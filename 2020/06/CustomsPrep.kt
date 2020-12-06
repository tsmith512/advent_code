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

    customsDataScanner.close()
  }

  /**
   * Given a group (one string from groupAnswers), return the number of
   * questions that got a "yes" (count of unique letters).
   */
  private fun getGroupAnyoneSaidYesCount(group: String): Int = group.replace("\n", "").toCharArray().distinct().count()

  /**
   * Sum getGroupYesCount across the whole collection.
   */
  fun getAllGroupsAnyoneYesCount(): Int = groupAnswers.fold(0) {x, i -> x + getGroupAnyoneSaidYesCount(i)}
}

fun main() {
  val customsForms = CustomsPrep("sample_survey.txt")

  // Since I have no clue how to label "sum of count-distinct-per-group Yeses"
  println("Part one count: " + customsForms.getAllGroupsAnyoneYesCount())
  // Part one count: 6161
}
