// src/app/(main)/services/page.tsx
import React from 'react';
import PageTitle from '@/components/common/PageTitle';
import ServiceList from '@/components/services/ServiceList';
import { getAllServices } from '@/lib/actions';
import ErrorMessage from '@/components/common/ErrorMessage';
import type { ServiceWithDetails } from '@/types/service.d.ts';

export default async function ServicesPage() {
    let allServicesRaw: ServiceWithDetails[] = [];
    let error: string | null = null;
    let uniqueServices: ServiceWithDetails[] = []; // Array para guardar servicios únicos

    try {
        allServicesRaw = await getAllServices();

        // --- LÓGICA PARA ELIMINAR DUPLICADOS POR NOMBRE ---
        if (allServicesRaw.length > 0) {
            const seenNames = new Set<string>(); // Para rastrear nombres ya vistos
            uniqueServices = allServicesRaw.filter(service => {
                // Si el nombre no está vacío y no lo hemos visto antes...
                if (service.name && !seenNames.has(service.name)) {
                    seenNames.add(service.name); // Marcarlo como visto
                    return true; // Incluir este servicio (el primero con este nombre)
                }
                // Si el nombre está vacío o ya lo vimos, excluirlo
                return false;
            });
            console.log(`Filtered ${allServicesRaw.length} raw services down to ${uniqueServices.length} unique services by name.`);
        }
        // --- FIN LÓGICA DUPLICADOS ---

    } catch (err: unknown) {
        console.error("Error loading services page:", err);
        if (err instanceof Error) {
            error = err.message;
        } else {
            error = "An unknown error occurred while loading services.";
        }
        // uniqueServices ya está inicializado como []
    }

    return (
        <div>
            <PageTitle title="Our Services" subtitle="Comprehensive medical care for all your needs." />

            {error && <ErrorMessage message={error} className="my-4" />}

            {/* --- Pasa la lista de servicios ÚNICOS al componente --- */}
            {!error && <ServiceList services={uniqueServices} />}
            {/* --- Fin --- */}

            {/* Mensaje si no hay servicios únicos y no hubo error */}
            {!error && uniqueServices.length === 0 && (
                 <p className="text-center text-gray-600 py-10">
                    No services are currently listed or could be uniquely identified. Please check back later.
                 </p>
             )}
        </div>
    );
}
