module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      namespace :users do

        desc "Sign up"
        params do
          requires :first_name, type: String
          requires :last_name, type: String
          requires :email, type: String
          requires :password, type: String
          requires :password_confirmation, type: String
          optional :birth_date, type: Date
          optional :sex, type: String
          optional :introduction, type: String
        end
        post "signup" do
          result = User::Create.(params)

          error_messages = result["contract.default"].errors.messages
          error!(error_messages, 404) if error_messages.length > 0

          { auth_token: result["auth_token"] }
        end

        desc "Log in"
        params do
          requires :email, type: String
          requires :password, type: String
        end
        post "login" do
          command = AuthenticateUser.call(params[:email], params[:password])

          if command.success?
            user = User.find_by_email(params[:email])

            {auth_token: command.result}
          else
            error!(command.errors, 404)
          end
        end

        desc "Get current user", headers: Base.headers_definition
        get "getuser" do
          authenticate_request

          current_user.update(online: true)
          current_user.save

          serialized_data = ActiveModelSerializers::Adapter::Json.new(
              UserSerializer.new(current_user)
            ).serializable_hash
          ActionCable.server.broadcast "user_list_channel", serialized_data.merge({delete: false})

          {
            email: current_user.email,
            first_name: current_user.first_name,
            last_name: current_user.last_name
          }
          current_user
        end

        desc "Get user list", headers: Base.headers_definition
        get "user_list" do
          authenticate_request
          online_users = User.where("online = ? AND email != ?", true, current_user.email)

          online_users
        end

      end
    end
  end
end