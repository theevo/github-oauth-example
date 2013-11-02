class MainApplication < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)

  get '/' do
    # @time = Time.now
    # @client = Octokit::Client.new \
    #   :login => MY_LOGIN,
    #   :password => MY_PASSWORD

    erb :'index'
  end

  get '/login' do
    redirect "https://github.com/login/oauth/authorize?client_id=#{OAUTH_TEST_CLIENT_ID}"
  end
end