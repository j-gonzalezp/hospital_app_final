// src/app/(main)/doctors/page.tsx
import React from 'react';
import PageTitle from '@/components/common/PageTitle';
import DoctorFilter from '@/components/doctors/DoctorFilter';
import DoctorList from '@/components/doctors/DoctorList';
import { getAllSpecialties, getDoctors } from '@/lib/actions';
import ErrorMessage from '@/components/common/ErrorMessage';
// --- Importa los tipos necesarios ---
import type { SpecialtyDocument } from '@/types/specialty.d.ts';
import type { DoctorWithDetails } from '@/types/doctor.d.ts';
// --- Fin importación de tipos ---

interface FindDoctorPageProps {
  searchParams?: {
    name?: string;
    specialty?: string; // Este será el ID de la especialidad
  };
}

export default async function FindDoctorPage({ searchParams }: FindDoctorPageProps) {
  // --- Añade tipos explícitos aquí ---
  let specialties: SpecialtyDocument[] = [];
  let doctors: DoctorWithDetails[] = [];
  // --- Fin tipos explícitos ---
  let error: string | null = null;

  const filterName = searchParams?.name;
  const filterSpecialtyId = searchParams?.specialty;

  try {
    // Promise.all infiere correctamente los tipos de retorno aquí
    const [fetchedSpecialties, fetchedDoctors] = await Promise.all([
        getAllSpecialties(),
        getDoctors({
            name: filterName,
            specialtyId: filterSpecialtyId,
        })
    ]);

    // Asigna los resultados a las variables tipadas
    specialties = fetchedSpecialties;
    doctors = fetchedDoctors;

    if (specialties.length === 0) {
         console.warn("No specialties found. Check Appwrite collection data and permissions.");
     }

   } catch (err: unknown) {
       console.error("Error loading doctors page data:", err);
       error = err instanceof Error ? err.message : "Failed to load doctor information. Please try again later.";
       // Asegura que sigan siendo arrays vacíos tipados en caso de error
       specialties = [];
      doctors = [];
  }

  return (
    <div>
      <PageTitle title="Find Your Doctor" subtitle="Search by name or specialty" />

      {/* Pasa las especialidades tipadas al filtro */}
      <DoctorFilter specialties={specialties} />

      {/* Muestra error si ocurrió durante la carga */}
      {error && <ErrorMessage message={error} className="my-4" />}

      {/* Muestra la lista de doctores tipada si no hubo error */}
      {!error && <DoctorList doctors={doctors} isLoading={false} error={null} />}

       {/* Mensaje si no hay doctores y no hubo error general */}
       {!error && doctors.length === 0 && (
           <p className="text-center text-gray-600 py-10">
               No doctors found matching your current criteria.
           </p>
       )}
    </div>
  );
}
