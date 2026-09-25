local START_COUNT = 50
local GROUND_MAX_TOP = 96 -- highest point
local GROUND_MIN_BTM = 120 -- lowest point
local PAD_WIDTH = 15

Level = {
  pad = {},
  ground = {}
}

local function init_pad()
  return {
    width = PAD_WIDTH,
    sprite = 2,
    x = rndb(0, 126 - PAD_WIDTH),
    y = rndb(GROUND_MAX_TOP, GROUND_MIN_BTM)
  }
end

local function init_ground(self)
  -- create ground at pad
  for i = self.pad.x, self.pad.x + self.pad.width do
    self.ground[i] = self.pad.y
  end

  -- create ground right of pad
  for i = self.pad.x + self.pad.width + 1, 127 do
    local height = rndb(self.ground[i - 1] - 3, self.ground[i - 1] + 3)
    self.ground[i] = mid(GROUND_MAX_TOP, height, GROUND_MIN_BTM)
  end

  -- create groud left of pad
  for i = self.pad.x - 1, 0, -1 do
    local height = rndb(self.ground[i + 1] - 3, self.ground[i + 1] + 3)
    self.ground[i] = mid(GROUND_MAX_TOP, height, GROUND_MIN_BTM)
  end
end

local function draw_pad(self)
  spr(self.pad.sprite, self.pad.x, self.pad.y, 2, 1)
end

local function draw_ground(self)
  for i = 0, 127 do
    line(i, self.ground[i], i, 127, 5)
  end
end

local function draw_stars()
  srand(1)
  for i = 1, START_COUNT do
    pset(rndb(0, 127), rndb(0, 127), rndb(5, 7))
  end
  srand(time())
end

function Level:init()
  self.pad = init_pad()
  init_ground(self)
end

-- returns "pad", "ground" or nil
function Level:touchdown(l, r, b)
  local pad = self.pad
  if l >= pad.x and r <= pad.x + pad.width and b >= pad.y - 1 then
    return "pad"
  end
  for i = l, r do
    if (self.ground[i] <= b) return "ground"
  end
end

function Level:draw()
  draw_stars()
  draw_ground(self)
  draw_pad(self)
end