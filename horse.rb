#!/usr/bin/env ruby
#
NAME = "horse"
FILE_TMP = "#{NAME}.pnm"

tmp_files = [FILE_TMP]

bytes = open("| jpegtopnm #{NAME}.jpg").read
open(FILE_TMP,"wb").write(bytes)

height = 440 #189
h_offset = 180
offset = 780 # - height

names = []

8.times do |i|
  out_name = "#{NAME}-%02d.gif" % i
  names << out_name
  tmp_files << out_name
  cmd = "|\
      pamcut -left=#{200+i*15} -top=#{offset + i*height} -width=600 -height=#{height - h_offset} #{FILE_TMP} \
    | pnmquant 256 \
    | pamtogif".gsub(/\s+/,' ')
  puts cmd
  cut = open(cmd).read
  open(out_name,"wb").write(cut)
end

#    | pamscale 0.5 \
#    | pnmpad -white -top 100 -bottom=100 \

system "gifsicle -d 25 --loop --colors 256 #{names.join(' ')} > #{NAME}.gif"

tmp_files.each {|fn| File.delete(fn)}

  
