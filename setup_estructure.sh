#!/bin/bash

# Script para crear la estructura inicial de carpetas y archivos para el proyecto Hospital Web App.
# Ejecutar este script desde la raíz del directorio del proyecto (ej: hospital-web-app/).
# Asegúrate de haber ejecutado `npx create-next-app...` primero.

echo "🚀 Iniciando la creación de la estructura de carpetas y archivos..."

# --- Directorio `public` ---
echo "📁 Creando estructura en public/..."
mkdir -p public/icons
mkdir -p public/images
touch public/manifest.json
touch public/sw.js
# Puedes añadir iconos de marcador de posición si quieres:
# touch public/icons/icon-192x192.png
# touch public/icons/icon-512x512.png
echo "✅ Estructura de public/ creada."

# --- Directorio `src` ---
echo "📁 Creando estructura principal en src/..."
mkdir -p src/app
mkdir -p src/components
mkdir -p src/hooks
mkdir -p src/lib
mkdir -p src/types
# Nota: El directorio src/styles/ no se crea intencionalmente según los requisitos
# (globals.css está en src/app/globals.css).
echo "✅ Estructura principal de src/ creada."

# --- Estructura de `src/app` ---
echo "📁 Creando estructura en src/app/..."
# Grupos de rutas y páginas principales
mkdir -p src/app/'(auth)'/login
mkdir -p src/app/'(auth)'/register
mkdir -p src/app/'(main)'/about
mkdir -p src/app/'(main)'/appointments
mkdir -p src/app/'(main)'/contact
mkdir -p src/app/'(main)'/doctors/'[doctorId]'
mkdir -p src/app/'(main)'/locations
mkdir -p src/app/'(main)'/patients-visitors
mkdir -p src/app/'(main)'/resources/'[articleId]'
mkdir -p src/app/'(main)'/services/'[serviceId]'

# Archivos raíz de app y (main)
touch src/app/layout.tsx # Root Layout (ya debería existir, pero `touch` no sobrescribe)
touch src/app/loading.tsx
touch src/app/not-found.tsx
# touch src/app/globals.css # Ya debería existir

touch src/app/'(main)'/layout.tsx # Layout para la sección principal
touch src/app/'(main)'/page.tsx   # Homepage

# Archivos de página (page.tsx)
touch src/app/'(auth)'/login/page.tsx
touch src/app/'(auth)'/register/page.tsx
touch src/app/'(main)'/about/page.tsx
touch src/app/'(main)'/appointments/page.tsx
touch src/app/'(main)'/contact/page.tsx
touch src/app/'(main)'/doctors/page.tsx
touch src/app/'(main)'/doctors/'[doctorId]'/page.tsx
touch src/app/'(main)'/locations/page.tsx
touch src/app/'(main)'/patients-visitors/page.tsx
touch src/app/'(main)'/resources/page.tsx
touch src/app/'(main)'/resources/'[articleId]'/page.tsx
touch src/app/'(main)'/services/page.tsx
touch src/app/'(main)'/services/'[serviceId]'/page.tsx

# Opcional: Carpeta API (si se necesita más adelante)
# mkdir -p src/app/api/hello
# touch src/app/api/hello/route.ts

echo "✅ Estructura de src/app/ creada."

# --- Estructura de `src/components` ---
echo "📁 Creando estructura en src/components/..."
mkdir -p src/components/appointment
mkdir -p src/components/auth
mkdir -p src/components/common
mkdir -p src/components/doctors
mkdir -p src/components/layout
mkdir -p src/components/services

# Archivos de ejemplo o índices (opcional, descomentar si se desea)
# touch src/components/common/Button.tsx
# touch src/components/common/Card.tsx
# touch src/components/layout/Navbar.tsx
# touch src/components/layout/Footer.tsx
# touch src/components/appointment/BookingForm.tsx
# touch src/components/doctors/DoctorCard.tsx

echo "✅ Estructura de src/components/ creada."

# --- Estructura de `src/hooks` ---
echo "📁 Creando archivos en src/hooks/..."
touch src/hooks/useAuth.ts
touch src/hooks/useAppointments.ts
# touch src/hooks/useClickOutside.ts # Ejemplo
echo "✅ Archivos de src/hooks/ creados."

# --- Estructura de `src/lib` ---
echo "📁 Creando archivos en src/lib/..."
touch src/lib/appwrite.ts
touch src/lib/actions.ts
touch src/lib/utils.ts
touch src/lib/constants.ts
echo "✅ Archivos de src/lib/ creados."

# --- Estructura de `src/types` ---
echo "📁 Creando archivos en src/types/..."
touch src/types/appwrite.d.ts # Para tipos relacionados con Appwrite (ej: Models)
touch src/types/appointment.d.ts
touch src/types/doctor.d.ts
touch src/types/index.d.ts # Archivo general de tipos si es necesario
echo "✅ Archivos de src/types/ creados."

# --- Archivos Raíz del Proyecto y `src` ---
echo "📁 Creando archivos raíz adicionales..."
touch src/middleware.ts
touch Dockerfile
touch .env.local # Archivo para variables de entorno locales (¡NO LO SUBAS A GIT!)

echo "✅ Archivos raíz creados."

# --- Mensaje Final ---
echo ""
echo "🎉 ¡Estructura de carpetas y archivos creada exitosamente!"
echo "ℹ️ Recuerda añadir tu configuración de Appwrite y otras variables sensibles al archivo '.env.local'."
echo "ℹ️ El archivo 'src/app/globals.css' y 'src/app/layout.tsx' fueron creados por Next.js, este script asegura que existan otros archivos clave."
echo "ℹ️ Comienza a desarrollar los componentes y páginas."