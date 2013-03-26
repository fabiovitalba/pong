function love.load()
	--Setting Game Window
	windowWidth = 1024
	windowHeight = 480
	success = love.graphics.setMode(windowWidth, windowHeight, false, true, 0)	--( width, height, fullscreen, vsync, fsaa )
	
	--Setting Game Set-Up
	gamestate = "paused"
	
	--Setting Game Field
	startX = 50
	startY = 50
	fieldWidth = windowWidth - 100
	fieldHeight = windowHeight - 100
	grassIMG = love.graphics.newImage("g.jpg")
	
	--Setting Player Images
	player1IMG = love.graphics.newImage("1.png")
	player2IMG = love.graphics.newImage("2.png")
	--Setting up Players Positions
	p1x = 50
	p1y = 50
	p2x = windowWidth - (50 + 24)
	p2y = 50
	
	--Initializing Graphics stuff
	local f = love.graphics.newFont(12)
	love.graphics.setFont(f)
	love.graphics.setColor(0,0,0,255)
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setColor(0,0,0)
	love.graphics.setColorMode("replace")
end

function love.draw()
	--Draw the Field
	love.graphics.rectangle("line", startX, startY, fieldWidth, fieldHeight)
	love.graphics.line(startX+(fieldWidth/2), startY, startX+(fieldWidth/2), startY+fieldHeight)
	
	--Update the Players positions
	love.graphics.setColorMode("replace")
	love.graphics.draw(player1IMG, p1x, p1y)
	love.graphics.draw(player2IMG, p2x, p2y)
	
	--Draw the Instructions
	love.graphics.setColorMode("modulate")
	love.graphics.setColor(0,0,0, 255)
	love.graphics.print("Player 1 uses W and S Keys and Player 2 uses Up and Down Arrow Keys. Start with Space.", 10, 10)
	
	--Check if Game Over
end

function love.update(dt)
	if love.keyboard.isDown("w") then
		--Player 1 goes up
		while ((p1y - 1) > startY) do
			p1y = p1y - 1
		end
	elseif love.keyboard.isDown("s") then
		--Player 1 goes down
		p1y = p1y + 1
	end
	if love.keyboard.isDown("up") then
		--Player 2 goes up
		while ((p2y - 1) > startY) do
			p2y = p2y - 1
		end
	elseif love.keyboard.isDown("down") then
		--Player 2 goes down
		p2y = p2y + 1
	end
end

function love.keypressed(key)
	if key == ' ' then
		--Gamestate = Started
		gamestate = "running"
	elseif key == 'p' then
		--Gamestate = Paused
		gamestate = "paused"
	end
end