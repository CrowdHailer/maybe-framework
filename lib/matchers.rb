module Matchers
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
end
