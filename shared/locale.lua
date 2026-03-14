local localeData = {}

local function loadLocale(lang)
    local raw = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.json'):format(lang))
    if not raw then return nil end
    local ok, data = pcall(json.decode, raw)
    if ok and type(data) == 'table' then return data end
    return nil
end

local lang = GetConvar('setr_language', 'en')
localeData = loadLocale(lang) or loadLocale('en') or {}

function _L(key, ...)
    local parts = {}
    for part in key:gmatch('[^%.]+') do
        parts[#parts + 1] = part
    end
    local val = localeData
    for _, part in ipairs(parts) do
        if type(val) ~= 'table' then return key end
        val = val[part]
    end
    if type(val) == 'string' then
        if select('#', ...) > 0 then
            local ok, result = pcall(string.format, val, ...)
            return ok and result or val
        end
        return val
    end
    return key
end