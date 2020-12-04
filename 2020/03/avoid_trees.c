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

#define MAXHEIGHT 500
#define MAXWIDTH 100
/* @TODO: These are maxes, can I allocate `field` only as big as it needs to be? */

int main() {
  // Variables for the forest
  char field[MAXHEIGHT][MAXWIDTH];
  int forest_width = 0, forest_height = 0;

  // For processing the file
  char line[MAXWIDTH];
  FILE *geography = fopen("forest.txt", "r");

  while(fgets(line, MAXWIDTH, geography)) {
    // Plant the forest, one row at a time, using the current height as index
    strcpy(field[forest_height], line);

    // On the first line, check how wide the forest patch is
    if (forest_height == 0) {
      forest_width = strnlen(line, MAXWIDTH);
      printf("Forest Width: %d\n", forest_width);
    }

    forest_height++;
  }

  // We need total height, not zero-based index of the last line.
  forest_height += 1;
  printf("Forest Height: %d\n\n", forest_height);

  fclose(geography);

  // Starting coordinates
  int x = 0, y = 0;

  // Counter of trees I've hit
  int count = 0;

  // Slope is 1 down 3 across and terminates at the bottom but not an edge.
  // So increment on Y (first dimension), not X (second dimension)
  for (y = 0; y < forest_height; y++) {
    if (field[y][x] == '#') {
      count++;
    }

    // The for loop moves us down, this moves us over, then wrap around
    x += 3;
    x = x % (forest_width - 1);
  }

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

  for (int attempt = 0; attempt < 5; attempt++) {
    count = 0;
    x = 0;

    for (y = 0; y < forest_height; y+= slopes[attempt][0]) {
      if (field[y][x] == '#') {
        count++;
      }

      // The for loop moves us down, this moves us over, then wrap around
      x += slopes[attempt][1];
      x = x % (forest_width - 1);
    }

    // Save the number of trees we hit on this attempt
    slopes[attempt][2] = count;

    printf("You crashed into %d trees on the %d,%d slope.\n", count, slopes[attempt][0], slopes[attempt][1]);
  }

  // Now that we have each slope, multiply them together.
  uint64_t tree_product = slopes[0][2];
  for (int attempt = 1; attempt < 5; attempt++) {
    tree_product *= slopes[attempt][2];
  }

  printf("The product of those numbers is %lu\n\n", tree_product);
  // Part Two answer:
  // You crashed into 86 trees on the 1,1 slope.
  // You crashed into 159 trees on the 1,3 slope.
  // You crashed into 97 trees on the 1,5 slope.
  // You crashed into 88 trees on the 1,7 slope.
  // You crashed into 55 trees on the 2,1 slope.
  // The product of those numbers is 6419669520

  return 0;
}
