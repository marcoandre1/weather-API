# Weather API

- create a new rails application named weather

```console
rails new weather-api -d mysql
```

- Enter your application

```console
cd weather
# If you setup MySQL or Postgres with a username/password, modify the
# config/database.yml file to contain the username/password that you specified
```

- Add a model for the location

```console
rails g model location name
```

- Add a model for the recordings

```console
rails g model Recording location:references temp:integer status
```

- Make sure that MySQL server is running. If you get an error like this:

```console
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
```

it's probable that your server is not running. You can start it with:

```console
sudo service mysql start
```

- Generate the database

```console
rake db:migrate
```

- Open your project in Visual Studio Code.

- Go to `db/seeds.rb` and add some data:

```ruby
locations = Location.create(name: 'New York City')
Recording.create(location_id: 1, temp: 32, status: 'cloudy')
Recording.create(location_id: 1, temp: 34, status: 'rainy')
Recording.create(location_id: 1, temp: 30, status: 'rainy')
Recording.create(location_id: 1, temp: 28, status: 'cloudy')
Recording.create(location_id: 1, temp: 22, status: 'sunny')
```

- In `app/models/location.rb`, add the relation:

```ruby
class Location < ApplicationRecord
    has_many :recordings
end
```

- Seed the database:

```console
rake db:seed
```

- You should be able to see your data in rails console:

```console
rails c
Location.last.recordings.last
exit
```

- Go to `config/routes.rb` to start building the API:

```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :locations do
        resources :recordings
      end
    end
  end

  resources :locations
end
```

- You can see the routes created with the command:

```console
rake routes
```

- The specified routes expect a controller at `api/v1`. Thus, you need to create the next controllers:
  - `app/controllers/api/v1/locations_controller.rb`
  - `app/controllers/api/v1/recordings_controller.rb`
- Add the following to `locations_controller.rb`:

```ruby
class Api::V1::LocationsController < ApplicationController
  before_action :set_location

  def show
  end

  private

    def set_location
      @location = Location.find(params[:id])
    end
end
```

- Add the location view at `app/views/api/v1/locations/show.json.jbuilder`:

```ruby
json.id @location.id
json.name @location.name

json.current do
  json.temp @location.recordings.last.temp
  json.status @location.recordings.last.status
end
```

- Another way to do this would be to add the render function in `locations_controller.rb`:

```ruby
def show
  render json: {
    id: @location.id,
    name: @location.name
  }
end
```

- Now start the server:

```console
rails s
```

- Navigate to `localhost:3000/api/v1/locations/1.json` to get your JSON!
- If you go to `localhost:3000/api/v1/locations/1`, you get a format error.
- To avoid this, build your own API controller at `app/controllers/api_controller.rb`:

```ruby
class ApiController < ApplicationController
  before_action :set_default_format

  private

    def set_default_format
      request.format = :json
    end
end
```

> This will override the specified format in the URL.

- Now change the class you inherit in `locations_controller.rb`:

```ruby
class Api::V1::LocationsController < ApiController
```

- Now, you should be able to navigate to `localhost:3000/api/v1/locations/1`!

- The only problem with this approach is that other formats, like `xml` are not going to work. But you can tweak to make it work!
