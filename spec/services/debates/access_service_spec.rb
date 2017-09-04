require 'rails_helper'

describe Debates::AccessService do
  let(:auth_token) { create(:auth_token) }
  let(:debate) { instance_double(Debate, create_auth_token!: auth_token) }
  let(:service) { described_class.new(debate: debate) }

  describe '#login' do
    subject { service.login }

    it 'should create user with auth_token' do
      expect(subject.auth_token).to eq(auth_token)
    end
  end
end
