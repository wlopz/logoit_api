require 'sinatra'
require 'unirest'
require 'mini_magick'
require 'json'
require "sinatra/reloader" if development?
require 'open-uri'

get '/' do

	File.read('public/views/index.erb')

	# erb :index

end

post '/' do
	Unirest.timeout(5)

	tempfile = params['user_image'][:tempfile].path
	image = MiniMagick::Image.open(tempfile)
	image.resize "600x400"

	ext = File.extname(tempfile)
	basename = File.basename(tempfile, ext)
	resized_tempfile = Tempfile.new([basename, ext])
	image.write(resized_tempfile.path)

	# p resized_tempfile.path

	response = Unirest.post 'https://search.craftar.net/v1/search',
	        parameters: {
            token: "ee40a93438eb49ee",
	       		image: resized_tempfile				                        
	        }

		body = response.body

	if body["error"]
	 	code = body['error']['code']
		message = body['error']['message']
		"#{code}: #{message}"
	elsif body['results'].size.zero?
		"no matches"
	else
	 	url = body['results'][0]['item']['url']
	 	redirect url
	end

	# File.read('public/views/show.erb')

	# erb :show
end