FROM ruby:3.1.2

RUN apt-get -y update && \
apt-get -y upgrade && \
apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install \
build-essential \
git \
libpq-dev \
nodejs \
npm \
sqlite3 \
tzdata && \
apt-get clean

# setup ruby gems
RUN gem update --system && \
gem install bundler && \
bundle config set --global --without test

# setup yarn
RUN npm install -g yarn

# get application code
RUN rm -rf /opt/haley-capstone
RUN git clone --origin github --branch main --depth 1 https://github.com/wasatchtimpanogos/haleyCapstone.git /opt/haley-capstone

# install application dependencies 1st time
WORKDIR /opt/haley-capstone
RUN yarn --ignore-engines
RUN bundle

# prepare the environment
ENV RAILS_ENV=production RAILS_LOG_TO_STDOUT=true RAILS_SERVE_STATIC_FILES=true

# prepare and run the application
CMD git checkout . && \
git pull --no-rebase github main && \
yarn --ignore-engines && \
bundle && \
rm -f tmp/pids/server.pid && \
bin/rails db:migrate && \
bin/rails s --binding=0.0.0.0 --port=3000
