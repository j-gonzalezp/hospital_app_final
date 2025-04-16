#!/bin/bash

echo "🚀 Creando archivos de componentes base..."

echo "📁 Creando componentes en src/components/appointment..."

mkdir -p src/components/appointment

echo "import React from 'react';

interface AppointmentCardProps {
  appointment: any;
}

const AppointmentCard: React.FC<AppointmentCardProps> = ({ appointment }) => {
  return (
    <div className=\"border p-4 rounded shadow-md mb-4\">
      <h3 className=\"font-semibold\">Appointment Details</h3>
      <p>Doctor: {appointment.doctorName || 'N/A'}</p>
      <p>Date: {appointment.date || 'N/A'}</p>
      <p>Status: {appointment.status || 'N/A'}</p>
    </div>
  );
};

export default AppointmentCard;" > src/components/appointment/AppointmentCard.tsx

echo "import React from 'react';
import AppointmentCard from './AppointmentCard';

interface AppointmentListProps {
  appointments: any[];
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

echo "'use client';

import React, { useState } from 'react';
import Button from '@/components/common/Button';
import Select from '@/components/common/Select';
import Input from '@/components/common/Input';

interface BookingFormProps {
  doctors: any[];
  availableSlots: any[];
  onBookingSubmit: (formData: any) => void;
  onDateChange: (doctorId: string, date: string) => void;
  onDoctorChange: (doctorId: string) => void;
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

  const handleDoctorChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const doctorId = e.target.value;
    setSelectedDoctor(doctorId);
    setSelectedDate('');
    setSelectedSlot('');
    onDoctorChange(doctorId);
  };

  const handleDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const date = e.target.value;
    setSelectedDate(date);
    setSelectedSlot('');
    if (selectedDoctor && date) {
      onDateChange(selectedDoctor, date);
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
      date: selectedDate,
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
        disabled={!selectedDoctor}
      />

      <Select
        label=\"Select Time Slot\"
        value={selectedSlot}
        onChange={handleSlotChange}
        required
        disabled={!selectedDate || availableSlots.length === 0}
      >
        <option value=\"\" disabled>-- Select a Time --</option>
        {availableSlots.map((slot) => (

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

echo "'use client';

import React from 'react';

interface AvailabilityCalendarProps {
  doctorId: string;
  onDateSelect: (date: Date) => void;
}

const AvailabilityCalendar: React.FC<AvailabilityCalendarProps> = ({ doctorId, onDateSelect }) => {
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
      />
      <p className=\"mt-2 text-sm text-gray-500\">Availability Calendar Placeholder (Implement with a library or custom logic)</p>
    </div>
  );
};

export default AvailabilityCalendar;" > src/components/appointment/AvailabilityCalendar.tsx

echo "'use client';

import React from 'react';

interface SlotSelectorProps {
  slots: { id: string; time: string; status: 'available' | 'booked' | 'unavailable' }[];
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
            className={\`px-3 py-1 border rounded text-sm
              \${selectedSlot === slot.id ? 'bg-blue-500 text-white border-blue-500' : 'bg-white'}
              \${slot.status === 'available' ? 'hover:bg-blue-100 cursor-pointer' : 'bg-gray-200 text-gray-400 cursor-not-allowed'}
            \`}
          >
            {slot.time}
          </button>
        ))}
      </div>
    </div>
  );
};

export default SlotSelector;" > src/components/appointment/SlotSelector.tsx

echo "'use client';

import React from 'react';
import Modal from '@/components/common/Modal';
import Button from '@/components/common/Button';

interface CancelConfirmationModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  appointmentDetails: any;
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

echo "📁 Creando componentes en src/components/auth..."
mkdir -p src/components/auth

echo "'use client';

import React, { useState } from 'react';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';
import Link from 'next/link';

interface LoginFormProps {
    onLogin: (credentials: any) => void;
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

echo "'use client';

import React, { useState } from 'react';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';
import Link from 'next/link';

interface RegisterFormProps {
    onRegister: (userData: any) => void;
    loading?: boolean;
    error?: string | null;
}

const RegisterForm: React.FC<RegisterFormProps> = ({ onRegister, loading, error }) => {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

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
        minLength={8}
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


echo "📁 Creando componentes en src/components/common..."
mkdir -p src/components/common

echo "'use client';

import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  fullWidth?: boolean;
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
    ghost: 'bg-transparent text-blue-600 hover:bg-blue-100 focus:ring-blue-500'
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

echo "import React from 'react';

interface CardProps {
  children: React.ReactNode;
  className?: string;
}

const Card: React.FC<CardProps> = ({ children, className = '' }) => {
  return (
    <div className={\`bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden \${className}\`}>
      {children}
    </div>
  );
};

export default Card;" > src/components/common/Card.tsx

echo "'use client';

import React, { useEffect } from 'react';
import { X } from 'lucide-react';

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
      document.body.style.overflow = 'hidden';
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
  };

  return (
    <div
      className=\"fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 backdrop-blur-sm transition-opacity duration-300 ease-in-out\"
      onClick={onClose}
      aria-labelledby=\"modal-title\"
      role=\"dialog\"
      aria-modal=\"true\"
    >
      <div
        className={\`bg-white rounded-lg shadow-xl w-full m-4 \${sizeClasses[size]} transform transition-all duration-300 ease-in-out scale-95 opacity-0 \${isOpen ? 'scale-100 opacity-100' : ''}\`}
        onClick={(e) => e.stopPropagation()}
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

echo "'use client';

import React from 'react';

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  id: string;
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

echo "'use client';

import React from 'react';

interface SelectProps extends React.SelectHTMLAttributes<HTMLSelectElement> {
  label?: string;
  id: string;
  error?: string | null;
  className?: string;
  children: React.ReactNode;
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
         <span className=\"sr-only\">Loading...</span>
      </div>
    </div>
  );
};

export default LoadingSpinner;" > src/components/common/LoadingSpinner.tsx

echo "import React from 'react';
import { AlertTriangle } from 'lucide-react';

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


echo "import React from 'react';
import { Info, CheckCircle, AlertTriangle, XCircle } from 'lucide-react';

interface AlertProps {
  message: string;
  type?: 'info' | 'success' | 'warning' | 'error';
  className?: string;
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
    </div>
  );
};

export default Alert;" > src/components/common/Alert.tsx


echo "📁 Creando componentes en src/components/doctors..."
mkdir -p src/components/doctors

echo "import React from 'react';
import Image from 'next/image';
import Link from 'next/link';
import Button from '@/components/common/Button';

interface DoctorCardProps {
  doctor: {
    id: string;
    name: string;
    specialty: string;
    profilePictureUrl?: string;
    qualifications?: string;
  };
}

const DoctorCard: React.FC<DoctorCardProps> = ({ doctor }) => {
  const placeholderImage = '/images/doctor-placeholder.png';

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
         <div className=\"mt-auto\">
           <Link href={\`/doctors/\${doctor.id}\`} passHref legacyBehavior>
              <a className='block'>
