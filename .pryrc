#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'pathname'
$LOAD_PATH.unshift(Pathname.getwd.join('lib').to_s)
require 'faraday_cage'

def reload!
  Dir["#{Dir.pwd}/lib/**/*.rb"].each { |f| load f }
end
