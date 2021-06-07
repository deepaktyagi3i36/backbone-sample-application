require 'rails_helper'

RSpec.describe Person, type: :model do
  subject {
    described_class.new(first_name: "fname",
                        last_name: "lname",
                        email: "test@example.com",
                        phone: "+919988776655")
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a first_name" do
    subject.first_name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a last_name" do
    subject.last_name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a valid email" do
    subject.email = "invalid_email"
    expect(subject).to_not be_valid
  end

  it "is not valid without a phone" do
    subject.phone = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a valid phone" do
    subject.phone = "9988776655"
    expect(subject).to_not be_valid
  end
end
