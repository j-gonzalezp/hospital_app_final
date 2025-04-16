// src/app/(main)/contact/page.tsx
import React from 'react';
import PageTitle from '@/components/common/PageTitle';
import ErrorMessage from '@/components/common/ErrorMessage';
import ContactForm from '@/components/contact/ContactForm'; // Importa el formulario
import { getAllLocations } from '@/lib/actions'; // Obtén ubicaciones si quieres mostrarlas
import { Mail, Phone, MapPin } from 'lucide-react'; // Iconos

export default async function ContactPage() {
    // Opcional: Obtener ubicaciones para mostrar
    let primaryLocation = null; // O un array si quieres mostrar varias
    let locationError: string | null = null;
    try {
        const locations = await getAllLocations();
        // Asume que quieres mostrar la primera ubicación como contacto principal
         if (locations.length > 0) {
              primaryLocation = locations[0];
         }
     } catch (err: unknown) {
         console.error("Error loading locations for contact page:", err);
         locationError = err instanceof Error ? err.message : "Could not load location details.";
    }

    return (
        <div>
            <PageTitle title="Contact Us" subtitle="We're here to help. Reach out to us anytime." />

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-10 md:gap-16 mt-8 md:mt-12">

                {/* Columna Izquierda: Información de Contacto */}
                <div className="space-y-6">
                    <h2 className='text-2xl font-semibold font-serif text-[var(--text-primary)]'>Get in Touch</h2>
                     <p className='text-base text-[var(--text-secondary)]'>
                        Have questions or need assistance? Use the form or contact us directly through the channels below.
                    </p>

                    {/* Información de Contacto Directo */}
                    <div className='space-y-4 pt-4 border-t border-[var(--border-primary)]'>
                        <div className="flex items-center space-x-3">
                            <Mail size={20} className="text-[var(--text-accent)] flex-shrink-0"/>
                            <div>
                                <h3 className='font-medium text-[var(--text-secondary)]'>Email Us</h3>
                                <a href="mailto:info@modernhospital.com" className='text-base'>info@modernhospital.com</a>
                            </div>
                        </div>
                         <div className="flex items-center space-x-3">
                            <Phone size={20} className="text-[var(--text-accent)] flex-shrink-0"/>
                             <div>
                                <h3 className='font-medium text-[var(--text-secondary)]'>Call Us</h3>
                                <a href="tel:+15551234567" className='text-base'>(555) 123-4567</a>
                            </div>
                        </div>
                        {primaryLocation && (
                             <div className="flex items-start space-x-3">
                                <MapPin size={20} className="text-[var(--text-accent)] flex-shrink-0 mt-1"/>
                                 <div>
                                    <h3 className='font-medium text-[var(--text-secondary)]'>Visit Us</h3>
                                    <p className='text-base !mb-0 !text-[var(--text-secondary)]'>{primaryLocation.address}</p>
                                    {/* Opcional: Añadir enlace al mapa */}
                                    {primaryLocation.mapUrl && <a href={primaryLocation.mapUrl} target='_blank' rel='noopener noreferrer' className='text-sm mt-1 inline-block'>View Map</a>}
                                </div>
                            </div>
                        )}
                        {locationError && <ErrorMessage message={locationError}/>}
                    </div>

                     {/* Opcional: Mostrar una tarjeta de ubicación completa */}
                     {/* {primaryLocation && (
                         <div className="mt-6">
                            <h3 className='text-lg font-semibold mb-3'>Main Facility</h3>
                            <LocationCard location={primaryLocation} />
                         </div>
                     )} */}
                </div>

                {/* Columna Derecha: Formulario de Contacto */}
                <div>
                     <h2 className='text-2xl font-semibold font-serif text-[var(--text-primary)] mb-4'>Send Us a Message</h2>
                    <ContactForm />
                </div>

            </div>
        </div>
    );
}
