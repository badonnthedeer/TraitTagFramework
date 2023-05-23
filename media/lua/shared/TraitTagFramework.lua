TraitTags = {}

local function sanitizeTags(tagString)
    --remove all spaces, control characters, null, punctuation & symbols (except commas)
    local workString = tagString:gsub('[^%w,]', '')
    return workString;
end

--Uses alphanumberic symbols and commas only.
function TraitTags:add(traitName, tags)
    local sanitizedTags = sanitizeTags(tags);
    local tagTable = {};
    --local prevComma = 0;
    --local currChar = '';
    if TraitFactory:getTrait(traitName)
    then
        if string.len(sanitizedTags) > 0
        then
            print("Trait Tags: inserting table entry "..traitName.." to TraitTags.");
            table.insert(TraitTags, traitName);
            print("Trait Tags: adding tags "..sanitizedTags.." to "..traitName.." entry.");
            for i = 1, string.len(sanitizedTags)
            do
                --[[currChar = sanitizedTags:sub(i,i)
                if currChar == ','
                then
                    table.insert(tagTable, sanitizedTags:sub(prevComma + 1, i));
                    prevComma = i;
                elseif i >= string.len(sanitizedTags)
                then
                    table.insert(tagTable, sanitizedTags:sub(prevComma + 1, i));
                end]]
                table.insert(string.split(sanitizedTags, ','));
            end
            table.insert(traitName, tagTable);
        else
            print("Trait Tags: No tags detected for "..traitName..", skipping...");
        end
    else
        print("Trait Tags: Cannot find trait "..traitName..", skipping...");
    end
end

function TraitTags:remove(traitName)
    if TraitTags[traitName]
    then
        table.remove(TraitTags, traitName)
    else
        print("Trait Tags: No entry found for "..traitName..", cannot remove. Skipping...")    
    end
end

function TraitTags:getTagTable(traitName)
    if TraitTags[traitName]
    then
        return TraitTags[traitName]
    else
        print("Trait Tags: No entry found for "..traitName..", cannot get tag table. Skipping...")    
    end
end

function TraitTags:toString()
    local returnString = "";

    for trait, tagTable in ipairs(TraitTags) 
    do
        returnString = returnString..trait..": "
        --[[for _, tag in ipairs(tagTable)
        do
            returnString = returnString..tag..", "
        end]]
        returnString = returnString..table.concat(tagTable, ',');
        --returnString = returnString:sub(1, string.len(returnString) - 2);
        returnString = returnString.."; "
    end

    return returnString;
end

function TraitTags:tagTableToString(traitName)
    local returnString = "";

    if TraitTags[traitName]
    then
       --[[ for _, tag in ipairs(TraitTags[traitName])
        do
            returnString = returnString..tag..", "
        end
        returnString = returnString:sub(1, string.len(returnString) - 2);
        return returnString;]]
        returnString = table.concat(TraitTags[traitName], ',');
    else
        print("Trait Tags: No entry found for "..traitName..", cannot stringify tag table. Skipping...")    
    end
end

