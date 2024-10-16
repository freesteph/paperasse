FROM ruby:3.3.5-slim

EXPOSE 3000

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends build-essential

# do the bundle install in another directory with the strict essential
# (Gemfile and Gemfile.lock) to allow further steps to be cached
# (namely the NPM steps)
WORKDIR /bundle
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Move to the main folder
WORKDIR /app

COPY . .

CMD ["bash"]
