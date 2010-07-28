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
  
  def job_summary
    #Issue Date,Truck,Part No.,Description,Total Quantity,Consumed,Junk,Signed-In,Return Date,Well name,Engineer
  	 
  	 @results = ActiveRecord::Base.connection.execute("SELECT j.created_at, j.truck, p.part_number, p.description, 
  	 sum(quantity) as total_quantity, sum(jd.consumed) as consumed_total, sum(jd.junk) as junk_total,
  	 sum(jd.sign_in) as signin_total, jd.updated_at as closing_date, j.well, j.engineer
	 FROM jobs j
    INNER JOIN job_details jd ON j.id = jd.job_id
    INNER JOIN products p ON jd.part_id = p.id
    WHERE j.status =  'Approved' OR ( j.status =  'Closed' AND 
    DATE_FORMAT( j.updated_at,  '%Y-%m-%d' ) >= DATE_FORMAT( NOW( ) ,  '%Y-%m-01' ) )
    GROUP BY p.id, j.id
    ORDER BY j.id")
    
    file_path = write_job_summary_csv(@results)
    #render :text => "done"
    send_file file_path

  end 
end