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
import java.util.ArrayList;

class PassportScanner {
  public static void main(String[] args) throws FileNotFoundException {
    // Set up the input file
    File passportBatchFile = new File("./sample_batch.txt");
    Scanner passportBatch = new Scanner(passportBatchFile);
    passportBatch.useDelimiter("\n{2,}");

    // Set up array of passport "objects"
    ArrayList<String> passportObjects = new ArrayList<String>();

    // Step through the batch file and pull out individual records
    while(passportBatch.hasNext()) {
      passportObjects.add(passportBatch.next());
    }

    // Close the scanner once we've captured everything
    passportBatch.close();

    // Sample: print one them
    System.out.println("Batch contains " + passportObjects.size() + " passport objects.");
    System.out.println("The first looks like:\n" + passportObjects.get(0));
  }
}
