#!/usr/bin/env ruby

require 'io/console'
require 'yaml'

#Hacky Ruby stuff/Ruby quine cheats
def read_script
  DATA.readlines.collect { |line|
    line = line.chomp.delete("\t").delete("\n")
    line = "-e '#{line}' "
  }.join
end

#Shell out to weird stuff to lock
def unlock
    #@locked = false
    `caffeinate -u -t 2`
    `osascript -e 'delay 1' -e 'tell application "System Events"' -e 'keystroke return' -e 'keystroke "#{ENV["MYPASS"]}"' -e 'delay 1' -e 'keystroke return' -e 'end tell'`
end

def lock
  #@locked = true
  `pmset displaysleepnow`
end

def toggle_lock()
  return Proc.new{
    @locked = !@locked
  }.call
end

#Bluetewth stuff
def try_connect
  `osascript #{@script}`
end

def is_nearby?
  btdata = IO.popen("system_profiler SPBluetoothDataType").readlines.join("\n")
  bt = YAML.load(btdata)
  return bt["Bluetooth"]["Devices (Paired, Configured, etc.)"]["Pixel 3a"]["Connected"]
end



if not ENV["MYPASS"]
  puts "No environmental var MYPASS found."
  puts "Enter your password used to unlock your computer(this will be removed on progrm exit): "
  ENV["MYPASS"] = STDIN.noecho(&:gets).chomp
end

#Invocation bit
begin
  @script = get_script
  @locked = false
  while true
    try_connect() and sleep(2)
    if is_nearby? and @locked
      puts "✅ �"
      unlock() and toggle_lock()
    elsif not is_nearby?
      if not @locked
        puts "❌ �"
        lock() and toggle_lock()
      end
    else
      puts "�"
    end
  end
rescue Interrupt => e
  puts e and exit
end

at_exit do
  ENV.delete("MYPASS")
end

__END__
activate application "SystemUIServer"
tell application "System Events"
	tell process "SystemUIServer"
		set btMenu to (menu bar item 1 of menu bar 1 where description is "bluetooth")
		tell btMenu
			click
			tell (menu item "Pixel 3a" of menu 1)
				click
				if exists menu item "Connect to Network" of menu 1 then
					click menu item "Connect to Network" of menu 1
				else
					click btMenu
				end if
			end tell
		end tell
	end tell
end tell
quit application "SystemEvents"
quit application "SystemUIServer"
