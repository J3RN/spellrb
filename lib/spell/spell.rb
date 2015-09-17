module Spell
  class Spell
    def initialize(*args)
      fail "Too many arguments given" if args.count > 3

      if args[0].is_a? Hash
        @word_list = args[0]
        @alpha = args[1] || 0.3
      elsif args[0].is_a? Array
        fail "Word usage weights do not make sense with an Array" if args[1]
        @word_list = args[0]
      else
        fail "First argument must be an Array or Hash"
      end
    end

    # Returns the closest matching word in the dictionary
    def best_match(given_word)
      words = (@word_list.is_a? Array) ? @word_list : @word_list.keys

      word_bigrams = bigramate(given_word)
      word_hash = words.map do |key|
        [key, bigram_compare(word_bigrams, bigramate(key))]
      end
      word_hash = Hash[*word_hash.flatten]

      # Weight by word usage, if logical
      word_hash = apply_usage_weights(word_hash) if @word_list.is_a? Hash

      word_hash.max_by { |key, value| value }.first
    end

    # Returns a boolean for whether or not 'word' is in the dictionary
    def spelled_correctly?(word)
      if @word_list.is_a? Hash
        @word_list.keys.include?(word)
      else
        @word_list.include?(word)
      end
    end

    # Return a value from 0.0-1.0 of how similar these two words are
    def compare(word1, word2)
      bigram_compare(bigramate(word1), bigramate(word2))
    end

    private

    # Returns the number of matching bigrams between the two sets of bigrams
    def num_matching(one_bigrams, two_bigrams, acc = 0)
      return acc if (one_bigrams.empty? || two_bigrams.empty?)

      one_two = one_bigrams.index(two_bigrams[0])
      two_one = two_bigrams.index(one_bigrams[0])

      if (one_two.nil? && two_one.nil?)
        num_matching(one_bigrams.drop(1), two_bigrams.drop(1), acc)
      else
        # If one is nil, it is set to the other
        two_one ||= one_two
        one_two ||= two_one

        if one_two < two_one
          num_matching(one_bigrams.drop(one_two + 1), two_bigrams.drop(1), acc + 1)
        else
          num_matching(one_bigrams.drop(1), two_bigrams.drop(two_one + 1), acc + 1)
        end
      end
    end

    # Returns an array of the word's bigrams (in order)
    def bigramate(word)
      (0..(word.length - 2)).map { |i| word.slice(i, 2) }
    end

    # Returns a value from 0 to 1 for how likely these two words are to be a match
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
      max_usage = @word_list.values.max.to_f
      max_usage = 1 if max_usage == 0

      weighted_array = word_hash.map do |word, bigram_score|
        usage_score = @word_list[word].to_f / max_usage
        [word, (bigram_score * (1 - @alpha)) + (usage_score * @alpha)]
      end

      Hash[*weighted_array.flatten]
    end
  end
end
