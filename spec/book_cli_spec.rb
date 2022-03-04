require_relative '../book_cli.rb'
require 'pry'
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BookCli do

    subject {described_class.new}
    
    describe '#run' do
        it 'should be defined' do
            expect(subject).respond_to?(:run)
        end
    end

    describe '#greeting' do
        it 'should be defined' do
            expect(subject).respond_to?(:greeting)
        end

    end

    describe '#help_menu' do
        it 'should be defined' do
            expect(subject).respond_to?(:help_menu)
        end
    end

    describe '#fetch_reading_lists' do
        it 'should be defined' do
            expect(subject).respond_to?(:fetch_reading_lists)
        end

        context 'user types "view"' do
            it 'terminal should be "view"' do
                allow($stdin).to receive(:gets).and_return('view')
                expect($stdin.gets).to eq('view')
                subject.fetch_reading_lists
            end

            it 'reading_lists directory should be present' do
                expect(Dir.exists?("reading_lists")). to be_truthy
            end
        end
    end

    describe '#view_all_reading_lists' do
        it 'should be defined' do
            expect(subject).respond_to?(:view_all_reading_lists)
        end

        it 'should tell a user that their list is empty if reading_list has no files' do
            binding.pry
            output = capture_standard_output { subject.view_all_reading_lists } 
            if Dir.entries("reading_lists").length < 3
                expect{output}.to eq("You currently have no reading lists. Type 'create' to create one.\n")
            end
        end

    end

    describe '#create_a_reading_list' do
        it 'should be defined' do
            expect(subject).respond_to?(:create_a_reading_list)
        end

        it 'should create a new json file' do
            # binding.pry
            STDIN.should_receive(:gets) { "Test File" }
            expect(File.exist?("./reading_lists/test_file.json")).to be_truthy
        end
    end

end
