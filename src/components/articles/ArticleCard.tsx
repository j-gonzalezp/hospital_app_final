// src/components/articles/ArticleCard.tsx
import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import type { ArticleWithDetails } from '@/types/article.d.ts';
import { Calendar, User } from 'lucide-react'; // Iconos opcionales

interface ArticleCardProps {
    article: ArticleWithDetails;
}

const ArticleCard: React.FC<ArticleCardProps> = ({ article }) => {
    const placeholderImage = '/images/article-placeholder.png'; // Crea esta imagen

     // Formatea la fecha de publicación
    const publishDateFormatted = article.publishDate
        ? new Date(article.publishDate).toLocaleDateString(undefined, {
              year: 'numeric', month: 'long', day: 'numeric'
          })
        : 'Date unknown';

    return (
        <Link href={`/resources/${article.slug}`} className="block group">
            <article className="border rounded-lg overflow-hidden shadow-sm bg-white flex flex-col h-full transition-shadow hover:shadow-lg">
                {/* Imagen Destacada */}
                <div className="relative h-48 w-full bg-gray-200">
                    <Image
                        src={article.featuredImageUrl || placeholderImage}
                        alt={article.title || 'Article image'}
                        fill
                        sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
                        style={{ objectFit: 'cover' }}
                    />
                </div>

                {/* Contenido de la Tarjeta */}
                <div className="p-4 flex flex-col flex-grow">
                    {/* Categoría o Tags (Opcional) */}
                    {article.category && (
                        <p className="text-xs font-medium text-blue-600 uppercase mb-1">{article.category}</p>
                    )}

                    {/* Título */}
                    <h3 className="text-lg font-semibold mb-2 text-gray-800 group-hover:text-blue-700 transition-colors line-clamp-2">
                        {article.title}
                    </h3>

                    {/* Extracto */}
                    {article.excerpt && (
                        <p className="text-sm text-gray-600 mb-3 line-clamp-3 flex-grow">
                            {article.excerpt}
                        </p>
                    )}

                    {/* Metadatos (Fecha, Autor) */}
                    <div className="mt-auto pt-2 border-t border-gray-100 text-xs text-gray-500 flex flex-wrap gap-x-3 gap-y-1 items-center">
                       <div className='flex items-center space-x-1'>
                            <Calendar size={14} />
                           <span>{publishDateFormatted}</span>
                       </div>
                       {article.authorName && (
                            <div className='flex items-center space-x-1'>
                                <User size={14} />
                                <span>By {article.authorName}</span>
                            </div>
                       )}
                    </div>
                </div>
            </article>
        </Link>
    );
};

export default ArticleCard;