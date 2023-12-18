module snake_game(
    input wire clk,           // Clock signal
    input wire reset,         // Reset signal
    input wire [1:0] dir,     // Direction control (00-up, 01-down, 10-left, 11-right)
    output reg [9:0] snake_x, // Snake head x-coordinate
    output reg [9:0] snake_y, // Snake head y-coordinate
    output reg game_over      // Game over signal
);

// Define the play area size
parameter MAX_WIDTH = 320;
parameter MAX_HEIGHT = 240;

// Define the initial position of the snake
parameter INIT_X = MAX_WIDTH / 2;
parameter INIT_Y = MAX_HEIGHT / 2;

// Speed of the snake movement
parameter SPEED = 1;

// Internal registers to hold the snake's current direction and position
reg [9:0] snake_head_x = INIT_X;
reg [9:0] snake_head_y = INIT_Y;
reg [1:0] current_dir = 2'b00;

// Update the snake's position based on the current direction
always @(posedge clk) begin
    if (reset) begin
        // Reset the snake's position to the center of the screen
        snake_head_x <= INIT_X;
        snake_head_y <= INIT_Y;
        game_over <= 0;
    end else begin
        // Update the direction if a valid control signal is received
        if (dir != current_dir && dir != (current_dir ^ 2'b11)) begin
            current_dir <= dir;
        end

        // Move the snake's head based on the current direction
        case (current_dir)
            2'b00: snake_head_y <= snake_head_y - SPEED; // Up
            2'b01: snake_head_y <= snake_head_y + SPEED; // Down
            2'b10: snake_head_x <= snake_head_x - SPEED; // Left
            2'b11: snake_head_x <= snake_head_x + SPEED; // Right
        endcase

        // Check for collisions with the walls
        if (snake_head_x <= 0 || snake_head_x >= MAX_WIDTH || 
            snake_head_y <= 0 || snake_head_y >= MAX_HEIGHT) begin
            game_over <= 1;
        end
    end
end

// Assign the current head position to output
always @(posedge clk) begin
    if (!game_over) begin
        snake_x <= snake_head_x;
        snake_y <= snake_head_y;
    end
end

endmodule
