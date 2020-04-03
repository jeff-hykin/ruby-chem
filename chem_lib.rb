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


# alloy_weight = 24.1.grams
# al_weight = alloy_weight * 77.3.percent
# al_moles = al_weight * Al.moles_per_gram
# h2_moles = al_moles * 3/2
# h2_grams = h2_moles * (H*2).weight
# puts "al_moles is: #{al_moles} "
# puts "h2_grams is: #{h2_grams} "


# # S*8 & Cl*2 -> S*2 + Cl*2
# # S*8 & 4 Cl*2 -> 4 S*2 + Cl*2
# puts which_is_limiting(29.0.grams, S*8, 75.7.grams, Cl*2, ratio: 1/4)

# s_moles = 0.11306924516531502.moles
# result_moles = s_moles*4
# result_weight = result_moles * (S*2 + Cl*2).weight
# puts "result_weight is: #{result_weight} "

$H = 6.626e-34 # some other constant related to plank
$C = 2.998e8 # speed of light


# given
def binding_energy
    nm = 217
    kinetic_energy = 2.0*10**-19

    meters = nm / 10**9

    puts "meters is: #{meters} "
    photon_energy = ($H * $C) / meters
    binding_energy = photon_energy - kinetic_energy
    puts "photon_energy is: #{photon_energy} "
    puts "binding_energy is: #{binding_energy} "
end


def energy_calc_2
    meters1 = 650.6/10**9
    meters2 = 703.2/10**9

    energy_1 = ($H * $C)/meters1
    energy_2 = ($H * $C)/meters2
    puts "energy_1 is: #{energy_1} "
    puts "energy_2 is: #{energy_2} "

    difference = energy_1 - energy_2
    hertz = difference / $H
    puts "hertz is: #{hertz.to_scientific} "

    # (((x) * 1000)/(6.626E-34))/1000 = 700
end





puts (Fe+C).valence_electrons 