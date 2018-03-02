FROM nginx:stable

COPY nginx.conf /etc/nginx/
COPY app.conf /etc/nginx/sites-available/

RUN rm /etc/nginx/conf.d/default.conf
RUN ln -s /etc/nginx/sites-available/app.conf /etc/nginx/conf.d/default.conf
