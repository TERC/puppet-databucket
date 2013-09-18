require 'digest'
require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:databucket_md5sum,
                                      :type => :rvalue,
                                      :doc => <<-'EOS'
The databucket_md5sum function uses the standard ruby Digest library to perform a Digest::MD5.hexdigest on a string.

*Examples:*
    databucket_md5sum("a=>bbc=>dec=>d=>e")

Should return the value "3096339ef6bdad8974cd042511404353"
EOS
) do |args|
  data = args[0]
  raise(ArgumentError, "Must pass data") unless data
  raise(ArgumentError, "Data must be a string") unless data.is_a? String

  return Digest::MD5.hexdigest(function_flatten_databucket([data]))
end