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
 * Part Two answer:
 *   Batch contains 140 valid passports.
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.ArrayList;
import java.util.Arrays;

class PassportScanner {
  public static String[] fieldsRequired = {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"};
  public static String[] eyeColorOptions = {"amb", "blu", "brn", "gry", "grn", "hzl", "oth"};
  public static Pattern heightParser = Pattern.compile("(\\d{2,3})(cm|in)");
  public static Pattern hairColorParser = Pattern.compile("#[0-9A-F]{6}");
  public static Pattern passportNumberParser = Pattern.compile("\\d{9}");

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
      System.out.println("-- Checking Passport #" + i);
      if (checkPassport(passportObjects.get(i))) {
        System.out.println("-- PASS\n");
        validPassports++;
      } else {
        System.out.println("-- FAIL\n");
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
    Arrays.sort(fields);

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
          valid = checkRange(1920, Integer.valueOf(kv[1]).intValue(), 2002);
          System.out.println("Birth Year: " + kv[1] + " -- " + valid.toString());
          break;
        case "iyr":
          valid = checkRange(2010, Integer.valueOf(kv[1]).intValue(), 2020);
          System.out.println("Issue Year: " + kv[1] + " -- " + valid.toString());
          break;
        case "eyr":
          valid = checkRange(2020, Integer.valueOf(kv[1]).intValue(), 2030);
          System.out.println("Expiration Year: " + kv[1] + " -- " + valid.toString());
          break;
        case "hgt":
          Matcher heightMatches = heightParser.matcher(kv[1]);

          // Was height specified correctly?
          if (!heightMatches.matches()) {
            System.out.println("Height: Invalid format or unit " + kv[1] + " -- false");
            valid = false;
            break;
          }

          switch (heightMatches.group(2)) {
            case "in":
              valid = checkRange(59, Integer.valueOf(heightMatches.group(1)).intValue(), 76);
              System.out.println("Height: " + heightMatches.group(1) + " inches -- " + valid.toString());
              break;
            case "cm":
              valid = checkRange(150, Integer.valueOf(heightMatches.group(1)).intValue(), 193);
              System.out.println("Height: " + heightMatches.group(1) + " centimeters -- " + valid.toString());
              break;
            default:
              valid = false;
              System.out.println("Height: Invalid unit " + kv[1] + " -- false");
              break;
          }
          break;
        case "hcl":
          Matcher hairColorMatches = hairColorParser.matcher(kv[1].toUpperCase());
          valid = (hairColorMatches.matches());
          System.out.println("Hair color: " + kv[1].toUpperCase() + " -- " + valid);
          break;
        case "ecl":
          valid = (java.util.Arrays.asList(eyeColorOptions).indexOf(kv[1]) > -1);
          System.out.println("Eye color: " + kv[1].toUpperCase() + " -- " + valid);
          break;
        case "pid":
          Matcher passportNumberMatches = passportNumberParser.matcher(kv[1]);
          valid = (passportNumberMatches.matches());
          System.out.println("Passport Number: " + kv[1] + " -- " + valid);
          break;
        case "cid":
          //         _
          // __ __ _| |_  ___ ___ ___
          // \ V  V / ' \/ -_) -_) -_)
          //  \_/\_/|_||_\___\___\___|
          //
          break;
        default:
          valid = false;
          System.out.println("Unexpected Field Found: " + field + " -- " + valid);
          break;
      }

      // @TODO: Test cases are currently all written as (valid = (test)), so we
      // need to bail if we ever get a fail. Otherwise the validity of the
      // passport will always be the validity of the last field. How could I
      // check everything but keep a failure once it is registered?
      if (!valid) {
        break;
      }
    }
    return valid;
  }

  public static Boolean checkRange(int low, int check, int high) {
    return ((low - 1) < check) && (check < (high + 1));
  }
}
