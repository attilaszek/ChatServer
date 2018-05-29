module API
  module V1
    class Messages < Grape::API
      include API::V1::Defaults

      namespace :messages do

        desc "Get messages by page"
        params do
          requires :sender_id, type: Integer
          requires :receiver_id, type: Integer
          requires :page_nr, type: Integer
          requires :nr, type: Integer
        end
        get "show" do
          result1 = Message.where({sender_id: params[:sender_id], receiver_id: params[:receiver_id]})
          result2 = Message.where({sender_id: params[:receiver_id], receiver_id: params[:sender_id]})
          
          start_index = params[:nr] * (params[:page_nr] - 1)
          end_index = start_index + params[:nr] - 1
          
          (result1 + result2).sort_by {|msg| msg.created_at}.reverse[start_index..end_index]
        end

        desc "Create new message"
        params do
          requires :text, type: String
          requires :sender_id, type: Integer
          requires :receiver_id, type: Integer
        end
        post "create" do
          Message.create(params)
        end

      end
    end
  end
end