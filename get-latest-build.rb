require 'json'
require 'open-uri'
require 'pp'

begin
    release = JSON.parse(URI.open('https://api.github.com/repos/bison-packages/packages/releases/latest').read)
rescue OpenURI::HTTPError
    puts 'None'
    exit 0
end

$stderr.puts 'Latest release:'
$stderr.puts release.pretty_inspect
$stderr.puts

puts release['tag_name'].delete_prefix('v')
