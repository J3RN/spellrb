shared_context 'with a hash' do
  let(:word_hash) { { 'alpha' => 2, 'beta' => 20 } }
  let(:misspelling) { 'alphabet' }
  let(:correct)     { 'alpha' }

  subject do
    Spell::Spell.new(word_hash)
  end
end

shared_context 'with an array' do
  let(:word_array) { %w(alpha beta) }
  let(:misspelling) { 'alphabet' }
  let(:correct)     { 'alpha' }

  subject do
    Spell::Spell.new(word_array)
  end
end
