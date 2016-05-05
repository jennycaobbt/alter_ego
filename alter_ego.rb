require "pry"
require "colorize" #will this run if other person doesn't have this?


def start
quits = false

until quits == true
  #first menu
  puts "*Possible commands*"
  puts "> Enter my Identifier"
  puts "> What are you?"
  puts "> I'm new"
  puts "> Exit"

  #Ask user to input one of the commands
  answer = ask_user

  #can I get the include command to work here?
  case
  when answer == "enter my identifier"
    identify
  when answer == "what are you"
    about_me(0)
  when answer == "im new"
    new_account
  when answer == "exit"
    puts "Bye!".green
    quits = true
  when answer == "let me test something"
    test_area
  else
    no_understand
  end
end

end

def about_me(header)
  if header == 0
    puts "My name is #{$bot_name}! :)".green
    puts "I'm a bot built by Jenny to learn Ruby. ^_^".green
    puts "I won't be very smart at the beginning because Jenny sucks at Ruby right now... :(".green
    puts "But hopefully I'll be able to do more later :)".green
  else

  end

  puts "*Possible commands*"
  puts "> What can you do right now?"
  puts "> Tell me a bit more about you!"
  puts "> I'm new"
  puts "> Let me enter my identifier"

  answer = ask_user

  case
  when answer == "what can you do right now"
    list_features
    about_me(1)
  when answer == "tell me a bit more about you"
    origin_story
    about_me(1)
  when answer == "im new"
    new_account
  when answer == "let me enter my identifier"
    identify
  else
    no_understand
    about_me(1) #will this have looping issues?
  end

end

def list_features
  puts "I can remember who you are and record basic information about you.".green
  puts "When you interact with me, I will ask you certain questions, and try to build a profile for you!".green
  puts "I will also remember the dates you told me certain things, so you can ask me about the timing of things too".green
  puts "Since I don't have eyes, I remember you using an identifier, which is like your password! :)".green
  puts "If I don't know you yet, I will create a new identifier for you. Just say 'I'm new'".green
  puts "If you already have an identifier, just say 'let me enter my identifier'".green
  puts "Remember... Jenny's pretty new at Ruby so there's no security to this...".green
  puts "I'm depending on you to not mess with me too much! Why would you do that to a poor defenseless bot? :(".green
end

def origin_story
  puts "I'm named after the AI 'Alter Ego' made by Chihiro Fujisaki in the game Danga Ronpa 1 :)".green
  puts "Of course... since Jenny is not Chihiro... I am not really an AI...".green
  puts "Nor can I decrypt super sensitive files or infiltrate networks...".green
  puts ".... and there's also a possibility that Jenny will rename me to something else once she's less obsessed with the game -__-'".green
  puts "That's it! This origin story of me, #{$bot_name}! ^_^".green

end

def new_account
  #want to make it so that the moment people type quit, it ends this method.
  puts "Welcome! I'm #{$bot_name}, nice to meet you!".green

  name_status = 0

  until name_status == 1
    puts "What's your first name?".green
    first_name = gets.strip.downcase.capitalize
    puts "You said... #{first_name}".yellow
    sleep(0.7)
    puts "And your last name?".green
    last_name = gets.strip.downcase.capitalize
    puts "You said... #{last_name}".yellow
    sleep(0.7)

    name_status = confirm("So you're #{first_name} #{last_name}?", "Ok, let's re-enter your name!")
  end

  puts "Ok, your name is #{first_name} #{last_name}!".green



  ident_status = 0
  until ident_status == 1
    puts "Now, type an identifier for yourself! This is the code that I will use to know it's you.".green
    code = gets.gsub(/\W+/, '') #how does this work??
    puts "I removed all spaces and weird symbols for simplicity :)".green

    ident_status = confirm("'#{code}' is your identifier. Is this ok?", "Ok, Let's re-enter your identifier")
  end
  puts "Ok, your identifier is '#{code}'!".green


  setup_string = "identifier:#{code},first_name:#{first_name},last_name:#{last_name},register_time:#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}"
  fh = File.new("users/#{code}", "w")
  fh.puts setup_string
  puts "Thanks #{first_name}! I remembered you with the identifier '#{code}'.".green
  puts "Next time enter your identifier for me to remember you! :)".green
  puts "I wrote the following to a file so I can remember you:".green
  puts setup_string.red
  fh.close
end



def identify
  try_identify = 1
    until try_identify == 0
      puts "Enter your identifier".green
      code = gets.gsub(/\W+/, '')
      puts "You entered... #{code}".yellow
      sleep (1)
      if File.readable?("users/#{code}")
        user_info = File.read("users/#{code}").strip



        #puts user_info.red
        user_info_hash = convert_into_hash(user_info)
        sleep (1)
#to save all the information for now, will convert to an object later!
        first_name = user_info_hash["first_name"]
        last_name = user_info_hash["last_name"]
        identifier = user_info_hash["identifier"]
        register_time = user_info_hash["register_time"]
#--------Recording info------
        puts "Hi #{first_name}! How are you?".green
        puts "This is what I know about you:".red
        puts "Your first name is #{first_name}".green
        puts "Your last name is #{last_name}".green
        puts "You first introduced yourself to me on #{register_time} :)".green
        puts "... and your identifier is obviously #{identifier}".green
        puts "I have no other interesting features right now, but thanks for visiting! :D".green
        puts "See you again soon!"

#-------- this will also be moved to another method------
        sleep (1)
        puts "Returning to main menu...".yellow
        sleep (1)
        try_identify = 0
      else
        puts "I don't recognize the identifier '#{code}'".green
        try_identify = confirm("Want to try again?", "Alright, remember if you say 'I'm new', you can create an identifier")

      end
    end

end

def convert_into_hash(user_info)

  info_pairs = user_info.split(",")
  the_hash = {}

  info_pairs.each do |item|
    array_pair = item.split(":")
    the_hash[array_pair[0]] =array_pair[1]
  end
  return the_hash
end

def test_area

  dummy = "identifier:timelord,first_name:Homura,last_name:Akemi,register_time:2016-05-02_00-26-11"
  get_back = convert_into_hash(dummy)
  #binding.pry
  puts get_back.values_at("first_name")
  puts get_back["last_name"]
  puts get_back["identifier"]
  puts get_back["register_time"]


end

def no_understand
  puts "Sorry, I don't understand".green
  puts "I can only understand the possible commands displayed typed relatively accurately, Jenny's not good enough at ruby to teach me to do anything else yet :(".green
  puts "Try again?".green
end

#This return 1 if the user answered yes
def confirm(ask_string, redo_string)

  confirm_status = false
  until confirm_status == true
    puts ask_string.green
    puts "Please put Yes, or No"

    answer = ask_user

    if answer == "yes"
      return 1
      confirm_status = true
    elsif answer == "no"
      puts redo_string.green
      confirm_status = true
      return 0
    else
      no_understand
    end

  end

end


def ask_user
  answer = gets.strip.downcase.gsub(/[^a-z0-9\s]/i, '')
  #figure out how the gsub thing works
  puts "You said... #{answer}".yellow
  sleep(0.7)
  return answer
end

$bot_name = "Alter Ego"
puts "Hi! How are you? :)".green

start
