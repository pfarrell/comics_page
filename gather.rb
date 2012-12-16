%w(yaml open-uri date).each { |dependency| require dependency }

$comics = YAML.load_file 'config/comics.yml'
$config = YAML.load_file 'config/config.yml'

@date=Date.today

def parse val
  val.gsub!("{year}", @date.year.to_s)
  val.gsub!("{month}", @date.month.to_s)
  val.gsub!("{day}", @date.day.to_s)
  val
end

$comics.each do |comic,v|
  p parse($comics[comic]["page"])
  open(parse($comics[comic]["page"])) {|f|
    f.each_line { |line| 
      if line =~ /#{$comics[comic]["indicator"]}/
#        p line
        line.match /.*(#{$comics[comic]["regex"]}).*/
#        p $1
        open("public/#{comic}-#{@date.to_s}.#{$comics[comic]["extension"]}", 'wb') do |file|
          file << open($1).read
        end
      end
    }
  }
end
