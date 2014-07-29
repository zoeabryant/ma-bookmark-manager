env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://qxxtoiirwkpbrx:WYNH9sLMUNz5N7hCoACj0nImkx@ec2-107-20-191-205.compute-1.amazonaws.com:5432/d9b84p4h4p2pi1")
DataMapper.finalize
DataMapper.auto_migrate!