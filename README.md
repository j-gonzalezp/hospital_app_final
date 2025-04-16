      
# 🏥 Aplicación Web Moderna para Hospital (Next.js 15, Appwrite, Docker, Vercel)

Aplicación web completa, responsive y contenerizada desarrollada para un hospital privado moderno. Centrada en el paciente, muestra servicios, personal médico, recursos y facilita la interacción del usuario, destacando un sistema robusto de **programación de citas basado en disponibilidad de slots**. Construida con **Next.js 15 (App Router)**, TypeScript, Tailwind CSS y un backend **Appwrite** (Cloud). El proyecto incluye containerización con **Docker** y despliegue optimizado en **Vercel**.

[![Next.js](https://img.shields.io/badge/Next.js-15-black?style=flat-square&logo=nextdotjs)](https://nextjs.org/) [![TypeScript](https://img.shields.io/badge/TypeScript-5-blue?style=flat-square&logo=typescript)](https://www.typescriptlang.org/) [![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-3-38B2AC?style=flat-square&logo=tailwind-css)](https://tailwindcss.com/) [![Appwrite](https://img.shields.io/badge/Appwrite-Cloud-pink?style=flat-square&logo=appwrite)](https://appwrite.io/) [![Docker](https://img.shields.io/badge/Docker-Ready-blue?style=flat-square&logo=docker)](https://www.docker.com/) [![Vercel](https://img.shields.io/badge/Deploy-Vercel-black?style=flat-square&logo=vercel)](https://vercel.com/)

**[🔗 Ver Demo en Vivo (Vercel)]** `https://hospital-app-final.vercel.app/`
**[📦 Ver Repositorio (GitHub)]** `https://github.com/j-gonzalezp/hospital_app_final/`

## Tabla de Contenidos

*   [Características Principales](#características-principales)
*   [Stack Tecnológico](#stack-tecnológico)
*   [Estructura del Proyecto](#estructura-del-proyecto)
*   [Configuración Local](#configuración-local)
    *   [Pre-requisitos](#pre-requisitos)
    *   [Instalación](#instalación)
    *   [Variables de Entorno](#variables-de-entorno)
    *   [Ejecutar Desarrollo](#ejecutar-desarrollo)
*   [Backend (Appwrite)](#backend-appwrite)
    *   [Configuración](#configuración)
    *   [Estructura de la Base de Datos](#estructura-de-la-base-de-datos)
    *   [Lógica Clave: Disponibilidad y Citas](#lógica-clave-disponibilidad-y-citas)
*   [Docker](#docker)
    *   [Construir la Imagen](#construir-la-imagen)
    *   [Ejecutar el Contenedor](#ejecutar-el-contenedor)
*   [Despliegue (Vercel)](#despliegue-vercel)
*   [Próximos Pasos (Opcional)](#próximos-pasos-opcional)

## Características Principales ✨

*   **Homepage Dinámica:** Presentación atractiva con secciones destacadas (Servicios, Doctores, Testimonios, Ubicación).
*   **Buscador de Doctores:** Filtro por nombre y especialidad, perfiles detallados de doctores.
*   **Servicios y Especialidades:** Listado y páginas de detalle para cada servicio/especialidad.
*   **Sistema de Citas Avanzado:**
    *   Visualización de slots de disponibilidad por doctor y fecha.
    *   Reserva de citas seleccionando un slot disponible.
    *   Dashboard "Mis Citas" para pacientes registrados.
    *   Funcionalidad para cancelar citas (liberando el slot).
*   **Recursos de Salud:** Listado y vista detallada de artículos informativos.
*   **Ubicaciones:** Listado de información de contacto y detalles.
*   **Autenticación de Usuarios:** Registro e inicio de sesión para pacientes (Appwrite Auth).
*   **Páginas Informativas:** "About Us", "Contact Us" (con formulario), "Patients & Visitors Hub".
*   **Diseño Responsive:** Totalmente adaptable a móviles, tablets y escritorios.
*   **Tema Claro/Oscuro:** Mediante variables CSS y preferencia del sistema.
*   **Contenerizado:** Imagen Docker optimizada lista para usar (aunque desplegado en Vercel).
*   **CI/CD:** Despliegue automático en Vercel en cada push a `main`.

## Stack Tecnológico 🛠️

*   **Framework Frontend:** [Next.js](https://nextjs.org/) 15 (App Router) con [TypeScript](https://www.typescriptlang.org/)
*   **Estilos:** [Tailwind CSS](https://tailwindcss.com/) (v3, configuración por defecto, `globals.css` con variables CSS)
*   **Gestión de Estado (Frontend):** React Hooks, Server Components, Server Actions
*   **Backend y Base de Datos:** [Appwrite](https://appwrite.io/) (Cloud)
*   **Contenerización:** [Docker](https://www.docker.com/) (Dockerfile preparado)
*   **Despliegue:** [Vercel](https://vercel.com/)
*   **CI/CD:** Vercel CI/CD (Integración Git)
*   **Control de Versiones:** Git y [GitHub](https://github.com/)
*   **Iconos:** [Lucide React](https://lucide.dev/)

## Estructura del Proyecto 📂

    

IGNORE_WHEN_COPYING_START
Use code with caution.Markdown
IGNORE_WHEN_COPYING_END

hospital-web-app/
├── .dockerignore
├── .env.local.example # Ejemplo de variables de entorno
├── .eslintrc.json
├── .github/ # Opcional: Workflows si se usó GHCR
│ └── workflows/
│ └── deploy.yml
├── .gitignore
├── Dockerfile # Configuración para Docker
├── next.config.mjs # Configuración de Next.js (output: 'standalone')
├── package.json
├── postcss.config.mjs
├── public/ # Assets estáticos
│ ├── icons/
│ └── images/
├── README.md # Este archivo
├── src/
│ ├── app/ # App Router: Rutas, Páginas, Layouts
│ │ ├── (auth)/
│ │ ├── (main)/
│ │ ├── globals.css
│ │ ├── layout.tsx # Layout Raíz
│ │ └── not-found.tsx
│ ├── components/ # Componentes React reutilizables
│ ├── hooks/ # Hooks personalizados (useAuth)
│ ├── lib/ # Lógica central, utils, SDKs
│ │ ├── actions.ts # Server Actions
│ │ └── appwrite.ts # Cliente Appwrite SDK
│ └── types/ # Definiciones TypeScript
└── tsconfig.json

      
## Configuración Local 🚀

Sigue estos pasos para ejecutar el proyecto en tu máquina local.

### Pre-requisitos

*   Node.js (v18+)
*   npm (o gestor de paquetes compatible)
*   Git
*   Docker (Opcional, para pruebas locales del contenedor)
*   Instancia de Appwrite Cloud configurada.

### Instalación

1.  **Clona:** `git clone https://github.com/j-gonzalezp/hospital_app_final.git`
2.  **Navega:** `cd hospital_app_final`
3.  **Instala:** `npm install`

### Variables de Entorno

1.  Crea un archivo `.env.local` en la raíz.
2.  Copia y pega las claves necesarias (ver ejemplo abajo o `src/lib/appwrite.ts`).
3.  Rellena los valores con los IDs y endpoint de **tu propio proyecto Appwrite**.

    ```env
    # .env.local - ¡Usa tus propios valores!

    NEXT_PUBLIC_APPWRITE_ENDPOINT="https://cloud.appwrite.io/v1"
    NEXT_PUBLIC_APPWRITE_PROJECT_ID="TU_PROJECT_ID"          # Reemplaza con tu ID
    NEXT_PUBLIC_APPWRITE_DATABASE_ID="TU_DATABASE_ID"        # Reemplaza con tu ID
    NEXT_PUBLIC_ASSETS_BUCKET_ID="TU_BUCKET_ID"              # Reemplaza con tu ID
    NEXT_PUBLIC_COLLECTION_ID_TESTIMONIALS="TU_ID_TESTIMONIALS" # Reemplaza...
    NEXT_PUBLIC_COLLECTION_ID_LOCATIONS="TU_ID_LOCATIONS"       # Reemplaza...
    NEXT_PUBLIC_COLLECTION_ID_SERVICES="TU_ID_SERVICES"         # Reemplaza...
    NEXT_PUBLIC_COLLECTION_ID_APPOINTMENTS="TU_ID_APPOINTMENTS" # Reemplaza...
    NEXT_PUBLIC_COLLECTION_ID_DOCTORS="TU_ID_DOCTORS"           # Reemplaza...
    NEXT_PUBLIC_COLLECTION_ID_SPECIALTIES="TU_ID_SPECIALTIES"   # Reemplaza...
    NEXT_PUBLIC_COLLECTION_ID_PATIENTINFO="TU_ID_PATIENTINFO"   # Reemplaza...
    NEXT_PUBLIC_COLLECTION_ID_AVAILABILITYSLOTS="TU_ID_AVAILABILITYSLOTS" # Reemplaza...
    NEXT_PUBLIC_COLLECTION_ID_ARTICLES="TU_ID_ARTICLES"         # Reemplaza...
    ```

### Ejecutar Desarrollo

```bash
npm run dev

    

IGNORE_WHEN_COPYING_START
Use code with caution.
IGNORE_WHEN_COPYING_END

Abre http://localhost:3000.
Backend (Appwrite) ☁️
Configuración

Es necesario configurar un proyecto en Appwrite Cloud con:

    Autenticación: Proveedor Email/Password habilitado.

    Base de Datos: Una base de datos creada.

    Colecciones: Ver sección abajo, con atributos, índices y permisos adecuados.

    Storage: Un bucket para assets (app_files o el ID que definas).

    Plataformas Web: Añadir http://localhost:3000 (desarrollo) y https://hospital-app-final.vercel.app (producción) como plataformas web en la configuración del proyecto Appwrite.

Estructura de la Base de Datos

    Colecciones: users (Auth), doctors, specialties, services, doctorAvailabilitySlots, appointments, locations, articles, testimonials, patientInfo.

    Bucket: app_files (o el nombre/ID definido) para imágenes.

¡Importante sobre Índices y Permisos!

    Se requieren índices en Appwrite para queries eficientes (ej: en doctorAvailabilitySlots sobre doctorId, status, startTime; en articles sobre slug[único], status, publishDate; en doctors sobre isActive, name, specialtyId; en testimonials sobre isApproved).

    Permisos role:all (read) para colecciones públicas (doctors, services, specialties, locations, articles publicados, testimonials aprobados).

    Permisos específicos (role:member, user:USER_ID) para colecciones privadas (appointments, patientInfo).

    Permisos role:member (read, update) para doctorAvailabilitySlots (considerar Appwrite Function a futuro).

    Permisos role:all (read) para el bucket de Storage.

Lógica Clave: Disponibilidad y Citas 📅

El sistema de citas se basa en la colección doctorAvailabilitySlots.

    Disponibilidad: Se consultan los slots con status: 'available' para un doctor y fecha específicos.

    Reserva: Una Server Action verifica el slot, crea la cita en appointments (status: 'scheduled'), y actualiza el slot a status: 'booked' enlazando la cita.

    Cancelación: Una Server Action cambia el estado de la cita a 'cancelled' y revierte el estado del slot a 'available'.

Docker 🐳

Se incluye un Dockerfile multi-stage para construir una imagen de producción optimizada usando output: 'standalone'.
Construir la Imagen

Pasar las variables NEXT_PUBLIC_... como argumentos de build:

      
docker build \
  --build-arg NEXT_PUBLIC_APPWRITE_ENDPOINT="VALOR" \
  --build-arg NEXT_PUBLIC_APPWRITE_PROJECT_ID="VALOR" \
  # ... (añadir --build-arg para TODAS las NEXT_PUBLIC_...) ... \
  -t hospital-web-app .

    

IGNORE_WHEN_COPYING_START
Use code with caution.Bash
IGNORE_WHEN_COPYING_END
Ejecutar el Contenedor

Pasar las variables NEXT_PUBLIC_... como variables de entorno al contenedor:

      
docker run --rm -p 3000:3000 \
  -e NODE_ENV="production" \
  -e NEXT_PUBLIC_APPWRITE_ENDPOINT="VALOR" \
  -e NEXT_PUBLIC_APPWRITE_PROJECT_ID="VALOR" \
  # ... (añadir -e para TODAS las NEXT_PUBLIC_...) ... \
  hospital-web-app

    

IGNORE_WHEN_COPYING_START
Use code with caution.Bash
IGNORE_WHEN_COPYING_END

(Reemplaza "VALOR" con tus datos reales y hospital-web-app si usaste otro tag)
Despliegue (Vercel) ▲

La aplicación está desplegada en Vercel y configurada para CI/CD.

    Importar Proyecto: Importar el repositorio Git (https://github.com/j-gonzalezp/hospital_app_final/) en Vercel.

    Framework: Vercel detecta Next.js.

    Variables de Entorno: Configurar TODAS las variables NEXT_PUBLIC_... requeridas (Endpoint, Project ID, Database ID, Collection IDs, Bucket ID) en la configuración del proyecto en Vercel (Settings -> Environment Variables).

    Build & Deploy: Vercel maneja el build (next build) y el despliegue automáticamente en cada push a la rama main.

URL de Producción: https://hospital-app-final.vercel.app/