require 'rails_helper'

RSpec.describe Authenticable, type: :controller do
  describe 'autheticable user' do
    let(:user) { create(:user) }
    let(:authentication) { MockController.new }

    context 'should get user from Authorization token' do
      before do
        authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
      end

      it 'sets the current user' do
        expect(authentication.current_user.id).to eq(user.id)
      end
    end

    context 'should not get user from Authorization token' do
      before do
        authentication.request.headers['Authorization'] = nil
      end

      it 'does not set the current user' do
        expect(authentication.current_user).to be_nil
      end
    end
  end
end

class MockController
  include Authenticable

  attr_accessor :request

  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end