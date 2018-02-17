class User < ApplicationRecord
    include ActiveModel::ForbiddenAttributesProtection
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
    has_many :subscriptions
    has_many :preloadsources, through: :subscriptions
end
