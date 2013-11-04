splash = {}	--initialization

function splash.load()

splash.dt_temp=0

end

function splash.draw()
--
love.graphics.draw(imgs["tits"],56*scale,(splash.dt_temp-1)*4*scale,0,scale,scale) --will start off screen, as dt increases it will move down last 0 is rotation
  love.graphics.setColor(fontcolor.r,fontcolor.g,fontcolor.b)
  -- Show after 2.5 seconds
  if splash.dt_temp == 1 then 
    love.graphics.printf("Press Start",
      0,80*scale,love.graphics.getWidth(),"center") 
  end
  
  --If previous game
	if game.score ~= 0 then
		love.graphics.printf("Score:"..game.score,40*scale,150*scale,150*scale,"center")
	end
  
  
  -- Reset the color
  love.graphics.setColor(255,255,255) --resetting color is important
  
end

function splash.update(dt) --delta time
	--update dt_temp
	splash.dt_temp = splash.dt_temp + dt
	--wait 2.5 seconds, then stop in place.
	if splash.dt_temp > 1 then
		splash.dt_temp=1
	end
end

function splash.keypressed(key)
	--Change to game state and init game
	state = "game"
	game.load()
end


