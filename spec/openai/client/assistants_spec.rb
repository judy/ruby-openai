RSpec.describe OpenAI::Client do
  describe "#assistants", :vcr do
    let(:extra_headers) { { "OpenAI-Beta" => "assistants=v1" } }
    let(:name) { "Coding Assistant" }
    let(:model) { "gpt-3.5-turbo" }
    let(:create) do
      VCR.use_cassette(create_cassette) do
        OpenAI::Client.new.assistants.create(
          parameters: {
            name: name,
            model: model
          }
        )
      end
    end
    let(:create_id) { create["id"] }

    before do
      OpenAI.configure do |config|
        config.extra_headers = extra_headers
      end
    end

    after do
      OpenAI.configure do |config|
        config.extra_headers = nil
      end
    end

    describe "#list", :vcr do
      let(:cassette) { "assistants list" }
      let(:create_cassette) { "#{cassette} create" }
      let(:response) { OpenAI::Client.new.assistants.list }

      before { create }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          puts response.inspect
          expect(response.dig("data").length).to eql(1)
          expect(response.dig("data", 0, "id")).to eql(create_id)
          expect(response.dig("data", 0, "name")).to eql(name)
        end
      end
    end

    describe "#create", :vcr do
      let(:cassette) { "assistants create" }
      let(:response) do
        OpenAI::Client.new.assistants.create(
          parameters: {
            model: model
          }
        )
      end

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response.dig("model")).to eql(model)
        end
      end
    end

    describe "#retrieve" do
      let(:cassette) { "assistants retrieve" }
      let(:create_cassette) { "#{cassette} create" }
      let(:response) { OpenAI::Client.new.assistants.retrieve(id: create_id) }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response.dig("model")).to eql(model)
          expect(response.dig("name")).to eql(name)
        end
      end
    end
  end
end
