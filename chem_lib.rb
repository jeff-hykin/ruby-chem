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



volume = 0.3
molarity = 0.184 

puts "Copper(II) Iodine weight is: #{ ( Cu+I*2 ).weight } "

solute = volume * molarity
puts "solute is: #{solute} "
amount = solute * ( Cu+I*2 ).weight
puts "amount is: #{amount} "


grams = 18.6
moles_per_gram = (Na*2 + S).moles_per_gram
moles = grams * moles_per_gram
liters = 0.375

moles_per_liter = moles / liters
grams_per_mole  = ( Fe*2 + (S+O*4)*3 ).weight


grams_per_liter = moles_per_liter * grams_per_mole
puts "grams_per_liter is: #{grams_per_liter} "
puts "19.9/grams_per_liter is: #{19.9/grams_per_liter} "

18.6 