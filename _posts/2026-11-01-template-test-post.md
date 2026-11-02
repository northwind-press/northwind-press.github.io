---
title: "Template test post: sources, a correction, code, a table and a long URL"
author: "Developer 2"
description: "Test article exercising every part of the article template. Never merge."
sources:
  - title: "Jekyll documentation: Front Matter"
    url: https://jekyllrb.com/docs/front-matter/
    publisher: "Jekyll"
    date: "2026-01-15"
    accessed: "2026-11-02"
  - title: "GitHub Pages dependency versions"
    url: https://pages.github.com/versions/
    publisher: "GitHub"
  - title: "A source with a very long URL that has no natural break points at all"
    url: https://example.com/a/really/long/path/that/keeps/going/and/going/without/any/spaces/so/it/cannot/wrap/naturally/on/a/narrow/phone/screen?with=query&parameters=thatarealsoextremelylongandunbroken1234567890
corrections:
  - date: 2026-11-02
    text: "An earlier version said the table had two columns. It has three ([source](https://jekyllrb.com/docs/front-matter/))."
---
This paragraph links a claim inline to [the Jekyll front matter docs](https://jekyllrb.com/docs/front-matter/).

## A code block

```python
def very_long_function_name_to_test_horizontal_overflow_inside_preformatted_blocks(argument_one, argument_two):
    return argument_one + argument_two
```

Inline `code_with_a_really_long_identifier_that_should_not_break_the_layout_on_mobile` too.

## A table

| Model | Context window | Notes on this particular configuration |
|-------|----------------|----------------------------------------|
| Alpha | 128k tokens | A fairly long cell that should wrap or scroll inside the table |
| Beta  | 1M tokens | Short |

## A long URL

Raw long URL in body text: https://example.com/a/really/long/path/that/keeps/going/and/going/without/any/spaces/so/it/cannot/wrap/naturally/on/a/narrow/phone/screen?with=query&parameters=thatarealsoextremelylongandunbroken1234567890
