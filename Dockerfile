FROM ruby:2.5.0-alpine

MAINTAINER opensanca@opensanca.com

ARG rails_env="development"
ARG build_without=""

ENV APP_PATH /usr/src/app

WORKDIR ${APP_PATH}

RUN apk update \
  && apk add \
    openssl \
    tar \
    build-base \
    tzdata \
    postgresql-dev \
    nodejs \
  && wget https://yarnpkg.com/latest.tar.gz \
  && mkdir -p /opt/yarn \
  && tar -xf latest.tar.gz -C /opt/yarn --strip 1 \
  && mkdir ./log

ENV PATH="$PATH:/opt/yarn/bin" BUNDLE_PATH="/usr/local/bundle" BUNDLE_JOBS=2 RAILS_ENV=${rails_env} BUNDLE_WITHOUT=${bundle_without}

COPY . ${APP_PATH}

RUN bundle install && yarn && bundle exec rake assets:precompile

CMD rails s -b 0.0.0.0
