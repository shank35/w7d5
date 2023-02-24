class SubsController < ApplicationController

  before_action :ensure_user_is_moderator, only: [:edit]
  before_action :require_logged_in

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id
    if @sub.save
      redirect_to subs_url
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to subs_url
    else  
      flash.now[:messages] = ["Invalid Update"]
      render :edit
    end
  end

  def show
    @sub = Sub.find(params[:id])
    render :show
  end

  def index
    @subs = Sub.all
    render :index
  end

  private

  def ensure_user_is_moderator
    @page_sub = Sub.find(params[:id])
    redirect_to subs_url unless @page_sub.moderator_id == current_user.id
  end

  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end

end
