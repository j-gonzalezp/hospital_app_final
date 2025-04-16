import React from 'react';
import ServiceCard from './ServiceCard';
import { ServiceDocument } from '@/types/service';

interface ServiceListProps {
  services: ServiceDocument[]; // Reemplaza con tipo Service[] o Specialty[]
}

const ServiceList: React.FC<ServiceListProps> = ({ services }) => {
   if (!services || services.length === 0) {
    return <p className="text-center text-gray-600 py-10">No services available at this time.</p>;
  }
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      {services.map((service) => (
        // Use $id for key based on Appwrite convention
        <ServiceCard key={service.$id} service={service} />
      ))}
    </div>
  );
};

export default ServiceList;
