#!/bin/bash

# Script para crear archivos de componentes iniciales con código base.
# Ejecutar desde la raíz del proyecto.

echo "🚀 Creando archivos de componentes base..."

# --- src/components/appointment ---
echo "📁 Creando componentes en src/components/appointment..."

mkdir -p src/components/appointment # Asegura que el directorio exista

# src/components/appointment/AppointmentCard.tsx (Display)
echo "import React from 'react';

interface AppointmentCardProps {
  // Define props: ej. appointment data
  appointment: any; // Reemplaza 'any' con un tipo específico
}

const AppointmentCard: React.FC<AppointmentCardProps> = ({ appointment }) => {
  return (
    <div className=\"border p-4 rounded shadow-md mb-4\">
      <h3 className=\"font-semibold\">Appointment Details</h3>
      {/* Muestra detalles del appointment */}
      <p>Doctor: {appointment.doctorName || 'N/A'}</p>
      <p>Date: {appointment.date || 'N/A'}</p>
      <p>Status: {appointment.status || 'N/A'}</p>
      {/* Añade más detalles y acciones (ej. cancelar) */}
    </div>
  );
};

export default AppointmentCard;" > src/components/appointment/AppointmentCard.tsx

# src/components/appointment/AppointmentList.tsx (Display, podría necesitar 'use client' si tiene filtros)
echo "import React from 'react';
import AppointmentCard from './AppointmentCard';

interface AppointmentListProps {
  appointments: any[]; // Reemplaza 'any[]' con un tipo específico
}

const AppointmentList: React.FC<AppointmentListProps> = ({ appointments }) => {
  if (!appointments || appointments.length === 0) {
    return <p>No appointments found.</p>;
  }

  return (
    <div className=\"space-y-4\">
      {appointments.map((app) => (
        <AppointmentCard key={app.id || Math.random()} appointment={app} />
      ))}
    </div>
  );
};

export default AppointmentList;" > src/components/appointment/AppointmentList.tsx

# src/components/appointment/BookingForm.tsx (Interactive -> Client Component)
echo "'use client';

import React, { useState } from 'react';
import Button from '@/components/common/Button';
import Select from '@/components/common/Select';
import Input from '@/components/common/Input';
// Importa AvailabilityCalendar y SlotSelector si los usas aquí

interface BookingFormProps {
  doctors: any[]; // Reemplaza con tipo Doctor
  availableSlots: any[]; // Reemplaza con tipo Slot
  onBookingSubmit: (formData: any) => void; // Define el tipo de formData
  onDateChange: (doctorId: string, date: string) => void; // Para cargar slots
  onDoctorChange: (doctorId: string) => void; // Para cargar slots iniciales o resetear fecha
}

const BookingForm: React.FC<BookingFormProps> = ({
  doctors,
  availableSlots,
  onBookingSubmit,
  onDateChange,
  onDoctorChange
}) => {
  const [selectedDoctor, setSelectedDoctor] = useState<string>('');
  const [selectedDate, setSelectedDate] = useState<string>('');
  const [selectedSlot, setSelectedSlot] = useState<string>('');
  const [reason, setReason] = useState<string>('');
  // Añade más estados según sea necesario (loading, error)

  const handleDoctorChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const doctorId = e.target.value;
    setSelectedDoctor(doctorId);
    setSelectedDate(''); // Resetea fecha al cambiar doctor
    setSelectedSlot('');
    onDoctorChange(doctorId); // Llama a la función para posible carga inicial
  };

  const handleDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const date = e.target.value;
    setSelectedDate(date);
    setSelectedSlot(''); // Resetea slot al cambiar fecha
    if (selectedDoctor && date) {
      onDateChange(selectedDoctor, date); // Carga slots para doctor y fecha
    }
  };

   const handleSlotChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setSelectedSlot(e.target.value);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedDoctor || !selectedSlot || !selectedDate) {
      alert('Please select a doctor, date, and time slot.');
      return;
    }
    onBookingSubmit({
      doctorId: selectedDoctor,
      availabilitySlotId: selectedSlot,
      date: selectedDate, // Podría extraerse del slot si el slot tiene fecha completa
      reason,
    });
  };

  return (
    <form onSubmit={handleSubmit} className=\"space-y-4 p-6 border rounded-lg shadow-sm\">
      <Select
        label=\"Select Doctor\"
        value={selectedDoctor}
        onChange={handleDoctorChange}
        required
      >
        <option value=\"\" disabled>-- Select a Doctor --</option>
        {doctors.map((doc) => (
          <option key={doc.id} value={doc.id}>{doc.name}</option>
        ))}
      </Select>

      <Input
        label=\"Select Date\"
        type=\"date\"
        value={selectedDate}
        onChange={handleDateChange}
        required
        disabled={!selectedDoctor} // Habilita solo si se eligió doctor
      />

      {/* Aquí podrías integrar AvailabilityCalendar o SlotSelector */}
      <Select
        label=\"Select Time Slot\"
        value={selectedSlot}
        onChange={handleSlotChange}
        required
        disabled={!selectedDate || availableSlots.length === 0} // Habilita si hay fecha y slots
      >
        <option value=\"\" disabled>-- Select a Time --</option>
        {availableSlots.map((slot) => (
           // Asegúrate que el 'value' sea el ID del slot de disponibilidad
          <option key={slot.id} value={slot.id}>
            {new Date(slot.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
          </option>
        ))}
         {selectedDate && availableSlots.length === 0 && <option disabled>No slots available for this date</option>}
      </Select>

      <Input
        label=\"Reason for Visit (Optional)\"
        type=\"text\"
        value={reason}
        onChange={(e) => setReason(e.target.value)}
        placeholder=\"Briefly describe the reason\"
      />

      <Button type=\"submit\" variant=\"primary\">Book Appointment</Button>
    </form>
  );
};

export default BookingForm;" > src/components/appointment/BookingForm.tsx

# src/components/appointment/AvailabilityCalendar.tsx (Interactive -> Client Component)
echo "'use client';

import React from 'react';

interface AvailabilityCalendarProps {
  doctorId: string;
  onDateSelect: (date: Date) => void;
  // Podría necesitar props para marcar días con disponibilidad
}

const AvailabilityCalendar: React.FC<AvailabilityCalendarProps> = ({ doctorId, onDateSelect }) => {
  // Aquí iría la lógica de un calendario (podrías usar una librería como react-calendar)
  // O un input[type=date] simplificado
  const handleDateChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    onDateSelect(new Date(event.target.value));
  };

  return (
    <div className=\"p-4 border rounded\">
      <label htmlFor='date-picker' className='block mb-2 text-sm font-medium text-gray-700'>Select Date:</label>
      <input
        id='date-picker'
        type=\"date\"
        onChange={handleDateChange}
        className=\"border p-2 rounded w-full\"
        // Añade lógica para deshabilitar fechas pasadas o sin disponibilidad
      />
      <p className=\"mt-2 text-sm text-gray-500\">Availability Calendar Placeholder (Implement with a library or custom logic)</p>
    </div>
  );
};

export default AvailabilityCalendar;" > src/components/appointment/AvailabilityCalendar.tsx

# src/components/appointment/SlotSelector.tsx (Interactive -> Client Component)
echo "'use client';

import React from 'react';

interface SlotSelectorProps {
  slots: { id: string; time: string; status: 'available' | 'booked' | 'unavailable' }[]; // Ajusta el tipo de slot
  selectedSlot: string | null;
  onSlotSelect: (slotId: string) => void;
}

const SlotSelector: React.FC<SlotSelectorProps> = ({ slots, selectedSlot, onSlotSelect }) => {
  if (!slots || slots.length === 0) {
    return <p className=\"text-gray-500 italic\">No available slots for the selected date.</p>;
  }

  return (
    <div className=\"space-y-2\">
      <h4 className=\"font-medium\">Available Slots:</h4>
      <div className=\"flex flex-wrap gap-2\">
        {slots.map((slot) => (
          <button
            key={slot.id}
            onClick={() => onSlotSelect(slot.id)}
            disabled={slot.status !== 'available'}
            className={`px-3 py-1 border rounded text-sm
              ${selectedSlot === slot.id ? 'bg-blue-500 text-white border-blue-500' : 'bg-white'}
              ${slot.status === 'available' ? 'hover:bg-blue-100 cursor-pointer' : 'bg-gray-200 text-gray-400 cursor-not-allowed'}
            `}
          >
            {slot.time} {/* Formatea la hora como necesites */}
          </button>
        ))}
      </div>
    </div>
  );
};

export default SlotSelector;" > src/components/appointment/SlotSelector.tsx

# src/components/appointment/CancelConfirmationModal.tsx (Interactive -> Client Component)
echo "'use client';

import React from 'react';
import Modal from '@/components/common/Modal';
import Button from '@/components/common/Button';

interface CancelConfirmationModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  appointmentDetails: any; // Reemplaza 'any' con tipo Appointment
}

const CancelConfirmationModal: React.FC<CancelConfirmationModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
  appointmentDetails
}) => {
  return (
    <Modal isOpen={isOpen} onClose={onClose} title=\"Confirm Cancellation\">
      <div className=\"p-4\">
        <p className=\"mb-4\">Are you sure you want to cancel the following appointment?</p>
        {/* Muestra detalles del appointment a cancelar */}
        <div className=\"mb-4 p-2 border rounded bg-gray-50 text-sm\">
          <p><strong>Doctor:</strong> {appointmentDetails?.doctorName || 'N/A'}</p>
          <p><strong>Date:</strong> {appointmentDetails?.date || 'N/A'}</p>
          <p><strong>Time:</strong> {appointmentDetails?.time || 'N/A'}</p>
        </div>
        <div className=\"flex justify-end space-x-3\">
          <Button onClick={onClose} variant=\"secondary\">
            Keep Appointment
          </Button>
          <Button onClick={onConfirm} variant=\"danger\">
            Yes, Cancel It
          </Button>
        </div>
      </div>
    </Modal>
  );
};

export default CancelConfirmationModal;" > src/components/appointment/CancelConfirmationModal.tsx

# --- src/components/auth ---
echo "📁 Creando componentes en src/components/auth..."
mkdir -p src/components/auth # Asegura que el directorio exista

# src/components/auth/LoginForm.tsx (Interactive -> Client Component)
echo "'use client';

import React, { useState } from 'react';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';
import Link from 'next/link';

interface LoginFormProps {
    onLogin: (credentials: any) => void; // Define el tipo de credentials
    loading?: boolean;
    error?: string | null;
}

const LoginForm: React.FC<LoginFormProps> = ({ onLogin, loading, error }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onLogin({ email, password });
  };

  return (
    <form onSubmit={handleSubmit} className=\"space-y-4 max-w-md mx-auto p-6 border rounded-lg shadow-sm\">
       <h2 className=\"text-2xl font-semibold text-center mb-6\">Login</h2>
      {error && <p className=\"text-red-500 text-sm text-center\">{error}</p>}
      <Input
        label=\"Email\"
        type=\"email\"
        id=\"login-email\"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
        autoComplete=\"email\"
      />
      <Input
        label=\"Password\"
        type=\"password\"
        id=\"login-password\"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
        autoComplete=\"current-password\"
      />
      <Button type=\"submit\" variant=\"primary\" fullWidth disabled={loading}>
        {loading ? 'Logging in...' : 'Login'}
      </Button>
       <p className=\"text-sm text-center text-gray-600\">
        Don't have an account?{' '}
        <Link href=\"/register\" className=\"text-blue-600 hover:underline\">
          Register here
        </Link>
      </p>
    </form>
  );
};

export default LoginForm;" > src/components/auth/LoginForm.tsx

# src/components/auth/RegisterForm.tsx (Interactive -> Client Component)
echo "'use client';

import React, { useState } from 'react';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';
import Link from 'next/link';

interface RegisterFormProps {
    onRegister: (userData: any) => void; // Define el tipo de userData
    loading?: boolean;
    error?: string | null;
}

const RegisterForm: React.FC<RegisterFormProps> = ({ onRegister, loading, error }) => {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  // Añade más campos si son necesarios (teléfono, etc.)

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (password !== confirmPassword) {
      alert('Passwords do not match!');
      return;
    }
    onRegister({ name, email, password });
  };

  return (
    <form onSubmit={handleSubmit} className=\"space-y-4 max-w-md mx-auto p-6 border rounded-lg shadow-sm\">
       <h2 className=\"text-2xl font-semibold text-center mb-6\">Register</h2>
      {error && <p className=\"text-red-500 text-sm text-center\">{error}</p>}
      <Input
        label=\"Full Name\"
        type=\"text\"
        id=\"register-name\"
        value={name}
        onChange={(e) => setName(e.target.value)}
        required
        autoComplete=\"name\"
      />
      <Input
        label=\"Email\"
        type=\"email\"
        id=\"register-email\"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
        autoComplete=\"email\"
      />
      <Input
        label=\"Password\"
        type=\"password\"
        id=\"register-password\"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
        minLength={8} // Appwrite default minimum
        autoComplete=\"new-password\"
      />
       <Input
        label=\"Confirm Password\"
        type=\"password\"
        id=\"register-confirm-password\"
        value={confirmPassword}
        onChange={(e) => setConfirmPassword(e.target.value)}
        required
         minLength={8}
        autoComplete=\"new-password\"
      />
      <Button type=\"submit\" variant=\"primary\" fullWidth disabled={loading}>
        {loading ? 'Registering...' : 'Register'}
      </Button>
       <p className=\"text-sm text-center text-gray-600\">
        Already have an account?{' '}
        <Link href=\"/login\" className=\"text-blue-600 hover:underline\">
          Login here
        </Link>
      </p>
    </form>
  );
};

export default RegisterForm;" > src/components/auth/RegisterForm.tsx


# --- src/components/common ---
echo "📁 Creando componentes en src/components/common..."
mkdir -p src/components/common # Asegura que el directorio exista

# src/components/common/Button.tsx (Interactive -> Client Component, por el onClick)
echo "'use client';

import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  fullWidth?: boolean;
  // Añade más props si necesitas (ej. leftIcon, rightIcon)
}

const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  className = '',
  ...props
}) => {
  const baseStyle = 'inline-flex items-center justify-center rounded-md font-medium focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed transition-colors duration-150';

  const variantStyles = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500',
    secondary: 'bg-gray-200 text-gray-800 hover:bg-gray-300 focus:ring-gray-400',
    danger: 'bg-red-600 text-white hover:bg-red-700 focus:ring-red-500',
    ghost: 'bg-transparent text-blue-600 hover:bg-blue-100 focus:ring-blue-500' // O ajusta según tu tema
  };

  const sizeStyles = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg'
  };

  const widthStyle = fullWidth ? 'w-full' : '';

  return (
    <button
      className={\`\${baseStyle} \${variantStyles[variant]} \${sizeStyles[size]} \${widthStyle} \${className}\`}
      {...props}
    >
      {children}
    </button>
  );
};

export default Button;" > src/components/common/Button.tsx

# src/components/common/Card.tsx (Display)
echo "import React from 'react';

interface CardProps {
  children: React.ReactNode;
  className?: string;
  // Añade props para variantes si es necesario (ej. con padding, sin borde)
}

const Card: React.FC<CardProps> = ({ children, className = '' }) => {
  return (
    <div className={\`bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden \${className}\`}>
      {children}
    </div>
  );
};

export default Card;" > src/components/common/Card.tsx

# src/components/common/Modal.tsx (Interactive -> Client Component)
echo "'use client';

import React, { useEffect } from 'react';
import { X } from 'lucide-react'; // Icono popular, instala `lucide-react`

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  children: React.ReactNode;
  title?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl';
}

const Modal: React.FC<ModalProps> = ({ isOpen, onClose, children, title, size = 'md' }) => {
  useEffect(() => {
    const handleEsc = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        onClose();
      }
    };
    if (isOpen) {
      document.body.style.overflow = 'hidden'; // Evita scroll del fondo
      window.addEventListener('keydown', handleEsc);
    } else {
      document.body.style.overflow = 'unset';
    }
    return () => {
      window.removeEventListener('keydown', handleEsc);
      document.body.style.overflow = 'unset';
    };
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  const sizeClasses = {
    sm: 'max-w-sm',
    md: 'max-w-md',
    lg: 'max-w-lg',
    xl: 'max-w-xl',
    // Añade más tamaños si necesitas
  };

  return (
    <div
      className=\"fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 backdrop-blur-sm transition-opacity duration-300 ease-in-out\"
      onClick={onClose} // Cierra al hacer clic fuera
      aria-labelledby=\"modal-title\"
      role=\"dialog\"
      aria-modal=\"true\"
    >
      <div
        className={\`bg-white rounded-lg shadow-xl w-full m-4 \${sizeClasses[size]} transform transition-all duration-300 ease-in-out scale-95 opacity-0 \${isOpen ? 'scale-100 opacity-100' : ''}\`}
        onClick={(e) => e.stopPropagation()} // Evita que el clic dentro cierre el modal
      >
        <div className=\"flex items-center justify-between p-4 border-b\">
          {title && <h2 id=\"modal-title\" className=\"text-lg font-semibold\">{title}</h2>}
          <button
            onClick={onClose}
            className=\"text-gray-400 hover:text-gray-600\"
            aria-label=\"Close modal\"
          >
            <X size={20} />
          </button>
        </div>
        <div>{children}</div>
      </div>
    </div>
  );
};

export default Modal;" > src/components/common/Modal.tsx

# src/components/common/Input.tsx (Interactive -> Client Component)
echo "'use client';

import React from 'react';

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  id: string; // ID es necesario para el 'htmlFor' del label
  error?: string | null;
  className?: string;
}

const Input: React.FC<InputProps> = ({ label, id, error, className = '', ...props }) => {
  const baseStyle = 'block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm';
  const errorStyle = error ? 'border-red-500 ring-red-500' : 'border-gray-300';

  return (
    <div className=\"w-full\">
      {label && (
        <label htmlFor={id} className=\"block text-sm font-medium text-gray-700 mb-1\">
          {label} {props.required && <span className=\"text-red-500\">*</span>}
        </label>
      )}
      <input
        id={id}
        className={\`\${baseStyle} \${errorStyle} \${className}\`}
        {...props}
      />
      {error && <p className=\"mt-1 text-xs text-red-500\">{error}</p>}
    </div>
  );
};

export default Input;" > src/components/common/Input.tsx

# src/components/common/Select.tsx (Interactive -> Client Component)
echo "'use client';

import React from 'react';

interface SelectProps extends React.SelectHTMLAttributes<HTMLSelectElement> {
  label?: string;
  id: string;
  error?: string | null;
  className?: string;
  children: React.ReactNode; // Opciones van aquí
}

const Select: React.FC<SelectProps> = ({ label, id, error, className = '', children, ...props }) => {
  const baseStyle = 'block w-full pl-3 pr-10 py-2 text-base border border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-md';
   const errorStyle = error ? 'border-red-500 ring-red-500' : 'border-gray-300';

  return (
     <div className=\"w-full\">
      {label && (
        <label htmlFor={id} className=\"block text-sm font-medium text-gray-700 mb-1\">
          {label} {props.required && <span className=\"text-red-500\">*</span>}
        </label>
      )}
      <select
        id={id}
        className={\`\${baseStyle} \${errorStyle} \${className}\`}
        {...props}
      >
        {children}
      </select>
       {error && <p className=\"mt-1 text-xs text-red-500\">{error}</p>}
    </div>
  );
};

export default Select;" > src/components/common/Select.tsx

# src/components/common/LoadingSpinner.tsx (Display)
echo "import React from 'react';

interface LoadingSpinnerProps {
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

const LoadingSpinner: React.FC<LoadingSpinnerProps> = ({ size = 'md', className = '' }) => {
  const sizeClasses = {
    sm: 'h-4 w-4',
    md: 'h-8 w-8',
    lg: 'h-12 w-12',
  };

  return (
    <div className={\`flex justify-center items-center \${className}\`}>
      <div
        className={\`animate-spin rounded-full border-t-2 border-b-2 border-blue-500 \${sizeClasses[size]}\`}
        role=\"status\"
        aria-live=\"polite\"
      >
         <span className=\"sr-only\">Loading...</span> {/* Accessibility */}
      </div>
    </div>
  );
};

export default LoadingSpinner;" > src/components/common/LoadingSpinner.tsx

# src/components/common/ErrorMessage.tsx (Display)
echo "import React from 'react';
import { AlertTriangle } from 'lucide-react'; // Icono opcional

interface ErrorMessageProps {
  message: string | null | undefined;
  className?: string;
}

const ErrorMessage: React.FC<ErrorMessageProps> = ({ message, className = '' }) => {
  if (!message) {
    return null;
  }

  return (
    <div
      className={\`bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative flex items-center \${className}\`}
      role=\"alert\"
    >
      <AlertTriangle className=\"h-5 w-5 mr-2\" />
      <span className=\"block sm:inline\">{message}</span>
    </div>
  );
};

export default ErrorMessage;" > src/components/common/ErrorMessage.tsx

# src/components/common/PageTitle.tsx (Display)
echo "import React from 'react';

interface PageTitleProps {
  title: string;
  subtitle?: string;
  className?: string;
}

const PageTitle: React.FC<PageTitleProps> = ({ title, subtitle, className = '' }) => {
  return (
    <div className={\`mb-6 md:mb-8 \${className}\`}>
      <h1 className=\"text-3xl md:text-4xl font-bold text-gray-900\">
        {title}
      </h1>
      {subtitle && (
        <p className=\"mt-2 text-lg text-gray-600\">
          {subtitle}
        </p>
      )}
    </div>
  );
};

export default PageTitle;" > src/components/common/PageTitle.tsx


# src/components/common/Alert.tsx (Display, podría ser 'use client' si tiene botón de cierre)
echo "import React from 'react';
import { Info, CheckCircle, AlertTriangle, XCircle } from 'lucide-react'; // Iconos opcionales

interface AlertProps {
  message: string;
  type?: 'info' | 'success' | 'warning' | 'error';
  className?: string;
  // onClose?: () => void; // Añadir si se quiere un botón de cierre ('use client')
}

const Alert: React.FC<AlertProps> = ({ message, type = 'info', className = '' }) => {
  const baseStyle = 'px-4 py-3 rounded relative border mb-4 flex items-center';
  const typeStyles = {
    info: 'bg-blue-100 border-blue-400 text-blue-700',
    success: 'bg-green-100 border-green-400 text-green-700',
    warning: 'bg-yellow-100 border-yellow-400 text-yellow-700',
    error: 'bg-red-100 border-red-400 text-red-700',
  };
   const Icon = {
    info: <Info className=\"h-5 w-5 mr-2\" />,
    success: <CheckCircle className=\"h-5 w-5 mr-2\" />,
    warning: <AlertTriangle className=\"h-5 w-5 mr-2\" />,
    error: <XCircle className=\"h-5 w-5 mr-2\" />,
  }[type];


  return (
    <div className={\`\${baseStyle} \${typeStyles[type]} \${className}\`} role=\"alert\">
      {Icon}
      <span>{message}</span>
       {/* Añadir aquí botón de cierre si se necesita */}
    </div>
  );
};

export default Alert;" > src/components/common/Alert.tsx


# --- src/components/doctors ---
echo "📁 Creando componentes en src/components/doctors..."
mkdir -p src/components/doctors # Asegura que el directorio exista

# src/components/doctors/DoctorCard.tsx (Display)
echo "import React from 'react';
import Image from 'next/image'; // Usa Next.js Image para optimización
import Link from 'next/link';
import Button from '@/components/common/Button'; // Podrías tener un botón 'View Profile'

interface DoctorCardProps {
  doctor: { // Define el tipo de Doctor aquí o impórtalo
    id: string;
    name: string;
    specialty: string; // O un objeto Specialty
    profilePictureUrl?: string; // URL de la imagen
    qualifications?: string;
  };
}

const DoctorCard: React.FC<DoctorCardProps> = ({ doctor }) => {
  const placeholderImage = '/images/doctor-placeholder.png'; // Ten una imagen de placeholder

  return (
    <div className=\"border rounded-lg overflow-hidden shadow-md bg-white flex flex-col h-full\">
      <div className=\"relative h-48 w-full\">
        <Image
          src={doctor.profilePictureUrl || placeholderImage}
          alt={\`Profile picture of Dr. \${doctor.name}\`}
          layout=\"fill\"
          objectFit=\"cover\"
          className=\"bg-gray-200\"
        />
      </div>
      <div className=\"p-4 flex flex-col flex-grow\">
        <h3 className=\"text-xl font-semibold mb-1\">Dr. {doctor.name}</h3>
        <p className=\"text-blue-600 mb-2\">{doctor.specialty}</p>
        {doctor.qualifications && <p className=\"text-sm text-gray-600 mb-4 line-clamp-2\">{doctor.qualifications}</p>}
         <div className=\"mt-auto\"> {/* Empuja el botón hacia abajo */}
           <Link href={\`/doctors/\${doctor.id}\`} passHref legacyBehavior>
              <a className='block'> {/* Envolver el botón en <a> para SSR Link */}
                  <Button variant=\"secondary\" size=\"sm\" fullWidth>View Profile</Button>
               </a>
            </Link>
         </div>
      </div>
    </div>
  );
};

export default DoctorCard;" > src/components/doctors/DoctorCard.tsx

# src/components/doctors/DoctorProfile.tsx (Display)
echo "import React from 'react';
import Image from 'next/image';
import PageTitle from '@/components/common/PageTitle';
import Button from '@/components/common/Button'; // Botón para reservar cita

interface DoctorProfileProps {
   doctor: { // Define el tipo completo del Doctor
    id: string;
    name: string;
    specialty: string; // O un objeto Specialty
    qualifications: string;
    bio?: string;
    yearsExperience?: number;
    profilePictureUrl?: string;
    languages?: string[];
    // Añade más campos según la estructura de Appwrite
  };
}

const DoctorProfile: React.FC<DoctorProfileProps> = ({ doctor }) => {
 const placeholderImage = '/images/doctor-placeholder.png';

  return (
    <div className=\"max-w-4xl mx-auto p-4 md:p-8\">
      <div className=\"md:flex md:space-x-8\">
        {/* Imagen y botón de reservar */}
        <div className=\"md:w-1/3 text-center mb-6 md:mb-0\">
          <div className=\"relative h-64 w-64 mx-auto rounded-full overflow-hidden border-4 border-gray-200 shadow-lg mb-4\">
             <Image
               src={doctor.profilePictureUrl || placeholderImage}
               alt={\`Dr. \${doctor.name}\`}
               layout=\"fill\"
               objectFit=\"cover\"
               className=\"bg-gray-200\"
             />
          </div>
           {/* TODO: Enlazar este botón al flujo de reserva con este doctor preseleccionado */}
          <Button variant=\"primary\" size=\"lg\">Book Appointment</Button>
        </div>

        {/* Detalles del Doctor */}
        <div className=\"md:w-2/3\">
          <PageTitle title={\`Dr. \${doctor.name}\`} subtitle={doctor.specialty} className='mb-4' />
          <div className=\"space-y-4 text-gray-700\">
             <p><strong>Qualifications:</strong> {doctor.qualifications}</p>
            {doctor.yearsExperience !== undefined && <p><strong>Experience:</strong> {doctor.yearsExperience} years</p>}
            {doctor.languages && doctor.languages.length > 0 && (
               <p><strong>Languages:</strong> {doctor.languages.join(', ')}</p>
            )}
             {doctor.bio && (
                <div>
                 <h3 className=\"text-lg font-semibold mb-1\">About Dr. {doctor.name}</h3>
                 <p className=\"text-base whitespace-pre-line\">{doctor.bio}</p> {/* whitespace-pre-line respeta saltos de línea */}
               </div>
            )}
             {/* Añade más secciones si es necesario (ej. educación, publicaciones) */}
          </div>
        </div>
      </div>

       {/* Sección de Disponibilidad (podría ser otro componente) */}
       <div className='mt-10 pt-6 border-t'>
           <h3 className=\"text-2xl font-semibold mb-4\">Check Availability</h3>
            {/* Aquí integrarías el BookingForm o un componente de calendario/slots específico */}
           <p className='italic text-gray-600'> (Availability section placeholder - Integrate BookingForm or similar component here)</p>
       </div>
    </div>
  );
};

export default DoctorProfile;" > src/components/doctors/DoctorProfile.tsx

# src/components/doctors/DoctorFilter.tsx (Interactive -> Client Component)
echo "'use client';

import React, { useState } from 'react';
import Select from '@/components/common/Select';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';

interface DoctorFilterProps {
  specialties: { id: string; name: string }[]; // Tipos específicos
  // locations: { id: string; name: string }[]; // Si filtran por ubicación
  onFilterChange: (filters: { specialty?: string; name?: string; /* location?: string */ }) => void;
}

const DoctorFilter: React.FC<DoctorFilterProps> = ({ specialties, onFilterChange }) => {
  const [selectedSpecialty, setSelectedSpecialty] = useState('');
  const [doctorName, setDoctorName] = useState('');
  // const [selectedLocation, setSelectedLocation] = useState('');

  const handleApplyFilters = () => {
    onFilterChange({
      specialty: selectedSpecialty || undefined, // Envía undefined si está vacío
      name: doctorName || undefined,
     // location: selectedLocation || undefined,
    });
  };

  const handleResetFilters = () => {
      setSelectedSpecialty('');
      setDoctorName('');
      // setSelectedLocation('');
      onFilterChange({}); // Llama sin filtros para resetear
  };

  return (
    <div className=\"p-4 bg-gray-50 border rounded-lg mb-6 shadow-sm\">
      <div className=\"grid grid-cols-1 md:grid-cols-3 gap-4 items-end\">
        <Input
          label=\"Doctor Name\"
          id=\"doctor-name-filter\"
          placeholder=\"Search by name...\"
          value={doctorName}
          onChange={(e) => setDoctorName(e.target.value)}
        />
        <Select
          label=\"Specialty\"
          id=\"specialty-filter\"
          value={selectedSpecialty}
          onChange={(e) => setSelectedSpecialty(e.target.value)}
        >
          <option value=\"\">All Specialties</option>
          {specialties.map((spec) => (
            <option key={spec.id} value={spec.id}>{spec.name}</option>
          ))}
        </Select>
         {/* Añade filtro de ubicación si es necesario */}
        {/* <Select
          label=\"Location\"
          id=\"location-filter\"
          value={selectedLocation}
          onChange={(e) => setSelectedLocation(e.target.value)}
        >
           <option value=\"\">All Locations</option>
           // Mapea ubicaciones
        </Select> */}

         <div className=\"flex space-x-2 md:col-start-3 md:justify-self-end\">
             <Button onClick={handleApplyFilters} variant='primary'>Apply Filters</Button>
             <Button onClick={handleResetFilters} variant='secondary'>Reset</Button>
          </div>
      </div>
    </div>
  );
};

export default DoctorFilter;" > src/components/doctors/DoctorFilter.tsx

# src/components/doctors/DoctorList.tsx (Display)
echo "import React from 'react';
import DoctorCard from './DoctorCard';
import LoadingSpinner from '@/components/common/LoadingSpinner';
import ErrorMessage from '@/components/common/ErrorMessage';

interface DoctorListProps {
  doctors: any[]; // Reemplaza 'any[]' con el tipo Doctor[]
  isLoading?: boolean;
  error?: string | null;
}

const DoctorList: React.FC<DoctorListProps> = ({ doctors, isLoading, error }) => {
  if (isLoading) {
    return <div className=\"flex justify-center p-10\"><LoadingSpinner /></div>;
  }

  if (error) {
    return <ErrorMessage message={error} />;
  }

  if (!doctors || doctors.length === 0) {
    return <p className=\"text-center text-gray-600 py-10\">No doctors found matching your criteria.</p>;
  }

  return (
    <div className=\"grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6\">
      {doctors.map((doctor) => (
        <DoctorCard key={doctor.id} doctor={doctor} />
      ))}
    </div>
  );
};

export default DoctorList;" > src/components/doctors/DoctorList.tsx


# --- src/components/layout ---
echo "📁 Creando componentes en src/components/layout..."
mkdir -p src/components/layout # Asegura que el directorio exista

# src/components/layout/Navbar.tsx (Puede necesitar 'use client' para menús desplegables, estado de auth, etc.)
echo "'use client'; // Asume interactividad (menú móvil, estado auth)

import React, { useState } from 'react';
import Link from 'next/link';
import { Menu, X } from 'lucide-react'; // Iconos para menú móvil
import Button from '@/components/common/Button';

// Simulación del estado de autenticación (reemplazar con lógica real de useAuth o similar)
const useMockAuth = () => ({ user: null, logout: () => console.log('logout') });

const Navbar: React.FC = () => {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const { user, logout } = useMockAuth(); // Reemplazar con tu hook de autenticación

  const navLinks = [
    { href: '/', label: 'Home' },
    { href: '/doctors', label: 'Find a Doctor' },
    { href: '/services', label: 'Services' },
    { href: '/locations', label: 'Locations' },
    { href: '/resources', label: 'Health Resources' },
    { href: '/about', label: 'About Us' },
    { href: '/contact', label: 'Contact' },
  ];

  return (
    <nav className=\"bg-white shadow-md sticky top-0 z-40\">
      <div className=\"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8\">
        <div className=\"flex justify-between items-center h-16\">
          {/* Logo */}
          <div className=\"flex-shrink-0\">
            <Link href=\"/\" className=\"text-2xl font-bold text-blue-600\">
              Modern Hospital
            </Link>
          </div>

          {/* Links de Navegación Desktop */}
          <div className=\"hidden md:flex md:items-center md:space-x-6\">
            {navLinks.map((link) => (
              <Link key={link.href} href={link.href} className=\"text-gray-600 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors\">
                  {link.label}
              </Link>
            ))}
             {/* Auth Links Desktop */}
             <div className=\"ml-4 flex items-center space-x-2\">
               {user ? (
                 <>
                    <Link href=\"/appointments\" className=\"text-gray-600 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors\">
                        My Appointments
                    </Link>
                    <Button onClick={logout} variant=\"secondary\" size=\"sm\">Logout</Button>
                 </>
               ) : (
                  <>
                     <Link href=\"/login\" passHref legacyBehavior>
                         <a><Button variant=\"ghost\" size=\"sm\">Login</Button></a>
                     </Link>
                     <Link href=\"/register\" passHref legacyBehavior>
                         <a><Button variant=\"primary\" size=\"sm\">Register</Button></a>
                     </Link>
                  </>
               )}
              </div>
          </div>

          {/* Botón Menú Móvil */}
          <div className=\"md:hidden flex items-center\">
             {/* Botón de Login/Register simplificado para móvil si no hay menú */}
             {!isMobileMenuOpen && !user && (
                  <Link href=\"/login\" passHref legacyBehavior>
                      <a><Button variant=\"primary\" size=\"sm\">Login</Button></a>
                  </Link>
              )}
            <button
              onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
              className=\"ml-2 inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-blue-500\"
              aria-expanded={isMobileMenuOpen}
            >
              <span className=\"sr-only\">Open main menu</span>
              {isMobileMenuOpen ? <X className=\"block h-6 w-6\" aria-hidden=\"true\" /> : <Menu className=\"block h-6 w-6\" aria-hidden=\"true\" />}
            </button>
          </div>
        </div>
      </div>

      {/* Panel Menú Móvil */}
      {isMobileMenuOpen && (
        <div className=\"md:hidden absolute top-16 inset-x-0 bg-white shadow-lg z-30\">
          <div className=\"px-2 pt-2 pb-3 space-y-1 sm:px-3\">
            {navLinks.map((link) => (
              <Link key={link.href} href={link.href} className=\"text-gray-600 hover:bg-gray-50 hover:text-blue-600 block px-3 py-2 rounded-md text-base font-medium transition-colors\" onClick={() => setIsMobileMenuOpen(false)}>
                  {link.label}
              </Link>
            ))}
          </div>
           {/* Auth Links Móvil */}
           <div className=\"pt-4 pb-3 border-t border-gray-200 px-5\">
                {user ? (
                    <div className=\"space-y-1\">
                         <Link href=\"/appointments\" className=\"block px-3 py-2 rounded-md text-base font-medium text-gray-600 hover:text-blue-600 hover:bg-gray-50\" onClick={() => setIsMobileMenuOpen(false)}>
                             My Appointments
                         </Link>
                        <button onClick={() => { logout(); setIsMobileMenuOpen(false); }} className=\"w-full text-left block px-3 py-2 rounded-md text-base font-medium text-gray-600 hover:text-blue-600 hover:bg-gray-50\">
                             Logout
                        </button>
                    </div>
                ) : (
                    <div className=\"space-y-2\">
                         <Link href=\"/login\" passHref legacyBehavior>
                              <a><Button variant=\"ghost\" fullWidth onClick={() => setIsMobileMenuOpen(false)}>Login</Button></a>
                         </Link>
                         <Link href=\"/register\" passHref legacyBehavior>
                             <a><Button variant=\"primary\" fullWidth onClick={() => setIsMobileMenuOpen(false)}>Register</Button></a>
                         </Link>
                     </div>
                )}
            </div>
        </div>
      )}
    </nav>
  );
};

export default Navbar;" > src/components/layout/Navbar.tsx

# src/components/layout/Footer.tsx (Display)
echo "import React from 'react';
import Link from 'next/link';

const Footer: React.FC = () => {
  const currentYear = new Date().getFullYear();

  return (
    <footer className=\"bg-gray-100 border-t border-gray-200 mt-12\">
      <div className=\"max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8\">
        <div className=\"grid grid-cols-1 md:grid-cols-4 gap-8\">
          {/* Sección Logo/About */}
          <div>
            <h3 className=\"text-lg font-semibold text-gray-800 mb-2\">Modern Hospital</h3>
            <p className=\"text-sm text-gray-600\">Providing excellent healthcare with compassion and innovation.</p>
             {/* Social Media Icons (optional) */}
          </div>

          {/* Quick Links */}
          <div>
            <h4 className=\"font-semibold text-gray-700 mb-2\">Quick Links</h4>
            <ul className=\"space-y-1 text-sm\">
              <li><Link href=\"/doctors\" className=\"text-gray-600 hover:text-blue-600\">Find a Doctor</Link></li>
              <li><Link href=\"/services\" className=\"text-gray-600 hover:text-blue-600\">Services</Link></li>
              <li><Link href=\"/appointments\" className=\"text-gray-600 hover:text-blue-600\">Book Appointment</Link></li>
              <li><Link href=\"/patients-visitors\" className=\"text-gray-600 hover:text-blue-600\">Patients & Visitors</Link></li>
            </ul>
          </div>

          {/* Contact Info */}
           <div>
            <h4 className=\"font-semibold text-gray-700 mb-2\">Contact Us</h4>
            <address className=\"text-sm text-gray-600 not-italic space-y-1\">
               <p>123 Health St.</p>
               <p>Wellville, MedState 12345</p>
               <p>Phone: <a href=\"tel:+15551234567\" className=\"hover:text-blue-600\">(555) 123-4567</a></p>
               <p>Email: <a href=\"mailto:info@modernhospital.com\" className=\"hover:text-blue-600\">info@modernhospital.com</a></p>
             </address>
          </div>

           {/* Legal/Other Links */}
           <div>
            <h4 className=\"font-semibold text-gray-700 mb-2\">Information</h4>
            <ul className=\"space-y-1 text-sm\">
               <li><Link href=\"/about\" className=\"text-gray-600 hover:text-blue-600\">About Us</Link></li>
               <li><Link href=\"/contact\" className=\"text-gray-600 hover:text-blue-600\">Contact</Link></li>
              <li><Link href=\"/privacy-policy\" className=\"text-gray-600 hover:text-blue-600\">Privacy Policy</Link></li>
              <li><Link href=\"/terms-of-service\" className=\"text-gray-600 hover:text-blue-600\">Terms of Service</Link></li>
            </ul>
          </div>
        </div>

        <div className=\"mt-8 border-t border-gray-300 pt-6 text-center text-sm text-gray-500\">
          © {currentYear} Modern Hospital. All rights reserved.
        </div>
      </div>
    </footer>
  );
};

export default Footer;" > src/components/layout/Footer.tsx

# src/components/layout/Sidebar.tsx (Puede necesitar 'use client' si es interactivo)
echo "'use client'; // Probablemente necesario si tiene estado o interacción

import React from 'react';
import Link from 'next/link';
// Importa iconos si los usas (ej. lucide-react)

interface SidebarProps {
  // Props para controlar visibilidad en móvil, etc.
}

const Sidebar: React.FC<SidebarProps> = () => {
  // Lógica para estado (abierto/cerrado en móvil), usuario actual, etc.
  const dashboardLinks = [
    { href: '/appointments', label: 'My Appointments' /* icon: CalendarIcon */ },
    { href: '/profile', label: 'My Profile' /* icon: UserIcon */ },
    { href: '/medical-records', label: 'Medical Records' /* icon: FileTextIcon */ }, // Ejemplo
    // Añade más links según sea necesario
  ];

  return (
    <aside className=\"w-64 bg-gray-50 p-4 border-r h-full hidden md:block\"> {/* Oculto en móvil por defecto */}
      <nav>
        <h3 className=\"text-xs font-semibold uppercase text-gray-500 mb-2\">Dashboard</h3>
        <ul className=\"space-y-1\">
          {dashboardLinks.map((link) => (
            <li key={link.href}>
              <Link href={link.href} className=\"flex items-center px-3 py-2 text-sm font-medium rounded-md text-gray-700 hover:bg-gray-200 hover:text-gray-900 transition-colors\">
                  {/* {link.icon && <link.icon className=\"h-5 w-5 mr-2\" />} */}
                  {link.label}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
       {/* Puedes añadir otras secciones al sidebar */}
    </aside>
  );
};

export default Sidebar;" > src/components/layout/Sidebar.tsx

# --- src/components/services ---
echo "📁 Creando componentes en src/components/services..."
mkdir -p src/components/services # Asegura que el directorio exista

# src/components/services/ServiceCard.tsx (Display)
echo "import React from 'react';
import Image from 'next/image';
import Link from 'next/link';

interface ServiceCardProps {
  service: { // Define el tipo de Service o Specialty
    id: string;
    name: string;
    description: string;
    imageUrl?: string;
    // slug?: string; // Si usas slugs para las URLs
  };
}

const ServiceCard: React.FC<ServiceCardProps> = ({ service }) => {
  const placeholderImage = '/images/service-placeholder.png'; // Placeholder
  // Determina la URL (podría ser /services/[id] o /services/[slug])
  const serviceUrl = \`/services/\${service.id}\`; // Ajusta si usas slugs

  return (
    <Link href={serviceUrl} className=\"block group\">
      <div className=\"border rounded-lg overflow-hidden shadow-md bg-white h-full flex flex-col transition-shadow duration-200 group-hover:shadow-lg\">
        <div className=\"relative h-40 w-full\">
          <Image
            src={service.imageUrl || placeholderImage}
            alt={\`Image for \${service.name}\`}
            layout=\"fill\"
            objectFit=\"cover\"
             className=\"bg-gray-200\"
          />
        </div>
        <div className=\"p-4 flex-grow\">
          <h3 className=\"text-lg font-semibold mb-2 group-hover:text-blue-600 transition-colors\">{service.name}</h3>
          <p className=\"text-sm text-gray-600 line-clamp-3\">{service.description}</p>
        </div>
        <div className=\"p-4 pt-0 text-sm text-blue-600 font-medium group-hover:underline\">
            Learn More →
        </div>
      </div>
    </Link>
  );
};

export default ServiceCard;" > src/components/services/ServiceCard.tsx

# src/components/services/ServiceList.tsx (Display)
echo "import React from 'react';
import ServiceCard from './ServiceCard';

interface ServiceListProps {
  services: any[]; // Reemplaza con tipo Service[] o Specialty[]
}

const ServiceList: React.FC<ServiceListProps> = ({ services }) => {
   if (!services || services.length === 0) {
    return <p className=\"text-center text-gray-600 py-10\">No services available at this time.</p>;
  }
  return (
    <div className=\"grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6\">
      {services.map((service) => (
        <ServiceCard key={service.id} service={service} />
      ))}
    </div>
  );
};

export default ServiceList;" > src/components/services/ServiceList.tsx

# src/components/services/ServiceDetail.tsx (Display)
echo "import React from 'react';
import Image from 'next/image';
import PageTitle from '@/components/common/PageTitle';
// Importa componentes relacionados si es necesario (ej. lista de doctores de este servicio)

interface ServiceDetailProps {
  service: { // Define el tipo completo del Service/Specialty
    id: string;
    name: string;
    description: string;
    imageUrl?: string;
    costEstimate?: string;
    durationMinutes?: number;
    // Podría tener una lista de doctores asociados, etc.
  };
}

const ServiceDetail: React.FC<ServiceDetailProps> = ({ service }) => {
 const placeholderImage = '/images/service-placeholder.png';

  return (
    <div className=\"max-w-4xl mx-auto p-4 md:p-8\">
      <PageTitle title={service.name} className='mb-6' />

      {service.imageUrl && (
        <div className=\"relative h-64 w-full rounded-lg overflow-hidden shadow-md mb-6\">
          <Image
            src={service.imageUrl || placeholderImage}
            alt={\`Image for \${service.name}\`}
            layout=\"fill\"
            objectFit=\"cover\"
            className=\"bg-gray-200\"
          />
        </div>
      )}

      <div className=\"prose prose-lg max-w-none text-gray-700 mb-6\">
        {/* Usa 'prose' de Tailwind Typography si quieres formateo fácil de Markdown/HTML */}
        <p>{service.description}</p>
      </div>

      <div className=\"bg-gray-50 p-4 rounded-lg border space-y-2 text-sm mb-6\">
         {service.durationMinutes && <p><strong>Estimated Duration:</strong> {service.durationMinutes} minutes</p>}
         {service.costEstimate && <p><strong>Estimated Cost:</strong> {service.costEstimate}</p>}
         {/* Añade más detalles relevantes */}
      </div>

      {/* Sección Opcional: Doctores que realizan este servicio */}
      {/* <div>
          <h3 className=\"text-xl font-semibold mb-4\">Doctors Providing This Service</h3>
          // Aquí iría una lista de DoctorCards o similar
          <p className='italic text-gray-500'>(Placeholder for related doctors list)</p>
      </div> */}

       {/* Sección Opcional: Cómo prepararse */}
       {/* <div className='mt-6 pt-6 border-t'>
           <h3 className=\"text-xl font-semibold mb-4\">How to Prepare</h3>
            <p>...</p>
       </div> */}

        {/* Botón para reservar (si aplica directamente a este servicio) */}
        {/* <div className='mt-8 text-center'>
            <Button variant='primary' size='lg'>Book This Service</Button>
        </div> */}

    </div>
  );
};

export default ServiceDetail;" > src/components/services/ServiceDetail.tsx


echo ""
echo "🎉 ¡Archivos de componentes base creados exitosamente en src/components/!"
echo "ℹ️ Cada archivo contiene un componente funcional básico de React con TypeScript."
echo "ℹ️ Los componentes interactivos tienen la directiva 'use client'."
echo "ℹ️ Revisa y adapta los tipos de props (reemplaza 'any') y la lógica según tus necesidades."
echo "ℹ️ Instala dependencias si usaste iconos: npm install lucide-react"