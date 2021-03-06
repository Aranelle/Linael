# -*- encoding : utf-8 -*-
module Linael
  class Modules::Dice < ModuleIRC

    Name="dice"	

    def dice privMsg
      if (Options.dice? privMsg.message)
        options	= Options.new privMsg
        if (!options.to_much?)
          dices=[]
          options.number.to_i.times { dices << DiceLauncher.new(options.dice.to_i)}
          sum = dices.inject(0) {|sum,d| sum + d.value}
          answer(privMsg,"#{privMsg.who}: Dices = [#{dices.join(" - ")}]")
        else
          sum = 0
          options.number.to_i.times {sum += DiceLauncher.new(options.dice.to_i).value}
        end
        answer(privMsg,"#{privMsg.who}: Sum = #{sum}")
      end
    end

    def startMod()
      add_module :msg => [:dice]
    end
  
    class Options < ModulesOptions
      
      number = "[0-9]{1,3}"

      generate_to_catch :dice => Regexp.new("^"+number+"d"+number)

      def to_much?
        number.to_i > 20
      end
    

      generate_value :number => Regexp.new("("+number+")"+"d"+number),
                     :dice   => Regexp.new(number + "d" + "("+number+")")

    end

    class DiceLauncher

      attr_reader :value

      def initialize dice
        @value = rand(dice) + 1
      end

      def to_s
        @value.to_s
      end

    end
  end

end
