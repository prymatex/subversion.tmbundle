# just a small to-html formater for what svn blame gives you.
# made to be compatible with the ruby version included
# in 10.3.7 (1.6.8) but runs also with 1.8
#
# copyright 2005 torsten becker <torsten.becker@gmail.com>
# no warranty, that it doesn't crash your system.

css = '
body {
   font-family: sans-serif;
   font-size: 11pt;
}

h1 {
   font-size: 18pt;
}

div.error {
   color: red;
   font-weight: bold;
}

a, a:visited, a:link {
   background-color: inherit;
   text-decoration: none;
   color: inherit;
}

a:hover, a:active {
   background-color: #a3c8ff; /*#8ab9ff;*/
}


table.blame {
   font-size: 9.5pt;
   padding: 1px;
   border-collapse: collapse;
}

table.blame th {
   text-align: left;
   background-color: #eee;
   border-bottom: 1px solid #999;
   padding: 3px;
   padding-bottom: 1px;
   padding-top: 1px;
   color: #666;
}

table.blame td {
   vertical-align: top;
}

td.linecol {
   background-color: #ddd;
   border-right: 1px solid #999;
   color: #888;
   text-align: right;
}

td.revcol, td.namecol {
   text-align: right;
   background-color: #f8f8f8;
   color: #888;
   border-right: 1px solid #ddd;
   padding-right: 2px;
   padding-left: 2px;
}

td.namecol {
   border-right: 1px solid #aaa;
}

td.codecol {
   font-size: 9pt;
   font-family: "Bitstream Vera Sans Mono", monospace;
   padding-left: 4px;
}

td.current_line {
   background-color: #e7e7e7;
}'



class NoMatchException < StandardError; end

def make_tm_link( filename, line )
   'txmt://open?url=file://' + filename + '&line=' + line.to_s
end


out       = ''
full_file = ENV['TM_FILEPATH']
file      = full_file.sub( /^.*\//, '')
current   = ENV['TM_LINE_NUMBER'].to_i
linecount = 1


begin
   out += '<table class="blame"> <tr> <th>line</th> <th>rev</th> <th>name</th> <th>code</th> </tr>'
   $stdin.each_line do |line|
      raise NoMatchException  unless line =~ /\s*(\d+)\s*(\w+)\s*(.*)/
      
      curr_add = (current == linecount) ? ' current_line' : ''
      
      out += '<tr><td class="linecol">'+ linecount.to_s +'</td>' +
                 '<td class="revcol'+ curr_add +'">' + $1 +'</td>' +
                 '<td class="namecol'+ curr_add +'">' + $2 +'</td>' +
                 '<td class="codecol'+ curr_add +'"><a href="' +
                     make_tm_link( full_file, linecount) +'">'+ $3 +
                 '</a></td></tr>'
      
      linecount += 1
   end
   
   out += '</table>'
   
rescue NoMatchException
   out = '<div class="error">ERROR: mhh, something with with the regex or svn must be wrong.</div>'
end


puts "<html>
<head>
<title>Subversion blame for '"+file+"'</title>
<style>
"+css+"
</style>
</head>

<body>
<h1>Subversion blame for '"+file+"'</h1>
<hr />
"+out+"
</body>

</html>"
