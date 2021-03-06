
function createWalls(x, y, width, height)
    --local wall param gets wall info from the level data
    local wall = world:newRectangleCollider(x, y, width, height, {collision_class = "Wall"})
    wall:setType('static')
    table.insert(walls, wall)
end

function createToilets(x, y, width, height)
    local toilet = world:newRectangleCollider(x, y, width, height, {collision_class = "Toilets"})
    toilet:setType('static')
    table.insert(toilets, toilet)
end

function createHDoor(x, y, width, height)
    local door = world:newRectangleCollider(x, y, width, height, {collision_class = "Doors"})
    door:setType('static')
    door.locked = true
    table.insert(hDoors, door)
end

function createVDoor(x, y, width, height)
    local door = world:newRectangleCollider(x, y, width, height, {collision_class = "Doors"})
    door:setType('static')
    door.locked = true
    table.insert(vDoors, door)
end

function createKeys(x, y, width, height)
    local key = world:newRectangleCollider(x, y, width + 20, height, {collision_class = "Keys"})
    key:setType('static')
    key.collected = false
    key.animation = animations.key
    table.insert(keys, key)
end

function toiletUpdate(dt)
    if gameMode == 1 then
        local toiletCollider = world:queryRectangleArea(player:getX() + 30, player:getY() + 30, 10, 10, {'Toilets'})
        if #toiletCollider > 0  then
            toiletFlag = true
            pauseTrigger()
        end
    end
end

function keyDraw()
    for i,k in ipairs(keys) do
        local kx, ky = k:getPosition()
        k.animation:draw(sprites.keyGraphic, kx+5, ky+10, nil, nil, nil, sprites.keyGraphic:getWidth(), sprites.keyGraphic:getHeight())
    end 
end

function hDoorUpdate(dt)
    if gameMode == 1 then
        for i,d in ipairs(hDoors) do
            local doorHCollider = world:queryRectangleArea(d:getX()-10, d:getY()-10, 20, 20, {'Player'})
            if #doorHCollider > 0  then
                if player.hasKey then
                    player.hasKey = false
                    d.locked = false
                    love.audio.play(sounds.doorOpen)
                end
            end
        end

        for i=#hDoors,1,-1 do
            local d = hDoors[i]
            if d.locked == false then
                hDoors[i]:destroy()
                table.remove(hDoors,i)
            end
        end
    end
end

function vDoorUpdate(dt)
    if gameMode == 1 then
        for i,d in ipairs(vDoors) do
            local doorVCollider = world:queryRectangleArea(d:getX()-10, d:getY()-10, 20, 20, {'Player'})
            if #doorVCollider > 0  then
                if player.hasKey then
                    player.hasKey = false
                    d.locked = false
                    love.audio.play(sounds.doorOpen)
                end
            end
        end

        for i=#vDoors,1,-1 do
            local d = vDoors[i]
            if d.locked == false then
                vDoors[i]:destroy()
                table.remove(vDoors,i)
            end
        end
    end
end

function drawDoors()
    for i, d in ipairs(vDoors) do
        local dx, dy = d:getPosition()
        love.graphics.draw(sprites.doorGraphic, dx+5, dy-20, 1.5708, nil, nil)
        --love.graphics.draw()
    end
    for i, d in ipairs(hDoors) do
        local dx, dy = d:getPosition()
        love.graphics.draw(sprites.doorGraphic, dx-20, dy)
    end
end

function keyUpdate(dt)
    if gameMode == 1 then
        if #keys > 0 then
            for i,k in ipairs(keys) do
                k.animation:update(dt)
                local keyCollider = world:queryRectangleArea(k:getX() + 5, k:getY(), 10, 10, {'Player'})
                if #keyCollider > 0  then
                    if player.hasKey == false then
                        player.hasKey = true
                        k.collected = true
                        love.audio.play(sounds.key)
                    end
                end
            end
            for i=#keys,1,-1 do
                local k = keys[i]
                if k.collected then
                    keys[i]:destroy()
                    table.remove(keys,i)
                end
            end
            --debug
            if player.hasKey then
                debugKey = 1
            else
                debugKey = 0
            end
        end
    end
end

function clearRoom()

    local i = #walls
    while i > -1 do
        if walls[i] ~= nil then
            walls[i]:destroy()
        end
        table.remove(walls, i)
        i = i -1
    end
    local i = #keys
    while i > -1 do
        if keys[i] ~= nil then
            keys[i]:destroy()
        end
        table.remove(keys, i)
        i = i -1
    end
    local i = #toilets
    while i > -1 do
        if toilets[i] ~= nil then
            toilets[i]:destroy()
        end
        table.remove(toilets, i)
        i = i -1
    end
    local d = #hDoors
    while d > -1 do
        if hDoors[d] ~= nil then
            hDoors[d]:destroy()
        end
        table.remove(hDoors, d)
        d = d -1
    end
    local d = #vDoors
    while d > -1 do
        if vDoors[d] ~= nil then
            vDoors[d]:destroy()
        end
        table.remove(vDoors, d)
        d = d -1
    end
    local i = #ghosts
    while i > -1 do
        if ghosts[i] ~= nil then
            ghosts[i]:destroy()
        end
        table.remove(ghosts, i)
        i = i -1
    end
    player.hasKey = false
end

function miss()
    player.misses = player.misses + 1
    --gameMode = 2
    if player.misses <=2 then
        loadroom(roomNumber)
    else
    end
end
 
function loadRoom(roomNumber)
    clearRoom()
    gameMap = sti("rooms/room" .. roomNumber .. ".lua")
    for i, obj in pairs(gameMap.layers["Walls"].objects) do 
        createWalls(obj.x, obj.y, obj.width, obj.height)
    end
    for i, obj in pairs(gameMap.layers["Toilets"].objects) do 
        createToilets(obj.x, obj.y, obj.width, obj.height)
    end
    if gameMap.layers["HoriDoors"] then
        for i, obj in pairs(gameMap.layers["HoriDoors"].objects) do 
            createHDoor(obj.x, obj.y, obj.width, obj.height)
        end
    end
    if gameMap.layers["VertDoors"] then
        for i, obj in pairs(gameMap.layers["VertDoors"].objects) do 
            createVDoor(obj.x, obj.y, obj.width, obj.height)
        end
    end
    for i, obj in pairs(gameMap.layers["Start"].objects) do
        player:setPosition(obj.x + 40, obj.y + 40)
    end 

    if gameMap.layers["Keys"] then
        for i, obj in pairs(gameMap.layers["Keys"].objects) do 
            createKeys(obj.x, obj.y, obj.width, obj.height)
        end
    end
    setPoopTimer()

end