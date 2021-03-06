# -*- encoding : utf-8 -*-

module Linael

  module IRC

    def self.send_msg(msg)
      $linael_irc_socket.puts "#{msg}\n"
    end

    def self.connect(server,port,nick)
      $linael_irc_socket = TCPSocket.open(server, port)
      send_msg "USER #{nick} 0 * :Linael"
      send_msg "NICK #{nick}"
    end

    def self.main_loop(msg_handler)
      while line = get_msg
        p line
        msg_handler.handle_msg(line)
      end
    end

    def self.get_msg()
      return $linael_irc_socket.gets
    end

  end

  module Action

    include IRC

    def method_missing(name, *args, &block)
      if name =~ /(.*)_channel/
        self.class.send("define_method",name) do |arg|
          msg = "#{$1.upcase} "
          msg += "#{arg[:dest]} " unless arg[:dest].nil?
          msg += "#{arg[:who]} " unless arg[:who].nil?
          msg += "#{arg[:args]} " unless arg[:args].nil?
          msg += ":#{arg[:msg]} " unless arg[:msg].nil?
          IRC::send_msg msg
        end      
        return self.send name,args[0]
      end
      super
    end

    def talk(dest,msg)
      privmsg_channel({dest: dest, msg: msg})
    end

    def answer(privMsg,ans)
      if(privMsg.private_message?)
        talk(privMsg.who,ans)
      else
        talk(privMsg.place,ans)
      end
    end

  end
end
