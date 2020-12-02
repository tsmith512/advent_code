#  ___               __ ___
# |   \ __ _ _  _   /  \_  )
# | |) / _` | || | | () / /
# |___/\__,_|\_, |  \__/___|
#            |__/
#
# "Password Philosophy"

# Challenge:
# Input file contains lines in this format: `LOW-HIGH CHAR: STRING`
# Count lines from the input file where CHAR is present between LOW and HIGH
# times (inclusive) in STRING.

# Pull a sample row from the file to work on the test
$example = "7-10 d: dddddddddpzwqflvdx"

function ParseRow {
  param([string]$row)
  # Translate my description above into a regex that saves named matches.
  #   - You can name matches!
  #   - The -match will save this into $Matches variable automatically.
  #   - The -matches test will return T/F, which will output on the terminal if
  #     you don't capture it (hence Out-Null)
  $row -match '(?<Min>\d+)-(?<Max>\d+) (?<Char>[A-Za-z]): (?<Passwd>.+)' | Out-Null
  $Matches
}

function GetCount {
  param(
    [string]$Text,
    [string]$Char
  )

  # Explode the string into an array, filter the test character, count it
  $($Text.ToCharArray() | Where-Object {$_ -eq $Char} | Measure-Object).Count
}

function IsEnough {
  param(
    [int]$Count,
    [int]$Min,
    [int]$Max
  )

  (($Count -ge $Min) -and ($Count -le $Max))
}

$Values = ParseRow $example
$Count = GetCount $Values.Passwd $Values.Char

if (IsEnough $Count $Values.Min $Values.Max) {
  "The test string contains the character an acceptable number of times"
}
