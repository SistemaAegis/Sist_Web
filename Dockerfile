# -------------------- STAGE 1: BASE --------------------
# Usamos una imagen base ligera de Node.js
FROM node:20-alpine AS base

# -------------------- STAGE 2: DEPENDENCIES (Instalar) --------------------
FROM base AS deps
# Instalar dependencias del sistema para compatibilidad
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copiar archivos de lock/configuración
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./

# Instalar dependencias de manera condicional.
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci --legacy-peer-deps; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

# -------------------- STAGE 3: BUILDER (Compilar) --------------------
FROM base AS builder
WORKDIR /app
# Copiar node_modules instalados en la etapa 'deps'
COPY --from=deps /app/node_modules ./node_modules
# Copiar el código fuente restante
COPY . .

# Comando para compilar la aplicación Next.js
RUN npm run build 

# -------------------- STAGE 4: RUNNER (Producción Final) --------------------
# Imagen final, solo con lo necesario para ejecutar la aplicación
FROM base AS runner
WORKDIR /app

# Configurar un usuario no-root por motivos de seguridad
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
USER nextjs

ENV NODE_ENV production
# CRÍTICO: Eliminamos 'ENV PORT 3000' para que Next.js use la variable PORT inyectada por Render.

# Copiar Standalone Output 
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static 

EXPOSE 3000

# Comando para iniciar el servidor de producción de Next.js
CMD ["node", "server.js"]