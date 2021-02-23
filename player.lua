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
player.hasKey = false
player.moveSpace = 100

function playerUpdate(dt)

    if player.body then
--[[
        local collidersRight = world:queryRectangleArea(player:getX() + 39, player:getY() - 5, 5, 10, {'Wall'})
        local collidersLeft = world:queryRectangleArea(player:getX() - 41, player:getY() - 5, 5, 10, {'Wall'})
        local collidersUp = world:queryRectangleArea(player:getX() - 5, player:getY() - 41, 10, 5, {'Wall'})
        local collidersDown = world:queryRectangleArea(player:getX() - 5, player:getY() + 39, 10, 5, {'Wall'})]]

        local collidersRight = world:queryRectangleArea(player:getX() + 38, player:getY() - 35, 7, 70, {'Wall'})
        local collidersLeft = world:queryRectangleArea(player:getX() - 43, player:getY() - 35, 7, 70, {'Wall'})
        local collidersUp = world:queryRectangleArea(player:getX() - 35, player:getY() - 43, 70, 7, {'Wall'})
        local collidersDown = world:queryRectangleArea(player:getX() - 35, player:getY() + 38, 70, 7, {'Wall'})

            if #collidersRight >0 then
                player.rightBlocked = true
            else
                player.rightBlocked = false
            end

            if #collidersLeft >0 then
                player.leftBlocked = true
            else
                player.leftBlocked = false
            end

            if #collidersUp >0 then
                player.upBlocked = true
            else
                player.upBlocked = false
            end
        
            if #collidersDown >0 then
                player.downBlocked = true
            else
                player.downBlocked = false
            end
        player.posX, player.posY = player:getPosition()
        
    end
end

function drawPlayer()
    local px, py = player:getPosition()
    love.graphics.draw(sprites.playerGraphic, player.posX, player.posY, 0, 0.5, 0.5, sprites.playerGraphic:getWidth() / 2, sprites.playerGraphic:getHeight() / 2)
    --love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, ks, ky)
end
