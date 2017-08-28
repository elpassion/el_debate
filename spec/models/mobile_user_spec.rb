require 'rails_helper'

describe MobileUser do
  subject { mobile_user }
  let(:mobile_user) { create(:mobile_user, user_attributes) }
  let(:user_attributes) { {} }

  describe '#full_name' do
    subject { mobile_user.full_name }
    let(:user_attributes) { { first_name: first_name, last_name: last_name } }
    let(:first_name) { FFaker::Name.first_name }
    let(:last_name) { FFaker::Name.last_name }

    it 'joins first name with last name' do
      is_expected.to eq("#{first_name} #{last_name}")
    end

    context 'when firstname or lastname is lowercase' do
      let(:first_name) { 'firstName' }
      let(:last_name) { 'lastName' }

      it 'upcases firstname' do
        is_expected.to include('FirstName')
      end

      it 'upcases lastname' do
        is_expected.to include('LastName')
      end
    end
  end

  describe '#initials' do
    subject { mobile_user.initials }
    let(:user_attributes) { { first_name: first_name, last_name: last_name } }
    let(:first_name) { FFaker::Name.first_name }
    let(:last_name) { FFaker::Name.last_name }

    it 'consist of first letters of first_name and last_name' do
      is_expected.to eq(first_name[0] + last_name[0])
    end
  end
end
