HeartCatcher = {}

function HeartCatcher.load()
  HeartCatcher.player = {}
  HeartCatcher.player.img = love.graphics.newImage('data/DownArrow.png')
  HeartCatcher.player.x = love.graphics.getWidth() * 0.5 - HeartCatcher.player.img:getWidth() * 0.5
  HeartCatcher.player.y = love.graphics.getHeight() * 0.9 - HeartCatcher.player.img:getHeight() * 0.5
  HeartCatcher.player.speed = 500
  
  HeartCatcher.heartData = {}
  HeartCatcher.heartData.spawnTimer = 0.05
  HeartCatcher.heartData.speed = 750
  HeartCatcher.heartData.img = love.graphics.newImage('data/Heart.png')
  
  HeartCatcher.allHearts = {}
  HeartCatcher.createHeartTimer = HeartCatcher.heartData.spawnTimer
  HeartCatcher.currentHeartTimer = HeartCatcher.createHeartTimer
  
  HeartCatcher.timeLeft = 30
  HeartCatcher.score = 0
  
  HeartCatcher.dropTarget = 0
  HeartCatcher.lastDropTarget = 0
  HeartCatcher.dropTargetSpeed = 100
  HeartCatcher.currentDropPosition = love.graphics.getWidth() * 0.5 - HeartCatcher.heartData.img:getWidth() * 0.5;
  HeartCatcher.SetNewDropTarget()
end


function HeartCatcher.update(dt)
  HeartCatcher.CheckGameOverConditions(dt)
  HeartCatcher.MovePlayer(dt)
  HeartCatcher.ClampPositionToScreen(HeartCatcher.player)
  
  HeartCatcher.UpdateHearts(dt)
  HeartCatcher.MoveDropTarget(dt)
  HeartCatcher.DoCollisionChecks()
end

function HeartCatcher.draw(dt)
  love.graphics.draw(HeartCatcher.player.img, HeartCatcher.player.x, HeartCatcher.player.y)
  
  for i, heart in ipairs(HeartCatcher.allHearts) do
    love.graphics.draw(heart.img, heart.x, heart.y)
  end
end

function HeartCatcher.CheckGameOverConditions(dt)
  HeartCatcher.timeLeft = HeartCatcher.timeLeft - dt
  
  if HeartCatcher.timeLeft < 0 then
    -- stop the game here?
    -- Throw Event?
  end
  
end

function HeartCatcher.ClampPositionToScreen(obj)
  if obj.x < 0 then
    obj.x = 0
  end
  
  if obj.x + obj.img:getWidth() > love.graphics.getWidth() then
    obj.x = love.graphics.getWidth() - obj.img:getWidth()
  end
  
  if obj.y < 0 then
    obj.y = 0
  end
  
  if obj.y + obj.img:getHeight() > love.graphics.getHeight() then
    obj.y = love.graphics.getHeight() - obj.img:getHeight()
  end  
end

function HeartCatcher.CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function HeartCatcher.MovePlayer(dt)
  if love.keyboard.isDown('left', 'a') then
    HeartCatcher.player.x = HeartCatcher.player.x - dt * HeartCatcher.player.speed
  end
  
  if love.keyboard.isDown('right', 'd') then
    HeartCatcher.player.x = HeartCatcher.player.x + dt * HeartCatcher.player.speed
  end
  
  if love.keyboard.isDown('up', 'w') then
    HeartCatcher.player.y = HeartCatcher.player.y - dt * HeartCatcher.player.speed
  end
  
  if love.keyboard.isDown('down', 's') then
    HeartCatcher.player.y = HeartCatcher.player.y + dt * HeartCatcher.player.speed
  end
end

function HeartCatcher.SpawnHeart(dt)
  HeartCatcher.currentHeartTimer = HeartCatcher.currentHeartTimer - dt
  if HeartCatcher.currentHeartTimer < 0 then
    local newHeart = {}
    newHeart.x = HeartCatcher.currentDropPosition
    newHeart.y = -10
    newHeart.img = HeartCatcher.heartData.img
    table.insert(HeartCatcher.allHearts, newHeart)
    
    HeartCatcher.currentHeartTimer = HeartCatcher.createHeartTimer
  end
end

function HeartCatcher.MoveHearts(dt)
  for i, heart in ipairs(HeartCatcher.allHearts) do
    heart.y = heart.y + HeartCatcher.heartData.speed * dt
  
    if heart.y > love.graphics.getHeight() + heart.img:getHeight() then
      HeartCatcher.RemoveHeart(i, false)
    end
  end
end

function HeartCatcher.RemoveHeart(i, collected)
  if collected then
    HeartCatcher.score = HeartCatcher.score + 1
  else
    print (HeartCatcher.allHearts[i].x) 
    HeartCatcher.score = HeartCatcher.score - 10
  end
  
  print (HeartCatcher.score)
  table.remove(HeartCatcher.allHearts, i)
end

function HeartCatcher.UpdateHearts(dt)
  if HeartCatcher.timeLeft > 2 then
    HeartCatcher.SpawnHeart(dt)
  end
  HeartCatcher.MoveHearts(dt)
end

function HeartCatcher.ProcessHeartCollision(heartIndex)
  HeartCatcher.RemoveHeart(heartIndex, true)
end

function HeartCatcher.CheckForHeartCollision(heart)
  return HeartCatcher.CheckCollision(heart.x, heart.y, heart.img:getWidth(), heart.img:getHeight(), HeartCatcher.player.x, HeartCatcher.player.y, HeartCatcher.player.img:getWidth(), HeartCatcher.player.img:getHeight())
end

function HeartCatcher.DoCollisionChecks()
  for i, heart in ipairs(HeartCatcher.allHearts) do
    if HeartCatcher.CheckForHeartCollision(heart) then
      HeartCatcher.ProcessHeartCollision(i)
    end
  end
end

function HeartCatcher.SetNewDropTarget()
  HeartCatcher.lastDropTarget = HeartCatcher.dropTarget
  
  local heartWidth = HeartCatcher.heartData.img:getWidth()
  HeartCatcher.dropTarget = love.math.random(heartWidth * 0.5, love.graphics.getWidth() - heartWidth * 0.5)
  HeartCatcher.dropTargetSpeed = love.math.random(350, 1000)
end

function HeartCatcher.MoveDropTarget(dt)
  local distanceCovered = HeartCatcher.dropTargetSpeed * dt * HeartCatcher.GetCurrentDropDistancePercentage()
  local inverted = false
  if (HeartCatcher.currentDropPosition > HeartCatcher.dropTarget) then
    distanceCovered = - distanceCovered
    inverted = true
  end
  
  HeartCatcher.currentDropPosition = HeartCatcher.currentDropPosition + distanceCovered
  
  if HeartCatcher.currentDropPosition < HeartCatcher.dropTarget and inverted then
    HeartCatcher.SetNewDropTarget()
  else if HeartCatcher.currentDropPosition > HeartCatcher.dropTarget and not inverted then
    HeartCatcher.SetNewDropTarget()
    end
  end
end

function HeartCatcher.GetCurrentDropDistancePercentage()
  local totalDistance = GetDistance(HeartCatcher.lastDropTarget, HeartCatcher.dropTarget)
  local coveredDistance = GetDistance(HeartCatcher.lastDropTarget, HeartCatcher.currentDropPosition)
  
  local percentage = 0
  if totalDistance > 0 then 
    percentage = coveredDistance / totalDistance
  end
    
  -- so now we have a value in [0, 1]
  -- make it so we have, depending on distance, something like [0.x --- 1 --- 0.x]
  local x = percentage - 0.5
  
  if (x > 0.5) then
    -- sometimes x = inf and i totaly don't understand why, fix it here.
    x = 0.5
  end
  
  return -(x * x) * 3 + 1
end

function GetDistance(a, b)
  return math.abs(a - b)
end