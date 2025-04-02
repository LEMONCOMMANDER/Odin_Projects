require 'httparty'
require_relative './api_config'
require 'json'

module GptGenerations
  def self.names(character)


    name = {first_name: '', last_name: ''}
    name
  end


  def self.ask(prompt)
  response = HTTParty.post(API_REQUEST_CONFIG[:'chat-gpt'][:host],
                           headers: API_REQUEST_HEADERS[:'chat-gpt'],
                           body: JSON.generate({
                                                    model: 'gpt-4o',
                                                    "messages": [
                                                                  {
                                                                    role: 'user',
                                                                    content: "#{prompt}"
                                                                  }
                                                                ]
                                                    }
                                               )
                           )
  output = JSON.parse(response.body, symbolize_names: true)


  puts output[:choices][0][:message][:content]
  end
end