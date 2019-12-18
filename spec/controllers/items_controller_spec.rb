require 'rails_helper'
require 'faker'

RSpec.describe ItemsController, type: :controller do
	let!(:todo){create(:todo)}
	let!(:items){create_list(:item,10,todo_id: todo.id)}
	let(:todo_id){todo.id}
	let(:item_id){items.first.id}
	describe "get /todos/:todo_id/items" do
		before{get :index, params: {todo_id: todo_id}}
		context "when todo items exist" do
			it "returnds all todo items" do
				expect(json).not_to be_empty
				expect(json.size).to eq(10)
			end
			it "returns status 200" do
				expect(response).to have_http_status(200)
			end
		end
		context "when todo item does not exist" do
			let(:todo_id){0}
			it "returns 404 status" do
				expect(response).to have_http_status(404)
			end
			it "retuirns record not found" do
				expect(response.body).to match(/Couldn't found Todo/)
			end
		end
	end
	describe "get /todos/:todo_id/items/:id" do
		before{get :show,params:{id: item_id,todo_id: todo_id}}
		context "when  todo item exists" do
			it "returns item" do
				expect(json).not_to be_empty
				expect(json['id']).to eq(todo_id)
			end
			it "returns status 200" do
				expect(response).to have_http_status(200)
			end
		end
		context "when todo item does not exists" do
			let(:item_id){0}
			it "returns status 404" do
				expect(response).to have_http_status(404)
			end
			it "returns record not found" do
				expect(response.body).to match(/Couldn't found Item/)
			end
		end
	end
	describe "post /todos/:todo_id/items/:id" do
		let(:valid_attr){{name: "pen",done: false,todo_id: todo_id}}
		context "when attri are valid" do
			before{post :create,params: valid_attr}
			it "create item" do
				expect(json['name']).to eq("pen")
			end
			it "returns status 201" do
				expect(response).to have_http_status(201)
			end
		end
		context "when attr not valid" do
			before{post :create,params: {todo_id:todo_id}}
			it "returns status code 422" do
				expect(response).to have_http_status(422)
			end
			it "returns validations error" do
				expect(response.body).to match(/Validation failed: Name can't be blank/)
			end
		end
	end
	describe "put /todos/:todo_id/items/:id" do
		let(:valid_attr){{name: "inc",id: item_id,todo_id: todo_id}}
		before{put :update,params: valid_attr}
		context "when item exists" do
			it "returns status 204" do
				expect(response).to have_http_status(204)
			end
			it "updates items" do
				update_item = Item.find(params['id'])
				expect(update_item.name).to eq("inc")
			end
		end
		context "when item does not exists" do
			let(:item_id){0}
			it "returns status 404" do
				expect(response).to have_http_status(404)
			end
			it "returns record not found" do
				expect(response.body).to match(/Couldn't found Item/)
			end
		end
	end
	describe "delete /todos/:todo_id/items/:item_id" do
		before {delete :destroy,params: {id: item_id,todo_id: todo_id}}
		it "returns status 204" do
			expect(response).to have_http_status(204)
		end
	end
end
