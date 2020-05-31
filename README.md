![banner](https://i.imgur.com/FuMpPBk.png)

# Crash Team Racing - Godot

## Description
Godot version: 3.2.2 beta 3

This project has the objective to mimic crash team racing 1999 physics and kart handling.
I'll do my best to get as close as possible.

This is only possible with the help of CTR-Tools Guys which are decompiling the game
and have a lot of technical details about the game.


## Screenshots

https://i.imgur.com/PMa81fm.mp4
https://imgur.com/7Oce0Ov.mp4

## Controllers
* WASD - Move
* U - Camera close/far
* Hold I - Camera front
* Hold Space - slow motion
* M - Reset Game
* K - Start a video in the top-left corner (used to compare with original game) videos folder is not included, if you want to help I can include then in future updates.
* J/K - equivalent to R1/L1

**How to Test**
* Open Godot 3.2.2 beta 3
* open the project
* start scene **gameplay/lev_sewer.tscn**
* Press F6

## CHANGELOG
**0.3.0**
* Added Jump
* Added PowerSliding (not even close to original game)
* Speedometer now shows powersliding meter
* Added proper collision to sewer speedway
* Added Tiremarks


**0.2.1**
* Corrected uphill speed lose
* Added SpeedData
- SpeedData contains the official values used in CTR 1999
- MT are powerslide / SF - Saffi fire / USF - Ultra Saffi fire
- Thanks to **baguete** for making the research  

**0.2.0**
* Added Speedometer

**0.1.0**
* Added a new kart model (better one with less polygons)
* Tire handling
* Improved game physics
* Improved kart handling
* Camera Change

