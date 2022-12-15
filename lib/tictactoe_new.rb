class Player
  attr_accessor :name, :symbol

  @@number = 1
  @@symbols = %w[X O]

  def initialize
    @name = input_name
    @symbol = input_symbol
    @@number += 1
  end

  def input_name
    puts "Player #{@@number}, please enter your name:"
    @name = gets.chomp
  end

  def input_symbol
    if @@symbols.length == 1
      puts "Player #{@@number}, your symbol = #{@symbol}"
      @@symbols.pop
    else
      puts "Player #{@@number}, please enter 'X' or 'O' as your symbol"
      until @symbol == 'X' || @symbol == 'O'
        @symbol = gets.chomp.upcase
      end
      @@symbols.delete(symbol)
    end
  end
end

class Game
  attr_reader :p1, :p2, :field, :first, :winning_lines, :game_over

  def initialize(player1, player2)
    @p1 = player1
    @p2 = player2
    @field = fill_field
    @winning_lines = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                      [1, 4, 7], [2, 5, 8], [3, 6, 9],
                      [1, 5, 9], [3, 5, 7]]
    @game_over = false
    @first = true
  end

  def print_field
    puts " #{@field[1]} | #{@field[2]} | #{@field[3]}"
    puts '---+---+---'
    puts " #{@field[4]} | #{@field[5]} | #{@field[6]}"
    puts '---+---+---'
    puts " #{@field[7]} | #{@field[8]} | #{@field[9]}"
  end

  def fill_field
    res = {}
    (1..9).each do |num|
      res[num] = num
    end
    res
  end

  def make_guess(player)
    input = gets.chomp.to_i
    if @field.keys.include?(input) && @field[input] != @p1.symbol && @field[input] != @p2.symbol
      @field[input] = player.symbol
      alter_winning_lines(input, player.symbol)
    else
      make_guess(player)
    end
  end

  def alter_winning_lines(number, symbol)
    @winning_lines.each_with_index do |line, index|
      line.each_with_index do |num, idx|
        @winning_lines[index][idx] = symbol if num == number
      end
    end
  end

  def check_winner
    @winning_lines.each do |line|
      if line.all?(@p1.symbol)
        print_field
        game_over!
        annouce_winner(@p1.name)
      elsif line.all?(@p2.symbol)
        print_field
        game_over!
        annouce_winner(@p2.name)
      end
    end
  end

  def game_over!
    @game_over = true
  end

  def annouce_winner(name)
    puts "Congratulations #{name}, you win"
  end

  def next_player(player)
    if player == @p1
      @first = false
    else
      @first = true
    end
  end

  def play_turn(player)
    print_field
    puts "#{player.name}, it's your turn, choose a field"
    make_guess(player)
    check_winner
    next_player(player)
  end

  def check_field
    fields = @field.select do |_key, value|
      value.is_a?(Integer)
    end
    if fields.empty?
      game_over!
      puts 'This was a draw'
    end
  end

  def play_game
    until game_over
      if first
        play_turn(p1)
      else
        play_turn(p2)
      end
      check_field
    end
  end
end

game = Game.new(Player.new, Player.new)
game.play_game
