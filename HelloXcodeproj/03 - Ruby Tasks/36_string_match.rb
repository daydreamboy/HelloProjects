#encoding: utf-8

require_relative '../02 - Ruby Helper/rubyscript_helper'

@exp = '(.+)\[(.*)\]'

def match(string)
  matches = string.match(@exp)
  dump_object(matches)
  if matches.nil?
    string
  else
    [matches[1], matches[2]]
  end
end

def test1
  string = 'ab'
  ret = match(string)
  dump_object(ret)
end

def test2
  string = 'ab[]'
  ret = match(string)
  dump_object(ret)
end

def test3
  string = 'ab[Debug]'
  ret = match(string)
  dump_object(ret)
end

def test4
  string = 'ab[Debug,Release]'
  ret = match(string)
  if ret.count > 1
    arr = ret[1].split(/[\s,]/)
    dump_object(arr)
  end
end

def test5
  string = 'ab[Debug, Release]'
  ret = match(string)
  if ret.count > 1
    arr = ret[1].split(/[\s,]/).reject { |c| c.empty? }
    dump_object(arr)
  end
end

test1
test2
test3
test4
test5
