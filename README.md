# space-invaders

A simple video game on an FPGA.

## Gameplay

- The player starts with 3 lives. Each time the player is hit by a missile, one life is lost. 
The player loses when no more lives remain.
- The player's score is increased by one each time an invader is shot down. 
The player wins the game when no more invaders remain.

## Hardware

- Nexys3 Spartan 6 FPGA board
- Left and right buttons for player movement
- Shoot button for the player's laser
- Reset button that returns the game to its initial state at any point
- 3 seven-segment displays for the player's lives and score count
- External monitor to display the game via VGA output

## Implementation

Read more about the game implementation [here](https://tchieu.com/projects/space-invaders/).