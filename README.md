# Scraper

This rails application is used to index, fetch and delete contents of given urls.
The application exposes an API with the following RESTful endpoints:

| HTTP Verb | URI              | Body                      | Method      |
|-----------|------------------|---------------------------|-------------|
|  POST     | api/v1/pages     | url='http://some.url.org' | Create      |
|  GET      | api/v1/pages     |                           | Index       |
|  GET      | api/v1/pages/:id |                           | Show        |
|  DELET    | api/v1/pages/:id |                           | Destroy     |

Response data is formatted in JSON format.

Note: The current version *always* returns JSON formatted responses. 
This can be easily fixed and extended in future versions !

Each of the above methods is described briefly:

__Create:__ expects a url parameter that specifies the url to be indexed.
It scrapes the given url and save url along with content in the database.
Note: There is no Update method - If a record for a given url already exists, 
it just gets updated with the newly scraped content. Otherwise, a new record is created.

Return status codes: 
* 204 on success (empty body)
  * In this case the 'Location' response-header contains the url of the created page
* 422 on error, body contains error message

__Index:__ Fetches all page records from the database 

Return status codes:
* 200 on success (body contains array of page records)

__Show:__ Fetches a single record matching the given id

Return status codes:
* 200 on success (body contains single record)
* 404 id not found (empty body) 

__Destroy:__ Deletes a record matching the given id from the database.

Return status codes:
* 204 on success (empty body)
* 404 id not found (empty body)
* 405 error in record deletion (body contains error message)

The content that is being indexed for a page is the content of the 'h1', 'h2', 'h3' and 'a' tags.
In the response body of the Show and Index methods, each of the above keys is 
mapped to an array of values representing the content of instances of the corresponding tag, in the same order as found.

The application was tested using ruby 2.2.3 

# Runnig the application
* _bundle install_ to install gems
* _bundle exec rake db:migrate_ to migrate the database
* _bundle exec rails s_ to run server

# Examples
One can use _curl_ to test the api:

* Index a page. Upon success, the Location response header will contain the url of the indexed page:
  __curl -i -X POST -d "url=https://en.wikipedia.org/wiki/Main_Page" http://localhost:3000/api/v1/pages__
* Show page with id 1:
  __curl -i http://localhost:3000/api/v1/pages/1__
* Index all pages:
  __curl -i http://localhost:3000/api/v1/pages__
* Delete page with id 1:
  __curl -i -X DELET http://localhost:3000/api/v1/pages/1__

