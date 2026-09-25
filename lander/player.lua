local SIZE = 8

Player = {}

local function thrust(self)
  if (btn(0)) self.dx -= self.thrust_power
  if (btn(1)) self.dx += self.thrust_power
  if (btn(2)) self.dy -= self.thrust_power

  if (btn(0) or btn(1) or btn(2)) sfx(0)
end

local function stay_on_screen(self)
  -- left side
  if (self.x < 0) then
    self.x = 0
    self.dx = 0
  end
  -- right side
  if (self.x > 119) then
    self.x = 119
    self.dx = 0
  end
  --- top side
  if (self.y < 0) then
    self.y = 0
    self.dy = 0
  end
end

function Player:init()
  self.x = 60
  self.y = 8
  self.dx = 0
  self.dy = 0
  self.sprite = 1
  self.win_sprite = 4
  self.lost_sprite = 5
  self.thrust_sprite = 6
  self.state = "flying"
  -- "flying", "landed" or "crashed"
  self.thrust_power = 0.075
  self.gravity = 0.025
end

function Player:land()
  self.state = "landed"
end

function Player:crash()
  self.state = "crashed"
end

-- left, right, bottom edges in pixels
function Player:bounds()
  return flr(self.x), flr(self.x + SIZE - 1), flr(self.y + SIZE - 1)
end

function Player:update()
  self.dy += self.gravity

  thrust(self)

  self.x += self.dx
  self.y += self.dy

  stay_on_screen(self)
end

function Player:draw()
  if (self.state == "flying" and (btn(0) or btn(1) or btn(2))) spr(self.thrust_sprite, self.x, self.y + 2)

  spr(self.sprite, self.x, self.y)

  if self.state == "landed" then
    spr(self.win_sprite, self.x, self.y - 8)
  elseif self.state == "crashed" then
    spr(self.lost_sprite, self.x, self.y)
  end
end