# this is models file
module WorkUtils

  module Models

    class File < ActiveRecord::Base
      validates :name, :presence => true
      validates :number_of_lines, :presence => true
    end

  end

end
