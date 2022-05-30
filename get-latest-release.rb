require 'net/ftp'

ftp = Net::FTP.new('ftp.gnu.org')
ftp.login
ftp.chdir('gnu/bison/')

RemoteFile = Struct.new(:filename, :mtime, keyword_init: true)

files = ftp
    .list('*.tar.gz')
    .map { |line| line[/bison-.*\.tar\.gz/] }
    .map { |filename| Thread.new { RemoteFile.new(filename: filename, mtime: ftp.mdtm(filename)) } }
    .each(&:join)
    .map(&:value)
    .sort_by(&:mtime)

files.each do |f|
    $stderr.puts "Filename = #{f.filename.ljust(25, ' ')} mtime = #{f.mtime}"
end

filename = files.last.filename
release = filename.delete_prefix('bison-').delete_suffix('.tar.gz')

$stderr.puts "\nLatest release = #{release}"

puts release
