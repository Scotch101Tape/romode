# Romode

A module for handling modes and contexts in Roblox. 

## Installation

### Method 1: Model File (Roblox Studio)
* Download the `rbxm` model file attached to the latest release from the [GitHub releases page](https://github.com/scotch101tape/romode/releases).
* Insert the model into Studio into a place like `ReplicatedStorage`

### Method 2: Filesystem
* Copy the `src` directory into your codebase
* Rename the folder to `Romode`
* Use a plugin like [Rojo](https://github.com/LPGhatguy/rojo) to sync the files into a place






## Example

```lua
local Romode = require(romode.path)

local mode = Romode.new({
	Foo = {
		One = {},
		Two = {
			data = {
				field = true
			}
		}
	},
	Bar = {}
})

mode.Foo.Two:when(function()
	print("Starting mode Two")
end, function()
	print("Ending mode Two")
end)

mode.Foo.Two:setMode()
```
