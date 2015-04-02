class App < Sandwitch::Controller
  def identity
    segment(/UM\d{2,3}/, &:to_i)
  end

  def execute(action)
    ->(*captures){
      send action, *captures, current_customer
    }
  end

  routes do
    on get, root, &:index
    on get, segment('new'), &:new
    post segment('new'), params('post'), &execute(:create)
    on get, identity, &execute(:show)
  end
end
