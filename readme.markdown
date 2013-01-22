Collaborator
==========

A simple gem for injecting dependencies into classes. I got bored of copying the same code again and again so I made this simple gem. 

Usage
-----

	class BugFinder
		...
	end

	class BugKiller
		# mixing the Collaborator module
		extend Collaborator
		
		# declare a dependency, pass an instance of the collaborator object
		dependency :bug_finder, BugFinder.new
	end

The dependecy method just creates a couple of attribute accesors, so you can use the dependecy like this:

	class BugKiller
		extend Collaborator 
		dependency :bug_finder, BugFinder.new

		def run
			bugs = bug_finder.run
			...
		end

	end

### Injecting dependencies

	In your test you just inject a new dependency like so:

	bug_killer = BugKiller.new
	bug_killer.bug_finder = mocked_bug_finder

### Lazy evaluation

You can also pass a lambda as the second argument, this will defer evaluation of the dependecy until it is actually used

	class BugKiller
		extend Collaborator 
		dependency :bug_finder, ->{ BugFinder.new }

		def run
			bugs = bug_finder.run
			...
		end

	end

### Preparing collaborators

Sometimes it is useful to prepare the collaborators in some way before actually using them. To do this just create a method in your class called 'prepare_collaborator'.

	class BugKiller
		extend Collaborator 
		dependency :bug_finder, ->{ BugFinder.new }

		# this function receives the name of the collaborator e.g. :bug_finder and the collaborator itself
		def prepare_collaborator(name, collaborator)
			collaborator.log_enable = true
		end

	end

When a dependency is injected e.g. bug_killer.bug_finder = mocked_bug_finder this method is also called on the injected dependency

Copyright
----------

Copyright (c) 2013 Sebastian. See LICENSE.txt for
further details.

