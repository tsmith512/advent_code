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

class CustomsPrep(inputFile: String) {
  var groupAnswers: MutableList<String> = ArrayList()

  init {
    val customsDataScanner = Scanner(File(inputFile)).useDelimiter("\n\n")

    while (customsDataScanner.hasNext()) {
      groupAnswers.add(customsDataScanner.next())
    }
  }
}

fun main() {
  val customsForms = CustomsPrep("sample_survey.txt")
  println(customsForms.groupAnswers)
}
