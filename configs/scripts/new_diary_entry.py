#!/usr/bin/python
from datetime import datetime

template = """= {date} =

== Daily checklist ==

* [ ] [[https://github.com/discord/discord/pulls/gizmo385 |Check open PRs]]
* [ ] [[https://github.com/discord/discord/pulls?q=is%3Apr+is%3Aopen+user-review-requested%3A%40me |Check PRs waiting for review]]

== Todo ==

* [ ]

== Notes ==
"""

today = datetime.now()
print(template.format(date=today.strftime('%A %B %-d, %Y')))