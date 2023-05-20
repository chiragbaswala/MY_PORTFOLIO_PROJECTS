---Calculating number of users and Averages

--1) Tracking their Physical activities

SELECT 
	COUNT(DISTINCT Id) AS users_tracking_activity,
	AVG(TotalSteps) AS average_steps,
	AVG(TotalDistance) AS average_distance,
	AVG(Calories) AS average_calories

FROM
	bellabeat.dbo.daily_activity_cleaned

--2)Tracking Heart Rate

SELECT
	COUNT(DISTINCT Id) AS users_tracking_heartrate,
	AVG(Value) AS average_heartrate,
	MIN(Value) AS minimum_heartrate,
	MAX(Value) AS maximum_heartrate

FROM
	bellabeat.dbo.heartrate_seconds

--3)Tracking Sleep

SELECT
	COUNT(DISTINCT Id) AS users_tracking_sleep,
	AVG(TotalMinutesAsleep)/60.0 AS average_hours_asleep,
	MIN(TotalMinutesAsleep)/60.0 AS minimum_hours_asleep,
	MAX(TotalMinutesAsleep)/60.0 AS maximum_hours_asleep,
	AVG(TotalTimeInBed)/60.0 AS average_hours_inbed

FROM
	bellabeat.dbo.sleepDay

--4)Tracking Weight

SELECT
	COUNT(DISTINCT Id) AS users_tracking_weight,
	AVG(WeightKg) AS average_weightkg,
	MIN(WeightKg) AS minimum_weightkg,
	MAX(WeightKg) AS maximum_weightkg


FROM
	bellabeat.dbo.weight_cleaned
