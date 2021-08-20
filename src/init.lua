local Romode = {}

Romode.modeMetatable = {} do
	local modeMetatable = Romode.modeMetatable
	modeMetatable.__index = modeMetatable

	-- Fires the beginning function when the mode begins and fires the ending function when the mode ends
	function modeMetatable:when(beginning: function, ending: function)
		self.beginning(beginning)
		self.ending(ending)
	end

	-- Connects the event to the function when the mode begins and disconnects when the mode ends
	function modeMetatable:during(event: RBXScriptSignal, f: function)
		local connection
		self.beginning:Connect(function()
			connection = event:Connect(f)
		end)

		self.ending:Connect(function()
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
		function rec(tbl: table, onList: table)
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
				for i, child in ipairs(onList) do
					-- Check to see if they are still the same
					if same then
						if child == currentlyOn[i] then
							-- Skip firing events if they are
							continue
						else
							-- Turn same to false if they are not the same
							same = false
						end
					end
						
					-- Fire the events for changing
					currentlyOn[i].ending:Fire()
					child.beginning:Fire()
				end

				-- Set the new on list
				tbl.on = onList
			end
		end
		rec(self, {})
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

		for key, val in pairs(tbl) do
			-- Make sure it is not super, data, or and event
			if key ~= "super" and key ~= "data" and type(val) == "table" then
				rec(val, super)
			end
		end
	end
	rec(tree)

	-- Init the current mode value,
	-- No events are fired for this
	tree.on = {tree}
end

return Romode