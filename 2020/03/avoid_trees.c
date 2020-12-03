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

#define HEIGHT 323
#define WIDTH 33
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

  printf("You crashed into %d trees on the original slope.\n\n", count);
  // Part One Answer: You crashed into 159 trees.

  //  ___          _     ___
  // | _ \__ _ _ _| |_  |_  )
  // |  _/ _` | '_|  _|  / /
  // |_| \__,_|_|  \__| /___|
  //
  // This time multiple slopes are provided. Run each, capture the number of
  // trees encountered on each, then return the product of the set.
  int slopes[5][3] = {
    /* {Y offset, X offset, number of trees} or "rise over run" */
    {1, 1, 0},
    {1, 3, 0},
    {1, 5, 0},
    {1, 7, 0},
    {2, 1, 0}  /* Yes, down-two. */
  };

  count = 0;

  for (int attempt = 0; attempt < 5; attempt++) {
    for (y = 0; y < HEIGHT; y+= slopes[attempt][0]) {
      if (field[y][x] == '#') {
        count++;
      }

      // The for loop moves us down, this moves us over, then wrap around
      x += slopes[attempt][1];
      x = x % (WIDTH - 2);
    }

    // Save the number of trees we hit on this attempt
    slopes[attempt][2] = count;

    printf("You crashed into %d trees on the %d,%d slope.\n", count, slopes[attempt][0], slopes[attempt][1]);
  }

  // Now that we have each slope, multiply them together.
  int tree_product = slopes[0][2];
  for (int attempt = 1; attempt < 5; attempt++) {
    tree_product *= slopes[attempt][2];
  }

  printf("The product of those numbers is %d\n\n", tree_product);

  return 0;
}
