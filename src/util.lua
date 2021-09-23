local Util = {}

-- Function for recursion
function Util.recursion(f)
	-- Somewhat convoluted, but it gets the job done
	return function(...)
		f(function(...)
			return Util.recursion(f)(...)
		end, ...)
	end
end

return Util