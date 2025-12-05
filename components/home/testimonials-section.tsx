export function TestimonialsSection() {
  const testimonials = [
    {
      company: "Acme Corp",
      sector: "Sector Tecnológico",
      initials: "AC",
      testimonial:
        "El sistema de distribución ha mejorado significativamente nuestra gestión de inventario de oficina.",
    },
    {
      company: "Univalle",
      sector: "Sector Financiero",
      initials: "GI",
      testimonial: "Hemos reducido costos y optimizado nuestros procesos de compra de material de oficina.",
    },
    {
      company: "Tech Solutions",
      sector: "Sector Consultoría",
      initials: "TS",
      testimonial: "La plataforma digital es intuitiva y nos permite realizar pedidos de forma rápida y eficiente.",
    },
    {
      company: "Mega Enterprises",
      sector: "Sector Retail",
      initials: "ME",
      testimonial:
        "El servicio de distribución es puntual y el soporte técnico siempre está disponible para ayudarnos.",
    },
  ]

  return (
    <section className="py-16 bg-gray-50">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8 space-y-6">
        <div className="text-center space-y-2 max-w-2xl mx-auto">
          <h2 className="text-3xl font-bold">Nuestros Clientes</h2>
          <p className="text-gray-600">
            Empresas que confían en nuestro sistema de distribución de material de escritorio.
          </p>
        </div>

        <div className="grid md:grid-cols-4 gap-6 pt-8">
          {testimonials.map((testimonial, index) => (
            <div key={index} className="bg-white p-6 rounded-lg shadow-sm">
              <div className="flex items-center gap-4 mb-4">
                <div className="bg-gray-100 rounded-full w-12 h-12 flex items-center justify-center">
                  <span className="font-medium text-blue-600">{testimonial.initials}</span>
                </div>
                <div>
                  <h4 className="font-medium">{testimonial.company}</h4>
                  <p className="text-sm text-gray-600">{testimonial.sector}</p>
                </div>
              </div>
              <p className="text-sm text-gray-600">"{testimonial.testimonial}"</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}
