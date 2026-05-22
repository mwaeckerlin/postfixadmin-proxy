FROM mwaeckerlin/very-base as postfixadmin
RUN $PKG_INSTALL postfixadmin
RUN mv /usr/share/webapps/postfixadmin /root/app

FROM mwaeckerlin/nginx
ENV PHP_FPM_HOST "postfixadmin"
ENV ROOT "/app/public"
COPY --from=postfixadmin /root/app /app
