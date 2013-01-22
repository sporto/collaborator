require 'spec_helper'
require 'collaborator'
require 'ostruct'

describe 'Collaborator' do

	let(:injected_collaborator)	{ double.as_null_object }
	let(:subject) { Subject.new }

	class Collaborator1
		attr_accessor :foo
		def run
			true
		end
	end

	class Subject
		extend Collaborator
		dependency :collaborator1, Collaborator1.new
		dependency :collaborator2, ->{ Collaborator1.new }
	end

	it "mixes in the module" do
		expect(Subject).to respond_to(:dependency)
	end

	it "creates a getter method" do
		expect(subject).to respond_to(:collaborator1)
	end

	it "creates a setter method" do
		expect(subject).to respond_to(:collaborator1=)
	end

	it "creates a reset method" do
		expect(subject).to respond_to(:reset_collaborator1)
	end

	it "reached the collaborator object" do
		expect(subject.collaborator1.run).to be_true
	end

	it "returns the default collaborator1" do
		expect(subject.collaborator1).to be_instance_of(Collaborator1)
	end

	it "can inject the dependency" do
		subject.collaborator1 = injected_collaborator
		expect(subject.collaborator1).to eq(injected_collaborator)
	end

	it "can reset the dependency" do
		subject.collaborator1 = injected_collaborator
		subject.reset_collaborator1
		expect(subject.collaborator1).to be_instance_of(Collaborator1)
	end

	it "accepts a lambda" do
		expect(subject).to respond_to(:collaborator2)
		expect(subject.collaborator2.run).to be_true
	end

	describe "#prepare_collaborator" do

		let(:subject2) { SubjectWithPrepareCollaborator.new }

		class SubjectWithPrepareCollaborator
			extend Collaborator
			dependency :collaborator1, Collaborator1.new

			def prepare_collaborator(name, collaborator)
				collaborator.foo = 9
			end
		end

		it 'gets call when using the dependency' do
			subject2.should_receive(:prepare_collaborator)
			subject2.collaborator1
		end

		it 'passes the name of the collaborator' do
			subject2.stub(:prepare_collaborator) do |name, collaborator|
				expect(name).to eq(:collaborator1)
			end
			subject2.collaborator1
		end

		it 'passes the reference to the collaborator' do
			subject2.stub(:prepare_collaborator) do |name, collaborator|
				expect(collaborator).to be_instance_of(Collaborator1)
			end
			subject2.collaborator1
		end

		it 'gets call when a dependency is injected' do
			subject2.should_receive(:prepare_collaborator)
			subject2.collaborator1 = injected_collaborator
		end

		it "runs the code in the method" do
			expect(subject2.collaborator1.foo).to eq(9)
		end

		it "runs the code in the method for an injected collaborator" do
			injected = OpenStruct.new
			subject2.collaborator1 = injected
			expect(injected.foo).to eq(9)
		end

	end


end