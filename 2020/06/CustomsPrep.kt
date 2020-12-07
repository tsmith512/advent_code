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

  /**
   * In Part Two, we need to know if someone answered yes to every question that
   * anyone in their group said yes to. (Read the Advent of Code page, I can't
   * make good words for this prompt.) Given a person's answers and a set of all
   * questions, return 1 if this person said yes on everything.
   */
   private fun yesOnEverything(person: String, questions: Set<Char>): Int {
     return if (person.toCharArray().count() == questions.count()) 1 else 0
   }

   /**
    * In Part Two, we need to inspect individual groups to see how many people
    * within that group answered yes to every question presented.
    */
  fun getAllPeopleAllYesAnswers(): Int {
    var allYesAnswers = 0

    groupAnswers.forEach {
      var thisGroupTotalQuestions = it.replace("\n", "").toCharArray().toSet()
      var thesePeople = it.trim().split("\n")
      var thisGroupAllYesAnswers = 0

      println("Group members: " + thesePeople)
      println("Group Questions: " + thisGroupTotalQuestions)
      thisGroupAllYesAnswers = thesePeople.fold(0) {count, person -> count + yesOnEverything(person, thisGroupTotalQuestions)}
      println("Group contains " + thisGroupAllYesAnswers + " who said yes on everything.")

      allYesAnswers += thisGroupAllYesAnswers
    }

    return allYesAnswers
  }
}

fun main() {
  val customsForms = CustomsPrep("sample_survey.txt")

  // Since I have no clue how to label "sum of count-distinct-per-group Yeses"
  println("Part one count: " + customsForms.getAllGroupsAnyoneYesCount())
  // Part one count: 6161

  println("Part two count: " + customsForms.getAllPeopleAllYesAnswers())
}
