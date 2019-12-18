require 'rails_helper'

RSpec.describe TodosController, type: :controller do
	let!(:todos){create_list(:todo,10)}
	let(:todo_id){todos.first.id}
	describe 'GET#todos' do
		before { get :index }
		it 'returns todos' do
			expect(json).not_to be_empty
			expect(json.size).to eql(10)
		end
		it 'returns status code 200' do
			expect(response).to have_http_status(200)
		end
	end
	describe 'GET /todos/:id' do
		before{get "show",params: {id: todo_id}}
		context 'when record exists' do
			it "returns todo" do
				expect(json).not_to be_empty
				expect(json['id']).to eq(todo_id)
			end
			it "returns status code 200" do
				expect(response).to have_http_status(200)
			end
		end
		context "when record not found" do
			let(:todo_id){100}
			it "shoud return 404 status" do
				expect(response).to have_http_status(404)
			end
			it "return not found error" do
				expect(response.body).to match(/Couldn't find Todo/)
			end
		end
	end
	describe 'post /todos' do
		let(:valid_attrs){{title: 'samy',created_by: 1}}
		context "when the request is valid" do
			before{post :create,params: valid_attrs}
			it "should create to do" do
				expect(json['title']).to eq("samy")
			end
			it "returns status code 201" do
				expect(response).to have_http_status(201)
			end
		end
		context "when request not valid" do
			before{post :create, params: {title: "test"}}
			it "returns status code 422" do
				expect(response).to have_http_status(422)
			end
			it "returns validation error" do
				expect(response.body).to match(/Validation failed: Created by can't be blank/)
			end
		end
	end
	describe 'put /todos/:id' do
		let(:valid_attrs){{id: todo_id,title: 'kannan'}}
		context "when reord found" do
			before{put :update,params: valid_attrs}
			it "update record" do
				expect(response.body).to be_empty
			end
			it "status code 204" do
				expect(response).to have_http_status(204)
			end
		end
	end
	describe 'delete /todos/:id' do
		before {delete :destroy,params:{id: todo_id}}
		it "delet record" do
			expect(response).to have_http_status(204)
		end
	end
end
