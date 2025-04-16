// src/app/(main)/appointments/page.tsx
'use client'; // ¡Asegúrate que esta es la PRIMERA línea!

import React, { useEffect, useState, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import useAuth, { AuthState } from '@/hooks/useAuth'; // Importa tipo AuthState
import PageTitle from '@/components/common/PageTitle';
import AppointmentList from '@/components/appointment/AppointmentList';
import LoadingSpinner from '@/components/common/LoadingSpinner';
import ErrorMessage from '@/components/common/ErrorMessage';
import Button from '@/components/common/Button';
import Link from 'next/link';
import { getUserAppointments, cancelUserAppointment } from '@/lib/actions'; // Importa Server Actions
import type { AppointmentWithDetails } from '@/types/appointment.d.ts'; // Importa el tipo con 'type'
import CancelConfirmationModal from '@/components/appointment/CancelConfirmationModal';

// --- Asegúrate que la exportación sea exactamente así ---
export default function AppointmentsPage() {
  // --- Desestructura el estado de autenticación ---
  const { user, isLoading: isAuthLoading, error: authError }: AuthState = useAuth();
  const router = useRouter();

  // --- Estados del componente ---
  const [appointments, setAppointments] = useState<AppointmentWithDetails[]>([]);
  const [isLoadingData, setIsLoadingData] = useState<boolean>(true); // Indica explícitamente boolean
  const [dataError, setDataError] = useState<string | null>(null);
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [appointmentToCancel, setAppointmentToCancel] = useState<AppointmentWithDetails | null>(null);

  // --- Protección de Ruta ---
  useEffect(() => {
    // Espera a que la carga de autenticación termine
    if (!isAuthLoading) {
      // Si no hay usuario o hubo error de auth, redirige
      if (!user || authError) {
        if (authError) {
            console.error("Authentication error on page load:", authError);
        }
        console.log("User not authenticated or auth error, redirecting to login.");
        router.replace('/login?redirect=/appointments');
      }
      // Si hay usuario y no hay error, podemos proceder (o ya se están cargando los datos)
    }
  }, [user, isAuthLoading, authError, router]);
  // --- Fin Protección de Ruta ---


  // --- Carga de Datos de Citas ---
  const fetchAppointments = useCallback(async () => {
    // Solo intenta cargar si la autenticación terminó, hay usuario y no hubo error
    if (!isAuthLoading && user && !authError) {
        setIsLoadingData(true);
        setDataError(null);
        try {
            console.log(`Fetching appointments for user ${user.$id}...`); // Log útil
            const userAppointments = await getUserAppointments(user.$id);
            console.log(`Received ${userAppointments.length} appointments.`); // Log útil
            setAppointments(userAppointments);
        } catch (err: unknown) { // Captura y maneja el error de la action
            console.error("Error fetching appointments via action:", err);
            const message = err instanceof Error ? err.message : "Could not load your appointments.";
            setDataError(message);
        } finally {
            setIsLoadingData(false);
        }
    } else if (!isAuthLoading && (!user || authError)) {
        // Si no hay usuario o hay error de auth, detenemos la carga y esperamos la redirección
        setIsLoadingData(false);
    }
     // Si isAuthLoading es true, esperamos a que termine (el useEffect de protección se encargará)
  }, [user, isAuthLoading, authError]); // Dependencias correctas

  // Llama a fetchAppointments cuando el estado de autenticación esté listo y sea válido
  useEffect(() => {
      fetchAppointments();
  }, [fetchAppointments]);
  // --- Fin Carga de Datos ---


  // --- Lógica de Cancelación ---
  const openCancelModal = (appointment: AppointmentWithDetails) => {
      setAppointmentToCancel(appointment);
      setIsModalOpen(true);
  };

  const closeCancelModal = () => {
      setIsModalOpen(false);
      setAppointmentToCancel(null);
  };

  const handleConfirmCancel = async () => {
      if (!appointmentToCancel) return;

      // Puedes usar un estado de carga específico para la cancelación si quieres
      // setIsLoadingCancel(true);
      setDataError(null); // Limpia errores anteriores
      const cancellingAppointmentId = appointmentToCancel.$id; // Guarda ID por si appointmentToCancel se limpia antes

      closeCancelModal(); // Cierra el modal inmediatamente

      try {
          const result = await cancelUserAppointment(
              cancellingAppointmentId,
              appointmentToCancel.availabilitySlotId
          );

          if (result.success) {
              console.log("Appointment cancelled successfully via action");
              // Actualiza la UI: opción 1 - re-fetch
              // await fetchAppointments();
              // Opción 2 - actualizar estado local (más rápido)
              setAppointments(prev =>
                  prev.map(app =>
                      app.$id === cancellingAppointmentId
                          ? { ...app, status: 'cancelled' }
                          : app
                  )
              );
          } else {
                console.error("Cancellation action failed:", result.message);
                setDataError(result.message || "Failed to cancel appointment.");
           }
       } catch (error: unknown) {
            console.error("Error calling cancellation action:", error);
            const message = error instanceof Error ? error.message : "An unexpected error occurred during cancellation.";
            setDataError(message);
       } finally {
           // setIsLoadingCancel(false);
      }
  };
  // --- Fin Lógica de Cancelación ---


  // --- Renderizado Condicional ---

  // 1. Muestra spinner mientras se verifica la sesión de autenticación
  if (isAuthLoading) {
    return (
      <div className="flex justify-center items-center min-h-[400px]">
        <LoadingSpinner size="lg" />
        <p className="ml-4 text-gray-600">Verifying session...</p>
      </div>
    );
  }

  // 2. Si después de cargar no hay usuario o hubo error de auth, muestra mensaje de redirección
  //    (La redirección real ocurre en el useEffect de protección)
  if (!user || authError) {
     return (
        <div className="text-center py-10">
            <p className="text-red-600 mb-4">{authError ? `Authentication Error: ${authError}` : 'Not logged in. Redirecting...'}</p>
            <LoadingSpinner />
        </div>
     );
  }

  // 3. Si el usuario está autenticado, muestra el contenido de la página
  return (
    <div>
      {/* Título y Botón */}
      <div className="flex justify-between items-center mb-6 flex-wrap gap-4">
         <PageTitle title="My Appointments" className="mb-0" />
         <Link href="/doctors" passHref legacyBehavior>
             <a><Button variant="primary">Book New Appointment</Button></a>
         </Link>
      </div>

      {/* Muestra error de carga de datos si existe */}
      {dataError && <ErrorMessage message={dataError} className="mb-4"/>}

      {/* Muestra spinner de carga de datos O la lista de citas */}
      {isLoadingData ? (
        <div className="flex justify-center py-10">
            <LoadingSpinner />
            <p className="ml-4 text-gray-600">Loading appointments...</p>
        </div>
      ) : (
         <>
            <AppointmentList
                // Filtra aquí si quieres mostrar solo cierto tipo de citas por defecto
                appointments={appointments.filter(app => app.status === 'scheduled' || app.status === 'completed')}
                onCancelClick={openCancelModal}
            />
            {/* Mensaje si no hay citas (después de cargar y sin errores) */}
            {appointments.filter(app => app.status === 'scheduled' || app.status === 'completed').length === 0 && (
                <p className="text-center text-gray-600 py-10">You have no scheduled or completed appointments.</p>
            )}
         </>
      )}

       {/* Modal de Confirmación (fuera del flujo principal de renderizado) */}
        <CancelConfirmationModal
            isOpen={isModalOpen}
            onClose={closeCancelModal}
            onConfirm={handleConfirmCancel}
            // Asegúrate de que appointmentToCancel tenga los datos necesarios antes de pasarlos
            appointmentDetails={appointmentToCancel ? {
                doctorName: appointmentToCancel.doctorName || 'N/A',
                // Intenta usar slotStartTime si está disponible, si no, bookedAt como fallback
                date: appointmentToCancel.slotStartTime ? new Date(appointmentToCancel.slotStartTime).toLocaleDateString() : (appointmentToCancel.bookedAt ? new Date(appointmentToCancel.bookedAt).toLocaleDateString() : 'N/A'),
                time: appointmentToCancel.slotStartTime ? new Date(appointmentToCancel.slotStartTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : 'N/A',
            } : {}} // Objeto vacío si appointmentToCancel es null
        />
    </div>
  );
} // --- Fin del componente AppointmentsPage ---
