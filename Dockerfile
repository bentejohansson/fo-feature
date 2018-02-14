# Validate JSON files and write sanitized output to /env.in/
FROM python
COPY environments /env
COPY json_equality_check.py /check.py
RUN python3 /check.py /env/*.json

# Deploy environment files to an nginx container.
FROM nginx
ENV FASIT_ENVIRONMENT_NAME default
COPY environments /www/_environments/
COPY templates /templates/
COPY entrypoint.sh /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD ["nginx", "-g", "daemon off;"]
