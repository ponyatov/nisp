# Package

version     = "0.0.1"
author      = "Dmitry Ponyatov <dponyatov@gmail.com>"
description = "Lisp-like homoiconic language in Nim"
license     = "MIT"
binDir      = "bin"
srcDir      = "src"
installExt  = @["nim"]
bin         = @["nisp"]

# Dependencies

requires "nim >= 1.4.8"
