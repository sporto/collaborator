Collaborator
==========

A simple gem for injecting dependencies into classes. I got bored of copying the same code again and again so I made this simple gem. 

Usage
-----

	class Foo
	end

	class Bar
		# mixing the Collaborator module
		include Collaborator 
		
		# declare a dependency, pass an instance of the collaborator object
		dependency :foo, Foo.new
	end

The dependecy method just creates a couple of attribute accesors, so you can use the dependecy like this"

	class Bar
		include Collaborator 
		dependency :foo, Foo.new

		def something
			foo.run
		end

	end

In your test you just inject a new dependency like so:

	bar = Bar.new
	bar.foo = my_mock_dependecy

Copyright
----------

Copyright (c) 2013 Sebastian. See LICENSE.txt for
further details.

