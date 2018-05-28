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
          @user = User.new({
            first_name: params[:first_name],
            last_name: params[:last_name],
            email: params[:email],
            password: params[:password],
            birth_date: params[:birth_date],
            sex: params[:sex],
            introduction: params[:introduction],
            online: false
          })

          unless @user.valid?
            error!(@user.errors.messages, 404)
          end

          unless params[:password] == params[:password_confirmation]
            error!({"password_confirmation": ["invalid password confirmation"]}, 404)
          end

          @user.save
          { auth_token: AuthenticateUser.call(@user.email, @user.password).result }
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
            user.update(online: true)
            user.save
            p user
            p user.errors

            {auth_token: command.result}
          else
            error!(command.errors, 404)
          end
        end

        desc "Get current user", headers: Base.headers_definition
        get "getuser" do
          authenticate_request
          {
            email: current_user.email,
            first_name: current_user.first_name,
            last_name: current_user.last_name
          }
        end

        desc "Get user list", headers: Base.headers_definition
        get "user_list" do
          authenticate_request
          User.where(online: true)
        end

      end
    end
  end
end