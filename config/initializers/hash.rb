class Hash
  unless Hash.instance_methods(false).include?(:pick)
    def pick(*keys)
      select { |key, _| keys.include? key }
    end
  end

  unless Hash.instance_methods(false).include?(:pick!)
    def pick!(*keys)
      select! { |key, _| keys.include? key }
    end
  end
end
