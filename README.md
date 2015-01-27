Twitter App
=========

Introduction
==========

This is a Simple Twitter app providing two services.

1) Get any user's recent tweets upto 20 tweets.

2) Get a List of common users that Two users follow.


Run the application
=================

1) Clone the github repository "https://github.com/SelvaValluvan/projectTilt.git"

git clone https://github.com/selvavalluvan/projectTilt.git

2) Inside the folder created, install dependencies using CPAN or apt-get.

chmod +x ./installdep.sh
./installdep.sh

Most of them are Dancer dependencies.

3) To run locally execute the app.pl file inside bin.

perl ./bin/app.pl

4) In the browser, go to localhost:3000.

5) Enjoy the app !!


Deployed Version of the App
======================

It is available in  https://evening-eyrie-8562.herokuapp.com/

To Deploy this app in any of your Heroku App
=============================================
1) Navigate to the application folder

 In command line : 
2) heroko login

3) git init

4) git add .

5) git commit -a -m "My app on Heroku"

6) heroku create --stack cedar --buildpack https://github.com/miyagawa/heroku-buildpack-perl.git

7) git push heroku master

It will start deploying the app and dependencies and will give you a appid like a URL at the end and that is the public URL.


Note
======

I am not too good at HTML and CSS stuffs. But I tried.  Pardon me for bad frontend. Please comment on the code and the application. Let me know if any details are needed.

Thanks.
