module Metable
  extend ActiveSupport::Concern

  def metadata(user=nil)
    self.metadata_to_return(user)
  end
  
end
