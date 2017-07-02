class ConfigsController < ApplicationController

  def index
    config_vals = {
        dubai_rate: AED_XE_ETB,
        korea_rate: KRW_XE_ETB,
    }
    @config = OpenStruct.new(config_vals);
  end

end