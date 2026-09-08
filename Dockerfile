FROM node:20-bookworm-slim AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build
FROM node:20-bookworm-slim AS runtime
WORKDIR /app
RUN useradd --system --uid 10001 --no-create-home --shell /usr/sbin/nologin appuser
RUN chown 10001:10001 /app
COPY --from=build --chown=10001:10001 /app /app
ENV HOST=0.0.0.0 PORT=4321 HOME=/app
USER 10001
EXPOSE 4321
CMD ["sh", "-c", "npm run dev -- --host 0.0.0.0 --port 4321"]
