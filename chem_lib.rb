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
puts first.weight

p (Si+O*2)
p C.weight

# puts 260.grams / first.moles_per_gram