/**
 *  ___              _ ____
 * |   \ __ _ _  _  / |__ /
 * | |) / _` | || | | ||_ \
 * |___/\__,_|\_, | |_|___/
 *            |__/
 *
 * "Shuttle Search"
 *
 * Challenge: You need to catch a bus. Bus IDs are the departure interval and loop
 * time. The part one puzzle input first line is the earliest TIMESTAMP you could
 * depart, and the second line is a set of busses in service:
 *
 * 939
 * 7,13,x,x,59,x,31,19
 *
 * Nothing departs at 939. The next departure is at 944 (a multiple of 59).
 *
 * Report the ID of the next bus multiplied by the wait time until it leaves.
 */
import scala.io.Source.fromFile

object BusDepot {
  def inputFile = "bus_schedule.txt"

  def getInfo(): (Int, List[Int]) = {
    val timestamp :: schedule = fromFile(inputFile).getLines.toList
    (timestamp.toInt, schedule.mkString.split(",").filter(_ != "x").toList.map(x => x.toInt))
  }

  def getNextDeparture(interval: Int, min: Int): Int = {
    val gap = (interval + min) % interval
    if (gap == 0) min else interval + min - gap
  }

  def partOne(): Unit = {
    val (availableTime, busses) = getInfo

    val nextUp    = busses map(id => getNextDeparture(id, availableTime))
    val myBusTime = nextUp reduce { (a, b) => a min b }
    val myBus     = busses(nextUp indexOf(myBusTime))
    val myDelay   = myBusTime - availableTime

    println(s"You'll catch bus $myBus at $myBusTime after waiting for $myDelay whatevers.")
    println(s"Multiplied: ${myBus * myDelay}")
    // Part One solution:
    //   You'll catch bus 17 at 1000348, after waiting for 8 whatevers.
    //   Multiplied: 136
  }

  def partTwo() = {
    //  ___          _     ___
    // | _ \__ _ _ _| |_  |_  )
    // |  _/ _` | '_|  _|  / /
    // |_| \__,_|_|  \__| /___|
    //
    // Oh. Good. This is fine.
    //
    // Given the schedule (WITH the x's you ignored in getInfo(), you fool...)
    // determine the FIRST timestamp of the FIRST departure such that:
    // Timestamp = Bus X departure time
    // Timestamp + Y = Bus *index Y departure time (*not ID)
    //
    // From sample: 7,13,x,x,59,x,31,19
    //
    // So if Bus 7 leaves at Time 0, then Bus 13 should leave at T+1. Then Bus
    // 59 at T+4 (skipping the x's)
    //
    // - Other simultaneous bus departures aren't important
    // - Start time from Part One isn't important
    //
    // NARRATIVE WARNING: Surely the will be beyond 100000000000000!
    //
    // I can take no credit for determining this. That goes to a combination of
    // r/adventofcode , @duplico , and beating the crap out of my keyboard
    // hoping that magic spells will fall out. Thanks to sources:
    // https://rosettacode.org/wiki/Chinese_remainder_theorem
    // https://www.reddit.com/r/adventofcode/comments/kcts3z/2020_day_13_part_2_example_solutions_incorrect/gfsm3iu/
    // https://www.reddit.com/r/adventofcode/comments/kczahw/2020_day_13_part_2_python_extremely_fast/

    // Get array of (index/remainder, bus ID/start interval) pairs
    val schedule = getIndexedSchedule()

    // Mark the starting point of the loop so I know if my computer exploded
    var timestamp = 0L
    var increment = 1L

    // For each bus, we need to figure out the first time it could leave, as a
    // multiple of a workable start time we already know for other busses we've
    // already looked at.
    schedule.foreach { case (index, bus) =>

      // So if we just go looking for the "remainders" given for a bus seq like
      // 7,13, we'll get a start @ 14, not 77. The reason is that if we look for
      // time % bus = index  --> we end up looking backward. We'll accept a time
      // like 14, proposing Bus 13 can leave at 13 but that's t-1, not t+1 !

      // If we use 14 as a start time, bus 13, leaving at t+1 would try to leave
      // at 15, which isn't a multiple of 13. Thus, we need to pick a time
      // that gives us the remainder as a "count-up" to the bus time.
      // T 77 % B 13 = 12. We need to look for a "gap" that is 12, or
      // (Bus - Index), instead.
      var gap = ((bus - index) % bus)

      // And because the production input is evil, some index times are longer
      // than their bus interval. We're "catching the next one," so to speak.
      // The math above would make us look for a negative number, which will
      // never happen. So if the gap determined above is negative, we need to
      // add the bus interval to it, to wait for "the next one."
      if (gap < 0) gap += bus

      // Now look for start times such that % bus interval yield the gap we need
      println(s"Trying times for Bus $bus (idx $index -> gap $gap), starting with $timestamp")
      while (timestamp % bus != gap) timestamp += increment

      // To figure the next bus, we know it'll be a multiple of this bus interal
      // so bump the increment up so we don't have to try so many combinations.
      increment *= bus
      println(s"At $timestamp, Bus $bus can depart at ${timestamp + index}  (t + $index)")
    }

    println(s"\nFirst timestamp for the given pattern is $timestamp")
    // Part Two solution:
    //   First timestamp for the given pattern is 305068317272992
  }

  def getIndexedSchedule(): Array[(Int, Int)] = {
    // Pull an Array[String] of bus IDs and x's from the schedule file
    val rawSchedule = fromFile(inputFile).getLines.drop(1).mkString.split(",")

    // Index them as tuples and drop the placeholders
    val schedule = rawSchedule.zipWithIndex.map(_.swap).filter {case (i, b) => b != "x"}

    // Now that we've filtered the "x" items, cast bus IDs as Int and return.
    schedule map {case (i, b) => (i, b.toInt)}
  }

  def main(args: Array[String]) = partTwo()
}
