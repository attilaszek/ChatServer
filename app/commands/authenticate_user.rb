class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    return user if user && !user.online && user.authenticate(password)

    if user
      if user.online
        errors.add :account, 'Already signed in on another device'
      else
        errors.add :password, 'Invalid password'
      end
    else
      errors.add :email, 'Not registered'
    end
    nil
  end

end