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

# Instalar dependencias
# Asumo que estás usando 'npm' ya que tienes 'package-lock.json' y 'npm run build'
RUN npm ci --legacy-peer-deps

# -------------------- STAGE 3: BUILDER (Compilar) --------------------
FROM base AS builder
WORKDIR /app
# Copiar node_modules instalados en la etapa 'deps'
COPY --from=deps /app/node_modules ./node_modules
# Copiar el código fuente restante
COPY . .

# Compilar la aplicación Next.js
# Esto crea la carpeta .next/ (que contiene la salida compilada)
RUN npm run build 

# -------------------- STAGE 4: RUNNER (Producción Final) --------------------
# Imagen final, más ligera y segura
FROM node:20-alpine AS runner
WORKDIR /app

# Configurar un usuario no-root por motivos de seguridad
# (Esto es una buena práctica y no interfiere con Render)
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
USER nextjs

ENV NODE_ENV production
# CRÍTICO: No especificamos el puerto para que Render inyecte la variable PORT

# 🎯 Copiar archivos necesarios para el RUNNER (Modo sin Standalone)
# Copiamos la carpeta de build (.next) y el código fuente esencial:
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json 
# Necesitamos el resto del código fuente para que Next.js funcione correctamente en el servidor
COPY --from=builder --chown=nextjs:nodejs /app/app ./app
COPY --from=builder --chown=nextjs:nodejs /app/components ./components
COPY --from=builder --chown=nextjs:nodejs /app/hooks ./hooks
COPY --from=builder --chown=nextjs:nodejs /app/lib ./lib
COPY --from=builder --chown=nextjs:nodejs /app/services ./services
COPY --from=builder --chown=nextjs:nodejs /app/types ./types
COPY --from=builder --chown=nextjs:nodejs /app/utils ./utils
COPY --from=builder --chown=nextjs:nodejs /app/next.config.mjs ./next.config.mjs
# Puedes copiar cualquier otro archivo de configuración esencial (como postcss, tailwind, etc.)

EXPOSE 3000

# 🚀 Comando de inicio: Usamos 'npm start' que Next.js mapea a 'next start'.
# Next.js por defecto usará la variable de entorno PORT si está disponible.
CMD ["npm", "start"]