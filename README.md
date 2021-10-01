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

### Method 3: Kayak/Rotriever

* Use [kayak](https://github.com/emozley/kayak) to put the file into your porject

## [Documentation](https://scotch101tape.github.io/romode/)

For a complete documentation of the langauge visit the [gihub page](https://scotch101tape.github.io/romode/)

```lua
-- Context Action Service goes well with Romode
local ContextActionService = game:GetService("ContextActionService")

-- Get romode
local Romode = require(romode.path)

-- Create a mode tree
local mode = Romode.new({
    Playing = {
        Monster = {
            data = {
                health = 200
            }
        },
        Spectator = {
            data = {
                subject = "monster"
            }
        },
        Player = {
            data = {
                health = 100
            }
        }
    },
    Lobby = {}
})

-- Bind these functions when the mode starts and ends
mode.Playing.Spectator:when(function()
    -- Turn on spectator gui
end, function()
    -- Turn off spectator gui
end)

-- Bind these functions when the mode starts and ends
mode.Monster:when(function()
    -- Bind the monsters controls
    ContextActionService:BindAction(...)
end, function()
    -- Unbind the monsters controls
    ContextActionService:UnbindAction()
end)

--Set the inital mode
mode.Lobby:setMode()
```

## License

This code is under the MIT license. See [license.txt](https://github.com/scotch101tape/romode/license.txt).