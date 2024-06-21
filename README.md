# TradeXpert

This is a simple trading app project built using Devise for authentication, Tailwind CSS for styling, Turbo Stimulus for interactivity, RSpec for testing, and the IEX API for fetching stock market data.
![TradeXpert Screenshot](app/assets/images/view.png)

### Technologies Used

- Devise
- Tailwind CSS
- Turbo Stimulus
- RSpec
- IEX API

### User Story

As a Trader, I want to

- create an account to buy and sell stocks
- log in my credentials so that I can access my account on the app
- receive an email to confirm my pending Account signup
- receive an approval Trader Account email to notify me once my account has been approved
- buy a stock to add to my investment (Trader signup should be approved)
- have My Portfolio page to see all my stocks
- have a Transaction page to see and monitor all the transactions made by buying and selling stocks
- sell my stocks to gain money

As an Admin, I want to

- create a new trader to manually add them to the app
- edit a specific trader to update his/her details
- view a specific trader to show his/her details
- see all the trader that registered in the app so I can track all the traders
- have a page for pending trader sign up to easily check if there’s a new trader sign up
- approve a trader sign up so that he/she can start adding stocks
- see all the transactions so that I can monitor the transaction flow of the app

### Installation

1. Fork and Clone the repository:
   `git clone <repository-url>`
   `bundle install`
   `rails db:prepare`

2. Obtain an API key from the IEX API website (https://iexcloud.io/) if you haven't already.
3. Add your IEX API key to Rails credentials:
   `rails credentials:edit`
   Add the following lines to the opened file:
   `iex:`
   `api_key: your-api-key`

4. Start the Rails server:
   `bin/dev`

### Testing

RSpec is used for testing. To run the tests, use the following command:
`bundle exec rspec`

This will run all the tests and provide feedback on the application's behavior.
