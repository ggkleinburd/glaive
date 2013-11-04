level_1 = {}

function level_1.map()

	img_level_1_map = {"bg1","bg2","bg3","bg4","bg5","bg6"}
	imgs_map = {}
	for _,v in ipairs(img_level_1_map) do
		imgs_map[v]=love.graphics.newImage("assets/level_1/"..v..".gif")
	end
	currentBgTile = 1
	for var1=1, 2 do
		for var2=1,3 do
			print (currentBgTile)
			love.graphics.draw(imgs_map["bg"..currentBgTile],
			(var2-1)*512*bgscale,
			(var1-1)*384*bgscale,
			0,bgscale,
			bgscale)
								
			print((var2-1)*512)
			print((var1-1)*512)
			print("AT DRAWZ")
								
				--512*bgscale				
			currentBgTile = currentBgTile+ 1
		end
	
	end


end