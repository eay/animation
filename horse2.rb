#!/usr/bin/env ruby
#
NAME = "horse2"
FILE_TMP = "#{NAME}.pnm"

tmp_files = [FILE_TMP]

bytes = open("| jpegtopnm #{NAME}.jpg").read
open(FILE_TMP,"wb").write(bytes)

height = 662 # 440 #189
h_offset = 180
offset = 780 # - height
width = 820
left = 380

names = []

8.times do |i|
  out_name = "#{NAME}-%02d.gif" % i
  names << out_name
  tmp_files << out_name
  cmd = "|\
      pamcut -left=#{left} -top=#{offset + i*height} -width=#{width} -height=#{height - h_offset} #{FILE_TMP} \
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

  
