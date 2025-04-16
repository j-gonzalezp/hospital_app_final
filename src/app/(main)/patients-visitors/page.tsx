// src/app/(main)/patients-visitors/page.tsx
import React from 'react';
import PageTitle from '@/components/common/PageTitle';
import { Clock, Users, Briefcase, Wifi, FileText, ShieldCheck, DollarSign, Coffee, Gift, Landmark } from 'lucide-react'; // Importa todos los iconos necesarios

// Componente reutilizable para secciones de información (lo definimos aquí mismo)
const InfoSection = ({ title, icon: Icon, children }: { title: string, icon?: React.ElementType, children: React.ReactNode }) => (
    <section className="mb-8 md:mb-10 pb-6 border-b border-[var(--border-primary)] last:border-b-0 last:pb-0 last:mb-0">
        <div className="flex items-center mb-3">
            {Icon && <Icon size={24} className="text-[var(--text-accent)] mr-3 flex-shrink-0" />}
            <h2 className="text-2xl font-semibold font-serif text-[var(--text-primary)] !mb-0">
                {title}
            </h2>
        </div>
        <div className="prose prose-lg max-w-none text-[var(--text-secondary)] pl-0 md:pl-[calc(24px+0.75rem)]">
            {children}
        </div>
    </section>
);


export default function PatientsVisitorsPage() {
    return (
        <div>
            <PageTitle
                title="Patients & Visitors"
                subtitle="Information to make your visit or stay as smooth as possible."
            />

            <div className="mt-8 md:mt-12 space-y-10">

                {/* --- CONTENIDO DE EJEMPLO --- */}

                <InfoSection title="Visiting Hours" icon={Clock}>
                    <p>
                        General visiting hours are from <strong>11:00 AM to 8:00 PM</strong> daily. Specific units like ICU or Maternity may have different schedules; please inquire at the respective nursing station. We kindly request a maximum of two visitors per patient at a time.
                    </p>
                </InfoSection>

                <InfoSection title="Admission & Discharge" icon={Briefcase}>
                     {/* Verifica esta línea cuidadosamente */}
                    <p>
                        For admissions, please check in at the Admissions Desk in the Main Lobby. Remember your ID, insurance details, and doctors orders.
                    </p>
                    <p>
                        Discharge planning starts early. Your care team will provide instructions for home care and follow-up. Please arrange transportation in advance.
                    </p>
                </InfoSection>

                <InfoSection title="Patient & Visitor Amenities" icon={Users}>
                   <ul className="list-none !pl-0">
                        <li className='flex items-center mb-2'><Wifi size={16} className='mr-2 text-[var(--text-subtle)]'/> Guest Wi-Fi: <span className='font-medium ml-1'>HospitalGuest</span> (No password).</li>
                        <li className='flex items-center mb-2'><Coffee size={16} className='mr-2 text-[var(--text-subtle)]'/> Cafeteria: 1st Floor, 7 AM - 6 PM.</li>
                        <li className='flex items-center mb-2'><Gift size={16} className='mr-2 text-[var(--text-subtle)]'/> Gift Shop: Main Lobby, 9 AM - 5 PM.</li>
                        <li className='flex items-center mb-2'><Landmark size={16} className='mr-2 text-[var(--text-subtle)]'/> Chapel/Meditation Room: 2nd Floor.</li>
                   </ul>
                </InfoSection>

                 <InfoSection title="Preparing for Your Visit" icon={FileText}>
                     {/* Revisa también este texto por si acaso */}
                    <p>
                       Bring a list of medications, inform us of allergies, follow fasting instructions if applicable, and leave valuables at home.
                    </p>
                </InfoSection>

                <InfoSection title="Billing & Insurance" icon={DollarSign}>
                     {/* Y este */}
                    <p>
                        We accept most major insurance plans. Contact our Billing Department at <a href="tel:+15551234568">(555) 123-4568</a> for questions regarding coverage, bills, or financial assistance.
                    </p>
                </InfoSection>

                <InfoSection title="Hospital Policies" icon={ShieldCheck}>
                     {/* Y este */}
                    <p>
                       This is a <strong>smoke-free campus</strong>. Please silence mobile devices in patient areas and adhere to all posted guidelines.
                    </p>
                </InfoSection>

            </div>
        </div>
    );
}