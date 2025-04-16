// src/lib/appwrite.ts
import { Client, Account, Databases, Avatars, Storage, ID, Query } from 'appwrite';

// --- Leer todas las variables de entorno ---
const endpoint = process.env.NEXT_PUBLIC_APPWRITE_ENDPOINT;
const projectId = process.env.NEXT_PUBLIC_APPWRITE_PROJECT_ID;
const databaseId = process.env.NEXT_PUBLIC_APPWRITE_DATABASE_ID;

// Collection IDs (leerlos como antes)
const testimonialsCollectionId = process.env.NEXT_PUBLIC_COLLECTION_ID_TESTIMONIALS;
const locationsCollectionId = process.env.NEXT_PUBLIC_COLLECTION_ID_LOCATIONS;
const servicesCollectionId = process.env.NEXT_PUBLIC_COLLECTION_ID_SERVICES;
const appointmentsCollectionId = process.env.NEXT_PUBLIC_COLLECTION_ID_APPOINTMENTS;
const doctorsCollectionId = process.env.NEXT_PUBLIC_COLLECTION_ID_DOCTORS;
const specialtiesCollectionId = process.env.NEXT_PUBLIC_COLLECTION_ID_SPECIALTIES;
const patientInfoCollectionId = process.env.NEXT_PUBLIC_COLLECTION_ID_PATIENTINFO;
const availabilitySlotsCollectionId = process.env.NEXT_PUBLIC_COLLECTION_ID_AVAILABILITYSLOTS;
const articlesCollectionId = process.env.NEXT_PUBLIC_COLLECTION_ID_ARTICLES;

// --- LEER EL ÚNICO BUCKET ID ---
const assetsBucketId = process.env.NEXT_PUBLIC_ASSETS_BUCKET_ID;

// --- Validación de variables de entorno (AJUSTADA) ---
const requiredEnvVars = {
    endpoint,
    projectId,
    databaseId,
    testimonialsCollectionId,
    locationsCollectionId,
    servicesCollectionId,
    appointmentsCollectionId,
    doctorsCollectionId,
    specialtiesCollectionId,
    patientInfoCollectionId,
    availabilitySlotsCollectionId,
    articlesCollectionId,
    // --- SOLO VALIDAR EL ÚNICO BUCKET ID ---
    assetsBucketId
};

let isConfigValid = true;
console.log("Checking Appwrite Environment Variables..."); // Log para depuración
for (const [key, value] of Object.entries(requiredEnvVars)) {
    if (!value) {
        // Intenta construir el nombre esperado de la variable de entorno para un mensaje más claro
        // Esto es una aproximación y puede no ser perfecto para todos los nombres de claves
        let expectedEnvVar = `NEXT_PUBLIC_${key.replace(/([A-Z])/g, '_$1').toUpperCase()}`;
        if (key === 'endpoint') expectedEnvVar = 'NEXT_PUBLIC_APPWRITE_ENDPOINT';
        if (key === 'projectId') expectedEnvVar = 'NEXT_PUBLIC_APPWRITE_PROJECT_ID';
        if (key === 'databaseId') expectedEnvVar = 'NEXT_PUBLIC_APPWRITE_DATABASE_ID';
        if (key === 'assetsBucketId') expectedEnvVar = 'NEXT_PUBLIC_ASSETS_BUCKET_ID';
        if (key.endsWith('CollectionId')) {
            const prefix = key.replace('CollectionId', '');
             expectedEnvVar = `NEXT_PUBLIC_COLLECTION_ID_${prefix.toUpperCase()}`;
        }

        console.error(`❌ Error: Missing Appwrite environment variable for '${key}'. Expected variable name similar to '${expectedEnvVar}'. Value received: ${value}`);
        isConfigValid = false;
    } else {
         // Opcional: Loguea las variables encontradas para confirmar que se leen
         // console.log(`✅ Found ENV VAR for ${key}: Set`);
    }
}

if (!isConfigValid) {
    console.error("🔴 Appwrite configuration is incomplete. Please check your .env.local file and ensure all required IDs are set.");
    // Considera lanzar un error aquí si quieres que la aplicación falle en lugar de continuar con configuración incompleta
    // throw new Error("Incomplete Appwrite configuration. Check server logs.");
} else {
    console.log("✅ Appwrite Environment Variables seem complete.");
}

// --- Inicialización del Cliente Appwrite ---
const client = new Client();

if (endpoint && projectId) {
    console.log(`Initializing Appwrite Client with Endpoint: ${endpoint} and Project ID: ${projectId}`);
    client
        .setEndpoint(endpoint)
        .setProject(projectId);
} else {
    // Este caso debería ser cubierto por la validación anterior, pero es una salvaguarda
    console.warn("🟡 Appwrite client setup skipped due to missing endpoint or projectId.");
}

// --- Exportar Instancias y Constantes ---
const account = new Account(client);
const databases = new Databases(client);
const avatars = new Avatars(client);
const storage = new Storage(client);

// Exporta las instancias del SDK y el generador de ID
export { client, account, databases, avatars, storage, ID, Query };

// Exporta los IDs leídos desde las variables de entorno
// Usamos la aserción '!' porque hemos validado que existen arriba (si isConfigValid es true)
// Si la configuración no es válida, estas exportaciones podrían ser undefined,
// pero el error ya se habrá registrado en la consola.
export const APPWRITE_DATABASE_ID = databaseId!;

export const COLLECTION_IDS = {
    testimonials: testimonialsCollectionId!,
    locations: locationsCollectionId!,
    services: servicesCollectionId!,
    appointments: appointmentsCollectionId!,
    doctors: doctorsCollectionId!,
    specialties: specialtiesCollectionId!,
    patientInfo: patientInfoCollectionId!,
    availabilitySlots: availabilitySlotsCollectionId!,
    articles: articlesCollectionId!,
};

// --- EXPORTAR SOLO EL ID DEL BUCKET ÚNICO ---
// Usamos 'assets' como clave genérica en nuestro código, pero el valor viene de la variable de entorno
export const BUCKET_IDS = {
    assets: assetsBucketId!,
};

// Pequeña función de utilidad para verificar la configuración si es necesario desde otro lugar
export const checkAppwriteConfig = (): boolean => {
    if (!isConfigValid) {
       console.warn("Attempted to use Appwrite SDK with incomplete configuration.");
    }
    return isConfigValid;
}

// Log final para confirmar que el módulo se cargó
console.log("Appwrite SDK module initialized.");