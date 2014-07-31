env = ENV["RACK_ENV"] || "development"

if env == 'production'
	DataMapper.setup(:default, ENV["HEROKU_POSTGRESQL_MAUVE_URL"])
else
	DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
end

DataMapper.finalize
DataMapper.auto_migrate!