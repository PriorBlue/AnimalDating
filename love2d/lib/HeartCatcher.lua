HeartCatcher = {}

function HeartCatcher.load()
  HeartCatcher.player = {}
  HeartCatcher.player.img = love.graphics.newImage('data/DownArrow.png')
  HeartCatcher.player.x = love.graphics.getWidth() * 0.5 - HeartCatcher.player.img:getWidth() * 0.5
  HeartCatcher.player.y = love.graphics.getHeight() * 0.9 - HeartCatcher.player.img:getHeight() * 0.5
  HeartCatcher.player.speed = 500
  
  HeartCatcher.heartData = {}
  HeartCatcher.heartData.spawnTimer = 0.4
  HeartCatcher.heartData.speed = 750
  HeartCatcher.heartData.img = love.graphics.newImage('data/Heart.png')
  
  HeartCatcher.allHearts = {}
  HeartCatcher.createHeartTimer = HeartCatcher.heartData.spawnTimer
  HeartCatcher.currentHeartTimer = HeartCatcher.createHeartTimer
  
  HeartCatcher.timeLeft = 60
  HeartCatcher.score = 0
end


function HeartCatcher.update(dt)
  HeartCatcher.timeLeft = HeartCatcher.timeLeft - dt
  HeartCatcher.MovePlayer(dt)
  HeartCatcher.ClampPositionToScreen(HeartCatcher.player)
  
  HeartCatcher.UpdateHearts(dt)
  HeartCatcher.DoCollisionChecks()
end

function HeartCatcher.draw(dt)
  love.graphics.draw(HeartCatcher.player.img, HeartCatcher.player.x, HeartCatcher.player.y)
  
  for i, heart in ipairs(HeartCatcher.allHearts) do
    love.graphics.draw(heart.img, heart.x, heart.y)
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
    local randomNumber = math.random (0, love.graphics.getWidth() - HeartCatcher.heartData.img:getWidth())
    local newHeart = {}
    newHeart.x = randomNumber
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
    HeartCatcher.score = HeartCatcher.score - 10
  end
  
  print (HeartCatcher.score)
  table.remove(HeartCatcher.allHearts, i)
end

function HeartCatcher.UpdateHearts(dt)
  HeartCatcher.SpawnHeart(dt)
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
