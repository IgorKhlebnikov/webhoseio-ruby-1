webhose.io client for Ruby
============================
A simple way to access the [Webhose.io](https://webhose.io) API from your Ruby code

```ruby
    require 'webhoseio'

    client = Webhoseio.new(YOUR_API_KEY)
    output = client.query("filterWebData", {"q":"github"})
    puts output['posts'][0]['text'] # Print the text of the first post
    puts output['posts'][0]['published'] # Print the text of the first post publication date

    # Get the next batch of posts
    output = client.get_next()
    puts output['posts'][0]['thread']['site'] # Print the site of the first post
```

API Key
-------

To make use of the webhose.io API, you need to obtain a token that would be
used on every request. To obtain an API key, create an account at
https://webhose.io/auth/signup, and then go into
https://webhose.io/dashboard to see your token.


Installing
----------
You can install from source:

``` bash

    $ git clone https://github.com/seenkoo/webhoseio-ruby
    $ cd webhoseio-ruby
    $ gem build webhoseio.gemspec
    $ gem install ./webhoseio-*.gem

 ```
 Or use gem install:

 ``` bash
    $ gem install webhoseio
 ```

Use the API
-----------

To get started, you need to require the library, and instantiate an API-client with your access token.
(Replace YOUR_API_KEY with your actual API key).

```ruby

    >>> require 'webhoseio'
    >>> client = Webhoseio.new(YOUR_API_KEY)
```

**API Endpoints**

The first parameter the query() function accepts is the API endpoint string. Available endpoints:
* filterWebData - access to the news/blogs/forums/reviews API
* productSearch - access to data about eCommerce products/services
* darkWebAPI - access to the dark web (coming soon)

Now you can make a request and inspect the results:

```ruby
    >>> output = client.query("filterWebData", {"q":"github"})
    >>> output['totalResults']
    15565094
    output['posts'].size
    100
    >>> output['posts'][0]['language']
    'english'
    >>> output['posts'][0]['title']
    'Putting quotes around dictionary keys in JS'
```


For your convenience, the ouput object is iterable, so you can loop over it
and get all the results of this batch (up to 100).

```ruby
    >>> output['posts'].inject(0) do |total_words, post|
    ...   total_words + post['text'].split.size
    ... end
    8822
```

Full documentation
------------------

* ``initialize(token)``

  * token - your API key

* ``query(end_point, params)``

  * end_point:
    * filterWebData - access to the news/blogs/forums/reviews API
    * productSearch - access to data about eCommerce products/services
    * darkWebAPI - access to the dark web (coming soon)
  * params: A key value dictionary. The most common key is the "q" parameter that hold the filters Boolean query. [Read about the available filters](https://webhose.io/documentation).

* ``get_next()`` - a method to fetch the next page of results.


Polling
-------

If you want to make repeated searches, performing an action whenever there are
new results, use code like this:

```ruby
    loop do
      res = client.query("filterWebData", {"q":"skyrim"})
      res['posts'].each do |post|
        perform_action(post)
      end
      sleep(0.3)
    end
```
