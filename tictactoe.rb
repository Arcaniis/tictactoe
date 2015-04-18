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
  whos_turn = players.sample
end

def winner_found(spaces)
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
  return someone_won
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
      draw_board(spaces)
      begin
        puts "\n#{player_name}'s turn."
        puts "\nChoose which space to place your X:"
        space = gets.to_i
      end until empty_spaces.keys.include?(space)
      empty_spaces.delete(space)
      draw_board(spaces, space, 'X')
      winner = winner_found(spaces)
      if winner == true
        puts "\nYou Win!"
      end
      whos_turn = 1
    else
      draw_board(spaces)
      puts "\nComputer's turn."
      sleep(2)
      space = empty_spaces.keys.sample
      empty_spaces.delete(space)
      draw_board(spaces, space, 'O')
      winner = winner_found(spaces)
      if winner == true
        puts "\nComputer wins :("
      end
      whos_turn = 0
    end
  end until empty_spaces == {} || winner == true

  if winner == false
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