FROM oven/bun:latest

# Set the working directory
WORKDIR /app

COPY package.json bun.lockb ./
RUN bun install

COPY . .

EXPOSE 8000

CMD ["bun", "index.ts"]