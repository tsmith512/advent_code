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
  char field[5][5] = {
    {"..##."},
    {".##.."},
    {"..##."},
    {".##.."},
    {"....."}
  };

  int i, j;

  for (i = 0; i < 5; i++) {
    for (j = 0; j < 5; j++) {
      printf("Area [%d][%d] = %c", i, j, field[i][j]);

      if (field[i][j] == '#') {
        printf(" Tree!");
      }

      printf("\n");
    }
  }

  return 0;
}
