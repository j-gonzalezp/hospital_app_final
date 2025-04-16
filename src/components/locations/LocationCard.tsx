// src/components/locations/LocationCard.tsx
import React from 'react';
import type { LocationDocument } from '@/types/locations';
import { MapPin, Phone, Clock, ExternalLink } from 'lucide-react'; // Iconos

interface LocationCardProps {
    location: LocationDocument;
}

const LocationCard: React.FC<LocationCardProps> = ({ location }) => {
    return (
        <div className="border rounded-lg shadow-sm overflow-hidden bg-white p-5 flex flex-col h-full">
            <h3 className="text-xl font-semibold mb-3 text-gray-800">{location.name}</h3>

            <div className="space-y-2 text-sm text-gray-600 mb-4 flex-grow">
                {location.address && (
                    <div className="flex items-start space-x-2">
                        <MapPin size={16} className="text-gray-400 mt-0.5 flex-shrink-0" />
                        <span>{location.address}</span>
                    </div>
                )}
                {location.phoneNumber && (
                    <div className="flex items-center space-x-2">
                        <Phone size={16} className="text-gray-400 flex-shrink-0" />
                        <a href={`tel:${location.phoneNumber}`} className="hover:text-blue-600 hover:underline">
                            {location.phoneNumber}
                        </a>
                    </div>
                )}
                 {location.operatingHours && (
                    <div className="flex items-start space-x-2">
                        <Clock size={16} className="text-gray-400 mt-0.5 flex-shrink-0" />
                        {/* Usar whitespace-pre-line para respetar saltos de línea si los hubiera */}
                        <span className='whitespace-pre-line'>{location.operatingHours}</span>
                    </div>
                )}
            </div>

            {/* Botón para ver en mapa si hay URL */}
            {location.mapUrl && (
                <div className="mt-auto pt-3 border-t border-gray-100">
                    <a
                        href={location.mapUrl}
                        target="_blank" // Abre en nueva pestaña
                        rel="noopener noreferrer" // Seguridad
                        className="inline-flex items-center justify-center w-full px-4 py-2 border border-transparent text-sm font-medium rounded-md text-blue-700 bg-blue-100 hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
                    >
                        <ExternalLink size={16} className="mr-2"/>
                        View on Map
                    </a>
                </div>
            )}
            {/* Opcional: Podrías mostrar un mapa embebido si tienes lat/lon usando librerías como react-leaflet o google-maps-react */}
             {/* {location.latitude && location.longitude && (
                <div className="mt-4 h-40 bg-gray-200 rounded">Map Placeholder</div>
             )} */}
        </div>
    );
};

export default LocationCard;