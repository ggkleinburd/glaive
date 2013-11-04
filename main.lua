love._openConsole()
debug = false

require('splash')
require('game')
--Camera = require "camera"
--local cam = Camera()
print("fuck")
function love.load()
	--sets full screen
--	love.graphics.setMode(0, 0, true, v, f)
--	love.graphics.setMode(love.graphics.getWidth(),love.graphics.getHeight(), true, v, f)
	-- Load images (global assets)
	img_fn = {"bullet","enemy","player","tits","bg1","ventrun","bg2","bg3"}
	imgs = {}
	for _,v in ipairs(img_fn) do
		imgs[v]=love.graphics.newImage("assets/"..v..".gif")
	end
	
	-- Set filter to nearest
	for _,v in pairs(imgs) do
		v:setFilter("nearest","nearest")
	end
	
	-- Play music and loop it.
	music = love.audio.newSource( "assets/music.ogg" , "stream" )
	music:setLooping(true)
	love.audio.play(music)
	
	-- load shoot sound
	shoot = love.audio.newSource( "assets/shoot.ogg" , "static" )
	
	-- Initialize font, and set it.
	font = love.graphics.newFont("assets/font.ttf",14*scale) --multiply almost everything by the scale
	love.graphics.setFont(font) --sets font to the declared font variable
	
	-- define colors (global assets)
	bgcolor = {r=100,g=100,b=100}
	fontcolor = {r=46,g=115,b=46}
	
	-- initial state
	state = "splash" --use later on
	
	--load the splash
	splash.load()
	
	game.load()

end

function love.draw() --use what you load
-- Set color
	love.graphics.setColor(bgcolor.r,bgcolor.g,bgcolor.b)
	-- Draw rectangle for background
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight()) --draws rectangle to window dimensions
	-- Return the color back to normal.
	love.graphics.setColor(255,255,255)
	
	if state=="splash" then
		splash.draw()
	elseif state=="game" then
		game.draw()
		
	end
	
end

function love.update(dt)

	-- Call the state's update function
	if state == "splash" then
		splash.update(dt)
	elseif state == "game" then
		game.update(dt)
		
		
  end
  
end
function love.keypressed(key)
	--Call the state's keypressed function
		if state == "splash" then 
			splash.keypressed(key)
		elseif state == "game" then
			game.keypressed(key)
	end
	if key == "`" then
		debug = not debug
	end
end