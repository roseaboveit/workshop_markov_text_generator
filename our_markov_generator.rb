class OurMarkovGenerator
  def initialize file
    @markov_hash = {}
    get_hash file
    create_sentence
  end

  def get_hash file
    orig_text = File.open(file).read
    orig_text.gsub!(/\n/, " ")
    orig_text.gsub!(/[,`();-]/, " ")
    word_array = orig_text.split(" ") #==> Array
    word_array.each_with_index do |word, i|
      unless word[-1] == "."
        next_word = word_array[i + 1]
        if @markov_hash[word]
          @markov_hash[word] << next_word
        else
          @markov_hash[word] = [next_word]
        end
      end
    end
  end

  def create_sentence
    starting_word = @markov_hash.keys.sample
    sentence_array = [starting_word]
    next_word = find_next_word starting_word
    while next_word[-1] != "."
      sentence_array << next_word
      next_word = find_next_word next_word
    end
    sentence_array << next_word
    puts sentence_array.join(" ")
  end

  def find_next_word word
    @markov_hash[word].sample
  end

end
