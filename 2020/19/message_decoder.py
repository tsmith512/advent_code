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

INPUT_FILE = "message_dump.txt"
rules = {}
primaryRule = 0

def main():
  rules, messages = setup(INPUT_FILE)
  bigAssRegex = translate(rules[primaryRule], 0, 0)
  matcher = re.compile(bigAssRegex)

  count = 0
  for message in messages:
    count += 1 if matcher.match(message) else 0

  print("{} messages from the set of {} matched rule {}".format(count, len(messages), primaryRule))

  # Part One solution:
  # RULE IN:  8 11
  # OUT: ^(((b(a((a(ab|ba)|b(ba|aa))a|((ab|bb)b|(b|a)(b|a)a)b)|b(a((b|a)a|bb)a|(((b|a)a|ab)a|(b|a)(b|a)b)b))|a(a(aab|b((b|a)a|bb))b|b((((b|a)b|aa)b|((b|a)a|bb)a)b|(b(ab|bb)|abb)a)))a|(a((a((ab|ba)a|(ba|(b|a)b)b)|b((ba|(b|a)b)a|(ab|bb)b))b|(b(aba|baa)|a(aab|aaa))a)|b((ba((b|a)a|bb)|a(a((b|a)a|bb)|b(ba|aa)))a|((a(b|a)(b|a)|b((b|a)a|bb))b|b(ba|aa)a)b))b)b|(a((b((b|a)(b|a)bb|(b((b|a)b|aa)|aba)a)|a(a((ba|aa)a|((b|a)b|aa)b)|b(((b|a)a|bb)b|((b|a)b|aa)a)))a|(((bba|(b|a)(b|a)b)a|aabb)a|(a(b(b|a)(b|a)|aba)|b((ba|aa)a|bab))b)b)|b(a(b(((ba|aa)a|(ab|ba)b)a|(aaa|(ba|aa)b)b)|a((aba|b(ab|bb))a|(b((b|a)a|bb)|a(ab|ba))b))|b((b(ba|aa)b|(abb|b(ab|ba))a)b|(a(b((b|a)a|ab)|a(ab|ba))|b(((b|a)b|aa)a|(ba|(b|a)b)b))a)))a)(((b(a((a(ab|ba)|b(ba|aa))a|((ab|bb)b|(b|a)(b|a)a)b)|b(a((b|a)a|bb)a|(((b|a)a|ab)a|(b|a)(b|a)b)b))|a(a(aab|b((b|a)a|bb))b|b((((b|a)b|aa)b|((b|a)a|bb)a)b|(b(ab|bb)|abb)a)))a|(a((a((ab|ba)a|(ba|(b|a)b)b)|b((ba|(b|a)b)a|(ab|bb)b))b|(b(aba|baa)|a(aab|aaa))a)|b((ba((b|a)a|bb)|a(a((b|a)a|bb)|b(ba|aa)))a|((a(b|a)(b|a)|b((b|a)a|bb))b|b(ba|aa)a)b))b)b|(a((b((b|a)(b|a)bb|(b((b|a)b|aa)|aba)a)|a(a((ba|aa)a|((b|a)b|aa)b)|b(((b|a)a|bb)b|((b|a)b|aa)a)))a|(((bba|(b|a)(b|a)b)a|aabb)a|(a(b(b|a)(b|a)|aba)|b((ba|aa)a|bab))b)b)|b(a(b(((ba|aa)a|(ab|ba)b)a|(aaa|(ba|aa)b)b)|a((aba|b(ab|bb))a|(b((b|a)a|bb)|a(ab|ba))b))|b((b(ba|aa)b|(abb|b(ab|ba))a)b|(a(b((b|a)a|ab)|a(ab|ba))|b(((b|a)b|aa)a|(ba|(b|a)b)b))a)))a)(a((((a(a((b|a)a|bb)|bab)|b(aba|bab))b|(a(b|a)(b|a)(b|a)|b((b|a)(b|a)a|aab))a)a|((b(b(ba|(b|a)b)|a((b|a)b|aa))|a(ba|(b|a)b)(b|a))a|(b(aaa|(ba|aa)b)|a(a(ab|aa)|bba))b)b)b|((((ba|aa)(b|a)b|((ab|bb)b|baa)a)a|(a(aba|bab)|b(b|a)(ba|aa))b)a|((b((b|a)(b|a)b|aaa)|a((ba|aa)a|((b|a)a|bb)b))a|(((ba|aa)a|((b|a)a|bb)b)b|(aaa|b(ab|bb))a)b)b)a)|b(((a((aaa|(ba|(b|a)b)b)a|(aab|bab)b)|b(((ba|bb)a|((b|a)a|bb)b)a|bbab))a|(b(((ba|bb)a|((b|a)a|bb)b)a|(bba|a(ba|bb))b)|a((b(ab|bb)|aab)a|(b|a)(ba|aa)b))b)b|(b(a((((b|a)a|ab)a|(b|a)(b|a)b)b|(aaa|(ab|bb)b)a)|b(a(a(ab|ba)|bbb)|b(aaa|b(ab|bb))))|a((b(b(ba|bb)|a(ab|ba))|a(b(ba|aa)|a((b|a)b|aa)))a|(a((ab|ba)b|aaa)|b((ba|(b|a)b)a|(ab|bb)b))b))a))$
  #
  # 222 messages from the set of 433 matched rule 0


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

def translate(item, id, depth):
  # Base case
  if item == "a" or item == "b":
    return item

  if str(id) in item:
    print("ID was found in its own rule")
    return item

  # Split the string into piped segments, then by space. Look up each and build
  # a regex pattern to match the opts, because of course that's a thing I'd do
  translated = []
  for index, segment in enumerate(str(item).split("|")):
    pieces = [*map(lambda s: s.strip(), segment.split())]
    decoded = [*map(lambda x: translate(rules[int(x)], int(x), depth + 1), pieces)]
    translated.append("".join(decoded))

  # If we had multiple segment options, they need to be an OR group:
  if len(translated) > 1:
    output = "({})".format("|".join(translated))
  # If this didn't have multiple options, we don't need to group it:
  else:
    output = translated[0]

  if depth == 0:
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
