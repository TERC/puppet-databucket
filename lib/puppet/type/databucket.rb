# A bucket is incredibly simple it just sucks in arbitrary data.
Puppet::Type.newtype(:databucket) do
  @doc = "An bucket of arbitrary data"
  
  newparam(:name) do
    desc "Name of the bucket, must be unique"
    isnamevar
  end
  
  newparam(:type) do
    desc "A metaparam, sets the type of data"
    
    isrequired
    validate do |val|
      raise(ArgumentError, "Type must be a string") unless val.is_a? String
      raise(ArgumentError, "Empty values for type are not permitted") if val.length < 1
    end
  end
  
  newparam(:data) do
    desc "Actual data, accepts anything"
    isrequired
    validate do |val|
      raise(ArgumentError, "Empty values for data are not permitted") if (val.is_a? String) and val.length < 1
      raise(ArgumentError, "Empty values for data are not permitted") if (val.is_a? Hash or val.is_a? Array) and val.empty?
    end
  end
  
end
