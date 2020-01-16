# Load the Docker image.
FROM ruby:2.7.0-alpine3.11

# Define environment variables.
ENV LANG C.UTF-8
ENV PS1 '▶ '

# Install Packages.
RUN apk update && apk upgrade && apk add --update --no-cache build-base git npm

# Install Rails.
RUN gem install rails

# Install Vue CLI.
RUN npm i @vue/cli @vue/cli-init -g

# Set up a work directory.
WORKDIR /nuxt-on-rails
