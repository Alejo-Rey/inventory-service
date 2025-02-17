class ProductsController < ApplicationController

  def index
    @products = Product.all
    render json: @products
  end

  def show
    @product = Product.find(params[:id])

    render json: @product, status: :ok

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def update
    @product = Product.find(params[:id])

    if @product.update!(product_params)
      render json: @product, status: :ok
    else
      render json: { errors: @product.errors }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def create
    products_data = product_params

    if products_data.blank?
      return render json: { error: "No products provided" }, status: :unprocessable_entity
    end

    created_products = []

    ActiveRecord::Base.transaction do
      products_data.each do |product_data|
        product = Product.new(product_data)
        if product.save
          created_products << product
        else
          raise ActiveRecord::Rollback, "Error: #{product.errors.full_messages.join(', ')}"
        end
      end
    end

    render json: created_products, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def product_params
    permitted_params = params.permit(products: [ :name, :description, :price, :quantity ]).fetch(:products, [])

    if permitted_params.is_a? Array
      return permitted_params
    end

    params.require(:products).permit(:name, :description, :price, :quantity)
  end
end
