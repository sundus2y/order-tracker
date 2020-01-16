FROM ruby:2.5.5
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential
RUN apt-get install -y libpq-dev
RUN apt-get install -y nodejs
RUN apt-get install -y --no-install-recommends yarn

ENV APP_HOME /var/www/ots
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ENV RAILS_ROOT $APP_HOME
ENV ADMIN_NAME 'Sundus'
ENV ADMIN_EMAIL 'sundus2y@gmail.com'
ENV ADMIN_PASSWORD 'Admin!123'
ENV GMAIL_USERNAME 'sundus2y@gmail.com'
ENV GMAIL_PASSWORD 'gmailpassword'
ENV DOMAIN_NAME 'ots.com'
ENV SECRET_KEY_BASE '3363cd9679f62ff36dee249c1e3425a4d895cb04f1d10e5adc60c56fc33d51441d2b1144195d5bf3065af1c1d85b3b5f1b722dbfdf112cce18d804992ea4e2d7'
ENV RAILS_ENV='production'
ENV RACK_ENV='production'
ENV RAILS_SERVE_STATIC_FILES=true
#ENV PORT 80
ENV WEB_CONCURRENCY 5

COPY ./Gemfile $APP_HOME/
COPY ./Gemfile.lock $APP_HOME/

RUN gem install bundler -v2.0.2
RUN bundle install --without development test

COPY . $APP_HOME
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]