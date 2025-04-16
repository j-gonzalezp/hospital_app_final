
// src/components/doctors/DoctorFilter.tsx
'use client';

import React, { useState, useEffect, useCallback } from 'react';
import Select from '@/components/common/Select';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';
import { useRouter, useSearchParams } from 'next/navigation'; // Hooks de navegación
import type { SpecialtyDocument } from '@/types/specialty.d.ts'; // Importa tipo

interface DoctorFilterProps {
  specialties: SpecialtyDocument[];
}

const DoctorFilter: React.FC<DoctorFilterProps> = ({ specialties }) => {
  const router = useRouter();
  const searchParams = useSearchParams(); // Hook para leer parámetros actuales

  // Inicializa estado con valores de la URL actual
  const [doctorName, setDoctorName] = useState(searchParams.get('name') || '');
  const [selectedSpecialty, setSelectedSpecialty] = useState(searchParams.get('specialty') || '');

  // Actualiza la URL cuando se aplican filtros
  const handleApplyFilters = useCallback(() => {
      const current = new URLSearchParams(searchParams.toString()); // Crea un objeto mutable

      if (!doctorName) {
          current.delete('name');
      } else {
          current.set('name', doctorName);
      }

      if (!selectedSpecialty) {
          current.delete('specialty');
      } else {
          current.set('specialty', selectedSpecialty);
      }

      const search = current.toString();
      const query = search ? `?${search}` : '';

      // Navega a la misma página pero con los nuevos parámetros
      router.push(`/doctors${query}`);
  }, [searchParams, doctorName, selectedSpecialty, router]);


  // Función para limpiar filtros y URL
  const handleResetFilters = () => {
      setDoctorName('');
      setSelectedSpecialty('');
      router.push('/doctors'); // Navega a la URL base sin parámetros
  };

  // Opcional: Aplicar filtros automáticamente al escribir o seleccionar,
  // pero puede ser costoso. Un botón explícito es más controlado.
  // useEffect(() => { handleApplyFilters(); }, [doctorName, selectedSpecialty, handleApplyFilters]);

  return (
    <div className="p-4 bg-gray-50 border rounded-lg mb-6 shadow-sm">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
        <Input
          label="Doctor Name"
          id="doctor-name-filter"
          placeholder="Search by name..."
          value={doctorName}
          onChange={(e) => setDoctorName(e.target.value)}
          // Considera añadir un debounce si quieres buscar mientras se escribe
        />
        <Select
          label="Specialty"
          id="specialty-filter"
          value={selectedSpecialty}
          onChange={(e) => setSelectedSpecialty(e.target.value)}
        >
          <option value="">All Specialties</option>
          {/* Usa $id como value y name como texto */}
          {specialties.map((spec) => (
            <option key={spec.$id} value={spec.$id}>{spec.name}</option>
          ))}
        </Select>

         <div className="flex space-x-2 md:col-start-3 md:justify-self-end mt-4 md:mt-0">
             <Button onClick={handleApplyFilters} variant='primary'>Apply Filters</Button>
             <Button onClick={handleResetFilters} variant='secondary'>Reset</Button>
          </div>
      </div>
    </div>
  );
};

export default DoctorFilter;
