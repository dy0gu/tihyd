require("TIHYD/Aging")
require("TIHYD/CharacterCreation")

Events.OnInitGlobalModData.Add(TIHYD.build)
Events.OnCreatePlayer.Add(TIHYD.init)
Events.EveryDays.Add(TIHYD.main)
