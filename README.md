# Books CLI

A command line application for book lovers!

## Specs & Gems
- Ruby version 2.6.1
- `gem "pry"`
- `gem "colorize"`
- `gem "dotenv"`
- `gem "json"`
- `gem "rspec"`
- `gem "httparty"`


## Getting started
1. Clone the repo down
```bash
$ git clone https://github.com/abeciana1/books-cli
```
2. Install the necessary gems
```bash
$ bundle install
```

## Running tests
To run the test suite, please execute the following command within the terminal:
```bash
$ bundle exec rspec spec/book_cli_spec.rb
```

## Features

- A user can perform full CRUD on their reading lists
- A user can search for books via the Google Books API integration and receive 5 books based on their query
    - Then, a user can select any one of those books to add it to their reading list and view that same list later with the book(s) added

## Things that I want to get better at and learn
- I started my application with the intentions of full-on test driven development. However, due to time constraints and limitations in my experience with Rspec, I finish the application with additional tests. I really want to get better understanding of Rspec and how it works.
- As an junior developer, I would greatly appreciate any feedback as well as recommendations on books and/or courses to consult to get better at my TDD approach and Rspec.