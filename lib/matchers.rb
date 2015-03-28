module Matchers
  # def self.fetch(name)
  #   name = name.capitalize
  #   if const_defined? name
  #     const_get name
  #   end
  # end
  def self.Method(*request_methods)
    request_methods = request_methods.map(&:to_s).map(&:upcase)
    Class.new do
      def initialize(request)
        @request = request
      end

      attr_reader :request

      def match?
        request_methods.include? request.request_method
      end

      def match_path
        true
      end

      def match_params
        true
      end

      define_method :request_methods do
        request_methods
      end
    end
  end
  Get = Method :get
  Delete = Method :delete
  Options = Method :options
  Head = Method :head
  class Root
    def initialize(request)
      @request = request
    end

    attr_reader :request

    def match?
      match_path
    end

    def match_path
      request.path_info == '/'
    end

    def match_params
      true
    end
  end
end
