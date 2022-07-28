FROM codacy/ci-base AS builder

RUN apk add --update --no-cache --force-overwrite \
    openssl openssl-dev crystal shards g++ gc-dev \
    libc-dev libevent-dev libxml2-dev llvm llvm-dev \
    llvm-static make pcre-dev readline-dev \
    yaml-dev zlib-dev git

RUN  git config --global user.email "dung@productsway.com" && git config --global user.name "Dung Huynh Duc"

RUN mkdir -p /workspace

WORKDIR /workspace
COPY ./ /workspace

ENV ALPINE=1

RUN make test build



FROM codacy/ci-base

LABEL maintainer="dung@productsway.com"

RUN apk add --update --no-cache --force-overwrite gc-dev pcre-dev libevent-dev git

COPY --from=builder /workspace/bin/git-version /bin

RUN mkdir -p /repo
VOLUME /repo

CMD ["/bin/git-version", "--folder=/repo"]
