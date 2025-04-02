require 'rspec'
require_relative '..//bubble_sort'

#both bubble sorts return [output, time message]
# def random_array(size)
#   unsorted_array = Array.new(size) { rand(1..1000) }
#   return unsorted_array, size
# end

describe 'tests the performance and output of bubble sort methods' do
  let (:array1_100) { [133, 370, 684, 412, 699, 66, 411, 584, 360, 517, 190, 801, 242, 925, 299, 536, 211, 425, 841, 665, 280, 757, 75, 563, 384, 764, 627, 823, 257, 335, 533, 54, 772, 688, 533, 662, 915, 249, 70, 482, 7, 943, 892, 420, 257, 64, 936, 363, 986, 213, 716, 890, 717, 62, 643, 845, 899, 100, 979, 415, 328, 649, 83, 639, 607, 616, 448, 135, 533, 224, 411, 704, 427, 843, 10, 378, 817, 483, 508, 142, 286, 674, 948, 539, 701, 471, 75, 353, 358, 836, 593, 941, 917, 635, 343, 712, 937, 979, 261, 126] }

  # array1_100 = random_array(100)
  # array2_100 = random_array(100)
  # array3_100 = random_array(100)
  #
  # array1_500 = random_array(500)
  # array2_500 = random_array(500)
  # array3_500 = random_array(500)
  #
  # array1_1k = random_array(1000)
  # array2_1k = random_array(1000)
  # array3_1k = random_array(1000)
  #
  # array1_3k = random_array(3000)
  # array2_1k = random_array(3000)
  # array3_1k = random_array(3000)

  context "tests methods at array size 100" do
    it "tests array1_100" do
      # p array1_100
      # p array1_100.class

      #equal each other
      # expect(bubble_sort(array1_100)[0]).to eq(bubble_sort_reducer(array1_100)[0])
      expect(bubble_sort(array1_100)[0]).to eq([7, 10, 54, 62, 64, 66, 70, 75, 75, 83, 100, 126, 133, 135, 142, 190, 211, 213, 224, 242, 249, 257, 257, 261, 280, 286, 299, 328, 335, 343, 353, 358, 360, 363, 370, 378, 384, 411, 411, 412, 415, 420, 425, 427, 448, 471, 482, 483, 508, 517, 533, 533, 533, 536, 539, 563, 584, 593, 607, 616, 627, 635, 639, 643, 649, 662, 665, 674, 684, 688, 699, 701, 704, 712, 716, 717, 757, 764, 772, 801, 817, 823, 836, 841, 843, 845, 890, 892, 899, 915, 917, 925, 936, 937, 941, 943, 948, 979, 979, 986])
      puts "\e[31m\n#{bubble_sort(array1_100)[1]}\e[0m"

      expect(bubble_sort_reducer(array1_100)[0]).to eq([7, 10, 54, 62, 64, 66, 70, 75, 75, 83, 100, 126, 133, 135, 142, 190, 211, 213, 224, 242, 249, 257, 257, 261, 280, 286, 299, 328, 335, 343, 353, 358, 360, 363, 370, 378, 384, 411, 411, 412, 415, 420, 425, 427, 448, 471, 482, 483, 508, 517, 533, 533, 533, 536, 539, 563, 584, 593, 607, 616, 627, 635, 639, 643, 649, 662, 665, 674, 684, 688, 699, 701, 704, 712, 716, 717, 757, 764, 772, 801, 817, 823, 836, 841, 843, 845, 890, 892, 899, 915, 917, 925, 936, 937, 941, 943, 948, 979, 979, 986])
      puts "\e[31m\n#{bubble_sort_reducer(array1_100)[1]}\e[0m"
    end

    # it "tests array2_100" do
    #
    # end
  end
end