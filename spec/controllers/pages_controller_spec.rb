describe PagesController do

  describe 'POST create' do

   before do
     @page = Page.new
     allow(Page).to receive(:scrape).and_return(@page)
   end

   it "has 204 status on success" do
     allow(@page).to receive(:save).and_return true
     post :create
     expect(response.status).to eq(204)
   end

   it "has 422 status on error" do
     allow(@page).to receive(:save).and_return false
     post :create
     expect(response.status).to eq(422)
   end

  end

  describe 'GET show' do

    before do
      create_pages(1)
    end

    let(:page) { Page.first }

    it "has 200 status on success, and json body" do
      get :show, params: { id: page }
      expect(response.status).to eq 200
      expect(response.body).to eq page.to_json
    end

    it "has 404 status on non existing id" do
      get :show, params: { id: page.id + 1 }
      expect(response.status).to eq 404
    end
  end

  describe 'GET index' do
    before do
      create_pages(5)
    end

    it "has 200 status, and body consist of pages in json format" do
       get :index
       expect(response.status).to eq 200
       expect(response.body).to eq Page.all.to_json
    end
  end

  describe 'DELETE destroy' do

    before do
      create_pages(1)
    end

    let(:page) { Page.first }

    it "has 204 status on sucess, and number of record decreases by one" do
      delete :destroy, params: { id: page }
      expect(response.status).to eq 204
      expect(Page).to be_none
    end

    it "has 404 for non existing page, and number of records does not change" do
      delete :destroy, params: { id: page.id + 1 }
      expect(response.status).to eq 404
      expect(Page.count).to eq 1
    end
  end


  # Helper method that creates distinct page records in the database
  def create_pages(num)
    num.times do |i|
      Page.create(url: "http://www.uri_#{i}.com", 
                  content: {"h1"=>["a#{i}","b#{i}"], "h2"=>["c#{i},d#{i}"], "h3"=>["e#{i}","f#{i}"], "a"=>["g#{i}","h#{i}"] })
    end
  end
end
