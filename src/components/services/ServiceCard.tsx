// src/components/services/ServiceCard.tsx
import React from 'react';
import Image from 'next/image';
import Link from 'next/link';
// --- Asegúrate de importar el tipo correcto ---
import type { ServiceWithDetails } from '@/types/service.d.ts';

// --- Usa el tipo importado directamente ---
interface ServiceCardProps {
  service: ServiceWithDetails;
}
// --- FIN ---

const ServiceCard: React.FC<ServiceCardProps> = ({ service }) => {
  const placeholderImage = '/images/service-placeholder.png'; // Asegúrate que exista
  const serviceUrl = `/services/${service.$id}`; // Usa $id

  return (
    <Link href={serviceUrl} className="block group">
      <div className="border rounded-lg overflow-hidden shadow-sm bg-white h-full flex flex-col transition-shadow duration-200 group-hover:shadow-lg">
        <div className="relative h-40 w-full bg-gray-200">
          <Image
            src={service.imageDisplayUrl || placeholderImage} // Usa la URL procesada
            alt={`Image for ${service.name}`}
            fill
            sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
            style={{ objectFit: 'cover' }}
          />
        </div>
        <div className="p-4 flex-grow">
          <h3 className="text-lg font-semibold mb-2 group-hover:text-blue-600 transition-colors">{service.name}</h3>
          <p className="text-sm text-gray-600 line-clamp-3">{service.description}</p>
        </div>
        <div className="p-4 pt-0 text-sm text-blue-600 font-medium group-hover:underline">
            Learn More →
        </div>
      </div>
    </Link>
  );
};

export default ServiceCard;