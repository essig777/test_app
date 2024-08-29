require 'rails_helper'

RSpec.describe Customer, type: :model do
  it 'Create a customer' do
    customer = create(:customer)
    expect(customer.full_name).to start_with('Sr. ')
  end

  it 'Create a vip customer' do
    customer = create(:customer_vip)
    expect(customer.vip).to be true
  end

  it 'Create a default customer' do
    customer = create(:customer_default)
    expect(customer.vip).to be false
  end

  it 'Create a customer - Sobrescrevendo atributos' do
    customer = create(:customer, name: "Eduardo Essig")
    expect(customer.full_name).to eq('Sr. Eduardo Essig')
  end
  
  it 'Usando o attributes_for' do
    attrs = attributes_for(:customer)
    attrs1 = attributes_for(:customer_vip)
    attrs2 = attributes_for(:customer_default)
  end

  it 'Atributo Transitório' do
    customer = create(:customer_default, upcased: true)
    expect(customer.name.upcase).to eq(customer.name)
  end

  it 'Cliente Masculino' do
    customer = create(:customer, :male)
    expect(customer.gender).to eq('M')
  end

  it 'Cliente Masculino VIP' do
    customer = create(:customer_male_vip)
    expect(customer.gender).to eq('M')
    expect(customer.vip).to be true
  end

  it 'travel_to' do
    travel_to Time.zone.local(2004, 11, 24, 01, 04, 44) do
      @customer = create(:customer_vip)
    end

    puts @customer.created_at
    expect(@customer.created_at).to eq(Time.utc(2004, 11, 24, 01, 04, 44))

  end
  it { expect{ create(:customer) }.to change {Customer.all.size}.by(1)}
end
