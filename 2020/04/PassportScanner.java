/**
 *  ___               __  _ _
 * |   \ __ _ _  _   /  \| | |
 * | |) / _` | || | | () |_  _|
 * |___/\__,_|\_, |  \__/  |_|
 *            |__/
 *
 * "Passport Processing"
 *
 * Challenge:
 *
 * The input file contains objects: each with several key:value pairs.
 * Spaces and/or a single newline separate fields. Empty lines separate
 * objects. For narrative reasons, the `cid` field is optional, but otherwise
 * valid objects require the following keys:
 *
 * - byr
 * - iyr
 * - eyr
 * - hgt
 * - hcl
 * - ecl
 * - pid
 * - cid (optional)
 *
 * Count objects from the input file which meet these requirements.
 *
 * In English:
 * - Read the file into something that can be processed in its entirety
 * - Explode it by /\n{2,}/ to separate objects
 * - Foreach, explode by /\s/ to separate keys
 * - Foreach object, check for required keys.
 *   - Count objects that pass
 * - Return count
*/

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

class PassportScanner {
  public static void main(String[] args) throws FileNotFoundException {
    File passportBatchFile = new File("./sample_batch.txt");
    Scanner passportObjects = new Scanner(passportBatchFile);
    passportObjects.useDelimiter("\n{2,}");

    int i = 0;
    while(passportObjects.hasNext()) {
      String line = passportObjects.next();
      System.out.println(i);
      System.out.println(line);
      i++;
    }
  }
}
