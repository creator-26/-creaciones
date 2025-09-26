local espadaID = 47433

print("🔍 Probando ID de espada: " .. espadaID)

-- Intentar cargar la espada de forma segura
local success, herramienta = pcall(function()
    local objetos = game:GetObjects('rbxassetid://' .. espadaID)
    return objetos[1]
end)

if success and herramienta then
    print("✅ ¡FUNCIONA! Espada encontrada:")
    print("Nombre: " .. herramienta.Name)
    print("Tipo: " .. herramienta.ClassName)
    
    -- Añadir a la mochila
    herramienta.Parent = game.Players.LocalPlayer.Backpack
    print("🎯 Espada añadida a tu mochila!")
    
    -- Verificar si es una herramienta
    if herramienta:IsA("Tool") then
        print("⚔️ Es una herramienta equipable")
    else
        print("❌ No es una herramienta, es: " .. herramienta.ClassName)
    end
    
else
    print("❌ NO FUNCIONA - Error:")
    print(herramienta)  -- Mostrar el error
    print("💡 Sugerencia: El ID probablemente no existe")
end