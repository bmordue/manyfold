class CreatorsController < ApplicationController
  before_action :get_creator, except: [:index, :new, :create]

  def index
    @creators =
      if current_user.pagination_settings["creators"]
        page = params[:page] || 1
        Creator.all.page(page).per(current_user.pagination_settings["per_page"])
      else
        Creator.all
      end
    @title = "Creators"
  end

  def show
    @models = @creator ? @creator.models : Model.where(creator: nil)
    if current_user.pagination_settings["models"]
      page = params[:page] || 1
      @models = @models.page(page).per(current_user.pagination_settings["per_page"])
    end
  end

  def edit
    @creator.links.build if @creator.links.empty? # populate empty link
  end

  def update
    @creator.update(creator_params)
    redirect_to @creator
  end

  def new
    @creator = Creator.new
    @creator.links.build if @creator.links.empty? # populate empty link
    @title = "New Creator"
  end

  def create
    @creator = Creator.create(creator_params)
    redirect_to @creator
  end

  def destroy
    @creator.destroy
    redirect_to creators_path
  end

  private

  def get_creator
    if params[:id] == "0"
      @creator = nil
      @title = "Unknown"
    else
      @creator = Creator.find(params[:id])
      @title = @creator.name
    end
  end

  def creator_params
    params.require(:creator).permit([
      :name,
      links_attributes: [:id, :url, :_destroy]
    ])
  end
end
