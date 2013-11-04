class MainApplication < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)

  enable :sessions

  helpers do
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      !session[:access_token].nil?
    end
  end

  get '/' do
    # @time = Time.now
    # @client = Octokit::Client.new \
    #   :login => MY_LOGIN,
    #   :password => MY_PASSWORD

    erb :'index'
  end

  get '/login' do
    redirect "https://github.com/login/oauth/authorize?client_id=#{OAUTH_TEST_CLIENT_ID}&scope=repo,gist"
  end

  get '/callback' do
    # get temporary GitHub code...
    session_code = request.env['rack.request.query_hash']["code"]
    
    # ... and POST it back to GitHub
    result = RestClient.post("https://github.com/login/oauth/access_token",
                          {:client_id => OAUTH_TEST_CLIENT_ID,
                           :client_secret => OAUTH_TEST_CLIENT_SECRET,
                           :code => session_code
                          },{
                           :accept => :json
                          })
    session[:access_token] = JSON.parse(result)["access_token"]
    redirect '/secret'
  end

  get '/secret' do
    protected!
    @client = Octokit::Client.new :access_token => session[:access_token]
    erb :'secret'
  end
end