This is game of **Yam** (or [Yahtzee](https://en.wikipedia.org/wiki/Yahtzee)) made using **Godot 4**, for now only available in French.
It can be played in local multiplayer (every player takes turn playing a round) up to 6 players. (Can easily be modified in code if you wish to do so).

The rules are slightly different than the standard ones, as they are the ones we used to play with in my family.

## Scoring

The **basic hands** are easy, for values 1 to 6, you can score the sum of the dice of your hand with the corresponding value.
At the end of the game, if the player has at least 63 points in the basic/standard hands, they will get a bonus of 37 points.

Now for the **special hands**:

- The small straight (petite suite) is obtained when the player has the hand "1, 2, 3, 4, 5" and is worth 30 points.
- The large straight (grande suite) is obtained when the player has the hand "2, 3, 4, 5, 6" and is worth 30 points.
- The three of a kind (brelan) is obtained when the player has at least three of the same die. It is worth the sum of all the dice.
- The full house (full) is obtained when the player has a three of a kind and a pair at the same time (Yam included). It is worth 25 points.
- The four of a kind (carré) is obtained when the player has at least four of the same die. It is worth 40 points.
- The Yam is obtained when the player has five of the same die. It is worth 50 points.
- The plus goes hand to hand with the minus: If the minus hasn't been played yet, or if the sum of all the dice is greater or equal to the minus, the plus is worth said sum.
- The minus (moins) goes hand to hand with the plus: If the plus hasn't been played yet, or if the sum of all the dice is lower or equal to the plus, the minus is worth said sum.

**NB**: All of these scoring rules can be found in game by hovering over the name of a hand.








## Assets : 

Dice assets by DANI MACCARI (see https://dani-maccari.itch.io/)

Background art from vecteezy.com

Dice sounds from elevenlabs.io

Click sound from pixabay.com
