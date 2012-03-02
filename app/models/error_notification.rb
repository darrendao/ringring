class ErrorNotification < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true
end
