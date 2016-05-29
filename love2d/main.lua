require('lib/32linesofgoodness')
require("lib/postshader")
nodeManager = require("node")
require("lib/text_gui")

function love.load()
	nodeManager.init()
	local font
	font = love.graphics.newFont("font/font.ttf", 16)
	love.graphics.setFont(font)
  text_gui.load()
end

function love.update(dt)
	nodeManager.update(dt)
end

function love.draw()
	nodeManager.draw()
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit(0)
  end
end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)
	nodeManager.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	nodeManager.mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
	nodeManager.mousemoved(x, y, dx, dy)
end