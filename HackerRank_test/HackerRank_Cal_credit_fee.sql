/** Calculate the monthly total balance by applying a fee based on the number of debit transactions:

    If fewer than 20 transactions or less than 1000 in debits, charge 5.
    If between 20 and 25 transactions, charge 3.
    If more than 25 transactions, no charge.

Table: transaction
|Field  |Type   |    
|dt     |date   |
|amount |number |
**/

with debite_tab as (
Select 
    month(dt) dmonth, 
    count(dt), 
    sum(amount*-1) as deb,
    case when (count(dt) < 20) or (sum(amount*-1) < 1000) then 5
        when count(dt) >= 20 and count(dt) <= 25 then 3
        when count(dt) > 25 then 0 
    end as fee
       
from transactions
where amount < 0
Group by month(dt)
),

credite_tab as (
    select 
        month(dt) as cmonth, 
        sum(amount) as cre  
    from transactions
where amount > 0
Group by month(dt)
)

select 
    sum(deb)+sum(fee)- coalesce(sum(cre),0) as total_result
from debite_tab 
left join on credite_tab on dmonth = cmonth;