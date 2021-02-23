ghosts = {}

ghostSpawnX = 0
ghostSpawnY = 0

--ghostgo is 0 until the spawn animation goes for a second or 2. decreases with difficulty

-- tickerLevel is a set value for ghost movement which is determined by difficulty
tickerLevel = 40
--for timing between ghost steps
ghostTicker = 0

--for counting down when it is time for a ghost spawn
ghostSpawnTimer = 0

--number assigned by randomizing the spawn frequency for level of difficulty (eg. 10-12 for Easy)
spawnTimerNumber = 720

--initial state for ghostTimer. Changes to 1 when loop runs once
timerState = 0


--two values provided by difficulty type passed to spawnTimerNumber. Selects a number between the two at random.
lowerSec = 480
upperSec = 720



function ghostTimer(dt)
    if timerState == 1 then
        if ghostSpawnTimer ~= 0 then
            ghostSpawnTimer = ghostSpawnTimer - 1
        else
            ghostParam()
            spawnTimerNumber = math.random(lowerSec, upperSec)
            ghostSpawnTimer = spawnTimerNumber
        end
    else 
        timerState = 1
        upperSec = upperSec / difficultySet
        lowerSec = lowerSec / difficultySet
        spawnTimerNumber = math.random(lowerSec, upperSec)
        ghostSpawnerTimer = spawnTimerNumber
    end
end

--[[ Code moved to ghostUpdate()
function ghostMoveCounter(dt)
    --for i,g in ipairs(ghosts) do
        if g.ticker > 0 then
            g.ticker = g.ticker - 1
        else
            local gx, gy = g:getPosition()
            g:setX(gx + dt * (g.ghostFacingRight and 100 or -100))
            g.ticker = tickerLevel
        end
    --end
end
--[[
function ghostMoveCounter()
    for i,g in ipairs(ghosts) do
        local gx, gy = g:getPosition()
        if g.ticker ~= 0 then
            g.ticker = g.ticker - 1
        else
            if g.ghostFacingRight then
                g:setX(gx + 100)
                g.ticker = tickerLevel
            else
                g:setX(gx - 100)
                g.ticker = tickerLevel
            end
        end
    end
end
]]

function ghostSpawn(x, y)
local ghost = world:newRectangleCollider(x, y, 20, 20, {collision_class ="Bad"})
    ghost.direction = 1 --[[1 can be replaced with a var for determined by what side they spawn on]]
    ghost.speed = 100 --number of pixels the ghost moves
    -- if statement sets ghostFacingRight boolean by its x spawn location. Determines what animation will be used.
    ghost.ticker = tickerLevel
    if ghostSpawnX == 25 then
        ghost.ghostFacingRight = true
    else
        ghost.ghostFacingRight = false
    end
    ghost.ghostGo = 0
    ghost.goTimer = 0
    table.insert(ghosts, ghost)
end

function ghostParam()

    local rndX
    local rndY
    local xTable = {25, 675}
    local yTable = {25, 125, 225, 325}

    rndX = xTable[math.random(1, #xTable)]
    rndY = yTable[math.random(1, #yTable)]

    ghostSpawnX = rndX
    ghostSpawnY = rndY

    ghostSpawn(ghostSpawnX, ghostSpawnY)
end

function ghostUpdate(dt)
    for i,g in ipairs(ghosts) do
        local gx, gy = g:getPosition()

        local colliders = world:queryRectangleArea(gx, gy-10, 20, 5, {'Player'})
        if #colliders >0 then
            love.audio.play(sounds.playerHori)
        end

        if g.ticker > 0 then
            g.ticker = g.ticker - 1
        else
            local gx, gy = g:getPosition()
            g:setX(gx + dt * (g.ghostFacingRight and 100 or -100))
            g.ticker = tickerLevel
        end

        if g.ghostFacingRight == true then

            if gx == 735 then
                g.body:destroy()
                table.remove(ghosts, i)
            end
        else

            if gx == -15 then
                g.body:destroy()
                table.remove(ghosts, i)
            end
        end
    end
end

function drawGhost()
    for i,g in pairs(ghosts) do
        local gx, gy = g:getPosition()
        if g.ghostFacingRight == true then
            -- note: ghostLeft is showing the ghost facing RIGHT because it originates on the left side, and travels right
            g.animation = animations.ghostLeft
        else
            g.animation = animations.ghostRight
        end
        g.animation:draw(sprites.ghostGraphic, gx, gy, 0, 1.2, 1.2, sprites.ghostGraphic:getWidth() / 4, sprites.ghostGraphic:getHeight() / 2)
        --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, ks, ky)
        --location debug
        gDebugPosX = gx
        gDebugPosY = gy
    end
end