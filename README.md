# SliderPuzzle (IOS App)

### Key decisions

I used the **view/viewController/Model** pattern. That pattern separates the UI from the logic and the data acquisition. For this I used several classes; each of them belongs to one of this types:

* Tile class is used for every of the individual sections of the image. Class GameModel creates the appropriate group of these elements and initializes them. Both classes form the coreData of the app.

* GameViewController contains the logic of the game itself. It receives the data from the GameModel.

* The visual part is mostly built in the Main.Storyboard, except for the tiles that are created programmatically.

Regards the creation of the tiles I decided to do it dynamically from an image. A method contained in GameModel creates the number of pieces of the original image selected by the user.

I made special efforts designing the UI within the time I had, allowing the user to choose different options and showing certain feedback at the end of the game.

Because of the lack of the time I had to put aside the testing, which I have fulfilled just in an informal way.

### Main problems

I made a bad decision when I confronted the problem of choosing the class I was going to use to manage the tiles. After certain amount of time trying to develop the idea I had to drop it and choose another one. I finally solved it by creating the matrix through the use of loops, one tile at a time.

I also had minor difficulties implementing the movement of the cells because the gestures could be so fast that skipped the boundaries imposed. I solved that by controlling the movement when reaching said boundaries.

These project was also the first time I used certain gesture recognizers so I had to learn to manage them by the way.
