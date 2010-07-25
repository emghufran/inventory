class ReportsController < ApplicationController
  def explosives_quantities
    @results = ActiveRecord::Base.connection.execute("SELECT b.name as bunker_name, SUM( p.net_weight * ui.quantity ) /1000 AS weight
    FROM bunkers b
    INNER JOIN update_inventories ui ON b.id = ui.bunker_id
    INNER JOIN products p ON ui.part_id = p.id
    GROUP BY b.name
    UNION 
	 select 'Field' as bunker_name, sum(p.net_weight * jd.quantity)/1000 as weight from jobs j
    inner join job_details jd on j.id = jd.job_id
    inner join products p on jd.part_id = p.id
    where j.status = 'Approved'")

  end
  
  def   
  SELECT * 
FROM jobs j
INNER JOIN job_details jd ON j.id = jd.job_id
INNER JOIN products p ON jd.part_id = p.id
WHERE j.status =  'Approved'
OR (
j.status =  'Closed'
AND DATE_FORMAT( j.updated_at,  '%Y-%m-%d' ) >= DATE_FORMAT( NOW( ) ,  '%Y-%m-01' )
)
end