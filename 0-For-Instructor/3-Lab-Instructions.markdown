# 202: Swift, Part 3: Lab Instructions

In the demo you got a taste of closures, generics, and enums with associated values.

In this lab, you'll put this theory into action in a real app:

1. You will make the `Grid` class from the Tic-Tac-Toe game generic, so that it is reusable in other games. 
2. You will use closures to improve the game's win-detection logic.

## Making the Grid generic

Open the project from **TicTacToe-1** in the **1-Starter** folder.

If you were in the previous talk on Swift language basics, note that the Tic-Tac-Toe project for this session is slightly different.

Previously, you used a dictionary to keep track of the moves that were made by both players. This was called the “turns” dictionary and it associated positions with players. 

> **Note:** A `Position` is one of the nine squares on the board. A `Player` is either X or O, cross or nought. (You can see these types in **DataStructures.swift**.)

To see where the noughts and crosses are, you could simply look into this dictionary. This works great, but it’s definitely not the only way to solve this problem.

Instead of using a general-purpose dictionary, we can also write our own container type. Let’s call this `Grid`.

![](Images/Grid.png)

The `Grid` object represents a grid of 3x3 squares, exactly like what you see on the screen. In other words, this is a 2-dimensional array of `Player` objects. Each element in that 2-dimensional array directly corresponds with a square on the `Board` view. 

This models our problem domain closer than having a dictionary of `[Position: Player]` objects. It’s not that the dictionary approach was wrong, but I feel this grid is a more accurate description of the problem that we’re trying to solve.

Take a quick look at the source code for **Grid.swift** (see the **Lab** group). It has the following properties:

	let columns: Int
	let rows: Int

	private var array: Array<Player?>

There are properties for the number of columns and rows, so `Grid` is not restricted to just 3x3 squares. The grid can be any size, allowing you to re-use this code for other games that have a larger playing area, such as [Go](https://en.wikipedia.org/wiki/Go_%28game%29).

There is also an array of `Player` objects. Note that `Grid` actually stores *optional* `Player` objects because a grid square can be empty.

Let’s talk about generics. What if you’re making another board game, for example chess? You may want to use this `Grid` object too -- it’s pretty handy for making board games. Except in chess you don’t want to place `Player` values on the grid, you’d use a more complex `ChessPiece` object that also stores whether the piece is a king, queen, pawn, rook, and so on.

So what do you do? You can copy this source file and replace every occurrence of `Player` with `ChessPiece`. But that leads to a bunch of duplicate work. If you're anything like me, you're lazy and you prefer to write code just once and then reuse it over and over. :]

What you can do instead is make `Grid` independent of the type of objects it stores. That’s where generics come in.

Notice how the data type `Player` occurs in many places in **Grid.swift**? To make the `Grid` generic you replace this specific type with a placeholder, `T`.

	struct Grid<T> {

First, add `<T>` in angle brackets behind the name of the type. This tells Swift that `Grid` is now a generic type and that `T` is the name of the placeholder.

Also replace every occurrence of `Player` in **Grid.swift** with that placeholder `T`. And just like that, `Grid` is completely generic, and you can store any type of object in it.

Note: The array should have `T?` objects in it, because it stores optionals. 

Before you can use this new generic `Grid` in the game, you first have to tell it what objects it stores. Switch to **ViewController.swift**.

Xcode gives errors on all the lines that use the `grid` variable. That’s because it doesn’t have enough information to create a new instance of `Grid`. At this point, the placeholder `T` must be filled in with the actual kind of object you intend to use.

Tell the compiler that it’s really a `Grid` of `Player` objects:

	private var grid = Grid<Player>(columns: 3, rows: 3)

All the errors should now be gone.

Note that the `reset()` method has a similar line, but you don't need to write `<Player>` there (although it would be OK if you did). Due to the magic of *type inference*, Swift already knows that `self.grid` is a `Grid` of `Player` objects.

Build and run. The game should still work exactly the same, but you have successfully made the `Grid` type reusable across many other projects. It no longer depends on `Player` objects. 

If you were making a chess game, you’d add this same **Grid.swift** source file to your project and you’d write `Grid<ChessPiece>(columns: 8, rows: 8)` to make a grid that stores `ChessPiece` objects.

That’s the power of generics. They allow you to reuse data structures. In the next section you’ll also see an example of a generic function. That’s a function you can use with many different data types. All in the name of re-use and writing less code.

So how do you know when to make something generic? I tend to start by writing the non-generic version. When I realize I could reuse this object somewhere else, in some other context, I make it generic by replacing specific types – such as `Player` – with a placeholder type `T`. It's really not as difficult as it sounds. :]

## Improving the win-detection logic

Tic-Tac-Toe is a pretty simple game -- the biggest job of the app is to determine whether there is a winner or not. This algorithm is part of the `checkEnd()` method in **ViewController.swift**.

There are two things you can improve here:

1. There is a lot of duplicate code in `checkEnd()`. You can write this much more succinctly by using closures.
2. The logic for checking whether a player has 3-in-a-row can also be used in other games, so you'll make the algorithm re-usable with generics.

You will put your improvements into a new function, `checkWin()`. You can already find a basic version of this function in the file **WinDetection.swift** inside the **Lab** group. (This is a global function in a source file of its own, so that you can easily put it into other projects.)

Uncomment the `checkWin()` function. It should look as follows:

	func checkWin(grid: Grid<Player>, position: Position, player: Player) -> Bool {
	  let row = position.row
	  let column = position.column

	  // TODO: paste code here

	  return rowWin || columnWin || diagonalAWin || diagonalBWin
	}

(It currently has errors. You will fix these in a moment.)

This function takes three parameters:

- `grid` --- Note that the type of this parameter is `Grid<Player>` because `Grid` is now a generic type; you always have to tell the compiler what sort of objects it is made out of.
- `position` --- The row and column where the most recent move was made.
- `player` --- This is the `Player` who made the move.

`checkWin()` returns `true` when this move results in a win -- i.e. the player made 3-in-a-row -- or `false` if it doesn't.

You will now move the code from `ViewController.checkEnd()` into this new `checkWin()` function.

## Refactor ViewController

Go to **ViewController.swift**. From `checkEnd()`, cut the `for` loops that check the rows and columns and diagonals for 3-in-a-row. (Leave the `UIAlertController` stuff.)

Paste this code into the new `checkWin()` function.

In the code you just pasted, replace `lastMove.player` with just `player`. That fixes all the compiler errors in this file.

In **ViewController.swift**, replace the line that says:

	if rowWin || columnWin || diagonalAWin || diagonalBWin {

with:

    if checkWin(self.grid, lastMove.position, lastMove.player) {

(You can also remove the first two lines, `let row = `... and `let column = `...)

Build and run, and make sure everything still works OK.

So far all you did was separate the logic for checking whether there is a winner, from the logic that shows the alert when there is a win or draw. This lets you call the `checkWin()` function from other places, for example to create the brains for a computer-controlled AI player (unfortunately, we don't have time for that in this talk).

## Make `checkWin()` generic

You've seen that types, such as `Grid`, can be generic. But you can also make functions generic. This makes them independent of the type of one or more of their parameters.

In this case, you're going to make `checkWin()` independent of `Player`, so you could theoretically re-use it in another game, such as [Connect Four](https://en.wikipedia.org/wiki/Connect_Four).

The type signature of a generic function looks like this:

	func name<T>(parameter: T) {
	  . . .
	}

The `<T>` after the function name tells Swift that this is a generic function with `T` as the placeholder for the actual type name. 

In **WinDetection.swift**, change the function signature to:

	func checkWin<T>(grid: Grid<T>, position: Position, player: T) -> Bool {

You've added the placeholder type `T` behind the name of the function. You also used `T` to replace the `Player` type of the `grid` and `player` parameters.

This means that `checkWin()` will now work on any instance of `Grid`, regardless of what type of objects the grid actually contains (`Player`, `ChessPiece`, `Candy`, and so on).

Unfortunately, Xcode now gives error messages on these lines:

	if test != player {

The error message is "Cannot invoke != with an argument list of type (T, T)". This means Swift does not have an `!=` operator for this placeholder type `T`. That makes sense, because `T` could be anything!

The `!=` operator doesn't automatically work on all types, only on types that conform to the `Equatable` protocol.

You can use a *type restriction*, so that Swift knows that whatever type you're going to use must at least conform to the `Equatable` protocol. The syntax of a type restriction is `<T: ProtocolName>`, so change the function signature to:

	func checkWin<T: Equatable>(grid: Grid<T>, position: Position, player: T) -> Bool {

Now the errors are gone. You can now use `checkWin()` in any X-in-a-row game you can think of!

Build and run to make sure everything still works.

> **Note:** Here, `T` stands in for the `Player` type, but `Player` is not actually declared as conforming to `Equatable` (see **DataStructures.swift**). So how come this still works? Swift recognizes that `Player` is a simple enum, so it automatically makes it `Equatable`. After all, a variable with the enum value `Player.X` is always equal to any other variable with the enum value `Player.X`.

## Simplify using closures

If you look closely at the `for`-loops in `checkWin()`, you'll notice that they all do the exact same thing except for the way they step through the grid. 

For example, the loop that checks the row steps through the grid horizontally; the loop that checks the column steps through the grid vertically; and the loops for the diagonals step in both directions.

These four loops all follow the same template:

	var win = true
	for i in 0..<3 {
	  if let test = grid[/* ... calculate Position ... */] {
		if test != player {
		  win = false
		  break
		}
	  } else {
		win = false
		break
	  }
	}

The only thing that is different is how they convert the value of the loop counter `i` into a grid position:

	Check row:        Position(column: i,      row: row)
	Check column:     Position(column: column, row: i)
	Check diagonal A: Position(column: i,      row: i)
	Check diagonal B: Position(column: i,      row: 2-i)

All this code duplication seems like something that should be refactored. Instead of having four different loops, you will extract the thing that is different between these loops -- calculating the `Position` values -- and put that into four different closures.

First, declare a `typealias` to make things easier to read:

	private typealias Step = (i: Int, row: Int, column: Int) -> Position

This describes a closure that takes three parameters -- `i`, the loop variable, `row` the current row, and `column` the current column -- and turns these into a new `Position` object. Exactly how that happens depends on the closure.

To begin with, define a closure that steps through the columns of a single row:

	private let horizontal: Step = { i, row, column in Position(column: i, row: row) }

This is exactly what happens in the very first `for` loop. The loop counter `i` is used to step through the columns 0, 1, 2, while the row value remains the same.

> **Note:** This closure does not have a `return` statement, even though it returns a value. When the closure only has a single line you can leave out `return`. It's a little shortcut.

![](Images/Stepping.png)

Because this closure ignores the `column` parameter, you can also write it like so:

	private let horizontal: Step = { i, row, _ in Position(column: i, row: row) }

The wildcard symbol `_` tells Swift that you're not using this parameter.

Now add a second closure. This one steps through the rows 0, 1, 2 of a single column:

	private let vertical: Step = { i, _, column in Position(column: column, row: i) }

This is identical to what happens in the `// Check column` section.

Likewise, you can also create closures for the two diagonals:

	private let diagonalA: Step = { i, _, _ in Position(column: i, row: i) }
	private let diagonalB: Step = { i, _, _ in Position(column: i, row: 2-i) }

To recap: What you've done here is create four closures that convert the value of the loop counter `i` -- and the current `column` and `row` numbers -- into a new `Position` object. Each of those closures does that in a slightly different way, corresponding to the 4 `for`-loops.

Now, if `stepper` is a variable that refers to one of these closures, then this is how you can use it to look at the squares in the grid:

	for i in 0..<3 {
      if let test = grid[stepper(i: i, row: row, column: column)] {
        . . .
      }
    }

If `stepper` is the `horizontal` closure, this steps through positions `(0, row)`, `(1, row)`, and `(2, row)`.

But if `stepper` is the `vertical` closure, this steps through positions `(column, 0)`, `(column, 1)`, and `(column, 2)`.

You don't have to change the loop -- the only thing that changes is which closure you're using.

Now you'll write a new function, `winInDirection()`, that looks at the grid squares in a particular direction and returns `true` if there are 3-in-a-row.

Here is the function in its entirety:

	private func winInDirection<T: Equatable>(grid: Grid<T>, position: Position, player: T, stepper: Step) -> Bool {
	  let row = position.row
	  let column = position.column

	  var win = true
	  for i in 0..<3 {
		if let test = grid[stepper(i: i, row: row, column: column)] {
		  if test != player {
			win = false
			break
		  }
		} else {
		  win = false
		  break
		}
	  }
	  return win
	}

As you can see, this function contains only a single `for` loop. The closure that it uses is passed in through the `stepper` parameter. Note that `winInDirection()` needs to be a generic function too, because it will be called from `checkWin()`.

With all these pieces in place, you can rewrite `checkWin()` to be as simple as this:

	func checkWin<T: Equatable>(grid: Grid<T>, position: Position, player: T) -> Bool {
	  return winInDirection(grid, position, player, horizontal)
		  || winInDirection(grid, position, player, vertical)
		  || winInDirection(grid, position, player, diagonalA)
		  || winInDirection(grid, position, player, diagonalB)
	}

You've replaced the four loops with four calls to the same function, but each time you're passing along a different closure. How cool is that?

Build and run, and make sure the win-detection logic still works OK. Excellent!

The current solution is fine, but you can do even better. Swift allows functions to be nested. That means you can put the `winInDirection()` function *inside* of `checkWin()`, as follows:

	func checkWin<T: Equatable>(grid: Grid<T>, position: Position, player: T) -> Bool {
	  let row = position.row
	  let column = position.column

	  func winInDirection(stepper: Step) -> Bool {
		var win = true
		for i in 0..<3 {
		  if let test = grid[stepper(i: i, row: row, column: column)] {
			if test != player {
			  win = false
			  break
			}
		  } else {
			win = false
			break
		  }
		}
		return win
	  }

	  let rowWin = winInDirection(horizontal)
	  let columnWin = winInDirection(vertical)
	  let diagonalAWin = winInDirection(diagonalA)
	  let diagonalBWin = winInDirection(diagonalB)

	  return rowWin || columnWin || diagonalAWin || diagonalBWin
	}

Notice how `winInDirection()` no longer needs to be declared as private, nor does it need the `position` or `player` parameters because it can grab those from its enclosing scope.

Build and run once more.

Does all of this make sense to you? Let me know if you have any questions!

Congratulations, you now have a `Grid` object that can be reused in many other board games, and a `checkWin()` function that is suitable for many other X-in-a-row games. (If you still have time left, try to change this logic so that it is not limited to just 3 rows and columns.)

You’re ready to continue on to the challenges!
