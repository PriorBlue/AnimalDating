text_gui = {}

-- load everything
function text_gui.load()
  text_gui.default_font = love.graphics.newImageFont("data/default_imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
end

-- display a given text within a rectangle
function text_gui.display_text_within_borders(text, minX, minY, maxX, maxY, text_scale)
  local minX, minY, maxX, maxY = minX or 0,minY or love.graphics.getHeight()/4*3,
    maxX or love.graphics.getWidth(),maxY or love.graphics.getHeight()
  text_gui.draw_text_frame()
  tr, tg, tb, ta = love.graphics.getColor()
  love.graphics.setColor(250,250,250,255)
  --love.graphics.printf("test", minX, minY, 600, "left")
  draw_text = love.graphics.newText(text_gui.default_font, nil)
  local text = text or "not specified"
  local text_scale = 1.5
  draw_text:setf(text, maxX*(1/text_scale), "left")
  --love.graphics.printf("test", minX+10, minY+10, maxX - minX - 20, "left")
  love.graphics.draw(draw_text, minX+10, minY+10, 0,text_scale,text_scale)
  --love.graphics.draw(draw_text, 10, 10, 0)--,2,2)
  love.graphics.setColor(tr, tg, tb, ta)
end

function text_gui.draw_text_frame(minX, minY, maxX, maxY)
  minX, minY, maxX, maxY = minX or 0,minY or love.graphics.getHeight()/4*3,maxX or love.graphics.getWidth(),maxY or love.graphics.getHeight()
  tr, tg, tb, ta = love.graphics.getColor()
  love.graphics.setColor(0,100,200,120)
  tw = love.graphics.getLineWidth()
  love.graphics.setLineWidth(5)
  love.graphics.rectangle("fill", minX+5, minY+5, maxX - minX - 10, maxY - minY - 10)
  love.graphics.setColor(200,200,200,200)
  love.graphics.rectangle("line", minX+5, minY+5, maxX - minX - 10, maxY - minY - 10)
  love.graphics.setColor(tr,tg, tb, ta)
  love.graphics.setLineWidth(tw)
end

function text_gui.draw_choice_frame(minX, minY, maxX, maxY)
  
end

function text_gui.display_textbox(text)
  
end

function text_gui.display_textboxes(text)
  
end
