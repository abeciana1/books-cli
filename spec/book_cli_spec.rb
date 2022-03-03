require_relative '../book_cli.rb'

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
    end

end
