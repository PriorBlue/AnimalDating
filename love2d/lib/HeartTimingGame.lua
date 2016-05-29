HeartTimingGame = {}

function HeartTimingGame.load()
  HeartTimingGame.bar = {}
  HeartTimingGame.bar.img = love.graphics.newImage('data/LoveMeter.png')
  HeartTimingGame.bar.x = love.graphics.getWidth() * 0.5 - HeartTimingGame.bar.img:getWidth() * 0.5
  HeartTimingGame.bar.y = love.graphics.getHeight() * 0.5 - HeartTimingGame.bar.img:getHeight() * 0.5
  
  HeartTimingGame.indicator = {}
  HeartTimingGame.indicator.img = love.graphics.newImage('data/LoveMeterMark.png')
  HeartTimingGame.indicator.x = love.graphics.getWidth() * 0.5 - HeartTimingGame.indicator.img:getWidth() * 0.5
  HeartTimingGame.indicator.y = love.graphics.getHeight() * 0.5 - HeartTimingGame.indicator.img:getHeight() * 0.5
  
  HeartTimingGame.speed = 500
  HeartTimingGame.score = 0
  HeartTimingGame.didEvaluate = false
  
  HeartTimingGame.borderRight = HeartTimingGame.bar.x + HeartTimingGame.bar.img:getWidth()
  HeartTimingGame.borderLeft = HeartTimingGame.bar.x
  HeartTimingGame.midPoint = HeartTimingGame.bar.x + HeartTimingGame.bar.img:getWidth() * 0.5
  
  HeartTimingGame.isCurrentlyGoingRight = true
end


function HeartTimingGame.update(dt)
  HeartTimingGame.MoveIndicator(dt)
  
  if love.keyboard.isDown('space') then
    if not HeartTimingGame.didEvaluate then
      HeartTimingGame.didEvaluate = true
      HeartTimingGame.Evaluate()
    end
  else
    HeartTimingGame.didEvaluate = false
  end
  

end

function HeartTimingGame.draw()
  love.graphics.draw(HeartTimingGame.bar.img, HeartTimingGame.bar.x, HeartTimingGame.bar.y)
  love.graphics.draw(HeartTimingGame.indicator.img, HeartTimingGame.indicator.x, HeartTimingGame.indicator.y)
end

function HeartTimingGame.MoveIndicator(dt)
  local currentSpeed = HeartTimingGame.speed
  
  if not HeartTimingGame.isCurrentlyGoingRight then
    currentSpeed = -currentSpeed
  end
  
  HeartTimingGame.indicator.x = HeartTimingGame.indicator.x + currentSpeed * dt
  HeartTimingGame.CheckBorders()
end

function HeartTimingGame.CheckBorders()
  if HeartTimingGame.isCurrentlyGoingRight and HeartTimingGame.indicator.x > HeartTimingGame.borderRight then
    HeartTimingGame.isCurrentlyGoingRight = false
  end
  if not HeartTimingGame.isCurrentlyGoingRight and HeartTimingGame.indicator.x < HeartTimingGame.borderLeft then
    HeartTimingGame.isCurrentlyGoingRight = true
  end
  
end

function HeartTimingGame.Evaluate()
  distance = HeartTimingGame.midPoint - HeartTimingGame.indicator.x
  distance = math.abs(distance)
  
  HeartTimingGame.score = 100 - distance
  print (HeartTimingGame.score)
end
