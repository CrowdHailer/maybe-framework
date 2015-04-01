class App < Sandwitch::Controller

  # cuba inspired
  # use route, consume
  # symbol matching
  route get, /edit(\d.)/, file('.css'), &:index

  def self.show(pattern=/[^\/]+/, &block)
    get pattern, &block
  end

  get integer(min: 12, max: 45) do |count|
    "Your count was #{count}"
  end

  get header(:key => /match/)







  def self.get
    ->(instance){
      instance.send :get
    }
  end


end
