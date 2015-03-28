class NotFound
  def self.call(env)
    [404, {}, ['Not Found']]
  end
end


class Sandwitch
  Request = Class.new(Rack::Request)
  Response = Class.new(Rack::Response)
  UndefinedRequest = Class.new(StandardError)

  def initialize(app = NotFound)
    @app = app
  end

  attr_reader :app

  def self.call(env)
    new.call(env)
  end

  def request
    raise UndefinedRequest, 'There is no request object available'
  end

  def new(request, response)
    clone.tap do |copy|

      copy.define_singleton_method :request do
        request
      end

      copy.define_singleton_method :response do
        response
      end
    end
  end

  def call(env)
    new(Request.new(env), Response.new).respond || app.call(env)
  end

  def routes
    self.class.routes
  end

  def respond
    routes.each do |conditions, action|
      captures = conditions.map{|part| part.call(request)}
      if captures.all?
        self.instance_exec *captures, &action
        return response
      end
    end
    return nil

    routes.each do |matcher, action|
      m = matcher.new(request)
      if m.match_all?
        self.instance_exec *match.captures, &action
      end
    end
  end

  def self.on(*args, &action)
    routes << [args, action]
  end

  def self.routes
    @routes ||= []
  end

  def self.get?
    ->(request){
      request.get?
    }
  end

  def self.head?
    ->(request){
      request.head?
    }
  end

  def self.get
    ->(request){
      Matchers::Get.new(request).match?
    }
  end

end

module Matchers
  class Get
    def initialize(request)
      @request = request
    end

    attr_reader :request

    def match?
      request.get?
    end

    def match_path
      true
    end

    def match_params
      true
    end
  end
end

class App < Sandwitch
  on get do
    response.body = ['Hello World']
  end

  on head? do |a|

  end

end

class Rest < Sandwitch
  # on get, index do ||
  #   @items = Items.all
  #   response.body = [render :index]
  # end
  #
  # on get, segment('/new'), :action => :new
  # def new
  #   ok :new
  # end
  #
  # on post, root, params(:item), authenticated do |item_params, user|
  #   form = Item::Create::Form.new item_params
  #   Items::Create.call(form, user) do |on|
  #     on.created do |item|
  #       response.status = 201
  #       response << :location => "/items/#{item.id}"
  #     end
  #   end
  # end
end
