class Language < ApplicationRecord
    include ActiveModel::ForbiddenAttributesProtection
    has_many :preloadsources
end
