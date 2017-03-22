1. Run program by typing rackup url_short_app.ru
2. Need to input url to be shortened as post request. This can be achieved by using postman chrome extension or by curl method.
   #ex: curl --request POST 'http://localhost:9292/urls/set_url' --data "url=amazon.com".
3. Once your post request has done, visit http://localhost:9292/urls where url and shortened urls will be listed.
4. Get the shortened url from above list and search http://localhost:9292/urls/shortened_url, you will be redirected to the original url.

