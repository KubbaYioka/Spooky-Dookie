ghosts = {}

ghostSpawnX = 0
ghostSpawnY = 0

--number of allowed ghosts is equivalent to the difficulty.
ghostNumber = difficulty

--ghostgo is 0 until the spawn animation goes for a second or 2.

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
    if gameMode == 1 then
        if timerState == 1 then
            if ghostSpawnTimer > 0 then
                ghostSpawnTimer = ghostSpawnTimer - 1
            else
                if #ghosts < difficulty then
                    ghostParam()
                    timerState = 0
                else
                    ghostSpawnTimer = spawnTimerNumber
                    timerState = 0
                end
            end
        else 
            upperSec = upperSec / difficulty
            lowerSec = lowerSec / difficulty
            spawnTimerNumber = math.random(lowerSec, upperSec)
            ghostSpawnTimer = spawnTimerNumber
            timerState = 1
        end
    end
end


function ghostSpawn(x, y)
    if gameMode == 1 then
        local ghost = world:newRectangleCollider(x, y, 20, 20, {collision_class ="Bad"})
        local gx = x
        local gy = y
        ghost.speed = 100 --number of pixels the ghost moves
        -- if statement sets ghostFacingRight boolean by its x spawn location. Determines what animation will be used.
        ghost.ticker = tickerLevel
        if gx == 15 then
            ghost.ghostFacingRight = true
            ghost.animation = animations.ghostLeftFlash
        else
            ghost.ghostFacingRight = false
            ghost.animation = animations.ghostRightFlash
        end
        ghost.ghostGo = 0
        ghost.ghostTimer = 0
        ghost.hit = false
        table.insert(ghosts, ghost)
        love.audio.play(sounds.ghostAppear)
    end
end

function ghostParam()

    local rndX
    local rndY
    local xTable = {15, 675}
    local yTable = {70, 170, 270, 370}

    rndX = xTable[math.random(1, #xTable)]
    rndY = yTable[math.random(1, #yTable)]

    ghostSpawnX = rndX
    ghostSpawnY = rndY

    ghostSpawn(ghostSpawnX, ghostSpawnY)
end

function ghostUpdate(dt)
    if gameMode == 1 then
        for i,g in ipairs(ghosts) do
            g.animation:update(dt)
            if g.body then
                if g.ghostGo >= 1 then
                    local gx, gy = g:getPosition()
                    if g.ghostFacingRight then
                        -- note: ghostLeft is showing the ghost facing RIGHT because it originates on the left side, and travels right
                        g.animation = animations.ghostLeft
                    else
                        g.animation = animations.ghostRight
                    end
                    local colliders = world:queryRectangleArea(gx-10, gy-10, 20, 20, {'Player'})
                    if #colliders >0 then
                        --implement delay 
                        love.audio.play(sounds.playerHori)
                        poopTimer = poopTimer - 5
                    end
                    local bColliders = world:queryRectangleArea(gx-10, gy-10, 20, 20, {'Bullets'})
                    if #bColliders >0 then
                        g.hit = true
                    end

                    if g.ticker > 0 then
                        g.ticker = g.ticker - 1
                    else
                        g:setX(gx + (g.ghostFacingRight and 100 or -100))
                        love.audio.play(sounds.ghostMove)
                        g.ticker = tickerLevel
                    end
                    if g.ghostFacingRight then

                        if gx >= 735 then
                            g.body:destroy()
                            table.remove(ghosts, i)
                        end
                    else
                        if gx <= -15 then
                            g.body:destroy()
                            table.remove(ghosts, i)
                        end
                    end
                else
                    if g.ghostTimer <= goTimer then
                        g.ghostTimer = g.ghostTimer + 1
                    else
                        g.ghostGo = 1
                    end
                end
            end
        end
    end
end

function drawGhost()
    if #ghosts >= 1 then
        for i,g in ipairs(ghosts) do
            --if g.body then
                local gx, gy = g:getPosition()
                g.animation:draw(sprites.ghostGraphic, gx+5, gy-10, nil, nil, nil, sprites.ghostGraphic:getWidth() / 4, sprites.ghostGraphic:getHeight() / 4)
                --location debug
                gDebugPosX = gx
                gDebugPosY = gy
            --end
        end
    end
end