%w(yaml open-uri date).each { |dependency| require dependency }

$comics = YAML.load_file 'config/comics.yml'
$config = YAML.load_file 'config/config.yml'

@date = ARGV[0].nil? ? Date.today : Date.parse(ARGV[0])

def mkdir!(directory) 
  Dir::mkdir(directory) unless FileTest::directory?(directory) 
end

def parse val
  val.gsub!("{year}", @date.year.to_s)
  val.gsub!("{month}", @date.month.to_s)
  val.gsub!("{day}", @date.day.to_s)
  val
end

def get_comic(comic_cfg, dest)
  open(parse(comic_cfg["page"])) {|f|
    f.each_line { |line| 
      if line =~ /#{comic_cfg["indicator"]}/
#        p line
        line.match /.*(#{comic_cfg["regex"]}).*/
#        p $1
        open(dest, 'wb') do |file|
          file << open($1).read
        end
      end
    }
  }
end

def scheduled?(date, schedule)
  return true if schedule.to_s == '*'
  return schedule.to_s.include?(date.wday.to_s)
end

mkdir!($config["dest_dir"])
$comics.each do |comic,v|
  mkdir!("#{$config["dest_dir"]}/#{@date.to_s}")
  comic_cfg = $comics[comic]
  if scheduled?(@date, comic_cfg["schedule"])
    p "downloading: #{parse($comics[comic]["page"])}"
    get_comic($comics[comic], "#{$config["dest_dir"]}/#{@date.to_s}/#{comic}.#{comic_cfg["extension"]}")
  end
end
