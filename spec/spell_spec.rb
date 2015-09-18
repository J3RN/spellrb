require 'spec_helper'

describe 'Spell' do
  describe '.best_match' do
    context 'with a hash' do
      include_context 'with a hash'
      it_behaves_like 'a spelling corrector'

      context 'with a strong weight' do
        subject do
          Spell::Spell.new(word_hash, 0.5)
        end

        it 'corrects differently' do
          # Compare score for 'alpha':  0.5714285714285714
          # Compare score for 'beta':   0.2857142857142857
          # alpha total score = ((2.0 / 20.0)  * 0.5 + (0.57 * 0.5))  = 0.33
          # beta  total score = ((20.0 / 20.0) * 0.5 + (0.28 * 0.5))  = 0.64
          expect(subject.best_match(misspelling)).to eq('beta')
        end
      end
    end

    context 'with an array' do
      include_context 'with an array'
      it_behaves_like 'a spelling corrector'
    end
  end

  describe '.spelled_correctly?' do
    context 'with a hash' do
      include_context 'with a hash'
      it_behaves_like 'a spell checker'
    end

    context 'with an array' do
      include_context 'with an array'
      it_behaves_like 'a spell checker'
    end
  end

  describe '.compare' do
    include_context 'with a hash'

    it 'returns the correct decimal value' do
      expect(subject.compare('hello', 'shallow')).to eq(1.0 / 3)
    end
  end
end
