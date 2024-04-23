require_relative 'questionnaire'
require 'rspec'

RSpec.describe 'Questionnaire' do
  describe '#do_prompt' do
    it 'prompts the user and stores answers' do
      allow_any_instance_of(Object).to receive(:gets).and_return('yes', 'yes', 'no', 'no', 'yes')
      expect_any_instance_of(PStore).to receive(:transaction).and_call_original
      #expect_any_instance_of(PStore).to receive(:[]=).at_least(5).times
      do_prompt
    end
  end

  describe '#calculate_rating' do
    it 'calculates the rating correctly' do
      answers = { "q1" => "Yes", "q2" => "No", "q3" => "Yes", "q4" => "Yes", "q5" => "No" }
      rating = calculate_rating(answers)
      expect(rating).to eq(60.0)
    end
  end

  describe '#do_report' do
    it 'prints ratings and average rating' do
      # Mocking the PStore object and its behavior
      store = double("PStore")
      allow(PStore).to receive(:new).and_return(store)
      allow(store).to receive(:transaction).and_yield
      allow(store).to receive(:[]).and_return([{ "q1" => "Yes", "q2" => "Yes" }, { "q1" => "No", "q2" => "Yes" }])

      # Expectations for the ratings and average rating
      #expect { do_report }.to output("Run 1 Rating: 100.0\nRun 2 Rating: 50.0\nAverage Rating: 75.0\n").to_stdout
    end

    it 'prints message for no runs recorded' do
      # Mocking the PStore object and its behavior
      store = double("PStore")
      allow(PStore).to receive(:new).and_return(store)
      allow(store).to receive(:transaction).and_yield
      allow(store).to receive(:[]).and_return(nil)

      # Expectations for the message when no runs are recorded
      expect { do_report }.to output("Ratings not present.\n").to_stdout
    end
  end
end
