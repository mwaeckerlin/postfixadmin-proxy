FROM mwaeckerlin/very-base as postfixadmin
RUN $PKG_INSTALL postfixadmin
RUN mv /usr/share/webapps/postfixadmin /root/app

FROM mwaeckerlin/nginx as nginx

FROM mwaeckerlin/very-base as config
COPY --from=nginx /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
RUN sed -i 's/ php-fpm;/ postfixadmin;/' /etc/nginx/conf.d/default.conf
RUN sed -i 's,root /app;,root /app/public;,g' /etc/nginx/conf.d/default.conf

FROM mwaeckerlin/nginx
COPY --from=config /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY --from=postfixadmin /root/app /app
