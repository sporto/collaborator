module Collaborator

	# a dependecy might be a class, an instance or a lambda
	# evaluate the lambda if necessary
	def evaluate_dependency(dependency)
		if dependency.is_a?(Proc)
			return dependency.call
		else
			dependency
		end
	end

	def dependency(name, default_dep)

		define_method(name) do
			cached = instance_variable_get("@#{name}")
			return cached if cached
			self.send "reset_#{name}"
		end

		define_method("#{name}=") do |injected|
			self.prepare_collaborator(name, injected) if self.respond_to?(:prepare_collaborator)
			instance_variable_set("@#{name}", injected)
		end

		define_method("reset_#{name}") do
			evaluated = self.class.evaluate_dependency(default_dep)
			self.prepare_collaborator(name, evaluated) if self.respond_to?(:prepare_collaborator)
			instance_variable_set("@#{name}", evaluated)
			evaluated
		end
		
	end


end