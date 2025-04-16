// src/components/services/ServiceDetail.tsx
import React from 'react';
import Image from 'next/image';
import PageTitle from '@/components/common/PageTitle';
import type { ServiceWithDetails } from '@/types/service.d.ts'; // Importa el tipo correcto
import { Clock, DollarSign, Tag } from 'lucide-react'; // Iconos

interface ServiceDetailProps {
   service: ServiceWithDetails; // Usa el tipo con $id
}

const ServiceDetail: React.FC<ServiceDetailProps> = ({ service }) => {
  // Removed unused placeholderImage variable

  return (
    // El $id no se usa directamente aquí, pero el tipo es correcto
    <div className="max-w-4xl mx-auto p-4 md:p-8">
      <PageTitle title={service.name} className='mb-6' />

      {/* Imagen */}
      {service.imageDisplayUrl && (
        <div className="relative h-64 md:h-80 w-full rounded-lg overflow-hidden shadow-md mb-6 bg-gray-200">
          <Image
            src={service.imageDisplayUrl}
            alt={`Image for ${service.name}`}
            fill
             style={{ objectFit: 'cover' }}
            priority
          />
        </div>
      )}

      {/* Descripción */}
      <div className="prose prose-lg max-w-none text-[var(--text-secondary)] mb-6">
         <p>{service.description}</p>
      </div>

      {/* Detalles Adicionales */}
      <div className="bg-[var(--bg-secondary)] p-4 md:p-6 rounded-lg border border-[var(--border-primary)] space-y-3 text-sm mb-6">
         {service.specialtyName && (
             <div className='flex items-center space-x-2 text-[var(--text-primary)]'>
                <Tag size={16} className='text-[var(--text-subtle)]'/>
                <span><strong>Specialty:</strong> {service.specialtyName}</span>
             </div>
          )}
         {service.durationMinutes && (
             <div className='flex items-center space-x-2 text-[var(--text-primary)]'>
                 <Clock size={16} className='text-[var(--text-subtle)]'/>
                 <span><strong>Estimated Duration:</strong> {service.durationMinutes} minutes</span>
             </div>
          )}
         {service.costEstimate && (
             <div className='flex items-center space-x-2 text-[var(--text-primary)]'>
                <DollarSign size={16} className='text-[var(--text-subtle)]'/>
                <span><strong>Estimated Cost:</strong> {service.costEstimate}</span>
            </div>
         )}
         {/* Añade más detalles relevantes */}
      </div>

      {/* Otras secciones si son necesarias (Doctores, Preparación, etc.) */}

    </div>
  );
};

export default ServiceDetail;
