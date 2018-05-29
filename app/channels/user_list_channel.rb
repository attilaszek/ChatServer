class UserListChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    
    stream_from "user_list_channel"

    @current_user = User.find_by_email(params[:user_email]) if params[:user_email]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed

    if @current_user
      @current_user.update(online: false)
      @current_user.save!

      serialized_data = ActiveModelSerializers::Adapter::Json.new(
        UserSerializer.new(@current_user)
      ).serializable_hash
      ActionCable.server.broadcast "user_list_channel", serialized_data.merge({delete: true})  
    end
  end
end
