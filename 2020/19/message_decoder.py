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

import itertools

INPUT_FILE = "message_sample.txt"

def main():
  rules, messages = setup(INPUT_FILE)

  rulebook(rules)
  print(messages)

  print(decode(rules, 0))

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

# Given the dict of rules and an ID to investivate, do that?
def decode(rules, id):
  # Split the rule text into options at the pipe:
  rule = rules[id].split("|")
  for half, option in enumerate(rule):

    # Split the option into its parts by space:
    parts = option.strip().split(" ")
    for index, part in enumerate(parts):

      # If the part is a number, we need to decode it
      if part.isnumeric():
        # This will return an array
        parts[index] = decode(rules, int(part))
      else:
        parts[index] = part

    # At this point, `parts` is either an array of character options or a
    # single character. `rule` is a 1- or 2- length of options to resolve this
    # rule. Start by just passing them straight up.
    # print("Output for {}: {}\n\n".format(id, parts))
    rule[half] = parts
  return rule[0] if len(rule) == 1 else rule

def rulebook(rules):
  for k, v in rules.items():
    print("{} : {}".format(k, v))


if __name__ == "__main__":
  main()
