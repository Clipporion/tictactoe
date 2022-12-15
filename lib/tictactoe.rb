class Game
  def initialize
      @field = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9}
      @free = [1,2,3,4,5,6,7,8,9]
      @winning_lines = [[1,2,3],[4,5,6],[7,8,9],
                          [1,4,7],[2,5,8],[3,6,9],
                          [1,5,9],[3,5,7]]
      @first_player = true
      @ended = false
  end

  attr_accessor :field, :free, :first_player, :ended, :winning_lines

  def print_board
      puts "  #{field[1]}  |  #{field[2]}  |  #{field[3]}"
      puts "-----+-----+-----"
      puts "  #{field[4]}  |  #{field[5]}  |  #{field[6]}"
      puts "-----+-----+-----"
      puts "  #{field[7]}  |  #{field[8]}  |  #{field[9]}"
  end

end

class Player
  @@number = 1

  def initialize
    @name = ""
    @symbol = ""
    while @name == ""
      puts "Player #{@@number}, enter your name:"
      @name = gets.chomp
    end
    while @symbol == "" || @symbol.length > 1
      puts "#{@name}, enter a single sign as your symbol:"
      @symbol = gets.chomp
    end
    @@number += 1
  end

  attr_reader :name, :symbol
  attr_accessor :number

  def choose_field
      $game.print_board
      puts "#{@name}, enter number of field:"
      choice = gets.chomp.to_i
      if choice.is_a?(Integer)
          if $game.free.include?(choice)
              $game.field[choice] = @symbol
              $game.winning_lines.each_with_index do |line, index|
                  line.each_with_index do |number, idx|
                      if number == choice
                          $game.winning_lines[index][idx] = symbol
                      end
                  end
              end
              $game.free.delete(choice)
              if $game.first_player == true
                  $game.first_player = false
              else
                  $game.first_player = true
              end
          else
              puts "This field is not available"
              choose_field
          end
      else
          puts "Please choose a valid field"
          choose_field
      end
  end

  def check_winner
      $game.winning_lines.each do |line|
          if line.all?(@symbol)
              $game.print_board
              puts "#{@name} is the winner, congratulations"
              $game.ended = true
              puts "Do you want to play again? (Y or N)"
              if gets.chomp == "Y"
                  @@number = 1
                  play_game
              end
          end
      end
  end

end

def play_game
  $game = Game.new
  player1 = Player.new
  player2 = Player.new

  while $game.ended == false
    if $game.free.empty?
      $game.print_board
      puts 'This was a draw'
      $game.ended = true
    elsif
      if $game.first_player == true
        player1.choose_field
        player1.check_winner
      elsif $game.first_player == false
        player2.choose_field
        player2.check_winner
        end
    end
  end
end

play_game
