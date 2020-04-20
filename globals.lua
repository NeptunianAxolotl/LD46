local globals = {
	TILE_SIZE = 64,
	DIAG = math.sqrt(2),
	INV_DIAG = 1/math.sqrt(2),
	
	PI = math.pi,
	
	BAR_RED = 0.8,
	BAR_GREEN = 0.8,
	BAR_BLUE = 0.8,
	
	BAR_SLEEP_RED = 0,
	BAR_SLEEP_GREEN = 0.5,
	BAR_SLEEP_BLUE = 0.9,
	
	BAR_FOOD_RED = 0,
	BAR_FOOD_GREEN = 0.8,
	BAR_FOOD_BLUE = 0,
	
	BAR_SKILL_RED = 0.6,
	BAR_SKILL_GREEN = 0.8,
	BAR_SKILL_BLUE = 0,
	
	CAM_ACCEL = 7000,
	CAM_SPEED = 1200,
	
	CONSTANT_HUNGER = -0.008,
	CONSTANT_FATIGUE = -0.008,
	
	MOTION_HUNGER = -0.02,
	MOTION_FATIGUE = -0.02,
	
	DRAIN_MULT = 0.4,
	
	PRIORITY_COUNT = 3,
	
	DOUBLE_CLICK_TIME = 0.7,
	
	CAMERA_ROAM_BOUND = 864,
	CAMERA_START_X = -300,
	CAMERA_START_Y = -500,
}

return globals
