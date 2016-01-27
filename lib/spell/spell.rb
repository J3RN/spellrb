module Spell
  class Spell
    def initialize(word_hash, alpha = 0.3)
      proto_word_list = word_hash.map do |word, usage|
        [word, { usage: usage, bigrams: bigramate(word) }]
      end

      @max_usage = word_hash.values.max.to_f
      @max_usage = 1 if @max_usage == 0

      @word_list = Hash[proto_word_list]
      @alpha = alpha
    end

    # Returns the closest matching word in the dictionary
    def best_match(given_word)
      word_bigrams = bigramate(given_word)
      word_hash = @word_list.map do |key, info|
        [key, bigram_compare(word_bigrams, info[:bigrams])]
      end
      word_hash = Hash[word_hash]

      word_hash = apply_usage_weights(word_hash)
      word_hash.max_by { |_key, value| value }.first
    end

    # Returns a boolean for whether or not 'word' is in the dictionary
    def spelled_correctly?(word)
      @word_list.keys.include?(word)
    end

    # Return a value from 0.0-1.0 of how similar these two words are
    def compare(word1, word2)
      bigram_compare(bigramate(word1), bigramate(word2))
    end

    private

    # Returns the number of matching bigrams between the two sets of bigrams
    def num_matching(one_bigrams, two_bigrams, acc = 0)
      return acc if one_bigrams.empty? || two_bigrams.empty?

      one_two = one_bigrams.index(two_bigrams[0])
      two_one = two_bigrams.index(one_bigrams[0])

      if one_two.nil? && two_one.nil?
        num_matching(one_bigrams.drop(1), two_bigrams.drop(1), acc)
      else
        # If one is nil, it is set to the other
        two_one ||= one_two
        one_two ||= two_one

        if one_two < two_one
          num_matching(one_bigrams.drop(one_two + 1),
                       two_bigrams.drop(1), acc + 1)
        else
          num_matching(one_bigrams.drop(1),
                       two_bigrams.drop(two_one + 1), acc + 1)
        end
      end
    end

    # Returns an array of the word's bigrams (in order)
    def bigramate(word)
      (0..(word.length - 2)).map { |i| word.slice(i, 2) }
    end

    # Returns a value from 0 to 1 for how likely these two words are to be a
    # match
    def bigram_compare(word1_bigrams, word2_bigrams)
      most_bigrams = [word1_bigrams.count, word2_bigrams.count].max
      num_matching(word1_bigrams, word2_bigrams).to_f / most_bigrams
    end

    # For each word, adjust it's score by usage
    #
    # v = s * (1 - a) + u * a
    # Where v is the new value
    # a is @alpha
    # s is the bigram score (0..1)
    # u is the usage score (0..1)
    def apply_usage_weights(word_hash)
      weighted_array = word_hash.map do |word, bigram_score|
        usage_score = @word_list[word][:usage].to_f / @max_usage
        [word, (bigram_score * (1 - @alpha)) + (usage_score * @alpha)]
      end

      Hash[weighted_array]
    end
  end
end
