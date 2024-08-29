require 'rails_helper'

RSpec.describe CustomersController, type: :controller do

  describe "#index" do
    it 'Responds successfully' do
      get :index
      expect(response).to have_http_status :ok
    end
  end

  describe "#create" do
    it 'Should create a customer' do
      post :create , params: { customer: {name: "abc", email: "abc@email.com", address: "ABCABCABCA"}}
      expect(response).to have_http_status :created
    end

    context "Without address" do
      it "Shouldn't create a customer" do
        post :create , params: { customer: {name: "abc", email: "abc@email.com"}}
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end