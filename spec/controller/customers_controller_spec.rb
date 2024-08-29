require 'rails_helper'

RSpec.describe CustomersController, type: :controller do

  context 'As a Guest' do
    describe "#index" do
      it 'responds successfully - responds 200' do
        get :index
        expect(response).to have_http_status :ok
      end
    end

    describe "#show" do
      it 'responds a 302 response (not authorized)' do
        customer = create(:customer)
        get :show, params: { id: customer.id }
        expect(response).to have_http_status :found
      end
    end
  end  
  
  context 'As logged Member' do
    before do
      @member = create(:member)
      @customer = create(:customer)
    end

    it 'Content-Type JSON' do
      customer_params = attributes_for(:customer)
      sign_in @member
      post :create, format: :json, params: { customer: customer_params }
      expect(response.content_type).to include('application/json')
    end

    it 'with valid attributes' do
      customer_params = attributes_for(:customer)
      sign_in @member
      expect{ 
        post :create, params: { customer: customer_params }
      }.to change(Customer, :count).by(1)
    end

    it 'with invalid attributes' do
      customer_params = attributes_for(:customer, address: nil)
      sign_in @member
      expect{ 
        post :create, params: { customer: customer_params }
      }.not_to change(Customer, :count)
    end

    describe '#show' do
      it 'responds successfully - responds 200' do
          sign_in @member
        
          get :show, params: { id: @customer.id }
          expect(response).to have_http_status :ok
      end

      it 'render a :show template' do
        sign_in @member
      
        get :show, params: { id: @customer.id }
        expect(response).to render_template(:show)
      end
    end
    
    describe 'Notice' do
      it do
      customer_params = attributes_for(:customer)
      sign_in @member
      post :create, params: { customer: customer_params }
      expect(flash[:notice]).to match("Customer was successfully created.")
      end
    end

    describe 'Routes' do
      it { should route(:get, '/customers').to(action: :index)}
    end
  end
end
