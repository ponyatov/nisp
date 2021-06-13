import unittest
import nisppkg/config
import nisp

test "hello":
  check MODULE == "nisp"

test "Object.hello":
  let hello = newObject("Hello")
  check $hello == "\n<object:Hello>"

test "int.dump":
  let num = newInt(1234)
  check num.tag() == "int"
  # check $num == "\n<int:1234>"
