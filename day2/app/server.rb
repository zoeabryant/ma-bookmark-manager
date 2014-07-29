require 'sinatra'
# require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'

require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/user'
require_relative 'helpers/application'
require_relative 'data_mapper_setup'

require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'controllers/links'
require_relative 'controllers/tags'
require_relative 'controllers/application'

enable :sessions
set :session_secret, 'super secret'

set :views, Proc.new { File.join(root, "views") }
use Rack::Flash
use Rack::MethodOverride

# register Sinatra::Partial
set :partial_template_engine, :erb

# class BookmarkManager < Sinatra::Base