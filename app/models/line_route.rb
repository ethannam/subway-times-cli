class LineRoute < ActiveRecord::Base
  belongs_to :lines
  belongs_to :routes
end