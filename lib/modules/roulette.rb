# -*- encoding : utf-8 -*-
module Linael
  class Modules::Roulette < ModuleIRC

    Name="roulette"	

    Help=["Auto kick people who lose on roulette"]

    def kick_on_lose privMsg
      if privMsg.message =~ /^(\S*):\schamber.*6.*BANG/ and privMsg.who == "marvin"
        p privMsg.message
        p "#{privMsg.place} and #{$~[1]}"
        kick_channel(privMsg.place,$~[1],"YOU LOSE!")	
      end
    end

    def startMod()
      add_module :msg => [:kick_on_lose]
    end

  end
end
