FROM postgres:16

# Install build tools and dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    postgresql-server-dev-16 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# ---- Install pgvector ----
RUN git clone --branch v0.7.4 https://github.com/pgvector/pgvector.git \
    && cd pgvector \
    && make \
    && make install

# ---- Install Apache AGE ----
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    libreadline-dev \
    zlib1g-dev \
    flex \
    bison

RUN git clone https://github.com/apache/age.git \
    && cd age \
    && git checkout PG16/v1.6.0-rc0 \
    && make \
    && make install
