require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:flatten_databucket,
                                      :type => :rvalue,
                                      :doc => <<-'EOS'
  One of the downsides to ruby 1.8.7 is no good way to sort and thus trivially compare hashes.
  
  This function will recursively flatten and sort data.
EOS
) do |args|
  data = args[0]

  if data.is_a? Hash
    array = Array.new
    data.each_pair do |key, value|
      array << "#{function_flatten_databucket([key])}=>#{function_flatten_databucket([value])}"
    end
    data = array
  end

  if data.is_a? Array
    string = String.new
    data.map{ |a| function_flatten_databucket([a])}.sort.each do |val|
      string << val
    end
    data = string
  end

  unless data.is_a? String
    data = data.to_s << data.class.to_s
  end

  return data
end