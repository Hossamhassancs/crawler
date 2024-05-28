require 'nokogiri'
require 'net/http'
require 'uri'
require 'parallel'
require 'redis'
require 'json'


class Scrapper

  X_PATH = %w[
    h1 h2 h3 h4 h5 h6 p span div li a blockquote cite figcaption
    address summary article section aside label legend dt dd th td nav
  ].map { |tag| "//#{tag}" }.join(' | ')
  
  def initialize(urls, api_token, base_url)
    @urls = urls
    @redis = Redis.new(url: ENV['REDIS_URL'])
    @api_token = api_token
    @base_url = base_url
  end

  def scrape_and_save
    results = Parallel.map(@urls, in_threads: 5) do |url|
      begin
        sentences = fetch_and_parse(url)
        write_sentences_in_redis(url, sentences)
        { url: url, sentences: sentences }
      rescue StandardError => e
        puts "Error crawling URL #{url}: #{e.message}"
        nil
      end
    end.compact
  end

  private

  def fetch_and_parse(url)
    html_content = fetch_html(url)
    doc = Nokogiri::HTML(html_content)
    extract_sentences(doc)
  end

  def fetch_html(url)
    full_url = "#{@base_url}/?token=#{@api_token}&url=#{url}"
    uri = URI.parse(full_url)
    response = Net::HTTP.get_response(uri)
    raise "Error fetching URL: #{url}" unless response.is_a?(Net::HTTPSuccess)

    response.body
  end

  def extract_sentences(doc)
    sentences = []
    doc.xpath(X_PATH).each do |node|
      sentences.concat(split_into_sentences(node.text))
    end
    sentences
  end

  def split_into_sentences(text)
    text.split(/(?<=[.!?])\s+/)
  end

  def write_sentences_in_redis(url, sentences)
    @redis.set(url, sentences.to_json)
  end
end