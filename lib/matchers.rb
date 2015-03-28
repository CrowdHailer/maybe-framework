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
  def self.Get
    const_get 'Get'
  end
  def self.Head
    const_get 'Head'
  end
  def self.Root
    const_get 'Root'
  end
  def self.Delete
    const_get 'Delete'
  end
  def self.Options
    const_get 'Options'
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
  def self.Segment(pattern='[^\/]+')
    Class.new do
      def initialize(request)
        @request = request
      end

      attr_reader :request

      def match?
        matchdata = request.path_info.match(/\A\/(#{pattern})(\/|\z)/)
        return false unless matchdata
        segment, tail = matchdata.captures
        # ap segment
        # ap tail
        yield segment unless pattern.is_a?(String)
        request.path_info = tail + matchdata.post_match
      end

      def match_path
        request.path_info == '/'
      end

      def match_params
        true
      end

      define_method :pattern do
        pattern
      end
    end
  end
  def self.Group(*matchers)
    Class.new do
      def initialize(request)
        @request = request
      end

      attr_reader :request

      def match?
        matchers.map{|m| m.new(request)}.all?{|m| m.match?{|i| captures << i}}
      end

      def captures
        @captures ||= []
      end

      define_method :matchers do
        matchers
      end
    end
  end
end
