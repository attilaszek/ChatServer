require "reform"

module User::Contract
  class Create < Reform::Form
    property :first_name
    property :last_name
    property :email
    property :password
    property :password_confirmation

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
    validates_uniqueness_of :email
    validates :password, length: {in: 6..20}, confirmation: true
    validates :password_confirmation, presence: true
  end
end