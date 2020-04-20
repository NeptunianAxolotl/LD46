
local function UpdateCamera(dt, cameraX, cameraY, camSpeedX, camSpeedY)
	local xAccel, yAccel = false, false
	if (love.keyboard.isDown("a") or love.keyboard.isDown("left")) and cameraX > -GLOBAL.CAMERA_ROAM_BOUND then
		camSpeedX = camSpeedX - dt*GLOBAL.CAM_ACCEL
		xAccel = true
	elseif (love.keyboard.isDown("d") or love.keyboard.isDown("right")) and cameraX < GLOBAL.CAMERA_ROAM_BOUND then
		camSpeedX = camSpeedX + dt*GLOBAL.CAM_ACCEL
		xAccel = true
	end
	
	if (love.keyboard.isDown("w") or love.keyboard.isDown("up")) and cameraY > -GLOBAL.CAMERA_ROAM_BOUND then
		camSpeedY = camSpeedY - dt*GLOBAL.CAM_ACCEL
		yAccel = true
	elseif (love.keyboard.isDown("s") or love.keyboard.isDown("down")) and cameraY < GLOBAL.CAMERA_ROAM_BOUND then
		camSpeedY = camSpeedY + dt*GLOBAL.CAM_ACCEL
		yAccel = true
	end
	
	if camSpeedX ~= 0 then
		if camSpeedX < 0 then
			if camSpeedX < -GLOBAL.CAM_SPEED then
				camSpeedX = -GLOBAL.CAM_SPEED
			end
			if not xAccel then
				camSpeedX = camSpeedX + dt*GLOBAL.CAM_ACCEL
				if camSpeedX > 0 then
					camSpeedX = 0
				end
			end
		else
			if camSpeedX > GLOBAL.CAM_SPEED then
				camSpeedX = GLOBAL.CAM_SPEED
			end
			if not xAccel then
				camSpeedX = camSpeedX - dt*GLOBAL.CAM_ACCEL
				if camSpeedX < 0 then
					camSpeedX = 0
				end
			end
		end
		cameraX = cameraX + dt*camSpeedX
	end
	
	if camSpeedY ~= 0 then
		if camSpeedY < 0 then
			if camSpeedY < -GLOBAL.CAM_SPEED then
				camSpeedY = -GLOBAL.CAM_SPEED
			end
			if not yAccel then
				camSpeedY = camSpeedY + dt*GLOBAL.CAM_ACCEL
				if camSpeedY > 0 then
					camSpeedY = 0
				end
			end
		else
			if camSpeedY > GLOBAL.CAM_SPEED then
				camSpeedY = GLOBAL.CAM_SPEED
			end
			if not yAccel then
				camSpeedY = camSpeedY - dt*GLOBAL.CAM_ACCEL
				if camSpeedY < 0 then
					camSpeedY = 0
				end
			end
		end
		cameraY = cameraY + dt*camSpeedY
	end
	
	return cameraX, cameraY, camSpeedX, camSpeedY
end

return {
	UpdateCamera = UpdateCamera,
}
