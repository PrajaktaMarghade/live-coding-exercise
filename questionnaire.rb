require "pstore" # https://github.com/ruby/pstore

STORE_NAME = "tendable.pstore"
store = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

# TODO: FULLY IMPLEMENT
def do_prompt
  # Ask each question and get an answer from the user's input.
  answers = {}

  QUESTIONS.each_key do |question_key|
    print "#{QUESTIONS[question_key]} (Yes/No): "
    ans = gets&.chomp&.downcase
    if ['yes', 'y'].include?(ans)
      answers[question_key] = 'Yes'
    elsif ['no', 'n'].include?(ans)
      answers[question_key] = 'No'
    else
      puts "Invalid input. Please enter 'Yes' or 'No'."
    end
  end

  # Store answers
  store = PStore.new(STORE_NAME)
  store.transaction do
    store[:answers] ||= []
    store[:answers] << answers
  end

  return answers
end

# calculate rating
def calculate_rating(answers)
  total_yes = answers.count { |_, answer| answer == 'Yes' }
  total_questions = QUESTIONS.size
  rating = (total_yes.to_f / total_questions) * 100
  rating.round(2)
end

def do_report
  store = PStore.new(STORE_NAME)
  all_ratings = []

  store.transaction do
    store[:answers]&.each_with_index do |answers, index|
      rating = calculate_rating(answers)
      all_ratings << rating
      puts "Run #{index + 1} Rating: #{rating}"
    end
  end

  if all_ratings.any?
    average_rating = (all_ratings.sum / all_ratings.size).round(2)
    puts "Average Rating: #{average_rating}"
  else
    puts "Ratings not present."
  end
end

do_prompt
do_report
