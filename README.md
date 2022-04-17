# recursify

Flutter Windows Application to create videos consisting of recursively generated frames.

## Setup

To use the application, the [FFMPEG CLI](https://ffmpeg.org/download.html#build-windows) for Windows must be installed.

## Usage

Open the app, choose an image from your file system, follow through the three steps in the 'Editor'-tab, press the export button on the export page and wait for the video render to finish.
Will export png files of every recursive frame and use that to generate the next frame. After all frames are rendered, the video will be saved to your file system as an mp4 file using ffmpegs command line interface (windows only).

