--walls, doors

function wallUpdate(dt)

end


--[[
    -- vertical wall position extremes (upper left to lower right)
    love.graphics.rectangle('line', 60, 80, 20, 80)
    love.graphics.rectangle('line', 760, 80, 20, 80)
    love.graphics.rectangle('line', 60, 480, 20, 80)
    love.graphics.rectangle('line', 760, 480, 20, 80)

    --vertical center
    love.graphics.rectangle('line', 460, 280, 20, 80)
    love.graphics.rectangle('line', 360, 280, 20, 80)

    -- horizontal wall position extremes (upper left to lower right)
    love.graphics.rectangle('line', 680, 60, 80, 20)
    love.graphics.rectangle('line', 80, 60, 80, 20)
    love.graphics.rectangle('line', 680, 560, 80, 20)
    love.graphics.rectangle('line', 80, 560, 80, 20)

    --horizontal center
    love.graphics.rectangle('line', 380, 260, 80, 20)
    love.graphics.rectangle('line', 380, 360, 80, 20)

]]