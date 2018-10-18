require 'nokogiri'
require 'open-uri'

#doc = Nokogiri::HTML(open("https://news.google.com/topics/#CAAqJggKIiBDQkFTRWdvSUwyMHZNRFZxYUdjU0FtVnVHZ0pWVXlnQVAB"))
#img  = doc.css("figure.AZtY5d.d7hoq.WylPad.QolzWc img [src]")

require 'openssl'
doc = Nokogiri::HTML(open('https://news.google.com/topics/CAAqJggKIiBDQkFTRWdvSUwyMHZNRFZxYUdjU0FtVnVHZ0pWVXlnQVAB', :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
title = doc.css('h2.OJMBqe').text
img = Array.new
article = Array.new
img  = doc.css('figure.AZtY5d.d7hoq.WylPad.QolzWc img') 
link = doc.css('div.ZulkBc.qNiaOd h3 a span').text
src = []
src = img.each { |l| p l.attr('src') }
link = link.split(',')
puts link[1]

#n = link.size
#$art = Array.new
#@article = Array.new
#a = 0
#while a<link.size
#   $art = link[a]['href']
#   a = a + 1
#end
#rate = entries.css('table')[0].css('tr')[1].css('td')[1].text
#@formattedrate = rate[6..8]
puts title

puts src


