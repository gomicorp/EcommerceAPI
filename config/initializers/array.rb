class Array

  # Make same key same value hash
  # %w[a b c].to_echo
  # => {"a"=>"a", "b"=>"b", "c"=>"c"}
  def to_echo
    k, v = dup, dup
    k.zip(v).to_h
  end
end
