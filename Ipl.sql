use IPL

select* from IPL$
	

select count(*) from Ball
select count(*) from IPL$


--1. matches played per season
--step 1 --extract year

select year,count(year) as matches_played from
(select*, DATEPART(year,date) as year
from IPL$)a
group by year
order by year

--2 Most player of the match
select player_of_match, count(player_of_match) as Number_of_winnings
from IPL$
group by player_of_match
order by Number_of_winnings desc

--3 Most player of match per season


select* from(
select*,rank() over(partition by year order by Times_won desc) rnk from(
select year, player_of_match,count(player_of_match) as Times_won from(
select*, DATEPART(year,date) as year
from IPL$)a
group by year,player_of_match)b)c
where rnk=1


--4 Most wins by any team and calculate top 3 teams of ipl
select * from (
select*,rank() over(order by No_of_times_won desc) as rnk from(
select winner,count(winner) as No_of_times_won
from IPL$
group by winner )a)b
where rnk in (1,2,3)

--5 top 5 venues where matches are played

select* from(
select*, rank() over(order by Matches_played desc)as rnk from(
select venue , count(venue) as Matches_played
from IPL$
group by venue)a)b
where rnk between 1 and 5


--6 Most runs by any batsman

select batsman,sum(batsman_runs) as total_runs
from Ball
group by batsman
order by total_runs desc


-- 7 Percentage of runs scored by each player in ipl

select* from(
select*,rank() over(order by Percentage_contribution desc) as rnk from(
select batsman, (total_runs/239945)*100 as Percentage_contribution from (
select batsman,sum(batsman_runs) as total_runs
from Ball
group by batsman)a
group by batsman,total_runs
having sum(total_runs) !=0)b)c
where rnk between 1 and 5
 
--8 Most sixes by any batsman
select batsman, count(batsman_runs) as No_of_6_scored
from Ball
where batsman_runs=6
group by batsman
order by  No_of_6_scored desc


--9 Most fours by any batsman
select batsman, count(batsman_runs) as No_of_6_scored
from Ball
where batsman_runs=4
group by batsman
order by  No_of_6_scored desc

--10  3000 runs club , highest strike rate
select* from(
select batsman,sum(batsman_runs) as total_runs,count(batsman_runs) as total_balls_faced , round(sum(batsman_runs)/count(batsman_runs)*100 ,0)as Strike_rate
from Ball
group by batsman)a
where total_runs>=3000
order by Strike_rate desc

--11 Total wins by team

select*,rank() over(partition by year1 order by wins desc)as rnk from(
select datepart(year,date) as year1, winner,count(winner) as wins
from IPL$
group by datepart(year,date),winner)a

--12...Does toss winning affects the result

select count(*) as Total_matches,sum(Toss_winning_status)as Won_who_won_toss from (
select team1,team2,toss_winner,winner,
case when winner=toss_winner then 1 else 0
end as Toss_winning_status
from IPL$)a

--calculate percentage

select count(*) as Total_matches,sum(Toss_winning_status)as Won_who_won_toss ,round((sum(Toss_winning_status)*1.0/count(*))*100,0) as Percentage_of_winning  from (
select team1,team2,toss_winner,winner,
case when winner=toss_winner then 1 else 0
end as Toss_winning_status
from IPL$)a


--13 Lowest economy rate for bowler who has bowled atleat 50 overs

select bowler, (count(bowler)/6) as over_bowled,count(batsman_runs) as runs_conceded, cast(count(batsman_runs)/(count(bowler)/6) as decimal(4,2)) as economy
from Ball
group by bowler
having (count(bowler)/6) != 0 
order by economy 

select bowler, (count(bowler)/6) as over_bowled,count(batsman_runs) as runs_conceded, cast(count(batsman_runs)/(count(bowler)/6) as decimal(4,2)) as economy
from Ball
group by bowler
having (count(bowler)/6) >50
order by economy 


--14 Average score of  each team per season