#! /usr/bin/env ruby

require 'optparse'

#get_seqs.rb  -c extracted_seqs/seqs_coords.txt -g $genome -f 150
#################################################################################################
## METHODS
#################################################################################################
def load_coords(input)
	coords = []
	File.open(input).each do |line|
		line.chomp!
		fields = line.split("\t")
		fields[2] = fields[2].to_i - 1
		fields[3] = fields[3].to_i - 1
		coords << fields
	end	
	return coords
end

def load_fasta(input)
	seqs = {}
	name = nil
	seq = ''
	File.open(input).each do |line|
		line.chomp!
		if line =~ /^>/ 
			if !name.nil?
				seqs[name] = seq
				seq=''
			end
			name = line.gsub('>', '')
		else
			seq << line
		end
	end
	seqs[name] = seq
	return seqs
end

def get_complementary(string)
        comp = ''
        equivalences = {
                'n' => 'n',
                'a' => 't',
                't' => 'a',
                'c' => 'g',
                'g' => 'c'
        }
        string.downcase.each_char do |nt|
                comp << equivalences[nt]
        end
        return comp
end

def get_seqs(coords, fasta, flank)
	seqs = []
	coords.each do |id, chr, start, stop, strand|
		query = fasta[chr]
		f_start = start -1 - flank
		f_start = 0 if f_start < 0
		f_stop = stop +1 + flank
		f_stop = query.length-1 if f_stop > query.length-1
		if !query.nil?
			if strand == '-'
				seq_string = get_complementary(query[f_start..f_stop]).reverse
			else
				seq_string = query[f_start..f_stop] 
			end
			seqs << ["#{id}_#{chr}-#{start}-#{stop}_f#{flank}", seq_string]
		end
	end
	return seqs
end

#################################################################################################
## INPUT PARSING
#################################################################################################
options = {}

optparse = OptionParser.new do |opts|
        options[:input] = nil
        opts.on( '-c', '--coords_file PATH', 'Table with coords' ) do |string|
            options[:input] = string
        end

        options[:fasta] = nil
        opts.on( '-f', '--fasta_file PATH', 'Fasta which get sequences' ) do |string|
            options[:fasta] = string
        end

        options[:flanking_region] = 0
        opts.on( '-r', '--flanking_region INTEGER', 'Take extra nucleotides by each flanking region' ) do |string|
            options[:flanking_region] = string.to_i
        end


        # Set a banner, displayed at the top of the help screen.
        opts.banner = "Usage: #{__FILE__} options \n\n"

        # This displays the help screen
        opts.on( '-h', '--help', 'Display this screen' ) do
                puts opts
                exit
        end

end # End opts

# parse options and remove from ARGV
optparse.parse!


###########################################################################################################
## MAIN
##########################################################################################################
coords = load_coords(options[:input])
fasta = load_fasta(options[:fasta])
seqs = get_seqs(coords, fasta,  options[:flanking_region])
seqs.each do |id, seq|
	puts ">#{id}\n#{seq}"
end
