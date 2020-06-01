# FunctionalAPI

Some collection of functions and types that are useful in day to day development.

# Functions 

## `map`

To help a bit with composability some existing map functions defined on `Array`, `Optional` and `Result` are made as global symbols.

```swift
public func map<A,B>(_ a: A?, _ f: (A) -> B) -> B? { ... 

public func map<A,B>(_ a: [A], _ f: (A) -> B) -> [B] { ... 

public func map<A,B>(_ a: Result<A,Error> , _ f: (A) -> B) -> Result<B, Error> { ...
```
 
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
## `product`

If you are thinking _cartesian product_ then you are right! Just take up to 5 arrays of stuff and you will get an array of tuples with all combinations.

Let's see a easy example, for more complicated check out tests:

```swift
let aa = [1,2]
let bb = ["a", "b"]

product(aa, bb)

// (1, "a")
// (1, "b")
// (2, "a")
// (2, "b")
```

### Where this function use useful?

It depends what you need. I use it to generate variations in my snapshot tests. One array contains device, other size class, language direction... you get the idea ;)

## `zip`

Zip function is defined on sequences in Swift. This is a nice extension to have it on Optional. 

Let say you have some computations or values that are optional. It might be tedious to `if let` them. Using `zip` you just flip the container inside out (check out how type is transormed in this [documentation on zip in haskell](https://hoogle.haskell.org/?hoogle=zip)) and `map` on the result. You can use [OptionalAPI](https://github.com/sloik/OptionalAPI) for this to.

```swift
let userName: String? 
let userLast: String?
let userAge: Int? 

zip(userName, userLast, userAge)
    .map{ (name: String, last: String, age: Int) in 
        // Working with not optional values
     }
```

I mentioned with [OptionalAPI](https://github.com/sloik/OptionalAPI) `map` can be _replaced_ with `andThen`:

```swift
zip(userName, userLast, userAge)
    .andThen{ (name: String, last: String, age: Int) in 
        // Working with not optional values
     }
```

Under the hood `map` is used by it read _better_.

# Types

## Either

T.B.C.
