require 'rails_helper'

RSpec.describe Api::V1::TokensController, type: :controller do

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:password_valid) { 'g00d_pa$$' }
    let(:password_invalid) { 'b@d_pa$$' }

    context 'should get JWT token' do
      it 'returns success' do
        post :create, params: { user: { email: user.email, password: password_valid } }
        json_response = JSON.parse(response.body)

        expect(json_response['token']).not_to be_nil
        expect(response).to have_http_status(:success)
      end

    end

    context 'should not get JWT token' do
      it 'returns unauthorized' do
        post :create, params: { user: { email: user.email, password: password_invalid } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end