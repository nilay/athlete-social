class Admin::DashboardController < Admin::ApplicationController
  def show
    @questions = Question.all
      .page(params[:page])
      .per(25)

    @athletes = Athlete.all
      .page(params[:athlete_page])
      .per(25)
  end
end
