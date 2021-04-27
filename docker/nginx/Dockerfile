FROM nginx:latest

RUN rm -f /etc/nginx/conf.d/*

COPY app.conf /etc/nginx/conf.d/app.conf

CMD ["nginx", "-g", "daemon off;"]
