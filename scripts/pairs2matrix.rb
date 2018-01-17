#! /usr/bin/env ruby


pairs = {}

File.open(ARGV[0]).each do |line|
	line.chomp!
	gen, prot = line.split(' ')
	query = pairs[gen]
	if query.nil?
		pairs[gen] = [prot]
	else
		query << prot if !query.include?(prot)
	end
end

gens = pairs.keys
prots = pairs.values.flatten.uniq

File.open(ARGV[1], 'w') {|f|
	f.puts prots.join("\t")
	gens.each do |gen|
		line = [gen]
		strain_prots = pairs[gen]
		prots.each do |prot|
			if strain_prots.include?(prot)
				line << 1
 			else
				line << 0
			end
		end
		f.puts line.join("\t")
	end
}
