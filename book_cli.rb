require 'pry'
require 'colorize'
require 'json'
require 'httparty'

class BookCli

    def initialize
        @selected_list = ""
    end

    def run
        greeting

        puts "If this is your first time here, please type 'create' (without quotes) to create a NEW folder for your reading list.".yellow
        puts "\n"
        puts "Otherwise, type 'view' (without quotes) to view your reading list(s) OR type 'search' to search for books."
        puts "\n"
        puts "PLEASE REMEMBER ALL COMMANDS ARE CASE SENSITIVE".red
        puts "\n"
        puts "You may type 'exit' anytime to exit the program."
        user_welcome_input = gets.chomp

        case user_welcome_input
        when "create"
            fetch_reading_lists
        when "view"
            fetch_reading_lists
        when "search"
            get_books_search
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
            Dir.mkdir "reading_lists"
            view_all_reading_lists
        end
    end

    def view_all_reading_lists
        reading_list = Dir.entries("reading_lists")
        if reading_list.length < 3
            puts  "You currently have no reading lists. Type 'create' to create one.\n"
            user_reading_list_options = gets.chomp

            case user_reading_list_options
            when "create"
                create_a_reading_list
            when "exit"
                exit
            else
                edge_case_restart_app
            end
        end
        if reading_list.length > 2
            puts "Here's your reading list:"
            valid_reading_list = reading_list.each_with_index do |list, index|
                if list.length > 2 && File.extname(list) == ".json"
                    puts "#{index - 1}: #{JSON.load(File.read("./reading_lists/#{list}"))["name"]}"
                end
            end
            puts "Type the number of the reading list you want to view."
            user_reading_list_select =  gets.chomp

            if user_reading_list_select.to_i.is_a?(Integer) && user_reading_list_select.to_i < valid_reading_list.length - 2 && user_reading_list_select.to_i > 0
                get_reading_list(user_reading_list_select)
            else
                edge_case_restart_app
            end
        end
    end

    def create_a_reading_list
        puts "Give your reading list a name."
        new_list_name = gets.chomp
        
        file_name = new_list_name.downcase.split(" ").join("_") + ".json"
        new_list = File.new("./reading_lists/#{file_name}", "w+")

        file_data = {
            name: new_list_name,
            books: []
        }
        
        File.open("./reading_lists/#{file_name}", "w") do |file|
            file.write(JSON.pretty_generate(file_data))
        end
    end

    def get_reading_list(reading_list_index)
        reading_list = Dir.entries("reading_lists")
        loaded_file = JSON.load(File.read("./reading_lists/#{reading_list[reading_list_index.to_i + 1]}"))

        @selected_list = "./reading_lists/#{reading_list[reading_list_index.to_i + 1]}"
        
        puts "Importing your reading list"
        puts "..."
        puts "Reading List: #{loaded_file["name"]}"
        puts "Number of books: #{loaded_file["books"].length}"
        puts "\n"
        puts "\n"
        puts "Your Books:"
        puts "\n"

        if loaded_file["books"].length < 1
            puts "No books in your list currently. Type the word 'search' to add books to your list."
        else
            loaded_file["books"].each_with_index do |book, index|
                book_info = book["volumeInfo"]
                puts "======"
                puts "Book ##{index + 1}"
                puts "Title: #{book_info["title"]}"
                puts "Description: #{book_info["description"]}"
                puts "Author: #{book_info["authors"][0]}"
                puts "Publisher: #{book_info["publisher"]}"
                puts "======"
            end
        end

        puts "Type the word 'back' to view all of your reading lists."
        puts "Type the word 'delete' to delete this list."
        puts "Type the word 'update' to update this list."
        user_reading_list_options = gets.chomp

        case user_reading_list_options
        when "back"
            view_all_reading_lists
        when "search"
            get_books_search
        when "delete"
            delete_reading_list("./reading_lists/#{reading_list[reading_list_index.to_i + 1]}")
        when "update"
            update_reading_list("./reading_lists/#{reading_list[reading_list_index.to_i + 1]}")
        else
            edge_case_restart_app
        end
    end

    def get_books_search
        puts "Type your query here:"
        user_search_term = gets.chomp

        data = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{user_search_term}")
        data["items"].slice(0,5).each_with_index do |book, index|
            book_info = book["volumeInfo"]
            puts "======"
            puts "Book ##{index + 1}"
            puts "Title: #{book_info["title"]}"
            puts "Description: #{book_info["description"]}"
            puts "Author: #{book_info["authors"][0]}"
            puts "Publisher: #{book_info["publisher"]}"
            puts "======"
        end

        puts "Search again? (Y/N)"
        user_search_again = gets.chomp

        case user_search_again
        when "y" || "Y"
            get_books_search
        when "n" || "N"
            if @selected_list.length > 1
                add_book_to_reading_list
            else
                run
            end
        else
            run
        end
    end

    def add_book_to_reading_list
        loaded_file = JSON.load(File.read(@selected_list))
        puts "Enter the number of the book you want to add to your reading list....'#{loaded_file["name"]}'"
        user_book_selection = gets.chomp
        if user_book_selection.to_i.is_a?(Integer) && user_book_selection.to_i < 6
            index = user_book_selection.to_i - 1
            new_file_name = loaded_file["name"].downcase.split(" ").join("_") + ".json"
            File.new("./reading_lists/#{new_file_name}", "w")
            File.open("./reading_lists/#{new_file_name}", "w") do |file|
                file.write(JSON.pretty_generate({
                    name: loaded_file["name"],
                    books: loaded_file["books"] << data["items"][index]
                }))
            end
            view_all_reading_lists
        else
            puts "Invalid entry, you have to choose a number."
            view_all_reading_lists
        end
        
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

    def delete_reading_list(reading_list)
        puts "Are you sure? (Y/N)"
        delete_verification = gets.chomp
        case delete_verification
        when "Y"
            File.delete(reading_list) if File.exist?(reading_list)
        when "y"
            File.delete(reading_list) if File.exist?(reading_list)
        when "N"
            puts "We'll move you to the reading lists screen."
            view_all_reading_lists
        when "n"
            puts "We'll move you to the reading lists screen."
            view_all_reading_lists
        when "exit"
            exit
        else
            puts "Sorry we didn't catch that."
            view_all_reading_lists
        end
        
    end

    def update_reading_list(reading_list)
        loaded_file = JSON.load(File.read(reading_list))
        puts "Your loaded file:"
        puts "\n"
        puts "1. Name: #{loaded_file["name"]}"
        puts "\n"
        puts "Choose which property or properties to edit"

        user_update_list_option = gets.chomp

        new_file_data = {
            name: loaded_file["name"],
            books: loaded_file["books"]
        }

        case user_update_list_option
        when "1"
            puts "What is the new name of your reading list?"
            new_list_name = gets.chomp
            loaded_file["name"] = new_list_name
            new_file_name = new_list_name.downcase.split(" ").join("_") + ".json"
            File.new("./reading_lists/#{new_file_name}", "w")
            File.open("./reading_lists/#{new_file_name}", "w") do |file|
                file.write(JSON.pretty_generate({
                    name: loaded_file["name"],
                    books: loaded_file["books"]
                }))
            end
            File.delete(reading_list) if File.exist?(reading_list)
            view_all_reading_lists
        else
            view_all_reading_lists
        end
    end

end

book_cli = BookCli.new
book_cli.run