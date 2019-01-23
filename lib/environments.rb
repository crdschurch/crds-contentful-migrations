require 'active_support/inflector'
require 'waitutil'

class Environments
  include HTTParty
  include ActiveSupport::Inflector
  base_uri 'https://api.contentful.com'

  def initialize
    @path = "/spaces/#{ENV['CONTENTFUL_SPACE_ID']}/environments"
    @headers = {
      "Authorization" => "Bearer #{ENV['CONTENTFUL_MANAGEMENT_ACCESS_TOKEN']}",
      "Content-Type" => "application/vnd.contentful.management.v1+json"
    }
  end

  def create!(env)
    id = env[0..39].parameterize
    unless ls.include?(id)
      response = self.class.put("#{@path}/#{id}", body: { name: id }.to_json, headers: @headers)
      if response.success?
        STDOUT.write "#{ENV['CONTENTFUL_SPACE_ID']}/#{id} created successfully\n"
        WaitUtil.wait_for_condition('environment created', verbose: true, timeout_sec: 300) do
          env_req = self.class.get("#{@path}/#{id}", headers: @headers)
          env_req.success? && JSON.parse(env_req.body).dig('sys', 'status', 'sys', 'id') == 'ready'
        end
      else
        STDOUT.write "There was a problem: #{response.response.message}\n"
      end
      id
    end
  end

  def destroy!(env)
    id = env[0..39].parameterize
    if ls.include?(id)
      response = self.class.delete("#{@path}/#{id}", headers: @headers)
      if response.success?
        STDOUT.write "#{ENV['CONTENTFUL_SPACE_ID']}/#{id} destroyed successfully\n"
      else
        STDOUT.write "There was a problem: #{response.response.message}\n"
      end
    end
  end

  def ls
    response = self.class.get(@path, headers: @headers)
    if response.success?
      JSON.parse(response.body).dig('items').collect{|r| r['name'] }
    end
  end

  def exists?(env)
    ls.include? env.parameterize
  end

end