// Game defaults
parameter PLAYER_LIVES = 3;

// VGA display 640x480 at 60Hz
parameter RES_H = 640; // Horizontal display width
parameter SYNC_H = 96; // Horizontal sync width
parameter FP_H = 16; // Horizontal front porch width
parameter BP_H = 48; // Horizontal back porch width
parameter signed START_H = 0 - FP_H - SYNC_H - BP_H;
parameter signed SYNC_START_H = START_H + FP_H;
parameter signed SYNC_END_H = SYNC_START_H + SYNC_H;
parameter signed ACTIVE_START_H = 0;
parameter signed END_H = RES_H - 1;

parameter RES_V = 480; // Vertical display width
parameter SYNC_V = 2; // Vertical sync width
parameter FP_V = 10; // Vertical front porch width
parameter BP_V = 33; // Vertical back porch width
parameter signed START_V = 0 - FP_V - SYNC_V - BP_V;
parameter signed SYNC_START_V = START_V + FP_V;
parameter signed SYNC_END_V = SYNC_START_V + SYNC_V;
parameter signed ACTIVE_START_V = 0;
parameter signed END_V = RES_V - 1;

parameter PIXEL_FREQ = 25_000_000; // Hz
parameter TOTAL_PIXELS = RES_V * RES_H - 1;

// 8-bit colors
parameter BLACK = 8'b00000000;
parameter WHITE = 8'b11111111;
parameter GREEN = 8'b00111000;
parameter BLUE = 8'b11000000;

// Sprite values
parameter SPRITE_HEIGHT = 8;
parameter SPRITE_WIDTH = 13;
parameter SPRITE_SIZE = SPRITE_HEIGHT * SPRITE_WIDTH;
parameter SPRITE_SCALE = 2;
parameter SPRITE_HEIGHT_SCALED = SPRITE_HEIGHT * SPRITE_SCALE;
parameter SPRITE_WIDTH_SCALED = SPRITE_WIDTH * SPRITE_SCALE;

// Sprite enums
parameter PLAYER = 0;
parameter INVADER1 = 1;

// Player values
parameter PLAYER_START_X = (RES_H / 2) - (SPRITE_WIDTH_SCALED / 2);
parameter PLAYER_START_Y = RES_V - (SPRITE_HEIGHT_SCALED);
parameter PLAYER_STEP = 10;

// Invader values
parameter INVADER_PADDING = 8;
parameter INVADERS_H = 11;
parameter INVADERS_V = 5;
parameter INVADERS_OFFSET_V = SPRITE_HEIGHT_SCALED + INVADER_PADDING;
parameter INVADERS_OFFSET_H = SPRITE_WIDTH_SCALED + INVADER_PADDING;
parameter INVADERS_LINE_DISP = 10;
parameter INVADERS_WIDTH_TOT = (INVADERS_H * SPRITE_WIDTH_SCALED) 
										+ ((INVADERS_H - 1) * INVADER_PADDING);
parameter INVADERS_HEIGHT_TOT = (INVADERS_V * SPRITE_HEIGHT_SCALED) 
										+ ((INVADERS_V - 1) * INVADER_PADDING);
parameter INVADERS_START_X = (RES_H / 2) - (INVADERS_WIDTH_TOT / 2);
parameter INVADERS_START_Y = RES_V - SPRITE_HEIGHT_SCALED - INVADERS_HEIGHT_TOT
										- (INVADERS_OFFSET_V * INVADERS_LINE_DISP);
parameter INVADERS_STEP = 1;

// Projectile values
parameter PROJ_WIDTH = 1;
parameter PROJ_HEIGHT = 2;
parameter PROJ_WIDTH_SCALED = PROJ_WIDTH * SPRITE_SCALE;
parameter PROJ_HEIGHT_SCALED = PROJ_HEIGHT * SPRITE_SCALE;
parameter LASER_STEP = 1;
parameter MISSILE_STEP = 1;