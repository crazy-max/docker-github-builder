# syntax=docker/dockerfile:1

FROM alpine
ARG BUILDX_VERSION
ARG CI
ARG GITHUB_SHA
ARG RUNNER_OS
ARG XX_VERSION
ARG DOCKER_METADATA_OUTPUT_VERSION
ARG DOCKER_METADATA_OUTPUT_TAGS
ARG DOCKER_METADATA_OUTPUT_LABELS
RUN test "$BUILDX_VERSION" = "not-leaked"
RUN test "$CI" = "true"
RUN test -n "$GITHUB_SHA"
RUN test -n "$RUNNER_OS"
RUN test "$XX_VERSION" = "1.9.0"
RUN test "$DOCKER_METADATA_OUTPUT_VERSION" = "caller-version"
RUN printf '%s\n' "$DOCKER_METADATA_OUTPUT_TAGS" | grep -Fx 'example/app:vars-one' \
    && printf '%s\n' "$DOCKER_METADATA_OUTPUT_TAGS" | grep -Fx 'example/app:vars-two'
RUN printf '%s\n' "$DOCKER_METADATA_OUTPUT_LABELS" | grep -Fx 'org.example.vars.one=one' \
    && printf '%s\n' "$DOCKER_METADATA_OUTPUT_LABELS" | grep -Fx 'org.example.vars.two=two'
RUN mkdir -p /out && printf 'ok\n' > /out/vars.txt

FROM scratch
COPY --from=0 /out /
