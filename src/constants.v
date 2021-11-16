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

// Character dimensions
parameter CHAR_HEIGHT = 4;
parameter INVADER1_WIDTH = 12;
parameter PLAYER_WIDTH = 13;

// Character bitmaps