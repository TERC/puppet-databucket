require 'digest'
require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:flattened_md5sum,
                                      :type => :rvalue,
                                      :doc => <<-'EOS'
  Flatten data to an array and perform a Digest::MD5Sum on it to create a signature
EOS
) do |args|
  data = args[0]
  raise(ArgumentError, "Must pass data") unless data

  return Digest::MD5.hexdigest(function_flatten_databucket([data]))
end