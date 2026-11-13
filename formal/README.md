# Formal model (TLA+)

`FunctionalAPILaws.tla` is a finite TLA+ model of the public semantics of `Sources/FunctionalAPI`.
TLC checks every law over a carrier `Vals = {0, 1}` and **every** function in the finite function
space, so each law holds for all closures, not just hand-picked ones.

| Invariant | Swift API it abstracts |
|---|---|
| `TypeOK` | domain of the model variables |
| `ComposeOrder`, `ComposeAssociative`, `ComposeIdentity` | `compose(f, g)` applies `f` then `g`; with `identity` it is a monoid |
| `CurryUncurryRoundTrip`, `UncurryCurryRoundTrip`, `CurryApplication` | `curry`, `uncurry` |
| `FlipSwapsArguments`, `FlipInvolution` | `flip` |
| `PartialApplication`, `PartialIsCurry` | `partial(f, a)` equals `curry(f)(a)` |
| `ThunkReturnsValue`, `IdentityIsNeutral` | `thunk`, `identity` |
| `ForwardApplicationIsCall` | `x \|> f == f(x)` |
| `ForwardCompositionIsCompose` | `f >>> g == compose(f, g)` |
| `KeyPathProjection` | prefix `^` turns a KeyPath into a projection function |
| `FunctorialMapMatchesFreeMap`, `ArrayFunctorLaws` | `<^>` on `[A]` and `A?` is `map`; functor identity and composition |
| `ArrayFlatMapLaws` | free `flatMap` on arrays (monad laws, `map` via `flatMap`) |
| `CompactMapDropsNil`, `CompactMapOfTotalIsMap` | free `compactMap` |
| `ResultMapLaws` | free `map` / `<^>` on `Result` |
| `PhantomProcess` | `Phantom.process` applies the transform and keeps the wrapped value |

## Abstractions

- Arrays are sequences of length at most 2; a KeyPath is a field selector on a pair; `Result`
  has one abstract error (`failure`); `Optional` is a `none`/`some` record.
- `zurry`, `nop` and the DEBUG-only `developmentValue`/`temporayValue` are not modelled
  (`zurry` is internal, `nop` has no observable result, `temporayValue` traps).
- Only arities that exist in the code are modelled for `curry`, `partial`, `flip` (2 arguments);
  `partial` is modelled for the 2-argument form, whose 3-argument form is the same pattern.
- The generic `A <^> f` overload (plain application) is not modelled; Swift overload resolution
  chooses the more specific array/optional/result/either overloads for those types.

## Non-vacuity

Each `FunctionalAPILaws.<mutant>.cfg` seeds one bug through the `Mutant` constant and names
the invariant that must catch it (`\* EXPECT_VIOLATION: ...`):

- `compose_swapped`: `compose` applies `g` before `f` (caught by `ComposeOrder`).
- `flip_noop`: `flip` returns its argument unchanged (caught by `FlipSwapsArguments`).

`run_tlc.sh` fails if a mutant passes.

## Running

```sh
TLA_JAR=/path/to/tla2tools-1.7.4.jar formal/run_tlc.sh   # needs Java 11+
```

The script checks the jar's SHA-256 against the pinned tla2tools 1.7.4. CI runs it on a
self-hosted Oracle ARM64 runner, only on pushes to the default branch or by manual dispatch
(`.github/workflows/oracle-tla.yml`). The Swift build and tests stay on hosted macOS.

## Limits

The model describes the *intended* semantics, read by hand from the Swift sources. It does not
prove the Swift code conforms; the XCTest suite covers the code. If the Swift behaviour
changes, update the model in the same PR.
