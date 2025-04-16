import React from 'react';

interface CardProps {
  children: React.ReactNode;
  className?: string;
  // Añade props para variantes si es necesario (ej. con padding, sin borde)
}

const Card: React.FC<CardProps> = ({ children, className = '' }) => {
  return (
    <div className={`bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden ${className}`}>
      {children}
    </div>
  );
};

export default Card;
