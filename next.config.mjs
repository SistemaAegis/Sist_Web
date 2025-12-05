/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuración de ignorar errores, mantenida.
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  // Configuración de imágenes, mantenida.
  images: {
    unoptimized: true,
  },
  // CRÍTICO: ELIMINAR O COMENTAR la línea 'output: "standalone"',
  // ya que no estás utilizando esa estructura de despliegue.
  // output: "standalone", 
}

export default nextConfig