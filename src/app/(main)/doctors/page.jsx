// src/app/(main)/doctors/page.jsx
// VERSIÓN JAVASCRIPT - SIN TIPADO ESTRICTO

import React from 'react';
import PageTitle from '@/components/common/PageTitle';
import DoctorFilter from '@/components/doctors/DoctorFilter';
import DoctorList from '@/components/doctors/DoctorList';
import { getAllSpecialties, getDoctors } from '@/lib/actions'; // Asume compatibilidad JS/TS
import ErrorMessage from '@/components/common/ErrorMessage';
// No se importan tipos como SpecialtyDocument o DoctorWithDetails

// No se define ni exporta FindDoctorPageProps

export default async function FindDoctorPage({ searchParams }) { // Sin tipo : FindDoctorPageProps
  // Inicializa con arrays vacíos
  let specialties = [];
  let doctors = [];
  let error = null; // Inicializa como null

  // Accede a searchParams directamente (común en JS)
  const filterName = searchParams?.name;
  const filterSpecialtyId = searchParams?.specialty;

  try {
    // Promise.all sigue funcionando igual
    const [fetchedSpecialties, fetchedDoctors] = await Promise.all([
        getAllSpecialties(),
        getDoctors({
            name: filterName,
            specialtyId: filterSpecialtyId,
        })
    ]);

    // Asigna los resultados
    specialties = fetchedSpecialties;
    doctors = fetchedDoctors;

    if (specialties.length === 0) {
         console.warn("No specialties found. Check Appwrite collection data and permissions.");
     }

   } catch (err) { // Sin tipo : unknown
       console.error("Error loading doctors page data:", err);
       // Accede a 'message' directamente
       error = err.message || "Failed to load doctor information. Please try again later.";
       // Asegura que sigan siendo arrays vacíos en caso de error
       specialties = [];
       doctors = [];
  }

  return (
    <div>
      <PageTitle title="Find Your Doctor" subtitle="Search by name or specialty" />

      {/* Pasa las especialidades (sin tipo explícito) al filtro */}
      <DoctorFilter specialties={specialties} />

      {/* Muestra error si ocurrió */}
      {error && <ErrorMessage message={error} className="my-4" />}

      {/* Muestra la lista de doctores si no hubo error */}
      {/* DoctorList ahora recibe un array potencialmente sin tipo estricto */}
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