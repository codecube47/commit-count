require 'github_api'

print "Enter github users:  "
users = gets

# get comments from user list
def getCommits(users)
	user_commits = {}
	# Check athentications
	github = Github.new :oauth_token => 'b3f4377813d9c76fe54b16f1349eae511da3814c'
	print "Connecting and getting data please wait for a while ."

  users.split(',').map(&:strip).each do |user|
		begin
		  	# Get user repos
			repos = github.repos.list user: user
		rescue Github::Error::NotFound
           puts "No user exist"
		rescue Exception
		  # handle everything else
		end

    print "."
	total_commits=0
	repos.each do |repo|    
	    repo_total=0
		commit_activity = github.repos.stats.commit_activity user: user, repo: repo.name	
		commit_activity.each do |activity|
		     repo_total+=activity.total
		end
	  total_commits+=repo_total
	end
	user_commits["#{user}"] = "#{total_commits}"
  end
  puts""
  puts"========================="
  user_commits = user_commits.sort_by {|k,v| v}.reverse
  user_commits.each {|k,v| puts "#{k}: #{v}"}

end


if users.to_s.strip.length == 0 
	print "No user name entered please try again:  "
	users = gets
  if users.to_s.strip.length == 0 
	print "You have tried twise System shutdown:  "
  else
	getCommits(users)
  end
else
	getCommits(users)
end



