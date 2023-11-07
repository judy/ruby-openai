module OpenAI
  class Assistants
    def initialize(client:)
      @client = client
    end

    def create(parameters: {})
      @client.json_post(path: "/assistants", parameters: parameters)
    end
  end
end
