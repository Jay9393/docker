FROM ruby:3.0.0-alpine

RUN apk add --update --virtual \
  runtime-deps \
  build-base \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  yarn \
  libffi-dev \
  readline \
  build-base \
  libc-dev \
  linux-headers \
  readline-dev \
  file \
  imagemagick \
  git \
  tzdata \
  && rm -rf /var/cache/apk/*

WORKDIR /app
COPY . /app/

ENV BUNDLE_PATH /gems
RUN yarn install
RUN bundle config --local build.mysql2 --with-ldflags="-L $(brew --cellar zstd)/1.5.0/lib -L $(brew --prefix openssl)/lib" --with-ldlibs="-lzstd -lssl" --with-cppflags="-I $(brew --prefix openssl)/include"
RUN gem install mysql2 -v '0.5.3' -- \
  --with-ldflags=-L/usr/local/opt/openssl/lib \
  --with-cppflags=-I/usr/local/opt/openssl/include
RUN bundle install

ENTRYPOINT [ "bin/rails" ]
CMD ["s", "-b", "0.0.0.0"]

EXPOSE 3000