require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:create_databucket,
                                      :arrity => 3,
                                      :doc => <<-'EOS'
This function is similar to the create_resources function now included in puppet except:
- the resource is known to be a databucket
- the first argument(type) is actually setting a parameter used for filtering on the resource
- the name is automatically assigned and follows the format #{type}::#{md5sum(data)}
- the third argument sets metaparameters(tags, expiration, virtual, export)

*Examples:*
    create_databuckets('bucket', { 'data' => { 'foo' => 'bar' } })

Is functionally equivalent to:
    databucket { 'bucket::fb44f36ae92ff8464cb0efa8ee4bab74': type => 'bucket', data => { 'foo' => 'bar' } }
EOS
) do |args|
  type, data, metadata = args

  raise(ArgumentError, "Must pass a type") unless type
  raise(ArgumentError, "Must pass data") unless data
  raise(ArgumentError, "Data must be a hash, array, or string") if (data.class != String and data.class != Array and data.class != Hash)

  raise(ArgumentError, "Metadata must be a hash") if metadata and !metadata.is_a? Hash
   
  type     = type.downcase
  exported = false
  virtual  = false
  
  if metadata
    metadata.each_pair do |key, value|
      case key.to_s.downcase.singularize.chomp.to_sym # that's a mouthful!
      when :virtual
        eval = value.downcase.singularize.chomp
        if eval =~ (/(true)$/i)
          virtual = true
        elsif eval =~ (/(false)$/i)
          virtual = false
        else
          raise(ArgumentError, "Virtual must be set to true or false")
        end 
      when :export
        eval = value.downcase.singularize.chomp
        if eval =~ (/(true|enabled)$/i)
          exported = true
        elsif eval =~ (/(false|disabled)$/i)
          exported = false
        else
          raise(ArgumentError, "Export must be set to true, false, enabled or disabled")
        end 
      when :exported
        eval = value.downcase.singularize.chomp
        if eval =~ (/(true|enabled)$/i)
          exported = true
        elsif eval =~ (/(false|disabled)$/i)
          exported = false
        else
          raise(ArgumentError, "Export(ed) must be set to true, false, enabled or disabled")
        end 
      when :tag
        tags = value
      end
    end
  end
  
  raise(ArgumentError, "Can only set exported or virtual, not both") if virtual and exported
  
  name_prefix = ""
  if virtual
    name_prefix = "@"
  elsif exported
    name_prefix = "@@"
  end
  
  name = "#{name_prefix}#{type}::#{function_databucket_md5sum([function_flatten_databucket([data])])}"
 
  # Now construct the object
  object = { name => { "type" => type, "data" => data } }
  object[name].merge({ "tags" => tags }) if tags
  
  # And call out to the create_resources function
  function_create_resources(['databucket', object]) 
end