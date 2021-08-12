class V1::QuestionsController < ApplicationController
  def search
    questions = Question.search params[:q], star: true
    render json: { items: ActiveModel::SerializableResource.new(questions, each_serializer: QuestionSerializer).as_json }, status: :ok
  end

  def show
    @question = Question.find(params[:id])
    render json: { data: QuestionSerializer.new(@question, scope: { user_id: current_user.id }).as_json, klass: "Question" }, status: :ok
  end

  def index
    questions = Question.all
    render json: { data: ActiveModel::SerializableResource.new(questions, user_id: current_user.id, each_serializer: QuestionSerializer, scope: { user_id: current_user.id }).as_json, klass: "Question" }, status: :ok
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      Tagging.extract_tags(params[:tags], "Question", @question.id)
      render json: { data: QuestionSerializer.new(@question).as_json, klass: "Question" }, status: :ok
    end
  end

  def update
    @question = Question.find(params[:id])
    Tagging.extract_tags(params[:tags], "Question", @question.id)
    if @question.update_attributes(question_params)
      render json: { data: QuestionSerializer.new(@question).as_json, klass: "Question" }, status: :ok
    end
  end

  def destroy
    @question = Question.find(params[:id])
    if @question.destroy
      render json: { data: @question, klass: "Question" }, status: :ok
    else
      render json: { data: @question.errors.full_messages }, status: :ok
    end
  end

  def question_params
    params.require(:question).permit!
  end
end
