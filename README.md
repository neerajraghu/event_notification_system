Setup and Run Instructions:
	1. Open your terminal.
	2. Navigate to the project directory.
	3. Run the following commands:
		a) bundle install
		b) rails db:create
		c) rails db:migrate
		d) rails s
	These commands will install dependencies, set up the database, and start the Rails server.

for running the test cases, use the following command:
	a) bundle exec rake test

Note: Please replace the placeholder string "YOUR_ITERABLE_API_KEY" with the actual Iterable API key in both the controller (controllers/events_controller.rb) and the test file (test/controllers/events_controller_test.rb).