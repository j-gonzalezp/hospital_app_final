// src/app/(main)/doctors/[doctorId]/page.tsx
import React from 'react';
import DoctorProfile from '@/components/doctors/DoctorProfile';
import { getDoctorById } from '@/lib/actions';
import { notFound } from 'next/navigation';
import ErrorMessage from '@/components/common/ErrorMessage';
import BookingSection from '@/components/appointment/BookingSection'; // --- Importa el componente ---

interface DoctorProfilePageProps {
  params: {
    doctorId: string;
  };
}

export default async function DoctorProfilePage({ params }: DoctorProfilePageProps) {
  const { doctorId } = params;
  let doctor = null;
  let error: string | null = null;

   try {
       doctor = await getDoctorById(doctorId);
   } catch (err: unknown) {
       console.error(`Error loading doctor profile for ${doctorId}:`, err);
       error = err instanceof Error ? err.message : "Failed to load doctor profile.";
  }

  if (!doctor && !error) {
    notFound();
  }

  return (
    <div>
      {error && <ErrorMessage message={error} className="my-6" />}

      {doctor && <DoctorProfile doctor={doctor} />}

      {/* --- Integra BookingSection aquí --- */}
      {doctor && (
        <div className='mt-10 pt-6 border-t'>
           {/* El componente se encarga del título interno y la lógica */}
           <BookingSection doctorId={doctor.$id} />
        </div>
      )}
      {/* --- Fin de la integración --- */}
    </div>
  );
}
