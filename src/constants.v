// Game defaults
parameter PLAYER_LIVES = 3;

// VGA display 640x480 at 60Hz
parameter SYNC_H = 96;
parameter BACK_PORCH_H = SYNC_H + 48;
parameter DISPLAY_H = BACK_PORCH_H + 640;
parameter FRONT_PORCH_H = DISPLAY_H + 16;
parameter MAX_H = 799;

parameter SYNC_V = 2;
parameter BACK_PORCH_V = SYNC_V + 33;
parameter DISPLAY_V = BACK_PORCH_V + 480;
parameter FRONT_PORCH_V = DISPLAY_V + 10;
parameter MAX_V = 524;

parameter PIXEL_FREQ = 25_000_000; // Hz

// Character dimensions
parameter CHAR_HEIGHT = 4;
parameter INVADER1_WIDTH = 12;
parameter PLAYER_WIDTH = 13;

// Character bitmaps