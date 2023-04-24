# users_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { name: 'John', email: 'teste@gmail.com', password: '1233' } }
  let(:invalid_attributes) { { name: 'John', email: 'testegmail.com', password: '1233' } }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'create a new user' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'response created 200' do
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_attributes }
        end.to change(User, :count).by(0)
      end

      it 'return a error unprocessable_entity' do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      user
    end

    context 'should destroy user' do
      it 'delete the user' do
        expect do
          delete :destroy, params: { id: user }
        end.to change(User, :count).by(-1)
      end

      it 'return respond no content' do
        delete :destroy, params: { id: user }
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'update #PATH' do
    let(:new_attributes) do
      { email: Faker::Internet.email }
    end

    let(:new_invalid_attributes) do
      { email: 'testegmail.com' }
    end

    context 'should update user' do
      it 'updates the user' do
        patch :update, params: { id: user, user: new_attributes }
        user.reload
        expect(user.email).to eq(new_attributes.fetch(:email))
      end
    
      it 'return success on update user' do
        patch :update, params: { id: user, user: new_attributes }
        expect(response).to have_http_status(:success)
      end
    end
    
    context 'should not update user' do
      before do
        patch :update, params: { id: user, user: new_invalid_attributes }
      end
      
      it 'dont updates the user' do
        user.reload
        expect(user.email).not_to eq(new_invalid_attributes.fetch(:email))
      end
    
      it 'return unprocessable_entity on update user' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'show #GET' do
    let(:user) { create(:user) }

    context 'should show user' do
      it 'return user json' do
        get :show, params: { id: user }

        json_response = JSON.parse(self.response.body, symbolize_names: true)
        expect(user.email).to eq(json_response.dig(:email))
      end
    end
  end
end

