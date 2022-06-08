class BinaryTeesController < ApplicationController
  def create; end

  private

  def binary_tee_params
    params.permit(:text, :image)
  end
end
