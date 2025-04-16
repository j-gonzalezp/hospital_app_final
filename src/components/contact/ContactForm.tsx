// src/components/contact/ContactForm.tsx
'use client';

import React, { useState, useTransition } from 'react';
import Input from '@/components/common/Input';
import Button from '@/components/common/Button';
import LoadingSpinner from '@/components/common/LoadingSpinner';
import Alert from '@/components/common/Alert';
import { sendContactMessage } from '@/lib/actions'; // Importaremos esta action

interface ContactFormState {
    name: string;
    email: string;
    subject: string;
    message: string;
}

const ContactForm: React.FC = () => {
    const [formData, setFormData] = useState<ContactFormState>({
        name: '',
        email: '',
        subject: '',
        message: '',
    });
    const [error, setError] = useState<string | null>(null);
    const [successMessage, setSuccessMessage] = useState<string | null>(null);
    const [isPending, startTransition] = useTransition(); // Para manejar el estado de envío

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setError(null);
        setSuccessMessage(null);

        startTransition(async () => {
            try {
                // Llama a la Server Action
                const result = await sendContactMessage(formData);

                if (result.success) {
                    setSuccessMessage(result.message || 'Your message has been sent successfully!');
                    // Limpia el formulario
                    setFormData({ name: '', email: '', subject: '', message: '' });
                } else {
                    setError(result.message || 'Failed to send message. Please try again.');
                }
            } catch (err: any) {
                console.error("Error submitting contact form:", err);
                setError(err.message || 'An unexpected error occurred.');
            }
        });
    };

    return (
        <form onSubmit={handleSubmit} className="space-y-5 max-w-xl mx-auto">
            {error && <Alert message={error} type="error" />}
            {successMessage && <Alert message={successMessage} type="success" />}

            <Input
                id="contact-name"
                label="Your Name"
                name="name" // name debe coincidir con la clave en formData
                type="text"
                value={formData.name}
                onChange={handleChange}
                required
                disabled={isPending}
                autoComplete="name"
            />
            <Input
                id="contact-email"
                label="Your Email"
                name="email"
                type="email"
                value={formData.email}
                onChange={handleChange}
                required
                disabled={isPending}
                autoComplete="email"
            />
            <Input
                id="contact-subject"
                label="Subject"
                name="subject"
                type="text"
                value={formData.subject}
                onChange={handleChange}
                required
                disabled={isPending}
            />
             <div>
                 <label htmlFor="contact-message" className="block text-sm font-medium text-[var(--text-secondary)] mb-1">
                    Message <span className="text-red-500">*</span>
                 </label>
                 <textarea
                    id="contact-message"
                    name="message"
                    rows={5}
                    value={formData.message}
                    onChange={handleChange}
                    required
                    disabled={isPending}
                    className="block w-full px-3 py-2 border border-[var(--border-primary)] rounded-md shadow-sm focus:outline-none focus:ring-[var(--ring-color)] focus:border-[var(--border-accent)] sm:text-sm bg-[var(--bg-secondary)] text-[var(--text-primary)] disabled:opacity-70"
                 />
            </div>

            <Button type="submit" variant="primary" fullWidth disabled={isPending}>
                {isPending ? <LoadingSpinner size="sm" /> : 'Send Message'}
            </Button>
        </form>
    );
};

export default ContactForm;