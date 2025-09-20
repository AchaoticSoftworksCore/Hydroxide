local ModuleScript = {}

function ModuleScript.new(instance)
    local moduleScript = {}
    local closure = getScriptClosure(instance)

    if closure then
        moduleScript.Constants = getConstants(closure)
        moduleScript.Protos = getProtos(closure)
    end

    moduleScript.Instance = instance
    moduleScript.ReturnValue = require(instance) --// causes detection

    return moduleScript
end

return ModuleScript
