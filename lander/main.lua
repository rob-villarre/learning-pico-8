local MAX_LANDING_SPEED = 1
local state

function set_state(s, ...)
  state = s
  s:init(...)
end

Play = {}

function Play:init()
  Player:init()
  Level:init()
end

function Play:update()
  Player:update()

  local hit = Level:touchdown(Player:bounds())
  if hit == "pad" and Player.dy < MAX_LANDING_SPEED then
    Player:land()
    set_state(GameOver, true)
  elseif hit then
    Player:crash()
    set_state(GameOver, false)
  end
end

function Play:draw()
  Level:draw()
  Player:draw()
end

GameOver = {}

function GameOver:init(won)
  self.won = won
  sfx(won and 1 or 2)
end

function GameOver:update()
  if (btnp(5)) set_state(Play)
end

function GameOver:draw()
  Play:draw()

  if self.won then
    print("you win!", 48, 48, 11)
  else
    print("too bad!", 48, 48, 8)
  end
  print("press ❎ to play again", 20, 70, 5)
end

function _init()
  set_state(Play)
end

function _update()
  state:update()
end

function _draw()
  cls()
  state:draw()
end