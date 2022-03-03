require_relative '../book_cli.rb'
require 'pry'
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BookCli do
    
    describe '.run' do
        it 'should be defined' do
            expect(described_class).respond_to?(:run)
        end
    end

    describe '.greeting' do
        it 'should be defined' do
            expect(described_class).respond_to?(:greeting)
        end

        context 'user types "help"' do

            it 'terminal should be "help"' do
                help_input = "help"
                allow_any_instance_of(Kernel).to receive(:gets).and_return(help_input)
                expect(described_class.help_menu).to eq("help")
            end
        end
    end

    describe '.help_menu' do
        it 'should be defined' do
            expect(described_class).respond_to?(:help_menu)
        end
    end

end
