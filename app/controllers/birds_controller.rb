class BirdsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
# above line will return the render_not_found_response as a default for ALL controller actions, when we run into the "ActiveRecord::RecordNotFound" error

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  def create
    bird = Bird.create(bird_params)
    render json: bird, status: :created
  end

  # GET /birds/:id
  def show
    bird = find_bird
    render json: bird
  # rescue ActiveRecord::RecordNotFound #fixed the below error response for when an id doesn't exist in the database: 
    #ActiveRecord::RecordNotFound (Couldn't find Bird with 'id'=9999)
    # line 2 will do the same action as a default for ALL OF THE controllers
    # render_not_found_response
  end

  # PATCH /birds/:id
  def update
    bird = find_bird
    # if bird
    #   bird.update(bird_params)
    #   render json: bird
    # else
    #   render_not_found_response
    # end

    bird.update(bird_params)
    render json: bird
  # rescue ActiveRecord::RecordNotFound
    # render_not_found_response
  end

  # PATCH /birds/:id/like
  # Endpoint is /birds/:id, but the body should have a "like" key *see last lab*
  def increment_likes
    bird = find_bird
    # if bird
    #   bird.update(likes: bird.likes + 1)
    #   render json: bird
    # else
    #   render_not_found_response
    # end
    bird.update(likes: bird.likes + 1)
    render json: bird
  end

  # DELETE /birds/:id
  def destroy
    bird = find_bird
    # if bird
    #   bird.destroy
    #   head :no_content
    # else
    #   render_not_found_response
    # end
    bird.destroy
    head :no_content
  end

  private

  def find_bird 
    Bird.find(params[:id])
  end

  def bird_params
    params.permit(:name, :species, :likes)
  end


  def render_not_found_response 
    render json: { error: "Bird not found" }, status: :not_found
  end

end
