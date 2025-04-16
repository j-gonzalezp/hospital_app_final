// src/components/appointment/BookingForm.tsx
'use client';

import React, { useState, ChangeEvent } from 'react'; // Importa ChangeEvent
import Button from '@/components/common/Button';
import Select from '@/components/common/Select';
import Input from '@/components/common/Input';

interface BookingFormProps {
  doctors: { id: string; name: string }[]; // Ejemplo de tipo Doctor simplificado
  availableSlots: { id: string; startTime: string }[]; // Ejemplo de tipo Slot simplificado
  onBookingSubmit: (formData: { doctorId: string; availabilitySlotId: string; date: string; reason: string; }) => void;
  onDateChange: (doctorId: string, date: string) => void;
  onDoctorChange: (doctorId: string) => void;
}

const BookingForm: React.FC<BookingFormProps> = ({
  doctors,
  availableSlots,
  onBookingSubmit,
  onDateChange,
  onDoctorChange
}) => {
  const [selectedDoctor, setSelectedDoctor] = useState<string>('');
  const [selectedDate, setSelectedDate] = useState<string>('');
  const [selectedSlot, setSelectedSlot] = useState<string>('');
  const [reason, setReason] = useState<string>('');

  const handleDoctorChange = (e: ChangeEvent<HTMLSelectElement>) => { // Usa ChangeEvent
    const doctorId = e.target.value;
    setSelectedDoctor(doctorId);
    setSelectedDate('');
    setSelectedSlot('');
    onDoctorChange(doctorId);
  };

  const handleDateChange = (e: ChangeEvent<HTMLInputElement>) => { // Usa ChangeEvent
    const date = e.target.value;
    setSelectedDate(date);
    setSelectedSlot('');
    if (selectedDoctor && date) {
      onDateChange(selectedDoctor, date);
    }
  };

   const handleSlotChange = (e: ChangeEvent<HTMLSelectElement>) => { // Usa ChangeEvent
    setSelectedSlot(e.target.value);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedDoctor || !selectedSlot || !selectedDate) {
      alert('Please select a doctor, date, and time slot.');
      return;
    }
    onBookingSubmit({
      doctorId: selectedDoctor,
      availabilitySlotId: selectedSlot,
      date: selectedDate,
      reason,
    });
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 p-6 border rounded-lg shadow-sm">
      {/* --- AÑADE id AQUÍ --- */}
      <Select
        id="select-doctor" // ID único
        label="Select Doctor"
        value={selectedDoctor}
        onChange={handleDoctorChange}
        required
      >
        <option value="" disabled>-- Select a Doctor --</option>
        {doctors.map((doc) => (
          <option key={doc.id} value={doc.id}>{doc.name}</option>
        ))}
      </Select>

      {/* --- AÑADE id AQUÍ --- */}
      <Input
        id="select-date" // ID único
        label="Select Date"
        type="date"
        value={selectedDate}
        onChange={handleDateChange}
        required
        disabled={!selectedDoctor}
      />

      {/* --- AÑADE id AQUÍ --- */}
      <Select
        id="select-slot" // ID único
        label="Select Time Slot"
        value={selectedSlot}
        onChange={handleSlotChange}
        required
        disabled={!selectedDate || availableSlots.length === 0}
      >
        <option value="" disabled>-- Select a Time --</option>
        {availableSlots.map((slot) => (
          <option key={slot.id} value={slot.id}>
            {new Date(slot.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
          </option>
        ))}
         {selectedDate && availableSlots.length === 0 && <option disabled>No slots available for this date</option>}
      </Select>

      {/* --- AÑADE id AQUÍ --- */}
      <Input
        id="input-reason" // ID único
        label="Reason for Visit (Optional)"
        type="text"
        value={reason}
        onChange={(e) => setReason(e.target.value)}
        placeholder="Briefly describe the reason"
      />

      <Button type="submit" variant="primary">Book Appointment</Button>
    </form>
  );
};

export default BookingForm;
