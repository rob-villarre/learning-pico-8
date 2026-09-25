pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
SPR_WIDTH = 7
SPR_HEIGHT = 5

function _init()
  game_over = false
  make_cave()
  make_player()
end

function _update()
  if not game_over then
    update_cave()
    update_player()
    check_hit()
  else
    if (btnp(5)) _init()
  end
end

function _draw()
  cls()
  draw_player()
  draw_cave()

  if game_over then
    print("game over!", 44, 44, 7)
    print("your score: " .. player.score, 34, 54, 7)
    print("press ❎ to play again!", 18, 72, 6)
  else
    print("score:" .. player.score, 2, 2, 7)
    print("next speed up:" .. player.next_speed_up, 4, 4, 7)
  end
end

function make_cave()
  cave = {
    min_top = 45,
    max_btm = 85,
    { ["top"] = 5, ["btm"] = 119 }
  }
end

function draw_cave()
  local top_color = 5
  local btm_color = 5

  for i = 1, #cave do
    line(i - 1, 0, i - 1, cave[i].top, top_color)
    line(i - 1, 127, i - 1, cave[i].btm, btm_color)
  end
end

function update_cave()
  --remove the back of the cave
  if (#cave > player.speed) then
    for i = 1, player.speed do
      del(cave, cave[1])
    end
  end

  --add more cave
  while (#cave < 128) do
    local col = {}
    local up = flr(rnd(7) - 3)
    local dwn = flr(rnd(7) - 3)
    col.top = mid(3, cave[#cave].top + up, cave.min_top)
    col.btm = mid(cave.max_btm, cave[#cave].btm + dwn, 124)
    add(cave, col)
  end
end

function make_player()
  player = {
    x = 24,
    y = 60,
    dy = 0,
    rise = 1,
    fall = 2,
    dead = 3,
    speed = 2,
    score = 0,
    gravity = 0.1,
    flap_power = -2,
    flap_cooldown = 0,
    flap_cooldown_max = 2,
    next_speed_up = 1000
  }
end

function draw_player()
  if game_over then
    spr(player.dead, player.x, player.y)
  elseif (player.dy < 0) then
    spr(player.rise, player.x, player.y)
  else
    spr(player.fall, player.x, player.y)
  end
end

function update_player()
  player.dy += player.gravity

  if player.flap_cooldown > 0 then
    player.flap_cooldown -= 1
  end

  if btnp(2) and player.flap_cooldown <= 0 then
    player.dy = player.flap_power
    player.flap_cooldown = player.flap_cooldown_max
    sfx(0)
  end

  player.y += player.dy

  player.score += player.speed

  if player.score >= player.next_speed_up then
    player.speed += 1
    player.next_speed_up += 1000 * player.speed
  end
end

function check_hit()
  for i = player.x, player.x + (SPR_WIDTH - 1) do
    if (cave[i + 1].top > player.y or cave[i + 1].btm < player.y + (SPR_HEIGHT - 1)) then
      game_over = true
      sfx(1)
    end
  end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000088800000888000005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000600877000008770000056600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770007677079006770790056616d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700067776006777760065666500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006660000066600000555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000900900090090000d00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000400000b0500e050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a000025050000001d0501300015050220000a040090300a0300a03009020090200902009010090100901000000000000000000000000000000000000000000000000000000000000000000000000000000000
