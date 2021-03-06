function love.load()

    --orig set was 870 588
    love.window.setMode(720,460)

    anim8 = require 'libraries/anim8/anim8'
    wf = require 'libraries/windfield/windfield'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'

--SPRITES & --
--ANIMATIONS--
    sprites = {}
    animations = {}

    sprites.playerGraphic = love.graphics.newImage('graphics/player.png')
    sprites.ghostGraphic = love.graphics.newImage('graphics/ghost.png')
    sprites.keyGraphic = love.graphics.newImage('graphics/key.png')
    sprites.doorGraphic = love.graphics.newImage('graphics/door.png')
    sprites.chaliceGraphic = love.graphics.newImage('graphics/chalice.png')
    sprites.bullet = love.graphics.newImage('graphics/chaliceBullet.png')

    local ghostGrid = anim8.newGrid(20, 20, sprites.ghostGraphic:getWidth(), sprites.ghostGraphic:getHeight())

    animations.ghostRight = anim8.newAnimation(ghostGrid('1-1', 1), 1)
    animations.ghostLeft = anim8.newAnimation(ghostGrid('1-1', 2), 1)

    animations.ghostRightFlash = anim8.newAnimation(ghostGrid('1-2', 1), 1)
    animations.ghostLeftFlash = anim8.newAnimation(ghostGrid('1-2', 2), 1)

    local keyGrid = anim8.newGrid(20, 20, sprites.keyGraphic:getWidth(), sprites.keyGraphic:getHeight())
    animations.key = anim8.newAnimation(keyGrid('1-1', 1), 1)

    local chaliceGrid = anim8.newGrid(20, 20, sprites.chaliceGraphic:getWidth(), sprites.keyGraphic:getHeight())
    animations.chalice = anim8.newAnimation(chaliceGrid('1-2', 1), 1)

    --debug text color
    love.graphics.setColor(0,0,0,255)

--- SOUND ---
sounds = {}
sounds.playerVert = love.audio.newSource("sound/stepV.wav", "static")
sounds.playerHori = love.audio.newSource("sound/stepH.wav", "static")
sounds.ghostAppear = love.audio.newSource("sound/ghostAppear.wav", "static")
sounds.ghostMove = love.audio.newSource("sound/ghostMove.wav", "static")
sounds.key = love.audio.newSource("sound/key.wav", "static")
sounds.doorOpen = love.audio.newSource("sound/doorOpen.wav", "static")
sounds.point = love.audio.newSource("sound/point.wav", "static")
sounds.chaliceSpawn = love.audio.newSource("sound/chaliceAppear.wav", "static")
sounds.chaliceGet = love.audio.newSource("sound/chaliceGet.wav", "static")
sounds.chaliceHit = love.audio.newSource("sound/chaliceHit.wav", "static")
sounds.miss = love.audio.newSource("sound/miss.wav", "static")

---WORLD CREATION AND ---
---COLLISION CLASSES  ---

    --create world with no gravity
    world = wf.newWorld(0, 0, false)

    --collision detection on
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('Wall')
    world:addCollisionClass('Bad', {ignores = {'Wall', 'Bad'}})
    world:addCollisionClass('Toilets', {ignores = {'Bad'}})
    world:addCollisionClass('Player', {ignores = {'Bad', 'Toilets', 'Wall'}})
    world:addCollisionClass('Doors', {ignores = {'Bad', 'Toilets', 'Player', 'Wall'}})
    world:addCollisionClass('Keys', {ignores = {'Bad', 'Toilets', 'Player', 'Doors', 'Wall', 'Keys'}})
    world:addCollisionClass('Bullets', {ignores = {'Bad', 'Toilets', 'Player', 'Doors', 'Wall', 'Keys', 'Bullets'}})

    --REQUIRED LUA FILES--
    require('player')
    require('ghosts')
    require('watch')
    require('levelControl')
    require('pause')
    require('chalice')
    humpTimer = require "humpTimer"

--INIT TABLES--
keys = {}
walls = {}
toilets = {}
hDoors = {}
vDoors = {}


--INIT GLOBAL PARAMETERS--

    --gameMode starts at 0. Changes to 1 if the player presses start. Changes to 2 under certain circumstances
    gameMode = 0

    --concatinated for room files and increments
    roomNumber = 1

    --loadRoom. Always starts at 1

    loadRoom(roomNumber)

    --background color
    red = 163/255
    green = 205/225
    blue =  163/225

end

function love.update(dt)

    gameTimer(dt)
    humpTimer.update(dt)
    poopTimerUpdate(dt)

    gameMap:update(dt)
    world:update(dt)
    toiletUpdate(dt)
    playerUpdate(dt)
    keyUpdate(dt)
    chaliceTimer(dt)
    chaliceUpdate(dt)
    bulletUpdate(dt)
    ghostTimer(dt)
    ghostUpdate(dt)
    hDoorUpdate(dt)
    vDoorUpdate(dt)

end

function love.draw()
    love.graphics.setBackgroundColor(red, green, blue)
    world:draw()
    gameMap:drawLayer (gameMap.layers["Tile Layer 1"])
    gameMap:drawLayer (gameMap.layers["Tile Layer 2"])
    love.graphics.print("Time: " .. math.floor(displayPoopTimer+0.3), 20, 0)
    love.graphics.print("Score: " .. player.score, 20, 10) 
    love.graphics.print("R " ..#bulletsR , 100, 10) 
    love.graphics.print("L " ..#bulletsL , 100, 20) 
    drawPlayer()
    drawGhost()
    drawChalice()
    bulletDraw()
    keyDraw()
    drawDoors()
end

--player movement
function love.keypressed(key)
    --
    if key == '2' then
        ghostSpawn(15, 70)
    end
    if key == '3' then  
        ghostSpawn(675, 70)
    end 
    if key == '1' then
        chaliceSpawn(350, 80)
    end
    --
    if gameMode == 1 then
        if player.body then
            local px, py = player:getPosition()

            if key == 'right' then
                if player.rightBlocked or player.rightBlockedDoor == true then
                    player:setX(px - 0)
                else
                    player:setX(px + player.moveSpace)
                    if toiletFlag == false then
                        love.audio.play(sounds.playerHori)
                    end
                end
            end

            if key == 'left' then
                if player.leftBlocked or player.leftBlockedDoor == true then
                    player:setX(px + 0)
                else
                    player:setX(px - player.moveSpace)
                    if toiletFlag == false then
                        love.audio.play(sounds.playerHori)
                    end
                end
            end

            if key == 'up' then
                if player.upBlocked or player.upBlockedDoor == true then
                    player:setY(py + 0)
                else
                    player:setY(py - player.moveSpace)
                    if toiletFlag == false then
                        love.audio.play(sounds.playerHori)
                    end
                end
            end
            
            if key == 'down' then
                if player.downBlocked or player.downBlockedDoor == true then
                    player:setY(py - 0)
                else
                    player:setY(py + player.moveSpace)
                    if toiletFlag == false then
                        love.audio.play(sounds.playerHori)
                    end
                end
            end

            if key == 'r' then
                chaliceParam()
            end
        end 
    end
    if key == 's' then
        gameMode = 1
        loadRoom(1)
    end
end