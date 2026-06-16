# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.4.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Instala pacotes base e dependências do Oracle Client (libaio1)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips libaio1 wget unzip && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Configura variáveis de ambiente globais
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so" \
    LD_LIBRARY_PATH="/opt/oracle/instantclient_21_15" \
    PATH="$PATH:/opt/oracle/instantclient_21_15"

# --- FASE DE BUILD ---
FROM base AS build

# Instala ferramentas de compilação básicas e libs de desenvolvimento
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Baixa e configura o Oracle Instant Client SDK para a Gem poder compilar as extensões em C
RUN mkdir -p /opt/oracle && cd /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/2115000/instantclient-basiclite-linux.x64-21.15.0.0.0dbru.zip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/2115000/instantclient-sdk-linux.x64-21.15.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-21.15.0.0.0dbru.zip && \
    unzip instantclient-sdk-linux.x64-21.15.0.0.0dbru.zip && \
    rm -f *.zip

# Instala as gems do aplicativo
COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile -j 1 --gemfile

# Copia o código da aplicação
COPY . .

# Pré-compila o Bootsnap e Assets
RUN bundle exec bootsnap precompile -j 1 app/ lib/
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# --- FASE FINAL ---
FROM base

# Instala o Oracle Instant Client de runtime na imagem final
RUN mkdir -p /opt/oracle && cd /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/2115000/instantclient-basiclite-linux.x64-21.15.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-21.15.0.0.0dbru.zip && \
    rm -f *.zip

# Executa como usuário não-root por segurança
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash

# Define permissões na pasta do Oracle para o usuário rails conseguir ler os drivers
RUN chown -R rails:rails /opt/oracle

USER 1000:1000

# Copia os artefatos gerados no build
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]