#!/bin/bash

usage()
{
  cat <<TEXT
Usage: ./ruby_set_up.sh [app_name] [method_name]
You can build the basic environment for ruby.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./[app_name]-[app]
               |---[app_name].rb
             [test]
               |---[app_name]_test.rb
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
If you want to build a method together, you pass the second argument for this script.
TEXT
  exit 1
}

class_name=$(printf "${1}" | sed -r 's/(^|_)(.)/\U\2\E/g')

[ -z ${1} ] && usage

mkdir "${PWD}/${1}"
mkdir "${PWD}/${1}/app"
mkdir "${PWD}/${1}/test"
touch "${PWD}/${1}/app/${1}.rb"
touch "${PWD}/${1}/test/${1}_test.rb"

cat <<TEXT > "${PWD}/${1}/test/${1}_test.rb"
require 'minitest/autorun'
require_relative '../app/${1}.rb'
class ${class_name}Test < Minitest::Test
end
TEXT

[ -z ${2} ] && exit 0

cat <<TEXT > "${PWD}/${1}/app/${1}.rb"
def ${2}
  true
end
TEXT

cp /dev/null "${PWD}/${1}/test/${1}_test.rb"
cat <<TEXT > "${PWD}/${1}/test/${1}_test.rb"
require 'minitest/autorun'
require_relative '../app/${1}.rb'
class ${class_name}Test < Minitest::Test
  def test_${2}
    assert_equal true, ${2}
  end
end
TEXT

