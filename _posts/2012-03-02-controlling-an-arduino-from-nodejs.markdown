---
layout: post
title: Controlling an Arduino from Node.js
date: 2012-03-02 15:08:00
description: You can communicate with an Arduino microcontroller using Node.js very easily--here's how.
---

After expressing an interested in learning microcontroller programming, a friend of mine purchased for me an [Arduino Duemilanove](http://arduino.cc/en/Main/arduinoBoardDuemilanove), which arrived yesterday. Being someone who enjoys web programming, I of course wasted no time in figuring out how I could get it connected to a web page. I opted to use [Node.js](http://nodejs.org/) for my integration.

To communicate with the microcontroller, I used [node-serialport](https://github.com/voodootikigod/node-serialport), which allows you to make a connection to a serial port for reading and writing. For this test, I wrote a sketch to turn the onboard LED on pin 13 off when a `0` is read from the serial connection, and to turn the LED on when a `1` is read. The contents of this sketch follows; just upload it to your Arduino.

{% gist 1962067 00-sketch.c %}

Next up, we need to send a `0` or `1` byte to the Arduino from Node; here's a short CoffeeScript program that will blink the LED every second (I've hardcoded the device where my Arduino lives; substitute your own).

{% gist 1962067 01-blink.coffee %}

From here, it's not difficult to adapt this example into a more complete sample including a web server. Here's a complete listing of my program, including a web page to access at the root URL to control the LED using jQuery Ajax requests.

{% gist 1962067 02-server.coffee %}

{% gist 1962067 03-index.htm %}

Start the server and visit `http://localhost:8080` and click the buttons to control the lights!
