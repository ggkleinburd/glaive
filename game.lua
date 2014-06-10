--Things tagged CHANGE THIS may be the cause of problems
game = {} --initialization
Camera = require "camera"
--require("AnAL")
require ('level_1')
local anim = require 'anim'
	local cam = Camera(0,0)
	cam:zoom(.5)
local image, playerRun,map


function game.load()
printf= "hit load"
--background initialization
	game.clock = 0 -- game clock timer starts at 0, time since game was loaded, used for timing possibly, used for background here.
	
	--enemy initialization
	game.enemy_size = imgs["enemy"]:getWidth()	--size of enemy for collision purposes is just image size
	game.enemies = {} --table of enemies
	game.enemy_dt = 0 --current time
	game.enemy_rate = 2	--if it's greater than 2 reset enemy
	
	--player initialization
	game.player_width = 47	--sets player width(Just the size of the sprite)	--imgs["player"]:getWidth()
	game.player_height = 40		--sets the player height(Just the size of the sprite)	--imgs["player"]:getHeight()
	game.playerx = 		(1280/2)*sscale -- spawns the player in the middle of the x axis 
	game.playery = 	imgs["bg1"]:getHeight()*scale - (game.player_height+1*scale) --Spawns the player at the bottom of a preset image CHANGE THIS					--(720-40)*sscale	
	print(playery)
	--(imgs["bg1"]:getHeight()*scale)-game.player_height/2*scale --scale
	
	-- bullet intialization
	game.ammo = 10
	game.recharge_dt = 0
	game.recharge_rate = 1
	game.bullet_size = imgs["bullet"]:getWidth()
	game.bullets = {}
	
	-- info init
	game.score = 0
	cameraX = 0
	cameraY=0
	offset = 40
	-- camera init
	-- camera.load

	 -- Load the animation source. as a variable called "img" locally
    playerSheet  = love.graphics.newImage("assets/ventrun.gif")		--playerRun = the sheet
    local image = anim.newGrid(47, 40, playerSheet:getWidth(), playerSheet:getHeight())
	playerRun = anim.newAnimation(image('1-10',1), 0.1)
   
   --//////////////////TILED BACKGROUND BOLLOCKS\\\\\\\\\\\\\\\\\\\\\\
	tile = {}
	map = {}
	for i=1,3 do --change the second number to number of tiles
		map[i] = love.graphics.newImage( "map"..i..".gif")
	end
	--\\\\\\\\\\\\\\\TILE BULLSHIT//////////////////////////////////////
	love.graphics.setNewFont(12)	--Why is this here?
	
	--map variables 
   map_w = 6
   map_h = 6
   map_x = 1	--tile currently being drawn
   map_y = 1	--as in coordinate in the table of tiles
   map_offset_x = 30	--offset for map being drawn
   map_offset_y = 30	--offsec for map being drawn
   map_display_w = 14	--max tiles to draw
   map_display_h = 10	--max tiles to draw
   tile_w = 128
   tile_h = 128
   tileNum = 1
   
   
   
   -- Create animation. using local variable "img"
 --  anim = newAnimation(img, 47, 40, 0.1, 0)
    -- Mode constants:
   -- loop
   -- bounce
   -- once
   
   -- Sets the mode to "bounce"
 --  anim:setMode("loop")
	
	
end

function game.draw()
cam:attach()
-- Draw moving background 5 times horizontally and 6 times vertically

	level_1.map() 


--	end




	--Draw enemies
	for _,v in ipairs(game.enemies) do
		love.graphics.draw(imgs["enemy"],
							v.x,v.y,
							0,scale,scale,
							game.enemy_size/2,game.enemy_size/2)--set the origin for the image. So instead of origin being in the upper left hand corner, it's in the center, so the image is offset
		if debug then love.graphics.circle("line",v.x,v.y, game.enemy_size/2*scale) end
		end

	--Draw player
--	love.graphics.draw(imgs["player"],
--						game.playerx, game.playery, 
--						0, bgscale, bgscale, 
--						game.player_width/2, game.player_height/2)
	if debug then
		love.graphics.circle("line", game.playerx, game.playery, game.player_size/2*scale) 
	end
		
		-- Draw game.bullets
		for _,v in ipairs(game.bullets) do
		love.graphics.draw(imgs["bullet"],
							v.x,v.y,
							0,scale,scale,
							game.bullet_size/2,game.bullet_size/2)
		if debug then love.graphics.circle("line",v.x,v.y,game.bullet_size/2*scale) end
	end
		
	-- Draw game info
	love.graphics.setColor(fontcolor.r,fontcolor.g,fontcolor.b)
	love.graphics.printf(
	"score:" ..game.score..
	" ammo:" ..game.ammo, 0,0,love.graphics.getWidth(),"center")
	
	if debug then love.graphics.print(
	"enemies: "..#game.enemies..
	"\nbullets:"..#game.bullets..
	"\nenemy_rate:"..game.enemy_rate..
	"\nFPS:"..love.timer.getFPS(),
	0,14*scale) end
	love.graphics.setColor(255,255,255)
		
		playerRun:draw(image, game.playerx, game.playery, 0,bgscale*sscale,bgscale*sscale,47/2,40/2)
	--Draw camera
	
	-- - (game.player_width/2*sscale)
	-- - (game.player_height/2*sscale)

	 -- Draw the animation at (100, 100).
--	anim:draw(game.playerx/10, game.playery/10, 0, 5,5) 
	print("vent playerx is " .. game.playerx)
	print("vent playery is " .. game.playery)
     
	 
	 --game.playerx, game.playery)
	 
	cam:detach()
end

--Distance formula.
	function game.dist(x1,y1,x2,y2)
		return math.sqrt( (x1-x2)^2 + (y1 - y2) ^2 )
	end

function game.update(dt)
	--clock for background
	game.clock = game.clock + dt
	
	--Update game.enemies
	game.enemy_dt = game.enemy_dt + dt
	
	--Enemy spawn
	if game.enemy_dt > game.enemy_rate then --if the time elapsed is greater than 2 seconds
		game.enemy_dt = game.enemy_dt - game.enemy_rate --subtract enemy rate from delta time
		game.enemy_rate = game.enemy_rate - 0.01 * game.enemy_rate --modify enemy rate, subtracts a hundreth from rate
		local enemy = {} --local variable for enemy object
		enemy.y = math.random((8)*scale,(192-8)*scale) --the 8's are half of the enemy size as to make sure they do not appear partly off screen
		enemy.x = -game.enemy_size --starts just off screen
		table.insert(game.enemies, enemy)
	end
	
		--update enemy
		for ei, ev in ipairs(game.enemies) do
			ev.x = ev.x + 70*dt*scale
			if ev.x > 256*scale then
				table.remove(game.enemies,ei)
			end
		--If a player gets too close to enemy
			if game.dist(game.playerx, game.playery, ev.x, ev.y) < (12+8)*scale then --half of enemy size and half of player size sends to splash if distance is hit
				splash.load()
				state="splash"
			end
		end
		
		--Update player movement
		if love.keyboard.isDown("down") then
			game.playery = game.playery + 100*dt*scale
		end
		if love.keyboard.isDown("up") then
			game.playery = game.playery - 100*dt*scale
		end
		
		if love.keyboard.isDown("left") then
			game.playerx = game.playerx -100*dt*scale
		end
		if love.keyboard.isDown("right") then
			game.playerx = game.playerx + 100*dt*scale
		end
		-- Keep the player on the map
		if game.playerx > imgs["bg1"]:getWidth() * bgscale -(47/2)then
			game.playerx = imgs["bg1"]:getWidth() * bgscale - (47/2)
		end
		if game.playerx < 0+(47/2) then
		game.playerx = 0+(47/2)
		end
		if game.playery > imgs["bg1"]:getHeight() * bgscale -(40/2*scale*sscale)then
			game.playery = imgs["bg1"]:getHeight() * bgscale - (40/2*scale*sscale)
		end
		if game.playery < 0+(40/2*scale*sscale) then
		game.playery = 0+(40/2*scale*sscale)
		end
		
		--Update bullets
		for bi,bv in ipairs(game.bullets) do
			bv.x=bv.x  - 100*dt*scale
			if bv.x < 0 then
				table.remove(game.bullets,bi)
			end
		--Update Bullets with game.enemies
		for ei,ev in ipairs(game.enemies) do
			if game.dist(bv.x,bv.y,ev.x,ev.y) < (2+8)*scale then
				game.score = game.score + 100
				table.remove(game.enemies,ei)
				table.remove(game.bullets,bi)
			end
		end
	end
	
	--Update player amunition
	game.recharge_dt = game.recharge_dt + dt
	if game.recharge_dt > game.recharge_rate then
		game.recharge_dt = game.recharge_dt - game.recharge_rate
		game.ammo = game.ammo + 1
		if game.ammo > 10 then
			game.ammo = 10
		end
	end
	--//////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\--
	--////////////////CAMERA STUFF\\\\\\\\\\\\\\\\\\\--
	--\\\\\\\\\\\\\\\\\\\\\\/////////////////////////--
	
	-- If player is in a small bounded box
	print("at cameras")
	if (game.playerx-640 * sscale) <= 0 and (game.playerx + 640 * sscale) >= imgs["bg1"]:getWidth()*scale and (game.playery - 360 * sscale) <=0 and (game.playery + 360 * sscale) >= imgs["bg1"]:getHeight()*scale then
	
		print("small box")
		cam:lookAt(imgs["bg1"]:getWidth()/2*scale,imgs["bg1"]:getHeight()/2*scale)
	
	
	
	-- If player os in a horizontally bound tube .vertically tall.
	elseif (game.playerx-640 * sscale) <= 0 and (game.playerx + 640 * sscale) >= imgs["bg1"]:getWidth()*scale then	 
		print("horizontally bound")
		if (game.playery - 360 * sscale) <= 0 then
			print("1")
			cam:lookAt(imgs["bg1"]:getWidth()/2*scale,360 * sscale)
			
		elseif (game.playery + 360 * sscale) >= (imgs["bg1"]:getHeight()*scale) then
			print("2")
			cam:lookAt(imgs["bg1"]:getWidth()/2*scale,(imgs["bg1"]:getHeight()*scale - 360 * sscale * sscale))
		
		elseif (game.playery - 360 * sscale) > 0 and (game.playery + 360 * sscale) < imgs["bg1"]:getHeight()*scale then
			print("3")
			cam:lookAt(game.playerx, (game.playery-offset*scale)) 
		end
	
		
	-- If a player is in a vertically bound tube .horizontally long.
	elseif (game.playery - 360 * sscale)  <= 0 and (game.playery + 360 * sscale) >= imgs["bg1"]:getWidth()*scale then
		print("vertically bound")
		-- If player is half a screen or less from the left edge of the screen set the camera to half a screen from the left
		if (game.playerx - 640 * sscale )* scale <= 0 then
			print("1 vert")
			cam:lookAt(640 * sscale*scale, imgs["bg1"]:getHeight()/2*scale)
		
		elseif (game.playerx + 640 * sscale)*scale >= imgs["bg1"]:getWidth()*scale then
			print("2vert")
			cam:lookAt((imgs["bg1"]:getWidth()-640 * sscale)*scale,imgs["bg1"]:getHeight()/2*scale)
		
		elseif (game.playerx - 640 * sscale)*scale > 0 and (game.playerx + 640 * sscale) * scale < imgs["bg1"]:getWidth()*scale then
			print("3vert")
			cam:lookAt(game.playerx * scale, game.playerx * scale)
		end
	
	
	--If player is not bound on x or y axis
	else 
		print("hit this one")
			if(game.playery - 360 * sscale)  <=0 then
				print("1")
				cameraY=360 * sscale
			
			
			elseif(game.playery +360 * sscale) >= imgs["bg1"]:getHeight()*scale then
				print("2")
				print("camera y is" .. cameraY)
				print("getHeight is" .. imgs["bg1"]:getHeight()*scale)
				cameraY=(imgs["bg1"]:getHeight()* scale - 360 * sscale) 
			
			elseif(game.playery +360 * sscale) < imgs["bg1"]:getHeight()*scale and (game.playery-360 * sscale) > 0 then
			print("3")
				cameraY=game.playery
				print(game.playery)
				print(cameraY)
			end
			-- set y coordinate
			if(game.playerx - 640 * sscale)  <=0 then
				print("x 1")
				cameraX=640 * sscale
			
			elseif(game.playerx +640 * sscale) >= imgs["bg1"]:getWidth()*scale then
				print("x 2")
				cameraX=(imgs["bg1"]:getWidth() * scale -640 * sscale)
			
			elseif(game.playerx +640 * sscale) < imgs["bg1"]:getWidth()*scale and (game.playerx-640 * sscale) > 0 then
				print("x 3")
				cameraX=game.playerx
			end
			
			
			
			cam:lookAt(cameraX,cameraY)
			
		
	end
	
	--print("cam is " .. cameraX)
--	cam:lookAt(game.playerx, game.playery)
	--Updates the animation. (Enables frame changes)
	--FOCUS CAMERA ONLY ON PLAYER
--	cam:lookAt(game.playerx, game.playery)


--	anim:update(dt) 
	playerRun:update(dt)
	
	end
	
	
	
--	if imgs["bg1"]:getHeight()  <= playery+100 then
--	cam:lookAt(game.playerx, game.playery) - imgs["bg1"]:getHeight(),game.playery)
	




function game.keypressed(key)
--Shoot a bullet
	if key == " " and game.ammo > 0 then
		love.audio.play(shoot)
		game.ammo = game.ammo - 1
		local bullet = {}
		bullet.x = game.playerx
		bullet.y = game.playery
		table.insert(game.bullets,bullet)
	end


end


function game.draw_map()
	for y = 1, map_display_h do
		for x = 1, map_display_w do
		
			love.graphics.draw(
				title[map[y+map_y][x+map_x]],
				(x*tile_w_+map_offset_x),
				(y*tile_h+map_offset_y) 
				)
		end
	end
end





function game.tiletest()
for y = 0, map_display_h do
		for x = 0, map_display_w do
		
			love.graphics.draw(
				map[tileNum],
				(x*tile_w+map_offset_x),
				(y*tile_h+map_offset_y) 
				)
				tileNum = tileNum + 1
				if tileNum==4 then tileNum = 1 end
		end
	end
end






