# TERC Puppet Standard Library #

Some additional functions and types not included in puppet or the puppetlabs standard library.

## Types ##

### bucket ###

A bucket is a resource primitive that functions as a lightweight exportable data container.  It can be used to import and export 
arbitrary data in a controllable manner between classes or nodes.

The bucketed function(see below) can be used to collect all buckets that are real or have been realized of a given type, collecting
their data into an array.


## Functions ##

### bucketed ###
This function queries the compiler through the collected_resources and compiled_resources functions for all resources of type 
bucket.  It then filters these matches by the passed 'bucket' parameter and returns an array composed of the data that exists 
within the specified buckets.

*Examples:*

    bucketed('bucket')

Given a bucket of type bucket, which contains strings as its data payload, would return ["value", "another val"]

- *Type*: rvalue

### collected_resources ###
This function parses all collections existing within the compiler, evaluates them, and then parses them to see if they
match a given resource type.  It then returns an array composed of reference strings to the found resources.


*Examples:*

    collected_resources('exported')
  
Would return all realized exported or virtual resources of type 'exported'

- *Type*: rvalue

### compiled_resources ###
This function parses the compiler for resources matching a given type and returns an array composed of reference strings 
to those resources.

An optional second parameter can be used to filter by the criteria: real(not virtual or exported), virtual, or exported

*Examples:*

    compiled_resources('class')
    compiled_resources('class', 'real')

Should return all classes the compiler is aware of in the first case and all "real" classes in the second.  

- *Type*: rvalue

### curtime ###
This function will return the local system time via Ruby's Time.now function, or query the specified NTP server for the time
since unix epoch.

*Examples:*

    curtime()
    curtime("pool.ntp.org")

Should both return identical values.

- *Type*: rvalue


