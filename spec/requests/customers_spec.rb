require 'rails_helper'

RSpec.describe "Customers", type: :request do
  describe '#index' do
    it 'Response Body' do
      get "/customers.json"
      expect(response.body).to include_json([
      id: /\d/,
      name: (be_kind_of String),
      email: (be_kind_of String)
    ])
    end

    it 'JSON 200 ok' do
      get "/customers/1.json"
      expect(response).to have_http_status(200)
    end
  end

  describe '#show' do
    it 'Response Body' do
      get "/customers/1.json"
      expect(response.body).to include_json(
      id: /\d/,
      name: (be_kind_of String),
      email: (be_kind_of String)
      )
    end

    it 'Response Body - RSpec Puro' do
      get "/customers/1.json"
      response_body = JSON.parse(response.body)
      expect(response_body.fetch("id")).to eq(1) 
      expect(response_body.fetch("name")).to be_kind_of(String)
      expect(response_body.fetch("email")).to be_kind_of(String)
    end

    it 'JSON 200 ok' do
      get "/customers/1.json"
      expect(response).to have_http_status(200)
    end
  end

  describe '#post' do
    it 'create - JSON' do
      member = create(:member)
      login_as(member, scope: :member)

      headers = { "ACCEPT" => "application/json" }

      customers_params = attributes_for(:customer)

      post "/customers.json", params: { customer: customers_params }, headers: headers

      expect(response.body).to include_json(
      id: /\d/,
      name: customers_params.fetch(:name),
      email: customers_params.fetch(:email)
      )
    end
  end

  describe '#patch' do
    it 'update - JSON' do
      member = create(:member)
      login_as(member, scope: :member)

      headers = { "ACCEPT" => "application/json" }

      customers = Customer.first 
      customers.name += ' - ATUALIZADO'

      patch "/customers/#{customers.id}.json", params: { customer: customers.attributes }, headers: headers

      expect(response.body).to include_json(
      id: /\d/,
      name: customers.name,
      email: customers.email
      )
    end
  end

  describe '#destroy' do
    it 'delete - JSON' do
      member = create(:member)
      login_as(member, scope: :member)

      headers = { "ACCEPT" => "application/json" }

      customers = Customer.first 
      customers.name += ' - ATUALIZADO'

      expect {delete "/customers/#{customers.id}.json", headers: headers }.to change(Customer, :count).by(-1)
    end
  end

  describe 'JSON Schema' do
    it do
      get '/customers/1.json'
      expect(response).to match_response_schema("customer")
    end
  end
end

