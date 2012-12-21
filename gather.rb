%w(yaml open-uri date ./lastn).each { |dependency| require dependency }

$comics = YAML.load_file 'config/comics.yml'
$config = YAML.load_file 'config/config.yml'

@date = ARGV[0].nil? ? Date.today : Date.parse(ARGV[0])

def mkdir!(directory) 
  Dir::mkdir(directory) unless FileTest::directory?(directory) 
end

def parse_date cfg
  val=cfg["uri"]
  val.gsub!("{year}", @date.year.to_s)
  val.gsub!("{month}", "0#{@date.month.to_s}".last(2))
  val.gsub!("{day}", "0#{@date.day.to_s}".last(2))
  val
end

def parse_offset cfg, date
  arr=cfg["key"].split(',')
  offset=arr[1].to_i - (Date.parse(arr[0]) - date).to_i  
  uri=cfg["uri"].gsub("{offset}", offset.to_s)
  uri
end

def find_comic(comic_cfg, host_page, dest)
  open(host_page) {|f|
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

def get_comic(uri, dest)
  open(dest, 'wb') do |file|
    file << open(uri).read
  end
end

def scheduled?(date, schedule)
  return true if schedule.to_s == '*'
  return schedule.to_s.include?(date.wday.to_s)
end

mkdir!($config["dest_dir"])

mkdir!("#{$config["dest_dir"]}/#{@date.to_s}")

$comics["date"].each do |comic,comic_cfg|
  next if File.exists?("#{$config["dest_dir"]}/#{@date.to_s}/#{comic}.#{comic_cfg["extension"]}")
  if scheduled?(@date, comic_cfg["schedule"])
    p "downloading: #{parse_date(comic_cfg)}"
    find_comic(comic_cfg, parse_date(comic_cfg), "#{$config["dest_dir"]}/#{@date.to_s}/#{comic}.#{comic_cfg["extension"]}")
  end
end

#$comics["offset"].each do |comic,comic_cfg|
#  if scheduled?(@date, comic_cfg["schedule"])
#    p "downloading: #{parse_offset(comic_cfg, @date)}"
#    find_comic(comic_cfg, parse_offset(comic_cfg, @date), "#{$config["dest_dir"]}/#{@date.to_s}/#{comic}.#{comic_cfg["extension"]}")
#  end
#end

$comics["download"].each do |comic,comic_cfg|
  next if File.exists?("#{$config["dest_dir"]}/#{@date.to_s}/#{comic}.#{comic_cfg["extension"]}")
  if scheduled?(@date, comic_cfg["schedule"])
    p "downloading: #{parse_date(comic_cfg)}"
    get_comic(parse_date(comic_cfg), "#{$config["dest_dir"]}/#{@date.to_s}/#{comic}.#{comic_cfg["extension"]}")
  end
end
