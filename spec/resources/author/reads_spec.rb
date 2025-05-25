require 'rails_helper'

RSpec.describe AuthorResource, type: :resource do
  describe 'serialization' do
    let!(:author) { create(:author) }

    it 'works' do
      render
      data = jsonapi_data[0]
      expect(data.id).to eq(author.id)
      expect(data.jsonapi_type).to eq('authors')
    end
  end

  describe 'filtering' do
    let!(:author1) { create(:author) }
    let!(:author2) { create(:author) }

    context 'by id' do
      before do
        params[:filter] = { id: { eq: author2.id } }
      end

      it 'works' do
        render
        expect(d.map(&:id)).to eq([author2.id])
      end
    end
  end

  describe 'sorting' do
    describe 'by id' do
      let!(:author1) { create(:author) }
      let!(:author2) { create(:author) }

      context 'when ascending' do
        before do
          params[:sort] = 'id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            author1.id,
            author2.id
          ])
        end
      end

      context 'when descending' do
        before do
          params[:sort] = '-id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            author2.id,
            author1.id
          ])
        end
      end
    end
  end

  describe 'sideloading' do
    # ... your tests ...
  end
end
