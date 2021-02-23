--[[Perhaps implement a slight delay between movement and coming into contact with an enemy or end collision.



implement ghost program

0) randomize a dice roll to see if a ghost can be spawned. Increase in speed of spawning at higher difficulty
1) check for number of ghosts on screen by consulting the # of indexes in the ghosts table
2) check for number of allowed ghosts for current diffuculty
3) spawn ghost if number of allowed ghosts is not maximum 

Currently, if there are multiple ghosts on screen, the ticker between movements is twice as fast.

also, double check that current ghost deletion does not cause a memory problem. We want the tables to be kept small and indexed items
to be deleted completely. Consider the i = #bullets, 1, -1 do example from zamboes






        if key == 'a' then
            for i,g in ipairs(ghosts) do
                local gx, gy = g:getPosition()

                if ghostFacingRight == true then
                        g:setX(gx + 100)
                else
                        g:setX(gx - 100)
                end
            end
        end
        if key == 'd' then
            for i,g in ipairs(ghosts) do
                local gx, gy = g:getPosition()

                if ghostFacingRight == true then
                        g:setX(gx - 100)
                else
                        g:setX(gx + 100)
                end
                
            end
        end
        if key == 'w' then
            for i,g in ipairs(ghosts) do
                local gx, gy = g:getPosition()

                if ghostFacingRight == true then
                        g:setY(gy + 100)
                else
                        g:setY(gy - 100)
                end
            end
        end
        if key == 's' then
            for i,g in ipairs(ghosts) do
                local gx, gy = g:getPosition()

                if ghostFacingRight == true then
                        g:setY(gy - 100)
                else
                        g:setY(gy + 100)
                end
            end
        end


]]