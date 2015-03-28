require_relative '../angry_accessor'
module Sandwitch
  class Controller
    extend AngryAccessor

    class << self
      def call(env)
        new.call(env)
      end

      def on(*args, &action)
        routes << [Matchers.Group(*args), action]
      end

      def routes
        @routes ||= []
      end

      def method_missing(meth, *args, &block)
        begin
          matcher = Matchers.send(meth.capitalize, *args)
        rescue NameError
          super
        end
      end
    end

    def initialize(app = NotFound)
      @app = app
    end

    attr_writer :request, :response
    attr_fetcher :request, :response, :app


    def new(request, response)
      clone.tap do |copy|
        copy.request = request
        copy.response = response
      end
    end

    def call(env)
      new(Request.new(env), Response.new).respond || app.call(env)
    end

    def routes
      self.class.routes
    end

    def respond
      routes.each do |matcher, action|
        group_matcher = matcher.new(request)
        if group_matcher.match?
          self.instance_exec *group_matcher.captures, &action
          return response
        end
      end
      return nil
    end
  end
end
