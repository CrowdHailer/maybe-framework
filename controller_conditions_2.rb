class App < Sandwitch::Controller

  route :show do
    id = segment(/\d+/).to_i
    item = Items[id]
    get? && item ? [item] : false
  end

  route :missing do
    id = segment(/\d+/).to_i
    get? && id ? [id] : false
  end

  route :nothing do
    true
  end

  map AdminController, Matchers.path('/admin')

  def show(item)
    @item = item
    render :show
  end

  def missing(id)
    flash['error'] = "item with id #{id} not found"
    redirect :index
  end

  def nothing
    app.call(request.env)
  end

end
