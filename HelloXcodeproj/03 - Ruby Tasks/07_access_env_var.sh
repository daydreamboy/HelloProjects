#!/usr/bin/env bash

eval `ruby './07_export_variable.rb'`
echo "foo =  $foo"
echo "ruby_secret = $ruby_secret"

# @see https://stackoverflow.com/questions/24671014/exporting-ruby-variables-to-parent-process
eval `ruby -e "puts 'export foo=bar'"`
echo $foo