#!/usr/bin/env ruby

MIN_COMMIT_LENGTH = 20

$currentBranch = `git rev-parse --abbrev-ref HEAD`
$commitFileName = ARGV[0]

def checkTicketNumbers(branch, commit)
	if branch != commit
		puts "Ticket number of commit does not match the branch name (#{commit} != #{branch})"
		exit 1
	end
end

def rewriteCommitMsg(lines, ticketNumber, commitMsg)
	newCommitMsg = "[DATA-#{ticketNumber}] #{commitMsg}"
	lines[0] = newCommitMsg
	newFileContents = lines.join("")
	IO.write $commitFileName, newFileContents
	puts "Commit message corrected to: '#{newCommitMsg.delete("\n")}'"
end

if /(?:DATA|data)-(\d+)-.+/ =~ $currentBranch
	# Branch name starts with DATA-xxx, check commit message
	branchTicketNumber = $1 # Ticket number from branch

  commitFileLines = IO.readlines($commitFileName)
	commitMessage = commitFileLines[0]

	unless commitMessage.start_with?("Merge")
		# Check if commit message starts with [DATA-123] and is > 20 chars
		if /\[DATA-(\d+)\] .{20,}$/ =~ commitMessage
			# Commit message does match the format, check the ticket numbers match and error if not
			checkTicketNumbers($1, branchTicketNumber)
		else
			# Commit message does not match the format
			# If DATA is in lowercase or there are extra spaces, we can correct it
			if /\[(?:data|DATA)-(\d+)\] *(.{20,})$/ =~ commitMessage
				checkTicketNumbers($1, branchTicketNumber)

				# Valid ticket numbers, reformat the commit message
				rewriteCommitMsg(commitFileLines, $1, $2)
			else
				# Commit message does not start with the branch name, add it
				if commitMessage.length < MIN_COMMIT_LENGTH
					# Commit message too short, error..
					puts "Commit message must be > #{MIN_COMMIT_LENGTH} chars"
					exit 1
				end
				rewriteCommitMsg(commitFileLines, branchTicketNumber, commitMessage)
			end
		end
	end
end
