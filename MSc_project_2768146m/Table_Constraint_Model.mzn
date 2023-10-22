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

% visible clue fuction in the 5th column
function int: visible(array[int] of int: arr) =
  let {
    array[1..N] of int: max_up_to = [max(j in 1..i) (arr[j]) | i in 1..N];
  } in
  sum([if i = 1 \/ arr[i] > max_up_to[i-1] then 1 else 0 endif | i in 1..N]);

% 4x4 permutations and visibility clue 
array[1..24, 1..(N+1)] of int: perms_visibility = [| 1,2,3,4, visible([1,2,3,4]) |
                                                    1,2,4,3, visible([1,2,4,3]) |
                                                    1,3,2,4, visible([1,3,2,4]) |
                                                    1,3,4,2, visible([1,3,4,2]) |
                                                    1,4,2,3, visible([1,4,2,3]) |
                                                    1,4,3,2, visible([1,4,3,2]) |
                                                    2,1,3,4, visible([2,1,3,4]) |
                                                    2,1,4,3, visible([2,1,4,3]) |
                                                    2,3,1,4, visible([2,3,1,4]) |
                                                    2,3,4,1, visible([2,3,4,1]) |
                                                    2,4,1,3, visible([2,4,1,3]) |
                                                    2,4,3,1, visible([2,4,3,1]) |
                                                    3,1,2,4, visible([3,1,2,4]) |
                                                    3,1,4,2, visible([3,1,4,2]) |
                                                    3,2,1,4, visible([3,2,1,4]) |
                                                    3,2,4,1, visible([3,2,4,1]) |
                                                    3,4,1,2, visible([3,4,1,2]) |
                                                    3,4,2,1, visible([3,4,2,1]) |
                                                    4,1,2,3, visible([4,1,2,3]) |
                                                    4,1,3,2, visible([4,1,3,2]) |
                                                    4,2,1,3, visible([4,2,1,3]) |
                                                    4,2,3,1, visible([4,2,3,1]) |
                                                    4,3,1,2, visible([4,3,1,2]) |
                                                    4,3,2,1, visible([4,3,2,1]) |];

% Constraints for handling row table 
constraint forall(i in 1..N) (
  (left_clue[i] = 0 \/ table([grid[i, 1], grid[i, 2], grid[i, 3], grid[i, 4], left_clue[i]], perms_visibility)) /\
  (right_clue[i] = 0 \/ table([grid[i, 4], grid[i, 3], grid[i, 2], grid[i, 1], right_clue[i]], perms_visibility)) /\
  all_different(grid[i, 1..N])
);

% Constraints for handling column table 
constraint forall(i in 1..N) (
  (top_clue[i] = 0 \/ table([grid[1, i], grid[2, i], grid[3, i], grid[4, i], top_clue[i]], perms_visibility)) /\
  (bottom_clue[i] = 0 \/ table([grid[4, i], grid[3, i], grid[2, i], grid[1, i], bottom_clue[i]], perms_visibility)) /\
  all_different([grid[j, i] | j in 1..N])
);


% solver solve the constraint
solve satisfy;

% output format to view in puzzle grid
output ["| " ++ join(", ", [show(grid[i,j]) | j in 1..N]) ++ " |\n" | i in 1..N];
