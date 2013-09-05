# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
TheresienEms::Application.initialize!

Time::DATE_FORMATS[:european_style] = "%d.%m.%Y um %H:%M Uhr"


