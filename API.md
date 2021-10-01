# API

## Romode Tree

A Romode tree is the hierarchy of modes. Modes should be uppercase while the data should be under the `data` key

### `Romode.new(tree: table, dataMethods: boolean?): Romode Tree`
If the dataMethods is false or nil, the data keys will not have built in methods

## Mode Methods

### `mode:setMode()`
Sets the mode to be the current mode

### `mode:when(beginning: function, ending: function)`
Fires beginning function when the mode begins and the ending function when it ends

### `mode:during(event: RBXScriptEvent, connection: function)`
Connects and disconnects the function to the event when the mode begins and ends respectivly

## Data Methods

These are methods that change the data in the `data` key of the mode

### `mode:setData(data: table)`
Overwrites the data specified in the table. If the key is not specificly stated
