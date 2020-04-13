require_relative "./units.rb"

# BrINClHOF  # diatomic molecules

Avogadro = 6.02214076*10**23

def mol2atoms(mols)
    return mols * Avogadro
end

class Molecule
    attr_accessor :quantity
    
    def initialize(info_hash)
        @quantity = 1
        @charge = nil
        @info_hash = info_hash
    end
    
    def +(other)
        return Compound.new(self, other)
    end
    
    def *(other)
        if other.is_a?(Numeric)
            elem = self.class.new(@info_hash)
            elem.quantity = other
            return elem
        end
    end
    
    def ^(other)
        if other.is_a?(Numeric)
            elem = self.class.new(@info_hash)
            elem.charge = other
            return elem
        else
            raise <<-HEREDOC.remove_indent
                
                
                not implemented: #{self.class.inspect}^ else
            HEREDOC
        end
    end
    
    def valence_electrons()
        if @sub_elements.is_a?(Array)
            return (@sub_elements.map(&:valence_electrons).sum) * @quantity
        end
    end
    
    def weight()
        if @sub_elements.is_a?(Array)
            return (@sub_elements.map(&:weight).sum) * @quantity
        end
    end
    alias grams_per_mole weight
    
    def moles_per_gram()
        1/self.weight
    end
    
    def dup
        return self.class.new(@info_hash)
    end
    
    def bond_type()
        if not @sub_elements.is_a?(Array)
            raise <<-HEREDOC.remove_indent
                
                
                Asking for a bond_type on a single element
            HEREDOC
        end
        
        first_element = @sub_elements[0].info_hash["electronegativity"] 
        second_element = @sub_elements[1].info_hash["electronegativity"]
        difference = (first_element - second_element).abs
        if difference <= 0.4
            return :non_polar_covalent
        elsif difference <= 1.9
            return :polar_covalent
        else
            return :ionic
        end
    end
end


class Compound < Molecule
    def initialize(*molecules)
        molecule_1, molecule_2, *others = molecules
        @quantity = 1
        @charge = nil
        @sub_elements = []
        # TODO: always put the metal first
        if molecule_1.quantity == 1
            @sub_elements += molecule_1.sub_elements
        else
            @sub_elements.push(molecule_1)
        end
        if molecule_2.quantity == 1
            @sub_elements += molecule_2.sub_elements
        else
            @sub_elements.push(molecule_2)
        end
        @sub_elements += others
    end
    
    def *(other)
        if other.is_a?(Numeric)
            elem = self.class.new(*@sub_elements)
            elem.quantity = other
            return elem
        end
    end
    
    def to_s()
        "("+@sub_elements.map(&:to_s).join("")+")#{@quantity if @quantity > 2 }" 
    end
    
    def sub_elements
        @sub_elements
    end
    
    def weight()
        if @sub_elements.is_a?(Array)
            return (@sub_elements.map(&:weight).sum) * @quantity
        end
    end
    
    def imperical()
        divisor = @sub_elements.map{|each|each.quantity}.reduce(:lcm)
        @alternaitve_elements
    end
    # ionic or covalent
    # emperical form
    # molecular form
    # name
end

class Element < Molecule
    attr_accessor :quantity, :charge, :info_hash
    
    # TODO:
    #   ion
    #   isotope
    #   oxidation states
    
    def initialize(info_hash)
        @info_hash = info_hash
        @quantity = 1
        @charge = nil
        @symbol = info_hash["symbol"]
        
        for each_key, each_value in info_hash
            case each_key
            when "weight"
                eval(<<-HEREDOC)
                    def #{each_key}
                        return @info_hash[#{each_key.inspect}].amu
                    end
                HEREDOC
            when "classification"
                eval(<<-HEREDOC)
                    def #{each_key}
                        return @info_hash[#{each_key.inspect}].to_sym
                    end
                HEREDOC
            else
                eval(<<-HEREDOC)
                    def #{each_key}
                        return @info_hash[#{each_key.inspect}]
                    end
                HEREDOC
            end
        end
    end
    
    def is_a_metal?()
        ['alkaili_metal', 'alkaline_earth_metal','post_transition_metal', 'transition_metal'].include?(self.classification)
    end
    
    def is_a_non_metal?()
        self.classification == 'non_metal'
    end
    
    def sub_elements
        return [self]
    end
    
    def weight()
        return (@info_hash["mass"] * @quantity).grams/1.mol
    end
    alias grams_per_mole weight
    
    def valence_electrons()
        output = 0
        # helium is an exception
        if @symbol == "He"
            output = 2
        elsif group_number < 3
            output = group_number
        elsif group_number > 12
            output = group_number - 10
        # bunch of edgecases for transition metals so just look it up
        else
            if not @info_hash["valence_shells"]
                raise "\n\nTried to get electron_configuration for #{self} but there wasn't one in the database"
            end
            # add up all the electrons for each of the valence shells
            electrons_per_shell = @info_hash["valence_shells"].map do |each|
                each.match(/\d+\z/)[0].to_i
            end
            output = electrons_per_shell.sum
        end
        return output * @quantity
    end
    
    def to_s()
        return "#{@symbol}#{@quantity if @quantity >= 2 }"
    end
end

# 
# instantiate all elements
# 
element_yaml = YAML.load_file( __dir__/"elements.yaml")
for each_symbol, each_data in element_yaml.to_h
    each_data["symbol"] = each_symbol
    eval("#{each_symbol} = Element.new(each_data)")
end



# 
# charges 
# 
    # +1
    # ammonium NH4

    # -1
    # acetate : C2H3O2
    # bicarbonate (or hydrogen carbonate) : HCO3
    # bisulfate (or hydrogen sulfate) : HSO4
    # hypochlorite : ClO
    # chlorate : ClO3
    # chlorite : ClO2
    # cyanate : OCN
    # cyanide : CN
    # dihydrogen phosphate : H2PO4
    # hydroxide : OH
    # nitrate : NO3
    # nitrite : NO2
    # perchlorate : ClO4
    # permanganate : MnO4
    # thiocyanate : SCN

    # -2
    # carbonate : CO3
    # chromate : CrO4
    # dichromate : Cr2O7
    # hydrogen phosphate : HPO4
    # peroxide : O2
    # sulfate : SO4
    # sulfite : SO3
    # thiosulfate : S2O3

    # -3
    # borate : BO3
    # phosphate : PO4

