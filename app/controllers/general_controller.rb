class GeneralController < ApplicationController
  def home
  	@current_page = "homepage"
    @score_geometry = 0
    @score_address = 0
    @score_polygonfix = 0
    if user_signed_in?
      @score_geometry = Flag.flags_for_user(current_user.id, "geometry")
      @score_address = Flag.flags_for_user(current_user.id, "address")
      @score_polygonfix = Flag.flags_for_user(current_user.id, "polygonfix")
    else
      @score_geometry = Flag.flags_for_session(session, "geometry")
      @score_address = Flag.flags_for_session(session, "address")
      @score_polygonfix = Flag.flags_for_session(session, "polygonfix")
    end
    @has_score = false
    @has_score = true if @score_geometry > 0 || @score_address > 0 || @score_polygonfix > 0
  end

  def about
    @current_page = "homepage"
  end

  def win
  	ids = Flag.select(:polygon_id).where(:flag_value => "yes").order("random()").limit(30).map { |p| p.polygon_id }
	pp = Polygon.where(:id => ids).map { |p| JSON.parse(p.vectorizer_json) }
	obj = {}
	obj[:type] = "FeatureCollection"
	obj[:features] = pp
	@json = obj.to_json
  end

end
