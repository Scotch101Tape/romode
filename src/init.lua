local Romode = {}

Romode.modeMetatable = {} do
	local modeMetatable = Romode.modeMetatable
	modeMetatable.__index = modeMetatable

	-- Fires the beginning function when the mode begins and fires the ending function when the mode ends
	function modeMetatable:when(beginning, ending)
		self.beginning.Event:Connect(beginning)
		self.ending.Event:Connect(ending)
	end

	-- Connects the event to the function when the mode begins and disconnects when the mode ends
	function modeMetatable:during(event: RBXScriptSignal, f)
		local connection
		self.beginning.Event:Connect(function()
			connection = event:Connect(f)
		end)

		self.ending.Event:Connect(function()
			if connection then
				connection:Disconnect()
			end
		end)
	end

	-- Sets the current mode to self
	function modeMetatable:setMode()
		-- A function is used for recursion only
		-- It goes up the tree until it hits the top (which has no super).
		-- It then fires events and sets the on list
		local function rec(tbl: table, onList: table)
			-- Add the table onto the on list
			onList[#onList+1] = tbl
			
			-- If it has a super, go up, otherwise you have reached the top
			local super = tbl.super
			if super then
				rec(super, onList)
			else
				-- We have reached the top now and can fire events
				
				-- First we check what hasn't changed
				local same = true
				local currentlyOn = tbl.on
				for i = 1, math.max(#currentlyOn, #onList), 1 do
					local cOn = currentlyOn[i]
					local lOn = onList[i]

					-- Check to see if they're still the same
					if same then
						if lOn == cOn then
							-- Skip firing events if they are
							continue
						else
							-- Turn same to false if they are not the same
							same = false
						end
					end

					-- Fire events
					if cOn then
						cOn.ending:Fire()
					end

					if lOn then
						lOn.beginning:Fire()
					end
				end

				-- Set the new on list
				tbl.on = onList
			end
		end
		rec(self, {})
	end

	-- Overwrites the fields provided
	-- This fires the dataChanged event
	function modeMetatable:setData(overData)
		-- Function is used for recursion only
		-- It over write the all the properties in overData and creates a table of all changed properties
		local function rec(over, write)
			local changed = {}
		 	for key, val in pairs(over) do
				if type(val) == "table" then
					-- Add table changed
					changed[key] = {}

					-- If no table in write, create it
					if not write[key] then
						write[key] = {}
					end

					-- Do rec on the table in write
					rec(val, write[key])
				else
					-- Add value changed
					changed[key] = true

					-- Overwrite the val of write
					write[key] = val
				end
			end
		end
		local changed = rec(overData, self.data)

		self.dataChanged:Fire(self.data, changed)
	end
end

function Romode.new(tree: table): table
	-- A function is only used so that it is possible to use recursion
	-- Goes through the tree and adds the meta table and other properties
	-- to the tree
	local function rec(tbl: table, super: table?)
		-- Set the meta table
		setmetatable(tbl, Romode.modeMetatable)

		-- Set the super property
		tbl.super = super

		-- Set the events
		tbl.beginning = Instance.new("BindableEvent")
		tbl.ending = Instance.new("BindableEvent")
		tbl.dataChanged = Instance.new("BindableEvent")

		for key, val in pairs(tbl) do
			-- Make sure it is not super, data, or and event
			if key ~= "super" and key ~= "data" and type(val) == "table" then
				rec(val, tbl)
			end
		end
	end
	rec(tree)

	-- Init the current mode value,
	-- No events are fired for this
	tree.on = {tree}

	return tree
end

return Romode
