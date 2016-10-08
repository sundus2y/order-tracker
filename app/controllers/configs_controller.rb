class ConfigsController < ApplicationController

  def index
    config_vals = {
        dubai_rate: 6.04,
        korea_rate: 0.020,
    }
    @config = OpenStruct.new(config_vals);
  end

end