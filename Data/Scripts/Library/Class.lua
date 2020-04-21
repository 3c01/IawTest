
function CloneTable(tab)
    local clone = {}
    for k, v in pairs(tab) do
        if type(v) == "table" and not v.IsClassInstance then
            clone[k] = CloneTable(v)
        else
            clone[k] = v
        end
    end

    return clone
end

function Class(tab)
    function tab:New(...)
        local obj = CloneTable(self)
        obj.IsClassInstance = true
        obj.New = nil

        if obj.Extends then
            setmetatable(obj, {__index = obj.Extends})
        end

        obj.Extends = nil

        if obj.Constructor then
            obj:Constructor(unpack(arg))
        end

        return obj
    end

    return tab
end
