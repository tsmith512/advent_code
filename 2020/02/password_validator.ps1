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
$row = "7-10 w: dpzwqflvdx"

# Translate my description above into a regex that saves named matches.
#   - You can name matches!
#   - The -match will save this into $Matches variable automatically.
#   - The -matches test will return T/F, which will output on the terminal if
#     you don't capture it (hence Out-Null)
$row -match '(?<Min>\d+)-(?<Max>\d+) (?<Char>[A-Za-z]): (?<Passwd>.+)' | Out-Null

if ($Matches.Passwd.ToCharArray() -contains $Matches.Char) {
  "$($Matches.Passwd) contains $($Matches.Char)"
}
