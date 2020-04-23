require 'atk_toolbox'
require_relative "./chem_lib/elements.rb"


# A bomb calorimeter, or a constant volume calorimeter, is a device often used to determine the heat of combustion of fuels and the energy content of foods.

# In an experiment, a 0.4506 g sample of 1-naphthoic acid (C11H8O2) is burned completely in a bomb calorimeter. The calorimeter is surrounded by 1.232×103 g of water. During the combustion the temperature increases from 23.53 to 25.85 °C. The heat capacity of water is 4.184 J g-1°C-1.
# The heat capacity of the calorimeter was determined in a previous experiment to be 902.7 J/°C.
# Assuming that no energy is lost to the surroundings, calculate the molar heat of combustion of 1-naphthoic acid based on these data.



# calculate the molar heat of combustion
# In an experiment, a 0.4419 g sample of bisphenol A (C15H16O2) is burned completely in a bomb calorimeter. The calorimeter is surrounded by 1.361×103 g of water. During the combustion the temperature increases from 27.04 to 29.44 °C. The heat capacity of water is 4.184 J g-1°C-1.
# The heat capacity of the calorimeter was determined in a previous experiment to be 865.6 J/°C.
# Assuming that no energy is lost to the surroundings, calculate the molar heat of combustion of bisphenol A based on these data.
# C15H16O2(s) + 18O2(g)  8 H2O(l) + 15 CO2(g) + Energy
total_heat = nil

C15H16O2 = {
    mass: 0.4506,
    grams_per_mol: (C*11 + H*8 + O*2).grams_per_mole,
    molar_heat: :unknown,
    heat_per_gram: ->() { (total_heat / C15H16O2[:mass]) /1000 }
} 
water = {
    mass: 1.232*(10**3),
    start_temp: 23.53,
    end_temp: 25.85,
    heat_capacity: 4.184,
    temp_change: ->(){ water[:end_temp] - water[:start_temp] },
    energy_change: ->() { water[:mass] * water[:heat_capacity] * water[:temp_change][] }
}
calorimeter = {
    heat_capacity: 902.7,
    start_temp: water[:start_temp],
    end_temp: water[:end_temp],
    temp_change: ->(){ calorimeter[:end_temp] - calorimeter[:start_temp] },
    energy_change: ->(){ calorimeter[:heat_capacity] * calorimeter[:temp_change][] }
}

total_heat = -(water[:energy_change][] + calorimeter[:energy_change][] )

puts C15H16O2[:heat_per_gram][]  * C15H16O2[:grams_per_mol]