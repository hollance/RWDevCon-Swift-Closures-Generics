# 202: Swift (Conclusion)

All right, that concludes this talk on Swift generics, closures, and enums. I hope it gave you some insight in how to use these new features from Swift.

They let you do a lot of cool stuff that is much harder to pull off in Objective-C.

## What Did You Learn

**Closures.** You've seen that in Swift, closures are really no different from functions and methods. They have the same type signature and you invoke them the same way.

Functions, methods, and closures are completely interchangeable. Just think of a closure as a function without a name.

There's one big difference: closures capture their environment. If you're using the closure inside a class, it will usually capture `self`. That's important to be aware of.

This can lead to ownership cycles and memory leaks, so to prevent this you can use a capture list. The capture list changes how a variable is captured, so you can make it `weak` instead of `strong`, and avoid ownership cycles.

**Generics.** You also learned about generics. 

You've seen how you can make functions and methods generic, so you can use the same code with different data types. And of course you created your own generic container type that you can re-use in many different games.

When applied well, generics can really save a lot of duplicate code. They also allow you to write algorithms that are independent of the actual data you're processing.

**Enums.** And finally, enums with associated values. When I first came across this concept it didn't make any sense to me, but now I think it's one of the best features of Swift.

In a lot of cases, an enum is a better way to express what you want than the more traditional class or struct. So consider using them in your next project.

You've also seen how to use `switch` to read these enum values. Switch and enums really go hand-in-hand. I haven't been able to show off all the power of switch, it can do a lot more, so it's worth learning.

## Where To Go From Here?

As you're no doubt aware, we have a ton of free tutorials on our website. If you like games, you may be interested in my tutorial on how to make a game like Candy Crush. This shows how to use generics, closures, and enums, so you may want to check that out.

Of course, we also have a book, *Swift by Tutorials*. It covers all of this stuff in depth, with real-world examples. It's definitely worth a read.

Apple also has a book. This is a must-read. If you've read it and it didn't make much sense before, then I suggest you go read it again after this conference and -- hopefully! -- things should be a lot clearer the second time around.

If you want to talk to more about this stuff, you can also find me on Twitter and in the Ray Wenderlich forums. And of course I'll be available here at the conference, so please feel free to come up to me any time.

By the way, earlier I mentioned that closures are great for functional programming. If you’re interested in that, check out the talk at 3 PM today in this room, because that goes into depth on how to use functional programming principles with Swift.

Thank you! And enjoy your lunch!
