class Laboratory < ApplicationRecord
  belongs_to :department, counter_cache: :laboratories_count
end
