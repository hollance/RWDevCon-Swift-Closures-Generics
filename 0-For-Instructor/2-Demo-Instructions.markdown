# 202: Swift, Part 2: Demo Instructions

In this demo, you will use a playground to experiment with generics, closures, and enums with associated values.

The steps here will be explained in the demo, but here are the raw steps in case you miss a step or get stuck.

## 1) Closures

Open the **Demo.playground** from the **1-Starter** folder.

Put the `countOccurrences()` function into the class. Remove the `array` parameter:

	class MyClass {
	  . . .

	  func countOccurrences(value: Int) -> String {
		var count = 0
		for element in array {
		  if element == value {
			++count
		  }
		}
		return "\(value) appears \(count) times"
	  }
	}

Call this method:

	myObject.countOccurrences(999)

It should give the same results as the function ("999 appears 4 times").

Copy-paste the function parameters and body, but not the name, and assign it to a new variable:

	let c = (value: Int, array: [Int]) -> String {
	  var count = 0
	  for element in array {
		if element == value {
		  ++count
		}
	  }
	  return "\(value) appears \(count) times"
	}

This won't work yet. You have to make a few syntax changes:

	let c: (value: Int, array: [Int]) -> String = {

Add the closure's parameters inside the curly brackets:

	(value: Int, array: [Int]) -> String in

Remove the labels in the closure's type:

	let c: (Int, [Int]) -> String = { . . .

Call the closure:

	c(999, myArray)

It should give the same results as before ("999 appears 4 times").

Add the following method to the class:

	func performClosure(value: Int, closure: (Int, [Int]) -> String) -> String {  
	  return closure(value, array)  
	}

Pass the `c` closure to this method:

	myObject.performClosure(999, closure: c)

Again you should get the same results.

Write a new inline closure:

	myObject.performClosure(100, closure: { (value: Int, array: [Int]) -> String in  
	  var newArray = [Int]()  
	  for element in array {  
		newArray.append(element + value)  
	  }
	  return newArray.description  
	})

Use trailing syntax to put the closure behind the method call:

	myObject.performClosure(100) { (value: Int, array: [Int]) -> String in  
	  var newArray = [Int]()  
	  for element in array {  
		newArray.append(element + value)  
	  }
	  return newArray.description  
	}

Simplify the closure's parameters by removing the types, as well as the return type:

	{ value, array in . . .
	
Add a typealias (just above the class):

	typealias TransformArray = (Int, [Int]) -> String

You can now write `performClosure()` as:

	func performClosure(value: Int, closure: TransformArray) -> String {

And `c` as:

	let c: TransformArray = { . . .

## 2) Closures in Tic-Tac-Toe

Change the closure to:

	{ action in self.reset() }

or even:

	{ _ in self.reset() }

To avoid capturing `self` as a strong reference, write:

	{ [weak self] _ in 
	  if let strongSelf = self {
	    strongSelf.reset()
	  }
	}

## 3) Generics

Make `countOccurrences()` generic:

	func countOccurrences<T>(value: T, array: [T]) -> String {

Use a type restriction to limit this function to `Equatable` types:

	func countOccurrences<T: Equatable>(value: T, array: [T]) -> String {

Test this function with an array of strings:

	let stringArray = ["A", "B", "C", "B", "D", "E"]  
	countOccurrences("B", stringArray)

This should print "B appears 2 times".

Replace `[Int]` with `Array<Int>`, and `[T]` with `Array<T>`.

Cmd-click on the word `Array` to see the definition in the Swift standard library.

## 4) Enums with Associated Values

Give the labels in the `Player` enum values:

	enum Player: Int {  
	  case X = 0  
	  case O = 1  
	}

Change these values to strings:

	enum Player: String {  
	  case X = "Player X"  
	  case O = "Player O"  
	}

Add the following code to print out the raw value of an enum:

	let p = Player.X  
	println(p.rawValue)

Use a `switch` to read the enum value:

	switch p {  
	case .X:  
	  println("Player is X")  
	case .O:  
	  println("Player is O")  
	}

Remove the strings from the enum, and change the X case to:

	case X(username: String)

Change the `p` variable to:

	let p = Player.X(username: "Steve")

Add another variable:

	let t = Player.X(username: "Tim")

Modify the `switch` statement to print out the username:

	case .X(let username):  
	  println(username)

Change the `switch` to:

	switch t {

Change the label inside the `switch` from `username` to `value`:

	case .X(let value):  
	  println(value)

Associate another value with the X case:

	case X(username: String, country: String)

Change the creation of the two variables to include this additional value:

	let p = Player.X(username: "Steve", country: "USA")
	let t = Player.X(username: "Tim", country: "Belgium")

Inside the `switch`, change the case statement to:

	case .X(let username, let country):
	  println(country)

Rewrite it as:

	case let .X(username, country):

Replace the `username` label with the wildcard symbol:

	case let .X(_, country):

Cmd-click on the line `import Swift`. Search for "enum optional".

Create two optional strings; the first uses syntactic sugar, the second uses the `Optional` enum directly:

	var s1: String? = "Not nil"
	var s2: Optional<String> = .Some("Not nil")

Verify that `s1` and `s2` are equal with:

	s1 == s2

## 5) That's it!

Congrats, at this time you should have gained some insight into what closures, generics and enums are, and how to use them.

You are ready to move on to the lab.
