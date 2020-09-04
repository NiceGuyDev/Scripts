local list = {}

local function create(eventName)

	local eventList = {
		funcs = {},
		owners = {},
		orders = {}
	}

	list[eventName] = eventList

	return eventList

end

local function get(eventName)

	return list[eventName]

end

local function isValid(eventName)

	return get(eventName) and true or false

end

local function add(eventName, listenerName, func, owner)

	local event = get(eventName)

	if not event then

		event = create(eventName)

	end

	event.funcs[listenerName] = func
	event.owners[listenerName] = owner
	event.orders[#event.orders + 1] = listenerName

end

local function remove(eventName, listenerName)

	local event = get(eventName)

	event.funcs[listenerName] = nil
	event.owners[listenerName] = nil

end

local function call(eventName, ...)

	local event = get(eventName)

	if event then

		local eventOrders = event.orders

		for orderIndex = 1, #eventOrders do

			local listenerName = eventOrders[orderIndex]
			local listenerFunc, listenerOwner = event.funcs[listenerName], event.owners[listenerName]

			if listenerOwner then

				if listenerFunc(listenerOwner, ...) then

					return true

				end

			else

				if listenerFunc(...) then

					return true

				end

			end

		end

	end

end

return {
	create = create,
	add = add,
	remove = remove,
	get = get,
	call = call
}