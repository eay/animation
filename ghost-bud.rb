#!/usr/bin/env ruby
#
NAME = "ghost-bud"
FILE_TMP = "#{NAME}.pnm"

tmp_files = [FILE_TMP]

bytes = open("| jpegtopnm #{NAME}.jpg").read
open(FILE_TMP,"wb").write(bytes)

height = 189
offset = 850 - height

names = []

31.times do |i|
  out_name = "#{NAME}-%02d.gif" % i
  names << out_name
  tmp_files << out_name
  cmd = "|\
      pamcut -top=#{offset + i*height} -width=3000 -height=#{height} #{FILE_TMP} \
    | pnmpad -white -top 500 -bottom=500 \
    | pamscale 0.5 \
    | pnmquant 256 \
    | pamtogif".gsub(/\s+/,' ')
  puts cmd
  cut = open(cmd).read
  open(out_name,"wb").write(cut)
end

system "gifsicle -d 50 --colors 256 #{names.join(' ')} > #{NAME}.gif"

tmp_files.each {|fn| File.delete(fn)}

  
