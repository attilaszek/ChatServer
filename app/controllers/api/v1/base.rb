module API  
  module V1
    class Base < Grape::API

      def self.headers_definition
        {
          "Authorization" => {
            description: "Valdates your identity",
            required: true 
          }  
        }
      end

      helpers do
        attr_reader :current_user

        private

        def authenticate_request
          @current_user = AuthorizeApiRequest.call(request.headers).result
          error!('401 Unauthorized', 401) unless @current_user
        end
      end

      mount API::V1::Users

      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: "/api/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end  