class NotesController < ApplicationController

  def index
    @notes = Note.all
    render json: @notes, status: 200
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      render json: @note, status: 201
    else
      render json: @note.errors.full_messages, status: 422
    end
  end

  def show
    @note = Note.find(params[:id])
    render json: @note, status: 200
  end

  def update
    @note = Note.find(params[:id])
    if @note.update(note_params)
      render json: @note, status: 200
    else
      render json: @note.errors.full_messages, status: 422
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    render json: @note, status: 204
  end

  private
  def note_params
    params.require(:note).permit(:title, :body)
  end
end
