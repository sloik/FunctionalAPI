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

### Where this function is useful?

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

Either is one of those types that you already know in Swift but it's specialized in some values. 

Here is it:

```swift
enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}
```

Slo it's an enum with two cases. That should ring at least two bells. Usually the `right` one is associated with the `good` or `success` or `dextra`. The `left` on the other hand is for `bad`, `failure`, `error` or you can say `sinistra`.

At least two types that are common in Swift are a specialization of this `Either`. 

You can take a look at _Optional_ and match `left` with _none_ case. Also you can take a look at _Result_ and match if _failure_ with a `left` case.

So here you have a more generic type that you can use. It's useful not only when you have to validate stuff. But also when there is a need to return different types.

### Computed Properties

To make life a bit easier there are defined some helper properties. 

Handy properties for logic checks. 

```swift
var isLeft : Bool // true if `left` case
var isRight: Bool // true if `right` case
```

When you want to get to a value but you can deal with optional.

```swift
var right: Right?
var left : Left?
```

Take a look at [OptionalAPI](https://github.com/sloik/OptionalAPI) to see how working with Optional can be a pleasure.

### `map`s

---

T.B.C.
