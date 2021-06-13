import nisppkg/config

import os, strformat

proc CopyRight*(): string = fmt"(c) {AUTHOR} <{EMAIL}> {YEAR} {LICENSE}"

proc main*(argc: int, argv: seq[string]): int =
  echo fmt"{MODULE} {CopyRight()}"
  echo "argc: ", argc
  echo "argv: ", argv
  0

when isMainModule:
  let argc = paramCount()
  var argv: seq[string]
  for i in 0..argc: argv = argv & paramStr(i)
  discard main(argc, argv)



# Abstract Syntax (hyper)Graph = Marvin Minsky's Frame model

# https://nim-by-example.github.io/macros/
# http://goran.krampe.se/2014/12/03/nim-seq/


type Object = ref object of RootObj
  typee: string
  value: string
  nest: seq[Object]

proc newObject*(V: string): Object =
  new result
  result.value = V

method tag(self: Object): string {.base.} = "object"

method val(self: Object): string {.base.} = fmt"{self.value}"

method head(self: Object, prefix = ""): string {.base.} =
  fmt"{prefix}<{self.tag()}:{self.val()}>"

proc pad(depth: int): string = "\n"

method dump(self: Object,
            cycle: seq[Object] = @[], depth = 0,
            prefix = ""
            ): string {.base.} =
  result = pad(depth) & head(self)
  # for j in self.nest:
  # result += fmt"{j}" # dump(j, cycle, depth+1, fmt"{j}: ")

method `$`*(self: Object): string {.base.} = dump(self)


type Primitive = ref object of Object

type Atom = ref object of Primitive

# method head(self: Atom): string = ""
method tag(self: Atom): string = "atom"
method val(self: Atom): string = fmt"{self.value}"

type Int* = ref object of Primitive
  value: int

proc newInt*(V: int): Int =
  new result
  result.value = $V

# method head(self: Int): string = ""
method tag*(self: Int): string = "int"
# method val(self: Int): string = fmt"{self.value}"
method head(self: Int, prefix = ""): string =
  fmt"{prefix}<{self.tag()}:{self.val()}>"

type S = ref object of Primitive

method tag(self: S): string = "s"


type Container = ref object of Object

