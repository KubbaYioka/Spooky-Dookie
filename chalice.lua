chalices = {}
bulletsR = {}
bulletsL = {}


chaliceSpawnX = 0
chaliceSpawnY = 0


--for timing between ghost steps
chaliceTicker = 0

--for counting down when it is time for a ghost spawn
chaliceSpawnTimer = 0

--number assigned by randomizing the spawn frequency for level of difficulty (eg. 10-12 for Easy)
chaliceSpawnerNumber = 720

--initial state for chalice Timer. Changes to 1 when loop runs once
chaliceTimerState = 0

--two values provided by difficulty type passed to chaliceSpawnerNumber. Selects a number between the two at random.
lowerChaliceSec = 880
upperChaliceSec = 920

function chaliceTimer(dt)
    if gameMode == 1 then
        if #chalices <=0 then
            if chaliceTimerState == 1 then
                if chaliceSpawnTimer >= 0 then
                    chaliceSpawnTimer = chaliceSpawnTimer - 1
                else
                    if #chalices < 1 then
                        chaliceParam()
                        chaliceTimerState = 0
                    else
                        chaliceSpawnTimer = chaliceSpawnerNumber
                        chaliceTimerState = 0
                    end
                end
            else 
                upperChaliceSec = upperChaliceSec / difficulty
                lowerChaliceSec = lowerChaliceSec / difficulty
                chaliceSpawnerNumber = math.random(lowerChaliceSec, upperChaliceSec)
                chaliceSpawnTimer = chaliceSpawnerNumber
                chaliceTimerState = 1
            end
        end
    end
end

function chaliceSpawn(x, y)
    local chalice = world:newRectangleCollider(x, y, 20, 20, {collision_class ="Keys"})


    chalice.time = 5 * 60 -- 5 secs. 5 can be replaced with a variable based on difficulty
    chalice.got = false
    chalice.onscreen = true
    chalice.animation = animations.chalice
    table.insert(chalices, chalice)
    love.audio.play(sounds.chaliceSpawn)
end

function chaliceParam()
    local rndX
    local rndY
    local xTable = {50, 150, 250, 350, 450, 550, 650}
    local yTable = {80, 180, 280, 380, 480}

    rndX = xTable[math.random(1, #xTable)]
    rndY = yTable[math.random(1, #yTable)]

    chaliceSpawnX = rndX
    chaliceSpawnY = rndY

    chaliceSpawn(chaliceSpawnX, chaliceSpawnY)
end

function chaliceUpdate(dt)
    if gameMode == 1 then
        for i, c in ipairs(chalices) do
            if c.body then
                if c.time > 0 then
                    c.animation:update(dt) 
                    c.time = c.time - 1
                    local cx, cy = c:getPosition()  
                    local colliders = world:queryRectangleArea(cx-10, cy-50, 20, 50, {'Player'})
                    if #colliders > 0 then
                        love.audio.play(sounds.chaliceGet)
                        bulletSpawn(cx, cy)
                        c.body:destroy()
                        table.remove(chalices, i)
                    end
                else
                    c.body:destroy()
                    table.remove(chalices, i)
                end
            end
        end
    end
end

function drawChalice(dt)
    if #chalices >= 1 then
        for i,c in ipairs(chalices) do
            if c.body then
                local cx, cy = c:getPosition()
                c.animation:draw(sprites.chaliceGraphic, cx, cy-5, nil, nil, nil, sprites.chaliceGraphic:getWidth() / 4, sprites.chaliceGraphic:getHeight() / 4)
                --location debug
                cDebugPosX = cx
                cDebugPosY = cy
            end
        end
    end
end

function bulletSpawn(x, y)
    local bulletR = world:newRectangleCollider(x-40, y-20, 55, 10, {collision_class ="Bullets"})
    bulletR.hit = 0
    bulletR.ticker = 30 -- ticker same as ghost ticker. Movement only after it reaches zero 
    bulletR.gone = false
    bulletR.strike = false
    table.insert(bulletsR, bulletR)
    local bulletL = world:newRectangleCollider(x-40, y-20, 55, 10, {collision_class ="Bullets"})
    bulletL.hit = 0
    bulletL.ticker = 30 -- ticker same as ghost ticker. Movement only after it reaches zero 
    bulletL.gone = false
    bulletL.strike = false
    table.insert(bulletsL, bulletL)
end

function bulletUpdate(dt)
    for i, r in ipairs(bulletsR) do
        local rx, ry = r:getPosition()
        local colliders = world:queryRectangleArea(rx-15, ry-5, 55, 10, {'Bad'})
        if #colliders > 0 then
            hitFlag = true
            r.strike = true
            pauseTrigger()
        end
        if r.gone then
            r.body:destroy()
            table.remove(bulletsR, i)
        else
            if r.ticker > 0 then
                r.ticker = r.ticker - 1
            else
                r:setX(rx + 100)
                r.ticker = 30
            end
        end
        if rx > 680 then
            r.gone = true
        end
    end

    for i, l in ipairs(bulletsL) do
        local lx, ly = l:getPosition()
        local colliders = world:queryRectangleArea(lx-15, ly-5, 55, 10, {'Bad'})
        if #colliders > 0 then
            hitFlag = true
            l.strike = true
            pauseTrigger()
        end
        if l.gone then
            l.body:destroy()
            table.remove(bulletsL, i)
        else
            if l.ticker > 0 then
                l.ticker = l.ticker - 1
            else
                l:setX(lx - 100)
                l.ticker = 30
            end
        end
        if lx < 40 then
            l.gone = true
        end
    end
end

function bulletDraw()
    for i, r in ipairs(bulletsR) do
        local rx, ry = r:getPosition()
        love.graphics.draw(sprites.bullet, rx+5, ry-5)
    end
    for i, l in ipairs(bulletsL) do
        local lx, ly = l:getPosition()
        love.graphics.draw(sprites.bullet, lx+5, ly-5)
        --love.graphics.draw()
    end
end