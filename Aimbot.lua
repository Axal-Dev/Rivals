-- Script Aimbot pour Rivals
-- Assurez-vous que ce script est exécuté dans un environnement où `setclipboard` est autorisé.

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local workspace = game:GetService("Workspace")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local camera = workspace.CurrentCamera
local aimAt = "Head"  -- Changez en "UpperTorso" ou "LowerTorso" si vous préférez viser une autre partie du corps.
local fov = 700  -- Le champ de vision pour détecter les ennemis
local aimSpeed = 5  -- Vitesse du déplacement de la visée vers la cible
local predictionMultiplier = 0.05  -- Multiplier pour ajuster la prédiction de la visée en fonction de la vitesse de la cible

-- Fonction pour calculer la position prédite de la cible
local function predict_position(targetPosition, velocity)
    return targetPosition + (velocity * predictionMultiplier)
end

-- Fonction pour récupérer la cible la plus proche du centre de l'écran
local function get_closest_target()
    local closestPlayer = nil
    local shortestDistance = fov

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild(aimAt) then
            local targetPart = player.Character[aimAt]
            local targetPosition = targetPart.Position
            local targetVelocity = player.Character.HumanoidRootPart.Velocity or Vector3.new(0, 0, 0)
            
            -- Calcul de la position prédite de la cible
            local predictedPosition = predict_position(targetPosition, targetVelocity)
            local screenPosition, onScreen = camera:WorldToViewportPoint(predictedPosition)
            
            if onScreen then
                local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                local distanceFromCenter = (Vector2.new(screenPosition.X, screenPosition.Y) - screenCenter).Magnitude

                if distanceFromCenter < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distanceFromCenter
                end
            end
        end
    end

    return closestPlayer
end

-- Fonction principale d'aimbot
local function aim_at_target()
    if userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = get_closest_target()
        
        if target and target.Character and target.Character:FindFirstChild(aimAt) then
            local targetPart = target.Character[aimAt]
            local targetPosition = targetPart.Position
            local predictedPosition = predict_position(targetPosition, target.Character.HumanoidRootPart.Velocity)

            -- Convertir la position prédite en coordonnées écran et calculer le déplacement de la souris
            local screenPosition = camera:WorldToViewportPoint(predictedPosition)
            local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            local deltaX = (screenPosition.X - screenCenter.X) / aimSpeed
            local deltaY = (screenPosition.Y - screenCenter.Y) / aimSpeed

            -- Déplacement de la souris vers la cible
            mousemoverel(deltaX, deltaY)
        end
    end
end

-- Connexion à l'événement RunService pour exécuter la fonction d'aimbot
runService.RenderStepped:Connect(aim_at_target)

