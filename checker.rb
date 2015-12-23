require 'open3'

servers = File.open('servers_list.txt').read
time_min = nil
result = nil 

servers.each_line do |ip_addr|
  ip_addr.delete! "\n"
  Open3.popen3("ping #{ip_addr}") do |stdin, stdout, stderr, wait_thr|
    4.times do
      unless stdout.gets.nil?
        line = stdout.gets
        if line.include? "time="
          time = line[line.index('time=')..-1][/\d+/].to_i
          puts "server=#{ip_addr}, timeout=#{time}"
          if time_min.nil? || time < time_min
            time_min = time 
            result = ip_addr
          end
        end
      end
    end
  end
end

puts "\n-----------BEST RESULT-----------"
puts "server=#{result}, timeout=#{time_min}."

