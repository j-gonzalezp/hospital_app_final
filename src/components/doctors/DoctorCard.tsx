// src/components/doctors/DoctorCard.tsx
import React from 'react';
import Image from 'next/image';
import Link from 'next/link';
import Button from '@/components/common/Button';
import type { DoctorWithDetails } from '@/types/doctor.d.ts'; // Importa el tipo correcto

interface DoctorCardProps {
  doctor: DoctorWithDetails; // Usa el tipo con detalles
}

const DoctorCard: React.FC<DoctorCardProps> = ({ doctor }) => {
  const placeholderImage = '/images/doctor-placeholder.png'; // Asegúrate que esta imagen exista en public/images

  return (
    <div className="border rounded-lg overflow-hidden shadow-md bg-white flex flex-col h-full transition-shadow hover:shadow-lg">
      <div className="relative h-48 w-full bg-gray-200"> {/* Fondo por si la imagen falla */}
        <Image
          // Usa profilePictureUrl si existe, si no, el placeholder
          src={doctor.profilePictureUrl || placeholderImage}
          alt={`Profile picture of Dr. ${doctor.name}`}
          fill // Reemplaza layout="fill"
          sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw" // Ayuda a Next/Image a elegir el tamaño correcto
          style={{ objectFit: 'cover' }} // Reemplaza objectFit
          // Opcional: Añadir un event handler onError para mostrar el placeholder si la URL real falla
          // onError={(e) => { e.currentTarget.src = placeholderImage; }}
        />
      </div>
      <div className="p-4 flex flex-col flex-grow">
        <h3 className="text-xl font-semibold mb-1 text-gray-800">Dr. {doctor.name}</h3>
        {/* Muestra el nombre de la especialidad */}
        <p className="text-blue-600 mb-2 text-sm">{doctor.specialtyName || 'Specialty details unavailable'}</p>
        {/* Muestra calificaciones */}
        {doctor.qualifications && <p className="text-sm text-gray-600 mb-4 line-clamp-2">{doctor.qualifications}</p>}
         <div className="mt-auto"> {/* Empuja el botón hacia abajo */}
           {/* Enlaza usando el $id del doctor */}
           <Link href={`/doctors/${doctor.$id}`} passHref legacyBehavior>
              <a className='block'>
                  <Button variant="secondary" size="sm" fullWidth>View Profile</Button>
               </a>
            </Link>
         </div>
      </div>
    </div>
  );
};

export default DoctorCard;