class RecipesController < ApplicationController
    def index
        if User.find_by(id: session[:user_id])
            render json: Recipe.all, include: [:user], status: :created
        else
            render json: {errors: ["you are not logged in"]}, status: :unauthorized
        end
    end

    def create
        user = User.find_by(id: session[:user_id])
        if user
            recipe = user.recipes.create(recipe_params)
            if recipe.valid?
                render json: recipe, include: [:user], status: :created
            else
                render json: {errors: ["Invalid Recipe"]}, status: 422
            end
        else
            render json: {errors: ["not logged in"]}, status: :unauthorized
        end
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end
end
