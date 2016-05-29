text_gui = {}

--[[--
  Short instructions so nobody has to fight through the (currently horrible) code below:
  result_checking_function = text_gui.create_choice_box({"1", "2", "3", "4", "no"})
  create_choice_box() opens a choice box with the choices given as an array and returns a result checking function immediately. When that function is called, it returns either (false, nil) to signal that no choice has been made yet or (true, <choice_number>) after the enter key has been pressed.

  dummy_text = "This is just a short text.\nIt contains \n some newlines in order to\nforce a second page.\nWe still need another two newlines in order to reach the second page on a resolution of 800x600, but now we're done"
  text_closed_checker = text_gui.create_textbox(dummy_text)
  In this case, it's almost the same as above, except that the returned function does only return false until all text windows have been closed and true after that
--]]--

function text_gui.load()
  text_gui.font = love.graphics.newImageFont("data/default_imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
  -- maximum number of characters that fit in one text box line at 800x600 and 1.5x font magnification
  -- This assumption should eventually be replaced by some number crunching
  -- contains a function to draw the currently visible text box
  text_gui.current_textbox = nil
  text_gui.text_scale = 1.5
  text_gui.textboxvar = false
  text_gui.textbox_index = 1
  ---- choices
  -- contains a function to draw the currently visible choice box
  text_gui.current_choicebox = nil
  text_gui.selected_choice = 1
  text_gui.uppermost_choice = 1
  text_gui.navigate_choices = nil
  text_gui.choice_made = false
end

function text_gui.draw()
  if text_gui.current_textbox then
    text_gui.current_textbox()
  elseif text_gui.current_choicebox then
    text_gui.current_choicebox()
  end
end


-- display a given text within a rectangle
function text_gui.display_text_within_borders(text, minX, minY, maxX, maxY, text_scale)
  local minX, minY, maxX, maxY = minX or 0,minY or love.graphics.getHeight()/4*3,
    maxX or love.graphics.getWidth(),maxY or love.graphics.getHeight()
  text_gui.draw_frame()
  local tr, tg, tb, ta = love.graphics.getColor()
  love.graphics.setColor(250,250,250,255)
  draw_text = love.graphics.newText(text_gui.font, nil)
  local text = text or "not specified"
  local text_scale = text_scale or text_gui.text_scale
  draw_text:setf(text, maxX*(1/text_scale) -10, "left")
  love.graphics.draw(draw_text, minX+10, minY+6, 0,text_scale,text_scale)
  love.graphics.setColor(tr, tg, tb, ta)
end

function text_gui.draw_frame(minX, minY, maxX, maxY, frame_color, border_color, border_size)
  minX, minY, maxX, maxY = minX or 0,minY or love.graphics.getHeight()/4*3,maxX or love.graphics.getWidth(),maxY or love.graphics.getHeight()
  local tr, tg, tb, ta = love.graphics.getColor()
  frame_color = frame_color or {0,100,200,120}
  love.graphics.setColor(frame_color[1], frame_color[2], frame_color[3], frame_color[4])
  local tw = love.graphics.getLineWidth()
  love.graphics.setLineWidth(border_size or 5)
  love.graphics.rectangle("fill", minX+4, minY+4, maxX - minX - 8, maxY - minY - 8)
  border_color = border_color or {200,200,200,200}
  love.graphics.setColor(border_color[1], border_color[2], border_color[3], border_color[4])
  love.graphics.rectangle("line", minX+3, minY+2, maxX - minX - 6, maxY - minY - 4)
  love.graphics.setColor(tr,tg, tb, ta)
  love.graphics.setLineWidth(tw)
end

-------- CHOICES
function text_gui.draw_choice_frame(highlighted, minX, minY, maxX, maxY)
  local frame_color = {}
  local border_color = {}
  local border_size = 3
  if highlighted then
    frame_color = {50,150,250,180}
    border_color = {250,250,250,250}
    text_gui.draw_frame(minX, minY, maxX, maxY, frame_color, border_color, border_size)
  else
    frame_color = {0,100,200,100}
    border_color = {180,180,180,180}
    text_gui.draw_frame(minX, minY, maxX, maxY, frame_color, border_color, border_size)
  end
end

function text_gui.create_choice_box(choices)
  text_gui.selected_choice = 1
  text_gui.uppermost_choice = 1
  text_gui.choice_made = false
  text_gui.current_choicebox = function()
    text_gui.display_choice_box(choices, text_gui.selected_choice, text_gui.uppermost_choice)
    if text_gui.choice_made then
      text_gui.current_choicebox = nil
    end
  end
  text_gui.navigate_choices = function(direction)
    if direction == 1 then
      text_gui.selected_choice = text_gui.selected_choice > 1 and text_gui.selected_choice - 1 or 1
      if text_gui.uppermost_choice > text_gui.selected_choice then
        text_gui.uppermost_choice = text_gui.uppermost_choice - 1
      end
    elseif direction == -1 then
      text_gui.selected_choice = text_gui.selected_choice < #choices and text_gui.selected_choice + 1 or #choices
      if text_gui.selected_choice - text_gui.uppermost_choice >= 4 and text_gui.uppermost_choice > 0 then
        text_gui.uppermost_choice = text_gui.uppermost_choice + 1
      end
    end
  end
  -- returns (false, nil) until a choice is made, after that the return value will be (true, <choice_number>)
  local choice_box_finished_checker = function()
    if text_gui.choice_made then
      return true, text_gui.selected_choice
    else
      return false, nil
    end
  end
  return choice_box_finished_checker
end

function text_gui.display_choice_box(choices, highlighted_number, uppermost_choice)
  -- define default window size
  minX, minY, maxX, maxY = minX or 0,minY or love.graphics.getHeight()/4*3,maxX or love.graphics.getWidth(), maxY or love.graphics.getHeight()
  -- split visible window according to number of choices
  -- TODO it is assumed for now that no choice needs more than one line
  local single_choice_height = 0
  local space_between_choices = 3 -- vertical pixels between two choice borders
  if #choices <= 4 then
    single_choice_height = (love.graphics.getHeight()/4)/#choices - space_between_choices
  else
    -- more than 4 choices
    -- -> split into packs of four, display only the ones around the active one and show some arrows on the side to indicate that there's more
    single_choice_height = love.graphics.getHeight()/16 - space_between_choices
  end
  local choice_draw = {}
  for i = 1, #choices do
    choice_draw[i] = function(highlighted, uppermost)
      local position = i - uppermost + 1
      local choice_minY = minY+space_between_choices*position+(position-1)*single_choice_height
      local choice_maxY = choice_minY + single_choice_height
      text_gui.draw_choice_frame(highlighted, minX, choice_minY, maxX, choice_maxY)
      local tr, tg, tb, ta = love.graphics.getColor()
      love.graphics.setColor(250,250,250,255)
      draw_text = love.graphics.newText(text_gui.font, nil)
      local text = choices[i]
      local text_scale = text_scale or text_gui.text_scale
      draw_text:setf(text, maxX*(1 / text_scale), "left")
      local text_y_offset = single_choice_height / 2 - text_gui.font:getHeight() / 2 - space_between_choices
      love.graphics.draw(draw_text, minX+10, choice_minY+text_y_offset, 0,text_scale,text_scale)
    end
  end
  -- show choices (highlight first)
  for i = uppermost_choice, #choice_draw <= 4 and #choice_draw or uppermost_choice + 3 do
    choice_draw[i](highlighted_number == i, uppermost_choice)
  end
end

-------- TEXT BOXES
-- this shall only be called once
function text_gui.create_textbox(text)
  text_gui.textboxvar = false
  text_gui.textbox_index = 1
  text_gui.line_pairs = text_gui._split_text(text)
  text_gui.current_textbox = function()
    text_gui.textboxvar = text_gui.display_textboxes(text, text_gui.textbox_index, text_gui.line_pairs)
    if text_gui.textboxvar then
      text_gui.current_textbox = nil
    end
  end
  -- returns false until all text boxes of the current dialogue are closed
  local textbox_finished_checker = function()
    return text_gui.textboxvar
  end
  return textbox_finished_checker
end

function text_gui.display_textboxes(text, curr_textbox_number, line_pairs)
  if not line_pairs then
    line_pairs = text_gui._split_text(text)
  end
  if curr_textbox_number <= #line_pairs then
    text_gui.display_text_within_borders(line_pairs[curr_textbox_number])
    return false
  else
    -- signal at this point that the text box is done
    return true
  end
end

-- split the text to sections that fill five lines (by default, define max_lines for a different value)
function text_gui._split_text(text, max_lines)
  local window_part_max_lines = math.floor((love.graphics.getHeight()/4)/(text_gui.font:getHeight()*1.5))
  local max_lines = max_lines or window_part_max_lines
  local line_char_length = math.floor((love.graphics.getWidth()-100)/(text_gui.font:getWidth("A")*1.5))
  
  local width, lines = text_gui.font:getWrap(text, love.graphics.getWidth()*(1/text_gui.text_scale))
  --local line_char_length = width
  --[[--
  local line_pairs = {}
  for i = 1, (#lines-#lines%max_lines)/max_lines do
    local current_line_pair = {}
    for j = i*max_lines, (i+1)*max_lines - 1 do
      current_line_pair[j - i*max_lines + 1] = lines[j]
    end
    line_pairs[i] = current_line_pair
  end
  return line_pairs
end
  --]]--
  local line_pairs = {}
  local full_lines = 1
  local current_line_start = 1
  local current_line_pair_start = 1
  local newline = string.byte("\n")
  local space = string.byte(" ")
  local escape_char = string.byte("%")
  local escape_newbox = string.byte("t")
  for i = 1, #text do
    if i - current_line_start >= line_char_length then
      -- new line because of line length
      full_lines = full_lines + 1
      -- find the previous space
      local last_space_position = current_line_start
      for j = current_line_start, i do
        if text:byte(j) == space then
          -- space found
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
    elseif text:byte(i) == escape_char then
      -- check next sign if it exists
      if #text > i+1 then
        if text:byte(i+1) == escape_newbox then
          -- manual newboxing
          line_pairs[#line_pairs + 1] = text:sub(current_line_pair_start, i-1)
          --full_lines = max_lines + 1
          -- jump ahead with i
          i = i + 2
          current_line_pair_start = i
          full_lines = 1
        end
      end
    end
    -- check if 5 lines are full
    if full_lines > max_lines then
      line_pairs[#line_pairs + 1] = text:sub(current_line_pair_start, i)
      current_line_pair_start = i + 1
      full_lines = 1
    end
  end
  -- add last line(s) if not empty
  if not (current_line_pair_start == #text) then
    line_pairs[#line_pairs + 1] = text:sub(current_line_pair_start, #text)
  end

  return line_pairs
end
