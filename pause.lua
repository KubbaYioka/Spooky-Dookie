--loops for scoreAdd
loops = 0
--sets gameMode to 2 from 1 and triggers pause(), otherwise, changes gamemode to 1
function pauseTrigger()
    if gameMode == 1 then
        gameMode = 2
        pause()
    else
        gameMode = 1
    end
end

--iterated for the number of points to be added
function scoreAdd()
    player.score = player.score + 1
    love.audio.play(sounds.point)
    loops = loops + 1        
end

--score iterator adds points to the score one by one with a delay so the player can see the numbers go up. 
function scoreIterator(points)
    humpTimer.every(0.05, scoreAdd, points)
end

function pause()
    if gameMode == 2 then
        if missFlag then
            love.audio.play(sounds.miss)
           -- timer(3)
            --play poop animation

            player.miss = player.miss + 1
            if player.miss >=3 then
                missFlag = false
                gameOver()
            else
                missFlag = false
                loadRoom(roomNumber)
                --reset room to initial state and clear all enemies and player.hasKey = false
            end
        end

        if hitFlag then
            hitFlag = false
            --iterate through each bullet to see which one has struck an enemy. add to c.hit to iterate its combo
            for i, g in ipairs(ghosts) do
                if g.hit then
                    for i, r in ipairs(bulletsR) do
                        if r.strike then
                            r.strike = false
                            r.hit = r.hit + 1
                            scoreIterator(20 * r.hit)
                        end
                    end
                    for i, l in ipairs(bulletsL) do
                        if l.strike then
                            l.strike = false
                            l.hit = l.hit + 1
                            local combo = l.hit
                            scoreIterator(20 * combo)
                        end
                    g.body:destroy()
                    table.remove(ghosts, i)
                    end
                end
            end
        end
        if toiletFlag then
            toiletFlag = false
            scoreIterator(displayPoopTimer)
            local nextLevel = roomNumber + 1
            loadRoom(nextLevel)
            pauseTrigger() 
        end

        if newRoomFlag then
            local wait = false
            while wait == false do
                --flashing player animation
                if love.keyboard.isDown() then
                    wait = true
                    newRoomFlag = false
                end
            end
        end
    end
    pauseTrigger()
end
