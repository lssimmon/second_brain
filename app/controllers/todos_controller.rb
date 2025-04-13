class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]
  before_action :resume_session

  # GET /todos or /todos.json
  def index
    @todos = Todo.where(user_id: Current.user.id)
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @new_todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos or /todos.json
  def create
    @new_todo = Todo.new(todo_params)
    @new_todo.user_id = Current.user.id
    if @new_todo.save
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.append("todo-list", partial: "todos/todo", locals: { todo: @new_todo }), # Add the new todo to the list
            turbo_stream.replace("new-todo-form", partial: "todos/form", locals: { todo: Todo.new }) # Render a new form for the next todo
          ]
        }
      end
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @new_todo.errors, status: :unprocessable_entity }
    end
  end
  
  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    @todo = Todo.find(params[:id])
    @todo.update(todo_params)
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy!

    respond_to do |format|
      format.html { redirect_to todos_path, status: :see_other, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.expect(todo: [ :description, :completed ])
    end
end

