[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsloik%2FFunctionalAPI%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/sloik/FunctionalAPI)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsloik%2FFunctionalAPI%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/sloik/FunctionalAPI)
![Main](https://github.com/sloik/FunctionalAPI/actions/workflows/swift.yml/badge.svg?branch=main)
![Nightly](https://github.com/sloik/FunctionalAPI/actions/workflows/nightly.yml/badge.svg)

# `𝑓(x)` FunctionalAPI 

Some collection of functions and types that are useful in day to day development.

---
# Functions 

# `map`

To help a bit with composability some existing map functions defined on `Array` and `Result` are made as global symbols.

```swift

public func map<A,B>(_ a: [A], _ f: (A) -> B) -> [B] { ... 

public func map<A,B>(_ a: Result<A,Error> , _ f: (A) -> B) -> Result<B, Error> { ...
```

### Map on `Optional`s

Please chceck [OptionalAPI Swift Package](https://github.com/sloik/OptionalAPI) for maps and other extensions on Optional.
 
## `identity`
Whole implementation looks like this:

```swift
func identity<A>(_ a: A) -> A { a }
```

This might seem as a useless function but every time you write in your code `{ $0 }` you are writing this exact same function. Let's see some example:

```swift
[1,2,3].map{ $0 } // [1,2,3]
```

Same cane be done with identity but with extra clarity:

```swift
[1,2,3].map( identity ) // [1,2,3]
```

### Where this function is useful?

It depends what you need. I use it to generate variations in my snapshot tests. One array contains device, other size class, language direction... you get the idea ;)

# 🐇🕳 Rabbit Hole

This project is part of the [🐇🕳 Rabbit Hole Packages Collection](https://github.com/sloik/RabbitHole)
