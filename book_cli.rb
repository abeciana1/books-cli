require 'pry'
require 'colorize'

class BookCli

    def self.run
        BookCli.greeting

        puts "If this is your first time here, please type 'create' (without quotes) to create a NEW folder for your reading list.".yellow
        puts "\n"
        puts "Otherwise, type 'view' (without quotes) to view your reading list(s)"
        puts "\n"
        puts "PLEASE REMEMBER ALL COMMANDS ARE CASE SENSITIVE".red
        puts "\n"
        puts "You may type 'exit' anytime to exit the program. For additional help, please type 'help.'"
        user_welcome_input = gets.chomp

        case user_welcome_input
        when "help"
            BookCli.help_menu
        else
            puts "Sorry we didn't understand the command you entered. Please try again!".red
            puts "\n"
            puts "Would you like to restart the app? (Y/N)"
            restart = gets.chomp
            if restart == "Y" || restart == "y"
                puts "Restarting the app now ..."
                CLI.run
            else
                puts "No problem, come back anytime."
            end
        end
    end

    def self.greeting
        puts " ____ ____ ____ ____ ____ _________ ____ ____ ____ "
        puts "||B |||o |||o |||k |||s |||       |||C |||L |||I ||"
        puts "||__|||__|||__|||__|||__|||_______|||__|||__|||__||"
        puts "|/__\\|/__\\|/__\\|/__\\|/__\\|/_______\\|/__\\|/__\\|/__\\|"
        puts "\n"
        puts "\n"
        puts "         ,..........   ..........,"
        puts "     ,..,'          '.'          ',..,"
        puts "    ,' ,'            :            ', ',"
        puts "   ,' ,'             :             ', ',"
        puts "  ,' ,'              :              ', ',"
        puts " ,' ,'............., : ,.............', ',"
        puts ",'  '............   '.'   ............'  ',"
        puts " '''''''''''''''''';''';''''''''''''''''''"
        puts "                    '''"
    end

    def self.help_menu
        puts "help"
    end

end

BookCli.run