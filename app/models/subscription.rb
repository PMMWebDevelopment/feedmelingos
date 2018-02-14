class Subscription < ApplicationRecord
    belongs_to :user
    belongs_to :preloadsource
    belongs_to :language
    accepts_nested_attributes_for :preloadsource
end
