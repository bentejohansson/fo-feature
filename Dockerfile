FROM realguess/jq
COPY test.json .
RUN jq . < test.json

FROM nginx
COPY --from=0 test.json .
