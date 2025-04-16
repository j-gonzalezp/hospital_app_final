// src/lib/actions.ts
'use server'; // Marca este módulo para Server Actions

// --- MODIFICACIÓN AQUÍ: Importa Query directamente desde 'appwrite' ---
import {  Query, AppwriteException } from 'appwrite';
// --- FIN MODIFICACIÓN ---

// --- MODIFICACIÓN AQUÍ: Elimina Query de esta importación ---
import { databases, ID, storage, BUCKET_IDS, COLLECTION_IDS, APPWRITE_DATABASE_ID/*, Models*/ } from './appwrite';
// --- FIN MODIFICACIÓN ---
import type { AppointmentDocument, AppointmentWithDetails } from '@/types/appointment.d.ts';


import type { SpecialtyDocument } from '@/types/specialty';
import type { DoctorDocument, DoctorWithDetails } from '@/types/doctor.d.ts'; // Necesitarás crear este archivo
// Define un tipo para los detalles del doctor si es necesario
import type { AvailabilitySlotDocument } from '@/types/availability.d.ts'; // Importa el nuevo tipo

import type { ServiceDocument, ServiceWithDetails } from '@/types/service.d.ts'; // Importa tipos de servicio

// ... (resto de las actions) ...
import type { LocationDocument } from '@/types/locations';
// ... (resto de las actions) ...
import type { ArticleDocument, ArticleWithDetails } from '@/types/article.d.ts'; // Importa tipos de artículo
// Importa DoctorWithDetails si necesitas getDoctorDetails para el autor
// import type { DoctorWithDetails } from '@/types/doctor.d.ts';
// ... (resto de las actions) ...
import type { TestimonialDocument } from '@/types/testimonial.d.ts'; // Asegúrate que el tipo exista
// ... (resto de las actions) ...

// --- NUEVA FUNCIÓN: Obtener Testimonios Aprobados ---
interface GetTestimonialsOptions {
    limit?: number;
    offset?: number;
    // Podrías añadir filtros por doctorId o serviceId si quisieras
}

export async function getApprovedTestimonials(
    options: GetTestimonialsOptions = {}
): Promise<TestimonialDocument[]> {
    const { limit = 5, offset = 0 } = options;

    try {
        // --- LOG ANTES DE LA LLAMADA ---
        console.log(`ACTION: Fetching approved testimonials with limit=${limit}, offset=${offset}`);
        const queries: string[] = [
            Query.equal('isApproved', true),
            Query.orderDesc('$createdAt'),
            Query.limit(limit),
            Query.offset(offset)
        ];
        // --- LOG DE QUERIES ---
        console.log("ACTION: Appwrite Queries:", JSON.stringify(queries));

        const response = await databases.listDocuments(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.testimonials,
            queries
        );

        // --- LOG DESPUÉS DE LA LLAMADA ---
        console.log(`ACTION: Appwrite response received. Total documents found: ${response.total}, Documents in this batch: ${response.documents.length}`);
        // Opcional: Loguea los documentos recibidos
        // console.log("ACTION: Raw documents:", response.documents);

        const testimonials = response.documents as TestimonialDocument[];
        return testimonials;

    } catch (error) {
        // --- LOG EN CASO DE ERROR ---
        console.error("ACTION ERROR: Failed to fetch approved testimonials:", error);
        return []; // Devuelve vacío en error
    }
}

// --- NUEVA FUNCIÓN: Obtener Artículos Publicados ---
export async function getPublishedArticles(limit: number = 10, offset: number = 0): Promise<ArticleWithDetails[]> {
    try {
        console.log(`Fetching published articles (limit: ${limit}, offset: ${offset})...`);
        const queries: string[] = [
            Query.equal('status', 'published'), // Solo artículos publicados
            Query.orderDesc('publishDate'), // Los más recientes primero
            Query.limit(limit),
            Query.offset(offset)
        ];

        const response = await databases.listDocuments(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.articles,
            queries
        );

        const articles = response.documents as ArticleDocument[];
        console.log(`Found ${articles.length} published articles.`);

        // Enriquecer con URL de imagen destacada (Opcional: obtener nombre del autor)
        const articlesWithDetails: ArticleWithDetails[] = await Promise.all(
            articles.map(async (article) => {
                let featuredImageUrl: string | null = null;
                if (article.featuredImageId) {
                    try {
                        featuredImageUrl = storage.getFilePreview(
                            BUCKET_IDS.assets, // Usa el bucket único
                            article.featuredImageId
                        ).toString();
                    } catch (imgError) {
                        console.error(`Failed to get preview URL for article image ID ${article.featuredImageId}:`, imgError);
                    }
                }

                // Opcional: Obtener nombre del autor si existe authorDoctorId
                let authorName: string | undefined;
                if (article.authorDoctorId) {
                    // Podrías llamar a una función getDoctorNameById(id) aquí
                    // const doctor = await getDoctorById(article.authorDoctorId); // Reutiliza o crea una más simple
                    // authorName = doctor?.name;
                    authorName = `Dr. Placeholder ${article.authorDoctorId.substring(0,4)}`; // Placeholder temporal
                }


                return {
                    ...article,
                    featuredImageUrl: featuredImageUrl,
                    authorName: authorName,
                };
            })
        );

        return articlesWithDetails;

    } catch (error) {
        console.error("Failed to fetch published articles:", error);
        throw new Error("Could not fetch articles.");
    }
}

// --- NUEVA FUNCIÓN: Obtener Artículo por Slug ---
export async function getArticleBySlug(slug: string): Promise<ArticleWithDetails | null> {
    if (!slug) return null;

    try {
        console.log(`Fetching article by slug: ${slug}`);
        const queries: string[] = [
            Query.equal('slug', slug),
            Query.equal('status', 'published'), // Asegura que solo obtenemos publicados por slug
            Query.limit(1) // Solo debería haber uno con un slug único
        ];

        const response = await databases.listDocuments(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.articles,
            queries
        );

        if (response.documents.length === 0) {
            console.log(`Article with slug "${slug}" not found or not published.`);
            return null;
        }

        const article = response.documents[0] as ArticleDocument;
        let featuredImageUrl: string | null = null;
        let authorName: string | undefined;

        // Obtener URL de imagen
        if (article.featuredImageId) {
             try {
                 featuredImageUrl = storage.getFilePreview(BUCKET_IDS.assets, article.featuredImageId).toString();
             } catch (imgError) {
                 console.error(`Failed to get preview URL for article image ID ${article.featuredImageId}:`, imgError);
             }
        }

        // Obtener nombre del autor
         if (article.authorDoctorId) {
            // const doctor = await getDoctorById(article.authorDoctorId);
            // authorName = doctor?.name;
             authorName = `Dr. Placeholder ${article.authorDoctorId.substring(0,4)}`; // Placeholder temporal
         }

        return {
            ...article,
            featuredImageUrl: featuredImageUrl,
            authorName: authorName,
        };

    } catch (error) {
        console.error(`Failed to fetch article by slug ${slug}:`, error);
        // No lanzar error si no se encuentra, simplemente devolver null
        // throw new Error("Could not fetch article.");
        return null;
    }
}

// --- NUEVA FUNCIÓN: Obtener Todas las Ubicaciones ---
export async function getAllLocations(): Promise<LocationDocument[]> {
    try {
        console.log("Fetching all locations...");
        // Opcional: Si añades un campo 'isActive' a tu colección 'locations', filtra por él:
        // const queries = [Query.equal('isActive', true), Query.orderAsc('name')];
        const queries = [Query.orderAsc('name')]; // Ordenar alfabéticamente

        const response = await databases.listDocuments(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.locations,
            queries
        );

        const locations = response.documents as LocationDocument[];
        console.log(`Found ${locations.length} locations.`);
        return locations;

    } catch (error) {
        console.error("Failed to fetch locations:", error);
        throw new Error("Could not fetch locations.");
    }
}
// --- NUEVA FUNCIÓN: Obtener Todos los Servicios (con algunos detalles) ---
export async function getAllServices(): Promise<ServiceWithDetails[]> {
    try {
        console.log("Fetching all services...");
        const response = await databases.listDocuments(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.services,
            [Query.orderAsc('name')] // Ordenar alfabéticamente
        );

        const services = response.documents as ServiceDocument[];
        console.log(`Found ${services.length} services.`);

        // Opcional: Obtener mapa de especialidades para enriquecer datos
        // Podrías optimizar esto si no necesitas el nombre de la especialidad en la lista
        let specialtyMap = new Map<string, string>();
        try {
            const specialties = await getAllSpecialties(); // Reutiliza la función existente
            specialtyMap = new Map(specialties.map(spec => [spec.$id, spec.name]));
        } catch (specError) {
             console.warn("Could not fetch specialties to enrich services list:", specError);
        }


        // Enriquecer con URL de imagen y nombre de especialidad
        const servicesWithDetails: ServiceWithDetails[] = await Promise.all(
            services.map(async (service) => {
                let imageDisplayUrl: string | null = null;
                // Asume que 'imageUrl' en Appwrite guarda el ID de la imagen
                if (service.imageUrl) { // Verifica si hay un ID de imagen
                    try {
                        imageDisplayUrl = storage.getFilePreview(
                            BUCKET_IDS.assets, // Usa el bucket único
                            service.imageUrl // Asume que este es el File ID
                        ).toString();
                    } catch (imgError) {
                        console.error(`Failed to get preview URL for service image ID ${service.imageUrl}:`, imgError);
                    }
                }

                return {
                    ...service,
                    specialtyName: service.specialtyId ? specialtyMap.get(service.specialtyId) : undefined,
                    imageDisplayUrl: imageDisplayUrl,
                };
            })
        );

        return servicesWithDetails;

    } catch (error) {
        console.error("Failed to fetch services:", error);
        throw new Error("Could not fetch services.");
    }
}


// --- NUEVA FUNCIÓN: Obtener Servicio por ID (con detalles) ---
export async function getServiceById(serviceId: string): Promise<ServiceWithDetails | null> {
     if (!serviceId) return null;

    try {
        console.log(`Fetching service by ID: ${serviceId}`);
        const serviceDoc = await databases.getDocument(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.services,
            serviceId
        );

        const service = serviceDoc as ServiceDocument;
        let imageDisplayUrl: string | null = null;
        let specialtyName: string | undefined;

        // Obtener URL de imagen
        if (service.imageUrl) {
            try {
                imageDisplayUrl = storage.getFilePreview(BUCKET_IDS.assets, service.imageUrl).toString();
            } catch (imgError) {
                console.error(`Failed to get preview URL for service image ID ${service.imageUrl}:`, imgError);
            }
        }

        // Obtener nombre de especialidad (si tiene specialtyId)
        if (service.specialtyId) {
            try {
                const specialtyDoc = await databases.getDocument(
                    APPWRITE_DATABASE_ID,
                    COLLECTION_IDS.specialties,
                    service.specialtyId
                );
                specialtyName = specialtyDoc.name as string;
            } catch (specError) {
                console.error(`Failed to fetch specialty details for ID ${service.specialtyId}:`, specError);
                // No asignar 'Unknown Specialty' aquí, dejar undefined si falla
            }
        }

        return {
            ...service,
            imageDisplayUrl: imageDisplayUrl,
            specialtyName: specialtyName,
        };

    } catch (error: unknown) {
        if ((error as { code?: number })?.code === 404) {
            console.log(`Service with ID ${serviceId} not found.`);
            return null; // Devuelve null si no se encuentra
        }
        console.error(`Failed to fetch service by ID ${serviceId}:`, error);
	    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
        throw new Error(`Could not fetch service: ${errorMessage}`);
    }
}


// Interfaz para los datos necesarios para crear una cita
interface CreateAppointmentData {
    patientId: string; // ID del usuario que reserva
    doctorId: string;
    availabilitySlotId: string;
    reason?: string;
}

// --- NUEVA FUNCIÓN: Crear una Cita ---
export async function createAppointment(
    data: CreateAppointmentData
): Promise<{ success: boolean; message?: string; appointment?: AppointmentDocument }> {

    console.log("Attempting to create appointment with data:", data);

    if (!data.patientId || !data.doctorId || !data.availabilitySlotId) {
        return { success: false, message: "Missing required appointment data (patient, doctor, or slot)." };
    }

    // --- Estrategia: Verificar y Actualizar Slot, luego Crear Cita ---
    // Esta estrategia tiene una pequeña ventana de riesgo entre la verificación/actualización del slot
    // y la creación de la cita. Una Appwrite Function sería más robusta para la atomicidad.

    try {
        // 1. Obtener el Slot para verificar su estado ACTUAL
        console.log(`Fetching slot ${data.availabilitySlotId} to verify status...`);
        const slot = await databases.getDocument<AvailabilitySlotDocument>( // Especifica el tipo genérico
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.availabilitySlots,
            data.availabilitySlotId
        );

        // 2. Verificar si el Slot sigue disponible
        if (slot.status !== 'available') {
            console.warn(`Slot ${data.availabilitySlotId} is no longer available. Status: ${slot.status}`);
            return { success: false, message: `Sorry, the selected time slot (${new Date(slot.startTime).toLocaleTimeString([], {hour:'2-digit', minute:'2-digit'})}) is no longer available. Please select another time.` };
        }
        console.log(`Slot ${data.availabilitySlotId} confirmed as available.`);

        // 3. Crear la Cita PRIMERO (obtenemos el ID de la cita)
        //    Si esto falla, no hemos modificado el slot todavía.
        console.log("Creating appointment document...");
        const newAppointment = await databases.createDocument<AppointmentDocument>(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.appointments,
            ID.unique(), // Genera un ID único para la nueva cita
            {
                patientId: data.patientId,
                doctorId: data.doctorId,
                availabilitySlotId: data.availabilitySlotId,
                reason: data.reason || null, // Asegura que sea null si está vacío
                status: 'scheduled',
                // bookedAt es manejado por $createdAt automáticamente
            }
        );
        console.log(`Appointment document created with ID: ${newAppointment.$id}`);

        // 4. Actualizar el Slot AHORA, vinculando el ID de la cita
        //    Si esto falla, tenemos una cita creada pero el slot sigue 'available' (situación a manejar/limpiar).
        console.log(`Updating slot ${data.availabilitySlotId} status to booked and linking appointment ${newAppointment.$id}...`);
        await databases.updateDocument(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.availabilitySlots,
            data.availabilitySlotId,
            {
                status: 'booked',
                appointmentId: newAppointment.$id, // Vincula el ID de la cita creada
            }
        );
        console.log(`Slot ${data.availabilitySlotId} successfully updated.`);

        // ¡Éxito!
        return { success: true, appointment: newAppointment };

    } catch (error) {
        console.error("Failed to create appointment:", error);
        let message = "An unexpected error occurred while booking the appointment.";
        if (error instanceof AppwriteException) {
            // Podrías intentar identificar errores específicos (ej: permisos)
            message = `Failed to book appointment: ${error.message}`;
            // Considera si necesitas revertir algún paso si falló a mitad de camino
            // (ej: si la cita se creó pero la actualización del slot falló).
            // Esto es complejo sin transacciones reales.
        }
        return { success: false, message };
    }
}
// --- NUEVA FUNCIÓN: Obtener Slots Disponibles para un Doctor en una Fecha Específica ---
export async function getAvailableSlots(
    doctorId: string,
    date: string // Formato YYYY-MM-DD
): Promise<AvailabilitySlotDocument[]> {

    if (!doctorId || !date) {
        throw new Error("Doctor ID and Date are required to fetch available slots.");
    }

    try {
        // Construir las fechas de inicio y fin para el día seleccionado
        // Importante: Appwrite trabaja con UTC. Asegúrate de que el manejo de zonas horarias
        // sea consistente. Aquí asumimos que 'date' representa el inicio del día en la zona horaria local
        // y queremos buscar en el rango UTC correspondiente a ese día.
        // Una forma simple es buscar desde el inicio del día hasta el final del día.
        const startDate = new Date(date); // Interpreta YYYY-MM-DD como inicio del día local
        startDate.setHours(0, 0, 0, 0); // Asegura que sea medianoche
        const endDate = new Date(date);
        endDate.setHours(23, 59, 59, 999); // Fin del día

        // Convierte a formato ISO que Appwrite espera para Queries DateTime
        const startISO = startDate.toISOString();
        const endISO = endDate.toISOString();

        console.log(`Fetching available slots for doctor ${doctorId} between ${startISO} and ${endISO}`);

        const queries: string[] = [
            Query.equal('doctorId', doctorId),
            Query.equal('status', 'available'), // Solo slots disponibles
            Query.greaterThanEqual('startTime', startISO), // Comienza en o después del inicio del día
            Query.lessThan('startTime', endISO),        // Comienza antes del final del día
            Query.orderAsc('startTime') // Ordena los slots por hora
        ];

        const response = await databases.listDocuments(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.availabilitySlots,
            queries
        );

        console.log(`Found ${response.documents.length} available slots.`);
        return response.documents as AvailabilitySlotDocument[];

    } catch (error) {
        console.error(`Failed to fetch available slots for doctor ${doctorId} on ${date}:`, error);
        // Devuelve array vacío en caso de error para que el frontend pueda manejarlo
        // O lanza un error si prefieres manejarlo más arriba
        // throw new Error("Could not fetch available slots.");
        return [];
    }
}

interface DoctorDetails {
    name: string;
    // otros campos si los necesitas
}

// Función para obtener detalles de un doctor por ID (ejemplo)
async function getDoctorDetails(doctorId: string): Promise<DoctorDetails | null> {
    try {
        // Ahora COLLECTION_IDS.doctors viene de './appwrite' como antes
        const doctorDoc = await databases.getDocument(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.doctors,
            doctorId
        );
        // Asegúrate de que los campos existen en tu colección de doctores
        return {
            name: doctorDoc.name as string || 'Unknown Doctor',
        };
    } catch (error) {
        console.error(`Failed to fetch doctor details for ID ${doctorId}:`, error);
        return null; // Devuelve null si falla
    }
}


export async function getUserAppointments(userId: string): Promise<AppointmentWithDetails[]> {
    if (!userId) {
        throw new Error("User ID is required to fetch appointments.");
    }

    console.log(`Fetching appointments for user: ${userId}`);

    try {
        // Ahora Query viene directamente de 'appwrite' y funciona correctamente
        const response = await databases.listDocuments(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.appointments,
            [
                Query.equal('patientId', userId), // Filtra por el ID del paciente
                Query.orderDesc('$createdAt'), // Ordena por fecha de creación (o por fecha de cita si la tienes)
                // Query.limit(25) // Opcional: Limita el número de resultados
            ]
        );

        const appointments = response.documents as AppointmentDocument[];

        // --- Enriquecer con Detalles (Ej: Nombre del Doctor) ---
        const appointmentsWithDetails: AppointmentWithDetails[] = await Promise.all(
            appointments.map(async (app) => {
                const doctorInfo = await getDoctorDetails(app.doctorId);
                return {
                    ...app,
                    doctorName: doctorInfo?.name || 'Doctor details unavailable',
                };
            })
        );
        // --- Fin Enriquecer con Detalles ---

        console.log(`Found ${appointmentsWithDetails.length} appointments.`);
        return appointmentsWithDetails;

    } catch (error) {
        console.error("Failed to fetch user appointments:", error);
        // Lanza el error para que pueda ser capturado por el llamador (ej. useEffect en la página)
        if (error instanceof AppwriteException) {
             throw new Error(`Could not fetch appointments: ${error.message}`);
        }
        throw new Error("An unexpected error occurred while fetching appointments.");
    }
}

// --- Acción para Cancelar Cita (sin cambios necesarios aquí, asumiendo que el resto funciona) ---
export async function cancelUserAppointment(
    appointmentId: string,
    availabilitySlotId: string
): Promise<{ success: boolean; message?: string }> {
     if (!appointmentId || !availabilitySlotId) {
        return { success: false, message: "Appointment ID and Slot ID are required." };
    }
    console.log(`Attempting to cancel appointment ${appointmentId}, freeing slot ${availabilitySlotId}`);

    try {
        // Paso 1: Actualizar el estado de la cita a 'cancelled'
        await databases.updateDocument(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.appointments,
            appointmentId,
            { status: 'cancelled' }
        );
        console.log(`Appointment ${appointmentId} status updated to cancelled.`);

        // Paso 2: Actualizar el estado del slot de disponibilidad a 'available'
        await databases.updateDocument(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.availabilitySlots,
            availabilitySlotId,
            {
                status: 'available',
                appointmentId: null, // Desvincula el ID de la cita
            }
        );
         console.log(`Availability slot ${availabilitySlotId} status updated to available.`);

        return { success: true };

    } catch (error) {
        console.error("Failed to cancel appointment:", error);
        let message = "Could not cancel the appointment. Please try again.";
        if (error instanceof AppwriteException) {
            message = `Could not cancel appointment: ${error.message}`;
        }
        return { success: false, message };
    }
}

export async function getAllSpecialties(): Promise<SpecialtyDocument[]> {
    try {
        console.log("Fetching all specialties...");
        const response = await databases.listDocuments(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.specialties,
            [Query.orderAsc('name')] // Ordenar alfabéticamente
        );
        console.log(`Found ${response.documents.length} specialties.`);
        // Hacemos un type assertion seguro aquí
        return response.documents as SpecialtyDocument[];
    } catch (error) {
        console.error("Failed to fetch specialties:", error);
        throw new Error("Could not fetch specialties.");
    }
}

// --- NUEVA FUNCIÓN: Obtener Doctores (con filtros y detalles) ---
// Define un tipo para los filtros opcionales
interface DoctorFilters {
    name?: string;
    specialtyId?: string;
}

export async function getDoctors(filters: DoctorFilters = {}): Promise<DoctorWithDetails[]> {
    try {
        const queries: string[] = [Query.equal('isActive', true)];

        if (filters.specialtyId) {
            queries.push(Query.equal('specialtyId', filters.specialtyId));
        }
        if (filters.name) {
            queries.push(Query.search('name', filters.name));
        }
        queries.push(Query.orderAsc('name'));

        console.log(`Fetching doctors with queries: ${JSON.stringify(queries)}`);
        const response = await databases.listDocuments(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.doctors,
            queries
        );

        const doctors = response.documents as DoctorDocument[];
        console.log(`Found ${doctors.length} doctors matching criteria.`);

        // --- Enriquecer con detalles ---
        const specialties = await getAllSpecialties();
        const specialtyMap = new Map(specialties.map(spec => [spec.$id, spec.name]));

        const doctorsWithDetails: DoctorWithDetails[] = await Promise.all(
            doctors.map(async (doc) => {
                let profilePictureUrl: string | null = null;
                if (doc.profilePictureId) {
                    try {
                        // --- USA storage y BUCKET_IDS importados ---
                        profilePictureUrl = storage.getFilePreview(
                            BUCKET_IDS.assets, // Clave del bucket único
                            doc.profilePictureId
                        ).toString();
                        // --- FIN ---
                    } catch (imgError) {
                        console.error(`Failed to get preview URL for image ID ${doc.profilePictureId}:`, imgError);
                    }
                }

                return {
                    ...doc,
                    specialtyName: specialtyMap.get(doc.specialtyId) || 'Unknown Specialty',
                    profilePictureUrl: profilePictureUrl,
                };
            })
        );
        return doctorsWithDetails;

    } catch (error) {
        console.error("Failed to fetch doctors:", error);
        throw new Error("Could not fetch doctors.");
    }
}
// --- NUEVA FUNCIÓN: Obtener Doctor por ID (con detalles) ---
export async function getDoctorById(doctorId: string): Promise<DoctorWithDetails | null> {
    try {
        console.log(`Fetching doctor by ID: ${doctorId}`);
        const doc = await databases.getDocument(
            APPWRITE_DATABASE_ID,
            COLLECTION_IDS.doctors,
            doctorId
        );

        if (!doc.isActive) {
             console.warn(`Doctor with ID ${doctorId} is not active.`);
             return null;
        }

        const doctor = doc as DoctorDocument;
        let profilePictureUrl: string | null = null;
        let specialtyName: string | undefined;

        // Obtener URL de imagen
        if (doctor.profilePictureId) {
            try {
                 // --- USA storage y BUCKET_IDS importados ---
                profilePictureUrl = storage.getFilePreview(
                    BUCKET_IDS.assets, // Clave del bucket único
                    doctor.profilePictureId
                ).toString();
                // --- FIN ---
            } catch (imgError) {
                console.error(`Failed to get preview URL for image ID ${doctor.profilePictureId}:`, imgError);
            }
        }

        // Obtener nombre de especialidad
        try {
            const specialtyDoc = await databases.getDocument(
                APPWRITE_DATABASE_ID,
                COLLECTION_IDS.specialties,
                doctor.specialtyId
            );
            specialtyName = specialtyDoc.name as string;
        } catch (specError) {
            console.error(`Failed to fetch specialty details for ID ${doctor.specialtyId}:`, specError);
            specialtyName = 'Unknown Specialty';
        }

        return {
            ...doctor,
            profilePictureUrl: profilePictureUrl,
            specialtyName: specialtyName,
        };

    } catch (error: unknown) {
        if ((error as { code?: number })?.code === 404) {
            console.log(`Doctor with ID ${doctorId} not found.`);
            return null;
        }
        console.error(`Failed to fetch doctor by ID ${doctorId}:`, error);
		const errorMessage = error instanceof Error ? error.message : 'Unknown error';
        throw new Error(`Could not fetch doctor: ${errorMessage}`);
    }
}


// --- Tipos para el formulario de contacto ---
interface ContactFormData {
    name: string;
    email: string;
    subject: string;
    message: string;
}

interface SendMessageResult {
    success: boolean;
    message?: string;
}
// --- Fin tipos ---

// --- NUEVA FUNCIÓN: Enviar Mensaje de Contacto (SIMULADA) ---
export async function sendContactMessage(
    formData: ContactFormData
): Promise<SendMessageResult> {
    console.log("Received contact form submission:");
    console.log("Name:", formData.name);
    console.log("Email:", formData.email);
    console.log("Subject:", formData.subject);
    console.log("Message:", formData.message);

    // Validación básica (puedes añadir más)
    if (!formData.name || !formData.email || !formData.subject || !formData.message) {
        return { success: false, message: "Please fill in all required fields." };
    }
    if (!formData.email.includes('@')) {
         return { success: false, message: "Please enter a valid email address." };
    }

    // *** SIMULACIÓN ***
    // Aquí iría la lógica real para enviar el email o guardar en DB
    // Ejemplo:
    // try {
    //    await sendEmail({ to: 'admin@hospital.com', from: formData.email, subject: formData.subject, text: formData.message });
    //    return { success: true, message: "Message sent successfully!" };
    // } catch (error) {
    //    console.error("Email sending failed:", error);
    //    return { success: false, message: "Could not send message due to a server error." };
    // }

    // Simulación de éxito después de una breve pausa
    await new Promise(resolve => setTimeout(resolve, 1000));
    return { success: true, message: "Your message has been received (simulation)." };
}
