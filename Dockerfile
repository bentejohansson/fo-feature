# Validate JSON files and write sanitized output to /env.in/
FROM realguess/jq
COPY environments /env.in
RUN mkdir /env.out
RUN cd /env.in && find . -type f -exec sh -c 'jq . < {} > /env.out/{}' \;

# Deploy environment files to an nginx container.
FROM nginx
ENV FO_FEATURE_APPLICATIONPROPERTIES=hello_world
COPY --from=0 /env.out/ /www/_environments/
COPY nginx.conf /nginx.conf.template
COPY entrypoint.sh /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD ["nginx", "-g", "daemon off;"]
