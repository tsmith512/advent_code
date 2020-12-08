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
  var groupAnswers = mutableListOf<String>()

  /**
   * Process the input file and separate groups of passengers.
   */
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
   * Fun trick: <Coll>.toSet() will strip duplicates; Sets have unique members.
   */
  private fun getGroupAnyoneSaidYesCount(group: String): Int = group.replace("\n", "").toSet().count()

  /**
   * Sum getGroupYesCount across the whole collection.
   * <Coll>.fold() is a reducer that has a starting value.
   */
  fun getAllGroupsAnyoneYesCount(): Int = groupAnswers.fold(0) {x, i -> x + getGroupAnyoneSaidYesCount(i)}

  /**
   *  ___          _     ___
   * | _ \__ _ _ _| |_  |_  )
   * |  _/ _` | '_|  _|  / /
   * |_| \__,_|_|  \__| /___|
   *
   * In Part Two, we need to identify, within each group, how many questions got
   * a Yes from every member. (Find the intersection of member strings rather
   * than the union.)
   */
  fun getAllGroupsAllYesCount(): Int {
    var totalCount = 0

    groupAnswers.forEach {
      // Determine all questions this group received
      var allQuestions = it.replace("\n", "").toCharArray().toSet()

      // Separate the group into individual member strings
      var thesePeople = it.trim().split("\n")

      // Starting with a set of all questions, walk the group members and toss
      // any that aren't found in each member string.
      var yesFromAll = thesePeople.fold(allQuestions) {set, test -> set.intersect(test.toSet())}

      totalCount += yesFromAll.count()
    }

    return totalCount
  }
}

fun main() {
  val customsForms = CustomsPrep("customs_survey.txt")

  // Essentially "sum of count-distinct-per-group"
  println("Part one count: " + customsForms.getAllGroupsAnyoneYesCount())
  // Part one count: 6161

  // "sum of count-intersection-within-group"
  println("Part two count: " + customsForms.getAllGroupsAllYesCount())
  // Part two count: 2971
}
