import React from 'react';
import Link from 'next/link';

const Footer: React.FC = () => {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-gray-100 border-t border-gray-200 mt-12">
      <div className="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* Sección Logo/About */}
          <div>
            <h3 className="text-lg font-semibold text-gray-800 mb-2">Modern Hospital</h3>
            <p className="text-sm text-gray-600">Providing excellent healthcare with compassion and innovation.</p>
             {/* Social Media Icons (optional) */}
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="font-semibold text-gray-700 mb-2">Quick Links</h4>
            <ul className="space-y-1 text-sm">
              <li><Link href="/doctors" className="text-gray-600 hover:text-blue-600">Find a Doctor</Link></li>
              <li><Link href="/services" className="text-gray-600 hover:text-blue-600">Services</Link></li>
              <li><Link href="/appointments" className="text-gray-600 hover:text-blue-600">Book Appointment</Link></li>
              <li><Link href="/patients-visitors" className="text-gray-600 hover:text-blue-600">Patients & Visitors</Link></li>
            </ul>
          </div>

          {/* Contact Info */}
           <div>
            <h4 className="font-semibold text-gray-700 mb-2">Contact Us</h4>
            <address className="text-sm text-gray-600 not-italic space-y-1">
               <p>123 Health St.</p>
               <p>Wellville, MedState 12345</p>
               <p>Phone: <a href="tel:+15551234567" className="hover:text-blue-600">(555) 123-4567</a></p>
               <p>Email: <a href="mailto:info@modernhospital.com" className="hover:text-blue-600">info@modernhospital.com</a></p>
             </address>
          </div>

           {/* Legal/Other Links */}
           <div>
            <h4 className="font-semibold text-gray-700 mb-2">Information</h4>
            <ul className="space-y-1 text-sm">
               <li><Link href="/about" className="text-gray-600 hover:text-blue-600">About Us</Link></li>
               <li><Link href="/contact" className="text-gray-600 hover:text-blue-600">Contact</Link></li>
              <li><Link href="/privacy-policy" className="text-gray-600 hover:text-blue-600">Privacy Policy</Link></li>
              <li><Link href="/terms-of-service" className="text-gray-600 hover:text-blue-600">Terms of Service</Link></li>
            </ul>
          </div>
        </div>

        <div className="mt-8 border-t border-gray-300 pt-6 text-center text-sm text-gray-500">
          © {currentYear} Modern Hospital. All rights reserved.
        </div>
      </div>
    </footer>
  );
};

export default Footer;
