require "trailblazer"

class User::Create < Trailblazer::Operation
  step Model( User, :new )
  step Contract::Build( constant: User::Contract::Create )
  step Contract::Validate( )
  step :set_status!
  step Contract::Persist( )
  step :get_auth_token

  def set_status!(options, model:, **)
    model.online = false
    true
  end

  def get_auth_token(options, model:, **)
    options["auth_token"] = AuthenticateUser.call(model.email, model.password).result
  end

end
