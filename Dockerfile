# Dockerfile

# ---- Stage 1: Build ----
    FROM node:20-alpine AS builder
    WORKDIR /app
    COPY package*.json ./
    RUN npm ci
    COPY . .
    ENV NODE_ENV production
    RUN npm run build
    
    # ---- Stage 2: Production Runner ----
    FROM node:20-alpine AS runner
    WORKDIR /app
    ENV NODE_ENV production
    ENV NEXT_TELEMETRY_DISABLED 1
    RUN addgroup --system --gid 1001 nodejs
    RUN adduser --system --uid 1001 nextjs
    
    # Copia los artefactos necesarios desde la etapa 'builder'
    COPY --from=builder --chown=nextjs:nodejs /app/public ./public
    COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
    COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
    
    USER nextjs
    EXPOSE 3000
    ENV PORT 3000
    CMD ["node", "server.js"]