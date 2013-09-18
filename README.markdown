# TERC Puppet Databucket Library #

Adds the databucket type and associated functions.

## Types ##

### databucket ###

A databucket is a resource primitive that functions as a lightweight exportable data container.  It can be used to import and export 
arbitrary data in a controllable manner between classes or nodes.

The get_bucketed function(see below) can be used to collect all buckets that are real or have been realized of a given type, collecting
their data into an array.


## Functions ##

### create_databucket ###
Creates a bucket of the specified type.

### databucket_md5sum ###
The databucket_md5sum function uses the standard ruby Digest library to perform a Digest::MD5.hexdigest on a string.

*Examples:*
    databucket_md5sum("a=>bbc=>dec=>d=>e")

Should return the value "3096339ef6bdad8974cd042511404353"

- *Type*: rvalue

### flatten_databucket ###
The flatten_databucket function flattens and orders arbitrary data and returns a string.

*Examples:*
    flatten_databucket({ 'c' => { 'd' => 'e' }, 'bc' => 'de', 'a' => 'b' })
    flatten_databucket({ 'a' => 'b', 'c' => {'d' => 'e' }, 'bc' => 'de' })

Should both return the string "a=>bbc=>dec=>d=>e"

- *Type*: rvalue

### get_bucketed ###
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

- *Type*: rvalue
