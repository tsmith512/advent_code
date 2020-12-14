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

object BusDepot extends {
  def inputFile = "bus_schedule.txt"

  def getInfo() = {
    val timestamp :: schedule = fromFile(inputFile).getLines.toList
    (timestamp.toInt, schedule.mkString.split(",").filter(_ != "x").toList.map(x => x.toInt))
  }

  def getNextDeparture(interval: Int, min: Int): Int = {
    val gap = (interval + min) % interval
    if (gap == 0) min else interval + min - gap
  }

  def main(args: Array[String]) = {
    val (availableTime, busses) = getInfo

    val nextUp = busses.map(id => getNextDeparture(id, availableTime))
    val myBusTime = nextUp.reduce((a, b) => a min b)
    val myBus = busses(nextUp.indexOf(myBusTime))
    val myDelay = myBusTime - availableTime

    println("You'll catch bus " + myBus + " at " + myBusTime + ", after waiting for " + myDelay + " whatevers.")
    println("Multiplied: " + (myBus * myDelay))
    // Part One solution:
    //   You'll catch bus 17 at 1000348, after waiting for 8 whatevers.
    //   Multiplied: 136


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
    // (And yes, @duplico already tried it the cheap way; it would take years.)
  }
}
