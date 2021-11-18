// Game defaults
parameter PLAYER_LIVES = 3;

// VGA display 640x480 at 60Hz
parameter DISPLAY_H = 640;
parameter SYNC_START_H = DISPLAY_H + 16;
parameter SYNC_END_H = SYNC_START_H + 48;
parameter END_H = 799;

parameter DISPLAY_V = 480;
parameter SYNC_START_V = DISPLAY_V + 10;
parameter SYNC_END_V = SYNC_START_V + 33;
parameter END_V = 524;

parameter PIXEL_FREQ = 25_000_000; // Hz
parameter TOTAL_PIXELS = DISPLAY_V * DISPLAY_H - 1;

// Characters
parameter CHAR_HEIGHT = 8;

// Player values
parameter PLAYER_SCALE = 2;
parameter PLAYER_WIDTH = 13;
parameter PLAYER_START_X = (DISPLAY_H / 2) - (PLAYER_WIDTH / 2);
parameter PLAYER_START_Y = DISPLAY_V - CHAR_HEIGHT;

// Invader values
parameter INVADER_SCALE = 2;
parameter INVADER_WIDTH = 12;
parameter INVADER_PADDING = 8;
parameter INVADERS_HORZ_NUM = 11;
parameter INVADERS_VERT_NUM = 5;
parameter INVADERS_LINE_HEIGHT = CHAR_HEIGHT + INVADER_PADDING;
parameter INVADERS_LINE_DISP = 10;
parameter INVADERS_WIDTH_TOT = (INVADERS_HORZ_NUM * INVADER_WIDTH) 
										+ ((INVADERS_HORZ_NUM - 1) * INVADER_PADDING);
parameter INVADERS_HEIGHT_TOT = (INVADERS_VERT_NUM * CHAR_HEIGHT) 
										+ ((INVADERS_VERT_NUM - 1) * INVADER_PADDING);
parameter INVADERS_START_X = (DISPLAY_H / 2) - (INVADERS_WIDTH_TOT / 2);
parameter INVADERS_START_Y = DISPLAY_V - CHAR_HEIGHT - INVADERS_HEIGHT_TOT
										- (INVADERS_LINE_HEIGHT * INVADERS_LINE_DISP);

// 8-bit colors
parameter BLACK = 8'b00000000;
parameter WHITE = 8'b11111111;
parameter GREEN = 8'b00011100;

// Mem files
parameter PLAYER_FILE = "player.mem";
parameter INVADER1_FILE = "invader1.mem";