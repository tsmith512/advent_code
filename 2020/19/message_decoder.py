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
  # Split the rule text into options at the pipe: "2 3 | 3 2" -> ['2 3', '3 2']
  rule = rules[id].split("|")
  for half, option in enumerate(rule):

    # Split the option into its parts by space: '2 3' -> [2, 3]
    parts = option.strip().split(" ")
    for index, part in enumerate(parts):

      # If the part is a number, we need to decode it
      if part.isnumeric():
        innards = decode(rules, int(part))
        print("Decoded {}: {}".format(part, innards))
        parts[index] = resolve(innards)

    rule[half] = parts[0] if len(parts) == 1 else parts
  # By now `rule` contains 1 or 2 (the pipe) options to satisfy the rule.
  return rule[0] if len(rule) == 1 else rule

# Somewhere in here is a good idea but I think I walked too far away from it
# because it stopped making sense. Idea:
# - If we get an array with one member, unbox that and return it.
# - If we get two strings of 1 letter each, combine them.
# - If we get lists, we need to resolve all combinations they could create
# - Otherwise, return the input unchanged (string input)
def resolve(input):
  print("Resolving: {}".format(input))

  if type(input) == list and len(input) == 1:
    return input[0]

  # I think we can just join strings once they've been multiplied?
  elif all(type(x) == str and len(x) == 1 for x in input):
    return "".join(input)

  # If we have a list of lists, we should get the cartesian product
  elif all(type(x) == list for x in input):
    product = list(itertools.product(*input))
    combos = ["".join(combo) for combo in product]
    # @HELP! ^^ This line currently fails when resolving Rule 1 on the sample
    # input because `combo` is a list instead of a string. I think I'm doing
    # this in the wrong place. This is the last print:

    # Decoded 1: [[['ab', 'ab', 'ab', 'ab'], ['ab', 'aa', 'bb', 'ba']], [['ab', 'aa', 'bb', 'ba'], ['ab', 'ab', 'ab', 'ab']]]
    # Resolving: [[['ab', 'ab', 'ab', 'ab'], ['ab', 'aa', 'bb', 'ba']], [['ab', 'aa', 'bb', 'ba'], ['ab', 'ab', 'ab', 'ab']]]

    # Which I think is what Rule 1 boils down to, but somewhere a product didn't
    # get executed.

    print(combos)
    return combos
  else:
    return input

# Pretty printer for the rules dict
def rulebook(rules):
  for k, v in rules.items():
    print("{} : {}".format(k, v))


if __name__ == "__main__":
  main()
