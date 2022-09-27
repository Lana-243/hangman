require 'rspec'

require 'game'

describe Game do
  let(:game) { Game.new('Ruby') }

  describe '#initialize' do
    it 'should show full original word' do
      expect(game.instance_variable_get(:@letters)).to include('R', 'U', 'B', 'Y')
    end

    it 'should have exact length' do
      expect(game.instance_variable_get(:@letters).length).to eq(4)
    end

    it 'should not have any user guesses' do
      expect(game.instance_variable_get(:@user_guesses)).to be_empty
    end
  end

  describe '#normalize_letter' do
    it 'should change to E' do
      expect(game.normalize_letter('Ё')).to eq('Е')
    end

    it 'should keep E' do
      expect(game.normalize_letter('Е')).to eq('Е')
    end

    it 'should change to И' do
      expect(game.normalize_letter('Й')).to eq('И')
    end

    it 'should keep И' do
      expect(game.normalize_letter('И')).to eq('И')
    end
  end

  context 'user makes one guess' do
    before { game.play!('R')}
    
    it 'should show user_guesses' do
      expect(game.instance_variable_get(:@user_guesses)).to include('R')
    end

    it 'should have only one letter' do
      expect(game.instance_variable_get(:@user_guesses).length).to eq(1)
    end

    it 'should show no errors' do
      expect(game.errors).to be_empty
    end

    it 'should show no errors made' do
      expect(game.errors_made).to eq(0)
    end

    it 'should have same number of errors_allowed as total' do
      expect(game.errors_allowed).to eq(Game::TOTAL_ERRORS_ALLOWED)
    end
    
    it 'should not end the game' do
      expect(game.over?).to be false
    end

    it 'should not lose the game' do
      expect(game.lost?).to be false
    end

    it 'should not win the game' do
      expect(game.won?).to be false
    end
  end

  context 'user makes five guesses, two are correct, two doubles' do
    before do
      game.play!('R')
      game.play!('I')
      game.play!('I')
      game.play!('Y')
      game.play!('Y')

    end

    it 'should show user_guesses' do
      expect(game.instance_variable_get(:@user_guesses)).to include('R', 'I', 'Y')
    end

    it 'should three letters, no duplicates' do
      expect(game.instance_variable_get(:@user_guesses).length).to eq(3)
    end

    it 'should show have one error' do
      expect(game.errors).to include('I')
    end

    it 'should show only one error made' do
      expect(game.errors_made).to eq(1)
    end

    it 'should have one less number of errors_allowed as total' do
      expect(game.errors_allowed).to eq(Game::TOTAL_ERRORS_ALLOWED - 1)
    end

    it 'should not end the game' do
      expect(game.over?).to be false
    end

    it 'should not lose the game' do
      expect(game.lost?).to be false
    end

    it 'should not win the game' do
      expect(game.won?).to be false
    end
  end

  context 'user wins' do
    before do
      game.play!('R')
      game.play!('Y')
      game.play!('A')
      game.play!('B')
      game.play!('U')
    end

    it 'should show user_guesses' do
      expect(game.instance_variable_get(:@user_guesses)).to include('R', 'Y', 'B', 'U')
    end

    it 'should have one error' do
      expect(game.errors_allowed).to eq(Game::TOTAL_ERRORS_ALLOWED - 1)
    end

    it 'should end the game' do
      expect(game.over?).to be true
    end

    it 'should not lose the game' do
      expect(game.lost?).to be false
    end

    it 'should win the game' do
      expect(game.won?).to be true
    end
  end

  context 'user loses' do
    before do
      game.play!('A')
      game.play!('O')
      game.play!('T')
      game.play!('R')
      game.play!('Q')
      game.play!('S')
      game.play!('S')
      game.play!('P')
      game.play!('K')
    end

    it 'should show user_guesses' do
      expect(game.instance_variable_get(:@user_guesses)).to include('R', 'S', 'P', 'Q')
    end

    it 'should have one error' do
      expect(game.errors_made).to eq(7)
    end

    it 'should end the game' do
      expect(game.over?).to be true
    end

    it 'should lose the game' do
      expect(game.lost?).to be true
    end

    it 'should not win the game' do
      expect(game.won?).to be false
    end
  end
end
