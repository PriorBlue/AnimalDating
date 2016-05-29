require('lib/32linesofgoodness')
require("lib/postshader")
nodeManager = require("node")

function love.load()
	nodeManager.init()
	
	local font
	font = love.graphics.newFont("font/font.ttf", 16)
	love.graphics.setFont(font)
end

function love.update(dt)
	nodeManager.update(dt)
end

function love.draw()
	nodeManager.draw()
end

function love.keypressed(key)
	nodeManager.keypressed(key)
end

function love.keyreleased(key)

end

function love.textinput(text)
	nodeManager.textinput(text)
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

function love.wheelmoved(x, y)
	nodeManager.wheelmoved(x, y)
end