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
#include <stdlib.h>
#include <string.h>

#define HEIGHT 11
#define WIDTH 13
/* @TODO: But how would I determine these automatically? */

int main() {
  char field[HEIGHT][WIDTH];
  char line[WIDTH];
  int i = 0;
  FILE *geography = fopen("forest.txt", "r");

  while(fgets(line, WIDTH, geography)) {
    strcpy(field[i], line);
    /* Strip the ending newline -> replace it with a NULL */
    field[i][strlen(line) - 1] = '\0';
    i++;
  }

  fclose(geography);

  // Starting coordinates
  int x = 0, y = 0;

  // Counter of trees I've hit
  int count = 0;

  // Slope is 1 down 3 across and terminates at the bottom but not an edge.
  // So increment on Y (first dimension), not X (second dimension)
  for (y = 0; y < HEIGHT; y++) {
    printf("Area [%d][%d] = %c", y, x, field[y][x]);

    if (field[y][x] == '#') {
      printf(" Tree!");
      count++;
    }

    printf("\n");

    // The for loop moves us down, this moves us over, then wrap around
    x += 3;
    x = x % (WIDTH - 2);
  }

  printf("\n");

  printf("You crashed into %d trees.", count);

  return 0;
}
