--- Trains module
-- <p>When this module is loaded, it registers new
-- events in order to track trains as locomotives and
-- carriages are moved around. For this reason, you should use
-- this library's <a href="Event.html">Event</a> module</p>
-- @module Trains

-- Event registration is performed at the bottom of this file,
-- once all other functions have been defined

require 'stdlib/event/event'
require 'stdlib/table'
local Surface = require 'stdlib/area/surface'
local Entity = require 'stdlib/entity/entity'

Trains = {} --luacheck: allow defined top

--- This event is fired when a train is completely removed
-- <p>This will fire whenever the last locomotive is removed from a train</p>
-- <p>For a train consisting of 1 locomotive and 3 wagons the event will fire as soon as
-- the locomotive is mined, even though the wagons remain
-- <strong>Event parameters</strong> <br />
-- A table with the following properties:
-- <ul>
-- <li>old_id (int) The id of the train before the change</li>
-- <li>remains_id (int) The id of the remaining wagons or nil if nothing is left TODO this might not be possible
-- </ul>
-- </p>
-- @usage
----Event.register(Trains.on_train_removed, my_handler)
Trains.on_train_removed = script.generate_event_name()

--- Given search criteria (a table that contains at least a surface_name)
-- searches the given surface for trains that match the criteria
-- @usage
----Trains.find_filtered({ surface_name = "nauvis", state = defines.train_state.wait_station })
-- @tparam Table criteria Table with any keys supported by the <a href="Surface.html#find_all_entities">Surface</a> module.</p>
-- <p>If the name key isn't supplied, this will default to 'diesel-locomotive'</p>
-- <p>If the surface key isn't supplied, this will default to 1</p>
-- <p>If the surface key isn't supplied, this will search all surfaces that currently exist</p>
-- <p>Criteria may also include the 'state' field, which will filter the state of the train results</p>
-- @return A list of train details tables, if any are found matching the criteria. Otherwise the empty list.
-- <table><tr><td>train (LuaTrain)</td><td>The LuaTrain instance</td></tr><tr><td>id (int)</td><td>The id of the train</td></tr></table>
function Trains.find_filtered(criteria)
    criteria = criteria or {}

    local surface_list = Surface.lookup(criteria.surface)
    if criteria.surface == nil then
        surface_list = game.surfaces
    end

    local results = {}

    for _, surface in pairs(surface_list) do
        local trains = surface.get_trains(criteria.force)
        for _, train in pairs(trains) do
            table.insert(results, train)
        end
    end

    -- Apply state filters
    if criteria.state then
        results = table.filter(results, function(train)
            return train.state == criteria.state
        end)
    end

    -- Lastly, look up the train ids
    results = table.map(results, function(train)
        return { train = train, id = train.id }
    end)

    return results
end

--- Event handler for when a locomotive gets mined or destroyed
-- @return void
function Trains._on_locomotive_removed(event)
    --this is the old train that will become invalid
    local train = event.entity.train
    local locomotives = train.locomotives
    assert(train.valid)

    if #train.carriages > 1 and ( #locomotives.front_movers > 1 or #locomotives.back_movers > 1 ) then
        -- nothing to do, should be handled by on_train_created
        return
    end
    Event.dispatch({ name = Trains._on_train_removed, old_id = train.id })
end

--- Event handler for defines.events.on_train_created
-- @return void
function Trains._on_train_created(event)
    local train = event.train
    local old_id_1 = event.old_id_1
    local old_id_2 = event.old_id_2
    if #train.locomotives.front_movers > 0 or #train.locomotives.back_movers > 0 then
        global._train_registry[event.train.id] = event.train
    end
    if old_id_1 then
        --copy data via Trains.get/setData ?
        global._train_registry[old_id_1] = nil
        if old_id_2 then
            --copy data via Trains.get/setData ?
            global._train_registry[old_id_1] = nil
        end
    end
end

--- Creates an Entity module-compatible entity from a train
-- @tparam LuaTrain train
-- @treturn table
function Trains.to_entity(train)
    local name = "train-" .. train.id
    return {
        name = name,
        valid = train.valid,
        equals = function(entity)
            return name == entity.name
        end
    }
end

--- Set user data on a train
-- <p>This is a helper method around <a href="Entity.html#set_data">Entity.set_data</a></p>
-- @tparam LuaTrain train
-- @tparam mixed data
-- @return mixed
function Trains.set_data(train, data)
    return Entity.set_data(Trains.to_entity(train), data)
end

--- Get user data on a train
-- <p>This is a helper method around <a href="Entity.html#get_data">Entity.get_data</a></p>
-- @tparam LuaTrain train
-- @return mixed
function Trains.get_data(train)
    return Entity.get_data(Trains.to_entity(train))
end

-- Creates a registry of known trains
-- @return table A mapping of train id to LuaTrain object
local function create_train_registry()
    global._train_registry = global._train_registry or {}

    local all_trains = Trains.find_filtered()
    for _, trainInfo in pairs(all_trains) do
        global._train_registry[tonumber(trainInfo.id)] = trainInfo.train
    end

    --return registry
end

-- When developers load this module, we need to
-- attach some new events

--- Filters events related to entity_type
-- @tparam string event_parameter The event parameter to look inside to find the entity type
-- @tparam string entity_type The entity type to filter events for
-- @tparam callable callback The callback to invoke if the filter passes. The object defined in the event parameter is passed. <--Why only the parameter????
local function filter_event(event_parameter, entity_type, callback)
    return function(evt)
        if(evt[event_parameter].type == entity_type) then
            callback(evt)
        end
    end
end

-- When a locomotive is removed ..
Event.register(defines.events.on_entity_died, filter_event('entity', 'locomotive', Trains._on_locomotive_removed))
Event.register(defines.events.on_player_mined_entity, filter_event('entity', 'locomotive', Trains._on_locomotive_removed))

Event.register(defines.events.on_train_created, Trains._on_train_created)

-- When the mod is initialized the first time
Event.register(Event.core_events.init, create_train_registry)
Event.register(Event.core_events.configuration_changed, create_train_registry)

return Trains
