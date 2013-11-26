class PeopleController < ApplicationController
  include PermitDynamic

  def create
    @person = Person.create(person_params)
    render json: @person
  end

  rescue_from 'ActionController::UnpermittedParameters' do |ex|
    render json: { error: 'unpermitted_parameters' }, status: :bad_request
  end

  private

  def person_params
    params.require(:person).permit(:name, :dynamic_attributes => Person)
  end
end
