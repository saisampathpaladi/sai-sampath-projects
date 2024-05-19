FROM nginx:alpine
COPY src/ /usr/share/nginx/html
# ENV PRODUCTION=true
EXPOSE 80
# nginx defaults to this command
CMD ["nginx", "-g", "daemon off;"]


