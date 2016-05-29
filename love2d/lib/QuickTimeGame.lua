QuickTimeGame = {}

function QuickTimeGame.load()
  QuickTimeGame.icon = {}
  QuickTimeGame.icon.img = love.graphics.newImage('data/LoveMeter.png')
  QuickTimeGame.icon.x = love.graphics.getWidth() * 0.5 - QuickTimeGame.icon.img:getWidth() * 0.5
  QuickTimeGame.icon.y = love.graphics.getHeight() * 0.5 - QuickTimeGame.icon.img:getHeight() * 0.5
  
  QuickTimeGame.time = 3
  QuickTimeGame.succeeded = false
end

function QuickTimeGame.update(dt)
  if love.keyboard.isDown('space') then
      QuickTimeGame.Evaluate(true)
  end
  
  QuickTimeGame.time = QuickTimeGame.time - dt
  if (QuickTimeGame.time < 0 and not QuickTimeGame.succeeded) then
    QuickTimeGame.Evaluate(false)
  end
  
end

function QuickTimeGame.draw()
  if QuickTimeGame.time > 0 and not QuickTimeGame.succeeded then
    love.graphics.draw(QuickTimeGame.icon.img, QuickTimeGame.icon.x, QuickTimeGame.icon.y)
  end
end

function QuickTimeGame.AnyKeyWasPressed()
  if QuickTimeGame.time > 0 then
    Evaluate(true)
  end
end

function QuickTimeGame.Evaluate(wasSuccess)
  QuickTimeGame.succeeded = wasSuccess

  -- call Event here?
end
