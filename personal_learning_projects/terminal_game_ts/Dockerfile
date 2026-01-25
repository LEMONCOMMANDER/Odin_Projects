# syntax=docker/dockerfile:1

FROM node:current
LABEL authors="lemonlord"

# working_dir - is a little redundant here since I am running this from the "root" directory of this folder... but if I
# stored my dockerfile in odin_projects/ instead, I would want this set to ./js_ts_projects/terminal_game_ts
WORKDIR /terminal_game_ts

#--save-dev will install it in the developer dependencies in the package.json, which will not build in prod envionrments
RUN npm install typescript --save-dev

# typescript compiler that takes ts and compiles into js - but i don't think i need this here
#RUN npx tsc


#create a dir called 'terminal_game_ruby' and -- set it as the working dir -- << how to do this?
RUN mkdir terminal_game_ts
#whatever the set working dir is, do here... maybe

# Copy local terminal_game_ruby directory into container
COPY . /terminal_game_ts

## Install gems (if Gemfile exists) - ai
#RUN if [ -f Gemfile ]; then bundle install; fi
