class NotFound
  def self.call(env)
    [404, {}, ['Not Found']]
  end
end
