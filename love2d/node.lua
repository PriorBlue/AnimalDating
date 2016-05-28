local nodeManager = {}

nodeManager.init = function()
	nodeManager.list = dofile("data/nodes.lua")
	nodeManager.drag = nil
	nodeManager.node = nil
	nodeManager.out = nil
	nodeManager.outX = 0
	nodeManager.outY = 0
	nodeManager.mouseX = 0
	nodeManager.mouseY = 0
end

nodeManager.update = function(dt)
	for k, v in pairs(nodeManager.list) do
		local cnt = 0
		if v.out then
			for k2, v2 in pairs(v.out) do
				v2.x = v.x + v.width - 12
				v2.y = v.y + cnt * 16 + 40
				cnt = cnt + 1
			end
		end
	end
end
	
nodeManager.draw = function()
	for k, v in pairs(nodeManager.list) do
		local cnt = 0
		love.graphics.setColor(191, 191, 191)
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height, 8)
		love.graphics.setColor(127, 127, 127)
		love.graphics.rectangle("fill", v.x, v.y, v.width, 24, 8)
		love.graphics.setColor(223, 223, 223)
		love.graphics.printf(k, v.x, v.y + 4, v.width, "center")
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("fill", v.x + 12, v.y + v.height * 0.5, 6)
		love.graphics.setColor(223, 223, 223)
		love.graphics.circle("fill", v.x + 12, v.y + v.height * 0.5, 4)
		if v.out then
			for k2, v2 in pairs(v.out) do
				love.graphics.setColor(0, 0, 0)
				love.graphics.printf(v2.name, v.x, v2.y - 8, v.width - 32, "right")
				love.graphics.circle("fill", v2.x, v2.y, 6)
				love.graphics.setColor(223, 223, 223)
				love.graphics.circle("fill", v2.x, v2.y, 4)
				cnt = cnt + 1
			end
		end
		love.graphics.setColor(63, 63, 63)
		love.graphics.printf(v.text, v.x + 24, v.y + cnt * 16 + 40, v.width - 32, "left")
	end

	if nodeManager.node then
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle("fill", nodeManager.outX , nodeManager.outY, 4)
		love.graphics.line(nodeManager.outX, nodeManager.outY, nodeManager.mouseX, nodeManager.mouseY)
	end
	
	love.graphics.setColor(255, 255, 255)
end

nodeManager.mousepressed = function(x, y, button)
	for k, v in pairs(nodeManager.list) do
		cnt = 0
		if x >= v.x and x <= v.x + v.width and y >= v.y and y <= v.y + 24 then
			nodeManager.drag = k
			nodeManager.dragX = v.x - x
			nodeManager.dragY = v.y - y
		elseif v.out and x >= v.x and x <= v.x + v.width and y >= v.y and y <= v.y + v.height then
			for k2, v2 in pairs(v.out) do
				if x >= v.x + v.width - 18 and x <= v.x + v.width - 6 and y >= v.y + cnt * 16 + 34 and y <= v.y + cnt * 16 + 46 then
					print(k, v2.node)
					nodeManager.node = k2
					nodeManager.out = v2
					
					nodeManager.outX = v.x + v.width - 12
					nodeManager.outY = v.y + cnt * 16 + 40
					nodeManager.mouseX = nodeManager.outX
					nodeManager.mouseY = nodeManager.outY
				end

				cnt = cnt + 1
			end
		end
	end
end

nodeManager.mousereleased = function(x, y, button)
	nodeManager.drag = nil
	nodeManager.node = nil
	nodeManager.out = nil
end

nodeManager.mousemoved = function(x, y, dx, dy)
	if nodeManager.drag then
		nodeManager.list[nodeManager.drag].x = x + nodeManager.dragX
		nodeManager.list[nodeManager.drag].y = y + nodeManager.dragY
	end
	
	if nodeManager.node then
		nodeManager.mouseX = x
		nodeManager.mouseY = y
	end
end

return nodeManager