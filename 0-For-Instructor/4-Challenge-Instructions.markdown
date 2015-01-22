# 202: Swift, Part 4: Challenge Instructions

We have two challenges for you:

A. The first challenge practices your closure skills. You'll use a closure to replace the game's delegate protocol.

B. In the second challenge you will associate an image with the `Player` enum. You've already seen how to do this in the playground, but now it's your turn!

## Challenge A: Replace the delegate with a closure

The `Board` class is the view that draws the Tic-Tac-Toe pieces and handles taps. It has a delegate protocol, `BoardDelegate`, with a single method, `board(didPressPosition)`.

When the user taps on one of the grid squares, `Board` converts the touch coordinates to a `Position` object and calls the `board(didPressPosition)` method.

The `ViewController` is the delegate for `Board` and implements that method. Inside that method is where most of the game logic happens.

Your job is to replace this delegate protocol with your own closure. The idea here is that `Board` now calls this closure -- instead of the delegate method -- whenever the user taps in the grid.

### 1) Board.swift

In **Board.swift**, remove the `BoardDelegate` protocol. Also remove the line:

	var delegate: BoardDelegate?

Instead you'll add a variable of the type:

	((Position) -> Void)?

Call this variable `touchHandler`. Just like the old `delegate` variable it’s an optional, because it is `nil` until someone actually fills this in.

The type of the closure is `(Position) -> Void`, meaning it takes a `Position` parameter and does not return a value ("void"). The `Position` refers to the grid square the user just tapped on.

The whole thing is wrapped inside a second set of parentheses, so it can be made optional. If you didn’t use the parentheses but wrote it like this,

	(Position) -> Void?

then it would try to return an optional Void, which doesn’t make any sense.

If you want to make this easier to read, you can use a typealias:

	typealias TouchHandler = (Position) -> Void

You can put this typealias outside the `Board` class, or inside. (Inside is better because it avoids possible namespace collisions.)

The type of the `touchHandler` variable then becomes:

	TouchHandler?

There’s only one place in the code that called the old delegate method, in `touchesEnded()`. Inside that method, replace the line that calls the delegate with:

	self.touchHandler?(Position(column: col, row: row))
 
This creates a new `Position` object for the row and column where the user tapped and passes it to the closure that is stored in the `touchHandler` variable, if any. 

Remember, to invoke a closure you use the same syntax as calling a function. The question mark is necessary because `touchHandler` is an optional.

This technique is known as *optional chaining*. If no closure was placed into `touchHandler` -- it is still nil -- then nothing happens. (You could also use `if let` to unwrap the variable, but optional chaining is a handy shortcut.)

### 2) ViewController.swift

Previously, `ViewController` implemented the delegate method. Now it needs to provide this new closure. 

There is currently a compiler error in `viewDidLoad()` because it tries to assign to `Board`’s `delegate` property which no longer exists.

Instead, create a new closure and give it to the `Board`'s new `touchHandler` property:

	self.board.touchHandler = { position in  
	}

The closure is empty for now. It's up to you to finish writing this closure so that the game properly handles taps again.

Good luck!

Tip: Remember that closures capture their environment. Because the closure refers to instance variables and methods from `ViewController`, the closure captures the value of `self`. Swift demands that you explicitly write `self` in those cases or it won't accept the closure.

## Challenge B: Associate an image with the Player enum

In **Board.swift** there is the `imageForPlayer()` method to obtain the `UIImage` for drawing a player. 

Let’s assume the game is now online multiplayer and players can pick their own avatars that are used instead of the noughts and crosses. Then this code obviously isn’t good enough anymore.

Your job is to associate this avatar image with the `Player` enum. To keep things simple, you're only going to do this for player X right now, but the steps for player O are exactly the same.

### 1) Give the enum an image

First some preliminaries. In **DataStructures.swift**, change case X to:

	case X(avatar: UIImage)

This tells the enum that case X has a `UIImage` object associated with it.

Remove the `opposite()` function from `Player`. This function no longer works because player O doesn’t know what the avatar is of player X. In other words, to construct a new `Player.X` value you now always have to provide a `UIImage`.

In **ViewController.swift**, add the following two properties:

	private let playerX = Player.X(avatar: UIImage(named: "X")!)  
	private let playerO = Player.O

This makes two player objects, `playerX` and `playerO`. The avatar image is now associated with the instance stored in `playerX`, and you can ask for it back later.

Change the line that defines the `player` variable to:

	private var player: Player

This variable points at the active player. Change `init(coder)` to initialize it and make it point at player X:

	required init(coder aDecoder: NSCoder) {  
	  self.player = self.playerX  
	  super.init(coder: aDecoder)  
	}

Also add the `oppositePlayer()` method; this replaces the `opposite()` method you removed earlier.

	private func oppositePlayer() -> Player {  
	  switch player {  
	  case .X:  
		return playerO  
	  case .O:  
		return playerX  
	  }
	}

This is pretty straightforward: if the active player is X we return `playerO`, and vice versa.

Where the code still calls `self.player.opposite()`, change it to use this new method.

### 2) Equality for all

There is one more problem. Swift no longer allows you to call `checkWin()` on a `Grid` made of `Player` objects. 

Recall how `checkWin()` has a type restriction:

	func checkWin()<T: Equatable>(. . .)

Previously, `Player` was a simple enum and those are always `Equatable`. Now, however, the X case has a `UIImage` associated with it, and as a result Swift doesn’t know how to compare different `Player` values anymore.

An enum with associated values is not automatically `Equatable` and you can no longer use `==` and `!=` to compare `Player` instances. 

The fix is to implement the `Equatable` protocol and the `==` operator. By making `Player` conform to `Equatable` you tell Swift that it can be compared again using the `==` and `!=` operators. 

> **Note:** You only need to supply the `==` operator function and then Swift automatically provides `!=`.

In **DataStructures.swift**, add the `Equatable` protocol to `Player`.

The `Equatable` protocol requires that you add this function (below the `Player` enum):

	func ==(lhs: Player, rhs: Player) -> Bool {
	  // code goes here
	}

See if you can implement this function by yourself. It should return `true` if the `lhs` (left-hand-side) and `rhs` (right-hand-side) parameters refer to the same player, and `false` if they are different players.

In other words, `==` is `true` if both `lhs` and `rhs` are `.X`, or if both `lhs` and `rhs` are `.O`. But if one is `.X` and the other is `.O`, this function must return `false`.

Give it a shot. Tip: Because this enum has associated values, you cannot use `if` to compare them -- you always have to use a `switch`.

Scroll down to check your answer.

.

.

.

.

.

.

Here is a possible solution:

	func ==(lhs: Player, rhs: Player) -> Bool {
	  switch (lhs, rhs) {
	  case (.X, .X):
		return true
	  case (.O, .O):
		return true
	  default:
		return false
	  }
	}

The `switch` statement in Swift is very powerful. Here you combine the `lhs` and `rhs` value into a new *tuple*, and then match the values from that tuple against different patterns. Pretty slick, eh?

### 3) Drawing the image

In **Board.swift**, change the code in `imageForPlayer()` so that it uses the `UIImage` associated with player X. For player O, use `UIImage(named: "O")`.

Tip: When dealing with enums with associated values you always need to use a `switch` to read the value. 

To test if this really works, in **ViewController.swift**, change the code that creates `playerX` to use a different image:

	private let playerX = Player.X(avatar: UIImage(named: "Ray")!)  

(If you still have time left, then also try to associate a username with player X, and show this username in the alert when player X wins. Good luck!)

Congrats! You have completed the challenges for this session.
