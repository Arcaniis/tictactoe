require 'pry'

def system_clear
  system("cls")
  system("clear")
end

def draw_board(spaces, space = 10, symbol = nil)
  system_clear
  spaces[space] = symbol

  puts "          KEY          "
  puts "       |       |                        |       |       "
  puts "   1   |   2   |   3                #{spaces[1]}   |   #{spaces[2]}   |   #{spaces[3]}   "
  puts "       |       |                        |       |       "
  puts "-------+-------+-------          -------+-------+-------"
  puts "       |       |                        |       |       "
  puts "   4   |   5   |   6                #{spaces[4]}   |   #{spaces[5]}   |   #{spaces[6]}   "
  puts "       |       |                        |       |       "
  puts "-------+-------+-------          -------+-------+-------"
  puts "       |       |                        |       |       "
  puts "   7   |   8   |   9                #{spaces[7]}   |   #{spaces[8]}   |   #{spaces[9]}   "
  puts "       |       |                        |       |       "
end

def who_goes_first
  players = [0,1]
  players.sample
end

def players_turn(spaces, empty_spaces, player_name)
  draw_board(spaces)
  begin
    puts "\n#{player_name}'s turn."
    puts "\nChoose which space to place your X:"
    space = gets.to_i
  end until empty_spaces.keys.include?(space)
  empty_spaces.delete(space)
  draw_board(spaces, space, 'X')
  if winner_found?(spaces)
    puts "\nYou Win!"
    sleep(2)
  end
end

def smart_move(spaces, empty_spaces)
  # Check for blocking player's winning move
  x_count = 0
  space_available = false
  smart_move = 0
  chosen_space = nil
  winning_combinations = [[1,2,3], [4,5,6], [7,8,9], [1,5,9], [7,5,3], [1,4,7], [2,5,8], [3,6,9]]
  winning_combinations.each do |combination|
    combination.each do |space|
      if spaces[space] == 'X'
        x_count += 1
      end
      
      if spaces[space] == ' '
        space_available = space
      end

      if space_available && x_count == 2
      smart_move = space_available
      end
    end

    x_count = 0
    space_available = false

    if smart_move != 0
      chosen_space = smart_move
    else
      chosen_space = empty_spaces.keys.sample
    end
  end
  # Could add a check before the return for computer to have a winning move...
  chosen_space
end

def computers_turn(spaces, empty_spaces)
  draw_board(spaces)
  puts "\nComputer's turn."
  sleep(2)
  space = smart_move(spaces, empty_spaces)
  empty_spaces.delete(space)
  draw_board(spaces, space, 'O')
  if winner_found?(spaces)
    puts "\nComputer wins :("
  end
end

def winner_found?(spaces)
  someone_won = false
  combination_symbols = []
  winning_combinations = [[1,2,3], [4,5,6], [7,8,9], [1,5,9], [7,5,3], [1,4,7], [2,5,8], [3,6,9]]
  winning_combinations.each do |combination|
    combination.each do |space|
      combination_symbols << spaces[space]
    end
    combination_symbols.uniq!
    someone_won = true if combination_symbols.count == 1 && !combination_symbols.include?(' ')
    combination_symbols = []
  end
  someone_won
end

def play(player_name)
  system_clear
  spaces = {}
  (1..9).each {|space| spaces[space] = ' '}

  empty_spaces = {}
  (1..9).each {|space| empty_spaces[space] = 'Not Empty'}

  draw_board(spaces)
  whos_turn = who_goes_first

  begin
    if whos_turn == 0
      players_turn(spaces, empty_spaces, player_name)
      whos_turn = 1
    else
      computers_turn(spaces, empty_spaces)
      whos_turn = 0
    end
  end until empty_spaces == {} || winner_found?(spaces)

  if !winner_found?(spaces)
    puts "\nTie game!"
  end

  begin
    puts "\nDo you wish to play again? (Y/N)"
    play_again = gets.chomp.downcase
  end until play_again == 'y' || play_again == 'n'

  play(player_name) if play_again == 'y'
end

puts "\nWelcome to Tic Tac Toe!"
puts "\nPlease enter your name:"
player_name = gets.chomp.split(" ").each {|name| name.capitalize!}.join(" ")

begin
  puts "\nReady to play? (Y/N)"
  ready = gets.chomp.downcase
end until ready == 'y' || ready == 'n'

if ready == 'y'
  play(player_name)
end