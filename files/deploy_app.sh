#!/bin/bash
# Copyright (c) HashiCorp, Inc.

# Script to deploy a very simple web application.
# The web app has a customizable image and some text.

cat << EOM > /var/www/html/index.html
<html>
  <head>
    <title>GLUE</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        color: #333;
        text-align: center;
        padding: 20px;
      }
      .container {
        width: 800px;
        margin: 0 auto;
        background-color: #fff;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
      }
      h2 {
        color: #ff6347;
      }
      img {
        max-width: 100%;
        height: auto;
        border-radius: 8px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <!-- BEGIN -->
      <center><img src="https://plug-img-bucket.s3.us-west-1.amazonaws.com/KakaoTalk_Photo_2024-05-24-13-54-42.jpeg"></img></center>
      <h2>Meow World!</h2>
      Welcome to Team DoTheZ!
      <!-- END -->
    </div>
  </body>
</html>
EOM

echo "Script complete."