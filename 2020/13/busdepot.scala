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
  def inputFile = "bus_sample.txt"

  def getInfo() = {
    val timestamp :: schedule = fromFile(inputFile).getLines.toList
    (timestamp, schedule.mkString.split(",").filter(_ != "x").toList)
  }

  def main(args: Array[String]) = {
    getInfo()
    val (availableTime, busses) = getInfo
    println(availableTime)
    println(busses)
  }
}
