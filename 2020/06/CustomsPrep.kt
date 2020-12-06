/**
 *  ___               __   __
 * |   \ __ _ _  _   /  \ / /
 * | |) / _` | || | | () / _ \
 * |___/\__,_|\_, |  \__/\___/
 *            |__/
 *
 * "Custom Customs"
 *
 * Challenge:
 * A yes/no survey has been distributed. Puzzle input contains from all
 * passengers. A letter represents a "yes" on the corresponding question.
 * \n separates people, \n{2} separates groups.
 *
 * Calculate the sum of the count of questions which got a yes WITHIN each group
 */

import java.io.File
import java.util.Scanner

const val INPUT_FILE = "sample_survey.txt"

fun main() {
  val customsDataScanner = Scanner(File(INPUT_FILE)).useDelimiter("\n\n")

  while (customsDataScanner.hasNext()) {
    println("\n\nGroup Declaration:")
    println(customsDataScanner.next())
  }
}
