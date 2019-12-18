class ItemsController < ApplicationController
	before_action :set_todo
	before_action :set_todo_item,only:[:show,:update,:destroy]
	def show
	end
	def index

	end
	def create
	end
	def update
	end
	def destroy
	end
	private
	def item_params
		params.permit(:name,:done)
	end
	def set_todo
		@todo = Todo.find(params[:todo_id])
	end
	def set_todo_item
		@item = @todo.items.find(params[:id]) if @todo
	end
end
