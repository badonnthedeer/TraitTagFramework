# TraitTagFramework
A Project Zomboid framework for adding user-defined strings correlating to player traits. Trait tags are stored in a table accessed by a module and has built-in functions.
<h1>A message from the creator</h1>
Do you really enjoy this mod, or even better want to build off of it? Please consider <a href="https://ko-fi.com/badonnthedeer">donating to me</a> so I can pay my bills. I'm recently unemployed and every little bit helps!
<h1>How to Use:</h1>
Declare the module before it's needed (typically at the beginning of the file) with<br>
<code>local TTF = require("TraitTagFramework");</code><br>
Depending on your use case, you'll want to add your tags before the player is created. To do this, make a function that gets added to the OnGameBoot event with<br>
<code>Events.OnGameBoot.Add([your function here])</code><br>
If you're creating new traits, feel free to mingle  your trait and tag declarations together, like so:<br>
<code>local AT_Carpenter = TraitFactory.addTrait("AT_Carpenter", getText("UI_trait_AT_Carpenter"), 2, getText("UI_trait_AT_Carpenter_desc"), false);<br>
AT_Carpenter:addXPBoost(Perks.Woodwork, 1)<br>
<strong>TTF.Add("AT_Carpenter", "Anthro,HabitatBuilder");</strong></code>
<h1>Available Functions</h1>
<ul>
<li><h3>ToString()</h3>
Returns the entirety of the table and tags in a string.</li>
<li><h3>TagTableToString(string traitName)</h3>
Returns the tags associated with a trait as a string</li>
<li><h3>Add(string traitName, string tags)</h3>
Add(s) tag(s) to the TraitTags module.<br>
<strong>Note: For tags, use alphanumeric symbols only, and separate each tag with a comma.</strong>
</li>
<li><h3>Remove(string traitName)</h3>
Removes a trait and all of its tags from the TraitTags module.
</li>
<li><h3>RemoveTag(string traitName, string tag)</h3>
Removes the specified tag from the specified trait in the TraitTags module.
</li>
<li><h3>GetTable()</h3>
Returns the entirety of the TraitTags table as a table.
</li>
<li><h3>GetTagTable(string traitName)</h3>
Returns the table of tags associated with a trait as a table.
</li>
<li><h3>GetTagStatistics()</h3>
Returns a string containing each tag used, and how many times they're used.<br>
Note: I find this helpful for balancing purposes.
</li>
<li><h3>GetPlayerTraitTags(Player player)</h3>
Returns a string containing each tag a player has.<br>
</li>
<li><h3>GetPlayerTagStatistics(Player player)</h3>
Returns a string containing each tag and the amount(count) of each the player has. This list in the string is ordered by count.<br>
String format: "[tag]: [count]; [tag]: [count];..."
</li>
<li><h3>PlayerHasTag(Player player, string targetTag)</h3>
Returns a boolean, which is true if the player has the targetTag.
</li>
<li><h3>PlayerTagCountLargerThan(Player player, string subjectTag, string comparatorTag)</h3>
Returns a boolean, which is true only if the subjectTag's count is larger than the comparatorTag's count.<br>
Note: This will also return false if one of the tags cannot be found (with a console print warning of a nil if debug mode is on).
</li>
</ul>
<h1>All Vanilla Traits put in .Add</h1>
Here's a list of all vanilla traits with an example name for your Trait Tags module. This will work in whatever function you add it,
just add your own tags and run. (current as of build 41):
<br>TTF.add("Axeman", "");
<br>TTF.add("Handy", "");
<br>TTF.add("SpeedDemon", "");
<br>TTF.add("SundayDriver", "");
<br>TTF.add("Brave", "");
<br>TTF.add("Cowardly", "");
<br>TTF.add("Clumsy", "");
<br>TTF.add("Graceful", "");
<br>TTF.add("ShortSighted", "");
<br>TTF.add("HardOfHearing", "");
<br>TTF.add("Deaf", "");
<br>TTF.add("KeenHearing", "");
<br>TTF.add("EagleEyed", "");
<br>TTF.add("HeartyAppitite", "");
<br>TTF.add("LightEater", "");
<br>TTF.add("ThickSkinned", "");
<br>TTF.add("Unfit", "");
<br>TTF.add("Out of Shape", "");
<br>TTF.add("Fit", "");
<br>TTF.add("Athletic", "");
<br>TTF.add("Nutritionist", "");
<br>TTF.add("Nutritionist2", "");
<br>TTF.add("Emaciated", "");
<br>TTF.add("Very Underweight", "");
<br>TTF.add("Underweight", "");
<br>TTF.add("Overweight", "");
<br>TTF.add("Obese", "");
<br>TTF.add("Strong", "");
<br>TTF.add("Stout", "");
<br>TTF.add("Weak", "");
<br>TTF.add("Feeble", "");
<br>TTF.add("Resilient", "");
<br>TTF.add("ProneToIllness", "");
<br>TTF.add("Agoraphobic", "");
<br>TTF.add("Claustophobic", "");
<br>TTF.add("Lucky", "");
<br>TTF.add("Unlucky", "");
<br>TTF.add("Marksman", "");
<br>TTF.add("NightOwl", "");
<br>TTF.add("Outdoorsman", "");
<br>TTF.add("FastHealer", "");
<br>TTF.add("FastLearner", "");
<br>TTF.add("FastReader", "");
<br>TTF.add("AdrenalineJunkie", "");
<br>TTF.add("Inconspicuous", "");
<br>TTF.add("NeedsLessSleep", "");
<br>TTF.add("NightVision", "");
<br>TTF.add("Organized", "");
<br>TTF.add("LowThirst", "");
<br>TTF.add("Burglar", "");
<br>TTF.add("FirstAid", "");
<br>TTF.add("Fishing", "");
<br>TTF.add("Gardener", "");
<br>TTF.add("Jogger", "");
<br>TTF.add("SlowHealer", "");
<br>TTF.add("SlowLearner", "");
<br>TTF.add("SlowReader", "");
<br>TTF.add("NeedsMoreSleep", "");
<br>TTF.add("Conspicuous", "");
<br>TTF.add("Disorganized", "");
<br>TTF.add("HighThirst", "");
<br>TTF.add("Illiterate", "");
<br>TTF.add("Insomniac", "");
<br>TTF.add("Pacifist", "");
<br>TTF.add("Thinskinned", "");
<br>TTF.add("Smoker", "");
<br>TTF.add("Tailor", "");
<br>TTF.add("Dextrous", "");
<br>TTF.add("AllThumbs", "");
<br>TTF.add("Desensitized", "");
<br>TTF.add("WeakStomach", "");
<br>TTF.add("IronGut", "");
<br>TTF.add("Hemophobic", "");
<br>TTF.add("Asthmatic", "");
<br>TTF.add("Cook", "");
<br>TTF.add("Cook2", "");
<br>TTF.add("Herbalist", "");
<br>TTF.add("Brawler", "");
<br>TTF.add("Formerscout", "");
<br>TTF.add("BaseballPlayer", "");
<br>TTF.add("Hiker", "");
<br>TTF.add("Hunter", "");
<br>TTF.add("Gymnast", "");
<br>TTF.add("Mechanics", "");
<br>TTF.add("Mechanics2", "");
<h1>Credits</h1>
Special thanks to the Project Zomboid discord modding community for their tireless answering of my questions. Particular thanks to Albion, who has a seemingly encyclopedic knowledge of PZ properties, functions, and modding. You helped a lot :)