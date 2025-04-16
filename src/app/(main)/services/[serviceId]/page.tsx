// src/app/(main)/services/[serviceId]/page.tsx
import React from 'react';
import ServiceDetail from '@/components/services/ServiceDetail'; // Necesitas crear/ajustar este componente
import { getServiceById } from '@/lib/actions';
import { notFound } from 'next/navigation';
import ErrorMessage from '@/components/common/ErrorMessage';

interface ServiceDetailPageProps {
    params: {
        serviceId: string; // El nombre debe coincidir con el nombre de la carpeta [serviceId]
    };
}

export default async function ServiceDetailPage({ params }: ServiceDetailPageProps) {
    const { serviceId } = params;
    let service = null;
    let error: string | null = null;

    if (!serviceId) {
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
        <div>
            {/* Muestra error si ocurrió */}
            {error && <ErrorMessage message={error} className="my-6" />}

            {/* Muestra el detalle del servicio si se encontró */}
            {service && <ServiceDetail service={service} />}

            {/* Puedes añadir un botón de "Volver a Servicios" o similar */}
             {/* <Link href="/services">Back to Services</Link> */}
        </div>
    );
}

// Opcional: Generar rutas estáticas (si la lista de servicios no cambia muy a menudo)
// export async function generateStaticParams() {
//     try {
//         const services = await getAllServices();
//         return services.map((service) => ({
//             serviceId: service.$id,
//         }));
//     } catch (error) {
//         console.error("Failed to generate static params for services:", error);
//         return [];
//     }
// }
