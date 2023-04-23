# users_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:params_attributes) { { name: 'John', email: 'teste@gmail.com', password: '1233'} }
    let(:attributes_invalids) { { name: 'John', email: 'testegmail.com', password: '1233'} }
    context 'with valid attributes' do
      it 'create a new user' do
        expect {
          post :create, params: { user: params_attributes }
        }.to change(User, :count).by(1)
      end

      it 'response created 200' do
        post :create, params: { user: params_attributes }
        expect(response).to have_http_status(:created)
      end
    end
    
    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect { 
          post :create, params: { user: attributes_invalids }
      }.to change(User, :count).by(0)
      end

      it 're-renders the new template' do
        post :create, params: { user: attributes_invalids }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
