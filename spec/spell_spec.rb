require 'spec_helper'

describe 'Spell' do
  let(:word_hash) { { 'alpha' => 2, 'beta' => 20 } }
  let(:misspelling) { 'alphabet' }
  let(:correct)     { 'alpha' }

  subject do
    Spell::Spell.new(word_hash)
  end

  describe '.best_match' do
    context 'with a hash' do
      it 'corrects the misspelling' do
        expect(subject.best_match(misspelling)).to eq(correct)
      end

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
  end

  describe '.spelled_correctly?' do
    context 'with a hash' do
      it 'knows what is spelled correctly' do
        expect(subject.spelled_correctly? correct).to be true
      end

      it 'knows what is spelled incorrectly' do
        expect(subject.spelled_correctly? misspelling).to be false
      end
    end
  end

  describe '.compare' do
    it 'returns the correct decimal value' do
      expect(subject.compare('hello', 'shallow')).to eq(1.0 / 3)
    end
  end
end
