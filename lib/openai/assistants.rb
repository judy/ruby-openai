module OpenAI
  class Assistants
    def initialize(client:)
      @client = client
    end

    def list
      @client.get(path: "/assistants")
    end

    def create(parameters: {})
      @client.json_post(path: "/assistants", parameters: parameters)
    end

    def retrieve(id:)
      @client.get(path: "/assistants/#{id}")
    end
  end
end
