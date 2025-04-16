import React from 'react';
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
      className={`bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative flex items-center ${className}`}
      role="alert"
    >
      <AlertTriangle className="h-5 w-5 mr-2" />
      <span className="block sm:inline">{message}</span>
    </div>
  );
};

export default ErrorMessage;
