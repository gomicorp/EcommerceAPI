# Adds draw method into Rails routing
# It allows us to keep routing splitted into files
module ActionDispatch
  module Routing
    class Mapper
      def draw(routes_name)
        instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
      end
    end
  end
end

# To more information, visit here (The way of DHH & GitLab)
# =>  https://mattboldt.com/separate-rails-route-files
