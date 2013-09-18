require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:create_databucket,
                                      :arrity => 3,
                                      :doc => <<-'EOS'
  Creates a new databucket.  We can't have a metatype in puppet that controls name values on the basis of a parameter,
  so we generate an identifier that includes an md5sum of the data.
EOS
) do |args|
  type, data = args

  raise(ArgumentError, "Must pass a type") unless type
  raise(ArgumentError, "Must pass data") unless data
  raise(ArgumentError, "Data must be a hash") unless data.is_a? Hash
  
  type    = type.downcase
  export  = false
  virtual = false
  
  # Ensure we still have a hash
  raise(ArgumentError, "Only one key means we parsed toplevel key as name.  Data must be a hash.") unless data.is_a? Hash

  # Parse out options to figure out what to do
  data.keys.each do |key|
    case key.downcase.singularize.to_sym

    when :virtual
      data.delete(key)
    when :export
      data.delete(key)
    end
  end
  
  #function_create_resource('databucket', { name => data })
  
end