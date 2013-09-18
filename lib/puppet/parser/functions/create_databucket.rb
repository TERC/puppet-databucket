require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:create_databucket,
                                      :doc => <<-'EOS'
  Creates a new databucket.  Could not figure out how to do what I wanted via a type or provider so enjoy this.
EOS
) do |args|
  data, options = args

  raise(ArgumentError, "Must pass data") unless data
  raise(ArgumentError, "Data must be a hash") unless data.is_a? Hash
  
  name    = false
  type    = false
  md5sum  = false
  export  = false
  virtual = false
  
  # Only one key means we had to have been passed as :namevar => :params, or we didn't specify a type
  # and tried to bucket one piece of data.
  if data.keys.count == 1
    name = data.keys.first
    data = data[name]
  end

  # Ensure we still have a hash
  raise(ArgumentError, "Only one key means we parsed toplevel key as name.  Data must be a hash.") unless data.is_a? Hash

  # Parse out options to figure out what to do
  data.keys.each do |key|
    case key.downcase.singularize.to_sym
    when :md5sum
      md5sum = true
      data.delete(key)
    when :name
      name = data[key].downcase
      data.delete(key)
    when :type
      type = data[key].downcase
      data.delete(key)
    when :virtual
      
    when :export
      
    end
  end
  
end