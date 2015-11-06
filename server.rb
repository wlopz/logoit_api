require 'sinatra'
require 'unirest'
require 'mini_magick'
require 'json'

require 'open-uri'

get '/' do

	File.read('public/views/index.erb')

	# erb :index

end

post '/' do
	Unirest.timeout(5) 
	response = Unirest.post 'https://search.craftar.net/v1/search',
	        parameters: {
	            token: "703eb042371c49f0",
	       		image: params['user_image'][:tempfile]				                        
	        }

	# if body == response

		body = response.body
	 
	 	url = body['results'][0]['item']['url']

	# else

	# 	body = response.body

	# 	url = body['error']['code']

	# 	url = body['error']['message']

	# end

	 redirect url

	# File.read('public/views/show.erb')

	# erb :show
end

# helpers do
#   def scale_img

#   	user_image = MiniMagick::Image.open( tempfile.path )
#     user_image.thumbnail( "600x400" )
#     user_image.write( File.join settings.public, "images", "thumb_#{filename}")

#   end
# end

# https://my.craftar.net/api/v0/image/?api_key=b44ec443f934a284c4a0b1bd204d168680027d62