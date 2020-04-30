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





# # determine the heat capacity of the calorimeter
# # In the laboratory a student burns a 0.750-g sample of adipic acid (C6H10O4) in a bomb calorimeter containing 1150. g of water. The temperature increases from 24.50 °C to 27.00 °C. The heat capacity of water is 4.184 J g-1°C-1.
# # The molar heat of combustion is −2796 kJ per mole of adipic acid.
# # C6H10O4(s) + 13/2 O2(g) 6 CO2(g) + 5 H2O(l) + Energy
# # Calculate the heat capacity of the calorimeter.

# C6H10O4 = {
#     mass: 0.750,
#     molar_heat: -2796,
#     grams_per_mol: (C*6 + H*10 + O*4).grams_per_mole
# } 
# water = {
#     mass: 1150,
#     start_temp: 24.50,
#     end_temp: 27.00,
#     heat_capacity: 4.184,
#     temp_change: ->(){ water[:end_temp] - water[:start_temp] },
#     energy: ->() { water[:mass] * water[:heat_capacity] * water[:temp_change][] }
# }

# # The molar heat of combustion is −2796 kJ per mole of adipic acid.
# # C6H10O4(s) + 13/2 O2(g) 6 CO2(g) + 5 H2O(l) + Energy
# # Calculate the heat capacity of the calorimeter.
# conversion_factor = 1000
# heat_evolved = C6H10O4[:molar_heat] * (1/C6H10O4[:grams_per_mol]) * C6H10O4[:mass] * conversion_factor
# heat_absorbed = - (heat_evolved + water[:energy][] )

# heat_capacity = heat_absorbed / water[:temp_change][]

# puts heat_capacity



# # calculate the molar heat of combustion
# # In an experiment, a 0.4419 g sample of bisphenol A (C15H16O2) is burned completely in a bomb calorimeter. The calorimeter is surrounded by 1.361×103 g of water. During the combustion the temperature increases from 27.04 to 29.44 °C. The heat capacity of water is 4.184 J g-1°C-1.
# # The heat capacity of the calorimeter was determined in a previous experiment to be 865.6 J/°C.
# # Assuming that no energy is lost to the surroundings, calculate the molar heat of combustion of bisphenol A based on these data.
# # C15H16O2(s) + 18O2(g)  8 H2O(l) + 15 CO2(g) + Energy
# total_heat = nil

# C15H16O2 = {
#     mass: 0.4419,
#     grams_per_mol: (C*15 + H*16 + O*2).grams_per_mole,
#     molar_heat: :unknown,
#     heat_per_gram: ->() { (total_heat / C15H16O2[:mass]) /1000 }
# } 
# water = {
#     mass: 1.361*(10**3),
#     start_temp: 27.04,
#     end_temp: 29.44,
#     heat_capacity: 4.184,
#     temp_change: ->(){ water[:end_temp] - water[:start_temp] },
#     energy_change: ->() { water[:mass] * water[:heat_capacity] * water[:temp_change][] }
# }
# calorimeter = {
#     heat_capacity: 865.6,
#     start_temp: water[:start_temp],
#     end_temp: water[:end_temp],
#     temp_change: ->(){ calorimeter[:end_temp] - calorimeter[:start_temp] },
#     energy_change: ->(){ calorimeter[:heat_capacity] * calorimeter[:temp_change][] }
# }

# total_heat = -(water[:energy_change][] + calorimeter[:energy_change][] )

# puts C15H16O2[:heat_per_gram][]  * C15H16O2[:grams_per_mol]

def vaporization(which_molecule: nil, grams_of_liquid: nil, moles_of_liquid: nil, heat_vaporization: nil)
    # if "__ are-needed?" then answer is positive
    if moles_of_liquid == nil
        moles_of_liquid =  grams_of_liquid / which_molecule.grams_per_mole
    end
    # probably used in more complicated situation:
    #     boiling_point 
    #     specific_heat_of_liquid
    #     pressure = 1 atm
    
    return heat_vaporization * moles_of_liquid
    # example: vaporization(which_molecule: C*5+H*12, grams_of_liquid: 33.8, heat_vaporization: 25.8 )
end

def melt(which_molecule: nil, grams_of_solid: nil, moles_of_solid: nil, heat_fusion: nil)
    if moles_of_solid == nil
        moles_of_solid =  grams_of_solid / which_molecule.grams_per_mole
    end
    
    return heat_fusion * moles_of_solid
end

# puts melt(which_molecule: Pb, grams_of_solid: 45.5, heat_fusion: 4.77)


def change_in_entropy_of_surroundings(reactants:[], products:[], moles_of_reactant: nil)
    reactants.map{|each| each.quantity }
    change standard_enthalpies_of_products.sum - standard_enthalpies_of_reactants.sum
end

c2h6 = -84.7
co2 = -393.5
h2o_gas = -241.8
h2o2 = -187.8
no2 = 33.2
hcl_gas = -92.30
icl = 17.8
i2 = 62.4
nh4cl= -299.7
nh3_gas = -46.1
hcl_aqueous = -167.2
co_gas = -110.5
h2 = 0
fe3o4 = -1118.4
fe2o3 = -824.2

# moles = (10.1.grams / (Mg).grams_per_mole)
puts "(Mg).grams_per_mole is: #{(Mg+O).grams_per_mole} "
# puts moles * 41.2


presh = 0.01468417
# q_rxn = (presh**1 )/(1**1 * 1**1)
g_delta = (- ([68.2*1 + -228.6].sum)) + [-168.5  ].sum
puts "g_delta is: #{g_delta} "
answer = 2.7182818285 ** (-(g_delta*1000) / (8.314*298.15))
puts answer


# puts (-8.314 * 298 * Math.log(1.84*10**-5))/1000 * moles
puts (-8.314 * 298 * Math.log(1.32*10**25))/1000 * 2.43
puts "(-8.314 * 298 * Math.log(1.32*10**25))/1000 is: #{(-8.314 * 298 * Math.log(1.32*10**25))/1000} "