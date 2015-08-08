# Copyright (C) 2015 Oleh Prypin <blaxpirit@gmail.com>
# Licensed under terms of MIT license (see LICENSE)


import sequtils, strutils, macros


template any_it*(lst, pred: expr): expr =
    ## Does `pred` return true for any of the items of an iterable?
    var result = false
    for it {.inject.} in lst:
        if pred:
            result = true
            break
    result


proc count*[T](s: openarray[T], it: T): int =
    ## How many times this item appears in an array
    result = 0
    for x in s:
        if x == it:
            result += 1


proc partition*(s, sep: string): tuple[left, sep, right: string] =
    ## "a+b".partition("+") == ("a", "+", "b")
    ## "a+b".partition("-") == ("a+b", "", "")
    assert sep != nil and sep != ""
    let pos = s.find(sep)
    if pos < 0:
        (s, "", "")
    else:
        (s.substr(0, <pos), s.substr(pos, <pos+sep.len), s.substr(pos+sep.len))


proc is_upper*(s: string): bool =
    ## Is the string in uppercase (and there is at least one cased character)?
    let upper = s.to_upper()
    s == upper and upper != s.to_lower()


proc sub*[T](s: seq[T], a, b: int): seq[T] =
    ## Items from `a` to `b` non-inclusive
    if a < b: s[a .. <b]
    else: @[]


macro gen_class*(body: stmt): stmt {.immediate.} =
    ## When applied to a type block, this will generate methods
    ## that return each type's name as a string.
    for typ in body[0].children:
        body.add(parse_stmt(
            """method class(self: $1): string = "$1"""".format(typ[0])
        ))
    body
