# Anything Bucket

AnythingBucket is an CouchDB based iPhone "Anything Bucket" app.

I'm using it as more of a tool to help me flesh out [Trundle][1]

See also: [http://al3x.net/2009/01/31/against-everything-buckets.html][2]

## How to build

Make sure you've got all the submodules first:

	git submodule update --init --recursive

You will need a filed called "BUMP_API_KEY" at the root level of the AnythingBucket directory. This file should contain an API key from http://bu.mp/api - but an empty file will allow the project to compile.

[1]:  http://github.com/schwa/trundle
[2]: http://al3x.net/2009/01/31/against-everything-buckets.html
