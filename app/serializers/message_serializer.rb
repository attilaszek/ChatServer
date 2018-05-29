class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :sender_id, :receiver_id
end