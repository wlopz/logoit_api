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
            token: "703eb042371c49f0",
	       		image: resized_tempfile				                        
	        }

	# if body == response

		body = response.body
	 
	# p response.body
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

# helpers do
#   def scale_img
#   	tempfile = Tempfile.open(filename, 'wb') { |fp| fp.write(response.body) }

#   	user_image = MiniMagick::Image.open( tempfile.path )
#     user_image.thumbnail( "600x400" )
#     user_image.write( File.join )

#   end
# end

# https://my.craftar.net/api/v0/image/?api_key=b44ec443f934a284c4a0b1bd204d168680027d62