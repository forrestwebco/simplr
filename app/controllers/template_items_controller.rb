class TemplateItemsController < ApplicationController
  before_action :set_templating, only: [:semantic_ui, :uikit, :purecss, :sample_blog]
  before_action :set_on_point, only: [:calendar, :events, :on_point, :pricing, :admin, :example_stuff, :login, :edit, :update,
    :new_student_packet, :schedule, :show, :about, :get_started]

  before_action :set_item, only: [:show, :edit, :update]
  before_action :check_auth, only: [:edit, :update, :gen_item, :admin]

  before_action :set_page, only: [:on_point, :about, :schedule, :calendar, :pricing, :admin]

  layout :resolve_layout

  def show
    @tag = @item.tag
  end

  def gen_item
    @item = TemplateItem.new tag: params[:tag]
    @item.item_type = params[:item_type]
    if @item.save
      redirect_to on_point_edit_path(@item.unique_token)
    end
  end

  def pricing
    @priced_items = TemplateItem.priced_items.reverse
  end

  def calendar
    @event = Event.new
    @events = Event.all.reverse
  end

  def pass_wall
    cookies[:dev_wall_passed_yet] = { value: true, expires: 2.day.from_now }
    redirect_to root_url
  end

  def update
    if @item.update(item_params)
      if @item.tag.include? "lessons_schedule"
        true
      end
      redirect_to root_url
    else
      redirect_to on_point_edit_path(@item.unique_token), notice: "Failed to update item..."
    end
  end

  def index
    @forrest_web_co = true
  end

  def semantic_ui
    @semantic_ui = @forrest_web_co = true
  end

  private

  def check_auth
    redirect_to '/404' unless michaela?
  end

  def set_item
    if params[:tag]
      @item = TemplateItem.find_by_tag(params[:tag])
      @item ||= TemplateItem.find_by_unique_token(params[:tag])
      @item ||= TemplateItem.find_by_id(params[:tag])
    elsif params[:token]
      @item = TemplateItem.find_by_unique_token(params[:token])
      @item ||= TemplateItem.find_by_id(params[:token])
    else
      @item = TemplateItem.find_by_unique_token(params[:id])
      @item ||= TemplateItem.find_by_id(params[:id])
    end
    redirect_to '/404' unless @item
  end

  def resolve_layout
    case action_name.to_sym
    when :on_point, :calendar, :events, :pricing, :admin, :example_stuff, :login, :edit, :schedule, :show, :about, :get_started
      "on_point"
    when :new_student_packet
      "blank"
    else
      "application"
    end
  end

  def set_page
    case action_name.to_sym
    when :on_point
      @home = true
    when :about
      @about = true
    when :schedule
      @schedule = true
    when :calendar
      @calendar = true
    when :pricing
      @pricing = true
    when :admin
      @admin = true
    end
  end

  def set_on_point
    @on_point = true
  end

  def set_templating
    @templating = true
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:template_item).permit(:body, :image, :url, :name, :title, :description, :start_date, :total_students)
  end
end
