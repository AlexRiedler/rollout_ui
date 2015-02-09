ENV["RAILS_ENV"] ||= "test"

require 'rubygems'
require 'redis'
require 'redis-namespace'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

$redis = Redis::Namespace.new('rollout_ui:test', :redis => Redis.new)

RSpec.configure do |config|
  config.include Capybara::DSL
  config.before(:each) do
    keys = $redis.keys("*")
    $redis.del(*keys) unless keys.empty?

    $rollout = Rollout.new($redis)
    RolloutUi.wrap($rollout)
  end

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end
