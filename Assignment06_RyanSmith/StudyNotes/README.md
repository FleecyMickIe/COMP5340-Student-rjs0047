# StudyNotes

An iPhone app that uses on-device text recognition to turn photos of notes into organized study notes.

## Run the App

1. Download or clone this repository.
2. Open `StudyNotes.xcodeproj` in Xcode.
3. Select an iPhone simulator running iOS 26.5 or later.
4. Press Command-R to run the app.

## Test Text Recognition

1. In Finder, open the project folder and navigate to:
   `StudyNotes/Assets.xcassets/SampleNote.imageset`
2. Drag `SampleNote.png` onto the running iPhone simulator.
   This adds the image to the simulator’s photo library.
3. In StudyNotes, tap **Scan Notes from Photo**.
4. Select the sample image.
5. Review or edit the recognized text.
6. Enter a title, choose a course, and tap **Save Note**.

You can also tap **Try Sample Note** to recognize the bundled image directly without importing it into Photos.

## Manage Notes

- Filter saved notes by course.
- Tap a note to read its full text.
- Swipe left on a note to delete it.
