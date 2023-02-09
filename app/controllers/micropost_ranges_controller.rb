class MicropostRangesController < ApplicationController
  before_action :set_micropost_range, only: %i[ show edit update destroy ]
  @micropost_range_select = MicropostRange.pluck( :range_content, :range_id)
  # GET /micropost_ranges or /micropost_ranges.json
  def index
    @micropost_ranges = MicropostRange.all
  end

  # GET /micropost_ranges/1 or /micropost_ranges/1.json
  def show
  end

  # GET /micropost_ranges/new
  def new
    @micropost_range = MicropostRange.new
  end

  # GET /micropost_ranges/1/edit
  def edit
  end

  # POST /micropost_ranges or /micropost_ranges.json
  def create
    # 投稿の公開範囲
    @micropost_range = MicropostRange.new(micropost_range_params)

    respond_to do |format|
      if @micropost_range.save
        format.html { redirect_to micropost_range_url(@micropost_range), notice: "Micropost range was successfully created." }
        format.json { render :show, status: :created, location: @micropost_range }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @micropost_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /micropost_ranges/1 or /micropost_ranges/1.json
  def update
    respond_to do |format|
      if @micropost_range.update(micropost_range_params)
        format.html { redirect_to micropost_range_url(@micropost_range), notice: "Micropost range was successfully updated." }
        format.json { render :show, status: :ok, location: @micropost_range }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @micropost_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /micropost_ranges/1 or /micropost_ranges/1.json
  def destroy
    @micropost_range.destroy

    respond_to do |format|
      format.html { redirect_to micropost_ranges_url, notice: "Micropost range was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost_range
      @micropost_range = MicropostRange.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def micropost_range_params
      params.require(:micropost_range).permit(:range_id, :range_content)
    end
end
