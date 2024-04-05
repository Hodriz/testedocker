
FROM node:alpine AS build-stage

WORKDIR usr/src/app

COPY package*.json ./

RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build


FROM nginx:alpine AS production-stage
COPY --from=build-stage /usr/src/app/dist /usr/share/nginx/html
COPY --from=build-stage /usr/src/app/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]