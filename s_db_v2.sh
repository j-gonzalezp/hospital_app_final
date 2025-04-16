#!/bin/bash

# --- IDs HARCODEADOS ---
# Database ID: 67fe874f00007b6702ed
# Admin Team ID: 67fe88eb001a969f1dba
# Editor Team ID: 67c751eb0036f432765f
# --- ------------- ---

# --- Variables ---
DB_ID="67fe874f00007b6702ed"
ADMIN_TEAM="team:67fe88eb001a969f1dba"
EDITOR_TEAM="team:67c751eb0036f432765f"
BUCKET_ID="app_files"
# Ajusta estos sleeps si sigues teniendo problemas de timing
ATTRIBUTE_SLEEP=2 # Segundos de espera DESPUÉS de crear CADA atributo
SHORT_SLEEP=1     # Segundos de espera después de crear colección
DELETE_SLEEP=3    # Segundos de espera después de eliminar todo
LONG_SLEEP=5      # Segundos de espera antes de crear índices

# --- Nombres de las Colecciones (para facilitar eliminación) ---
COLLECTIONS=(
    "patientInfo"
    "specialties"
    "doctors"
    "doctorAvailabilitySlots"
    "appointments"
    "services"
    "articles"
    "locations"
    "testimonials"
)

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!                 A D V E R T E N C I A           !!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "Este script PRIMERO intentará ELIMINAR PERMANENTEMENTE"
echo "el bucket '${BUCKET_ID}' y las siguientes colecciones:"
for col in "${COLLECTIONS[@]}"; do
  echo "  - ${col}"
done
echo "en la base de datos '${DB_ID}' ANTES de recrearlos."
echo "TODOS LOS DATOS en ellos se PERDERÁN."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "NOTA: La opción --default ha sido ELIMINADA para booleanos/enums"
echo "      debido a errores. Deberás configurarlos MANUALMENTE después."
echo "NOTA: Se añadió una pausa de ${ATTRIBUTE_SLEEP}s después de crear cada atributo."
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

# --- Confirmación del Usuario ---
read -p "¿Estás ABSOLUTAMENTE SEGURO de que quieres continuar? (escribe 'si' para proceder): " CONFIRMATION
if [[ "$CONFIRMATION" != "si" ]]; then
  echo "Operación cancelada por el usuario."
  exit 1
fi

echo "--- Iniciando configuración v2.2 (MODO RECREACIÓN + Fixes) ---"
# ... (resto de los echos iniciales) ...

# --- FASE 0: Eliminar Recursos Existentes ---
echo "[FASE 0/4] Eliminando Recursos Existentes (si los hubiera)..."
# ... (Código de eliminación igual que antes) ...
# Eliminar Bucket
echo "  Eliminando bucket: ${BUCKET_ID}..."
appwrite storage delete-bucket --bucket-id "${BUCKET_ID}" --yes || echo "WARN: Bucket '${BUCKET_ID}' no existe o falló su eliminación." # Added --yes to skip interactive prompt if CLI supports it

# Eliminar Colecciones
echo "  Eliminando colecciones..."
for col_id in "${COLLECTIONS[@]}"; do
    echo "    Eliminando colección: ${col_id}..."
    appwrite databases delete-collection --database-id "${DB_ID}" --collection-id "${col_id}" --yes || echo "WARN: Colección '${col_id}' no existe o falló su eliminación." # Added --yes
done

echo "Eliminación completada (o los elementos no existían)."
echo "Esperando ${DELETE_SLEEP}s para que Appwrite procese las eliminaciones..."
sleep ${DELETE_SLEEP}

# --- FASE 1: Crear Bucket ---
echo "[FASE 1/4] Creando Bucket Único '${BUCKET_ID}'..."
# ... (Código de creación de bucket igual que antes) ...
appwrite storage create-bucket \
  --bucket-id "${BUCKET_ID}" \
  --name 'Application Files (Profiles & Articles)' \
  --permissions "read(\"any\")" "create(\"${EDITOR_TEAM}\")" "create(\"${ADMIN_TEAM}\")" "update(\"${EDITOR_TEAM}\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${EDITOR_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" \
  --file-security true \
  --enabled true || echo "ERROR: Falló la creación del bucket '${BUCKET_ID}'. Verifica límites del plan o errores."
echo "Bucket '${BUCKET_ID}' creado."


# --- FASE 2: Crear Colecciones y Atributos ---
echo "[FASE 2/4] Creando Colecciones y Atributos..."

# --- Colección: patientInfo ---
echo "  Creando: patientInfo..."
appwrite databases create-collection --database-id "${DB_ID}" --collection-id patientInfo --name 'Patient Info' --permissions "read(\"${ADMIN_TEAM}\")" "create(\"${ADMIN_TEAM}\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" --document-security true --enabled true || echo "ERROR: Falló la creación de la colección patientInfo."
echo "  Esperando ${SHORT_SLEEP}s..."
sleep ${SHORT_SLEEP}
echo "    Creando atributos para: patientInfo..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key userId --size 512 --required true || echo "ERROR: patientInfo: Atributo userId falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id patientInfo --key dateOfBirth --required false || echo "ERROR: patientInfo: Atributo dateOfBirth falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key address --size 255 --required false || echo "ERROR: patientInfo: Atributo address falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key emergencyContactName --size 100 --required false || echo "ERROR: patientInfo: Atributo emergencyContactName falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key emergencyContactPhone --size 50 --required false || echo "ERROR: patientInfo: Atributo emergencyContactPhone falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key insuranceProvider --size 100 --required false || echo "ERROR: patientInfo: Atributo insuranceProvider falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key policyNumber --size 100 --required false || echo "ERROR: patientInfo: Atributo policyNumber falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key bloodType --size 10 --required false || echo "ERROR: patientInfo: Atributo bloodType falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id patientInfo --key allergies --size 500 --required false || echo "ERROR: patientInfo: Atributo allergies falló"
sleep ${ATTRIBUTE_SLEEP}

# --- Colección: specialties ---
echo "  Creando: specialties..."
appwrite databases create-collection --database-id "${DB_ID}" --collection-id specialties --name Specialties --permissions "read(\"any\")" "create(\"${ADMIN_TEAM}\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" --document-security false --enabled true || echo "ERROR: Falló la creación de la colección specialties."
echo "  Esperando ${SHORT_SLEEP}s..."
sleep ${SHORT_SLEEP}
echo "    Creando atributos para: specialties..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id specialties --key name --size 100 --required true || echo "ERROR: specialties: Atributo name falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id specialties --key description --size 1000 --required true || echo "ERROR: specialties: Atributo description falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-url-attribute --database-id "${DB_ID}" --collection-id specialties --key iconUrl --required false || echo "ERROR: specialties: Atributo iconUrl falló"
sleep ${ATTRIBUTE_SLEEP}

# --- Colección: doctors ---
echo "  Creando: doctors..."
appwrite databases create-collection --database-id "${DB_ID}" --collection-id doctors --name Doctors --permissions "read(\"any\")" "create(\"${ADMIN_TEAM}\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" --document-security false --enabled true || echo "ERROR: Falló la creación de la colección doctors."
echo "  Esperando ${SHORT_SLEEP}s..."
sleep ${SHORT_SLEEP}
echo "    Creando atributos para: doctors..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key name --size 100 --required true || echo "ERROR: doctors: Atributo name falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key specialtyId --size 512 --required true || echo "ERROR: doctors: Atributo specialtyId falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key qualifications --size 500 --required true || echo "ERROR: doctors: Atributo qualifications falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key bio --size 2000 --required false || echo "ERROR: doctors: Atributo bio falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-integer-attribute --database-id "${DB_ID}" --collection-id doctors --key yearsExperience --required false --min 0 || echo "ERROR: doctors: Atributo yearsExperience falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key profilePictureId --size 512 --required false || echo "ERROR: doctors: Atributo profilePictureId falló (apunta a '${BUCKET_ID}')"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctors --key languages --size 100 --required false --array true || echo "ERROR: doctors: Atributo languages falló"
sleep ${ATTRIBUTE_SLEEP}
# --default ELIMINADO - Configurar manualmente en la consola
appwrite databases create-boolean-attribute --database-id "${DB_ID}" --collection-id doctors --key isActive --required true || echo "ERROR: doctors: Atributo isActive falló (Default debe configurarse manualmente)"
sleep ${ATTRIBUTE_SLEEP}

# --- Colección: doctorAvailabilitySlots ---
echo "  Creando: doctorAvailabilitySlots..."
appwrite databases create-collection --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --name 'Doctor Availability Slots' \
  --permissions "read(\"any\")" "create(\"${ADMIN_TEAM}\")" "update(\"users\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" \
  --document-security false --enabled true || echo "ERROR: Falló la creación de la colección doctorAvailabilitySlots (check permissions syntax)"
echo "  Esperando ${SHORT_SLEEP}s..."
sleep ${SHORT_SLEEP}
echo "    Creando atributos para: doctorAvailabilitySlots..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key doctorId --size 512 --required true || echo "ERROR: doctorAvailabilitySlots: Atributo doctorId falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key startTime --required true || echo "ERROR: doctorAvailabilitySlots: Atributo startTime falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key endTime --required true || echo "ERROR: doctorAvailabilitySlots: Atributo endTime falló"
sleep ${ATTRIBUTE_SLEEP}
# --default ELIMINADO - Configurar manualmente en la consola
appwrite databases create-enum-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key status --elements '["available","booked","unavailable"]' --required true || echo "ERROR: doctorAvailabilitySlots: Atributo status falló (Default debe configurarse manually)"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key appointmentId --size 512 --required false || echo "ERROR: doctorAvailabilitySlots: Atributo appointmentId falló"
sleep ${ATTRIBUTE_SLEEP}

# --- Colección: appointments ---
echo "  Creando: appointments..."
appwrite databases create-collection --database-id "${DB_ID}" --collection-id appointments --name Appointments --permissions "read(\"${ADMIN_TEAM}\")" "create(\"users\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" --document-security true --enabled true || echo "ERROR: Falló la creación de la colección appointments."
echo "  Esperando ${SHORT_SLEEP}s..."
sleep ${SHORT_SLEEP}
echo "    Creando atributos para: appointments..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key patientId --size 512 --required true || echo "ERROR: appointments: Atributo patientId falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key doctorId --size 512 --required true || echo "ERROR: appointments: Atributo doctorId falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key availabilitySlotId --size 512 --required true || echo "ERROR: appointments: Atributo availabilitySlotId falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key reason --size 500 --required false || echo "ERROR: appointments: Atributo reason falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key notes --size 1000 --required false || echo "ERROR: appointments: Atributo notes falló"
sleep ${ATTRIBUTE_SLEEP}
# --default ELIMINADO - Configurar manualmente en la consola
appwrite databases create-enum-attribute --database-id "${DB_ID}" --collection-id appointments --key status --elements '["scheduled","completed","cancelled","no-show"]' --required true || echo "ERROR: appointments: Atributo status falló (Default debe configurarse manualmente)"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id appointments --key cancellationReason --size 255 --required false || echo "ERROR: appointments: Atributo cancellationReason falló"
sleep ${ATTRIBUTE_SLEEP}

# --- Colección: services ---
echo "  Creando: services..."
appwrite databases create-collection --database-id "${DB_ID}" --collection-id services --name Services --permissions "read(\"any\")" "create(\"${ADMIN_TEAM}\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" --document-security false --enabled true || echo "ERROR: Falló la creación de la colección services."
echo "  Esperando ${SHORT_SLEEP}s..."
sleep ${SHORT_SLEEP}
echo "    Creando atributos para: services..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id services --key name --size 255 --required true || echo "ERROR: services: Atributo name falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id services --key description --size 2000 --required true || echo "ERROR: services: Atributo description falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id services --key specialtyId --size 512 --required false || echo "ERROR: services: Atributo specialtyId falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id services --key costEstimate --size 50 --required false || echo "ERROR: services: Atributo costEstimate falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-integer-attribute --database-id "${DB_ID}" --collection-id services --key durationMinutes --required false || echo "ERROR: services: Atributo durationMinutes falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-url-attribute --database-id "${DB_ID}" --collection-id services --key imageUrl --required false || echo "ERROR: services: Atributo imageUrl falló"
sleep ${ATTRIBUTE_SLEEP}

# --- Colección: articles ---
echo "  Creando: articles..."
appwrite databases create-collection --database-id "${DB_ID}" --collection-id articles --name Articles \
  --permissions "read(\"any\")" "create(\"${EDITOR_TEAM}\")" "create(\"${ADMIN_TEAM}\")" "update(\"${EDITOR_TEAM}\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${EDITOR_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" \
  --document-security false --enabled true || echo "ERROR: Falló la creación de la colección articles (check permissions syntax)"
echo "  Esperando ${SHORT_SLEEP}s..."
sleep ${SHORT_SLEEP}
echo "    Creando atributos para: articles..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key title --size 255 --required true || echo "ERROR: articles: Atributo title falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key slug --size 255 --required true || echo "ERROR: articles: Atributo slug falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key content --size 50000 --required true || echo "ERROR: articles: Atributo content falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key excerpt --size 500 --required false || echo "ERROR: articles: Atributo excerpt falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key authorDoctorId --size 512 --required false || echo "ERROR: articles: Atributo authorDoctorId falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id articles --key publishDate --required true || echo "ERROR: articles: Atributo publishDate falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key category --size 50 --required false || echo "ERROR: articles: Atributo category falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key tags --size 50 --required false --array true || echo "ERROR: articles: Atributo tags falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id articles --key featuredImageId --size 512 --required false || echo "ERROR: articles: Atributo featuredImageId falló (apunta a '${BUCKET_ID}')"
sleep ${ATTRIBUTE_SLEEP}
# --default ELIMINADO - Configurar manualmente en la consola
appwrite databases create-enum-attribute --database-id "${DB_ID}" --collection-id articles --key status --elements '["draft","published"]' --required true || echo "ERROR: articles: Atributo status falló (Default debe configurarse manualmente)"
sleep ${ATTRIBUTE_SLEEP}

# --- Colección: locations ---
echo "  Creando: locations..."
appwrite databases create-collection --database-id "${DB_ID}" --collection-id locations --name Locations --permissions "read(\"any\")" "create(\"${ADMIN_TEAM}\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" --document-security false --enabled true || echo "ERROR: Falló la creación de la colección locations."
echo "  Esperando ${SHORT_SLEEP}s..."
sleep ${SHORT_SLEEP}
echo "    Creando atributos para: locations..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id locations --key name --size 100 --required true || echo "ERROR: locations: Atributo name falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id locations --key address --size 255 --required true || echo "ERROR: locations: Atributo address falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id locations --key phoneNumber --size 50 --required false || echo "ERROR: locations: Atributo phoneNumber falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-float-attribute --database-id "${DB_ID}" --collection-id locations --key latitude --required false || echo "ERROR: locations: Atributo latitude falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-float-attribute --database-id "${DB_ID}" --collection-id locations --key longitude --required false || echo "ERROR: locations: Atributo longitude falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id locations --key operatingHours --size 500 --required false || echo "ERROR: locations: Atributo operatingHours falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-url-attribute --database-id "${DB_ID}" --collection-id locations --key mapUrl --required false || echo "ERROR: locations: Atributo mapUrl falló"
sleep ${ATTRIBUTE_SLEEP}

# --- Colección: testimonials ---
echo "  Creando: testimonials..."
appwrite databases create-collection --database-id "${DB_ID}" --collection-id testimonials --name Testimonials --permissions "read(\"any\")" "create(\"${ADMIN_TEAM}\")" "update(\"${ADMIN_TEAM}\")" "delete(\"${ADMIN_TEAM}\")" --document-security false --enabled true || echo "ERROR: Falló la creación de la colección testimonials."
echo "  Esperando ${SHORT_SLEEP}s..."
sleep ${SHORT_SLEEP}
echo "    Creando atributos para: testimonials..."
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id testimonials --key patientName --size 100 --required true || echo "ERROR: testimonials: Atributo patientName falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id testimonials --key quote --size 1000 --required true || echo "ERROR: testimonials: Atributo quote falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-integer-attribute --database-id "${DB_ID}" --collection-id testimonials --key rating --required false --min 1 --max 5 || echo "ERROR: testimonials: Atributo rating falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-datetime-attribute --database-id "${DB_ID}" --collection-id testimonials --key dateReceived --required true || echo "ERROR: testimonials: Atributo dateReceived falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id testimonials --key relatedDoctorId --size 512 --required false || echo "ERROR: testimonials: Atributo relatedDoctorId falló"
sleep ${ATTRIBUTE_SLEEP}
appwrite databases create-string-attribute --database-id "${DB_ID}" --collection-id testimonials --key relatedServiceId --size 512 --required false || echo "ERROR: testimonials: Atributo relatedServiceId falló"
sleep ${ATTRIBUTE_SLEEP}
# --default ELIMINADO - Configurar manualmente en la consola
appwrite databases create-boolean-attribute --database-id "${DB_ID}" --collection-id testimonials --key isApproved --required true || echo "ERROR: testimonials: Atributo isApproved falló (Default debe configurarse manualmente)"
sleep ${ATTRIBUTE_SLEEP}

echo "Creación de Colecciones y Atributos completada."


# --- FASE 3: Crear Índices ---
echo "[FASE 3/4] Creando Índices (Esperando ${LONG_SLEEP}s)..."
sleep ${LONG_SLEEP}

# ... (Código de creación de índices igual que antes, pero ahora deberían tener más éxito
#      si los atributos correspondientes se crearon correctamente) ...

echo "  Índices para: patientInfo..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id patientInfo --key idx_pat_userId --type key --attributes userId --orders ASC || echo "ERROR: Índice idx_pat_userId falló"

echo "  Índices para: specialties..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id specialties --key idx_spec_name --type key --attributes name --orders ASC || echo "ERROR: Índice idx_spec_name falló"

echo "  Índices para: doctors..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctors --key idx_doc_name --type key --attributes name --orders ASC || echo "ERROR: Índice idx_doc_name falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctors --key idx_doc_specialtyId --type key --attributes specialtyId --orders ASC || echo "ERROR: Índice idx_doc_specialtyId falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctors --key idx_doc_isActive --type key --attributes isActive --orders ASC || echo "ERROR: Índice idx_doc_isActive falló (Atributo 'isActive' pudo haber fallado)"

echo "  Índices para: doctorAvailabilitySlots..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key idx_slot_doctorId_startTime --type key --attributes doctorId,startTime --orders ASC,ASC || echo "ERROR: Índice COMPUESTO idx_slot_doctorId_startTime falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key idx_slot_status --type key --attributes status --orders ASC || echo "ERROR: Índice idx_slot_status falló (Atributo 'status' pudo haber fallado)"
appwrite databases create-index --database-id "${DB_ID}" --collection-id doctorAvailabilitySlots --key idx_slot_appointmentId --type key --attributes appointmentId --orders ASC || echo "ERROR: Índice idx_slot_appointmentId falló"

echo "  Índices para: appointments..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id appointments --key idx_app_patientId --type key --attributes patientId --orders ASC || echo "ERROR: Índice idx_app_patientId falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id appointments --key idx_app_doctorId --type key --attributes doctorId --orders ASC || echo "ERROR: Índice idx_app_doctorId falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id appointments --key idx_app_availabilitySlotId_unique --type unique --attributes availabilitySlotId --orders ASC || echo "ERROR: Índice ÚNICO idx_app_availabilitySlotId_unique falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id appointments --key idx_app_status --type key --attributes status --orders ASC || echo "ERROR: Índice idx_app_status falló (Atributo 'status' pudo haber fallado)"

echo "  Índices para: services..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id services --key idx_serv_name --type key --attributes name --orders ASC || echo "ERROR: Índice idx_serv_name falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id services --key idx_serv_specialtyId --type key --attributes specialtyId --orders ASC || echo "ERROR: Índice idx_serv_specialtyId falló"

echo "  Índices para: articles..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_title --type key --attributes title --orders ASC || echo "ERROR: Índice idx_art_title falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_slug_unique --type unique --attributes slug --orders ASC || echo "ERROR: Índice ÚNICO idx_art_slug_unique falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_authorDoctorId --type key --attributes authorDoctorId --orders ASC || echo "ERROR: Índice idx_art_authorDoctorId falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_publishDate --type key --attributes publishDate --orders DESC || echo "ERROR: Índice idx_art_publishDate falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_category --type key --attributes category --orders ASC || echo "ERROR: Índice idx_art_category falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id articles --key idx_art_status --type key --attributes status --orders ASC || echo "ERROR: Índice idx_art_status falló (Atributo 'status' pudo haber fallado)"

echo "  Índices para: locations..."
# No hay índices definidos explícitamente para 'locations'.

echo "  Índices para: testimonials..."
appwrite databases create-index --database-id "${DB_ID}" --collection-id testimonials --key idx_test_relatedDoctorId --type key --attributes relatedDoctorId --orders ASC || echo "ERROR: Índice idx_test_relatedDoctorId falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id testimonials --key idx_test_relatedServiceId --type key --attributes relatedServiceId --orders ASC || echo "ERROR: Índice idx_test_relatedServiceId falló"
appwrite databases create-index --database-id "${DB_ID}" --collection-id testimonials --key idx_test_isApproved --type key --attributes isApproved --orders ASC || echo "ERROR: Índice idx_test_isApproved falló (Atributo 'isApproved' pudo haber fallado)"


echo "Creación de índices completada."
echo "====================================================="
echo "--- ¡Proceso de RECREACIÓN v2.2 completado! ---"
echo "--- REVISA CUIDADOSAMENTE LA SALIDA POR MENSAJES 'ERROR' ---"
echo "--- El error 'Cannot convert...' podría persistir si es un bug de CLI/timing ---"
echo "--- VERIFICA LA ESTRUCTURA FINAL EN LA CONSOLA WEB DE APPWRITE ---"
echo "====================================================="
echo "ACCIONES IMPORTANTES POST-SCRIPT:"
echo "1. **CONFIGURAR MANUALMENTE VALORES DEFAULT:** Ve a la consola Appwrite y establece los valores predeterminados para:"
echo "   - doctors -> isActive (true)"
echo "   - doctorAvailabilitySlots -> status ('available')"
echo "   - appointments -> status ('scheduled')"
echo "   - articles -> status ('draft')"
echo "   - testimonials -> isApproved (false)"
echo "2. Confirma que todas las colecciones, atributos (sin default problemáticos) e índices se crearon."
echo "3. Configura permisos a nivel de Documento si es necesario ('patientInfo', 'appointments')."
echo "4. Revisa la lógica y seguridad de las reservas (actualización de slots)."
echo "5. Recuerda que ahora solo existe el bucket '${BUCKET_ID}'."
echo "====================================================="