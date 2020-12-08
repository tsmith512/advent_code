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

# Split the line as described above into an object with its named properties
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

# Given String and a Char, how many times is Char in String?
function GetCount {
  param(
    [string]$Text,
    [string]$Char
  )

  # Explode the string into an array, filter the test character, count it
  $($Text.ToCharArray() | Where-Object {$_ -eq $Char} | Measure-Object).Count
}

# Is ($min <= $count <= $max)?
function IsEnough {
  param(
    [int]$Count,
    [int]$Min,
    [int]$Max
  )

  (($Count -ge $Min) -and ($Count -le $Max))
}

$PasswordList = Get-Content .\password_list.txt
$ValidPasswords = 0

$PasswordList | ForEach-Object {
  $Values = ParseRow $_
  $Count = GetCount $Values.Passwd $Values.Char

  if (IsEnough $Count $Values.Min $Values.Max) {
    $ValidPasswords++
  }
}

"There were $ValidPasswords that passed the first test"
# Part One answer: There were 655 that passed the first test

#  ___          _     ___
# | _ \__ _ _ _| |_  |_  )
# |  _/ _` | '_|  _|  / /
# |_| \__,_|_|  \__| /___|
#
# "Min" and "Max" aren't ranges, they're positions. The given character must
# appear at either MIN-index or MAX-index, with a 1-based address space.

function CheckIndexes {
  param(
    [string]$String,
    [string]$Char,
    [int]$PosA,
    [int]$PosB
  )

  $Split = $String.ToCharArray()

  # Look for the match at one index or the other, subtract one because the given
  # position is one-based but PowerShell array indicies are zero-based.
  (($Split[$PosA - 1] -eq $Char) -xor ($Split[$PosB - 1] -eq $Char))
}

$ValidPasswords = 0

$PasswordList | ForEach-Object {
  $Values = ParseRow $_
  if (CheckIndexes $Values.Passwd $Values.Char $Values.Min $Values.Max) {
    $ValidPasswords++
  }
}

"There were $ValidPasswords that passed the second test"
# Part Two answer: There were 673 that passed the second test
