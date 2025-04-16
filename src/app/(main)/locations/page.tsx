// src/app/(main)/locations/page.tsx
import React from 'react';
import PageTitle from '@/components/common/PageTitle';
import ErrorMessage from '@/components/common/ErrorMessage';
import LocationCard from '@/components/locations/LocationCard'; // Importa el nuevo componente
import { getAllLocations } from '@/lib/actions'; // Importa la action
import type { LocationDocument } from '@/types/locations';

export default async function LocationsPage() {
    let locations: LocationDocument[] = [];
    let error: string | null = null;

     try {
         locations = await getAllLocations();
     } catch (err: unknown) {
         console.error("Error loading locations page:", err);
         error = err instanceof Error ? err.message : "Failed to load locations. Please try again later.";
        locations = []; // Asegura array vacío en caso de error
    }

    return (
        <div>
            <PageTitle title="Our Locations" subtitle="Find a hospital facility near you." />

            {error && <ErrorMessage message={error} className="my-4" />}

            {/* Grid para mostrar las tarjetas de ubicación */}
            {!error && locations.length > 0 && (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6">
                    {locations.map((location) => (
                        <LocationCard key={location.$id} location={location} />
                    ))}
                </div>
            )}

            {/* Mensaje si no hay ubicaciones y no hubo error */}
            {!error && locations.length === 0 && (
                 <p className="text-center text-gray-600 py-10">
                    No locations are currently listed. Please check back later.
                 </p>
             )}
        </div>
    );
}
