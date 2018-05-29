class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :file_b64, :file_name, :created_at, :sender_id, :receiver_id
end