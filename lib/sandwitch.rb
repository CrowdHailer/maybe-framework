require_relative './angry_accessor'
Dir[File.expand_path('../sandwitch/*.rb', __FILE__)].each {|file| require file }

module Sandwitch

end
