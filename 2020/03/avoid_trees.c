//  ___               __ ____
// |   \ __ _ _  _   /  \__ /
// | |) / _` | || | | () |_ \
// |___/\__,_|\_, |  \__/___/
//            |__/
//
// "Toboggan Trajectory"

// Challenge:
// Given a 2D field of dots and hashes, where dots are "open" and hashes are
// "trees," count the number of trees encountered traversing the field on a given
// slope -- right 3 / down 1. The map repeats horizontally but not vertically.

#include <stdio.h>

int main() {
  char field[10][10] = {
    {"..##...##."}, /* X goes across, through one line */
    {".##...##.."},
    {"..##...##."},
    {".##...##.."},
    {"..#......."},
    {"..##...##."},
    {".##...##.."},
    {"..##...##."},
    {".##...##.."},
    {".........."}
    /* Y goes down to the next string in the array */
  };

  // Starting coordinates
  int x = 0, y = 0;

  // Counter of trees I've hit
  int count = 0;

  // Slope is 1 down 3 across and terminates at the bottom but not an edge.
  // So increment on Y (first dimension), not X (second dimension)
  for (y = 0; y < 10; y++) {
    printf("Area [%d][%d] = %c", y, x, field[y][x]);

    if (field[y][x] == '#') {
      printf(" Tree!");
      count++;
    }

    printf("\n");

    // The for loop moves us down, this moves us over, then wrap around
    x += 3;
    x = x % 10;
  }

  printf("\n");

  printf("You crashed into %d trees.", count);

  return 0;
}
