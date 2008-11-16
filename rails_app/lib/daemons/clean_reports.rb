RAILS_ENV='production'

require File.dirname(__FILE__) + "/../../config/environment"
require 'open-uri'
require 'json'

entries = File.read('../iphone_android.log').split(/^--$/)

entries.each do |entry|
  created = Time.parse(entry[/(2008-11-[\d\s:]+?)\) \[P/,1])
  ptext = entry[/Parameters: (.+)$/,1]
  ptext.gsub!(/\#<.*?>/,'nil') #<File:/tmp/CGI.12231.10>  
  params = eval(ptext)
  source = params['format']=='iphone' ? 'IPH' : 'ADR'
  latlon, location_accuracy = params['reporter']['latlon'].split(':')
  p created
  
  if report = Report.find(:first, :conditions => ['source = ? AND (created_at BETWEEN ? AND ?) AND rating=? AND location_accuracy=? AND polling_place_name IS NULL', source, created-3.seconds, created+3.seconds, params['report']['rating'], location_accuracy ] )
    if params['polling_place'] && params['polling_place']['name'] && report.reporter.uniqueid==params['reporter']['uniqueid']
      report.update_attribute(:polling_place_name, params['polling_place']['name']) 
      puts "set polling place for #{report.id} to #{report.polling_place_name}"
    end
    next
  end

  # # puts "finding reporter #{params['reporter'].inspect}"
  # if reporter = source == 'IPH' ? IphoneReporter.update_or_create(params['reporter']) : AndroidReporter.update_or_create(params['reporter'])
  #   # reporter.location = Location.geocode(latlon) if reporter.location.nil?
  #   # reporter.profile_location = reporter.location.address if reporter.location && reporter.profile_location.blank?
  #   # reporter.profile_location = params['reporter']['latlon'] if reporter.profile_location.blank?
  #   # reporter.save
  #   report = reporter.reports.create(params['report'].merge(:latlon => params['reporter']['latlon'], :created_at => created ))
  #   p report
  # end
  
end


