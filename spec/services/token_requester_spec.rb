require 'rails_helper'

describe TokenRequester do
  before do
    @auth_token = create(:auth_token)
  end

  describe '#request' do
    it 'returns nil if token is not in the headers' do
      expect(get_token({ 'Abc' => 'Cde' })).to be_nil
    end

    it 'returns nil if auth token was not found' do
      expect(get_token({ 'Authorization' => 'test' })).to be_nil
    end

    it 'finds an auth token if exists' do
      expect(get_token({ 'Authorization' => @auth_token.value })).to eq(@auth_token)
    end
  end

  def get_token(headers)
    described_class.new(headers).auth_token
  end
end
