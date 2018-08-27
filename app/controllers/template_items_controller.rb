class TemplateItemsController < ApplicationController
  before_action :set_templating, only: [:semantic_ui, :uikit, :purecss, :sample_blog]
  before_action :set_on_point, only: [:calendar, :events, :on_point, :pricing, :admin, :example_stuff, :login, :edit, :update]

  before_action :set_item, only: [:edit, :update]
  before_action :check_auth, only: [:edit, :update]

  layout :resolve_layout
  
  def pricing
    @priced_items = TemplateItem.priced_items.reverse
  end

  def calendar
    @event = Event.new
    @events = Event.all.reverse
  end

  def pass_wall
    cookies.permanent[:still_in_dev_wall_passed] = true
    redirect_to root_url
  end

  def update
    if @item.update(item_params)
      redirect_to root_url
    else
      redirect_to :back, notice: "Failed to update item..."
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
    redirect_to '/404' unless current_user
  end

  def set_item
    if params[:token]
      @item = TemplateItem.find_by_unique_token(params[:token])
      @item ||= TemplateItem.find_by_id(params[:token])
    else
      @item = TemplateItem.find_by_unique_token(params[:id])
      @item ||= TemplateItem.find_by_id(params[:id])
    end
    redirect_to '/404' unless @item
  end

  def client_options
    {
      client_id: ENV['GOOGLE_CALENDAR_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CALENDAR_SECRET'],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url
    }
  end

  def resolve_layout
    case action_name.to_sym
    when :on_point, :calendar, :events, :pricing, :admin, :example_stuff, :login, :edit
      "on_point"
    else
      "application"
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
    params.require(:template_item).permit(:body, :image)
  end
end

# all of the google calendar code
# def new_event
#   client = Signet::OAuth2::Client.new(client_options)
#   client.update!(session[:authorization])
#
#   service = Google::Apis::CalendarV3::CalendarService.new
#   service.authorization = client
#
#   today = Date.today
#
#   event = Google::Apis::CalendarV3::Event.new({
#     start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
#     end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
#     summary: 'New event!'
#   })
#
#   service.insert_event(params[:calendar_id], event)
#
#   redirect_to calendar_events_path(calendar_id: params[:calendar_id])
# end
#
# def events
#   client = Signet::OAuth2::Client.new(client_options)
#   client.update!(session[:authorization])
#
#   service = Google::Apis::CalendarV3::CalendarService.new
#   service.authorization = client
#
#   @event_list = service.list_events(params[:calendar_id])
#
#   @calendar_id = params[:calendar_id]
# end
#
# def calendar
#   client = Signet::OAuth2::Client.new(client_options)
#   client.update!(session[:authorization])
#
#   service = Google::Apis::CalendarV3::CalendarService.new
#   service.authorization = client
#
#   @calendar_list = service.list_calendar_lists
# rescue Google::Apis::AuthorizationError
#   response = client.refresh!
#
#   session[:authorization] = session[:authorization].merge(response)
#
#   retry
# end
#
# # authenticate with google
# def redirect
#   client = Signet::OAuth2::Client.new(client_options)
#
#   redirect_to client.authorization_uri.to_s
# end
#
# def callback
#   client = Signet::OAuth2::Client.new(client_options)
#   client.code = params[:code]
#
#   response = client.fetch_access_token!
#
#   session[:authorization] = response
#
#   redirect_to on_point_calendar_path
# end
