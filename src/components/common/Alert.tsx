import React from 'react';
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
    info: <Info className="h-5 w-5 mr-2" />,
    success: <CheckCircle className="h-5 w-5 mr-2" />,
    warning: <AlertTriangle className="h-5 w-5 mr-2" />,
    error: <XCircle className="h-5 w-5 mr-2" />,
  }[type];


  return (
    <div className={`${baseStyle} ${typeStyles[type]} ${className}`} role="alert">
      {Icon}
      <span>{message}</span>
       {/* Añadir aquí botón de cierre si se necesita */}
    </div>
  );
};

export default Alert;
