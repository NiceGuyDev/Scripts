function coroutine.wait(delay, ...)

	local startTime = engineTime()

	while (engineTime() - startTime) <= delay do

		coroutine.yield(...)

	end

end