require "spec_helper"
require_relative "../../../../app/concepts/user/operation/create.rb"
require_relative "../../../../app/models/user.rb"

RSpec.describe User::Create do
  let (:params) { 
    { 
      first_name: "John",
      last_name: "Russel",
      email: "john.russel@example.com",
      password: "123456",
      password_confirmation: "123456"
    }
  }

  context 'no params' do
    it 'fails' do
      result = User::Create.()
      expect( result.success? ).to be_falsy
      expect( User.count).to eq(0)
    end
  end

  context 'valid params' do
    it 'creates new user' do
      result = User::Create.(params)
      expect( result.success? ).to be_truthy
      expect( result["auth_token"] ).not_to be_nil
      expect( result["contract.default"].errors.messages ).to be_empty
      user = User.last
      expect( User.count ).to eq(1)
      expect( user.first_name ).to eq(params[:first_name])
      expect( user.last_name ).to eq(params[:last_name])
      expect( user.email ).to eq(params[:email])
      expect( user.online ).to eq(false)
    end

    it 'creates 2 new users' do
      User::Create.(params)
      User::Create.(params.merge(email: "newemail@example.com"))

      expect( User.all.length ).to eq(2)
      expect( User.all.map {|user| user.email} ).to match_array(["newemail@example.com", params[:email]])
    end
  end

  context 'invalid params' do
    it 'fails with invalid email' do
      result = User::Create.(params.merge(email: "asd@"))
      expect( result.success? ).to be_falsy
      expect( result["auth_token"]).to be_nil
      expect( result["contract.default"].errors.messages.length ).to eq(1)
      expect( result["contract.default"].errors.messages ).to include(email: ["is invalid"])
    end

    it 'fails without first_name' do
      result = User::Create.(params.merge(first_name: nil))
      expect( result.success? ).to be_falsy
      expect( result["auth_token"]).to be_nil
      expect( result["contract.default"].errors.messages.length ).to eq(1)
      expect( result["contract.default"].errors.messages ).to include(first_name: ["can't be blank"])
    end

    it 'fails without last_name' do
      result = User::Create.(params.merge(last_name: ""))
      expect( result.success? ).to be_falsy
      expect( result["auth_token"]).to be_nil
      expect( result["contract.default"].errors.messages.length ).to eq(1)
      expect( result["contract.default"].errors.messages ).to include(last_name: ["can't be blank"])
    end

    it 'fails with short password' do
      result = User::Create.(params.merge(password: "asd12", password_confirmation: "asd12"))
      expect( result.success? ).to be_falsy
      expect( result["auth_token"]).to be_nil
      expect( result["contract.default"].errors.messages.length ).to eq(1)
      expect( result["contract.default"].errors.messages ).to include(password: ["is too short (minimum is 6 characters)"])
    end

    it 'fails because password_confirmation' do
      result = User::Create.(params.merge(password_confirmation: "123457"))
      expect( result.success? ).to be_falsy
      expect( result["auth_token"]).to be_nil
      expect( result["contract.default"].errors.messages.length ).to eq(1)
      expect( result["contract.default"].errors.messages ).to include(password_confirmation: ["doesn't match Password"])
    end

    it 'fails because already taken email' do
      result = User::Create.(params)
      result = User::Create.(params.merge(last_name: "New"))
      expect( result.success? ).to be_falsy
      expect( result["auth_token"]).to be_nil
      expect( result["contract.default"].errors.messages.length ).to eq(1)
      expect( result["contract.default"].errors.messages ).to include(email: ["has already been taken"])
    end

    it 'fails with 2 causes' do
      result = User::Create.(params)
      result = User::Create.(params.merge(last_name: "New", password: "123457"))
      expect( result.success? ).to be_falsy
      expect( result["auth_token"]).to be_nil
      expect( result["contract.default"].errors.messages.length ).to eq(2)
      expect( result["contract.default"].errors.messages ).to include(
        email: ["has already been taken"],
        password_confirmation: ["doesn't match Password"]
      )
    end
  end
end