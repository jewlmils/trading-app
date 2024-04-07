# Trading App

This is a simple trading app project built using Devise for authentication, Tailwind CSS for styling, Turbo Stimulus for interactivity, RSpec for testing, and the IEX API for fetching stock market data.

### Technologies Used

- Devise
- Tailwind CSS
- Turbo Stimulus
- RSpec
- IEX API

### Installation

1. Clone the repository:
   `git clone <repository-url>`

2. Install dependencies:
   `bundle install`

3. Set up the database:
   `rails db:create
rails db:migrate`

4. Obtain an API key from the IEX API website (https://iexcloud.io/) if you haven't already.
5. Set your IEX API key as an environment variable. You can do this by creating a `.env` file in the root of your project and adding the following line:
   `IEX_API_KEY=your-api-key`

6. Start the Rails server:
   `rails server`

7. Visit `http://localhost:3000` in your browser to view the app.

### Testing

RSpec is used for testing. To run the tests, use the following command:
`bundle exec rspec`

This will run all the tests and provide feedback on the application's behavior.
