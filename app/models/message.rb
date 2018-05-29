class Message < ApplicationRecord
  has_one :sender, class_name: "User", primary_key: "sender_id"
  has_one :receiver, class_name: "User", primary_key: "receiver_id"
end
