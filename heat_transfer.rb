# A piece of titanium metal with a mass of 22.1 g is heated in boiling water to 99.5 °C and then dropped into a coffee-cup calorimeter containing 75.0 g of water at 21.6 °C. When thermal equilibrium is reached, the final temperature is 24.4 °C. Calculate the specific heat capacity of titanium. (The specific heat capacity of liquid water is 4.184 J/g ⋅ K.)

mass_1 = 22.1
temp_1 = 99.5
mass_2 = 75.0
temp_2 = 21.6
specific_heat_2 = 4.184
final_temp = 24.4


energy_1 = mass_1 * (final_temp - temp_1)
energy_2 = mass_2 * (final_temp - temp_2) * specific_heat_2

specific_heat_1 = energy_2 / energy_1

puts specific_heat_1

# A piece of titanium metal with a mass of 20.7 g is heated in boiling water to 99.5 °C and then dropped into a coffee-cup calorimeter containing 75.0 g of water at 20.6 °C. When thermal equilibrium is reached, the final temperature is 23.2 °C. Calculate the specific heat capacity of titanium. (The specific heat capacity of liquid water is 4.184 J/g ⋅ K.)


mass_1 = 20.7
temp_1 = 99.5
mass_2 = 75.0
temp_2 = 20.6
specific_heat_2 = 4.184
final_temp = 23.2


energy_1 = mass_1 * (final_temp - temp_1)
energy_2 = mass_2 * (final_temp - temp_2) * specific_heat_2

specific_heat_1 = energy_2 / energy_1

puts specific_heat_1



# calculate with water

# A student heats 68.74 grams of lead to 97.95 °C and then drops it into a cup containing 78.00 grams of water at 21.43 °C. She measures the final temperature to be 24.00 °C.
# The heat capacity of the calorimeter (sometimes referred to as the calorimeter constant) was determined in a separate experiment to be 1.80 J/°C.
# Assuming that no heat is lost to the surroundings calculate the specific heat of lead.

mass_1 = 68.74
temp_1 = 97.95
mass_2 = 78.00
temp_2 = 21.43
final_temp = 24.00
specific_heat_2 = 4.184
heat_capacity = 1.80

change_in_temp_2 = (final_temp - temp_2)

energy_2 = mass_2 * specific_heat_2 * change_in_temp_2 + heat_capacity * change_in_temp_2
specific_heat_1 = energy_2 / (mass_1 * (final_temp - temp_1))

puts specific_heat_1


# calibrate

# In the laboratory a student heats 94.14 grams of iron to 99.08 °C and then drops it into a cup containing 78.17 grams of water at 24.16 °C.
# She measures the final temperature to be 32.61 °C.
# Using the accepted value for the specific heat of iron (See the References tool), calculate the calorimeter constant.


mass_1 = 94.14 # iron
temp_1 = 99.08
specific_heat_1 = 0.444
mass_2 = 78.17 # water
temp_2 = 24.16
final_temp = 32.61
specific_heat_2 = 4.184
system_temp = temp_2

change_in_temp_1 = final_temp - temp_1
change_in_temp_2 = final_temp - temp_2
change_in_system_temp = change_in_temp_2

energy_1 = mass_1 * change_in_temp_1 * specific_heat_1
energy_2 = mass_2 * change_in_temp_2 * specific_heat_2

system_energy = - (energy_2 + energy_1)
system_specific_heat = system_energy / change_in_system_temp

puts system_specific_heat




# A chunk of magnesium weighing 18.59 grams and originally at 97.51 °C is dropped into an insulated cup containing 82.86 grams of water at 21.17 °C.
# The heat capacity of the calorimeter (sometimes referred to as the calorimeter constant) was determined in a separate experiment to be 1.55 J/°C.
# Using the accepted value for the specific heat of magnesium (See the References tool), calculate the final temperature of the water. Assume that no heat is lost to the surroundings.

magnesium = {
    mass: 18.59,
    temp: 97.51,
    specific_heat: 1.017,
}
water = {
    mass: 82.86,
    temp: 21.17,
    specific_heat: 4.184,
}
cup = {
    heat_capacity: 1.55,
}
final_temp = :unknown
