require 'pry'
require 'colorize'
require 'json'

class BookCli

    def run
        greeting

        puts "If this is your first time here, please type 'create' (without quotes) to create a NEW folder for your reading list.".yellow
        puts "\n"
        puts "Otherwise, type 'view' (without quotes) to view your reading list(s)"
        puts "\n"
        puts "PLEASE REMEMBER ALL COMMANDS ARE CASE SENSITIVE".red
        puts "\n"
        puts "You may type 'exit' anytime to exit the program."
        user_welcome_input = gets.chomp

        case user_welcome_input
        when "view"
            fetch_reading_lists
        when "exit"
            exit
        else
            edge_case_restart_app
        end
    end

    def greeting
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

    def fetch_reading_lists
        if Dir.exists?("reading_lists")
            view_all_reading_lists
        else
            Dir.mkdir_p "reading_lists"
            view_all_reading_lists
        end
    end

    def view_all_reading_lists
        reading_list = Dir.entries("reading_lists")
        if reading_list.length < 3
            puts  "You currently have no reading lists. Type 'create' to create one.\n"
        end
        if reading_list.length > 2
            puts "Here's your reading list:"
            reading_list.each_with_index do |list, index|
                if list.length > 2 && File.extname(list) == ".json"
                    # binding.pry
                    puts "#{index - 1}: #{JSON.load(File.read("./reading_lists/#{list}"))["name"]}"
                end
            end
            puts "Type 'create' to create new one."
            puts "\n"
            puts "Or type the number of the reading list you want to view."
        end

        user_reading_list_options = gets.chomp

        if user_reading_list_options.to_i.is_a? Integer
            get_reading_list(user_reading_list_options)
        elsif user_reading_list_options == "create"
            create_a_reading_list
        elsif user_reading_list_options == "exit"
            exit
        else
            edge_case_restart_app
        end

        # case user_reading_list_options
        # when "create"
        #     create_a_reading_list
        # when "exit"
        #     exit
        # else
        #     edge_case_restart_app
        # end
    end

    def create_a_reading_list
        puts "Give your reading list a name."
        new_list_name = gets.chomp

        file_name = new_list_name.downcase.split(" ").join("_") + ".json"
        new_list = File.new("./reading_lists/#{file_name}", "w+")

        puts "\n"
        puts "Provide a description for your reading list OR press 'Enter' to leave it blank"
        new_list_desc = gets.chomp

        file_data = {
            name: new_list_name,
            description: new_list_desc,
            books: []
        }
        
        File.open("./reading_lists/#{file_name}", "w") do |file|
            file.write(JSON.pretty_generate(file_data))
        end
    end

    def get_reading_list(reading_list_index)
        reading_list = Dir.entries("reading_lists")
        binding.pry
        loaded_file = JSON.load(File.read("./reading_lists/#{reading_list[reading_list_index.to_i + 1]}"))
        
        puts "Importing your reading list"
        puts ""
    end

    def edge_case_restart_app
        puts "Sorry we didn't understand the command you entered. Please try again!".red
        puts "\n"
        puts "Would you like to restart the app? (Y/N)"
        restart = gets.chomp
        if restart == "Y" || restart == "y"
            puts "Restarting the app now ..."
            run
        else
            puts "No problem, come back anytime."
        end
    end

end

book_cli = BookCli.new
book_cli.run