require './lib/tictactoe_new'

describe Game do
  let(:p1) { instance_double(Player, name: 'Max', symbol: 'X') }
  let(:p2) { instance_double(Player, name: 'Linda', symbol: 'O') }
  subject(:game) { described_class.new(p1, p2) }

  describe '#initialize' do
    it 'sets the players right' do
      expect(game.p1.name).to eq('Max')
      expect(game.p2.name).to eq('Linda')
      expect(game.p1.symbol).to eq('X')
      expect(game.p2.symbol).to eq('O')
    end

    it 'creates the field' do
      expect(game.fill_field).to eq({ 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9 })
    end
  end

  describe '#make_guess' do
    it 'alters the field with both players' do
      allow(game).to receive(:gets).and_return('22', '1', '99', '2')
      game.make_guess(p1)
      expect(game.field[1]).to eq('X')
      game.make_guess(p2)
      expect(game.field[2]).to eq('O')
    end

    it 'calls alter winning lines' do
      allow(game).to receive(:gets).and_return('1')
      expect(game).to receive(:alter_winning_lines).once
      game.make_guess(p1)
    end
  end

  describe '#alter_winning_lines' do
    it 'sets the symbol to the corresponding spot in @winning_lines' do
      game.alter_winning_lines(5, p1.symbol)
      expect(game.winning_lines).to include([4, 'X', 6], [1, 'X', 9])
      game.alter_winning_lines(4, p2.symbol)
      expect(game.winning_lines).to include(['O', 'X', 6], [1, 'O', 7])
    end
  end

  describe '#check_winner' do
    context 'checks if a player has won the game' do
      it 'checks if any of the winning lines contains one symbol three times' do
        game.alter_winning_lines(1, p1.symbol)
        game.alter_winning_lines(2, p1.symbol)
        game.alter_winning_lines(3, p1.symbol)
        allow(game).to receive(:print_field)
        allow(game).to receive(:puts)
        expect(game).to receive(:game_over!)
        game.check_winner
      end
    end
  end

  describe '#game_over!' do
    it 'sets @game over to true' do
      game.game_over!
      expect(game.game_over).to be true
    end
  end

  describe '#annouce_winner' do
    it 'puts a sentence announcing the winner' do
      congrats_phrase = "Congratulations #{p1.name}, you win\n"
      expect { game.annouce_winner(p1.name) }.to output(congrats_phrase).to_stdout
    end
  end

  describe '#next_player' do
    before(:each) do
      game.next_player(p1)
    end
    it 'sets first to false in case of play_turn(p1)' do
      expect(game.first).to be false
    end

    it 'sets first to true in case of play_turn(p2)' do
      game.next_player(p2)
      expect(game.first).to be true
    end
  end

  describe '#check_field' do
    context 'checks if there are still fields to take' do
      before do
        i = 1
        until i > 9
          allow(game).to receive(:gets).and_return(i.to_s)
          allow(game).to receive(:puts)
          game.make_guess(p1)
          i += 1
        end
      end
      it 'sets game_over to true if all fields are taken' do
        game.check_field
        expect(game.game_over).to be true
      end
    end
  end
end
