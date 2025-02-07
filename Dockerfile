#docker run -d -p 80:80 -v [path to your config.js]:/usr/share/nginx/html/config.js ghcr.io/playfab/thundernetes-ui:[current tag]
# Step 1: Build static react app
FROM node:18-alpine3.15 AS builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Step 2: Run image
FROM nginx:1.23-alpine
COPY --from=builder /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
COPY config.js /usr/share/nginx/html/config.js
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
