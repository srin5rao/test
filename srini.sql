/* Name-Srinivas Rao Molugu CSU ID- 2824387 */
create database league;
use league;
create table team(team_id int primary key,team_name varchar(20),wins int,losses int,draws int,netrunrate float);
create table location(location_id int primary key,stadium varchar(50),city varchar(20),zip_code varchar(10));
create table player(player_id int primary key,name varchar(10),team_id int,playing_position varchar(20),
constraint fk_team_id FOREIGN KEY (team_id) REFERENCES team(team_id));
create table game(
game_id int primary key,team1_id int,team2_id int,mvp_player_id int,location_id int,date date,team1_score int,team2_score int,
constraint fk_team1_id FOREIGN KEY (team1_id) REFERENCES team(team_id),
constraint fk_team2_id FOREIGN KEY (team2_id) REFERENCES team(team_id),
constraint fk_mvp_player_id FOREIGN KEY (mvp_player_id) REFERENCES player(player_id),
constraint fk_location_id FOREIGN KEY (location_id) REFERENCES location(location_id)
);
insert into team values(1,"Super Strikers",2,0,0,1.2);
insert into team values(2,"Thunder boosters",1,1,0,0.67);
insert into team values(3,"Falcon Dynamiktes",0,2,0,-0.98);
insert into location values(1,"NYC stadium","New York",123456);
insert into location values(2,"CA stadium","California",654321);
insert into player values(1,"alex hales",1,"batsman");
insert into player values(2,"ian bell",2,"batsman");
insert into player values(3,"christain",3,"batsman");
insert into player values(4,"dan brown",1,"bowler");
insert into player values(5,"elliotal",2,"bowler");
insert into player values(6,"faulkner",3,"bowler");
insert into game values(1,1,2,2,1,"2021-11-30",200,150);
insert into game values(2,2,3,6,1,"2021-12-01",168,167);
insert into game values(3,1,3,1,2,"2021-12-02",210,90);

/* showing tables */

select * from player;
select * from team;
select * from location;
select * from game;

/*5 queries
1.Display team name with top wins
2.Display team names and their winning ratio
3.Display names of mvp players 
4.Display city in which most number games played
5. Display total scores of each team

SOLUTIONS:
*/

/* 1 */ select team_name from team where wins=(select max(wins) from team);
/* 2 */ select team_name,wins/(wins+losses+draws) from team;
/* 3 */ select name from player where player_id in (select mvp_player_id from game);
/* 4 */ select city from location where location_id= (select location_id from
(select location_id,max(temp.cnt) from (select location_id,count(*) as cnt from game group by location_id)temp)temp1);
/* 5 */ select team,sum(score)
from (
select team1_id as team,team1_score as score from game
union
select team2_id as team,team2_score as score from game)temp group by team;


/* Procedure for showing maximum wins and team  */
DELIMITER &&  
CREATE PROCEDURE display_max_wins (OUT name varchar(20),OUT highestwins INT)  
BEGIN  
	SELECT MAX(wins) into highestwins  FROM team;
    select team_name into name from team where wins=highestwins;   
END &&  
DELIMITER ;  
CALL display_max_wins(@n,@w);  
select @n,@w;

/* Procedure for showing names of players user specified starting letter in their names */

DELIMITER &&  
CREATE PROCEDURE display_player_names (IN start char)  
BEGIN  
	select name from player where name like concat(start,"%");  
END &&  
DELIMITER ;

call display_player_names('a');

/* trigger -1  - used in location table for modifying zipcode less than 6 digits into 100000*/

DELIMITER //  
Create Trigger before_operation_location   
BEFORE INSERT  ON  location FOR EACH ROW  
BEGIN  
IF NEW.zip_code < 100000 THEN SET NEW.zip_code = 100000;  
END IF;  
END //  

insert into location values(3,"SF stadium","san Fransicho",54321);

select * from location;

/* TRIGGER -2 - used for counting number of insertions of location table*/

Set @count=0;
delimiter $$
CREATE TRIGGER Count_tupples 
             AFTER INSERT ON location 
FOR EACH ROW
BEGIN
SET @count = @count + 1;
END $$


insert into location values(4,"AB stadium","AB Valley",54321);
select @count;

select * from location;





