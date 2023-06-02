local TraitTags = {}
TraitTags.tags = {}

TraitTags.sanitizeTags = function(tagString)
    --remove all spaces, control characters, null, punctuation & symbols (except commas)
    local workString = tagString:gsub('[^%w,]', '')
    return workString;
end


TraitTags.toString = function()
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


TraitTags.tagTableToString= function(traitName)
    local returnString = "";

    if TraitTags[traitName] ~= nil
    then
        returnString = table.concat(TraitTags[traitName], ',');
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot stringify tag table. Skipping...")
    end
    return returnString;
end


--Uses alphanumberic symbols and commas only.
TraitTags.add = function(traitName, tags)
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


TraitTags.remove = function(traitName)
    if TraitTags[traitName] ~= nil
    then
        table.remove(TraitTags, traitName)
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot remove. Skipping...")
    end
end


TraitTags.getTraitTags = function()
    return TraitTags;
end


TraitTags.getTagTable = function()
    if TraitTags[traitName] ~= nil
    then
        return TraitTags[traitName]
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot get tag table. Skipping...")
    end
end


TraitTags.getTagStatistics = function()
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

    --condense (limitation: cannot make a sorted table in vanilla lua. Return as string instead.)

    for _,entry in pairs(sortTable)
    do
        returnString = returnString..entry.tag..": "..entry.count.."; "
    end

    return returnString;
end


TraitTags.getPlayerTraitTags = function(player)
    local playerTraits = player:getTraits();
    local concatenatedTags = "";
    local returnString = "";

    if playerTraits ~= nil
    then
        for i = 1, playerTraits:size() -1
        do
            local trait = playerTraits:get(i);

            if TraitTags[trait] ~= nil
            then
                concatenatedTags = "";
                for _,tag in pairs(TraitTags[trait])
                do
                    if not returnString:contains(tag)
                    then
                        concatenatedTags = concatenatedTags..","..tag;
                    end
                end
                returnString = returnString..concatenatedTags;
            end
        end
    end
    returnString = returnString:sub(2, returnString:len())
    return returnString;
end


TraitTags.getPlayerTagStatistics = function(player)
    local playerTraits = player:getTraits();
    local trait = {};
    local tagTable = {};
    local tempTable = {};
    local sortTable = {};
    local returnString = "";


    --get
    for i=1, playerTraits:size() -1
    do
        trait = playerTraits:get(i);
        if TraitTags[trait] ~= nil
        then
            tagTable = TraitTags[trait];
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

    --condense (limitation: cannot make a sorted table in vanilla lua. Return as string instead.)

    for _,entry in pairs(sortTable)
    do
        returnString = returnString..entry.tag..": "..entry.count.."; "
    end

    return returnString;
end


TraitTags.PlayerHasTag = function(player, targetTag)
    local playerTraits = player:getTraits();
    local trait = {};
    local tagTable = {};

    for i=1, playerTraits:size() -1
    do
        trait = playerTraits:get(i);
        if TraitTags[trait] ~= nil
        then
            tagTable = TraitTags[trait];
            for _, tag in ipairs(tagTable)
            do
                if tag == targetTag
                    then
                    return true;
                end
            end
        end
    end
    return false;
end


TraitTags.PlayerTagCountLargerThan = function(player, subjectTag, comparatorTag)
    local stats = TraitTags:getPlayerTagStatistics(player);
    local subjectIndexS, subjectIndexE = stats:find(subjectTag);
    local comparatorIndexS, comparatorIndexE = stats:find(comparatorTag);

    if subjectIndexS ~= nil and comparatorIndexS ~= nil
    then
        if subjectIndexS > comparatorIndexS
        then
            return true;
        else
            return false;
        end
    else
        if getDebug()
        then
            print("TraitTags: PlayerTagLargerCountThan(): One or more of the given tags is null");
        end
        return nil;
    end
end


TraitTags.TTInit= function()
    if not ModData.exists(TraitTags)
    then
        ModData.add("TraitTags", TraitTags.tags)
        if getDebug()
        then
            print("TraitTags: ModData table created.")
        end
    end
end


Events.OnGameBoot.Add(TTInit);
--Events.OnNewGame.Add(TTInit);
--Events.OnInitGlobalModData.Add(TTInit)