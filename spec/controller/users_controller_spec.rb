require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { name: 'John', email: 'teste@gmail.com', password: '1233' } }
  let(:invalid_attributes) { { name: 'John', email: 'testegmail.com', password: '1233' } }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change { User.count }.by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_attributes } 
        end.to change { User.count }.by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      user
    end

    it 'destroys the user' do
      expect do
        request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
        delete :destroy, params: { id: user }
      end.to change { User.count }.by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'should forbid destroy user' do
      delete :destroy, params: { id: user }
      expect(response).to have_http_status(:forbidden)
    end
    
  end

  describe 'PATCH #update' do
    let(:new_attributes) { { email: Faker::Internet.email } }
    let(:new_invalid_attributes) { { email: 'testegmail.com' } }

    context 'with valid attributes' do
      before do
        request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
        patch :update, params: { id: user, user: new_attributes }
      end

      it 'updates the user' do
        user.reload
        expect(user.email).to eq(new_attributes.fetch(:email))
      end

      it 'returns success' do
        user.reload
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid attributes' do
      before do
        request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
        patch :update, params: { id: user, user: new_invalid_attributes }
      end

      it 'does not update the user' do
        user.reload
        expect(user.email).not_to eq(new_invalid_attributes.fetch(:email))
      end

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }

    it 'returns the user in JSON format' do
      get :show, params: { id: user }

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(user.email).to eq(json_response.dig(:email))
    end
  end
end
