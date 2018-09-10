require 'rails_helper'

describe ARStream do

  it 'raises ArgumentError' do
    expect { described_class.build(:bad_direction, Comment) }.to raise_error(ArgumentError)
  end
end
