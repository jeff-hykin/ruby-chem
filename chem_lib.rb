require 'atk_toolbox'
require_relative "./chem_lib/elements.rb"

# proportion_first = 0.302
# first = Mg+O
# second = ((Fe*2)+(O*3))
# mols_first  = (       100 * proportion_first  ) /   first.weight
# mols_second = (100 - (100 * proportion_first) ) /   second.weight
# total_mols = mols_first + mols_second
# puts "mols_second is: #{mols_second} "
# puts "second.weight is: #{second.weight} "
# puts "total_mols is: #{total_mols} "

# atoms_first = mol2atoms(mols_first)
# atoms_second = mol2atoms(mols_second)
# total_atoms = atoms_first + atoms_second
# puts " atoms: #{100 * atoms_first / total_atoms}"
# puts " atoms: #{100 * atoms_second / total_atoms}"

# grams_first = mols_first * first.weight
# grams_second = mols_second * second.weight
# total_grams = grams_first + grams_second

# puts " mass: #{100 * grams_first / total_grams}"
# puts " mass: #{100 * grams_second / total_grams}"

first = Si+O*2
second = C

def which_is_limiting(first_amount, first, second_amount,second, ratio:nil)
    ratio_first_to_second = ratio
    first_moles = first_amount / first.moles_per_gram
    second_moles = second_amount / second.moles_per_gram

    actual_ratio = first_moles / second_moles
    
    proportion_of_first = ratio_first_to_second / actual_ratio
    proportion_of_second = actual_ratio / ratio_first_to_second
    puts "proportion_of_first is: #{proportion_of_first} "
    puts "proportion_of_second is: #{proportion_of_second} "
    if actual_ratio < ratio_first_to_second
        return { limiting: :first, leftover: proportion_of_second * second_amount }
    else 
        return { limiting: :second, leftover: proportion_of_first * first_amount }
    end
end

puts which_is_limiting(260.grams, Si+O*2, 219.grams, C, ratio: 1/3)
# puts first.weight

# puts (Si+O*2)
# puts C.weight

