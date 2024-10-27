-- LocalScript pour l'ESP dans Roblox

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fonction pour créer un ESP
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Création d'un Highlight
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(210, 1, 3) -- Couleur de remplissage verte
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0) -- Couleur de contour noire
        highlight.FillTransparency = 0.5 -- Transparence de remplissage
        highlight.OutlineTransparency = 0 -- Transparence du contour

        -- Supprimer l'ESP lorsque le personnage est supprimé
        player.CharacterRemoving:Connect(function()
            highlight:Destroy()
        end)
    end
end

-- Vérifier les joueurs et appliquer l'ESP
local function checkPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)  -- Appliquer l'ESP à tous les joueurs existants
        end
    end
end

-- Événement pour les nouveaux joueurs
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createESP(player)  -- Créer l'ESP lorsque le personnage du nouveau joueur est ajouté
    end)
    
    -- S'assurer que l'ESP est créé immédiatement si le personnage est déjà présent
    if player.Character then
        createESP(player)
    end
end)

-- Vérifier au début pour les joueurs existants
checkPlayers()

-- Mettre à jour l'ESP si le personnage du joueur change
LocalPlayer.CharacterAdded:Connect(function()
    checkPlayers()
end)
