class CustomSessionsController < Devise::SessionsController
  after_filter :after_login, :only => :create

  def before_login
  end

  def after_login
    if current_user.role == 'sales'
      session.clear if is_off_hours?
    end
  end

  private

  # TODO: Make this part of admin configuration options
  def is_off_hours?
    login_time = Time.zone.now
    # Is Sunday?
    return true if login_time.sunday?
    # Is Between 6:30PM and 7AM?
    return true if login_time.hour < 4 || login_time.hour >= 16 || (login_time.hour == 15 && login_time.min > 30)
    false
  end
end