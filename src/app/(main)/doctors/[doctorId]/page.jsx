// src/app/(main)/doctors/[doctorId]/page.jsx
// VERSIÓN JAVASCRIPT - SIN TIPADO ESTRICTO

import React from 'react';
import DoctorProfile from '@/components/doctors/DoctorProfile';
import { getDoctorById } from '@/lib/actions'; // Asume que las actions siguen siendo TS o JS compatible
import { notFound } from 'next/navigation';
import ErrorMessage from '@/components/common/ErrorMessage';
import BookingSection from '@/components/appointment/BookingSection';
// No se necesita importar Metadata aquí si no se usa generateMetadata

// No se exporta un tipo 'Props' en JS

// La función ahora no tiene tipos explícitos
export default async function DoctorProfilePage({ params }) { // Sin tipo : DoctorProfilePageProps
  const { doctorId } = params; // Accede a doctorId
  let doctor = null;
  let error = null; // Inicializa como null

  if (!doctorId) {
    console.error("Doctor ID missing in params");
    notFound();
  }

  try {
    console.log(`Fetching doctor profile for ID: ${doctorId}`);
    doctor = await getDoctorById(doctorId);
  } catch (err) { // No se especifica tipo : unknown
    console.error(`Error loading doctor profile for ${doctorId}:`, err);
    // Accede a 'message' directamente, común en JS pero menos seguro que con 'unknown'
    error = err.message || "Failed to load doctor profile.";
    // Si 'err' no tiene 'message', será undefined, y el || funcionará
  }

  // Si getDoctorById devuelve null O hubo un error en el try/catch
  if (!doctor && !error) {
    // Solo llama a notFound si NO hubo un error explícito,
    // y el doctor es null (probablemente porque getDoctorById devolvió null)
    notFound();
  }

  return (
    <div>
      {/* Muestra el error si existe */}
      {error && <ErrorMessage message={error} className="my-6" />}

      {/* Muestra el perfil si el doctor se encontró Y no hubo error */}
      {doctor && !error && <DoctorProfile doctor={doctor} />}

      {/* Muestra la sección de reserva si el doctor se encontró Y no hubo error */}
      {doctor && !error && (
        <div className='mt-10 pt-6 border-t border-[var(--border-primary)]'>
           {/* Asume que BookingSection puede manejar doctor.$id */}
           <BookingSection doctorId={doctor.$id} />
        </div>
      )}
    </div>
  );
}

// generateMetadata y generateStaticParams (si los tenías) también perderían sus tipos
// export async function generateMetadata({ params }) { ... }
// export async function generateStaticParams() { ... }