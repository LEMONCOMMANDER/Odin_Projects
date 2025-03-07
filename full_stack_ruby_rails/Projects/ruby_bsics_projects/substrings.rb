=begin
Implement a method #substrings that takes a word as the first argument and then an array of
valid substrings (your dictionary) as the second argument. It should return a hash listing each
substring (case insensitive) that was found in the original string and how many times it was found.

Next, make sure your method can handle multiple words
=end

def substrings(input, dictionary)
  output = {}
  input.downcase.split(' ') do |word|
    word = word.match(/\w+/).to_s


## reduce path
#     output = output.merge(
#       dictionary.reduce({}) do |acc, next_value|
#         if word.include?(next_value)
#           acc[next_value] = acc.has_key?(next_value) ? acc[next_value] + 1 : 1
#         end
#         acc
#       end
#       )
#   end
#       p output
# end

    dictionary.each do |comparative|
      if word.include?(comparative)
        if output.has_key?(comparative)
          output[comparative] += 1
        else
          output[comparative] = 1
        end
      end
    end
  end
  puts output
  return output
end

### TESTS
substrings("Howdy partner, sit down! How's it going?", ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"])
#>> {"howdy"=>1, "partner"=>1, "sit"=>1, "down"=>1, "how"=>2, "it"=>2, "going"=>1}

substrings("Hello there! How are you doing today?", ["hello", "there", "how", "are", "you", "doing", "today", "he", "lo", "re"])
#>> Expected output: {"hello"=>1, "there"=>1, "how"=>1, "are"=>1, "you"=>1, "doing"=>1, "today"=>1, "he"=>2, "lo"=>1, "re"=>1}

substrings("The quick brown fox jumps over the lazy dog", ["the", "quick", "brown", "fox", "jumps", "over", "lazy", "dog", "qui", "bro", "fo", "jum", "ov", "la", "do"])
#>> Expected output: {"the"=>2, "quick"=>1, "brown"=>1, "fox"=>1, "jumps"=>1, "over"=>1, "lazy"=>1, "dog"=>1, "qui"=>1, "bro"=>1, "fo"=>1, "jum"=>1, "ov"=>1, "la"=>1, "do"=>1}


substrings("To be or not to be, that is the question", ["to", "be", "or", "not", "that", "is", "the", "question", "qu", "es", "ti", "on"])
#>> Expected output: {"to"=>2, "be"=>2, "or"=>1, "not"=>1, "that"=>1, "is"=>1, "the"=>1, "question"=>1, "qu"=>1, "es"=>1, "ti"=>1, "on"=>1}