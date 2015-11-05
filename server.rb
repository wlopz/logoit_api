require 'sinatra'

get '/' do
	File.read('upload/index.html')
end