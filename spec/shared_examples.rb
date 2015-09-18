shared_examples 'a spelling corrector' do
  it 'corrects the misspelling' do
    expect(subject.best_match(misspelling)).to eq(correct)
  end
end

shared_examples 'a spell checker' do
  it 'knows what is spelled correctly' do
    expect(subject.spelled_correctly? correct).to be true
  end

  it 'knows what is spelled incorrectly' do
    expect(subject.spelled_correctly? misspelling).to be false
  end
end
