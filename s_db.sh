#!/bin/bash

# --- IDs HARCODEADOS ---
# Database ID: 67fe874f00007b6702ed
# Admin Team ID: 67fe88eb001a969f1dba
# Editor Team ID: 67c751eb0036f432765f
# --- ------------- ---

echo "--- Iniciando configuración con IDs HARCODEADOS ---"
echo "Usando Database ID: 67fe874f00007b6702ed"
echo "Usando Admin Team ID: 67fe88eb001a969f1dba"
echo "Usando Editor Team ID: 67c751eb0036f432765f"
echo "====================================================="
echo "NOTA: Script guardado con finales de línea LF (Unix)."
echo "====================================================="


# --- Crear Buckets de Almacenamiento ---
echo "[FASE 1/3] Creando Buckets..."
# Updated permissions format (role:all -> any, role:authenticated -> users)
appwrite storage create-bucket --bucket-id profile_pictures --name 'Profile Pictures' --permissions 'read("any")' 'create("team:67fe88eb001a969f1dba")' 'update("team:67fe88eb001a969f1dba")' 'delete("team:67fe88eb001a969f1dba")' --file-security true --enabled true || echo "WARN: Bucket profile_pictures ya existe o falló su creación"

appwrite storage create-bucket --bucket-id article_images --name 'Article Images' --permissions 'read("any")' 'create("team:67c751eb0036f432765f", "team:67fe88eb001a969f1dba")' 'update("team:67c751eb0036f432765f", "team:67fe88eb001a969f1dba")' 'delete("team:67c751eb0036f432765f", "team:67fe88eb001a969f1dba")' --file-security true --enabled true || echo "WARN: Bucket article_images ya existe o falló su creación"
echo "Buckets creados."


# --- Crear Colecciones y Atributos ---
echo "[FASE 2/3] Creando Colecciones y Atributos..."

# Colección: patientInfo
echo "  Creando: patientInfo..."
# Check if collection exists before creating
appwrite databases create-collection --database-id 67fe874f00007b6702ed --collection-id patientInfo --name 'Patient Info' --permissions 'read("team:67fe88eb001a969f1dba")' 'create("team:67fe88eb001a969f1dba")' 'update("team:67fe88eb001a969f1dba")' 'delete("team:67fe88eb001a969f1dba")' --document-security true --enabled true || echo "WARN: Colección patientInfo ya existe o falló su creación"

# Try to create attributes, ignore if they already exist
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id patientInfo --key userId --size 512 --required true || echo "WARN: Atributo userId ya existe"
appwrite databases create-datetime-attribute --database-id 67fe874f00007b6702ed --collection-id patientInfo --key dateOfBirth --required false || echo "WARN: Atributo dateOfBirth ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id patientInfo --key address --size 255 --required false || echo "WARN: Atributo address ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id patientInfo --key emergencyContactName --size 100 --required false || echo "WARN: Atributo emergencyContactName ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id patientInfo --key emergencyContactPhone --size 50 --required false || echo "WARN: Atributo emergencyContactPhone ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id patientInfo --key insuranceProvider --size 100 --required false || echo "WARN: Atributo insuranceProvider ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id patientInfo --key policyNumber --size 100 --required false || echo "WARN: Atributo policyNumber ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id patientInfo --key bloodType --size 10 --required false || echo "WARN: Atributo bloodType ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id patientInfo --key allergies --size 500 --required false || echo "WARN: Atributo allergies ya existe"

# Colección: specialties
echo "  Creando: specialties..."
appwrite databases create-collection --database-id 67fe874f00007b6702ed --collection-id specialties --name Specialties --permissions 'read("any")' 'create("team:67fe88eb001a969f1dba")' 'update("team:67fe88eb001a969f1dba")' 'delete("team:67fe88eb001a969f1dba")' --document-security false --enabled true || echo "WARN: Colección specialties ya existe o falló su creación"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id specialties --key name --size 100 --required true || echo "WARN: Atributo name ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id specialties --key description --size 1000 --required true || echo "WARN: Atributo description ya existe"
appwrite databases create-url-attribute --database-id 67fe874f00007b6702ed --collection-id specialties --key iconUrl --required false || echo "WARN: Atributo iconUrl ya existe"

# Colección: doctors
echo "  Creando: doctors..."
appwrite databases create-collection --database-id 67fe874f00007b6702ed --collection-id doctors --name Doctors --permissions 'read("any")' 'create("team:67fe88eb001a969f1dba")' 'update("team:67fe88eb001a969f1dba")' 'delete("team:67fe88eb001a969f1dba")' --document-security false --enabled true || echo "WARN: Colección doctors ya existe o falló su creación"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id doctors --key name --size 100 --required true || echo "WARN: Atributo name ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id doctors --key specialtyId --size 512 --required true || echo "WARN: Atributo specialtyId ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id doctors --key qualifications --size 500 --required true || echo "WARN: Atributo qualifications ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id doctors --key bio --size 2000 --required false || echo "WARN: Atributo bio ya existe"
appwrite databases create-integer-attribute --database-id 67fe874f00007b6702ed --collection-id doctors --key yearsExperience --required false --min 0 || echo "WARN: Atributo yearsExperience ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id doctors --key profilePictureId --size 512 --required false || echo "WARN: Atributo profilePictureId ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id doctors --key languages --size 100 --required false --array true || echo "WARN: Atributo languages ya existe"
appwrite databases create-boolean-attribute --database-id 67fe874f00007b6702ed --collection-id doctors --key isActive --required true --default true || echo "WARN: Atributo isActive ya existe"

# Colección: doctorAvailabilitySlots
echo "  Creando: doctorAvailabilitySlots..."
appwrite databases create-collection --database-id 67fe874f00007b6702ed --collection-id doctorAvailabilitySlots --name 'Doctor Availability Slots' --permissions 'read("any")' 'create("team:67fe88eb001a969f1dba")' 'update("users", "team:67fe88eb001a969f1dba")' 'delete("team:67fe88eb001a969f1dba")' --document-security false --enabled true || echo "WARN: Colección doctorAvailabilitySlots ya existe o falló su creación"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id doctorAvailabilitySlots --key doctorId --size 512 --required true || echo "WARN: Atributo doctorId ya existe"
appwrite databases create-datetime-attribute --database-id 67fe874f00007b6702ed --collection-id doctorAvailabilitySlots --key startTime --required true || echo "WARN: Atributo startTime ya existe"
appwrite databases create-datetime-attribute --database-id 67fe874f00007b6702ed --collection-id doctorAvailabilitySlots --key endTime --required true || echo "WARN: Atributo endTime ya existe"
appwrite databases create-enum-attribute --database-id 67fe874f00007b6702ed --collection-id doctorAvailabilitySlots --key status --elements '["available","booked","unavailable"]' --required true --default "available" || echo "WARN: Atributo status ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id doctorAvailabilitySlots --key appointmentId --size 512 --required false || echo "WARN: Atributo appointmentId ya existe"

# Colección: appointments
echo "  Creando: appointments..."
appwrite databases create-collection --database-id 67fe874f00007b6702ed --collection-id appointments --name Appointments --permissions 'read("team:67fe88eb001a969f1dba")' 'create("users")' 'update("team:67fe88eb001a969f1dba")' 'delete("team:67fe88eb001a969f1dba")' --document-security true --enabled true || echo "WARN: Colección appointments ya existe o falló su creación"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id appointments --key patientId --size 512 --required true || echo "WARN: Atributo patientId ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id appointments --key doctorId --size 512 --required true || echo "WARN: Atributo doctorId ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id appointments --key availabilitySlotId --size 512 --required true || echo "WARN: Atributo availabilitySlotId ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id appointments --key reason --size 500 --required false || echo "WARN: Atributo reason ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id appointments --key notes --size 1000 --required false || echo "WARN: Atributo notes ya existe"
appwrite databases create-enum-attribute --database-id 67fe874f00007b6702ed --collection-id appointments --key status --elements '["scheduled","completed","cancelled","no-show"]' --required true --default "scheduled" || echo "WARN: Atributo status ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id appointments --key cancellationReason --size 255 --required false || echo "WARN: Atributo cancellationReason ya existe"

# Colección: services
echo "  Creando: services..."
appwrite databases create-collection --database-id 67fe874f00007b6702ed --collection-id services --name Services --permissions 'read("any")' 'create("team:67fe88eb001a969f1dba")' 'update("team:67fe88eb001a969f1dba")' 'delete("team:67fe88eb001a969f1dba")' --document-security false --enabled true || echo "WARN: Colección services ya existe o falló su creación"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id services --key name --size 255 --required true || echo "WARN: Atributo name ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id services --key description --size 2000 --required true || echo "WARN: Atributo description ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id services --key specialtyId --size 512 --required false || echo "WARN: Atributo specialtyId ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id services --key costEstimate --size 50 --required false || echo "WARN: Atributo costEstimate ya existe"
appwrite databases create-integer-attribute --database-id 67fe874f00007b6702ed --collection-id services --key durationMinutes --required false || echo "WARN: Atributo durationMinutes ya existe"
appwrite databases create-url-attribute --database-id 67fe874f00007b6702ed --collection-id services --key imageUrl --required false || echo "WARN: Atributo imageUrl ya existe"

# Colección: articles
echo "  Creando: articles..."
appwrite databases create-collection --database-id 67fe874f00007b6702ed --collection-id articles --name Articles --permissions 'read("any")' 'create("team:67c751eb0036f432765f", "team:67fe88eb001a969f1dba")' 'update("team:67c751eb0036f432765f", "team:67fe88eb001a969f1dba")' 'delete("team:67c751eb0036f432765f", "team:67fe88eb001a969f1dba")' --document-security false --enabled true || echo "WARN: Colección articles ya existe o falló su creación"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key title --size 255 --required true || echo "WARN: Atributo title ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key slug --size 255 --required true || echo "WARN: Atributo slug ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key content --size 50000 --required true || echo "WARN: Atributo content ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key excerpt --size 500 --required false || echo "WARN: Atributo excerpt ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key authorDoctorId --size 512 --required false || echo "WARN: Atributo authorDoctorId ya existe"
appwrite databases create-datetime-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key publishDate --required true || echo "WARN: Atributo publishDate ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key category --size 50 --required false || echo "WARN: Atributo category ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key tags --size 50 --required false --array true || echo "WARN: Atributo tags ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key featuredImageId --size 512 --required false || echo "WARN: Atributo featuredImageId ya existe"
appwrite databases create-enum-attribute --database-id 67fe874f00007b6702ed --collection-id articles --key status --elements '["draft","published"]' --required true --default "draft" || echo "WARN: Atributo status ya existe"

# Colección: locations
echo "  Creando: locations..."
appwrite databases create-collection --database-id 67fe874f00007b6702ed --collection-id locations --name Locations --permissions 'read("any")' 'create("team:67fe88eb001a969f1dba")' 'update("team:67fe88eb001a969f1dba")' 'delete("team:67fe88eb001a969f1dba")' --document-security false --enabled true || echo "WARN: Colección locations ya existe o falló su creación"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id locations --key name --size 100 --required true || echo "WARN: Atributo name ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id locations --key address --size 255 --required true || echo "WARN: Atributo address ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id locations --key phoneNumber --size 50 --required false || echo "WARN: Atributo phoneNumber ya existe"
appwrite databases create-float-attribute --database-id 67fe874f00007b6702ed --collection-id locations --key latitude --required false || echo "WARN: Atributo latitude ya existe"
appwrite databases create-float-attribute --database-id 67fe874f00007b6702ed --collection-id locations --key longitude --required false || echo "WARN: Atributo longitude ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id locations --key operatingHours --size 500 --required false || echo "WARN: Atributo operatingHours ya existe"
appwrite databases create-url-attribute --database-id 67fe874f00007b6702ed --collection-id locations --key mapUrl --required false || echo "WARN: Atributo mapUrl ya existe"

# Colección: testimonials
echo "  Creando: testimonials..."
appwrite databases create-collection --database-id 67fe874f00007b6702ed --collection-id testimonials --name Testimonials --permissions 'read("any")' 'create("team:67fe88eb001a969f1dba")' 'update("team:67fe88eb001a969f1dba")' 'delete("team:67fe88eb001a969f1dba")' --document-security false --enabled true || echo "WARN: Colección testimonials ya existe o falló su creación"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id testimonials --key patientName --size 100 --required true || echo "WARN: Atributo patientName ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id testimonials --key quote --size 1000 --required true || echo "WARN: Atributo quote ya existe"
appwrite databases create-integer-attribute --database-id 67fe874f00007b6702ed --collection-id testimonials --key rating --required false --min 1 --max 5 || echo "WARN: Atributo rating ya existe"
appwrite databases create-datetime-attribute --database-id 67fe874f00007b6702ed --collection-id testimonials --key dateReceived --required true || echo "WARN: Atributo dateReceived ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id testimonials --key relatedDoctorId --size 512 --required false || echo "WARN: Atributo relatedDoctorId ya existe"
appwrite databases create-string-attribute --database-id 67fe874f00007b6702ed --collection-id testimonials --key relatedServiceId --size 512 --required false || echo "WARN: Atributo relatedServiceId ya existe"
appwrite databases create-boolean-attribute --database-id 67fe874f00007b6702ed --collection-id testimonials --key isApproved --required true --default false || echo "WARN: Atributo isApproved ya existe"

echo "Colecciones y Atributos creados."


# --- Crear Índices ---
echo "[FASE 3/3] Creando Índices..."
sleep 5

echo "  Índices para: patientInfo..."
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id patientInfo --key idx_pat_userId --type key --attributes userId --orders ASC || echo "WARN: Índice idx_pat_userId pudo fallar"

echo "  Índices para: specialties..."
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id specialties --key idx_spec_name --type key --attributes name --orders ASC || echo "WARN: Índice idx_spec_name pudo fallar"

echo "  Índices para: doctors..."
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id doctors --key idx_doc_name --type key --attributes name --orders ASC || echo "WARN: Índice idx_doc_name pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id doctors --key idx_doc_specialtyId --type key --attributes specialtyId --orders ASC || echo "WARN: Índice idx_doc_specialtyId pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id doctors --key idx_doc_isActive --type key --attributes isActive --orders ASC || echo "WARN: Índice idx_doc_isActive pudo fallar"

echo "  Índices para: doctorAvailabilitySlots..."
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id doctorAvailabilitySlots --key idx_slot_doctorId_startTime --type key --attributes doctorId,startTime --orders ASC,ASC || echo "WARN: Índice COMPUESTO idx_slot_doctorId_startTime pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id doctorAvailabilitySlots --key idx_slot_status --type key --attributes status --orders ASC || echo "WARN: Índice idx_slot_status pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id doctorAvailabilitySlots --key idx_slot_appointmentId --type key --attributes appointmentId --orders ASC || echo "WARN: Índice idx_slot_appointmentId pudo fallar"

echo "  Índices para: appointments..."
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id appointments --key idx_app_patientId --type key --attributes patientId --orders ASC || echo "WARN: Índice idx_app_patientId pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id appointments --key idx_app_doctorId --type key --attributes doctorId --orders ASC || echo "WARN: Índice idx_app_doctorId pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id appointments --key idx_app_availabilitySlotId_unique --type unique --attributes availabilitySlotId --orders ASC || echo "WARN: Índice ÚNICO idx_app_availabilitySlotId_unique pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id appointments --key idx_app_status --type key --attributes status --orders ASC || echo "WARN: Índice idx_app_status pudo fallar"

echo "  Índices para: services..."
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id services --key idx_serv_name --type key --attributes name --orders ASC || echo "WARN: Índice idx_serv_name pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id services --key idx_serv_specialtyId --type key --attributes specialtyId --orders ASC || echo "WARN: Índice idx_serv_specialtyId pudo fallar"

echo "  Índices para: articles..."
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id articles --key idx_art_title --type key --attributes title --orders ASC || echo "WARN: Índice idx_art_title pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id articles --key idx_art_slug_unique --type unique --attributes slug --orders ASC || echo "WARN: Índice ÚNICO idx_art_slug_unique pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id articles --key idx_art_authorDoctorId --type key --attributes authorDoctorId --orders ASC || echo "WARN: Índice idx_art_authorDoctorId pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id articles --key idx_art_publishDate --type key --attributes publishDate --orders DESC || echo "WARN: Índice idx_art_publishDate pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id articles --key idx_art_category --type key --attributes category --orders ASC || echo "WARN: Índice idx_art_category pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id articles --key idx_art_status --type key --attributes status --orders ASC || echo "WARN: Índice idx_art_status pudo fallar"

echo "  Índices para: testimonials..."
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id testimonials --key idx_test_relatedDoctorId --type key --attributes relatedDoctorId --orders ASC || echo "WARN: Índice idx_test_relatedDoctorId pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id testimonials --key idx_test_relatedServiceId --type key --attributes relatedServiceId --orders ASC || echo "WARN: Índice idx_test_relatedServiceId pudo fallar"
appwrite databases create-index --database-id 67fe874f00007b6702ed --collection-id testimonials --key idx_test_isApproved --type key --attributes isApproved --orders ASC || echo "WARN: Índice idx_test_isApproved pudo fallar"

echo "Creación de índices completada."
echo "====================================================="
echo "--- ¡Proceso completado! ---"
echo "--- REVISA LA SALIDA POR ERRORES O ADVERTENCIAS ---"
echo "--- VERIFICA LA ESTRUCTURA EN LA CONSOLA WEB DE APPWRITE ---"
echo "====================================================="
echo "ACCIONES IMPORTANTES POST-SCRIPT:"
echo "1. Configura permisos de Documento para 'patientInfo' y 'appointments'."
echo "2. Revisa la seguridad de las reservas."
echo "3. Filtra artículos por status ('published') y testimoniales por 'isApproved'."
echo "====================================================="