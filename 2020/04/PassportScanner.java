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
 * Part One answer:
 *   Batch contains 260 passport objects.
 *   Batch contains 222 valid passports.
*/

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.ArrayList;

class PassportScanner {
  public static String[] fieldsRequired = {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"};

  public static void main(String[] args) throws FileNotFoundException {
    // Set up the input file
    File passportBatchFile = new File("./passport_batch.txt");
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
    System.out.println("Batch contains " + passportObjects.size() + " passport objects.");

    // Validate each passport object (String)
    int validPassports = 0;
    for (int i = 0; i < passportObjects.size(); i++) {
      if (checkPassport(passportObjects.get(i))) {
        validPassports++;
      }
    }

    // Report on the total
    System.out.println("Batch contains " + validPassports + " valid passports.");
  }

  /**
   * Take the passport string and figure out if it has all the required fields.
   * @param passport
   * @return boolean is passport valid?
   */
  public static Boolean checkPassport(String passport) {
    // Fields are either space or newline separated
    passport = passport.replaceAll("\\s", "\n");

    // Assume true because that sure seems like a great idea :upside_down_face:
    Boolean valid = true;

    for (String field : PassportScanner.fieldsRequired) {
      if (!passport.contains(field)) {
        valid = false;
      }
    }

    return valid;
  }
}
