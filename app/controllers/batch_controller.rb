class BatchController < ApplicationController

  def execute
    adapter = SendoAdapter.new
    ap adapter
  end

  private
  def query_params
    params.permit(:query)
  end
end
