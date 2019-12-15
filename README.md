# Tetris-68000

## Tetris done for processor MOTOROLA 68k

This is a aplication designed for the emulator [easy68k](http://www.easy68k.com/) to use it inside the emulator must be activated the exceptions so can be operated.

Current build state: **PASSED** 

## Controls:

 - ARROW UP    🠦 rotate the tetromino.
 - ARROW DOWN  🠦 drop faster the tetromino.
 - ARROW LEFT  🠦 move to the left the tetromino.
 - ARROW RIGHT 🠦 move to the right the tetromino.
 - SPACE       🠦 drop down the tetromino.
   
## Sound:

By default the music and sound are disabled. They can be enabled by changing in [TETRIS/CONST.X68](https://github.com/FelixAguilar/Tetris-68000/blob/master/TETRIS/TETRIS/CONST.X68) the constants MUSIC and SOUND to 1. It must be noticed that it can not be music and sound played at the same time so if both are active only music will be played, if only the sound is enabled then will be this one. And finally if both are disabled no sound will be executed.

## Features:

This are the features added inside the aplication if they are checked means that are included.

 - Graphics:
   - [x] Menu interface with instructions.
   - [x] Game over interface.
   - [x] Next tetromino.
   - [ ] Animations when a line is cleared.
 - Sound:
   - [x] Gameboy melody.
   - [x] Sounds when actions are executed.
   - [x] Posibility of disable the audio.
 - Game features:
   - [x] Score
   - [ ] Score rank
   - [ ] Random tetrominos
   
This aplication has been designed and implemented by @FelixAguilar
