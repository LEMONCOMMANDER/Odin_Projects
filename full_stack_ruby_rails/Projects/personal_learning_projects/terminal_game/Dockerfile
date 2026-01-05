# syntax=docker/dockerfile:1

FROM ubuntu:latest
LABEL authors="lemonlord"

#install ruby
#RUN apt-get install ruby-full
RUN apt-get update && apt-get install -y ruby-full build-essential

RUN gem install bundler

#create a dir called 'terminal_game' and -- set it as the working dir -- << how to do this?
RUN mkdir terminal_game
#whatever the set working dir is, do here... maybe
# Create and set working directory -- from ai
#WORKDIR /terminal_game

# Copy local terminal_game directory into container
COPY . /terminal_game

# Install gems (if Gemfile exists) - ai
RUN if [ -f Gemfile ]; then bundle install; fi
