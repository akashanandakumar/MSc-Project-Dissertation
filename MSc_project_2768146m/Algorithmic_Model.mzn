include "globals.mzn";  

% size of the puzzle grid
int: N = 4;  

% Clues for the skyscraper puzzle on all four direction
array[1..N] of int: top_clue = [0,0,0,0];
array[1..N] of int: bottom_clue = [2,1,0,0];
array[1..N] of int: left_clue = [0,4,2,0];
array[1..N] of int: right_clue = [3,0,0,0];


% variable 2D array declaration
array[1..N, 1..N] of var 1..N: grid;


% constraint to make all values in the row and column are distinct
constraint forall(i in 1..N) (
    alldifferent(row(grid, i)) /\ 
    alldifferent(col(grid, i))
);


% constraint for increasing and decreasing values in row and column
constraint
    forall(i in 1..N)(
        if top_clue[i] = N then 
            increasing([grid[j,i] | j in 1..N]) endif /\
        if bottom_clue[i] = N then 
            decreasing([grid[j,i] | j in 1..N]) endif /\
        if left_clue[i] = N then 
            increasing([grid[i,j] | j in 1..N]) endif /\
        if right_clue[i] = N then 
            decreasing([grid[i,j] | j in 1..N]) endif /\
        if top_clue[i] = 1 then 
            grid[1,i] = N endif /\
        if bottom_clue[i] = 1 then 
            grid[N,i] = N endif /\
        if left_clue[i] = 1 then 
            grid[i,1] = N endif /\
        if right_clue[i] = 1 then 
            grid[i,N] = N endif
    );
    
% constraint for handling visibility 
constraint
    forall(i in 1..N)(
        (top_clue[i] = 0 \/ sum(j in 1..N-1)(
            bool2int(grid[j,i] < grid[j+1,i] /\ forall(k in 1..j)(grid[k,i] <= grid[j+1,i]))
        ) = top_clue[i] - 1) /\
        (bottom_clue[i] = 0 \/ sum(j in 1..N-1)(
            bool2int(grid[j+1,i] < grid[j,i] /\ forall(k in j+1..N)(grid[k,i] <= grid[j,i]))
        ) = bottom_clue[i] - 1) /\
        (left_clue[i] = 0 \/ sum(j in 1..N-1)(
            bool2int(grid[i,j] < grid[i,j+1] /\ forall(k in 1..j)(grid[i,k] <= grid[i,j+1]))
        ) = left_clue[i] - 1) /\
        (right_clue[i] = 0 \/ sum(j in 1..N-1)(
            bool2int(grid[i,j+1] < grid[i,j] /\ forall(k in j+1..N)(grid[i,k] <= grid[i,j]))
        ) = right_clue[i] - 1)
    );

% solver solve the constraint
solve satisfy;

% output format to view in puzzle grid
output ["| " ++ join(", ", [show(grid[i,j]) | j in 1..N]) ++ " |\n" | i in 1..N];
