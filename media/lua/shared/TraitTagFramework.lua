TraitTags = {}

local function sanitizeTags(tagString)
    --remove all spaces, control characters, null, punctuation & symbols (except commas)
    local workString = tagString:gsub('[^%w,]', '')
    return workString;
end


function TraitTags:toString()
    local returnString = "";

    for trait, tagTable in pairs(TraitTags)
    do
        if type(tagTable) == "table"
        then
            returnString = returnString..trait..": ";
            returnString = returnString..table.concat(tagTable, ',');
            returnString = returnString.."; ";
        end
    end

    return returnString;
end


function TraitTags:tagTableToString(traitName)
    local returnString = "";

    if TraitTags[traitName] ~= nil
    then
        returnString = table.concat(TraitTags[traitName], ',');
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot stringify tag table. Skipping...")
    end
end


--Uses alphanumberic symbols and commas only.
function TraitTags:add(traitName, tags)
    local sanitizedTags = sanitizeTags(tags);
    local tagTable = {};
    if TraitFactory.getTrait(traitName)
    then
        if TraitTags[traitName] == nil
        then
            print("Trait Tag Framework: Initializing entry for "..traitName.." in TraitTags")
            TraitTags[traitName] = {};
        end
        if string.len(sanitizedTags) > 0
        then
            tagTable =  string.split(sanitizedTags, ',');
            print("Trait Tag Framework: adding tags "..sanitizedTags.." to "..traitName.." entry.");
            TraitTags[traitName] = tagTable;
        else
            print("Trait Tag Framework: No tags detected for "..traitName..", skipping...");
        end
    else
        print("Trait Tag Framework: Cannot find trait "..traitName..", skipping...");
    end
end


function TraitTags:remove(traitName)
    if TraitTags[traitName] ~= nil
    then
        table.remove(TraitTags, traitName)
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot remove. Skipping...")
    end
end


function TraitTags:getTraitTags()
    return TraitTags;
end


function TraitTags:getTagTable(traitName)
    if TraitTags[traitName] ~= nil
    then
        return TraitTags[traitName]
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot get tag table. Skipping...")
    end
end


function TraitTags:getPlayerTraitTags(player)
    local playerTraits = player:getTraits();
    local concatenatedTags = "";
    local returnString = "";
    if playerTraits ~= nil
    then
        for _, trait in ipairs(playerTraits)
        do
            print(_..", "..trait);
            if TraitTags[trait] ~= nil
            then
                concatenatedTags = table.concat(TraitTags[trait], ',');
                returnString = returnString..concatenatedTags..concatenatedTags;
            end
        end
    end
    return returnString;
end

function TraitTags:getTagsStatistics()
    local tempTable = {};
    local sortTable = {};
    local returnString = "";

    --get
    for trait, tagTable in pairs(TraitTags)
    do
        if type(tagTable) == "table"
        then
            for _, tag in ipairs(tagTable)
            do
                if tempTable[tag] ~= nil
                then
                    tempTable[tag] = tempTable[tag] + 1;
                else
                    tempTable[tag] = 1
                end
            end
        end
    end

    --sort
    for key, value in pairs(tempTable) do
        table.insert(sortTable, {tag = key, count = value})
    end
    table.sort(sortTable, function(a, b) return a.count > b.count end);

    --condense (limitation: cannot make a sorted table in vanilla lua. Return as string instead.

    for i = 1, getn(sortTable)
    do
        returnString = returnString..sortTable[i].tag..": "..sortTable[i].count.."; "
    end

    return returnString;
end
