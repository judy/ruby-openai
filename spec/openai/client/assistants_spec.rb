RSpec.describe OpenAI::Client do
  describe "#assistants", :vcr do
    let(:extra_headers) { { "OpenAI-Beta" => "assistants=v1" } }

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

    describe "#generate", :vcr do
      let(:response) do
        OpenAI::Client.new.assistants.create(
          parameters: {
            model: model
          }
        )
      end
      let(:cassette) { "assistants create" }
      let(:model) { "gpt-3.5-turbo" }

      it "succeeds" do
        VCR.use_cassette(cassette) do
          expect(response.dig("model")).to eql(model)
        end
      end
    end
  end
end
