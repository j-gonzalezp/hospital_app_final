'use client';

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
    <Modal isOpen={isOpen} onClose={onClose} title="Confirm Cancellation">
      <div className="p-4">
        <p className="mb-4">Are you sure you want to cancel the following appointment?</p>
        {/* Muestra detalles del appointment a cancelar */}
        <div className="mb-4 p-2 border rounded bg-gray-50 text-sm">
          <p><strong>Doctor:</strong> {appointmentDetails?.doctorName || 'N/A'}</p>
          <p><strong>Date:</strong> {appointmentDetails?.date || 'N/A'}</p>
          <p><strong>Time:</strong> {appointmentDetails?.time || 'N/A'}</p>
        </div>
        <div className="flex justify-end space-x-3">
          <Button onClick={onClose} variant="secondary">
            Keep Appointment
          </Button>
          <Button onClick={onConfirm} variant="danger">
            Yes, Cancel It
          </Button>
        </div>
      </div>
    </Modal>
  );
};

export default CancelConfirmationModal;
