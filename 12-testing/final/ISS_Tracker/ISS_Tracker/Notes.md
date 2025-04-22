# ISS Tracker

## Bugs


## Working On

* Testing


## Manual tests

* Does the map draw?
* Does the ISS appear on the map?
* Can you refresh the data manually?
* If auto refresh is on, does the data refresh regularly and at the expected interval?
* If I move or scroll the map, can I re-center on the ISS?

---

## Specifications - version 1

* Download data using the https://wheretheiss.at/w/developer API
* Display the current location of the ISS using Apple Maps.
* Show detailed information if requested -- velocity, height, country underneath and so on.
* Refresh periodically, allowing user to specify refresh rate or to turn it off.
* Show data using appropriate units. These should be user-configurable in Settings.
* Single window, resizable for compact and unobtrusive display.

## Future Plans

* Add a menu bar component that drops down to show a small map with info.
* Draw the track on the map after multiple updates have been read.
* Show the area of the map that is currently in sunlight.
* Show status text or download progress while downloading data.
