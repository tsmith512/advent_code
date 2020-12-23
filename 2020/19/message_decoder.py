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

print("Hello, World!")
