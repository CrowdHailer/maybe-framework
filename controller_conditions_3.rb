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

  get segment(/\d+/, &:to_i) do |i|

  end

  post root, param('customer', :form => Cutomer::CreateForm) do |form|
    Customer::Create.call(form, current_user) do |on|
      on.created do |customer|

      end
      on.bad_request do

      end
      on.not_allowed do

      end
    end

    usecase = Customer::Create.new(form, current_user)
    case usecase.status
    when :created then
      response.status = 201
      response['location'] = show_path(usecase.customer)
  end






  def self.get
    ->(instance){
      instance.send :get
    }
  end


end
