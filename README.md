# driving_task


Data Interpretation:

[['time in milliseconds since task started', 'slider position (slider value scaled from -1 to 1)', 'car position', 'car velocity', 'event code'], [...],]

A list is created every time there is a change in the slider position, and is added to the list that becomes the final data output.


## Compiling for web without minified code
```
flutter build web --profile --dart-define=Dart2jsOptimization=O0
```
