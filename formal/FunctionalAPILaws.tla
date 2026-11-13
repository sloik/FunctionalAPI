------------------------- MODULE FunctionalAPILaws -------------------------
(* Finite model of Sources/FunctionalAPI: compose / curry / uncurry / flip *)
(* / partial / thunk / identity, the operators |>, >>>, <^>, ^keyPath,    *)
(* the free map/flatMap/compactMap on arrays and map on Result, and the   *)
(* Phantom wrapper. Values range over Vals; functions over the full       *)
(* finite function space, so each law holds for every closure.            *)
(* Abstractions: arrays are sequences of length <= 2; a KeyPath is a      *)
(* field selector on a two-field record; Result is success(v)/failure(e)  *)
(* with a single abstract error; Optional is None / Some(v).              *)
EXTENDS Naturals, Sequences

CONSTANTS Vals,     \* carrier for values
          Mutant    \* "none" for the real semantics, otherwise a seeded bug

None_   == [tag |-> "none"]
Some(v) == [tag |-> "some", v |-> v]
Opts   == {None_} \cup {Some(v) : v \in Vals}
Fns    == [Vals -> Vals]
Fns2   == [Vals \X Vals -> Vals]
Id     == [x \in Vals |-> x]

\* FunctionsCombinators.swift
Compose(f, g) ==                       \* compose(f, g) = g after f
  IF Mutant = "compose_swapped" THEN [x \in Vals |-> f[g[x]]]
  ELSE [x \in Vals |-> g[f[x]]]
Curry(f)   == [a \in Vals |-> [b \in Vals |-> f[a, b]]]
Uncurry(h) == [t \in Vals \X Vals |-> h[t[1]][t[2]]]
Flip(f)    == IF Mutant = "flip_noop" THEN f
              ELSE [t \in Vals \X Vals |-> f[t[2], t[1]]]
Thunk(a)   == [u \in {0} |-> a]
Partial2(f, a) == [b \in Vals |-> f[a, b]]
Fwd(x, f)  == f[x]                     \* x |> f
Fcomp(f, g) == [x \in Vals |-> g[f[x]]]  \* f >>> g
Proj1 == [r \in Vals \X Vals |-> r[1]]   \* ^\.first
Proj2 == [r \in Vals \X Vals |-> r[2]]   \* ^\.second

\* FreeMaps.swift on arrays
Seqs == {<<>>} \cup {<<x>> : x \in Vals} \cup {<<x, y>> : x, y \in Vals}
SMap(s, f) == [i \in 1..Len(s) |-> f[s[i]]]
RECURSIVE SFlatMap(_, _)
SFlatMap(s, k) == IF s = <<>> THEN <<>> ELSE k[Head(s)] \o SFlatMap(Tail(s), k)
\* Optional-returning functions.
OptFns == [Vals -> Opts]
RECURSIVE SCompact(_, _)
SCompact(s, g) ==
  IF s = <<>> THEN <<>>
  ELSE (IF g[Head(s)].tag = "none" THEN <<>> ELSE <<g[Head(s)].v>>) \o SCompact(Tail(s), g)
\* <^> on Optional and Result
OMap(o, f) == IF o.tag = "none" THEN o ELSE Some(f[o.v])
RMap(r, f) == IF r.tag = "success" THEN [tag |-> "success", v |-> f[r.v]] ELSE r
Results == {[tag |-> "success", v |-> x] : x \in Vals} \cup {[tag |-> "failure", v |-> 0]}

\* Phantom.swift: a witness tag plus the wrapped value; process applies transform.
Phantoms == [w : {"A", "B"}, v : Vals]
Retag(w) == [p \in Phantoms |-> [w |-> w, v |-> p.v]]
Process(p, t) == t[p]

VARIABLES x, y, s, r, p
vars == <<x, y, s, r, p>>
Init == /\ x \in Vals /\ y \in Vals /\ s \in Seqs /\ r \in Results /\ p \in Phantoms
Next == UNCHANGED vars
Spec == Init /\ [][Next]_vars

TypeOK == x \in Vals /\ y \in Vals /\ s \in Seqs /\ r \in Results /\ p \in Phantoms

ComposeOrder == \A f, g \in Fns : Compose(f, g)[x] = g[f[x]]
ComposeAssociative ==
  \A f, g, h \in Fns : Compose(Compose(f, g), h) = Compose(f, Compose(g, h))
ComposeIdentity == \A f \in Fns : Compose(Id, f) = f /\ Compose(f, Id) = f
CurryUncurryRoundTrip ==
  \A f \in Fns2 : Uncurry(Curry(f)) = f
UncurryCurryRoundTrip ==
  \A f \in Fns2 : Curry(Uncurry(Curry(f))) = Curry(f)
CurryApplication == \A f \in Fns2 : Curry(f)[x][y] = f[x, y]
FlipSwapsArguments == \A f \in Fns2 : Flip(f)[y, x] = f[x, y]
FlipInvolution == \A f \in Fns2 : Flip(Flip(f)) = f
PartialApplication == \A f \in Fns2 : Partial2(f, x)[y] = f[x, y]
PartialIsCurry == \A f \in Fns2 : Partial2(f, x) = Curry(f)[x]
ThunkReturnsValue == Thunk(x)[0] = x
IdentityIsNeutral == Id[x] = x
\* Operators promise to equal the plain functions they sugar.
ForwardApplicationIsCall == \A f \in Fns : Fwd(x, f) = f[x]
ForwardCompositionIsCompose ==
  \A f, g \in Fns : Fcomp(f, g) = Compose(f, g) /\ Fwd(x, Fcomp(f, g)) = Fwd(Fwd(x, f), g)
KeyPathProjection ==
  Proj1[<<x, y>>] = x /\ Proj2[<<x, y>>] = y
FunctorialMapMatchesFreeMap ==       \* <^> on [A] is map, on A? is Optional.map
  /\ \A f \in Fns : SMap(s, f) = [i \in 1..Len(s) |-> f[s[i]]]
  /\ \A f \in Fns : Len(SMap(s, f)) = Len(s)
  /\ \A f \in Fns : OMap(Some(x), f) = Some(f[x]) /\ OMap(None_, f) = None_
ArrayFunctorLaws ==
  /\ SMap(s, Id) = s
  /\ \A f, g \in Fns : SMap(s, Compose(f, g)) = SMap(SMap(s, f), g)
ArrayFlatMapLaws ==
  /\ \A k \in [Vals -> Seqs] : SFlatMap(<<x>>, k) = k[x]
  /\ SFlatMap(s, [v \in Vals |-> <<v>>]) = s
  /\ \A f \in Fns : SMap(s, f) = SFlatMap(s, [v \in Vals |-> <<f[v]>>])
CompactMapDropsNil ==
  \A g \in OptFns :
    /\ Len(SCompact(s, g)) <= Len(s)
    /\ \A i \in 1..Len(SCompact(s, g)) : SCompact(s, g)[i] \in Vals
CompactMapOfTotalIsMap ==
  \A f \in Fns : SCompact(s, [v \in Vals |-> Some(f[v])]) = SMap(s, f)
ResultMapLaws ==
  /\ RMap(r, Id) = r
  /\ r.tag = "failure" => \A f \in Fns : RMap(r, f) = r
  /\ \A f, g \in Fns : RMap(r, Compose(f, g)) = RMap(RMap(r, f), g)
PhantomProcess ==
  /\ \A w \in {"A", "B"} : Process(p, Retag(w)).v = p.v /\ Process(p, Retag(w)).w = w
  /\ Process(Process(p, Retag("A")), Retag("B")) = Process(p, Retag("B"))
=============================================================================
