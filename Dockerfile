# Validate JSON files and write sanitized output to /env.in/
FROM realguess/jq
COPY environments /env.in
RUN mkdir /env.out
RUN cd /env.in && set -e && for file in *.json; do jq . < $file > /env.out/$file; done

# Deploy environment files to an nginx container.
FROM nginx
ENV ENVIRONMENT default
COPY --from=0 /env.out/ /www/_environments/
COPY nginx.conf /nginx.conf.template
COPY entrypoint.sh /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD ["nginx", "-g", "daemon off;"]
