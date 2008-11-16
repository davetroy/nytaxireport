RAILS_ENV='production'

require File.dirname(__FILE__) + "/../../config/environment"
require 'open-uri'
require 'json'

File.open('pull.txt') do |f|
  while (tid = f.gets)
    begin
      tid.chomp!.strip!
      next if tid[/^$/] || Report.find_by_uniqueid(tid)
      url = "http://twitter.com/statuses/show/#{tid}.json"
      p url
      entry = JSON.parse(open(url).read)

      user_info = entry.delete('user')
      {'id' => 'uniqueid', 'location' => 'profile_location'}.each do |k,v|
        user_info[v] = user_info.delete(k)
      end
      next unless reporter = TwitterReporter.update_or_create(user_info)
      p reporter

      report = reporter.reports.create(:text => entry['text'],
                          :uniqueid => entry['id'],
                          :created_at => entry['created_at'],
                          :updated_at => entry['updated_at'])
      p report
      sleep 3
    rescue Exception => e
      puts e.message
      sleep 1800 and retry if e.message[/400/]
      next
    end
  end
end
