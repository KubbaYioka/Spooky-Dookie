function love.load()

    --orig set was 870 588
    love.window.setMode(720,420)

    anim8 = require 'libraries/anim8/anim8'
    wf = require 'libraries/windfield/windfield'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'

--SPRITES & --
--ANIMATIONS--
    sprites = {}
    animations = {}

    sprites.playerGraphic = love.graphics.newImage('graphics/player.png')
    sprites.ghostGraphic = love.graphics.newImage('graphics/ghost.png')

    local ghostGrid = anim8.newGrid(20, 20, sprites.ghostGraphic:getWidth(), sprites.ghostGraphic:getHeight())

    animations.ghostLeft = anim8.newAnimation(ghostGrid('2-2', 1), 1)
    animations.ghostRight = anim8.newAnimation(ghostGrid('1-1', 1), 1)

    --debug text color
    love.graphics.setColor(0,0,0,255)

--- SOUND ---
sounds = {}
sounds.playerVert = love.audio.newSource("sound/stepV.wav", "static")
sounds.playerHori = love.audio.newSource("sound/stepH.wav", "static")

---WORLD CREATION AND ---
---COLLISION CLASSES  ---

    --create world with no gravity
    world = wf.newWorld(0, 0, false)

    --collision detection on
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('Wall')
    world:addCollisionClass('Bad', {ignores = {'Wall'}, ignores = {'Bad'}})
    world:addCollisionClass('Player', {ignores = {'Bad'}})
    world:addCollisionClass('ScreenEdge')

    --REQUIRED LUA FILES--
    require('player')
    require('ghosts')
    require('watch')
    require('control')

--INIT TABLES--
keys = {}
walls = {}


--INIT GLOBAL PARAMETERS--

    --difficulty. Starts at 1, does not exceed 4
    difficulty = 1

    --ghost spawn counter. Starts at a ghost spawning from 8-12 seconds. interval decreases with difficulty
    counterEasy = love.math.random(8, 12)
    counterMedium = love.math.random(7, 10)
    counterHard = love.math.random(6, 9)
    counterMax = love.math.random(4, 8)

    --sets the poop timer. When it runs out, the player craps their pants
    poopTimer = 0

    --keeps track of the number of keys on screen
    keyNumber = 0

    --keeps track of master timer. If playtime = 1 hour, then a secret message appears.
    masterTimer = 0

    --Difficulty. Can be 1 (easiest) - 4 (hardest).
    difficultySet = 1

    --loadRoom. Always starts at 1

    loadRoom("room1")

    --background color
    red = 163/255
    green = 205/225
    blue =  163/225


    --debug--
    gDebugPosX = 0
    gDebugPosY = 0
end

function love.update(dt)

    gameMap:update(dt)
    world:update(dt)
    playerUpdate(dt)
    ghostUpdate(dt)
    ghostTimer(dt)

    --include collider for toilet and end of room transition marker here. Perhaps research iterator for this.

end

function love.draw()

    love.graphics.setBackgroundColor(red, green, blue)
    world:draw()
    gameMap:drawLayer (gameMap.layers["Tile Layer 1"])
    love.graphics.print("Xpos: " .. player.posX, 20, 20)
    love.graphics.print("Ypos: " .. player.posY, 20, 30)
    love.graphics.print("gPosX: " .. gDebugPosX, 20, 40)
    love.graphics.print("# of ghosts: " .. #ghosts, 20, 80)
    drawPlayer()
    drawGhost()


end

--player movement
function love.keypressed(key)
    if player.body then
        local px, py = player:getPosition()

        if key == 'right' then
            if player.rightBlocked == true then
                player:setX(px - 0)
            else
                player:setX(px + player.moveSpace)
                love.audio.play(sounds.playerHori)
            end
        end

        if key == 'left' then
            if player.leftBlocked == true then
                player:setX(px + 0)
            else
                player:setX(px - player.moveSpace)
                love.audio.play(sounds.playerHori)
            end
        end

        if key == 'up' then
            if player.upBlocked == true then
                player:setY(py + 0)
            else
                player:setY(py - player.moveSpace)
                love.audio.play(sounds.playerHori)
            end
        end
        
        if key == 'down' then
            if player.downBlocked == true then
                player:setY(py - 0)
            else
                player:setY(py + player.moveSpace)
                love.audio.play(sounds.playerHori)
            end
        end

        if key == 'r' then
            ghostParam()
        end
    end
end


function createWalls(x, y, width, height)
    --local wall param gets wall info from the level data
    local wall = world:newRectangleCollider(x, y, width, height, {collision_class = "Wall"})
    wall:setType('static')
    table.insert(walls, wall)
end

function deleteLevel()
end


function loadRoom(levelNumber)

    --deleteLevel()

    gameMap = sti("rooms/" .. levelNumber .. ".lua")

    for i, obj in pairs(gameMap.layers["Walls"].objects) do 
        createWalls(obj.x, obj.y, obj.width, obj.height)
    end


end