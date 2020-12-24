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
rules = {}

def main():
  rules, messages = setup(INPUT_FILE)

  rulebook(rules)
  print(messages)

  translate(rules[0])

# Slurp the input file and split it in half, then put the rules in an dict of
# ID - RuleString and put the given messages in an array.
def setup(filename):
  file = open(filename, mode="r")
  contents = file.read().strip().split("\n\n")
  file.close()

  for i in contents[0].strip().split("\n"):
    kv = i.split(": ")
    id = int(kv[0])
    rule = kv[1].replace("\"", "").strip()
    rules[id] = rule

  messages = contents[1].split("\n")

  return rules, messages

def translate(item):
  # I've tried breaking this down into a complicated data model of arrays and
  # stuff. Let's try the dumb way. Cast whatever we got as a string and look at
  # each character individually.
  if item == "a" or item == "b":
    return item

  pieces = [*map(lambda s: s.strip(), str(item).split())]
  decoded = [*map(lambda x: translate(rules[int(x)]), pieces)]
  print("".join(decoded))
  return "".join(decoded)

# Pretty printer for the rules dict
def rulebook(rules):
  for k, v in rules.items():
    print("{} : {}".format(k, v))


if __name__ == "__main__":
  main()
