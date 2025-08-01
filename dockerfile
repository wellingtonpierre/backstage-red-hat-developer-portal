FROM node:18

WORKDIR /app
COPY . .

# Instalar dependencias del sistema necesarias para better-sqlite3
RUN apt-get update && apt-get install -y \
  python3 \
  build-essential \
  pkg-config \
  libsqlite3-dev \
  && rm -rf /var/lib/apt/lists/*

# Habilitar Yarn 4
RUN corepack enable && corepack prepare yarn@4.4.1 --activate

# Agregamos el plugin antes de instalar dependencias (para que el lockfile lo incluya)
RUN yarn --cwd packages/backend add @backstage/plugin-auth-backend-module-github-provider

# Verifica si el archivo existe
RUN ls -la /app/packages/backend/src || echo "NO EXISTE src/index.ts"
RUN ls -la /app/packages/backend/src/index.ts || echo "NO EXISTE index.ts"

# Instalación y compilación
RUN yarn install --frozen-lockfile
WORKDIR /app/packages/backend
RUN yarn build

EXPOSE 7007
CMD ["yarn", "start"]
