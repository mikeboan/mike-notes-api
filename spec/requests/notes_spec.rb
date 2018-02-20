require 'rails_helper'

RSpec.describe 'Notes API', type: :request do
  let!(:notes) { create_list(:note, 10) }
  let(:note_id) { notes.first.id }

  describe 'GET /notes' do
    before { get '/notes' }

    it 'returns notes' do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /notes/:id' do

    context 'when the note exists' do
      before { get "/notes/#{note_id}" }

      it 'returns the note' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json['id']).to eq(note_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the note does not exist' do
      it 'returns status code 404' do
        expect { get '/notes/9999' }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST /notes' do
    let(:valid_params) do
      { note: { title: 'new note title', body: 'new note body' } }
    end

    context 'when request is valid' do
      before { post '/notes', params: valid_params}

      it 'creates a note' do
        json = JSON.parse(response.body)
        expect(json['title']).to eq(valid_params[:note][:title])
        expect(json['body']).to eq(valid_params[:note][:body])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      before { post '/notes', params: { note: { title: 'bad note' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end

    describe 'PUT /notes/:id' do
      let(:valid_params) do
        { note: { title: 'edited note title' } }
      end

      context 'when the record exists' do
        before { put "/notes/#{note_id}", params: valid_params }

        it 'updates the note' do
          expect(JSON.parse(response.body)['title']).to eq(valid_params[:note][:title])
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
    end

    # Test suite for DELETE /notes/:id
    describe 'DELETE /notes/:id' do
      before { delete "/notes/#{note_id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
