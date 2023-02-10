class SearchTypesController < ApplicationController
  before_action :set_search_type, only: %i[ show edit update destroy ]

  # GET /search_types or /search_types.json
  def index
    @search_types = SearchType.all
  end

  # GET /search_types/1 or /search_types/1.json
  def show
  end

  # GET /search_types/new
  def new
    @search_type = SearchType.new
  end

  # GET /search_types/1/edit
  def edit
  end

  # POST /search_types or /search_types.json
  def create
    @search_type = SearchType.new(search_type_params)

    respond_to do |format|
      if @search_type.save
        format.html { redirect_to search_type_url(@search_type), notice: "Search type was successfully created." }
        format.json { render :show, status: :created, location: @search_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @search_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /search_types/1 or /search_types/1.json
  def update
    respond_to do |format|
      if @search_type.update(search_type_params)
        format.html { redirect_to search_type_url(@search_type), notice: "Search type was successfully updated." }
        format.json { render :show, status: :ok, location: @search_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @search_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_types/1 or /search_types/1.json
  def destroy
    @search_type.destroy

    respond_to do |format|
      format.html { redirect_to search_types_url, notice: "Search type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search_type
      @search_type = SearchType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def search_type_params
      params.require(:search_type).permit(:search_type_id, :search_type_content)
    end
end
