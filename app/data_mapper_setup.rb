env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
DataMapper.setup(:default, ENV["HEROKU_POSTGRESQL_MAUVE_URL"]) if env == 'production'

DataMapper.finalize
DataMapper.auto_migrate!