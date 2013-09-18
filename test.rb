require "digest"

def flatten_data(data)
  if data.is_a? Hash
    array = Array.new
    data.each_pair do |key, value|
      array << "#{flatten_data(key)}=>#{flatten_data(value)}"
    end
    data = array
  end
  if data.is_a? Array
    string = String.new
    data.map{ |a| flatten_data(a)}.sort.each do |val|
      string << val
    end
    data = string
  end
  unless data.is_a? String
    data = data.to_s << data.class.to_s
  end
  return data
end

puts flatten_data({"test" => "test", "nested" => { "a" => { "b" => "c", "d" => "e" } }, "foo" => "bar"})
puts flatten_data({"foo" => "bar", "test" => "test", "nested" => {"a" => { "d" => "e", "b" => "c" } }})
puts (flatten_data({"test" => "test", "nested" => { "a" => "b" }, "foo" => "bar"}) == flatten_data({"foo" => "bar", "test" => "test", "nested" => {"a" => "b" }}))
puts Digest::MD5.hexdigest(flatten_data({"foo" => "bar", "test" => "test", "nested" => {"a" => { "d" => "e", "b" => "c" } }}))
