require("TIHYD/Aging")
require("TIHYD/CharacterCreation")
require("TIHYD/CharacterInfo")

Events.OnInitGlobalModData.Add(TIHYD.loadConfig)
Events.OnCreatePlayer.Add(TIHYD.initializePlayer)
Events.EveryDays.Add(TIHYD.processAllPlayersDaily)
