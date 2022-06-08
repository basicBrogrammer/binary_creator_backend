require 'httparty'

class Printer
  include HTTParty
  base_uri 'https://api.printify.com/v1'
  TOKEN = ENV['PRINTIFY_TOKEN']
  SHOP_ID = '4521217'
  BLUEPRINT_ID = 12 # Unisex Jersey Short Sleeve Tee
  PROVIDER_ID = 39 # Scalable Press

  class << self
    def list_shops
      get('/shops.json')
    end

    def upload(text:, file:)
      post('/uploads/images.json', body: { file_name: text, contents: file }.to_json)
    end

    def create_product(text:, image_id:, variants:)
      post("/shops/#{SHOP_ID}/products.json", body: {
        "title": text,
        "description": "A Binary Tee that says '#{text}'",
        "blueprint_id": 384,
        "print_provider_id": 1,
        "variants": variants.map { |v| { id: v['id'], price: 30, is_enabled: true } },
        "print_areas": [
          {
            "variant_ids": [45_740, 45_742, 45_744, 45_746],
            "placeholders": [
              {
                "position": 'front',
                "images": [
                  {
                    "id": image_id,
                    "x": 0.5,
                    "y": 0.5,
                    "scale": 1,
                    "angle": 0
                  }
                ]
              }
            ]
          }
        ]
      }.to_json)
    end

    def list_blueprints
      get('/catalog/blueprints.json')
    end

    def list_variants
      get("/catalog/blueprints/#{BLUEPRINT_ID}/print_providers/#{PROVIDER_ID}/variants.json")['variants']
    end

    def get(*args)
      super(*args, headers: { 'Authorization' => "Bearer #{TOKEN}" })
    end

    def post(*args)
      args[1].merge!(headers: { 'Authorization' => "Bearer #{TOKEN}" })
      super(*args)
    end
  end
end
