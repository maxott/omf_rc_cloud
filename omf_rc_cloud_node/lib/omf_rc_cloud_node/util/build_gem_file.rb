
#
# This is a utility file to build a Gemfile for this RC
# which includes dependencies defined for 'Factories'
# in the config file
#
require 'optparse'
require 'yaml'

run_through_erb = false
top_dir = File.join(File.dirname($0), '../../..')
config_file = File.join(top_dir, 'etc/omf_rc/cloud_node.yaml')
op = OptionParser.new
op.on '-c', '--config-file FILE', "File to read configuration parameters from [#{config_file}]" do |f|
  config_file = f
end
op.on '-e', '--erbify', "Run content of config file through ERB. [#{run_through_erb}]" do
  run_through_erb = true
end
op.on_tail('-h', "--help", "Show this message") { $stderr.puts op; exit }
op.parse!


#
# This script starts a node proxy on a cloud instance. It assumes that
# various configuration options are being copied onto the VM by the
# cloud provider.
#
str = File.read(config_file)
if run_through_erb
  require 'erb'
  require 'socket'
  str = ERB.new(str).result()
end
cfg = YAML.load(str)
gems = []
(cfg['factories'] || []).each do |f|
  next unless f['add_defaults'].nil?
  if gem = f['gem']
    gems << gem
  end
end

gf_in = File.read(File.join(top_dir, 'Gemfile.in'))
gem_file = File.open(File.join(top_dir, 'Gemfile'), 'w')

gem_file.write(File.read(File.join(top_dir, 'Gemfile.in')))
gem_file.write("\n")
gems.each do |g|
  raise "Missing name in '#{g}'" unless name = g['name']
  if git = g['git']
    if g['git_multi_gem']
      gem_file.write(%{
git '#{git}' do
  gem '#{name}'
end
})
    end

    gem_file.write("gem '#{name}', :git => '#{git}'\n")
  end
end
gem_file.close
