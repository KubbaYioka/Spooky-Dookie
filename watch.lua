--Details the Watch and Difficulty functions--

--sets the poop timer. When it runs out, the player craps their pants. Begins at 30 seconds.
basePoopTimer = 1800
--current timer. 
poopTimer = 0
--timer display
displayPoopTimer = 0

--goTimer is the time it takes between when an enemy appears, flashes, and becomes a collider that can 
--harm the player. Changes with difficulty
goTimer = 240

--begins at gamestart
masterTimer = 0

-- frames within 1 second for game timer
frameMaster = 0

--total number of frames elapsed
frameKeeper = 0

--difficulty. Starts at 1, does not exceed 20
difficulty = 1

--Flags--
--these are flags for each condition that can cause the game to pause
missFlag = false
toiletFlag = false
hitFlag = false
newRoomFlag = false

--ghost spawn counter. Starts at a ghost spawning from 8-12 seconds. interval decreases with difficulty
counterEasy = love.math.random(8, 12)
counterMedium = love.math.random(7, 10)
counterHard = love.math.random(6, 9)
counterMax = love.math.random(3, 6)

function gameWatch()
    if gameMode == 0 then
    end
end

--set game timer on new game start
function gameTimer(dt)
    if gameMode == 1 or gameMode == 2 then
        frameMaster = frameMaster + 1
        if frameMaster >= 60 then
            masterTimer = masterTimer + 1
            frameMaster = 0
        end
        frameKeeper = masterTimer / 60
    else
        masterTimer = 0
        frameMaster = 0
    end
end

--to be run at the beginning of each map
function setPoopTimer()
        poopTimer = basePoopTimer / difficulty
end

function poopTimerUpdate(dt)
    if gameMode == 1 then
        if poopTimer >= 0 then
            poopTimer = poopTimer - 1
            displayPoopTimer = poopTimer / 60
        else
            missFlag = true
        end
    end
end

function gameOver()

end