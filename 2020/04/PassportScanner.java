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
 *
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * Field-level validation within each object. ("range" is inclusive)
 * - cid remains optional
 * - byr: /\d{4}/ range 1920 - 2002
 * - iyr: /\d{4}/ range 2010 - 2020
 * - eyr: /\d{4}/ range 2020 - 2030
 * - hgt: /\d{2,3}(cm|in)/
 *        for "cm" suffix: range 150 - 193
 *        for "in" suffix: range 59 - 76
 * - hcl: /#[0-9a-f]{6}/
 * - ecl: /(amb|blu|brn|gry|grn|hzl|oth)
 * - pid: /\d{9}/
 *
 * Count objects from the input file which have required fields with valid values.
 *
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.ArrayList;

class PassportScanner {
  public static String[] fieldsRequired = {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"};

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
    System.out.println("Batch contains " + passportObjects.size() + " passport objects.");

    // Validate each passport object (String)
    int validPassports = 0;
    for (int i = 0; i < passportObjects.size(); i++) {
      System.out.println("Checking Passport #" + i);
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
    String[] fields = passport.split("\\s");

    // Assume true because that sure seems like a great idea :upside_down_face:
    Boolean valid = true;

    // Keeping logic from Part 1, ensure all required fields are present.
    for (String field : PassportScanner.fieldsRequired) {
      if (!passport.contains(field)) {
        System.out.println("Passport is missing required fields.");
        return false;
      }
    }

    for (String field : fields) {
      String[] kv = field.split(":");

      switch (kv[0]) {
        case "byr":
          System.out.println("Birth Year: " + kv[1] + " -- " + checkRange(1920, Integer.valueOf(kv[1]).intValue(), 2002).toString());
          valid = checkRange(1920, Integer.valueOf(kv[1]).intValue(), 2002);
          break;
        case "iyr":
          System.out.println("Issue Year: " + kv[1] + " -- " + checkRange(2010, Integer.valueOf(kv[1]).intValue(), 2020).toString());
          valid = checkRange(2010, Integer.valueOf(kv[1]).intValue(), 2020);
          break;
        case "eyr":
          System.out.println("Expiration Year: " + kv[1] + " -- " + checkRange(2020, Integer.valueOf(kv[1]).intValue(), 2030).toString());
          valid = checkRange(2020, Integer.valueOf(kv[1]).intValue(), 2030);
          break;
      }
    }
    System.out.println("\n");
    return valid;
  }

  public static Boolean checkRange(int low, int check, int high) {
    return ((low - 1) < check) && (check < (high + 1));
  }
}
