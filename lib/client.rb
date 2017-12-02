require 'coinbase/exchange'
require "yaml"
module Client

  def self.client(product_id: nil)
    config = YAML::load_file(File.join(__dir__, '../config.yml'))
    Coinbase::Exchange::Client.new(config["key"],
                                   config["b64secret"],
                                   config["passphrase"],
                                   product_id: product_id)
  end

end
