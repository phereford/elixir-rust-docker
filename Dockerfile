FROM erlang:22.2.3

ENV ELIXIR_VERSION="v1.9.4"
ENV RUST_VERSION="1.40.0"
ENV NODE_VERSION="11.6.0"
ENV LANG="C.UTF-8"

RUN apt-get update && \
    apt-get install \
       ca-certificates \
       curl \
       gcc \
       libc6-dev \
       -qqy \
       --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Elixir
RUN set -xe \
    && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
    && ELIXIR_DOWNLOAD_SHA256="f86170bde3b3ad3d1365f34f77ab9cb424c4638a4067fd7d509787c03dea0d40061ef1a2c8d1d9e42bec65b8cda8c1bf32801e4712531eeaef50e0cd53ac2369" \
    && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
    && echo "$ELIXIR_DOWNLOAD_SHA256  elixir-src.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/local/src/elixir \
    && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
    && rm elixir-src.tar.gz \
    && cd /usr/local/src/elixir \
    && make install clean

# Install Rust
RUN RUST_ARCHIVE="rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz" && \
    RUST_DOWNLOAD_URL="https://static.rust-lang.org/dist/$RUST_ARCHIVE" && \
    mkdir -p /rust \
    && cd /rust \
    && curl -fsOSL $RUST_DOWNLOAD_URL \
    && curl -s $RUST_DOWNLOAD_URL.sha256 | sha256sum -c - \
    && tar -C /rust -xzf $RUST_ARCHIVE --strip-components=1 \
    && rm $RUST_ARCHIVE \
    && ./install.sh

# Install Node.js
ENV NODE_DOWNLOAD_URL="https://deb.nodesource.com/setup_$NODE_VERSION"
RUN curl -sL $NODE_DOWNLOAD_URL | bash - \
    && apt-get install -y nodejs

# Install Docker
RUN curl -fsSL "https://get.docker.com" | sh
