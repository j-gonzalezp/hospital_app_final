// src/app/(main)/services/[serviceId]/page.tsx
import React from 'react';
import ServiceDetail from '@/components/services/ServiceDetail'; // Necesitas crear/ajustar este componente
import { getServiceById } from '@/lib/actions'; // Asegúrate que esta acción exista y funcione
import { notFound } from 'next/navigation';
import ErrorMessage from '@/components/common/ErrorMessage';
// import Link from 'next/link'; // Descomenta si usas el botón de volver

interface ServiceDetailPageProps {
    // CORRECTED: params is now expected to be a Promise for async Page components
    params: Promise<{
        serviceId: string; // El nombre debe coincidir con el nombre de la carpeta [serviceId]
    }>;
    // Optional: If you were using searchParams, they would also need to be a Promise
    // searchParams?: Promise<{ [key: string]: string | string[] | undefined }>;
}

export default async function ServiceDetailPage({ params }: ServiceDetailPageProps) {
    // CORRECTED: Await the params promise before accessing its properties
    const { serviceId } = await params;
    let service = null;
    let error: string | null = null;

    if (!serviceId) {
        // This check might be redundant now as Next.js wouldn't call the page without a serviceId,
        // but it doesn't hurt to keep it for robustness.
        notFound(); // Si no hay ID, es 404
    }

    try {
        service = await getServiceById(serviceId);
    } catch (err: unknown) {
        console.error(`Error loading service detail for ${serviceId}:`, err);
        if (err instanceof Error) {
            error = err.message;
        } else {
            error = "Failed to load service details.";
        }
    }

    // Si la action devuelve null (porque no se encontró), muestra 404
    if (!service && !error) {
        notFound();
    }

    return (
        <div className="container mx-auto px-4 py-8"> {/* Añadido un poco de padding/contenedor */}
            {/* Muestra error si ocurrió */}
            {error && <ErrorMessage message={error} className="my-6" />}

            {/* Muestra el detalle del servicio si se encontró */}
            {service && <ServiceDetail service={service} />}

            {/* Puedes añadir un botón de "Volver a Servicios" o similar */}
             {/* <div className="mt-8">
                 <Link href="/services" className="text-blue-600 hover:underline">← Back to Services</Link>
             </div> */}
        </div>
    );
}

// Opcional: Generar rutas estáticas (si la lista de servicios no cambia muy a menudo)
// export async function generateStaticParams() {
//     try {
//         // Asegúrate de tener una acción para obtener todos los IDs de servicio
//         const services = await getAllServiceIds(); // Necesitarías crear esta acción
//         return services.map((service) => ({
//             serviceId: service.id, // O el campo que contenga el ID
//         }));
//     } catch (error) {
//         console.error("Failed to generate static params for services:", error);
//         return [];
//     }
// }

// Opcional: Generar metadatos dinámicos para SEO
// import { Metadata } from 'next';
// export async function generateMetadata({ params }: ServiceDetailPageProps): Promise<Metadata> {
//   // CORRECTED: Need to await params here too
//   const resolvedParams = await params;
//   const service = await getServiceById(resolvedParams.serviceId);

//   if (!service) {
//     return { title: 'Service Not Found' };
//   }

//   return {
//     title: service.name || 'Service Details', // Usa el nombre del servicio
//     description: service.shortDescription || `Details about our ${service.name} service.`, // Usa una descripción corta
//     // openGraph: { images: [service.imageUrl || '/default-service-image.png'] }
//   };
// }