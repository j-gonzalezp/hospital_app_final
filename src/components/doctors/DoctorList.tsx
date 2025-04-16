import React from 'react';
import DoctorCard from './DoctorCard';
import LoadingSpinner from '@/components/common/LoadingSpinner';
import ErrorMessage from '@/components/common/ErrorMessage';
import type { DoctorDocument } from '@/types/doctor.d.ts'; // Import the Doctor type

interface DoctorListProps {
  doctors: DoctorDocument[]; // Use the specific Doctor type
  isLoading?: boolean;
  error?: string | null;
}

const DoctorList: React.FC<DoctorListProps> = ({ doctors, isLoading, error }) => {
  if (isLoading) {
    return <div className="flex justify-center p-10"><LoadingSpinner /></div>;
  }

  if (error) {
    return <ErrorMessage message={error} />;
  }

  if (!doctors || doctors.length === 0) {
    return <p className="text-center text-gray-600 py-10">No doctors found matching your criteria.</p>;
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      {doctors.map((doctor) => (
        // Use $id for key based on Appwrite convention
        <DoctorCard key={doctor.$id} doctor={doctor} />
      ))}
    </div>
  );
};

export default DoctorList;
