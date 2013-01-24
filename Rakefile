#-------------------------------------------------------------------------------
# Copyright (c) 2013 National ICT Australia Limited (NICTA).
# This software may be used and distributed solely under the terms of the MIT license (License).
# You should find a copy of the License in LICENSE.TXT or at http://opensource.org/licenses/MIT.
# By downloading or using this software you accept the terms and the liability disclaimer in the License.
#-------------------------------------------------------------------------------
require 'rake/testtask'
require "bundler/gem_tasks"

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = "test/**/*_spec.rb"
  t.verbose = true
end
