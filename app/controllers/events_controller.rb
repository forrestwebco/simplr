class EventsController < ApplicationController
  before_action :set_templating, only: [:show]
  before_action :set_on_point, only: [:show]
  
  before_action :check_auth, except: [:show]
  before_action :set_event, except: [:create]

  layout :resolve_layout

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to on_point_calendar_path
    else
      redirect_to :back, notice: "Failed to create new event..."
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event
    else
      redirect_to :back, notice: "Failed to create new event..."
    end
  end

  def destroy
    @event.destroy
    redirect_to on_point_calendar_path
  end

  private

  def check_auth
    redirect_to '/404' unless current_user
  end

  def event_params
    params.require(:event).permit(:title, :body, :image, :start_date)
  end

  def set_event
    if params[:token]
      @event = Event.find_by_unique_token(params[:token])
      @event ||= Event.find_by_id(params[:token])
    else
      @event = Event.find_by_unique_token(params[:id])
      @event ||= Event.find_by_id(params[:id])
    end
    redirect_to '/404' unless @event
  end

  def set_on_point
    @on_point = true
  end

  def set_templating
    @templating = true
  end

  def resolve_layout
    case action_name.to_sym
    when :show
      "on_point"
    else
      "application"
    end
  end
end
