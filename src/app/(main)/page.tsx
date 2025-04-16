// src/app/(main)/page.tsx
import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import Button from '@/components/common/Button';
import ServiceCard from '@/components/services/ServiceCard'; // Reutilizar
import DoctorFilter from '@/components/doctors/DoctorFilter'; // Reutilizar
import TestimonialCard from '@/components/testimonials/TestimonialCard'; // Importar componente
import { ArrowRight, Search, Stethoscope, MapPin } from 'lucide-react'; // Importar iconos usados
import ErrorMessage from '@/components/common/ErrorMessage'; // Para mostrar errores

// --- Importar Actions ---
import {
    getAllServices,
    getAllSpecialties,
    getAllLocations,
    getApprovedTestimonials, // Action para testimonios
    // getPublishedArticles, // Descomentar si añades sección de artículos
} from '@/lib/actions';

// --- Importar Tipos ---
import type { ServiceWithDetails } from '@/types/service.d.ts';
import type { SpecialtyDocument } from '@/types/specialty.d.ts';
import type { TestimonialDocument } from '@/types/testimonial.d.ts'; // Asegúrate que la ruta sea correcta
import type { LocationDocument } from '@/types/locations';

// --- Componente Hero Section (Definido aquí por simplicidad) ---
// --- Componente Hero Section (CORREGIDO - Fondo Claro Consistente) ---
const HeroSection = () => (
    // Fondo claro constante, borde inferior sutil
    <section className="relative bg-gradient-to-br from-white via-slate-50 to-blue-50 pt-20 pb-12 md:pt-28 md:pb-20 text-center lg:text-left overflow-hidden border-b border-[var(--border-primary)]">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
                {/* Columna de Texto */}
                <div className="max-w-xl mx-auto lg:mx-0">
                    <h1 className="!text-4xl sm:!text-5xl lg:!text-6xl font-bold text-[var(--text-primary)] leading-tight mb-4">
                        Your Health, <span className="text-[var(--text-accent)]">Our Priority</span>.
                    </h1>
                    <p className="text-lg md:text-xl text-[var(--text-secondary)] mb-8">
                        Experience compassionate care and medical excellence at Modern Hospital. Find expert doctors and book your appointments with ease.
                    </p>
                    {/* Links actualizados */}
                    <div className="flex flex-col sm:flex-row justify-center lg:justify-start space-y-3 sm:space-y-0 sm:space-x-4">
                        <Link href="/doctors" passHref>
                            <Button variant="primary" size="lg"><Search size={18} className='mr-2' /> Find a Doctor</Button>
                        </Link>
                        <Link href="/services" passHref>
                            {/* Botón fantasma con borde */}
                            <Button variant="ghost" size="lg" className='border border-slate-300 dark:border-slate-700 text-[var(--text-accent)] hover:bg-blue-50 dark:hover:bg-slate-800'><Stethoscope size={18} className='mr-2' /> Our Services</Button>
                        </Link>
                    </div>
                </div>
                {/* Columna de Imagen */}
                <div className="hidden lg:block relative h-80 w-full max-w-md mx-auto lg:max-w-none lg:h-96 xl:h-[500px]">
                    <Image
                        src="/images/hospital-hero-placeholder.jpg"
                        alt="Smiling doctor and patient"
                        fill
                        style={{ objectFit: 'cover' }}
                        className="rounded-lg shadow-lg"
                        priority
                        // --- AÑADE sizes AQUÍ ---
                        sizes="(max-width: 1024px) 90vw, 50vw" // Ejemplo: 90% ancho viewport en pantallas pequeñas/medianas, 50% en grandes
                    // --- FIN ---
                    />
                    {/* Elementos decorativos para fondo claro */}
                    <div className="absolute -bottom-4 -right-4 w-32 h-32 bg-blue-100 rounded-full opacity-50 blur-xl"></div>
                    <div className="absolute -top-4 -left-4 w-24 h-24 bg-cyan-100 rounded-full opacity-50 blur-lg"></div>
                </div>
            </div>
        </div>
    </section>
);
// --- Componente Principal de la Página ---
export default async function HomePage() {

    // --- Obtener Datos para las Secciones ---
    let featuredServices: ServiceWithDetails[] = [];
    let specialties: SpecialtyDocument[] = [];
    let featuredTestimonials: TestimonialDocument[] = [];
     let primaryLocation: LocationDocument | null = null;
     // Objeto para almacenar errores de cada carga de datos
     const errors: { [key: string]: string | null } = {
         services: null,
         specialties: null,
        testimonials: null,
        location: null,
    };

    // --- Ejecutar llamadas a actions en paralelo (más eficiente) ---
    // Usamos Promise.allSettled para que si una falla, las otras puedan continuar
    const results = await Promise.allSettled([
        getAllServices(),
        getAllSpecialties(),
        getApprovedTestimonials({ limit: 2 }), // Limita a 2 para la home
        getAllLocations(),
    ]);

    // Procesar resultados de Promise.allSettled
    if (results[0].status === 'fulfilled') {
        featuredServices = results[0].value.slice(0, 3); // Toma los primeros 3 servicios
    } else {
        errors.services = "Could not load services.";
        console.error("Error fetching services:", results[0].reason);
    }

    if (results[1].status === 'fulfilled') {
        specialties = results[1].value;
    } else {
        errors.specialties = "Could not load specialties.";
        console.error("Error fetching specialties:", results[1].reason);
    }

    if (results[2].status === 'fulfilled') {
        featuredTestimonials = results[2].value;
    } else {
        errors.testimonials = "Could not load testimonials.";
        console.error("Error fetching testimonials:", results[2].reason);
    }

    if (results[3].status === 'fulfilled') {
        primaryLocation = results[3].value.length > 0 ? results[3].value[0] : null;
    } else {
        errors.location = "Could not load location info.";
        console.error("Error fetching locations:", results[3].reason);
    }

    // --- Logs de Depuración (Revisar en consola del servidor) ---
    console.log("HomePage Data Check:");
    console.log("- featuredServices count:", featuredServices.length);
    console.log("- specialties count:", specialties.length);
    console.log("- featuredTestimonials count:", featuredTestimonials.length);
    // console.log("- featuredTestimonials data:", featuredTestimonials); // Descomentar si necesitas ver los datos
    console.log("- primaryLocation found:", !!primaryLocation);
    console.log("- errors:", errors);
    // --- Fin Logs ---

    return (
        <div>
            {/* 1. Hero Section */}
            <HeroSection />

            {/* Contenedor Principal */}
            <div className="container mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-16 space-y-16 md:space-y-24">

                {/* 2. Key Services Section */}
                <section>
                    <h2 className="text-3xl font-semibold font-serif text-center mb-8 md:mb-12">Our Key Services</h2>
                    {errors.services && <ErrorMessage message={errors.services} />}
                    {featuredServices.length > 0 ? (
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8">
                            {featuredServices.map(service => (
                                <ServiceCard key={service.$id} service={service} />
                            ))}
                        </div>
                    ) : (
                        !errors.services && <p className="text-center text-[var(--text-subtle)]">Services information is currently unavailable.</p>
                    )}
                    <div className="text-center mt-8">
                        <Link href="/services" passHref>
                            <Button variant="ghost">View All Services <ArrowRight size={16} className="ml-1 inline" /></Button>
                        </Link>
                    </div>
                </section>

                {/* 3. Find a Doctor Section */}
                <section className="bg-[var(--bg-secondary)] p-6 md:p-10 rounded-lg shadow">
                    <h2 className="text-3xl font-semibold font-serif text-center mb-8">Find Your Doctor</h2>
                    {errors.specialties && <ErrorMessage message={errors.specialties} />}
                    {/* Pasa las especialidades (incluso si está vacío, el componente debería manejarlo) */}
                    <DoctorFilter specialties={specialties} />
                    <p className="text-center text-sm text-[var(--text-subtle)] mt-4">
                        Or <Link href="/doctors">browse our full directory</Link>.
                    </p>
                </section>

                {/* 4. Testimonials Section */}
                {/* Muestra la sección solo si no hubo error Y hay testimonios */}
                {!errors.testimonials && featuredTestimonials.length > 0 && (
                    <section>
                        <h2 className="text-3xl font-semibold font-serif text-center mb-8 md:mb-12">What Our Patients Say</h2>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8 max-w-4xl mx-auto">
                            {featuredTestimonials.map(testimonial => (
                                <TestimonialCard key={testimonial.$id} testimonial={testimonial} />
                            ))}
                        </div>
                        {/* Opcional: Enlace a página de todos los testimonios */}
                        {/* <div className="text-center mt-8"> ... </div> */}
                    </section>
                )}
                {/* Muestra mensaje si hubo error o si no hay testimonios */}
                {errors.testimonials && (
                    <div className="text-center text-sm text-red-600">Could not load testimonials at this time.</div>
                )}
                {!errors.testimonials && featuredTestimonials.length === 0 && (
                    <p className='text-center text-sm text-gray-500 italic'>(No testimonials available to display)</p>
                )}


                {/* 5. Location Highlight */}
                {primaryLocation && !errors.location && ( // Muestra solo si hay ubicación y no hubo error
                    <section className='text-center'>
                        <h2 className="text-3xl font-semibold font-serif mb-4">Visit Us</h2>
                        <p className='flex items-center justify-center space-x-2 text-[var(--text-secondary)] mb-4'>
                            <MapPin size={18} /><span>{primaryLocation.address}</span>
                        </p>
                        <Link href="/locations" passHref>
                            <Button variant="secondary">View Locations & Hours</Button>
                        </Link>
                    </section>
                )}
                {errors.location && (
                    <div className="text-center text-sm text-red-600">Could not load location information.</div>
                )}


                {/* 6. Blog/News Snippet (Opcional - requeriría getPublishedArticles) */}

            </div>
        </div>
    );
}
