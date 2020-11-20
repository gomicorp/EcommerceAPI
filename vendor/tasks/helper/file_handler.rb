module Rake
  module Helper
    def add_ignore(*texts)
      root_context do
        ignore_list = File.readlines('.gitignore')
        File.open('.gitignore', 'a') do |f|
          texts.each do |text|
            if ignore_list.grep(/#{text}/i).empty?
              res_flag = 'Insert'.yellow
              f.puts text
            else
              res_flag = 'Skip'.blue
            end
            $stdout.puts "#{res_flag} \t.gitignore << #{text.yellow}"
          end
        end
      end
    end
    module_function :add_ignore


    def insert_line(path, regex, texts = [])
      root_context do
        File.open(path, 'r+') do |file|
          lines = file.each_line.to_a

          line_or_nil = lines.grep(regex)[0]
          index_of_line = lines.index(line_or_nil) + 1 || lines.length

          dup_lines = lines.dup
          texts.each_with_index do |text, i|
            line = "#{text}\n"
            if dup_lines[index_of_line + i] != line
              $stdout.puts "#{'Insert'.yellow} \t#{path}:#{index_of_line + i} \t#{text.yellow}"
              lines.insert index_of_line + i, line
            else
              $stdout.puts "#{'Skip'.blue} \t#{path}:#{index_of_line + i} \t#{text.yellow}"
            end
          end

          file.rewind
          file.write(lines.join)
        end
      end
    end
    module_function :insert_line
  end
end
