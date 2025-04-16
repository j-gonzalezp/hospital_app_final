// src/app/(main)/resources/page.tsx
import React from 'react';
import PageTitle from '@/components/common/PageTitle';
import ErrorMessage from '@/components/common/ErrorMessage';
import ArticleCard from '@/components/articles/ArticleCard'; // Importa el nuevo componente
import { getPublishedArticles } from '@/lib/actions'; // Importa la action
import type { ArticleWithDetails } from '@/types/article.d.ts'; // Importa el tipo

// Podrías añadir paginación aquí usando searchParams para 'page'
// y pasando limit/offset a getPublishedArticles
export default async function ResourcesPage(/* { searchParams } */) {
    let articles: ArticleWithDetails[] = [];
    let error: string | null = null;
    // const currentPage = Number(searchParams?.page || 1);
    // const articlesPerPage = 9; // Por ejemplo
    // const offset = (currentPage - 1) * articlesPerPage;

    try {
        // articles = await getPublishedArticles(articlesPerPage, offset);
        articles = await getPublishedArticles(); // Obtiene los primeros 10 por defecto
    } catch (err: unknown) {
        console.error("Error loading articles page:", err);
        if (err instanceof Error) {
            error = err.message;
        } else {
            error = "An unknown error occurred while loading articles.";
        }
        articles = [];
    }

    return (
        <div>
            <PageTitle title="Health Resources" subtitle="Stay informed with our latest articles and health tips." />

            {error && <ErrorMessage message={error} className="my-4" />}

            {/* Grid para mostrar las tarjetas de artículos */}
            {!error && articles.length > 0 && (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6">
                    {articles.map((article) => (
                        <ArticleCard key={article.$id} article={article} />
                    ))}
                </div>
            )}

             {/* Aquí podrías añadir controles de paginación */}
             {/* <Pagination totalPages={totalPages} currentPage={currentPage} /> */}


            {/* Mensaje si no hay artículos y no hubo error */}
            {!error && articles.length === 0 && (
                 <p className="text-center text-gray-600 py-10">
                    No articles published yet. Please check back soon.
                 </p>
             )}
        </div>
    );
}
