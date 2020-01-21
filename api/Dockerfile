# Load the Docker image.
FROM ruby:2.6.5-alpine3.11

# Define environment variables.
ENV LANG C.UTF-8
ENV PS1 '▶ '
ARG API_ROOT=/nuxt-on-rails/api

# Install Packages.
RUN apk update && apk upgrade && apk add --update --no-cache \
      build-base \
      curl-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      postgresql-dev \
      ruby-dev \
      yaml-dev \
      graphviz \
      zlib-dev \
      bash \
      git \
      openssh \
      postgresql \
      ruby-json \
      tzdata \
      vim \
      nodejs \
      yaml

# Set up a work directory.
WORKDIR $API_ROOT

# Install Gems
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install -j4

# Add Puma SSL certificate files.
ADD ./keys/server.crt /home/root/.ssh/server.crt
ADD ./keys/server.key /home/root/.ssh/server.key

# Start the application server.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
