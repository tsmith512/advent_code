#!/usr/bin/env python3
"""
 ___              _ ___
|   \ __ _ _  _  / / _ \
| |) / _` | || | | \_, /
|___/\__,_|\_, | |_|/_/
           |__/

"Monster Messages"

Challenge:
Given a set of rules and a set of messages:

- Rules are numbered.
- Numeric rule values correspond to other rules which ultimately map to
  characters.
- Pipes are an "OR" statement.

Example:
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

- So Rule 0 means [4, 1, 5] --> [a, [2 3 | 3 2], b] --> ...
- Rule 3 is easier [4 5 | 5 4] --> [a b | b a] --> (ab, ba) are valid.

ababbb <- Matches
bababa
abbbab <- Matches
aaabbb
aaaabbb

Report the number of given message that satisfy Rule 0.
"""

INPUT_FILE = "message_sample.txt"

def main():
  rules, messages = setup(INPUT_FILE)

  rulebook(rules)
  print(messages)

  decode(rules, 0)

# Slurp the input file and split it in half, then put the rules in an dict of
# ID - RuleString and put the given messages in an array.
def setup(filename):
  file = open(filename, mode="r")
  contents = file.read().strip().split("\n\n")
  file.close()

  rules = {}
  for i in contents[0].strip().split("\n"):
    kv = i.split(": ")
    id = int(kv[0])
    rule = kv[1].replace("\"", "").strip()
    rules[id] = rule

  messages = contents[1].split("\n")

  return rules, messages

# Okay let's try this a different way:
def decode(rules, id):
  rule = rules[id]
  composite = ""

  if "|" in rule:
    # Need to figure out what to do here.
    print("There's a pipe")
    return rule
  else:
    # Split what we know by spaces
    pieces = rule.split(" ")
    for piece in pieces:
      # If this piece is a number, we need to look it up
      if piece.isnumeric():
        print("Numeric piece {}".format(piece))
        value = decode(rules, int(piece))
      # If this piece is a non-numeric string, it's part of a message
      else:
        value = piece

      # Having figured out what this piece is, cram it back onto our string
      composite = "{}{}".format(composite, value)
      print("{} -> {}".format(piece, value))

    # Now print and return the full string we've resolved
    print(composite)
    return composite

# Pretty printer for the rules dict
def rulebook(rules):
  for k, v in rules.items():
    print("{} : {}".format(k, v))


if __name__ == "__main__":
  main()
