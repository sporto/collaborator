module Collaborator

		def self.included(base)
			base.extend(ClassMethods)
		end

		module ClassMethods
			def dependency(name, default_dep)
				define_method(name) do
					cached = instance_variable_get("@#{name}")
					return cached if cached
					instance_variable_set("@#{name}", default_dep)
					default_dep
				end
				define_method("#{name}=") do |injected|
					instance_variable_set("@#{name}", injected)
				end
				define_method("reset_#{name}") do
					instance_variable_set("@#{name}", default_dep)
				end
			end
		end

end