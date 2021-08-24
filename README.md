# romode

This is a module for managing different modes in your Roblox scripts. It also, for the time being, can manage data. This may be removed or revised in future versions.

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
