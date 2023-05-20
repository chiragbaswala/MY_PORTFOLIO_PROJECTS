--Calculate the number of days each user tracked physical activity

SELECT
	DISTINCT Id,
	COUNT(ActivityDate) OVER (PARTITION BY Id) AS days_activity_recorded

FROM
	bellabeat.dbo.daily_activity_cleaned

ORDER BY
	days_activity_recorded DESC

--Calculate average time for each activity

SELECT
	ROUND(AVG(VeryActiveMinutes),2) AS AverageVeryActiveMinutes,
	ROUND(AVG(FairlyActiveMinutes),2) AS AverageFairlyActiveMinutes,
	ROUND(AVG(LightlyActiveMinutes)/60,2) AS AverageLightlyActiveHours,
	ROUND(AVG(SedentaryMinutes)/60,2) AS AverageSedentaryHours

FROM
	bellabeat.dbo.daily_activity_cleaned