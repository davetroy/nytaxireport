RAILS_ENV='production'

require File.dirname(__FILE__) + "/../config/environment"
require 'fastercsv'
FasterCSV.open("/Users/davetroy/Development/votereport/TimeView/reports.csv", "w", :col_sep => '|') do |csv|
  Report.find(:all, :conditions => 'location_id IS NOT NULL AND created_at BETWEEN "2008-11-4 05:00" AND "2008-11-5 05:00"', :order => 'created_at', :include => :location).each do |report|
    report_time = TimeZone['Eastern Time (US & Canada)'].utc_to_local(report.created_at).strftime("%B %d %H:%M:%S")
    cols = [report.location.latitude,report.location.longitude,report_time,report.source,report.wait_time]
    # cols = report.attributes.values.concat([report.location.latitude,report.location.longitude])
    # cols = cols.map { |c| c.is_a?(String) ? c.gsub(/[\n\r]+/,'') : c }
    csv << cols
  end
end