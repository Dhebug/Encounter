> [!WARNING]  
> This page contains potential spoilers for the game.  
> If you plan to play the game, you should probably refrain to go farther!
>
> For more information, you can safely read [Encounter.md](../Encounter.md)

# Game design discussion

## The original game
When the original game was released, in 1983, the standard text adventure game on the machine were sharing a number of characteristics:
- You navigate through multiple locations using NSEW directions, and sometimes Up and Down as well
  - It is non uncommon that the relation between the various locations and doors makes no sense from a map point of view
- You have no way to avoid traps: The entire design is based on failing, and learning from failures:
  - What's you command? 
    - East: Some poisoned arrow erupt from the wall. You are dead.
    - North: A hidden trap door opend under your feet. You are dead.
    - West: As you enter the room the door close and starts to fill with acid gaz. You are dead.
    - etc...
- Objects and interactions are often illogical and require testing all possible combinations
- The environment is fantastic and rarely follow the normal rules of our universe:
  - Trapped in the house of a sadistic canibal which is larger inside than outside
  - Investigating a space ship or futuristic laboratory
  - Some Twilight Zone style place filled with robots, orcs, magicians and teleporters
  - Etc...

Compared to most games on the machine, Encounter is quite sane:
- The adventure is in the everyday world (England in the 80ies)
- The player is just a normal investigator without any special gadgets or powers
- The map is mostly consistent and can be imagined as a place that could actually exist
- The actions mostly make sense - at least if you ignore the actual potency of chemical products -

## Modern adventure games
The adventure game genre has never really vanished, and modern implementations of text adventure engines have been released and ported to modern machines, making it easy for anyone to make their own game. All you need to do is to define some "locations", some "items", link and place everything together, define some vocabulary and actions, a few rules, type the descriptions, and there you are.

Some people decided to write their own engine, like Eric Safar when he worked on his Athanor game series on various retro machines, but ultimately it's not the engine that generally dictates how good the game is going to be in the end, it's how it's all linked together.

## Encounter HD
One of my personal pet peves in these games is when the difficulty is artificially created by having non-sensical maps, item used that make no sense, and obscure vocabulary to do the most basic of operations.

So for Encounter I gave myself a few constraints:
- The navigation on the map HAS to make sense:
  - If you came from the previous room by the EAST entrance, then there should be a WEST direction allowing you to go back to the place you came from.
  - Drawing on a map the list of locations and their directions, there should be no crossing lines, it should all make sense.
- The map itself should feel logical:
  - You should not have sequences where you go from the sewers to the forest to the bathroom and finally to the launch-pad for a rocket
  - If you enter what looks like a garden shed, it should not have the equivalent of the Empire State Building number of rooms inside
- The items and how you use them should be possible to guess.
  - Things like "put the flower pot on top of the dog to trigger the opening of the garage door where the submarine is parked" are not acceptable.  
- There should not be immediate and impossible to avoid failure conditions  

So, concretely, how does that translate in the changes made to the original Encounter game?
- In the original game, if you go "east" from the Narrow Path, you immediately fall into the pit which you did not even know was there.
  - I fixed that by adding a new location where the pit is present and clearly shown to the player
- In the original game, if you enter the main hall of the house, there is no way to avoid the dog attacking you if you are not equipped yet
  - In the new version, the dog will let you leave the room if you don't try to access the top stair
- Most of the topology in the original game made sense, but when converting to graphics it made the placement of doors difficult, so I add to change a couple locations to make the connection between the room easier to understand
- A couple places are not following the rules, but it's actually less worse than following them:
  - The gloomy stair case between the kitchen and the basement is shown in a Point Of View of the player despite the kitchen having the stair on the right side and the basement having it on the left side... but since it's changing level, it stays consistent because we use UP and DOWN, and these match just fine. 

