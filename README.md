Mycelial: A Rails app for a pinterest-style social network. 
=========

This is great for a visual CV social network and or a portfolio social network. The pages are linked together via a tagging system. There is a main feed and tag-specific feeds. Each users posts are also related to similar posts via the sporeprint algorithm, which matches it to other posts based on correlation (number of tag matches). Mycelial has nested comments, a like system, notifications, amazon s3 uploads and picture cropping, and much more. 

See the demo: [http://www.mycelial.com/](http://www.mycelial.com/)

### Features: 

An example user profile page. Great for a visual CV/Portfolio.

![mycelial](https://github.com/damian-sowers/mycelial/raw/master/app/assets/images/landing_page/browser-landing.png)

* Page caching with memcachier, dalli and redis
* Devise user management
* Uploads to s3 with carrierwave and fog
* Some tag management functionality is given with acts-as-taggable on gem
* Delayed jobs can be used with resque. (not currently running with the demo. But is already configured for use. Have some demo jobs in the workers folder)
* Foreman is used to run the development server (just need to make your own .env file)
* Unicorn and postgres are used for production server environment

### License:

Mit