# frozen_string_literal: true

# CounterCacheResettable
#
# MIT | 2019.05.14 | fred kim | yhkks1038@gmail.com
#
# Just put this module in your awesome model class using include keyword.
#
#   class Post < ApplicationRecord
#     include CounterCacheResettable
#
#     ...
#   end
#
# Enjoy!
#
# # ClassMethods
#
# => resettable_counter_for *counters
# : generate instance methods for counters
#
# for example.
#
# If some model class has this declaration:
#
#   resettable_counter_for :barcodes
#
# It makes method below to use:
#
#   def reset_barcodes_counter
#     send(:reset_counters, :barcodes)
#   end
#
# # InstanceMethods
#
# => reset_counters *counters
# : Make it easy to use reset counter method in ActiveRecord Class methods.
# : It is jsut alias for use reset method in instance.
#
# for example.
#
# In original.
#   Post.reset_counters(:id, :comments)
#
# Now we have.
#   Post.find(:id).reset_counters(:comments)
#
module CounterCacheResettable
  extend ActiveSupport::Concern

  def include(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def resettable_counter_for(*counters)
      counters.each do |counter|
        next unless counter.present?

        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def reset_#{counter}_counter
            send(:reset_counters, :#{counter})
          end
        CODE
      end
    end
  end

  def reset_counters(*counters)
    self.class.reset_counters(id, *counters)
  end
end
