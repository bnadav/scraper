describe PagesController do

  describe 'POST create' do

   before do
     @pg = Page.new
     allow(Page).to receive(:scrape).and_return(@pg)
   end

   it "has 204 status on success" do
     allow(@pg).to receive(:save).and_return true
     post :create
     expect(response.status).to eq(204)
   end

   it "has 422 status on error" do
     allow(@pg).to receive(:save).and_return false
     post :create
     expect(response.status).to eq(422)
   end

  end

  describe 'GET show' do

    before do
      create_pages(1)
    end

    it "produces json response for given id" do
      p1 = Page.first
      get :show, id: p1
      expect(response.status).to eq 200
      expect(response.body).to eq p1.to_json
    end
  end

  describe 'GET index' do
    before do
      create_pages(5)
    end

    it "produces json response for all pages in store" do
       get :index
       expect(response.status).to eq 200
       expect(response.body).to eq Page.all.to_json
    end
  end


  def create_pages(num)
    num.times do |i|
      Page.create(url: "http://www.uri_#{i}.com", 
                  content: {"h1"=>["a#{i}","b#{i}"], "h2"=>["c#{i},d#{i}"], "h3"=>["e#{i}","f#{i}"], "a"=>["g#{i}","h#{i}"] })
    end
  end
end
