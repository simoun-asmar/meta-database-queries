/*Question #1: 
The clients that have a client ID with a number between 0 and 1000 
are the earliest are most loyal Meta customers and need to be treated with
the best care possible.

Your manager wants to understand how the sales teams performed on these
customers over the last years.

What is the total revenue generated by Meta per year on clients that have
a client ID with a number between 0 and 1000?*/

SELECT
    EXTRACT(YEAR FROM dates) AS year,  -- Extract the year from the 'dates' column
    SUM(revenue) AS total_revenue  -- Calculate the total revenue for each year
    
FROM 
    meta_revenue

WHERE 
    SUBSTRING(client_id, 8, 20)::INTEGER BETWEEN 0 AND 1000  -- Convert a substring of 'client_id' to an integer and filter for values between 0 and 1000

GROUP BY 
    1  -- Group by the extracted year (first column in the SELECT list)
;

			 

/*Question #2: 
Your manager mentions that the client information of long term clients 
tends to not get updated regularly since the clients are already 
in the system for such a long time. He asks you to check this.

What is the average number of days since the client information was last updated
for clients that have a client ID with a number between 0 and 1000? 

You can calculate average number of days since the client was last updated
by comparing the current date and the last updated date.*/

SELECT  
    AVG(current_date - last_updated_date) AS avg_days_since_update  -- Calculate the average number of days between 'current_date' and 'last_updated_date'
      
FROM 
    meta_clients

WHERE 
    SUBSTRING(client_id, 8, 20)::INTEGER BETWEEN 0 AND 1000  -- Extract a portion of 'client_id', convert it to an integer, and filter for values between 0 and 1000
;

      

/*Question #3: 
Your manager wants to compare the sales performance
and the average number of days since the client was last updated
between the long term customers and all other customers.

What is the total revenue generated by Meta in 2022
and the average number of days since the client information was last updated 
for clients with a client ID with a number between 0 and 1000 versus all the other clients?*/

SELECT
    CASE 
        WHEN SUBSTRING(c.client_id, 8, 20)::INTEGER BETWEEN 0 AND 1000 
        THEN 'Long Term Clients'  -- Classify clients with 'client_id' in this range as 'Long Term Clients'
        ELSE 'Other Clients'  -- All other clients are labeled 'Other Clients'
    END AS customer_segment,
    
    ROUND(SUM(r.revenue)::NUMERIC, 2) AS total_revenue,  -- Calculate the total revenue and round to 2 decimal places
    
    ROUND(AVG(CURRENT_DATE - c.last_updated_date), 2) || ' days' AS avg_days_since_last_update  -- Calculate the average days since the last update and round to 2 decimal places
    
FROM 
    meta_clients AS c
JOIN 
    meta_revenue AS r
ON 
    c.client_id = r.client_id  -- Join 'meta_clients' and 'meta_revenue' on 'client_id'

WHERE 
    EXTRACT(YEAR FROM r.dates) = 2022  -- Filter for records from the year 2022

GROUP BY 
    1  -- Group by the customer segment (first column in the SELECT list)
;



/*Question #4: 
Count how many attendees each type of offsite has had over the last few years. 
Create the following offsite categories:
1. Drinks
2. Laser tag
3. Tennis
4. Mario Kart
5. Bubble Football
6. In case there are activities missing, populate the column with “No Offsite Activity” 
to make sure all columns are populated.

Make sure to clean up the data!*/

SELECT
    CASE 
        WHEN LOWER(off.offsite_activity) LIKE ('%la%') THEN 'Laser tag'  -- Categorize activities containing 'la' as 'Laser tag'
        WHEN LOWER(off.offsite_activity) LIKE ('%drinks%') THEN 'Drinks'  -- Categorize activities containing 'drinks' as 'Drinks'
        WHEN LOWER(off.offsite_activity) LIKE ('%bubble%') THEN 'Bubble Football'  -- Categorize activities containing 'bubble' as 'Bubble Football'
        WHEN off.offsite_activity = '' THEN 'No Offsite Activity'  -- If the activity is empty, label it 'No Offsite Activity'
        ELSE off.offsite_activity  -- Otherwise, keep the original activity name
    END AS offsite_category,
    
    COUNT(emp.first_name) AS attend  -- Count the number of employees attending the offsite event
    
FROM 
    meta_offsites AS off
JOIN 
    meta_employees AS emp
ON 
    off.sales_team = emp.sales_team  -- Join the offsites and employees tables based on sales_team

GROUP BY 
    1  -- Group by the offsite_category (the first column in the SELECT list)
;



/*Question #5: 
During the business reviews, the leadership wants to have a holistic overview of 
sales performance metrics and culture metrics in a single table for all sales teams.

Show the total revenue generated in 2021 and the number of offsite activities 
each sales team has had in one table for all sales teams. 

If offsite activities are missing, you can assume nothing happened 
and we should not count the activity.*/

SELECT
    off.sales_team AS sales_team,  -- Select the sales team from the meta_offsites table
    SUM(r.revenue) AS total_revenue,  -- Sum the total revenue for each sales team
    COUNT(DISTINCT off.offsite_activity)  -- Count the distinct offsite activities for each sales team

FROM 
    meta_revenue AS r
LEFT JOIN 
    meta_offsites AS off ON r.sales_team = off.sales_team  -- Left join meta_revenue with meta_offsites on sales_team

WHERE 
    EXTRACT(YEAR FROM r.dates) = 2021  -- Filter for revenue data from the year 2021
    AND off.year = 2021  -- Filter for offsite activities that occurred in 2021
    AND off.offsite_activity <> ''  -- Exclude rows where the offsite activity is empty

GROUP BY 
    1  -- Group the results by sales_team (the first column in the SELECT list)
;


/*Question #6: 
After sharing the table with your manager, he mentions that the leadership team 
also wants to include a metric about how clean each sales team keeps the client data.

Reuse the table generated in question 5 and add an additional column that 
shows the average number of days since the client data was updated for each sales team.*/

SELECT
    off.sales_team AS team,  -- Select the sales team from the meta_offsites table
    SUM(r.revenue) AS total_revenue,  -- Sum the total revenue for each sales team
    COUNT(DISTINCT off.offsite_activity) AS count_offsite_activity,  -- Count distinct offsite activities for each sales team
    AVG(CURRENT_DATE - c.last_updated_date) AS avg_days_since_update  -- Calculate the average number of days since the last update for clients

FROM 
    meta_revenue AS r
LEFT JOIN 
    meta_offsites AS off ON r.sales_team = off.sales_team  -- Left join to include all revenue even if no matching offsite activity
LEFT JOIN 
    meta_clients AS c ON c.client_id = r.client_id  -- Left join with meta_clients to get the last updated date for each client

WHERE 
    EXTRACT(YEAR FROM r.dates) = 2021  -- Filter revenue data for the year 2021
    AND off.year = 2021  -- Filter offsite activities that occurred in 2021

GROUP BY 
    1  -- Group by sales team (the first column in the SELECT list)
;
