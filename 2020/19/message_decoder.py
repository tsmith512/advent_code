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

import re

INPUT_FILE = "message_sample.txt"
rules = {}
primaryRule = 0

def main():
  rules, messages = setup(INPUT_FILE)
  bigAssRegex = translate(rules[primaryRule], True)
  matcher = re.compile(bigAssRegex)

  count = 0
  for message in messages:
    count += 1 if matcher.match(message) else 0

  print("{} messages from the set of {} matched rule {}".format(count, len(messages), primaryRule))

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

def translate(item, top = False):
  # Base case
  if item == "a" or item == "b":
    return item

  # Split the string into piped segments, then by space. Look up each and build
  # a regex pattern to match the opts, because of course that's a thing I'd do
  translated = []
  for index, segment in enumerate(str(item).split("|")):
    pieces = [*map(lambda s: s.strip(), segment.split())]
    decoded = [*map(lambda x: translate(rules[int(x)]), pieces)]
    translated.append("".join(decoded))

  # If we had multiple segment options, they need to be an OR group:
  if len(translated) > 1:
    output = "({})".format("|".join(translated))
  # If this didn't have multiple options, we don't need to group it:
  else:
    output = translated[0]

  if top:
    print("RULE IN:  {}\nOUT: {}\n".format(item, "^{}$".format(output)))
    return "^{}$".format(output)
  else:
    return output

# Pretty printer for the rules dict
def rulebook(rules):
  for k, v in rules.items():
    print("{} : {}".format(k, v))


if __name__ == "__main__":
  main()
