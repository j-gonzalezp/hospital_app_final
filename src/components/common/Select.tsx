'use client';

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
     <div className="w-full">
      {label && (
        <label htmlFor={id} className="block text-sm font-medium text-gray-700 mb-1">
          {label} {props.required && <span className="text-red-500">*</span>}
        </label>
      )}
      <select
        id={id}
        className={`${baseStyle} ${errorStyle} ${className}`}
        {...props}
      >
        {children}
      </select>
       {error && <p className="mt-1 text-xs text-red-500">{error}</p>}
    </div>
  );
};

export default Select;
