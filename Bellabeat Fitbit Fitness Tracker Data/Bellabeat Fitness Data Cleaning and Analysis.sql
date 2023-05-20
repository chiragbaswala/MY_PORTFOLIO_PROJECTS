--DATA CLEANING

--Cleaning daily_activity

IF EXISTS(SELECT*
		FROM bellabeat.dbo.daily_activity_cleaned)

DROP TABLE bellabeat.dbo.daily_activity_cleaned

CREATE TABLE bellabeat.dbo.daily_activity_cleaned
(Id FLOAT, ActivityDate DATETIME2(7), TotalSteps INT, TotalDistance FLOAT, VeryActiveDistance FLOAT, ModeratelyActiveDistance FLOAT, 
LightActiveDistance FLOAT, SedentaryActiveDistance FLOAT, VeryActiveMinutes INT, FairlyActiveMinutes INT, 
LightlyActiveMinutes INT, SedentaryMinutes INT, Calories FLOAT)

INSERT INTO bellabeat.dbo.daily_activity_cleaned
(Id, ActivityDate, TotalSteps, TotalDistance, VeryActiveDistance, ModeratelyActiveDistance, 
LightActiveDistance, SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, 
LightlyActiveMinutes, SedentaryMinutes, Calories)


SELECT
	Id, 
	ActivityDate,
	TotalSteps,
	CAST(TotalDistance AS FLOAT) AS TotalDistance,
	CAST(VeryActiveDistance AS FLOAT) AS VeryActiveDistance, 
	CAST(ModeratelyActiveDistance AS FLOAT) AS ModeratelyActiveDistance, 
	CAST(LightActiveDistance AS FLOAT) AS LightActiveDistance, 
	CAST(SedentaryActiveDistance AS FLOAT) AS SedentaryActiveDistance, 
	VeryActiveMinutes, 
	FairlyActiveMinutes, 
	LightlyActiveMinutes, 
	SedentaryMinutes, 
	Calories

FROM
	bellabeat.dbo.daily_activity

--Cleaning WeightLogInfo

IF EXISTS (Select *
		FROM bellabeat.dbo.weight_cleaned)

DROP TABLE bellabeat.dbo.weight_cleaned

CREATE TABLE bellabeat.dbo.weight_cleaned
(Id FLOAT, Date DATETIME2(7), WeightKg FLOAT)

INSERT INTO bellabeat.dbo.weight_cleaned

SELECT
	Id,
	Date,
	WeightKg

FROM bellabeat.dbo.weightLogInfo

--ANALYZING DATA

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

--Determine time when users were mostly active

SELECT
	DISTINCT (CAST(ActivityHour AS TIME)) AS activity_time,
	AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_intensity,
	AVG(METs/10.0) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_METs

FROM
	bellabeat.dbo.hourly_activity AS hourly_activity

JOIN bellabeat.dbo.minuteMETsNarrow AS METs 

ON 
	hourly_activity.Id = METs.Id AND
	hourly_activity.ActivityHour = METs.ActivityMinute

ORDER BY
	average_intensity DESC

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