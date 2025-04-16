#!/bin/bash

# --- IDs HARCODEADOS ---
# Database ID: 67fe874f00007b6702ed
# Admin Team ID: 67fe88eb001a969f1dba
# Editor Team ID: 67c751eb0036f432765f
# --- ------------- ---

# --- Variables ---
DB_ID="67fe874f00007b6702ed"
ADMIN_TEAM="team:67fe88eb001a969f1dba" # No se usa directamente aquí, pero se mantiene por consistencia
EDITOR_TEAM="team:67c751eb0036f432765f" # No se usa directamente aquí, pero se mantiene por consistencia
LONG_SLEEP=5 # Segundos de espera antes de crear índices

echo "--- Iniciando SCRIPT DE REPARACIÓN (t_db.sh) ---"
echo "Este script intentará crear atributos e índices FALTANTES."
echo "NO crea buckets ni colecciones."
echo "Es seguro ejecutarlo múltiples veces."
echo "====================================================="
echo "Usando Database ID: ${DB_ID}"
echo "====================================================="

# --- Intentar Crear Atributos Faltantes ---
echo "[FASE 1/2] Intentando crear Atributos faltantes..."

echo "  Verificando atributos para: patientInfo..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key userId --size 512 --required true || echo "WARN: patientInfo: Atributo userId ya existe o falló"
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id patientInfo --key dateOfBirth --required false || echo "WARN: patientInfo: Atributo dateOfBirth ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key address --size 255 --required false || echo "WARN: patientInfo: Atributo address ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key emergencyContactName --size 100 --required false || echo "WARN: patientInfo: Atributo emergencyContactName ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key emergencyContactPhone --size 50 --required false || echo "WARN: patientInfo: Atributo emergencyContactPhone ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key insuranceProvider --size 100 --required false || echo "WARN: patientInfo: Atributo insuranceProvider ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key policyNumber --size 100 --required false || echo "WARN: patientInfo: Atributo policyNumber ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key bloodType --size 10 --required false || echo "WARN: patientInfo: Atributo bloodType ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key allergies --size 500 --required false || echo "WARN: patientInfo: Atributo allergies ya existe o falló"

echo "  Verificando atributos para: specialties..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id specialties --key name --size 100 --required true || echo "WARN: specialties: Atributo name ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id specialties --key description --size 1000 --required true || echo "WARN: specialties: Atributo description ya existe o falló"
appwrite databases create-url-attribute --database-id "${DB_ID}" --collection-id specialties --key iconUrl --required false || echo "WARN: specialties: Atributo iconUrl ya existe o falló"

echo "  Verificando atributos para: doctors..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key name --size 100 --required true || echo "WARN: doctors: Atributo name ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key specialtyId --size 512 --required true || echo "WARN: doctors: Atributo specialtyId ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key qualifications --size 500 --required true || echo "WARN: doctors: Atributo qualifications ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key bio --size 2000 --required false || echo "WARN: doctors: Atributo bio ya existe o falló"
appwrite databases create-integer-attribute --database-id "${DB_ID}" --collection-id doctors --key yearsExperience --required false --min 0 || echo "WARN: doctors: Atributo yearsExperience ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key profilePictureId --size 512 --required false || echo "WARN: doctors: Atributo profilePictureId ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key languages --size 100 --required false --array true || echo "WARN: doctors: Atributo languages ya existe o falló"
appwrite databases create-boolean-attribute --database-id "${DB_ID}" --collection-id doctors --key isActive --required true --default true || echo "WARN: doctors: Atributo isActive ya existe o falló"

echo "  Verificando atributos para: doctorAvailabilitySlots..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key doctorId --size 512 --required true || echo "WARN: doctorAvailabilitySlots: Atributo doctorId ya existe o falló"
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key startTime --required true || echo "WARN: doctorAvailabilitySlots: Atributo startTime ya existe o falló"
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key endTime --required true || echo "WARN: doctorAvailabilitySlots: Atributo endTime ya existe o falló"
appwrite databases create-enum-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key status --elements '["available","booked","unavailable"]' --required true --default "available" || echo "WARN: doctorAvailabilitySlots: Atributo status ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key appointmentId --size 512 --required false || echo "WARN: doctorAvailabilitySlots: Atributo appointmentId ya existe o falló"

echo "  Verificando atributos para: appointments..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key patientId --size 512 --required true || echo "WARN: appointments: Atributo patientId ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key doctorId --size 512 --required true || echo "WARN: appointments: Atributo doctorId ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key availabilitySlotId --size 512 --required true || echo "WARN: appointments: Atributo availabilitySlotId ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key reason --size 500 --required false || echo "WARN: appointments: Atributo reason ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key notes --size 1000 --required false || echo "WARN: appointments: Atributo notes ya existe o falló"
appwrite databases create-enum-attribute --database-id "${DB_ID}" --collection-id appointments --key status --elements '["scheduled","completed","cancelled","no-show"]' --required true --default "scheduled" || echo "WARN: appointments: Atributo status ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key cancellationReason --size 255 --required false || echo "WARN: appointments: Atributo cancellationReason ya existe o falló"

echo "  Verificando atributos para: services..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id services --key name --size 255 --required true || echo "WARN: services: Atributo name ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id services --key description --size 2000 --required true || echo "WARN: services: Atributo description ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id services --key specialtyId --size 512 --required false || echo "WARN: services: Atributo specialtyId ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id services --key costEstimate --size 50 --required false || echo "WARN: services: Atributo costEstimate ya existe o falló"
appwrite databases create-integer-attribute --database-id "${DB_ID}" --collection-id services --key durationMinutes --required false || echo "WARN: services: Atributo durationMinutes ya existe o falló"
appwrite databases create-url-attribute --database-id "${DB_ID}" --collection-id services --key imageUrl --required false || echo "WARN: services: Atributo imageUrl ya existe o falló"

echo "  Verificando atributos para: articles..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key title --size 255 --required true || echo "WARN: articles: Atributo title ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key slug --size 255 --required true || echo "WARN: articles: Atributo slug ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key content --size 50000 --required true || echo "WARN: articles: Atributo content ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key excerpt --size 500 --required false || echo "WARN: articles: Atributo excerpt ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key authorDoctorId --size 512 --required false || echo "WARN: articles: Atributo authorDoctorId ya existe o falló"
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id articles --key publishDate --required true || echo "WARN: articles: Atributo publishDate ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key category --size 50 --required false || echo "WARN: articles: Atributo category ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key tags --size 50 --required false --array true || echo "WARN: articles: Atributo tags ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key featuredImageId --size 512 --required false || echo "WARN: articles: Atributo featuredImageId ya existe o falló"
appwrite databases create-enum-attribute --database-id "${DB_ID}" --collection-id articles --key status --elements '["draft","published"]' --required true --default "draft" || echo "WARN: articles: Atributo status ya existe o falló"

echo "  Verificando atributos para: locations..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id locations --key name --size 100 --required true || echo "WARN: locations: Atributo name ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id locations --key address --size 255 --required true || echo "WARN: locations: Atributo address ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id locations --key phoneNumber --size 50 --required false || echo "WARN: locations: Atributo phoneNumber ya existe o falló"
appwrite databases create-float-attribute --database-id "${DB_ID}" --collection-id locations --key latitude --required false || echo "WARN: locations: Atributo latitude ya existe o falló"
appwrite databases create-float-attribute --database-id "${DB_ID}" --collection-id locations --key longitude --required false || echo "WARN: locations: Atributo longitude ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id locations --key operatingHours --size 500 --required false || echo "WARN: locations: Atributo operatingHours ya existe o falló"
appwrite databases create-url-attribute --database-id "${DB_ID}" --collection-id locations --key mapUrl --required false || echo "WARN: locations: Atributo mapUrl ya existe o falló"

echo "  Verificando atributos para: testimonials..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id testimonials --key patientName --size 100 --required true || echo "WARN: testimonials: Atributo patientName ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id testimonials --key quote --size 1000 --required true || echo "WARN: testimonials: Atributo quote ya existe o falló"
appwrite databases create-integer-attribute --database-id "${DB_ID}" --collection-id testimonials --key rating --required false --min 1 --max 5 || echo "WARN: testimonials: Atributo rating ya existe o falló"
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id testimonials --key dateReceived --required true || echo "WARN: testimonials: Atributo dateReceived ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id testimonials --key relatedDoctorId --size 512 --required false || echo "WARN: testimonials: Atributo relatedDoctorId ya existe o falló"
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id testimonials --key relatedServiceId --size 512 --required false || echo "WARN: testimonials: Atributo relatedServiceId ya existe o falló"
appwrite databases create-boolean-attribute --database-id "${DB_ID}" --collection-id testimonials --key isApproved --required true --default false || echo "WARN: testimonials: Atributo isApproved ya existe o falló"

echo "Comprobación de atributos completada."

# --- Intentar Crear Índices Faltantes ---
echo "[FASE 2/2] Intentando crear Índices faltantes (Esperando ${LONG_SLEEP}s)..."
sleep ${LONG_SLEEP}

echo "  Verificando índices para: patientInfo..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id patientInfo --key idx_pat_userId --type key --attributes userId --orders ASC || echo "WARN: Índice idx_pat_userId no se pudo crear (quizás ya existe o el atributo falta)"

echo "  Verificando índices para: specialties..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id specialties --key idx_spec_name --type key --attributes name --orders ASC || echo "WARN: Índice idx_spec_name no se pudo crear (quizás ya existe o el atributo falta)"

echo "  Verificando índices para: doctors..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctors --key idx_doc_name --type key --attributes name --orders ASC || echo "WARN: Índice idx_doc_name no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctors --key idx_doc_specialtyId --type key --attributes specialtyId --orders ASC || echo "WARN: Índice idx_doc_specialtyId no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctors --key idx_doc_isActive --type key --attributes isActive --orders ASC || echo "WARN: Índice idx_doc_isActive no se pudo crear (quizás ya existe o el atributo falta)"

echo "  Verificando índices para: doctorAvailabilitySlots..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key idx_slot_doctorId_startTime --type key --attributes doctorId,startTime --orders ASC,ASC || echo "WARN: Índice COMPUESTO idx_slot_doctorId_startTime no se pudo crear (quizás ya existe o atributos faltan)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key idx_slot_status --type key --attributes status --orders ASC || echo "WARN: Índice idx_slot_status no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key idx_slot_appointmentId --type key --attributes appointmentId --orders ASC || echo "WARN: Índice idx_slot_appointmentId no se pudo crear (quizás ya existe o el atributo falta)"

echo "  Verificando índices para: appointments..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id appointments --key idx_app_patientId --type key --attributes patientId --orders ASC || echo "WARN: Índice idx_app_patientId no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id appointments --key idx_app_doctorId --type key --attributes doctorId --orders ASC || echo "WARN: Índice idx_app_doctorId no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id appointments --key idx_app_availabilitySlotId_unique --type unique --attributes availabilitySlotId --orders ASC || echo "WARN: Índice ÚNICO idx_app_availabilitySlotId_unique no se pudo crear (quizás ya existe, atributo falta o hay datos duplicados)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id appointments --key idx_app_status --type key --attributes status --orders ASC || echo "WARN: Índice idx_app_status no se pudo crear (quizás ya existe o el atributo falta)"

echo "  Verificando índices para: services..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id services --key idx_serv_name --type key --attributes name --orders ASC || echo "WARN: Índice idx_serv_name no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id services --key idx_serv_specialtyId --type key --attributes specialtyId --orders ASC || echo "WARN: Índice idx_serv_specialtyId no se pudo crear (quizás ya existe o el atributo falta)"

echo "  Verificando índices para: articles..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_title --type key --attributes title --orders ASC || echo "WARN: Índice idx_art_title no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_slug_unique --type unique --attributes slug --orders ASC || echo "WARN: Índice ÚNICO idx_art_slug_unique no se pudo crear (quizás ya existe, atributo falta o hay datos duplicados)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_authorDoctorId --type key --attributes authorDoctorId --orders ASC || echo "WARN: Índice idx_art_authorDoctorId no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_publishDate --type key --attributes publishDate --orders DESC || echo "WARN: Índice idx_art_publishDate no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_category --type key --attributes category --orders ASC || echo "WARN: Índice idx_art_category no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_status --type key --attributes status --orders ASC || echo "WARN: Índice idx_art_status no se pudo crear (quizás ya existe o el atributo falta)"

echo "  Verificando índices para: locations..."
# No hay índices definidos explícitamente en el script original para 'locations'.

echo "  Verificando índices para: testimonials..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id testimonials --key idx_test_relatedDoctorId --type key --attributes relatedDoctorId --orders ASC || echo "WARN: Índice idx_test_relatedDoctorId no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id testimonials --key idx_test_relatedServiceId --type key --attributes relatedServiceId --orders ASC || echo "WARN: Índice idx_test_relatedServiceId no se pudo crear (quizás ya existe o el atributo falta)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id testimonials --key idx_test_isApproved --type key --attributes isApproved --orders ASC || echo "WARN: Índice idx_test_isApproved no se pudo crear (quizás ya existe o el atributo falta)"

echo "Comprobación de índices completada."
echo "====================================================="
echo "--- ¡Proceso de REPARACIÓN (t_db.sh) completado! ---"
echo "--- REVISA LA SALIDA POR ADVERTENCIAS (WARN) ---"
echo "--- Si sigues viendo WARNs aquí, puede haber un problema subyacente ---"
echo "--- (p.ej., la colección no existe, error de escritura, datos duplicados para índices únicos) ---"
echo "--- VERIFICA LA ESTRUCTURA FINAL EN LA CONSOLA WEB DE APPWRITE ---"
echo "====================================================="