# Subtitles Wrapper

The Subtitle Wrapper package provides an easy way to display subtitles for videos using the VLC player in a Flutter application. It supports multiple subtitle formats and allows for dynamic subtitle delay adjustments.

## Features

- Display subtitles from SRT and WebVTT files.
- Adjust subtitle delay dynamically.
- Customize subtitle text style.

## Getting Started

### Installation

Add the following dependency to your `pubspec.yaml`:


### Usage

1. **Initialize the Subtitle Controller:**

   Create an instance of `SubtitleController` with the desired subtitle URL and type.

   ```dart
   SubtitleController subtitleController = SubtitleController(
     subtitleUrl: 'https://example.com/subtitles.srt',
     subtitleType: SubtitleType.srt,
     subtitleDecoder: SubtitleDecoder.utf8,
   );
   ```

2. **Set up the VLC Player:**

   Initialize the `VlcPlayerController` with the video URL.

   ```dart
   VlcPlayerController vlcPlayerController = VlcPlayerController.network(
     'http://example.com/video.mp4',
     autoPlay: true,
   );
   ```

3. **Use the Subtitles Wrapper:**

   Wrap your VLC player with the `SubtitleWrapper` widget to display subtitles.

   ```dart:lib/subtitle_wrapper.dart
   startLine: 7
   endLine: 48
   ```

4. **Adjust Subtitles Delay:**

   Use the `addSubtitleDelay` and `removeSubtitleDelay` methods to adjust the subtitle delay in milliseconds.

   ```dart:lib/subtitle_controller.dart
   startLine: 72
   endLine: 86
   ```

### Example

Here's a simple example of how to integrate the subtitle wrapper in your Flutter app:



### References

- For more details on the `SubtitleController` and its methods, refer to the code snippet:
  [lib/subtitle_controller.dart](https://github.com/caua-n/subtitles_wrapper/blob/main/lib/subtitle_controller.dart)

- For the complete example setup, see:
  [example/lib/main.dart](https://github.com/caua-n/subtitles_wrapper/blob/main/example/lib/main.dart)