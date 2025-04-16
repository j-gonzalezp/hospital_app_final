#!/bin/bash

# --- IDs Harcodeados y Configuración ---
DATABASE_ID_HARDCODED="67fe874f00007b6702ed"
ADMIN_TEAM_ID_HARDCODED="67fe88eb001a969f1dba"
SINGLE_USER_ID_HARDCODED="67feb9930029c07e4f5d" # <<< EL USER ID QUE PROPORCIONASTE
EDITOR_TEAM_ID_HARDCODED="67c751eb0036f432765f" # <<< TU EDITOR TEAM ID (o el de admin)
# --- Cantidad de Datos a Generar (Excepto Usuarios) ---
NUM_SPECIALTIES=5
NUM_DOCTORS=8
NUM_SERVICES_PER_SPECIALTY=3
NUM_SLOTS_PER_DOCTOR=10
NUM_APPOINTMENTS=5
NUM_ARTICLES=10
NUM_LOCATIONS=3
NUM_TESTIMONIALS=8
# --- FIN DE LA CONFIGURACIÓN ---

# --- VERIFICAR JQ (Recomendado) ---
if ! command -v jq &> /dev/null; then
    echo "WARN: El comando 'jq' no se encontró. La extracción de IDs puede ser menos fiable."
    USE_JQ=false
else
    USE_JQ=true
fi

echo "--- Iniciando Población con Mock Data (Usuario Único Harcodeado - v2 Permisos Corregidos) ---"
echo "Usando Database ID: ${DATABASE_ID_HARDCODED}"
echo "Usando Admin Team ID: ${ADMIN_TEAM_ID_HARDCODED}"
echo "Usando ÚNICO User/Patient ID: ${SINGLE_USER_ID_HARDCODED}"
echo "====================================================="
echo "NOTA: NO se crearán nuevos usuarios."
echo "      Se usará la sintaxis de permisos actualizada ('any', 'users', etc.)."
echo "Presiona Ctrl+C ahora si no quieres continuar."
sleep 5
echo "====================================================="

# --- Función para extraer ID ---
extract_id() {
    local json_output="$1"
    local extracted_id=""
    if [ "$USE_JQ" = true ]; then
        extracted_id=$(echo "${json_output}" | jq -r '."$id"' 2>/dev/null)
    fi
    if [[ -z "$extracted_id" || "$extracted_id" == "null" ]]; then
        extracted_id=$(echo "${json_output}" | grep '"$id"' | head -n 1 | sed -e 's/.*"$id": "//' -e 's/",//' -e 's/"//')
    fi
    if [[ -n "$extracted_id" && "$extracted_id" != "null" && ${#extracted_id} -gt 5 ]]; then
        echo "$extracted_id"
    else
        echo ""
    fi
}

# --- Arrays para guardar IDs ---
declare -a patient_info_ids
declare -a specialty_ids
declare -a doctor_ids
declare -a slot_ids
declare -a available_slot_ids
declare -a appointment_ids
declare -a service_ids
declare -a article_ids
declare -a location_ids
declare -a testimonial_ids

# --- FASE 1: Crear Especialidades ---
echo "[FASE 1] Creando Especialidades..."
specialty_names=("Cardiology" "Neurology" "Orthopedics" "Pediatrics" "Oncology" "Dermatology" "Gastroenterology")
for i in $(seq 1 $NUM_SPECIALTIES); do
    s_name="${specialty_names[$((i-1)) % ${#specialty_names[@]}]} Mock #${i}"
    s_desc="Description for ${s_name}."
    s_icon="https://placehold.co/64x64/eee/ccc/png?text=${s_name:0:1}"
    data=$(printf '{"name": "%s", "description": "%s", "iconUrl": "%s"}' "$s_name" "$s_desc" "$s_icon")
    echo "  Creando especialidad ${s_name}..."
    # CORREGIDO: Usar read("any") en lugar de read("role:all")
    spec_json=$(appwrite databases create-document --database-id ${DATABASE_ID_HARDCODED} --collection-id specialties --document-id "unique()" --data "${data}" --permissions 'read("any")' --json)
    spec_id=$(extract_id "${spec_json}")
    if [[ -n "$spec_id" ]]; then
        specialty_ids+=("${spec_id}")
        echo "    -> Especialidad Creada ID: ${spec_id}"
    else
        echo "    WARN: No se pudo crear o extraer ID para la especialidad ${s_name}. Salida JSON: ${spec_json}"
    fi
    sleep 0.5
done
echo "Especialidades creadas: ${#specialty_ids[@]}"
if [ ${#specialty_ids[@]} -eq 0 ]; then echo "ERROR: No se crearon especialidades. Abortando."; exit 1; fi

# --- FASE 2: Crear Doctores ---
echo "[FASE 2] Creando Doctores..."
doctor_names=("Dr. Alice Smith" "Dr. Bob Johnson" "Dr. Carol White" "Dr. David Brown" "Dr. Eve Davis" "Dr. Frank Miller" "Dr. Grace Wilson" "Dr. Henry Moore")
qualifications_examples=("MD, FACC" "PhD, Neurologist" "MBBS, Orthopedic Surgeon" "MD, Pediatrician" "Oncology Specialist" "Dermatology Cert." "Gastroenterology Fellow")
languages_examples=("[\"English\"]" "[\"English\", \"Spanish\"]" "[\"English\", \"French\"]")
for i in $(seq 1 $NUM_DOCTORS); do
    doc_name="${doctor_names[$((i-1)) % ${#doctor_names[@]}]} Mock #${i}"
    rand_spec_idx=$(( RANDOM % ${#specialty_ids[@]} ))
    doc_spec_id="${specialty_ids[$rand_spec_idx]}"
    doc_quals="${qualifications_examples[$((i-1)) % ${#qualifications_examples[@]}]}"
    doc_bio="Bio for ${doc_name}. Specialist in ${doc_spec_id:0:8}..."
    doc_exp=$(( RANDOM % 25 + 1 ))
    doc_langs="${languages_examples[$((i-1)) % ${#languages_examples[@]}]}"
    doc_active="true"
    data=$(printf '{"name": "%s", "specialtyId": "%s", "qualifications": "%s", "bio": "%s", "yearsExperience": %d, "languages": %s, "isActive": %s}' \
        "$doc_name" "$doc_spec_id" "$doc_quals" "$doc_bio" "$doc_exp" "$doc_langs" "$doc_active")
    echo "  Creando doctor ${doc_name}..."
    # CORREGIDO: Usar read("any")
    doc_json=$(appwrite databases create-document --database-id ${DATABASE_ID_HARDCODED} --collection-id doctors --document-id "unique()" --data "${data}" --permissions 'read("any")' --json)
    doc_id=$(extract_id "${doc_json}")
    if [[ -n "$doc_id" ]]; then
        doctor_ids+=("${doc_id}")
        echo "    -> Doctor Creado ID: ${doc_id}"
    else
        echo "    WARN: No se pudo crear o extraer ID para el doctor ${doc_name}. Salida JSON: ${doc_json}"
    fi
    sleep 0.5
done
echo "Doctores creados: ${#doctor_ids[@]}"
if [ ${#doctor_ids[@]} -eq 0 ]; then echo "ERROR: No se crearon doctores. Abortando."; exit 1; fi

# --- FASE 3: Crear PatientInfo (Para el Usuario Único) ---
echo "[FASE 3] Creando Información para Paciente Único (${SINGLE_USER_ID_HARDCODED})..."
blood_types=("O+" "A+" "B+" "AB+" "O-" "A-" "B-" "AB-")
user_id="${SINGLE_USER_ID_HARDCODED}"
year=$(( RANDOM % 56 + 1950 ))
month=$(( RANDOM % 12 + 1 ))
day=$(( RANDOM % 28 + 1 ))
dob=$(printf "%d-%02d-%02dT00:00:00.000+00:00" $year $month $day)
address="456 Central Ave, Testville"
e_name="Emergency ${user_id:0:6}"
e_phone="555-9876"
ins_prov="Global Health Inc."
policy="GHI-${RANDOM}"
blood="${blood_types[$RANDOM % ${#blood_types[@]}]}"
allergies="Penicillin"
data=$(printf '{"userId": "%s", "dateOfBirth": "%s", "address": "%s", "emergencyContactName": "%s", "emergencyContactPhone": "%s", "insuranceProvider": "%s", "policyNumber": "%s", "bloodType": "%s", "allergies": "%s"}' \
    "$user_id" "$dob" "$address" "$e_name" "$e_phone" "$ins_prov" "$policy" "$blood" "$allergies")
echo "  Creando info para usuario ${user_id}..."
# Permisos user:ID ya son correctos
info_json=$(appwrite databases create-document --database-id ${DATABASE_ID_HARDCODED} --collection-id patientInfo --document-id "unique()" --data "${data}" --permissions "read(\"user:${user_id}\")" "update(\"user:${user_id}\")" --json)
info_id=$(extract_id "${info_json}")
if [[ -n "$info_id" ]]; then
    patient_info_ids+=("${info_id}")
    echo "    -> Info Paciente Creada ID: ${info_id}"
else
    echo "    WARN: No se pudo crear o extraer ID para info del usuario ${user_id}. Salida JSON: ${info_json}"
fi
echo "Información de paciente creada: ${#patient_info_ids[@]}"

# --- FASE 4: Crear Ubicaciones ---
echo "[FASE 4] Creando Ubicaciones..."
location_names=("Main Hospital Campus" "Downtown Clinic" "Westside Medical Center")
addresses=("1 Hospital Dr" "456 Main St" "789 Oak Ave")
for i in $(seq 1 $NUM_LOCATIONS); do
    loc_name="${location_names[$((i-1)) % ${#location_names[@]}]}"
    loc_addr="${addresses[$((i-1)) % ${#addresses[@]}]}"
    loc_phone="555-5678"
    loc_hours="Mon-Fri: 8am - 6pm"
    data=$(printf '{"name": "%s", "address": "%s", "phoneNumber": "%s", "operatingHours": "%s"}' \
        "$loc_name" "$loc_addr" "$loc_phone" "$loc_hours")
    echo "  Creando ubicación ${loc_name}..."
    # CORREGIDO: Usar read("any")
    loc_json=$(appwrite databases create-document --database-id ${DATABASE_ID_HARDCODED} --collection-id locations --document-id "unique()" --data "${data}" --permissions 'read("any")' --json)
    loc_id=$(extract_id "${loc_json}")
    if [[ -n "$loc_id" ]]; then
        location_ids+=("${loc_id}")
        echo "    -> Ubicación Creada ID: ${loc_id}"
    else
        echo "    WARN: No se pudo crear o extraer ID para la ubicación ${loc_name}. Salida JSON: ${loc_json}"
    fi
    sleep 0.5
done
echo "Ubicaciones creadas: ${#location_ids[@]}"

# --- FASE 5: Crear Servicios ---
echo "[FASE 5] Creando Servicios..."
service_base_names=("Consultation" "Check-up" "Procedure X" "Therapy Session" "Diagnostic Test")
for spec_id in "${specialty_ids[@]}"; do
    for j in $(seq 1 $NUM_SERVICES_PER_SPECIALTY); do
        serv_name="${service_base_names[$((j-1)) % ${#service_base_names[@]}]} (${spec_id:0:4}...)"
        serv_desc="Desc for ${serv_name}."
        serv_cost="$${RANDOM % 200 + 50}"
        serv_dur=$(( (RANDOM % 6 + 3) * 10 ))
        data=$(printf '{"name": "%s", "description": "%s", "specialtyId": "%s", "costEstimate": "%s", "durationMinutes": %d}' \
            "$serv_name" "$serv_desc" "$spec_id" "$serv_cost" "$serv_dur")
        echo "  Creando servicio ${serv_name}..."
         # CORREGIDO: Usar read("any")
        serv_json=$(appwrite databases create-document --database-id ${DATABASE_ID_HARDCODED} --collection-id services --document-id "unique()" --data "${data}" --permissions 'read("any")' --json)
        serv_id=$(extract_id "${serv_json}")
        if [[ -n "$serv_id" ]]; then
            service_ids+=("${serv_id}")
        else
            echo "    WARN: No se pudo crear o extraer ID para el servicio ${serv_name}. Salida JSON: ${serv_json}"
        fi
        sleep 0.2
    done
done
echo "Servicios creados: ${#service_ids[@]}"

# --- FASE 6: Crear Slots de Disponibilidad ---
echo "[FASE 6] Creando Slots de Disponibilidad..."
slot_duration_minutes=30
days_in_future=5
slots_per_day_per_doctor=$NUM_SLOTS_PER_DOCTOR
IS_GNU_DATE=$(date --version | grep -q 'GNU coreutils' && echo true || echo false)

for doc_id in "${doctor_ids[@]}"; do
    echo "  Creando slots para Doctor ID: ${doc_id:0:8}..."
    for d in $(seq 0 $((days_in_future - 1))); do
        # ... (lógica de cálculo de fecha - sin cambios) ...
        if [ "$IS_GNU_DATE" = true ]; then
             base_start_time_obj=$(date -u -d "+${d} days 09:00" +"%s" 2>/dev/null) || base_start_time_obj=$(date +%s)
        else
             base_start_time_obj=$(date +%s)
             if [ $d -eq 0 ] && [ $s -eq 1 ]; then echo "    WARN: Usando fechas/horas aproximadas para slots."; fi
        fi
        for s in $(seq 1 $slots_per_day_per_doctor); do
            slot_start_seconds=$(( base_start_time_obj + (s-1) * slot_duration_minutes * 60 ))
            slot_end_seconds=$(( slot_start_seconds + slot_duration_minutes * 60 ))
            if [ "$IS_GNU_DATE" = true ]; then
                start_iso=$(date -u -d "@${slot_start_seconds}" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null) || start_iso=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
                end_iso=$(date -u -d "@${slot_end_seconds}" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null) || end_iso=$(date -u -d "+${slot_duration_minutes} minutes" +"%Y-%m-%dT%H:%M:%SZ")
            else
                start_iso=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
                end_iso=$(date -u -d "+${slot_duration_minutes} minutes" +"%Y-%m-%dT%H:%M:%SZ")
            fi
            data=$(printf '{"doctorId": "%s", "startTime": "%s", "endTime": "%s", "status": "available"}' "$doc_id" "$start_iso" "$end_iso")
            # CORREGIDO: Usar read("any") y update("users")
            slot_json=$(appwrite databases create-document --database-id ${DATABASE_ID_HARDCODED} --collection-id doctorAvailabilitySlots --document-id "unique()" --data "${data}" --permissions 'read("any")' 'update("users")' --json)
            slot_id=$(extract_id "${slot_json}")
            if [[ -n "$slot_id" ]]; then
                slot_ids+=("${slot_id}")
                available_slot_ids+=("${slot_id}")
            else
                echo "    WARN: No se pudo crear o extraer ID para slot del doctor ${doc_id:0:8}. Salida JSON: ${slot_json}"
            fi
            sleep 0.1
        done
    done
done
echo "Slots creados: ${#slot_ids[@]}"
echo "Slots inicialmente disponibles: ${#available_slot_ids[@]}"
if [ ${#available_slot_ids[@]} -eq 0 ]; then echo "ERROR: No se crearon slots disponibles. No se pueden crear citas."; exit 1; fi

# --- FASE 7: Crear Citas (Appointments) para el Usuario Único ---
echo "[FASE 7] Creando Citas para Paciente Único (${SINGLE_USER_ID_HARDCODED})..."
reasons=("Check-up" "Follow-up" "Consultation" "Pain" "Feeling unwell")
appt_patient_id="${SINGLE_USER_ID_HARDCODED}"

for i in $(seq 1 $NUM_APPOINTMENTS); do
    rand_doctor_idx=$(( RANDOM % ${#doctor_ids[@]} ))
    appt_doctor_id="${doctor_ids[$rand_doctor_idx]}"

    if [ ${#available_slot_ids[@]} -gt 0 ]; then
        rand_slot_idx=$(( RANDOM % ${#available_slot_ids[@]} ))
        appt_slot_id="${available_slot_ids[$rand_slot_idx]}"
        available_slot_ids=("${available_slot_ids[@]:0:$rand_slot_idx}" "${available_slot_ids[@]:$((rand_slot_idx + 1))}")
        appt_reason="${reasons[$RANDOM % ${#reasons[@]}]}"
        appt_notes="Mock note ${i} for user ${appt_patient_id:0:6}."
        appt_status="scheduled"
        data=$(printf '{"patientId": "%s", "doctorId": "%s", "availabilitySlotId": "%s", "reason": "%s", "notes": "%s", "status": "%s"}' \
            "$appt_patient_id" "$appt_doctor_id" "$appt_slot_id" "$appt_reason" "$appt_notes" "$appt_status")
        echo "  Creando cita ${i} (Doctor: ${appt_doctor_id:0:8}, Slot: ${appt_slot_id:0:8})..."
        # Permisos user:ID ya son correctos
        appt_json=$(appwrite databases create-document --database-id ${DATABASE_ID_HARDCODED} --collection-id appointments --document-id "unique()" --data "${data}" --permissions "read(\"user:${appt_patient_id}\")" "update(\"user:${appt_patient_id}\")" --json)
        appt_id=$(extract_id "${appt_json}")
        if [[ -n "$appt_id" ]]; then
            appointment_ids+=("${appt_id}")
            echo "    -> Cita Creada ID: ${appt_id}"
            echo "      Actualizando slot ${appt_slot_id} a 'booked'..."
            slot_update_data=$(printf '{"status": "booked", "appointmentId": "%s"}' "$appt_id")
            # Actualizar el slot usando el ID del documento
            update_output=$(appwrite databases update-document --database-id ${DATABASE_ID_HARDCODED} --collection-id doctorAvailabilitySlots --document-id "${appt_slot_id}" --data "${slot_update_data}" --json 2>/dev/null)
            if ! extract_id "$update_output" > /dev/null ; then
                 echo "      WARN: Falló la actualización del slot ${appt_slot_id} a booked."
            fi
        else
            echo "    WARN: No se pudo crear o extraer ID para la cita ${i}. Salida JSON: ${appt_json}"
        fi
        sleep 0.5
    else
        echo "  WARN: No quedan slots disponibles en la lista temporal para crear más citas."
        break
    fi
done
echo "Citas creadas: ${#appointment_ids[@]}"

# --- FASE 8: Crear Artículos ---
echo "[FASE 8] Creando Artículos..."
categories=("Health Tips" "Hospital News" "Research" "Wellness")
tags_examples=("[\"Heart\", \"Prevention\"]" "[\"Brain\", \"New Tech\"]" "[\"Bones\", \"Recovery\"]" "[\"Kids\", \"Vaccines\"]" "[\"Cancer\", \"Treatment\"]")
for i in $(seq 1 $NUM_ARTICLES); do
    title="Mock Article ${i}: Stay Healthy"
    slug="mock-article-${i}-stay-healthy-$(date +%s%N)"
    content="<p>Content for article ${i}.</p>"
    excerpt="Summary for article ${i}."
    rand_doctor_idx=$(( RANDOM % ${#doctor_ids[@]} ))
    author_id="${doctor_ids[$rand_doctor_idx]}"
    pub_date=$(date -u -d "-${RANDOM % 30} days" +"%Y-%m-%dT%H:%M:%SZ")
    category="${categories[$RANDOM % ${#categories[@]}]}"
    tags="${tags_examples[$RANDOM % ${#tags_examples[@]}]}"
    status="published"
    data=$(printf '{"title": "%s", "slug": "%s", "content": "%s", "excerpt": "%s", "authorDoctorId": "%s", "publishDate": "%s", "category": "%s", "tags": %s, "status": "%s"}' \
        "$title" "$slug" "$content" "$excerpt" "$author_id" "$pub_date" "$category" "$tags" "$status")
    echo "  Creando artículo ${slug}..."
    # CORREGIDO: Usar read("any")
    article_json=$(appwrite databases create-document --database-id ${DATABASE_ID_HARDCODED} --collection-id articles --document-id "unique()" --data "${data}" --permissions 'read("any")' --json)
    article_id=$(extract_id "${article_json}")
    if [[ -n "$article_id" ]]; then
        article_ids+=("${article_id}")
    else
        echo "    WARN: No se pudo crear o extraer ID para el artículo ${slug}. Salida JSON: ${article_json}"
    fi
    sleep 0.3
done
echo "Artículos creados: ${#article_ids[@]}"

# --- FASE 9: Crear Testimonios ---
echo "[FASE 9] Creando Testimonios..."
quotes=("Great experience!" "Staff was amazing." "Feeling much better!" "Highly recommend." "Very professional.")
for i in $(seq 1 $NUM_TESTIMONIALS); do
    patient_name="Testimonial Patient ${i}"
    quote="${quotes[$RANDOM % ${#quotes[@]}]}"
    rating=$(( RANDOM % 3 + 3 ))
    received_date=$(date -u -d "-${RANDOM % 90} days" +"%Y-%m-%dT%H:%M:%SZ")
    rel_doc_id=""
    rel_serv_id=""
    rand_choice=$((RANDOM % 3))
    if [ $rand_choice -eq 0 ] && [ ${#doctor_ids[@]} -gt 0 ]; then
        rand_doctor_idx=$(( RANDOM % ${#doctor_ids[@]} ))
        rel_doc_id="${doctor_ids[$rand_doctor_idx]}"
    elif [ $rand_choice -eq 1 ] && [ ${#service_ids[@]} -gt 0 ]; then
        rand_service_idx=$(( RANDOM % ${#service_ids[@]} ))
        rel_serv_id="${service_ids[$rand_service_idx]}"
    fi
    is_approved="true"
    data=$(printf '{"patientName": "%s", "quote": "%s", "rating": %d, "dateReceived": "%s", "relatedDoctorId": "%s", "relatedServiceId": "%s", "isApproved": %s}' \
        "$patient_name" "$quote" "$rating" "$received_date" "$rel_doc_id" "$rel_serv_id" "$is_approved")
    echo "  Creando testimonio ${i}..."
    # CORREGIDO: Usar read("any")
    test_json=$(appwrite databases create-document --database-id ${DATABASE_ID_HARDCODED} --collection-id testimonials --document-id "unique()" --data "${data}" --permissions 'read("any")' --json)
    test_id=$(extract_id "${test_json}")
    if [[ -n "$test_id" ]]; then
        testimonial_ids+=("${test_id}")
    else
        echo "    WARN: No se pudo crear o extraer ID para el testimonio ${i}. Salida JSON: ${test_json}"
    fi
    sleep 0.3
done
echo "Testimonios creados: ${#testimonial_ids[@]}"


echo "====================================================="
echo "--- ¡Población con Mock Data (Usuario Único - Permisos Corregidos) Completada! ---"
echo "--- REVISA LA SALIDA POR ERRORES O ADVERTENCIAS ---"
echo "====================================================="