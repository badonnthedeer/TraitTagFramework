local TraitTags = {};
TraitTags.tags = {};

TraitTags.SanitizeTags = function(tagString)
    --remove all spaces, control characters, null, punctuation & symbols (except commas)
    local workString = tagString:gsub('[^%w,]', '');
    return workString;
end


TraitTags.ToString = function()
    local returnString = "";


    for trait, tagTable in pairs(TraitTags.tags)
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


TraitTags.TagTableToString = function(traitName)
    local returnString = "";


    if TraitTags.tags[traitName] ~= nil
    then
        returnString = table.concat(TraitTags.tags[traitName], ',');
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot stringify tag table. Skipping...");
    end
    return returnString;
end


--Uses alphanumberic symbols and commas only.
TraitTags.Add = function(traitName, tags)
    local sanitizedTags = TraitTags.SanitizeTags(tags);
    local tagTable = {};
    if TraitFactory.getTrait(traitName) ~= nil
    then
        if TraitTags.tags[traitName] == nil
        then
            print("Trait Tag Framework: Initializing entry for "..traitName.." in TraitTags");
            TraitTags.tags[traitName] = {};
        end
        if string.len(sanitizedTags) > 0
        then
            tagTable =  string.split(sanitizedTags, ',');
            print("Trait Tag Framework: adding tags "..sanitizedTags.." to "..traitName.." entry.");
            TraitTags.tags[traitName] = tagTable;
        else
            print("Trait Tag Framework: No tags detected for "..traitName..", skipping...");
        end
    else
        print("Trait Tag Framework: Cannot find trait "..traitName..", skipping...");
    end
end


TraitTags.Remove = function(traitName)
    if TraitTags.tags[traitName] ~= nil
    then
        table.remove(TraitTags.tags, traitName);
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot remove. Skipping...");
    end
end

TraitTags.RemoveTag = function(traitName, tag)
    local traitEntry = TraitTags.tags[traitName];
    if traitEntry ~= nil and traitEntry:contains("tag")
    then
        local tagIndexS, tagIndexE = traitEntry:find(tag);
        if tagIndexS  ~= 1
        then
            TraitTags.tags[traitName] = traitEntry:sub(1,tagIndexS)..traitEntry:sub(tagIndexE + 1, traitEntry:len());
        else
            traitEntry:sub(tagIndexE + 1, traitEntry:len());
        end
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot remove. Skipping...");
    end
end

TraitTags.GetTable = function()
    return TraitTags.tags;
end


TraitTags.GetTagTable = function(traitName)
    if TraitTags.tags[traitName] ~= nil
    then
        return TraitTags.tags[traitName];
    else
        print("Trait Tag Framework: No entry found for "..traitName..", cannot get tag table. Skipping...");
    end
end


TraitTags.GetTagStatistics = function()
    local tempTable = {};
    local sortTable = {};
    local returnString = "";

    --get
    for trait, tagTable in pairs(TraitTags.tags)
    do
        if type(tagTable) == "table"
        then
            for _, tag in ipairs(tagTable)
            do
                if tempTable[tag] ~= nil
                then
                    tempTable[tag] = tempTable[tag] + 1;
                else
                    tempTable[tag] = 1;
                end
            end
        end
    end

    --sort
    for key, value in pairs(tempTable) do
        table.insert(sortTable, {tag = key, count = value});
    end
    table.sort(sortTable, function(a, b) return a.count > b.count end);

    --condense (limitation: cannot make a sorted table in vanilla lua. Return as string instead.)

    for _,entry in pairs(sortTable)
    do
        returnString = returnString..entry.tag..": "..entry.count.."; ";
    end

    return returnString;
end


TraitTags.GetPlayerTraitTags = function(player)
    local playerTraits = player:getTraits();
    local concatenatedTags = "";
    local returnString = "";

    if playerTraits ~= nil
    then
        for i = 0, (playerTraits:size() -1)
        do
            local trait = playerTraits:get(i);

            if TraitTags.tags[trait] ~= nil
            then
                concatenatedTags = "";
                for _,tag in pairs(TraitTags.tags[trait])
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
    returnString = returnString:sub(2, returnString:len());
    return returnString;
end


TraitTags.GetPlayerTagStatistics = function(player)
    local playerTraits = player:getTraits();
    local trait = {};
    local tagTable = {};
    local tempTable = {};
    local sortTable = {};
    local returnString = "";

    --get
    for i = 0, (playerTraits:size() -1)
    do
        trait = playerTraits:get(i);
        if TraitTags.tags[trait] ~= nil
        then
            tagTable = TraitTags.tags[trait];
            for _, tag in ipairs(tagTable)
            do
                if tempTable[tag] ~= nil
                then
                    tempTable[tag] = tempTable[tag] + 1;
                else
                    tempTable[tag] = 1;
                end
            end
        end
    end


    --sort
    for key, value in pairs(tempTable) do
        table.insert(sortTable, {tag = key, count = value});
    end
    table.sort(sortTable, function(a, b) return a.count > b.count end);

    --condense (limitation: cannot make a sorted table in vanilla lua. Return as string instead.)

    for _,entry in pairs(sortTable)
    do
        returnString = returnString..entry.tag..": "..entry.count.."; ";
    end

    return returnString;
end


TraitTags.PlayerHasTag = function(player, targetTag)
    local playerTraits = player:getTraits();
    local trait = {};
    local tagTable = {};

    for i = 0, (playerTraits:size() -1)
    do
        trait = playerTraits:get(i);
        if TraitTags.tags[trait] ~= nil
        then
            tagTable = TraitTags.tags[trait];
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
    local stats = TraitTags.GetPlayerTagStatistics(player);
    local subjectIndexS, subjectIndexE = stats:find(subjectTag);
    local comparatorIndexS, comparatorIndexE = stats:find(comparatorTag);

    if subjectIndexS ~= nil and comparatorIndexS ~= nil
    then
        local subjectCountIndexS, subjectCountIndexE = stats:find("%d+", subjectIndexE);
        local comparatorCountIndexS, comparatorCountIndexE = stats:find("%d+", comparatorIndexE);

        local subjectCount = stats:sub(subjectCountIndexS, subjectCountIndexE);
        local comparatorCount = stats:sub(comparatorCountIndexS, comparatorCountIndexE);

        if tonumber(subjectCount) > tonumber(comparatorCount)
        then
            return true;
        else
            return false;
        end
    else
        if getDebug()
        then
            print("Trait Tag Framework: PlayerTagLargerCountThan(): One or more of the given tags is null");
        end
        return false;
    end
end


TraitTags.GetAllTraitsWithTag = function(subjectTag)
    local tagTable = TraitTags.tags[trait];
    local matchingTraits = {};

    for traitName, tags in ipairs(tagTable)
    do
        if tags:contains(subjectTag)
        then
            matchingTraits:add(TraitFactory:getTrait(traitName));
        end
    end

    return matchingTraits;
end

return TraitTags;