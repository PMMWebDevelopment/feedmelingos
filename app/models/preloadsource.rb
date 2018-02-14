class Preloadsource < ApplicationRecord
    belongs_to :sourcetype
    belongs_to :language
    has_many :subscriptions, :dependent => :destroy
    has_many :users, through: :subscriptions
    
end
