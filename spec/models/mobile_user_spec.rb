require 'rails_helper'

describe User do
  subject { user }
  let(:user) { create(:user, user_attributes) }
  let(:user_attributes) { {} }

  describe '#full_name' do
    subject { user.full_name }
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
    subject { user.initials }
    let(:user_attributes) { { first_name: first_name, last_name: last_name } }
    let(:first_name) { FFaker::Name.first_name }
    let(:last_name) { FFaker::Name.last_name }

    it 'consist of first letters of first_name and last_name' do
      is_expected.to eq(first_name[0] + last_name[0])
    end

    context 'when first_name consist of two parts' do
      let(:first_part) { FFaker::Name.first_name }
      let(:second_part) { FFaker::Name.first_name }
      let(:first_name) { [first_part, second_part].join(' ') }

      it 'consist of first letter of first_name first part and first letter of last_name' do
        is_expected.to eq(first_part[0] + last_name[0])
      end
    end

    context 'when last_name consist of two parts' do
      let(:first_part) { FFaker::Name.first_name }
      let(:second_part) { FFaker::Name.first_name }
      let(:last_name) { [first_part, second_part].join(' ') }

      it 'consist of first letter of first_name and first letter of last_name first part' do
        is_expected.to eq(first_name[0] + first_part[0])
      end
    end

    context 'when first_name or last_name is lowercase' do
      let(:first_name) { 'firstName' }
      let(:last_name) { 'lastName' }

      it 'upcases initials' do
        is_expected.to eq('FL')
      end
    end

    context 'when last_name is missing' do
      let(:last_name) { nil }

      it 'consist of only first_name initial letter' do
        is_expected.to eq(first_name[0])
      end
    end

    context 'when first_name is missing' do
      let(:first_name) { nil }

      it 'consist of only last_name initial letter' do
        is_expected.to eq(last_name[0])
      end
    end
  end
end
