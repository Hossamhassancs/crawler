FROM ruby:3.1.2

WORKDIR /usr/src/app

# Install the byebug gem
RUN gem install parallel nokogiri redis 

# Copy Ruby script and necessary files
COPY app.rb file_manager.rb scrapper.rb urls-dev-test.txt keywords-dev-test.txt redis_fetcher.rb csv_exporter.rb example-output-dev-test.csv ./




# Run the Ruby script
CMD ["ruby", "app.rb"]
