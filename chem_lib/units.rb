# require 'atk_toolbox'

require 'mathn' # fixes division

# 
# general rules
# 
    # unit + unit = unit
    # unit - unit = unit
    # unit + number = unit
    # unit - number = unit
    # unit * number = unit
    # unit / number = unit
    # unit * unit = unit^2
    # unit / unit = unit / unit

# def convert(unit_1, unit_2)
#     # check for no conversion needed
#     if unit_1 == unit_2
#         return ->(amount) {amount}
#     end
#     possible_methods = []
#     loop do
#         previously_possible_amount = possible_resulting_units.size
#         possible_resulting_units = possible_methods.map {|each| each[-1]}
#         # check if conversion can be made
#         if possible_resulting_units.include?( unit_2 )
#             break
#         end
#         # check if no progress is being made
#         if possible_resulting_units.size == previously_possible_amount
#             raise <<-HEREDOC.remove_indent
                
                
#                 Cant find viable path between #{unit_1} and #{unit_2}
#             HEREDOC
#         end
#         # check all the possibilies
#         for each_chain in possible_methods
#             new_possibilies = UNITS[each_chain[-1]][convertable_to] - possible_resulting_units
#             for each_possibility in new_possibilies
#                 possible_methods.push([ *each_chain, each_possibility  ])
#             end
#             # set-join all possibilies
#             possible_resulting_units = possible_resulting_units | new_possibilies
#         end
#     end
#     # FIXME: look through the possible_methods, find the viable path, then perform the conversions
# end

# helper
class Symbol
    def base_unit()
        return self
    end
    
    def power()
        return 1
    end
end
class Numeric
    def number
        return self
    end
    def to_percent
        return "#{self * 100}%"
    end
    def to_scientific
        "%E" % self
    end
    def percent
        return self / 100
    end
end
class NumericUnits < Numeric
    attr_accessor :units, :number
    
    class PoweredUnit
        attr_accessor :base_unit, :power
        def initialize(base_unit, power)
            @base_unit = base_unit
            @power = power
        end
        
        def to_s
            return "#{@base_unit}^#{@power}"
        end
        def ==(other)
            return self.to_s == other.to_s
        end
    end
    
    class PerUnit
        attr_accessor :top, :bottom
        def initialize(top_unit, bottom_unit)
            @top = top_unit
            @bottom = bottom_unit
        end
        def to_s()
            "#{@top}/#{@bottom}"
        end
        def base_unit()
            return self.to_s.to_sym
        end
        def power
            return 1
        end
        def ==(other)
            return self.to_s == other.to_s
        end
    end
    
    def new_number(number, unit)
        if unit == nil
            return number
        elsif unit.is_a?(PoweredUnit)
            if unit.power == 0
                return number
            elsif unit.power == 1
                return new_number(number, unit.base_unit)
            end
        elsif unit.is_a?(PerUnit)
            if unit.top == unit.bottom
                return number
            elsif unit.bottom.is_a?(PerUnit) && unit.top == unit.bottom.bottom
                return new_number(number, unit.bottom.top)
            elsif unit.top.is_a?(PerUnit) && unit.top.top == unit.bottom
                return new_number(number, unit.top.bottom)
            elsif unit.bottom == nil
                return new_number(number, unit.top)
            end
        end
        return NumericUnits.new(number, unit)
    end
    
    def initialize(number, units)
        @number = number
        @units = units
    end
    
    def to_baseline
    end

    def to_s
        "#{@number}#{@units}"
    end
    
    def inspect
        "#{@number}.#{@units}"
    end

    def coerce(other)
        [self.class.new(other,nil), self]
    end

    def <=>(other)
        if other.is_a?(NumericUnits)
            if other.units == self.units
                return  @number <=> other.number
            else
                raise "\n\nI'm not yet sure how to compare two different units"
            end
        end
        @number <=> other
    end

    def +(other)
        if self.units != nil && other.is_a?(NumericUnits) && other.units != self.units
            raise "\n\nI'm not yet sure how to add two different units"
        else
            return self.new_number(@number + other.number, self.units||other.units)
        end
    end

    def -(other)
        if self.units != nil && other.is_a?(NumericUnits) && other.units != self.units
            raise "\n\nI'm not yet sure how to subtract two different units"
        else
            return self.new_number(@number - other.number, self.units||other.units)
        end
    end

    def *(other)
        resulting_number = @number * other.number
        if self.units != nil && other.is_a?(NumericUnits)
            if other.units.base_unit == self.units.base_unit
                resulting_power = self.units.power + other.units.power
                resulting_unit = PoweredUnit.new(self.units.base_unit, resulting_power)
                return self.new_number(resulting_number, resulting_unit)
            elsif other.units.is_a?(PerUnit)
                # FIXME: make this recusive, right now its only checking one deep, but the resulting bottom value could be a PerUnit
                # FIXME: this doesn't work out if self.units is a PerUnit
                # cancel out top and bottom
                if self.units == other.units.bottom.base_unit
                    new_power = other.units.power - self.units.power
                    if new_power == 0
                        return self.new_number(resulting_number, other.units.top)
                    else
                        return self.new_number(resulting_number, PerUnit.new(other.units.top, PoweredUnit.new(self.units, new_power)))
                    end
                end
            end
        else
            return self.new_number(resulting_number, self.units||other.units)
        end
        raise "\n\nI'm not yet sure how to multiply two different units:\nself:#{self}\nother:#{other}"
    end

    def /(other)
        resulting_number = @number / (0.0+other.number)
        if self.units != nil && other.is_a?(NumericUnits)
            if other.units.base_unit == self.units.base_unit
                resulting_power = self.units.power - other.units.power
                if resulting_power == 0
                    return resulting_number
                else
                    resulting_unit = PoweredUnit.new(self.units.base_unit, resulting_power)
                    return self.new_number(resulting_number, resulting_unit)
                end
            else
                return self.new_number(resulting_number, PerUnit.new(self.units, other.units))
            end
        else
            units = self.units||other.units
            if units.is_a?(PerUnit)
                units = PerUnit.new(units.bottom, units.top)
            end
            return self.new_number(resulting_number, units)
        end
    end
end

UNITS = Class.new do
    def initialize()
        @data = {}
    end
    
    def []=(name, unit_data)
        @data[name] = unit_data
        # add the abbreviation
        if unit_data[:abbreviation] && unit_data[:abbreviation] =~ /^[a-zA-Z]+$/
            eval <<-HEREDOC
                class Numeric
                    def #{unit_data[:abbreviation]}
                        NumericUnits.new(self, :#{name})
                    end
                    def #{name}
                        NumericUnits.new(self, :#{name})
                    end
                end
            HEREDOC
        end
    end
    def [](name)
        return @data[name]
    end
end.new




UNITS[:centimeters] = {
    abbreviation: :cm,
    convertable_to: {
        nanometers: ->(cm){cm*10000000},
        milimeters: ->(cm){cm*10},
        meters: ->(cm){cm*0.01},
        inches: ->(cm){cm*0.3937007992},
        feet: ->(cm){cm*0.0328084},
        yards: ->(cm){cm*0.01093613331113},
    }
}

UNITS[:meters] = {
    abbreviation: :m,
    convertable_to: {
        centimeters: ->(meters){meters/100},
    }
}

UNITS[:nanometers] = {
    abbreviation: :nm,
    convertable_to: {
        centimeters: ->(nanometers){nanometers/10**9},
    }
}

UNITS[:grams] = {
    abbreviation: :g,
    convertable_to: {
        atomic_mass_units: ->(grams){grams*6.022141e+23},
        miligrams: ->(grams){grams*1000},
        kilograms: ->(grams){grams*0.001},
        metric_tons: ->(grams){grams*0.000001},
        ounces: ->(grams){grams*0.03527396},
        pounds: ->(grams){grams*0.002204623},
        tons: ->(grams){grams*0.00000110231149997},
    }
}

UNITS[:atomic_mass_units] = {
    abbreviation: :amu,
    convertable_to: {
        grams: ->(amu){amu/6.022141e+23},
    }
}

UNITS[:moles] = {
    abbreviation: :mol,
    convertable_to: {
        atoms: ->(atoms){atoms*6.022141e+23},
    }
}

# TODO: add temperature
# TODO: add liters



