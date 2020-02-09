require 'atk_toolbox'
require_relative "./chem_lib/elements.rb"


def which_is_limiting(first_amount, first, second_amount,second, ratio:nil)
    # example:
    #    puts which_is_limiting(280.grams, Si+O*2, 217.grams, C, ratio: 0.333333333333333)
    
    ratio_first_to_second = ratio
    first_moles = first_amount * first.moles_per_gram
    second_moles = second_amount * second.moles_per_gram
    puts "    first_moles is: #{first_moles} "
    puts "    second_moles is: #{second_moles} "

    actual_ratio = first_moles / second_moles
    
    proportion_of_first = ratio_first_to_second / actual_ratio
    proportion_of_second = actual_ratio / ratio_first_to_second
    puts ""
    puts "    actual_ratio is: #{actual_ratio} "
    puts "    ratio_first_to_second is: #{ratio_first_to_second} "
    puts ""
    puts "    proportion_of_first is: #{proportion_of_first} "
    puts "    proportion_of_second is: #{proportion_of_second} "
    puts ""
    if actual_ratio < ratio_first_to_second
        return { limiting: first.to_s, leftover: "#{(1-proportion_of_second) * second_amount} of #{second.to_s}", percent_leftover: ((1-proportion_of_second)*100).round(2).to_s+"%" }
    else 
        return { limiting: second.to_s, leftover: "#{(1-proportion_of_first) * first_amount} of #{first.to_s}", percent_leftover: ((1-proportion_of_first)*100).round(2).to_s+"%"  }
    end
end

def percent_yeild(grams_of_first, first, grams_of_result, result, ratio:nil)
    # ex: percent_yeild(4.9e3.grams, H*2, 2.7e4.grams, C+H*4+O, ratio: 2)
    # ex: percent_yeild(6.0e3.grams, H*2, 2.9e4.grams, C+H*4+O, ratio: 2)
    first_moles = grams_of_first * first.moles_per_gram
    result_moles = grams_of_result * result.moles_per_gram
    
    puts "    first.weight is: #{first.weight} "
    puts "    first_moles is: #{first_moles} "

    actual_moles_of_result = first_moles * (1/ratio)
    actual_grams_of_result = actual_moles_of_result * result.weight
    puts "    grams_of_result is: #{grams_of_result} "
    puts "    actual_grams_of_result is: #{actual_grams_of_result} "
    puts "    grams_of_result/actual_grams_of_result is: #{grams_of_result/actual_grams_of_result} "
    puts "% is: #{(grams_of_result/actual_grams_of_result).round(5).to_percent} "
end


