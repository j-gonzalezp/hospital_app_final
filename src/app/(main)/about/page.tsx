// src/app/(main)/about/page.tsx
import React from 'react';
import PageTitle from '@/components/common/PageTitle';
import Image from 'next/image'; // Para añadir imágenes si quieres

// Opcional: Puedes crear un componente reutilizable para secciones de contenido
// const ContentSection = ({ title, children }: { title?: string, children: React.ReactNode }) => (
//     <section className="mb-8 md:mb-12">
//         {title && <h2 className="text-2xl md:text-3xl font-semibold font-serif mb-4 text-[var(--text-primary)]">{title}</h2>}
//         <div className="prose prose-lg max-w-none text-[var(--text-secondary)]">
//             {children}
//         </div>
//     </section>
// );

export default function AboutPage() {
    return (
        <div>
            <PageTitle
                title="About Modern Hospital"
                subtitle="Dedicated to Your Health and Well-being Since [Year Founded]" // Reemplaza [Year Founded]
            />

            {/* Sección Principal */}
            <section className="mt-8 md:mt-12 grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
                {/* Imagen Opcional */}
                <div className="relative h-64 md:h-80 rounded-lg overflow-hidden shadow-md bg-gray-200 order-1 lg:order-2">
                    <Image
                        // Reemplaza con una imagen relevante (ej. fachada del hospital, equipo)
                        src="/images/hospital-about-placeholder.jpg" // Necesitas crear esta imagen
                        alt="Modern Hospital Facility or Team"
                        fill
                        style={{ objectFit: 'cover' }}
                        sizes="(max-width: 1024px) 100vw, 50vw"
                    />
                </div>

                {/* Texto Introductorio */}
                <div className="prose prose-lg max-w-none text-[var(--text-secondary)] order-2 lg:order-1">
                    <p>
                        Welcome to Modern Hospital, a leading healthcare provider committed to delivering
                        exceptional medical care with compassion and innovation. Since our founding in [Year Founded],
                        we have strived to create a healing environment where patients receive personalized attention
                        from a dedicated team of experts.
                    </p>
                    <p>
                        Our state-of-the-art facility is equipped with the latest medical technology,
                        allowing us to offer a wide range of services, from routine check-ups and diagnostics
                        to complex surgical procedures and specialized treatments.
                    </p>
                </div>
            </section>

            {/* Sección Misión y Visión (Ejemplo) */}
            <section className="mt-12 md:mt-16 py-8 bg-[var(--bg-secondary)] rounded-lg px-6">
                 <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                     <div>
                         <h2 className="text-2xl font-semibold font-serif mb-3 text-[var(--text-primary)]">Our Mission</h2>
                         <p className='text-base !mb-0'> {/* Forzamos tamaño base y sin margen inferior */}
                             To provide outstanding patient care, advance medical knowledge through research and education,
                             and improve the health of the communities we serve with integrity and respect.
                         </p>
                     </div>
                      <div>
                         <h2 className="text-2xl font-semibold font-serif mb-3 text-[var(--text-primary)]">Our Vision</h2>
                         <p className='text-base !mb-0'>
                             To be the most trusted healthcare partner, recognized for our clinical excellence,
                             innovative spirit, and unwavering commitment to patient-centered care.
                         </p>
                     </div>
                 </div>
            </section>

            {/* Sección Historia (Ejemplo) */}
            <section className="mt-12 md:mt-16">
                <h2 className="text-3xl font-semibold font-serif mb-6 text-center text-[var(--text-primary)]">Our Journey</h2>
                <div className="prose prose-lg max-w-3xl mx-auto text-[var(--text-secondary)]">
                    <p>
                        Modern Hospital began as a small community clinic with a big dream. Over the decades,
                        we have grown alongside our community, continuously expanding our services and facilities.
                        We embraced technological advancements. Today, we stand as a pillar of
                        health in the region, proud of our legacy and excited for the future of medicine.
                    </p>
                 
                </div>
            </section>

             {/* Opcional: Sección Equipo Destacado (Podrías obtener datos de doctores) */}
             {/* <section className="mt-12 md:mt-16">
                 <h2 className="text-3xl font-semibold font-serif mb-6 text-center text-[var(--text-primary)]">Meet Our Leaders</h2>
                 <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                     // Aquí podrías mapear sobre datos de doctores/líderes y usar DoctorCard
                     <p className='col-span-full text-center italic'>Leadership section placeholder</p>
                 </div>
             </section> */}

        </div>
    );
}
