require 'spec_helper'
require 'collaborator'

describe 'Collaborator' do

	let(:injected_collaborator)	{ double.as_null_object }
	let(:subject) { Subject.new }

	class Service
	end

	class Subject
		include Collaborator
		dependency :collaborator, Service.new
	end

	it "mixes in the module" do
		expect(Subject).to respond_to(:dependency)
	end

	it "creates a getter method" do
		expect(subject).to respond_to(:collaborator)
	end

	it "creates a setter method" do
		expect(subject).to respond_to(:collaborator=)
	end

	it "creates a reset method" do
		expect(subject).to respond_to(:reset_collaborator)
	end

	it "returns the default collaborator" do
		expect(subject.collaborator).to be_instance_of(Service)
	end

	it "can inject the dependency" do
		subject.collaborator = injected_collaborator
		expect(subject.collaborator).to eq(injected_collaborator)
	end

	it "can reset the dependency" do
		subject.collaborator = injected_collaborator
		subject.reset_collaborator
		expect(subject.collaborator).to be_instance_of(Service)
	end

end