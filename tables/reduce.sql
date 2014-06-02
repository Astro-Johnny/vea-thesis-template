.mode csv
.separator ','
.output results.reduce.csv
SELECT 
	impl,
	max(average) AS max_average,
	max(maximum) AS abs_max,
	min(minimum) AS abs_min
FROM
(
	SELECT
		impl,
		filename,
		AVG(t_nonmax) AS average,
		MAX(t_nonmax) AS maximum,
		MIN(t_nonmax) AS minimum
	FROM test1
	AS a
	GROUP BY impl, filename
) GROUP BY impl;
.quit
