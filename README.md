# Text generation with Markov chains

Your task is to implement a Markov text generator.

## Background


Markov chains are a mathematical process to generate output that is similar to but different from some set of input. There are many practical applications for Markov chains, but one especially fun one is to use Markov chains to generate text. These have been used to generate filler text, produce bogus scientific papers, and power fun twitter bots.

![@Horse_ebooks screenshot](https://i.imgur.com/Qu9f0yF.png)

![@erowidrecruiter screenshot](https://i.imgur.com/M9jrImi.png)

## Implement a Markov text generator

The simplest way to implement a Markov text generator is to:
1. Keep track of the frequency of the words that appear after each word in the input.
2. Starting with an arbitrary word from the input, choose a random word that followed it, choose a random word that follows that word, etc.

<details>
<summary>Hint: look here for more detail</summary>

To break the process down a little more:
* Break the input text into words. Ruby's String class has a `#split` method that works great for this.
* Build a hash that keeps track of all of the words that appear immediately after each word in the the input.
* Choose a random word from the text, and then choose a random word from the list of words that followed that word.
* Choose a random word that follows the following word from the last step, and repeat.

For example, given the input text:

> the cat the dog the guinea pig

I could generate a hash like:

```
{
  "the" => ["cat", "dog", "guinea"],
  "cat" => ["the"],
  "dog" => ["the"],
  "guinea" => ["pig"]
}
```

Starting with a random word `"dog"`, the only possible following word is `"the"`. Choosing a random following word from `"the"`, I might end up with `"dog"` again. Repeating this process a few more times, I could end up with output like:

> "the dog the dog the dog the dog the cat the guinea pig"

> "dog the cat the cat the dog the cat the dog the cat"

</details>

<details>
<summary>Example implementation</summary>

```ruby

class MarkovGenerator
  def self.from_file file
    from_text File.read(file)
  end

  def self.from_text text
    freq_hash = Hash.new {|hash, key| hash[key] = [] }

    text.split.each_cons(2) do |word, following_word|
      freq_hash[word] << following_word
    end

    current_word = freq_hash.keys.sample
    sentence = [current_word]

    12.times do
      current_word = freq_hash[current_word].sample
      sentence << current_word
    end

    sentence.join(" ")
  end
end

```

Save this to a file named markov_generator.rb, then use it from your command line like:

`$ ruby -I. -rmarkov_generator -e "p MarkovGenerator.from_file 'ruby.txt'"`

This should provide output like: 
> "variety of ``scripts'' with Ruby excelled, and shell scripts, orchestrating the old days,"

> "favorite features: full regular expression support, tight integration with Ruby, you might think."
</details>

## More natural sentence construction

You probably noticed that the text generated with the simple implementation did not sound natural, for example, it would often awkwardly include punctuation or start a sentence. Think of a way to handle the beginning and end of sentences in a more natural sounding way.

<details>
<summary>Hint</summary>

A relatively straightforward way to do this would be to treat sentence-ending punctuation (ie, `.`, `?`, and `!`) as words themselves.
</details>

## More natural sounding text

You can generate more natural sounding text by keeping track of more information when processing your input. For example, instead of keeping track of the frequencies of the words following each word, keep track of the frequencies of the words following each pair of words. 

Instead of each pair of words, you could also use each trio of words. What works best for this will likely depend on your input text.

<details>
<summary>Hint</summary>

When building your hash of following word frequencies from the input, use each pair of words as the key for your hash, so that for this input text:

> the cat the dog the guinea pig

My frequencies hash might look like:

```
{
  ["the", "cat"] => ["the"],
  ["cat", "the"] => ["dog"],
  ["the", "dog"] => ["the"],
  ["dog", "the"] => ["guinea"],
  ["the", "guinea"] => ["pig"],
}
```

Note that this refinement will most likely not work well on such a small input text!
</details>

## Taking it further

* A fun application of Markov text generation is to mashup multiple sources of input. Modify your code to handle multiple sources.
* If you're generating text for a user in an interactive context, you might want to use some of the user's input as a "seed" for generating your response. Modify your generator to be able to take a user's text as additional input and generate custom responses to it.
* Random English text encountered in the wild will not be well formed enough to be processed easily by a computer. For example, look at Bram Stoker's Dracula from Project Gutenberg, is there anything you could do to generate text from it more naturally? http://www.gutenberg.org/cache/epub/345/pg345.txt
* Many times your input text will contain punctuation that can cause awkward output, like quoted strings or phrases in parenthesis. Is there a way to handle this more naturally?
