class ConversationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"

    p "////////////////////////"
    p params[:sender_id]
    p params[:receiver_id]

    stream_from "conversation_channel_#" + params[:sender_id].to_s
    stream_from "conversation_channel_#" + params[:receiver_id].to_s
   end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
