

class ConnectFour
	attr_accessor :board, :current_player
	def initialize
		@board = Array.new(7) { Array.new(6, nil) }
		@current_player = 1
		@winner = nil
	end

	def play_game
		introduction
		set_colors
		loop_turns
		results
	end

	def introduction
  		puts <<~HEREDOC

  		\e[31m   ____\e[0m \e[34m                            _     \e[0m\e[31m_____ \e[0m               
		\e[31m  / ___|\e[0m\e[34m ___  _ __  _ __   ___  ___| |_  \e[0m\e[31m|  ___|\e[0m\e[34m __  _   _ _ __ \e[0m
		\e[31m | |\e[0m\e[34m    / _ \\| '_ \\| '_ \\ / _ \\/ __| __| \e[0m\e[31m| |_\e[0m\e[34m  / _ \\| | | | '__|\e[0m
		\e[31m | |__\e[0m\e[34m | (_) | | | | | | |  __/ (__| |_  \e[0m\e[31m|  _|\e[0m\e[34m| (_) | |_| | |   \e[0m
		\e[31m  \\____\e[0m\e[34m \\___/|_| |_|_| |_|\\___|\\___|\\__| \e[0m\e[31m|_|\e[0m\e[34m   \\___/ \\__,_|_|  \e[0m
      		

      		NO holds barred, NO quarter given, NO mercy. This is Connect Four.
      		  \e[33m-\e[0mBe the first to get 4 in a row to win.
      		  \e[33m-\e[0mBlock your opponents if they're getting too close!

      		  \e[36m If your palms are sweating, that means you're doing it right.\e[0m

      		  Choose your color:
      		  	\e[33m [1]\e[0m \e[31mRed\e[0m
      		  	\e[33m [2]\e[0m \e[34mBlue\e[0m

    HEREDOC
  	end

  	def set_colors
		@current_player = player_input(1,2)
  	end

  	def player_input(min, max)
    	loop do
      		user_input = gets.chomp
      		verified_number = verify_input(min, max, user_input.to_i) if user_input.match?(/^\d+$/)
      		return verified_number if verified_number
      		puts "Input error! Please enter a number from #{min} to #{max}."
    	end
  	end

  	def verify_input(min, max, input)
    	return input if input.between?(min, max)
  	end

  	def loop_turns

  		turn_count = 0
  		while turn_count < 42
  			#the current player needs to choose a column
  			display_board

  			#we'll grab the array index of the chosen column
	  		x_coord = input_prompt

	  		#add the current_player's id to that stack & grab the y-index
	  		y_coord = stack_column(x_coord)

	  		#we use these to check if the added coin wins the game, if so break
	  		if won_board?(x_coord,y_coord)
	  			@winner = @current_player 
	  			return
	  		end

	  		#otherwise add a turn counter and swap the current player
	  		turn_count += 1
	  		@current_player == 1 ? @current_player = 2 : @current_player = 1
	  	end

	  	#if we run out of turns, @winner remains nil and we return
	  	return
  	end

  	def display_board
  		puts "   \e[31m .=============================.\e[0m"
  		puts "   \e[31m||                             ||\e[0m"
  		(0..5).to_a.reverse.each do |y|
  			row_string = "   \e[31m|| \e[0m"
  			(0..6).each do |x|
  				player = @board[x][y]
  				row_string.concat("[\e[31m@\e[0m] ") if player == 1
  				row_string.concat("[\e[34m@\e[0m] ") if player == 2
  				row_string.concat("[ ] ") if player == nil
  			end
  			row_string.concat("\e[31m||\e[0m")
  			puts row_string
  		end
  		puts "   \e[31m||-----------------------------||\e[0m"
  		puts "   \e[31m||\e[0m \e[33m[1] [2] [3] [4] [5] [6] [7]\e[0m \e[31m||\e[0m"
  	end

  	def input_prompt
  		puts <<~HEREDOC

  		Select a row to drop a coin:

  		HEREDOC
  		col_picker
  	end

  	def col_picker
  		loop do
  			user_input = gets.chomp
  			if user_input.match?(/^\d+$/)
	      		verified_number = verify_col_input(user_input.to_i - 1) 
	      		case verified_number
	      		when -2
	      			puts "That one's full! Please choose a column with room."
	      		when -1
	      			puts "Please enter a column that exists, and has room"
	      		else
	      			return verified_number
	      		end
	      	else
	      		puts "That's not a number!"
	  		end
	  	end
  	end

	def verify_col_input(input)
		return -1 if input < 0 || input > 6
		return input if @board[input][5] == nil
		return -2
	end

	def stack_column(x_coord)
  		dex = 0
  		while(@board[x_coord][dex] != nil && dex < 6)
  			dex += 1
  		end
  		@board[x_coord][dex] = @current_player
  		return dex
  	end

  	# this is run right after placing a coin, we reference @current_player a lot 
  	# here because we use that value to identify placed "coins" inside of @board
  	def won_board?(x, y)
  		return true if check_left(x,y) + check_right(x,y) + 1 == 4
  		return true if check_top(x,y) + check_below(x,y) + 1 == 4
  		return true if check_ul(x,y) + check_dr(x,y) + 1 == 4
  		return true if check_dl(x,y) + check_ur(x,y) + 1 == 4
  		return false
  	end

  	def check(x,y)
  		return true if @board[x][y] == @current_player
  		false
  	end

  	def check_left(x,y)
  		return 0 if x == 0
  		return 1 + check_left(x-1,y) if check(x-1,y)
  		return 0
  	end

  	def check_right(x,y)
  		return 0 if x == 6
  		return 1 + check_right(x+1,y) if check(x+1,y)
  		return 0
  	end

  	def check_top(x,y)
  		return 0 if y == 5
  		return 1 + check_top(x,y+1) if check(x,y+1)
  		return 0
  	end

  	def check_below(x,y)
  		return 0 if y == 0
  		return 1 + check_below(x,y-1) if check(x,y-1)
  		return 0
  	end

  	def check_ul(x,y)
  		return 0 if y == 5 || x == 0
  		return 1 + check_ul(x-1,y+1) if check(x-1,y+1)
  		return 0
  	end

  	def check_dl(x,y)
  		return 0 if y == 0 || x == 0
  		return 1 + check_dl(x-1,y-1) if check(x-1,y-1)
  		return 0
  	end

  	def check_ur(x,y)
  		return 0 if y == 5 || x == 6
  		return 1 + check_ur(x+1,y+1) if check(x+1,y+1)
  		return 0
  	end

  	def check_dr(x,y)
  		return 0 if y == 0 || x == 6
  		return 1 + check_dr(x+1,y-1) if check(x+1,y-1)
  		return 0
  	end

  	def results
  		display_board
  		if @winner == 1
  			puts "\n     \e[31mRed\e[0m wins!"
  		elsif @winner == 2
  			puts "\n     \e[34mBlue\e[0m wins!"
  		else
  			puts "\n   You ran out of turns! \e[33mTry again!\e[0m"
  		end
  	end
end

game = ConnectFour.new
game.play_game