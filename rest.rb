require './lib/sandwitch'

class Rest < Sandwitch::Controller
  def render(arg)
    'Hello World'
  end

  on get, root do
    @items = []
    response.body = [render(:index)]
  end

  on delete, root do
    response.status = 405
  end

  on options, root do
    response['Allow'] = ['GET', 'HEAD']
  end

  on get, segment('new') do
    response.body = ['new page']
  end

  on get, segment(/\d+/) do |id|
    response['X-item-id'] = id
  end



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
