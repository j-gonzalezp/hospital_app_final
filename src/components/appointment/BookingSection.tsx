// src/components/appointment/BookingSection.tsx
'use client';

import React, { useState, useEffect, useTransition, useCallback } from 'react';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';
import LoadingSpinner from '@/components/common/LoadingSpinner';
import ErrorMessage from '@/components/common/ErrorMessage';
import SlotSelector from './SlotSelector'; // Reutilizamos el componente de slots
import { getAvailableSlots, createAppointment } from '@/lib/actions'; // Importa ambas actions
import useAuth from '@/hooks/useAuth'; // Para obtener el ID del usuario
import type { AvailabilitySlotDocument } from '@/types/availability.d.ts'; // Importa el tipo de slot
import type { AppointmentDocument } from '@/types/appointment.d.ts'; // Importa el tipo de cita
import Alert from '../common/Alert'; // Para mensaje de éxito
import Link from 'next/link'; // Para el enlace de login/register

interface BookingSectionProps {
    doctorId: string;
    onBookingSuccess?: (appointmentDetails: AppointmentDocument) => void; // Usa el tipo específico
}

const BookingSection: React.FC<BookingSectionProps> = ({ doctorId, onBookingSuccess }) => {
    const { user, isLoading: isAuthLoading } = useAuth(); // Obtiene usuario y estado de carga auth
    const today = new Date().toISOString().split('T')[0]; // Fecha de hoy para min date

    // Estados del componente
    const [selectedDate, setSelectedDate] = useState<string>(today);
    const [availableSlots, setAvailableSlots] = useState<AvailabilitySlotDocument[]>([]);
    const [selectedSlot, setSelectedSlot] = useState<AvailabilitySlotDocument | null>(null);
    const [reason, setReason] = useState<string>('');
    const [error, setError] = useState<string | null>(null);
    const [successMessage, setSuccessMessage] = useState<string | null>(null);
    const [isLoadingSlots, setIsLoadingSlots] = useState<boolean>(false);
    const [isBooking, setIsBooking] = useState<boolean>(false); // Estado específico para el proceso de reserva
    const [isPending] = useTransition(); // Para carga no bloqueante de slots (startTransition removed as unused)

    // Función para cargar slots (envuelta en useCallback)
    const loadSlots = useCallback(async (date: string) => {
        if (!date || !doctorId) return;
        setError(null); // Limpia errores previos
        setIsLoadingSlots(true); // Empieza carga
        setSelectedSlot(null); // Deselecciona slot
        setAvailableSlots([]); // Limpia slots
        setSuccessMessage(null); // Limpia éxito previo

        try {
            const slots = await getAvailableSlots(doctorId, date);
            setAvailableSlots(slots);
        } catch (err: unknown) { // Use unknown for better type safety
            console.error("Error loading slots:", err);
            const errorMessage = err instanceof Error ? err.message : "Could not load available slots for this date.";
            setError(errorMessage);
        } finally {
             setIsLoadingSlots(false); // Termina carga
        }
    }, [doctorId]); // Depende solo de doctorId para definir la función

    // Efecto para cargar slots iniciales o cuando cambia la fecha seleccionada
    useEffect(() => {
        // Solo carga si tenemos el doctorId
        if (doctorId) {
             loadSlots(selectedDate);
        }
    }, [doctorId, selectedDate, loadSlots]); // Recarga si cambia doctorId o selectedDate

    // Manejador para el cambio de fecha
    const handleDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const newDate = e.target.value;
        setSelectedDate(newDate);
        // La carga se disparará por el useEffect de arriba
        // Opcional: usar startTransition si quieres que la carga sea menos bloqueante visualmente
        // startTransition(() => {
        //     loadSlots(newDate);
        // });
    };

    // Manejador para la selección de slot
    const handleSlotSelect = (slotId: string) => {
        const slot = availableSlots.find(s => s.$id === slotId);
        setSelectedSlot(slot || null);
        setError(null); // Limpia error al seleccionar slot
        setSuccessMessage(null); // Limpia éxito si se selecciona otro slot
    };

    // Manejador para el envío de la reserva
    const handleBookingSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setError(null);
        setSuccessMessage(null);

        if (!selectedSlot) {
            setError("Please select an available time slot.");
            return;
        }
        // Verifica autenticación
        if (isAuthLoading || !user) {
             setError("You must be logged in to book an appointment.");
             return;
        }

        setIsBooking(true); // Inicia spinner de reserva

        try {
            // Llama a la Server Action 'createAppointment'
            const result = await createAppointment({
                patientId: user.$id,
                doctorId: doctorId,
                availabilitySlotId: selectedSlot.$id,
                reason: reason.trim(),
            });

            if (result.success && result.appointment) {
                console.log("Booking successful:", result.appointment);
                setSuccessMessage("Appointment booked successfully!");
                setSelectedSlot(null); // Limpia selección
                setReason(''); // Limpia razón
                // Quita el slot reservado de la lista local
                setAvailableSlots(prev => prev.filter(s => s.$id !== selectedSlot.$id));
                // Llama al callback si existe
                if (onBookingSuccess) onBookingSuccess(result.appointment);
            } else {
                // Reserva fallida (ej: slot ocupado, error de permisos)
                console.error("Booking failed:", result.message);
                setError(result.message || "Failed to book appointment. The slot might have been taken.");
                // Recargar slots es crucial si falla porque el slot fue tomado
                loadSlots(selectedDate);
            }
        } catch (bookingError: unknown) { // Use unknown for better type safety
            // Error inesperado al llamar/ejecutar la action
            console.error("Error calling createAppointment action:", bookingError);
            const errorMessage = bookingError instanceof Error ? bookingError.message : "An unexpected error occurred while booking.";
            setError(errorMessage);
            // Recargar slots también puede ser útil aquí
            loadSlots(selectedDate);
        } finally {
            setIsBooking(false); // Termina spinner de reserva
        }
    };

    // --- Renderizado ---
    return (
        <div id="book-appointment-section" className="p-4 md:p-6 border rounded-lg shadow-sm bg-[var(--bg-secondary)] dark:bg-slate-800">
            <h4 className="text-xl font-semibold mb-4 text-[var(--text-primary)]">Schedule Your Visit</h4>

            {/* Selector de Fecha */}
            <div className="mb-4">
                <Input
                    label="Select Date"
                    type="date"
                    id={`booking-date-${doctorId}`}
                    value={selectedDate}
                    onChange={handleDateChange}
                    min={today} // No permitir fechas pasadas
                    required
                    // Deshabilita durante cargas o si no hay usuario
                    disabled={isAuthLoading || isLoadingSlots || isPending || isBooking || !user}
                    className="bg-white dark:bg-slate-700" // Fondo explícito para inputs
                />
            </div>

            {/* Mensajes de Error o Éxito */}
            {error && <ErrorMessage message={error} className="mb-4" />}
            {successMessage && <Alert message={successMessage} type="success" className="mb-4" />}

            {/* Indicador de carga de slots */}
            {(isLoadingSlots || isPending) && (
                 <div className="flex items-center justify-center my-4 text-[var(--text-subtle)]">
                    <LoadingSpinner size="sm" />
                    <span className="ml-2">Loading available times...</span>
                </div>
            )}

            {/* Selector de Slots (si no carga y hay usuario) */}
            {!isAuthLoading && user && !isLoadingSlots && !isPending && (
                <div className="mb-4">
                     <SlotSelector
                        slots={availableSlots.map(slot => ({
                             id: slot.$id,
                             time: new Date(slot.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
                             status: slot.status
                        }))}
                        selectedSlot={selectedSlot?.$id || null}
                        onSlotSelect={handleSlotSelect}
                    />
                     {/* Mensaje si no hay slots (después de cargar y sin error/éxito) */}
                    {availableSlots.length === 0 && !error && !successMessage && (
                         <p className='text-sm text-gray-500 dark:text-slate-400 mt-2'>No available appointments for this date. Please try another day.</p>
                    )}
                </div>
            )}

             {/* Mensaje para iniciar sesión (si no hay usuario y auth terminó) */}
             {!isAuthLoading && !user && (
                  <p className='text-sm text-center text-orange-700 dark:text-orange-300 bg-orange-50 dark:bg-orange-900/30 p-3 rounded border border-orange-200 dark:border-orange-800'>
                      Please <Link href={`/login?redirect=/doctors/${doctorId}`} className='font-semibold underline'>log in</Link> or <Link href={`/register?redirect=/doctors/${doctorId}`} className='font-semibold underline'>register</Link> to book an appointment.
                  </p>
             )}


            {/* Formulario de Reserva (si hay slot seleccionado, usuario y no hubo éxito reciente) */}
            {selectedSlot && user && !successMessage && (
                 <form onSubmit={handleBookingSubmit} className="mt-4 pt-4 border-t border-[var(--border-primary)]">
                     <p className='text-sm text-[var(--text-secondary)] mb-3'>
                        Confirming appointment for: <strong>{new Date(selectedSlot.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</strong> on {selectedDate}.
                    </p>
                     <div className="mb-4">
                         <Input
                             label="Reason for Visit (Optional)"
                             type="text"
                             id={`booking-reason-${doctorId}`}
                             value={reason}
                             onChange={(e) => setReason(e.target.value)}
                             placeholder="Briefly describe the reason"
                             maxLength={200}
                             disabled={isBooking}
                             className="bg-white dark:bg-slate-700" // Fondo explícito
                         />
                     </div>
                     <Button type="submit" variant="primary" fullWidth disabled={isBooking || !selectedSlot}>
                         {isBooking ? <LoadingSpinner size="sm" /> : 'Confirm Booking'}
                     </Button>
                 </form>
            )}

            {/* Mensaje y botón para volver a reservar después de éxito */}
            {successMessage && user && (
                <div className="mt-4 pt-4 border-t border-[var(--border-primary)] text-center">
                    {/* El Alert ya muestra el mensaje de éxito */}
                    <Button variant="secondary" onClick={() => {
                        setSuccessMessage(null); // Limpia mensaje
                        loadSlots(selectedDate); // Recarga slots
                    }}>Book Another Slot</Button>
                </div>
            )}
        </div>
    );
};

export default BookingSection;
