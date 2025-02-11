class ProductsController < ApplicationController

  def index
    @products = Product.all
    render json: @products
  end

  def show
    @product = Product.find(params[:id])

    render json: @product, status: 200

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def update
    @product = Product.find(params[:id])

    if @product.update!(product_params)
      render json: @product, status: 200
    else
      render json: { errors: @product.errors }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :quantity)
  end
end
