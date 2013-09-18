# TERC Puppet Databucket Library #

Adds the databucket type and associated functions.

## Types ##

### databucket ###

A databucket is a resource primitive that functions as a lightweight exportable data container.  It can be used to import and export 
arbitrary data in a controllable manner between classes or nodes.

The get_bucketed function(see below) can be used to collect all buckets that are real or have been realized of a given type, collecting
their data into an array.


## Functions ##

### bucketed ###
This function queries the compiler through the collected_resources and compiled_resources functions for all resources of type 
bucket.  It then filters these matches by the passed 'bucket' parameter and returns an array composed of the data that exists 
within the specified buckets.

*Examples:*

    get_bucketed('bucket')

Given a bucket of type bucket, which contains strings as its data payload, would return ["value", "another val"]

- *Type*: rvalue
