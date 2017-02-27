FROM nginx:1.11.10
RUN mkdir -p /usr/share/nginx/html
COPY ./deploy /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
