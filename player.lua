--establish poop timer--

startX = 25
startY = 25

--create player body
player = world:newRectangleCollider(startX, startY, 70, 70, {collision_class = "Player"})
player:setFixedRotation (true)

--init player position with start position
player.posX = startX
player.posY = startY
player.rightBlocked = false
player.leftBlocked = false
player.upBlocked = false
player.downBlocked = false
player.rightBlockedDoor = false
player.leftBlockedDoor = false
player.upBlockedDoor = false
player.downBlockedDoor = false
player.hasKey = false
player.moveSpace = 100
player.misses = 0
player.score = 0

function drawPlayer()
    local px, py = player:getPosition()
    love.graphics.draw(sprites.playerGraphic, px - 8, py + 10, 0, 0.3, 0.3, sprites.playerGraphic:getWidth() / 2, sprites.playerGraphic:getHeight() / 2)
    --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, ks, ky)
end

function playerUpdate(dt)
    if player.body then

        local collidersRight = world:queryRectangleArea(player:getX() + 38, player:getY() - 35, 7, 70, {'Wall'})
        local collidersLeft = world:queryRectangleArea(player:getX() - 43, player:getY() - 35, 7, 70, {'Wall'})
        local collidersUp = world:queryRectangleArea(player:getX() - 35, player:getY() - 43, 70, 7, {'Wall'})
        local collidersDown = world:queryRectangleArea(player:getX() - 35, player:getY() + 38, 70, 7, {'Wall'})

        local collidersRightDoor = world:queryRectangleArea(player:getX() + 38, player:getY() - 35, 8, 70, {'Doors', })
        local collidersLeftDoor = world:queryRectangleArea(player:getX() - 43, player:getY() - 35, 8, 70, {'Doors',})
        local collidersUpDoor = world:queryRectangleArea(player:getX() - 35, player:getY() - 43, 70, 8, {'Doors',})
        local collidersDownDoor = world:queryRectangleArea(player:getX() - 35, player:getY() + 38, 70, 8, {'Doors'})

        if #collidersRight >0 then
            player.rightBlocked = true
        else
            player.rightBlocked = false
        end

        if #collidersRightDoor > 0 then
            if player.hasKey == false then
                player.rightBlockedDoor = true
            end
        else
            player.rightBlockedDoor = false
        end

        if #collidersLeft >0 then
            player.leftBlocked = true
        else
            player.leftBlocked = false
        end

        if #collidersLeftDoor > 0 then
            if player.hasKey == false then
                player.leftBlockedDoor = true
            end
        else
            player.leftBlockedDoor = false
        end

        if #collidersUp >0 then
            player.upBlocked = true
        else
            player.upBlocked = false
        end

        if #collidersUpDoor > 0 then
            if player.hasKey == false then
                player.upBlockedDoor = true
            end
        else
            player.upBlockedDoor = false
        end

        if #collidersDown >0 then
            player.downBlocked = true
        else
            player.downBlocked = false
        end

        if #collidersDownDoor > 0 then
            if player.hasKey == false then
                player.downBlockedDoor = true
            end
        else
            player.downBlockedDoor = false
        end
        player.posX, player.posY = player:getPosition()
    end
end