require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:get_bucketed,
                                      :type => :rvalue,
                                      :doc => <<-'EOS'
This function queries the compiler for all resources of type databucket.  It then retrieves those resource's parameters(this should 
set off alarm bells about caution) and filters them matches by the passed 'bucket' parameter - ultimately returning an array composed 
of the data payload that exists within the specified databuckets.

*Examples:*
    class setup_buckets {
      databucket{ 'foo': type => 'bucket', data => "value" }
      databucket{ 'bar': type => 'bucket', data => "another value" }
    }
    class collect_buckets {
      require setup_buckets 
      $buckets = get_bucketed('bucket')
    }
    
In this example the buckets variable can be expected to contain [ 'value', 'another value' ]
EOS
) do |args|
  type = args[0]
  data = Array.new
  
  type = type.downcase.to_sym if type
  raise(ArgumentError, "Must specify the type of bucket") unless type
  
  bucket_type = Puppet::Resource.new('databucket', 'whatever').type
  
  # Parse all the collections in the compiler - could be much more efficient here, 
  # but eh, this is clearer I think
  collection_results = Array.new
  self.compiler.collections.each do |collection|
    if collection.resources.nil? or collection.resources.empty? # This should almost always be true
      # Clone/dup the collection and evaluate it
      coll = collection.clone.evaluate
      next unless coll # No response, move on!
      
      # Simple select by type
      resources = coll.select{|a| a.type == bucket_type }
    else # But hey, maybe it won't be
      # Simple select by type
      resources = collection.resources.find_all{|a| a.type == bucket_type}
    end
    
    # Push to the collection collector
    collection_results = collection_results + resources.map{ |a| a.to_s } unless resources.empty?
  end
  
  # Now map everything in the compiler.  Note that this will catch exported resources, so we need to
  compiler_results = self.compiler.resources.find_all { |a| a.type == bucket_type }
  compiler_results = results.select{ |a| a.to_s unless (a.exported or a.virtual) } if results and !results.empty?
  
  # Add the compiler and collection results together to get all of our 'real' resources
  buckets = (compiler_results + collection_results).uniq

  # Now parse for the specific resources and populate the data return.
  # we could've done this above but 1.8.7 makes hash comparisons to ensure uniqueness 
  # hard to write in a clear way.
  buckets.each do |bucket|
    res = findresource(bucket)
    data.push(res.to_hash[:data]) if (res.to_hash[:type] and 
                                      res.to_hash[:type].downcase.to_sym == type)
  end
  
  return data 
end