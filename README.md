# RAMP Task

This is the source code for the mobile version of the RAMP Task.

This is a demo version where the data that is recorded is displayed on screen at the end of each trial.

To save the data, use ctrl+a to select the text and then copy and paste that into a text file.

To run this task, or modify it for your own use, you will need to install flutter on your machine,
which you can do by following the instructions here: https://docs.flutter.dev/get-started/install

It will run on a web browser, and also on iOS and Android devices.

Alternatively you can test it on your browser through github pages using this link: https://florencelarkin.github.io/ramp_task/#/

## Code Description

The app was written using Flutter sdk version: 2.7

Task code is in the lib folder

Docs folder is for github pages

Files
‘main.dart’  controls the overall flow of the app: starts the task → practice instructions → practice → task instructions → ‘main_page.dart’ contains task
‘car_engine.dart’ called during task, this class  controls how the car moves, takes input on position and time from main_page
‘data_map_writer.dart’ and ‘device_data_writer.dart’ are classes that write the details for each data file that is recorded after every trial
‘url_args.dart’ pulls out subject id and other variables from individual link
‘data.dart’ sends task data to laureate servers
Operation
If trial failed, trial is restarted, restart_page.dart gives advice why trial failed
If trial passed goes to ‘continue.dart’ → loop main_page to continue_trial for the total number of trials, trials that have to be restarted do not count towards total 
After task is complete, ‘completed_page.dart’ is called and there is a link to exit the task that sends them to LIBR server to complete other tasks 


