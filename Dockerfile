FROM ruby:2.4.1
RUN apt-get update && apt-get install -y build-essential nodejs
ENV HOME=/home/garage_tasks
RUN mkdir ${HOME}
WORKDIR ${HOME}
COPY Gemfile ${HOME}/Gemfile
COPY Gemfile.lock ${HOME}/Gemfile.lock
RUN bundle install