# Validate JSON files and write sanitized output to /env.in/
FROM realguess/jq
COPY environments /env.in
RUN mkdir /env.out
RUN cd /env.in && find . -type f -exec sh -c 'jq . < {} > /env.out/{}' \;

# Deploy environment files to an nginx container.
FROM nginx
COPY --from=0 /env.out/ /usr/share/nginx/html
