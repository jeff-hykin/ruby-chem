require 'atk_toolbox'

def convert(unit_1, unit_2)
    # check for no conversion needed
    if unit_1 == unit_2
        return ->(amount) {amount}
    end
    possible_methods = []
    loop do
        previously_possible_amount = possible_resulting_units.size
        possible_resulting_units = possible_methods.map {|each| each[-1]}
        # check if conversion can be made
        if possible_resulting_units.include?( unit_2 )
            break
        end
        # check if no progress is being made
        if possible_resulting_units.size == previously_possible_amount
            raise <<-HEREDOC.remove_indent
                
                
                Cant find viable path between #{unit_1} and #{unit_2}
            HEREDOC
        end
        # check all the possibilies
        for each_chain in possible_methods
            new_possibilies = UNITS[each_chain[-1]][convertable_to] - possible_resulting_units
            for each_possibility in new_possibilies
                possible_methods.push([ *each_chain, each_possibility  ])
            end
            # set-join all possibilies
            possible_resulting_units = possible_resulting_units | new_possibilies
        end
    end
    # FIXME: look through the possible_methods, find the viable path, then perform the conversions
end

class NumericUnits < Numeric
    attr_accessor :units, :number
    
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
        if other.is_a?(NumericUnits)
            if other.units == self.units
                return  @number + other.number
            else
                raise "\n\nI'm not yet sure how to add two different units"
            end
        else
            return @number + other
        end
    end

    def -(other)
        if other.is_a?(NumericUnits)
            if other.units == self.units
                return  @number - other.number
            else
                raise "\n\nI'm not yet sure how to subtract two different units"
            end
        else
            return @number - other
        end
    end

    def *(other)
        if other.is_a?(NumericUnits)
            raise "\n\nI'm not yet sure how to multiply two units"
        else
            return @number * other
        end
    end

    def /(other)
        if other.is_a?(NumericUnits)
            raise "\n\nI'm not yet sure how to divide two units"
        else
            return @number / other
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
                        NumericUnits.new(self, :#{unit_data[:abbreviation]})
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

# TODO: add temperature