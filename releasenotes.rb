#!/usr/bin/env ruby
require 'optparse'

# Returns Hash of [ticketNumber => [commit1, commit2, ...]]
def getDiff(tag1, tag2, timestamps, unique)
  format = timestamps ? "%ci %s" : "%s"
  uniqpipe = unique ? "| uniq " + (timestamps ? "-s 25" : "") : ""
  return Hash[`git log --pretty="#{format}" #{tag1}...#{tag2} #{uniqpipe}`
    .split("\n")
    .map { |msg|
      ticket = msg.match(/DATA-(\d+)/)
      if ticket != nil
        [ticket[0], msg]
      end
    }
    .reject { |e| e == nil || e[1].match(/Merge (branch|pull request) .* (into|from)/) != nil }
    .group_by(&:first)
    .map { |k, a| [k, a.map(&:last)] }]
end

def getOptions(args)
  options = {:timestamps => false, :unique => false}
  OptionParser.new do |opts|
    opts.banner = "Usage: releasenotes <tag1> <tag2>"

    opts.on("-t", "--timestamps", "Include timestamps") do |t|
      options[:timestamps] = t
    end

    opts.on("-u", "--unique", "Unique commit messages") do |t|
      options[:unique] = t
    end

    opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
  end.parse!(args)

  return options
end

opts = getOptions(ARGV)

if ARGV.length < 2
  puts "Usage: releasenotes <tag1> <tag2> [options] (run --help for more info on options)"
else
  getDiff(ARGV[0], ARGV[1], opts[:timestamps], opts[:unique]).each { |ticket, notes|
    print(ticket + ":\n\n")

    notes.each { |n| print(" - " + n + "\n") }
    print("\n\n")
  }
end
