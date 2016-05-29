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
  draw_text = love.graphics.newText(text_gui.default_font, nil)
  local text = text or "not specified"
  local text_scale = text_scale or 1.5
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
  minX, minY, maxX, maxY = minX or 0,minY or love.graphics.getHeight()/4*3,maxX or love.graphics.getWidth(), maxY or love.graphics.getHeight()
  
end

function text_gui.display_choice_box(text)

end

function text_gui._display_textbox(text)
  text_gui.display_text_within_borders(text)
end

function text_gui.display_textboxes(text, curr_textbox_number, five_line_pairs)
  if not five_line_pairs then
    five_line_pairs = text_gui._split_text(text)
  end
  if curr_textbox_number <= #five_line_pairs then
    text_gui._display_textbox(five_line_pairs[curr_textbox_number])
    return false
  else
    -- signal at this point that the text box is done
    return true
  end
end

-- maximum number of characters that fit in one text box line at 800x600 and 1.5x font magnification
text_gui.line_char_length = 58
-- split the text to sections that fill five lines
function text_gui._split_text(text)
    -- check how many lines there are in the text
  local five_line_pairs = {}
  local full_lines = 1
  local current_line_start = 1
  local current_five_line_pair_start = 1
  local newline = string.byte("\n")
  local space = string.byte(" ")
  for i = 1, #text do
    if i - current_line_start >= text_gui.line_char_length then
      -- new line because of line length
      --print("newline because of length")
      full_lines = full_lines + 1
      -- find the previous space
      local last_space_position = current_line_start
      for j = current_line_start, i do
        if text:byte(j) == space then
          -- space found
          --print("space found")
          last_space_position = j
        end
      end
      if last_space_position >= current_line_start + 1 then
        i = last_space_position - 1
      end
      current_line_start = i + 1
    elseif text:byte(i) == newline then
      -- new line because of \n
      full_lines = full_lines + 1
      current_line_start = i + 1
    end
    -- check if 5 lines are full
    if full_lines > 5 then
      five_line_pairs[#five_line_pairs + 1] = text:sub(current_five_line_pair_start, i)
      current_five_line_pair_start = i + 1
      full_lines = 1
    end
  end
  -- add last line(s) if not empty
  if not (current_five_line_pair_start == #text) then
    five_line_pairs[#five_line_pairs + 1] = text:sub(current_five_line_pair_start, #text)
  end
  
  return five_line_pairs
end