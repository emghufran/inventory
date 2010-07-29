class ReportsController < ApplicationController
  before_filter :validate_authentication
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
  def fmt_in_out
     @results = ActiveRecord::Base.connection.execute("SELECT p.part_number PartNumber, p.description Description, p.Um,
SUM(CASE m.movement_type WHEN 'FMTIN' THEN m.quantity ELSE 0 END) FMTIN,
SUM(CASE m.movement_type WHEN 'FMTOUT' THEN m.quantity ELSE 0 END) FMTOUT,
b.location_code Locaion
FROM movements m
INNER JOIN products p ON p.id = m.part_id
INNER JOIN bunkers b ON b.id = from_id
WHERE (m.movement_type = 'FMTOUT'
OR m.movement_type = 'FMTIN') And 
DATE_FORMAT( m.updated_at,  '%Y-%m-%d' ) >= DATE_FORMAT( NOW( ) ,  '%Y-%m-01' )
GROUP BY p.part_number, p.description, p.um, b.location_code
Order By b.location_code")

    file_path = write_fmtinout_csv(@results)
    #render :text => "done"
    send_file file_path

  end
  def explosive_location_based
     @results = ActiveRecord::Base.connection.execute("Select pr.part_number,pr.description,received.Received,FMT.FMTIN, field.field_in,field.field_out,FMT.FMTOUT ,field.field_junk,field.used
from products pr
Left outer JOIN
(
SELECT p.id part_id,b.location, p.part_number, p.description, sum( jd.quantity ) AS field_out, sum( jd.sign_in ) AS field_in, sum( jd.consumed ) AS used, sum( jd.junk ) AS field_junk
FROM jobs j
INNER JOIN job_details jd ON j.id = jd.job_id
INNER JOIN products p ON jd.part_id = p.id
INNER JOIN bunkers b on jd.bunker_id = b.id and b.location='"+params[:location]+"'
WHERE j.status = 'Approved'
OR (
j.status = 'Closed'
AND DATE_FORMAT( j.updated_at, '%Y-%m-%d' ) >= DATE_FORMAT( NOW( ) , '%Y-%m-01' )
)
GROUP BY p.id, b.location
) field on field.part_id = pr.id
Left outer join
(
SELECT p.id part_id,p.part_number PartNumber, p.description Description, p.Um,
SUM(CASE m.movement_type WHEN 'FMTIN' THEN m.quantity ELSE 0 END) FMTIN,
SUM(CASE m.movement_type WHEN 'FMTOUT' THEN m.quantity ELSE 0 END) FMTOUT,
b.location Locaion
FROM movements m
INNER JOIN products p ON p.id = m.part_id
INNER JOIN bunkers b ON b.id = from_id and b.location = '"+params[:location]+"'
WHERE (m.movement_type = 'FMTOUT'
OR m.movement_type = 'FMTIN') And
DATE_FORMAT( m.updated_at,  '%Y-%m-%d' ) >= DATE_FORMAT( NOW( ) ,  '%Y-%m-01' )
GROUP BY p.id,p.part_number, p.description, p.um, b.location

)FMT on FMT.part_id = pr.id

left outer join

(
select part_id,SUM(received_quantity) Received from orders o
inner join bunkers b on o.bunker_id = b.id and b.location = '"+params[:location]+"'
Where o.status = 'received' and DATE_FORMAT( o.updated_at,  '%Y-%m-%d' ) >= DATE_FORMAT( NOW( ) ,  '%Y-%m-01' )
Group by part_id) received on received.part_id = pr.id
Where field.part_id is not null or FMT.part_id is not null or received.part_id is not null
order by pr.part_number")

    file_path = write_explosive_csv(@results)
    #render :text => "done"
    send_file file_path

  end

    def explosive_bunker_based
     @results = ActiveRecord::Base.connection.execute(" Select  pr.part_number,pr.description,received.Received,FMT.FMTIN, field.field_in,field.field_out,FMT.FMTOUT ,field.field_junk,field.used,
IFNULL(received.name,IFNULL(FMT.name,field.name)) Bunker
from products pr
Left outer JOIN
(
SELECT p.id part_id,b.name, p.part_number, p.description, sum( jd.quantity ) AS field_out, sum( jd.sign_in ) AS field_in, sum( jd.consumed ) AS used, sum( jd.junk ) AS field_junk
FROM jobs j
INNER JOIN job_details jd ON j.id = jd.job_id
INNER JOIN products p ON jd.part_id = p.id
INNER JOIN bunkers b on jd.bunker_id = b.id and b.location='khaskeili'
WHERE j.status = 'Approved'
OR (
j.status = 'Closed'
AND DATE_FORMAT( j.updated_at, '%Y-%m-%d' ) >= DATE_FORMAT( NOW( ) , '%Y-%m-01' )
)
GROUP BY p.id, b.name
) field on field.part_id = pr.id
Left outer join
(
SELECT p.id part_id,p.part_number PartNumber, p.description Description, p.Um,
SUM(CASE m.movement_type WHEN 'FMTIN' THEN m.quantity ELSE 0 END) FMTIN,
SUM(CASE m.movement_type WHEN 'FMTOUT' THEN m.quantity ELSE 0 END) FMTOUT,
b.name
FROM movements m
INNER JOIN products p ON p.id = m.part_id
INNER JOIN bunkers b ON b.id = from_id and b.location = 'khaskeili'
WHERE (m.movement_type = 'FMTOUT'
OR m.movement_type = 'FMTIN') And
DATE_FORMAT( m.updated_at, '%Y-%m-%d' ) >= DATE_FORMAT( NOW( ) , '%Y-%m-01' )
GROUP BY p.id,p.part_number, p.description, p.um, b.name

)FMT on FMT.part_id = pr.id

left outer join

(
select b.name,part_id,SUM(received_quantity) Received from orders o
inner join bunkers b on o.bunker_id = b.id and b.location = 'khaskeili'
Where o.status = 'received' and DATE_FORMAT( o.updated_at, '%Y-%m-%d' ) >= DATE_FORMAT( NOW( ) , '%Y-%m-01' )
Group by part_id,b.name) received on received.part_id = pr.id
Where field.part_id is not null or FMT.part_id is not null or received.part_id is not null

order by field.name,FMT.name,received.name")

    file_path = write_explosive_bunker_csv(@results)
    #render :text => "done"
    send_file file_path

  end
end