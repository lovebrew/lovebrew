# Package

version = "0.6.0"
author = "TurtleP"
description = "LÖVE Potion Game Distribution Helper"
license = "MIT"
srcDir = "src"
bin = @["lovebrew"]
binDir = "dist"


# Dependencies

requires "nim >= 1.4.6"
requires "zippy"
requires "parsetoml"
requires "cligen"
requires "regex"
requires "https://github.com/yglukhov/iface"
