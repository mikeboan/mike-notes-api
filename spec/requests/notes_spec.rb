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
    before { get "notes/#{note_id}" }

    context 'when the note exists' do
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
      let(:note_id) { 99999 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
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
        expect(json['title']).to eq(valid_params['title'])
        expect(json['body']).to eq(valid_params['body'])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      before { post '/notes', params: { title: 'bad note' } }

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
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
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
