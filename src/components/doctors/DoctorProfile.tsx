
import React from 'react';
import Image from 'next/image';
import PageTitle from '@/components/common/PageTitle';
import Button from '@/components/common/Button';
import type { DoctorWithDetails } from '@/types/doctor.d.ts';
import { Languages, Briefcase, CheckCircle, CalendarPlus } from 'lucide-react';

interface DoctorProfileProps {
   doctor: DoctorWithDetails;
}

const DoctorProfile: React.FC<DoctorProfileProps> = ({ doctor }) => {
 const placeholderImage = '/images/doctor-placeholder.png';

  return (
    <div className="max-w-4xl mx-auto p-4 md:p-8">
      <div className="md:flex md:space-x-8">
        {/* Imagen y botón de reservar */}
        <div className="md:w-1/3 text-center mb-6 md:mb-0 flex flex-col items-center">
          {/* ... (Código de la imagen sin cambios) ... */}
          <div className="relative h-52 w-52 md:h-64 md:w-64 mx-auto rounded-full overflow-hidden border-4 border-gray-200 shadow-lg mb-4 bg-gray-300">
             {/* ... (Image component) ... */}
             <Image
               src={doctor.profilePictureUrl || placeholderImage}
               alt={`Dr. ${doctor.name}`}
               fill
               sizes="(max-width: 768px) 50vw, 33vw"
               style={{ objectFit: 'cover' }}
               priority
             />
          </div>
           {/* TODO: Enlazar este botón al flujo de reserva con este doctor preseleccionado */}
           {/* Por ahora, puede ser un link a la sección de reserva en esta misma página */}
           <a href="#book-appointment-section" className="w-full max-w-xs inline-block"> {/* Enlace en la misma página */}
              <Button variant="primary" size="lg" fullWidth> {/* fullWidth en lugar de className */}
                 <CalendarPlus size={18} className="mr-2"/> Book Appointment
              </Button>
           </a>
        </div>

        {/* Detalles del Doctor */}
        <div className="md:w-2/3">
          <PageTitle title={`Dr. ${doctor.name}`} subtitle={doctor.specialtyName || 'Specialty Unknown'} className='mb-4' />
          <div className="space-y-4 text-gray-700">
            <div className='flex items-center space-x-2 text-base'>
                <CheckCircle size={18} className='text-green-600 flex-shrink-0'/>
                <span><strong>Qualifications:</strong> {doctor.qualifications}</span>
            </div>
            {doctor.yearsExperience !== undefined && (
                <div className='flex items-center space-x-2 text-base'>
                    <Briefcase size={18} className='text-gray-500 flex-shrink-0'/>
                    <span><strong>Experience:</strong> {doctor.yearsExperience} years</span>
                </div>
            )}
            {doctor.languages && doctor.languages.length > 0 && (
                <div className='flex items-center space-x-2 text-base'>
                    <Languages size={18} className='text-gray-500 flex-shrink-0'/>
                    <span><strong>Languages:</strong> {doctor.languages.join(', ')}</span>
                </div>
            )}
             {doctor.bio && (
                <div className='mt-6'>
                 <h3 className="text-lg font-semibold mb-2 text-gray-800 border-b pb-1">About Dr. {doctor.name}</h3>
                 {/* Usar prose para un mejor formato si el bio tiene saltos de línea */}
                 <p className="text-base whitespace-pre-line prose max-w-none">{doctor.bio}</p>
               </div>
            )}
             {/* Añade más secciones si es necesario (ej. educación, publicaciones) */}
          </div>
        </div>
      </div>
      {/* La sección de reserva se añade en la página `[doctorId]/page.tsx` */}
    </div>
  );
};

export default DoctorProfile;