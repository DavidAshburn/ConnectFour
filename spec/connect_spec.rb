require 'spec_helper'
require_relative '../app/connect'

describe ConnectFour do

	describe '#player_input' do
	    # Located inside #take_turn (Looping Script Method)
	    # Looping Script Method -> Test the behavior of the method (for example, it
	    # stops when certain conditions are met).

	    # Note: #player_input will stop looping when the valid_input is between?(min, max)

	    subject(:game_input) { described_class.new }

	    context 'when user number is between arguments' do
	      before do
	        valid_input = '7'
	        allow(game_input).to receive(:gets).and_return(valid_input)
	      end

	      it 'stops loop and does not display error message' do
	      	min = 1
	      	max = 7
	        error_message = "Input error! Please enter a number from #{min} to #{max}."
	        expect(game_input).not_to receive(:puts).with(error_message)
	        game_input.player_input(min, max)
	      end
	    end

	    context 'when user inputs an incorrect value once, then a valid input' do
	      before do
	        invalid_input = 'x'
	        valid_input = '3'
	        allow(game_input).to receive(:gets).and_return(invalid_input, valid_input)
	      end

	      it 'completes loop and displays error message once' do
	        min = 1
	        max = 7
	        error_message = "Input error! Please enter a number from #{min} to #{max}."
	        expect(game_input).to receive(:puts).with(error_message).once
	        game_input.player_input(min, max)
	      end
	    end

	    context 'when user inputs two incorrect values, then a valid input' do
	      before do
	        invalid_input = 'x'
	        valid_input = '3'
	        allow(game_input).to receive(:gets).and_return(invalid_input, invalid_input, valid_input)
	      end

	      it 'completes loop and displays error message twice' do
	        min = 1
	        max = 7
	        error_message = "Input error! Please enter a number from #{min} to #{max}."
	        expect(game_input).to receive(:puts).with(error_message).twice
	        game_input.player_input(min, max)
	      end
	    end
	end

	describe '#verify_input' do
    # Located inside #take_turn (Looping Script Method)
    # Query Method -> Test the return value

    # Note: #verify_input will only return a number if it is between?(min, max)

    	subject(:game_verify) { described_class.new }

	    context 'when given a valid input as argument' do
	      it 'returns valid input' do
	        valid_input = 5
	        expect(game_verify.verify_input(1,10, valid_input)).to be_positive.and be < 11
	      end
	    end

	    context 'when given invalid input as argument' do
	      it 'returns nil' do
	        invalid_input = 9
	        expect(game_verify.verify_input(1,2, invalid_input)).to be_nil
	      end
	    end
    end

    describe '#col_picker' do

    	subject(:game_colpick) { described_class.new }
    	context 'full column chosen' do

    		before do
	        	extra_input = '1'
	        	valid_input = '3'
	        	allow(game_colpick).to receive(:gets).and_return(extra_input, valid_input)
	        	(0..5).each { |i| game_colpick.board[0][i] = 1 }
	      	end

    		it 'gives the full column error message' do
	    		
	    		error_message = "That one's full! Please choose a column with room."
	    		expect(game_colpick).to receive(:puts).with(error_message).once
	    		game_colpick.col_picker
	    	end
    	end
    	context 'input outside range was chosen' do
    		before do
	        	bad_input = '9'
	        	valid_input = '7'
	        	allow(game_colpick).to receive(:gets).and_return(bad_input, valid_input)
	      	end

    		it 'gives the outside range error message' do
	    		error_message = "Please enter a column that exists, and has room"
	    		expect(game_colpick).to receive(:puts).with(error_message).once
	    		game_colpick.col_picker
    		end
    	end

    	context 'multiple bad inputs given' do
    		before do
	        	extra_input = '1'
	        	good_input = '3'
	        	allow(game_colpick).to receive(:gets).and_return(extra_input, extra_input, good_input)
	        	(0..5).each { |i| game_colpick.board[0][i] = 1 }
	      	end

	      	it 'gives multiple error messages then accepts good input' do
	      		error_message = "That one's full! Please choose a column with room."
	      		expect(game_colpick).to receive(:puts).with(error_message).twice
	      		game_colpick.col_picker
	      	end
    	end
    end

    describe '#set_colors' do
    	
    	context 'when choice is 1' do
    		subject(:game_colors) { described_class.new }

	    	it 'first player is red' do
	    		allow(game_colors).to receive(:player_input).with(1,2).and_return(1)
	    		game_colors.set_colors
	    		expect(game_colors.current_player).to eql(1)
	    	end
	    end
	    context 'when choice is 2' do
	    	subject(:game_colors) { described_class.new }
	    	
	    	it 'first player is blue' do
	    		allow(game_colors).to receive(:player_input).with(1,2).and_return(2)
	    		game_colors.set_colors
	    		expect(game_colors.current_player).to eql(2)
	    	end
	    end
    end

    describe '#won_board?' do
    # Located inside #play_game (Public Script Method)
    # these don't interpret
    	context 'when the board has 4 in a row somewhere' do
    		subject(:game_check_wins) { described_class.new() }

    		it 'detects rows with 4' do
    			(0..3).each { |i| game_check_wins.board[i][0] = 1 }
    			expect(game_check_wins.won_board?(0,0)).to eq(true)
    		end

    		it 'detects columns with 4' do
    			(0..3).each { |i| game_check_wins.board[0][i] = 1 }
    			expect(game_check_wins.won_board?(0,0)).to eq(true)
    		end

    		it 'detects diagonal rows of 4' do
    			(0..3).each { |i| game_check_wins.board[i][i] = 1 }
    			expect(game_check_wins.won_board?(0,0)).to eq(true)
    		end
    	end

    	context 'when there is no line of 4' do
    		subject(:game_check_bads) { described_class.new }

    		it 'returns false' do
    			expect(game_check_bads.won_board?(0,0)).to eq(false)
    		end

    		it 'ignores rows of 4 with both player pieces involved' do
    			(0..1).each { |i| game_check_bads.board[i][0] = 1 }
    			(2..3).each { |i| game_check_bads.board[i][0] = 2 }
    			expect(game_check_bads.won_board?(0,0)).to eq(false)
    		end
    	end
    end
end