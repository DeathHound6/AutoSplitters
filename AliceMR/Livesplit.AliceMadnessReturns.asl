// Version: 0.3.0-final

/*
## Changelog

0.1.0 - 2016.xx.xx

for the old version (before Dec 2022), by KC (aka KinkyCadence, Any% runner),
he used it during his WR/PB in 2016, it only does load removing

0.2.0 - 2020.xx.xx

for the old version (before Dec 2022), by Voxelse,
does everything (start, reset, IGT, load removing, IL chapters)

0.3.0 - 2024.03.18

for "Dec 2022" version, by Ankaid & PainGreed.
It's an updated version (with new memory addresses) of Voxelse's v0.2.0 with some improvements/fixes.

- new: the plugin has been rewritten for the latest game version (Dec 2022). It doesn't support the old version anymore.
- new: add "Monastery Shelf Valley - Liddell Memory (ingame)" split
- change: rename a split: "Monastery Shelf Valley - Liddell Memory" -> "Monastery Shelf Valley - Liddell Memory (loading)"
- change: descrease "Horn" area size: 750f -> 200f
- change: disable some splits by default (only for new clean setups)
- fix: run "split" logic during all "isLoading=True" frames, not only on a 1st loading frame
- new: add "Version" fake setting (just for information about the plugin)

- enhancement: improve handling of "Main menu" map in "split" action
- dev: split detection area is now adjustable for each split individually (750f default)
- dev: improve logic of debug prints
- dev: set low Livesplit frame rate (2 fps) if debug is enabled
- dev: rename: vars.splitPos -> vars.splits,  vars.splits -> vars.visited
- dev: add some comments to the code

## TODO
- add tooltips for tricky splits (both "scroll exit"s)
- recheck consistency of the splits disabled by default (ankaid has problems with them in v0.2.0 or they were not necessary)

## Types

Tuple<bool, float, bool, Vector3f, string>
    Item1 - bool  - isCheckedOnlyDuringLoading
    Item2 - float - maxVecDifference
    Item3 - bool  - is a split enabled in settings by default
    Item4 - Vector3f - coords of a split (x, y, z)
    Item5 - string   - an id/title of a setting (in Livesplit UI) related to a split

## How to release

- set vars.debugEnabled = false;
- change "Version" in settings.Add()
- copy to ./releases/Livesplit.AliceMadnessReturns-<version>.asl
- post a file from "relases" dir and a changelog to the Discord #tech channel (pin the message if it's possible)
- upload to "Resources" on srcom: https://www.speedrun.com/amr/resources
*/

state("AliceMadnessReturns") {}

startup {
    vars.debugEnabled = false;

    // chapter settings are not used ???
    settings.Add("Chapter1", true, "Chapter 1 - Hatter's Domain");
    settings.Add("Chapter2", true, "Chapter 2 - Deluded Depths");
    settings.Add("Chapter3", true, "Chapter 3 - Oriental Grove");
    settings.Add("Chapter4", true, "Chapter 4 - Queensland");
    settings.Add("Chapter5", true, "Chapter 5 - The Dollhouse");
    settings.Add("Chapter6", true, "Chapter 6 - Infernal Train");

    settings.Add("C_Start", false, "Auto-Start for Individual Chapters");

    vars.splits = new Dictionary<string, List<Tuple<bool, float, bool, Vector3f, string>>>() {
        {"Chapter1_L1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, false, new Vector3f(-121104.8f, 133311.8f, -109116.9f), "Houndsditch Home - Rooftop")
        }},
        {"Chapter1_W1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-143162.8f, -71054.6f, -134682.3f), "The Vale of Tears"),
            // Slug with a Shell
            // The Crockery
            Tuple.Create(false, 200f, true,  new Vector3f(-105929.5f, -134021.8f, -131036f),   "Trigger: Horn To Hatter's Gate"),
            Tuple.Create(true,  750f, true,  new Vector3f(-50729.85f, -137103.9f, -130469.1f), "Hatter's Gate")
            // Always Elevenses
        }},
        {"Chapter1_W2_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-91048.02f, 947.9908f, -4818.92f),   "Always Elevenses - Clockwork Bomb"),
            Tuple.Create(true,  750f, false, new Vector3f(-84845.62f, 6713.691f, -1947.022f),  "About Face - Liddell Memory"),
            // About Face
            Tuple.Create(true,  750f, false, new Vector3f(-94505.41f, 7329.168f, -1228.23f),   "About Face - Elevator"),
            Tuple.Create(true,  750f, true,  new Vector3f(16976.97f, -92662.27f, 1497.406f),   "Smelling and Regurgitating"),
            Tuple.Create(true,  750f, false, new Vector3f(24200.41f, -105594f, 2662f),         "Smelling and Regurgitating - Zone 2"),
            Tuple.Create(true,  750f, true,  new Vector3f(-95021.53f, 4842.74f, -1734.546f),   "About Face - Back to Center"),
            Tuple.Create(true,  750f, false, new Vector3f(-94505.41f, 7329.168f, -1228.23f),   "About Face - Elevator bis"),
            Tuple.Create(true,  750f, false, new Vector3f(19094.85f, 157968.5f, 479.3957f),    "Cranking Up & Pressing Down"),
            Tuple.Create(true,  750f, false, new Vector3f(9029.268f, 181402.9f, 2866.101f),    "Cranking Up & Pressing Down - Zone 2"),
            Tuple.Create(true,  750f, true,  new Vector3f(137887.9f, 8691.061f, -595.816f),    "Assemblage (or Destruction)")
        }},        
        {"Chapter2_L1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-47383.54f, -15982.41f, 600.7722f),  "Billingsgate")
        }},
        {"Chapter2_W1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(113254.2f, -76914.14f, 311.8564f),   "Tundraful"),
            Tuple.Create(true,  750f, false, new Vector3f(125714.9f, -67787.62f, 6691.982f),   "Sliding toward Oblivion"),
            Tuple.Create(true,  750f, true,  new Vector3f(-134187.8f, -68716.9f, 110504.2f),   "HMS Gryphon")
        }},
        {"Chapter2_W2_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-107912.4f, 132039.7f, 14325.22f),   "Naval Disaster"),
            Tuple.Create(true,  750f, true,  new Vector3f(12677.41f, 177859.7f, 43016.92f),    "Barrelbottom"),
            Tuple.Create(true,  750f, true,  new Vector3f(-33298.88f, 102112.8f, -1229.45f),   "Barrelbottom - Dreary Lane Theatre"),
            Tuple.Create(true,  750f, true,  new Vector3f(80753.61f, -166550.2f, 1551.779f),   "Inky Veil")
        }},
        {"Chapter2_W3_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-22199.14f, 68772.73f, -1649.233f),  "Choral Coral"),
            // Oyster Garden: Beds Available
            Tuple.Create(true,  750f, true,  new Vector3f(-26525.89f, 140491f, 1397.072f),     "Lost Souls Locker"),
            Tuple.Create(true,  750f, false, new Vector3f(133305.3f, -23020.03f, 212.8431f),   "Lost Souls Locker - Right Crypt Enter"),
            Tuple.Create(true,  750f, false, new Vector3f(-39478.11f, 145881.1f, 3482.234f),   "Lost Souls Locker - Right Crypt Exit"),
            Tuple.Create(true,  750f, false, new Vector3f(130968.3f, -9532.125f, 212.8431f),   "Lost Souls Locker - Left Crypt Enter"),
            Tuple.Create(true,  750f, false, new Vector3f(-36788.85f, 145708.7f, 3348.289f),   "Lost Souls Locker - Left Crypt Exit"),
            Tuple.Create(true,  750f, false, new Vector3f(130265.6f, 4958.536f, 212.8431f),    "Lost Souls Locker - Center Crypt Enter"),
            Tuple.Create(true,  750f, false, new Vector3f(-38142.93f, 147456.1f, 3591.008f),   "Lost Souls Locker - Center Crypt Exit"),
            Tuple.Create(true,  750f, true,  new Vector3f(-17798.04f, 124051.6f, 9650.9f),     "Barrelbottom Revisited")
        }},
        {"Chapter3_L1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(43539.08f, -83053.16f, 116981f),     "Threadneedle Street"),
            Tuple.Create(true,  750f, true,  new Vector3f(27577.55f, -51703.76f, 117670f),     "Vale of Doom")
        }},
        {"Chapter3_W1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(123519.5f, -129330f, -2593.363f),    "Scorched Earth"),
            Tuple.Create(true,  750f, true,  new Vector3f(-145791f, -234140.3f, 66619.65f),    "Scroll of Happy Times"),
            Tuple.Create(true,  750f, true,  new Vector3f(149132.6f, 43427.4f, 1586f),         "Scroll of Happy Times - Exit"),
            Tuple.Create(true,  750f, true,  new Vector3f(110298.2f, -11904.4f, 18635.73f),    "Monastery Shelf Valley"),
            Tuple.Create(true,  750f, false, new Vector3f(125638.3f, 34162.68f, 3840.933f),    "Monastery Shelf Valley - Liddell Memory (loading)"),
            Tuple.Create(false, 750f, true,  new Vector3f(125773.8f, 34567.30f, 3842.504f),    "Monastery Shelf Valley - Liddell Memory (ingame)"), // the point is ~ in the center of the platform
            Tuple.Create(true,  750f, true,  new Vector3f(97189.2f, 13658.15f, 17789.49f),     "Monastery Shelf Valley - Glide")
        }},
        {"Chapter3_W2_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-125666.7f, 132800.7f, -19598.68f),  "Trunk"),
            Tuple.Create(true,  750f, true,  new Vector3f(-89304.86f, 81629.91f, 17964f),      "Trunk - Top"),
            Tuple.Create(true,  750f, true,  new Vector3f(-145758.4f, -152724.4f, 71758.59f),  "Scroll of Dark Skies")
        }},
        {"Chapter3_W3_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(40203.8f, 90877.68f, -1823.834f),    "Weast Peak Prison Village"),
            // Hellish Hive
            Tuple.Create(true,  750f, true,  new Vector3f(-145921.1f, -127118.9f, 73550.69f),  "Scroll of Destiny"),
            Tuple.Create(true,  750f, true,  new Vector3f(159108.5f, 148457.3f, 4154.166f),    "Peak Temple")
        }},
        {"Chapter4_L1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(167.2345f, -992.4897f, 66f),         "Bow-Sreet Lock-Up"),
            Tuple.Create(true,  750f, true,  new Vector3f(-650.9072f, 19647.46f, -5311f),      "Cardbridge"),
            Tuple.Create(true,  750f, false, new Vector3f(-20286.55f, 24449.96f, -32483.68f),  "Cardbridge - Castle")
        }},
        {"Chapter4_W1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(79378.91f, -138761.1f, 14468.42f),   "Least Wing")
        }},
        {"Chapter4_W2_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-34548.13f, -68170.58f, -8198.999f), "Waste Wing Part 1"),
            Tuple.Create(true,  750f, false, new Vector3f(36224.66f, -188833.4f, -6525.948f),  "Waste Wing Part 1 - Executioner Fight"),
            Tuple.Create(true,  750f, false, new Vector3f(-7103.991f, -64807.59f, -7637.99f),  "Waste Wing Part 2")
        }},
        {"Chapter4_W3_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-18145.9f, -58544.73f, -9087.999f),  "Labyrinthine Revenge"),
            Tuple.Create(true,  750f, true,  new Vector3f(31655.56f, -59703.04f, -25550.9f),   "Harder they Fall"),
            Tuple.Create(true,  750f, true,  new Vector3f(34071.25f, 74200.09f, 20029f),       "Dark of Heartness")
        }},
        {"Chapter5_L1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-3229.494f, 115408.6f, 2512f),       "Rutledge Asylum"),
            Tuple.Create(true,  750f, true,  new Vector3f(26139.15f, 109511.4f, 2078.361f),    "Hide Park")
        }},
        {"Chapter5_W1_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(41046.14f, 73661.92f, -1475.516f),   "Fort Resistance"),
            // Frogs Way
            Tuple.Create(true,  750f, true,  new Vector3f(-79139.47f, -122175.3f, -4831.008f), "Off With Her Head Part 1"),
            Tuple.Create(true,  750f, true,  new Vector3f(-79068.68f, -77419.27f, -15110.98f), "Off With Her Head Part 1 - Load 1"),
            Tuple.Create(true,  750f, true,  new Vector3f(-71795.53f, -13694.27f, -8575.012f), "Off With Her Head Part 1 - Load 2"),
            Tuple.Create(true,  750f, true,  new Vector3f(74062.09f, 99204.59f, 6709.85f),     "Dolltown Cellars"),
            Tuple.Create(true,  750f, true,  new Vector3f(46611.77f, 165909.6f, -1498.751f),   "Dolltown Cellars - Slide")
            // Dollgirl's Pursuit
        }},
        {"Chapter5_W2_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(-878.5466f, 55078.02f, -4566f),      "Fort Resistance Delivered")
        }},
        {"Chapter5_W3_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(51230.15f, 128246.5f, 7750.255f),    "Looking Glass Railway Station"),
            Tuple.Create(true,  750f, true,  new Vector3f(15677.7f, -11832.72f, -1563.315f),   "Off With Her Head Part 2"),
            Tuple.Create(true,  750f, true,  new Vector3f(35640.95f, 223.0195f, -6834.925f),   "Off With Her Head Part 2 - Load 1"),
            Tuple.Create(true,  750f, true,  new Vector3f(32916.75f, -34233.54f, -339.5117f),  "Off With Her Head Part 2 - Load 2"),
            Tuple.Create(true,  750f, true,  new Vector3f(5366.389f, 110441.4f, -5174.123f),   "Off With Her Head Part 2 - Exit"),
            Tuple.Create(true,  750f, true,  new Vector3f(134648.6f, -113977.7f, 34311.09f),   "Dollmaker's Workshop"),
            Tuple.Create(true,  750f, true,  new Vector3f(181540.7f, -62085.9f, 33564.5f),     "Dollmaker's Workshop - Inside")
        }},
        {"Chapter6_P", new List<Tuple<bool, float, bool, Vector3f, string>>() {
            Tuple.Create(true,  750f, true,  new Vector3f(208150.6f, 177302.8f, 210723f),      "Whitechapel"),
            Tuple.Create(true,  750f, false, new Vector3f(-152821.8f, -180446.2f, -22136.82f), "Infernal Train Carriage"),
            // Dollmaker Part 1
            Tuple.Create(true,  750f, true,  new Vector3f(58855.39f, 79584.75f, -22376.82f),   "Dollmaker Part 2"),
            Tuple.Create(true,  750f, true,  new Vector3f(230808f, 450.4799f, 86617.7f),       "The End")
        }}
    };

    foreach(KeyValuePair<string, List<Tuple<bool, float, bool, Vector3f, string>>> kvp in vars.splits)
    {
        string chapterName = kvp.Key.Substring(0, 8);
        foreach(Tuple<bool, float, bool, Vector3f, string> tup in kvp.Value)
            settings.Add(tup.Item5, tup.Item3, tup.Item5, chapterName);
    }

    settings.Add("End", true, "End", "Chapter6");

    settings.Add("Version", false, "Version: 0.3.0-final - 2024.03.18");
    settings.SetToolTip("Version", "This setting doesn't affect anything. It's just for information.");

    vars.visited = new HashSet<string>();
    vars.endTouched = false;  // to avoid multiple splits in the end

    vars.ResetVars = (EventHandler)((s, e) => {
        vars.visited = new HashSet<string>();
    });
    timer.OnStart += vars.ResetVars;

    if (vars.debugEnabled)
    {
        print("[INFO] Debug is enabled !!! LiveSplit frame rate is decreased to 2 fps");
        refreshRate = 2d;
    }
    else
    {
        refreshRate = 100/3d;
    }
}

init {
    vars.watchers = new MemoryWatcherList() {
        // we use 2 addresses to detect loading, because we haven't found just one reliable address,
        // but there 2 ones seems like cover most of cases without false positives
        // 1st doesn't work after getting Umbrella and in some other places
        // 2nd looks as the most stable and reliable
        // prev 0x01107798
        (vars.isLoading  = new MemoryWatcher<bool>(new DeepPointer(0x01083B10))),

        (vars.isLoading2 = new MemoryWatcher<bool>(new DeepPointer(0x01081E38))),

        // prev 0x01105024, 0x504, 0x0), 32
        (vars.level = new StringWatcher(new DeepPointer(0x0107F744, 0x504, 0x0), 32)),

        // we haven't found and don't use "player" for XYZ coords for now (do we need ???)
        // (vars.player = new MemoryWatcher<int>(new DeepPointer(0x01105024, 0x47C, 0x0, 0x40, 0x22C)))

        // the new (direct) coords
        (vars.modelX = new MemoryWatcher<float>(new DeepPointer(0x010820E8, 0x1C, 0xA8, 0x22C, 0x58, 0x18, 0x4C, 0x64))),
        (vars.modelY = new MemoryWatcher<float>(new DeepPointer(0x010820E8, 0x1C, 0xA8, 0x22C, 0x58, 0x18, 0x4C, 0x68))),
        (vars.modelZ = new MemoryWatcher<float>(new DeepPointer(0x010820E8, 0x1C, 0xA8, 0x22C, 0x58, 0x18, 0x4C, 0x6C))),
    };
}

update {
    vars.watchers.UpdateAll(game);
}

start {
    return (! String.IsNullOrEmpty(vars.level.Current) && ! vars.level.Current.Equals(vars.level.Old))
        && (String.IsNullOrEmpty(vars.level.Old) || "AliceEntry".Equals(vars.level.Old))
        && (
            // new game - chapter 1
            "Chapter1_L1_P".Equals(vars.level.Current)
            // IL chapter logic
            || (settings["C_Start"] && (vars.level.Current[9] == 'L' || vars.level.Current[9] == 'P'))
    );
}

split {
    if (vars.debugEnabled) print("===");

    float x = vars.modelX.Current;
    float y = vars.modelY.Current;
    float z = vars.modelZ.Current;

    // the current "level" pointer doesn't work when you just launched the game and until you load a map (via "New Game" or "Chapter Select" menus)
    // in this case it's null and we should check it
    if (String.IsNullOrEmpty(vars.level.Current))
    {
        if (vars.debugEnabled) print("vars.level.Current IsNullOrEmpty");
        return false;
    }

    // also skip the "main menu" map
    if ("AliceEntry".Equals(vars.level.Current)) return false;

    List<Tuple<bool, float, bool, Vector3f, string>> loadList;
    vars.splits.TryGetValue(vars.level.Current, out loadList);

    if (loadList.Count >= 1)
    {
        foreach(Tuple<bool, float, bool, Vector3f, string> tup in loadList)
        {
            if (vars.debugEnabled) print(String.Format("Loc: title={0}, duringLoading={1}, vec={2}, ", tup.Item5, tup.Item1, tup.Item4));

            bool isCheckedOnlyDuringLoading = tup.Item1;
            float maxVecDifference = tup.Item2;
            Vector3f vec = tup.Item4;
            string levelName = tup.Item5;

            // skip if a split isn't enabled in settings
            bool enabledInSettings = settings[levelName];
            if (!enabledInSettings) continue;

            // skip already visited
            if (vars.visited.Contains(levelName)) continue;

            bool isLoading = vars.isLoading.Current || vars.isLoading2.Current;

            if (isLoading)
            {
                if (Math.Abs(vec.X - x) <= maxVecDifference
                    && Math.Abs(vec.Y - y) <= maxVecDifference
                    && Math.Abs(vec.Z - z) <= maxVecDifference
                )
                {
                    bool added = vars.visited.Add(levelName);
                    return added;
                }
                else
                {
                    if (vars.debugEnabled) print("EXIT: loading=True, math");
                }
            }
            else
            {
                // only "Horn" for now
                if (!isCheckedOnlyDuringLoading) {
                    if (Math.Abs(vec.X - x) <= maxVecDifference
                        && Math.Abs(vec.Y - y) <= maxVecDifference
                        && Math.Abs(vec.Z - z) <= maxVecDifference
                    )
                    {
                        bool added = vars.visited.Add(levelName);
                        return added;
                    }
                    else
                    {
                        if (vars.debugEnabled) print("EXIT: loading=False, math");
                    }
                }
                else
                {
                    if (vars.debugEnabled) print("EXIT: loading=False, isCheckedOnlyDuringLoading=True");
                }
            }
        }
    }

    // The end (the last split)
    if (
        !vars.endTouched
        && vars.level.Current.EndsWith("6_P", StringComparison.Ordinal)
        && Math.Abs(148884.8f - z) <= 1f
    )
    {
        float dX = x - 120496.19f;
        float dY = y - 200676.96f;
        if (dX * dX + dY * dY <= 513458.2336f)
        {
            vars.endTouched = true;
            return settings["End"];
        }
    }

    return false;
}

reset {
    return !"AliceEntry".Equals(vars.level.Old) && "AliceEntry".Equals(vars.level.Current);
}

isLoading {
    return vars.isLoading.Current || vars.isLoading2.Current;
}

shutdown {
    timer.OnStart -= vars.ResetVars;
}
