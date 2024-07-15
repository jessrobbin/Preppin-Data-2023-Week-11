with coord as (
Select
*
,address_long/(180/PI()) as long1
,address_lat/(180/PI()) as lat1
,branch_long/(180/PI()) as long2
,branch_lat/(180/PI()) as lat2
, long2 - long1 as long_diff
from pd2023_wk11_dsb_customer_locations as customers 
cross join pd2023_wk11_dsb_branches as branches
)
, distances as (
select
 customer
 , branch
, round((3963*acos( (sin(lat1) * sin(lat2))+ cos(lat1) * cos(lat2) * cos(long_diff))), 2) dist_miles
, rank () over (partition by customer order by dist_miles asc) as dist_rank
from coord
)
select
  customer
, branch as nearest_branch
, dist_miles
, rank() over (partition by branch order by dist_miles) as Customer_Priority
from distances
where dist_rank =  1

