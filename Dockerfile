FROM node:20-alpine AS base
ENV PATH="/app/node_modules/.bin:$PATH"
WORKDIR /app
COPY package*.json ./
# RUN npm install --mount=type=cache,id=my-ai-agent/react-poc/npm-cache,target=/usr/local/share/.cache/npm/v10
RUN npm i
RUN npm i -g next
COPY . ./


FROM base AS build
RUN npm run build

FROM base AS test
RUN ["npm", "test"]

FROM base AS debug
CMD ["tail", "-f", "/dev/null"]

FROM base AS development
ENV NODE_ENV=development
CMD [ "npm", "run","start:dev" ]

FROM build AS production
ENV NODE_ENV=production
CMD [ "npm", "start" ]
