// src/app/(main)/resources/[slug]/page.tsx
import React from 'react';
import Image from 'next/image';
import { getArticleBySlug } from '@/lib/actions';
import { notFound } from 'next/navigation';
import ErrorMessage from '@/components/common/ErrorMessage';
import { Calendar, User } from 'lucide-react'; // Iconos
// Necesitarás un procesador de Markdown si almacenas Markdown
// import ReactMarkdown from 'react-markdown';
// import remarkGfm from 'remark-gfm'; // Para tablas, etc.

interface ArticleDetailPageProps {
    params: {
        slug: string; // Debe coincidir con el nombre de la carpeta [slug]
    };
}

// Opcional: Generar metadatos dinámicos para SEO
// export async function generateMetadata({ params }: ArticleDetailPageProps): Promise<Metadata> {
//   const article = await getArticleBySlug(params.slug);
//   if (!article) {
//     return { title: 'Article Not Found' };
//   }
//   return {
//     title: article.title,
//     description: article.excerpt || 'Read this health article from Modern Hospital.',
//     // openGraph: { images: [article.featuredImageUrl || '/default-og-image.png'] }
//   };
// }


export default async function ArticleDetailPage({ params }: ArticleDetailPageProps) {
    const { slug } = params;
    let article = null;
    let error: string | null = null;

    if (!slug) {
        notFound();
    }

    try {
        article = await getArticleBySlug(slug);
    } catch (err: unknown) {
        console.error(`Error loading article detail for slug ${slug}:`, err);
        if (err instanceof Error) {
            error = err.message;
        } else {
            error = "An unknown error occurred while loading the article.";
        }
    }

    if (!article && !error) {
        notFound(); // Artículo no encontrado o no publicado
    }

     // Formatea la fecha de publicación
    const publishDateFormatted = article?.publishDate
        ? new Date(article.publishDate).toLocaleDateString(undefined, {
              year: 'numeric', month: 'long', day: 'numeric'
          })
        : null;


    return (
        <div className="max-w-3xl mx-auto px-4 py-8">
            {error && <ErrorMessage message={error} className="my-6" />}

            {article && (
                <article>
                    {/* Título */}
                    <h1 className="text-3xl md:text-4xl font-bold text-gray-900 mb-3 leading-tight">
                        {article.title}
                    </h1>

                    {/* Metadatos (Fecha, Autor, Categoría) */}
                    <div className="flex flex-wrap gap-x-4 gap-y-1 items-center text-sm text-gray-500 mb-6 border-b pb-3">
                       {publishDateFormatted && (
                           <div className='flex items-center space-x-1'>
                               <Calendar size={14} />
                               <span>Published on {publishDateFormatted}</span>
                           </div>
                       )}
                       {article.authorName && (
                            <div className='flex items-center space-x-1'>
                                <User size={14} />
                                <span>By {article.authorName}</span>
                            </div>
                       )}
                       {article.category && (
                           <span className="bg-blue-100 text-blue-800 px-2 py-0.5 rounded text-xs font-medium">
                               {article.category}
                           </span>
                       )}
                    </div>


                    {/* Imagen Destacada (Opcional) */}
                    {article.featuredImageUrl && (
                        <div className="relative h-64 md:h-80 w-full rounded-lg overflow-hidden shadow-md mb-8 bg-gray-200">
                          <Image
                            src={article.featuredImageUrl}
                            alt={article.title || 'Article featured image'}
                            fill
                            style={{ objectFit: 'cover' }}
                            priority // Carga prioritaria para imagen principal
                          />
                        </div>
                    )}

                    {/* Contenido del Artículo */}
                    {/* Usa 'prose' de Tailwind Typography para dar estilo al HTML/Markdown */}
                    <div className="prose prose-lg max-w-none">
                        {/* OPCIÓN A: Si guardaste HTML (¡Sanitizar!) */}
                         <div dangerouslySetInnerHTML={{ __html: article.content /* ¡ASEGÚRATE DE SANITIZAR ESTO ANTES! */ }} />

                         {/* OPCIÓN B: Si guardaste Markdown */}
                         {/* <ReactMarkdown remarkPlugins={[remarkGfm]}> */}
                         {/*    {article.content} */}
                         {/* </ReactMarkdown> */}
                    </div>

                     {/* Tags (Opcional) */}
                     {article.tags && article.tags.length > 0 && (
                         <div className="mt-8 pt-4 border-t">
                             <span className="font-semibold text-sm mr-2">Tags:</span>
                             {article.tags.map((tag, index) => (
                                 <span key={index} className="inline-block bg-gray-200 rounded-full px-3 py-1 text-xs font-medium text-gray-700 mr-2 mb-2">
                                     {tag}
                                 </span>
                             ))}
                         </div>
                     )}

                     {/* Botón Volver (Opcional) */}
                     {/* <Link href="/resources" className="inline-block mt-8 text-blue-600 hover:underline">← Back to Resources</Link> */}

                </article>
            )}
        </div>
    );
}
