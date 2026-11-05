require("TIHYD/Aging")
require("TIHYD/CharacterCreation")
require("TIHYD/CharacterInfo")

Events.OnInitGlobalModData.Add(TIHYD.build)
Events.OnCreatePlayer.Add(TIHYD.init)
Events.EveryDays.Add(TIHYD.main)
