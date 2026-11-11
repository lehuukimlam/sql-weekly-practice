-- Lam's FINAL query, submitted 2026-11-11. Formatting is as written in chat.

WITH grid AS 

(SELECT r.region_name,
	m.month_start
FROM regions r 
CROSS JOIN report_months m) 

, 


refunds_all AS 

(SELECT invoice_id, 
	SUM(refund_amount) refund_all 
FROM refunds 
GROUP BY invoice_id) 

,


accounts_region AS 

(SELECT a.account_id, 
	r.region_name 
FROM regions r 
LEFT JOIN accounts a ON r.region_id = a.region_id) 


,

invoice_full_info AS 

(SELECT a.region_name,
	i.invoice_id, 
	i.account_id,
	DATE_TRUNC('month',invoice_date) month_starting,
	i.amount, 
	i.status,
	r.refund_all
FROM invoices i 
LEFT JOIN refunds_all r ON i.invoice_id = r.invoice_id 
LEFT JOIN accounts_region a ON a.account_id = i.account_id

WHERE i.status = 'paid')

,

invoice_data AS 

(SELECT  g.month_start as month, 
	g.region_name,
	COALESCE(COUNT(DISTINCT i.invoice_id),0) invoices, 
	COALESCE(SUM(i.amount),0) billed, 
	COALESCE(SUM(i.refund_all),0) refunded, 
	ROUND(

	(COALESCE(SUM(i.refund_all),0) * 100) / NULLIF(COALESCE(SUM(i.amount),0),0)

,1) refund_pct,
	COALESCE(SUM(i.amount),0) - COALESCE(SUM(i.refund_all),0) net
	

FROM grid g 
LEFT JOIN invoice_full_info i
ON g.month_start = i.month_starting 
AND g.region_name = i.region_name

GROUP BY g.month_start, g.region_name)

SELECT  TO_CHAR(invoice_data.month, 'YYYY-MM') as month,
	region_name,
	invoices, 
	billed,
	refunded, 
	NULLIF(COALESCE(refund_pct,0),0) refund_pct,

	LAG(net) OVER (PARTITION BY region_name ORDER BY invoice_data.month) prev_net,

    	CASE 
        WHEN net IS NULL OR net = 0 THEN NULL
        WHEN LAG(net) OVER (PARTITION BY region_name ORDER BY invoice_data.month) IS NULL 	THEN NULL
        WHEN LAG(net) OVER (PARTITION BY region_name ORDER BY invoice_data.month) = 0 THEN 	NULL
        ELSE 
            ROUND(
                ((net - LAG(net) OVER (PARTITION BY region_name ORDER BY invoice_data.month)) * 100.0) / 
                LAG(net) OVER (PARTITION BY region_name ORDER BY invoice_data.month),
                1 
            )
    END as mom_pct,

	DENSE_RANK() OVER (PARTITION BY invoice_data.month ORDER BY COALESCE(refund_pct,0) DESC) refund_rank

FROM invoice_data

ORDER BY invoice_data.month ASC, refund_rank ASC, region_name ASC;
