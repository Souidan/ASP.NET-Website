


-----1 Sign up by providing my email, password, preffered game genre and the type of my membership--
--(normal user, verified reviewer or a development team).
CREATE PROC InsertNormalUser( 
@email varchar(100),
@user_password varchar(100),
@preferred_genre varchar(100),
@fname varchar(100),
@lname varchar(100),
@birthdate date
)

AS
 INSERT INTO Members Values (@email,@user_password,@preferred_genre)
 Insert into Normal_Users VALUES(@email,@fname,@lname,@birthdate) 
go

CREATE PROC InsertDevelopmentTeam
(@email varchar(100),@password varchar(100)
,@preferred_genre varchar(100),@team_name varchar(100),
@company_name varchar(100),@formation_date date)
AS
Insert into Members values (@email,@password,@preferred_genre)
Insert Development_Teams(email,team_name,company_name,formation_date) values (@email,@team_name,@company_name,@formation_date)
go



CREATE PROC InsertVerified_Reviewers
(@email varchar(100),@password varchar(100),
@preferred_genre varchar(100),@years int,
@fname varchar(100),@lname varchar(100))
AS
Insert into Members values (@email,@password,@preferred_genre)
Insert Verified_Reviewers(email,years_of_experience,first_name,last_name) values (@email,@years,@fname,@lname)
go

--2 Search by name for different games, conferences, communities, verified reviewers and development teams.

CREATE PROC SearchGame
(@name varchar(100))
AS
Select *
FROM Games where @name=game_name
go


CREATE PROC SearchConference(@name varchar(100))
AS
Select *
FROM Gaming_Conferences where @name=conference_name
go


CREATE PROC SearchCommunities(@name varchar(100))
AS
Select *
FROM Communities where @name=community_name
go

CREATE PROC SearchReviewer(@name varchar(100))
AS
Select *
FROM Verified_Reviewers where @name=first_name or @name=last_name
go

CREATE PROC SearchTeam(@name varchar(100))
AS
Select*
From Development_Teams where @name=team_name
go


--3 View a game and preview its information which includes its name, release date, age limit, the team
--who devloped it (if any), screenshots, videos, and a list of reviews written for that game. For a
--strategy game, I should be able to see if it’s real-time or not. For an action game, I should see
--its sub-genre. For a sport game, I should see its type. For an RPG game, I should see if it has a
--storyline or not, and if it has the option of PvP or not.

CREATE PROC ViewGame (@game_id int)
AS 
Select g.game_name,g.release_date,g.age_limit,dt.team_name,s.screenshot_path,v.video_path,r.review_text,st.is_real_time,AG.sub_genre,SG.sports_type,rpg.has_story_line,rpg.is_pvp
From Games g , Development_Teams_develops_Games d
			 , Development_Teams dt
			 , Game_Screenshots s 
			 , Game_Videos v 
			 , Reviews r
			 , Strategy_Games st 
			 , Action_Games AG 
			 , Sport_Games SG
			 , RPG_Games rpg
where d.game_id=g.game_id and dt.email=d.development_team_email and s.game_id=g.game_id and v.game_id=g.game_id and r.game_id=g.game_id and st.game_id=g.game_id and AG.game_id=g.game_id and SG.game_id=g.game_id and rpg.game_id=g.game_id and  g.game_id=@game_id
go

--4 Rate a game based on the following criteria: graphics, interactivity, uniqueness, and level design.

CREATE PROC RateGame(@game_id int,@member_email varchar(100),
@graphics int,@interactivity int,
@uniqueness int,@level_design int)
AS
INSERT INTO Ratings values(@interactivity,@uniqueness,@level_design,@graphics,@game_id,@member_email)
go

--5 View the overall rating of a game where the overall rating is calculated as the average of ratings
--provided by members of the network for that game.


CREATE PROC ViewRating(@game_id int)
AS
select avg(graphics) AS 'Graphics Rating',avg(level_design) AS 'Level Design Rating',avg(uniqueness) AS 'Uniqueness',avg(interactivity) AS 'Interactivity'
from Ratings r
where r.game_id=@game_id
go

--6 View a list of reviews about the games that I have rated, sorted by the years of experience of the
--reviewer.


CREATE PROC RatedGamesReviews
(@email varchar(100))
AS
select re.review_text
from Ratings r,Reviews re,Verified_Reviewers v
where r.game_id=re.game_id and r.member_email=@email and v.email = re.verified_reviewer_email
order by v.years_of_experience DESC
go


--7 View a conference and preview its name, when and where it is held. Also, I should be able to
--view the list of the development teams that presented their games in that conference, along with
--their game names. Moreover, I should be able to view the list of games that were debuted in that
--conference, as well as the list of reviews on that conference.

CREATE PROC ConferenceDetails(@conf_id int)
AS
select C.conference_name,C.conference_start_date,C.conference_end_date,C.venue from Gaming_Conferences C
where C.game_conference_id=@conf_id
select G.game_id,G.game_name,D.email,D.company_name,D.team_name from Game_presented_in_Conference GC,Games G,Development_Teams D,Development_Teams_develops_Games DG
where G.game_id=GC.game_id and DG.game_id = GC.game_id and D.email=DG.development_team_email  and GC.conference_id=@conf_id
select G1.game_id,G1.game_name from Games G1
where G1.conference_released_id = @conf_id
select R.review_id,R.review_text,R.verified_reviewer_email from Reviews R,Gaming_Conference_Reviews GR
where R.review_id=GR.game_conference_review_id and GR.conference_id=@conf_id
go


--8 Add a conference to my list of attended conferences.


CREATE PROC AttendConf(@email varchar(100),@conf_id int)
AS
INSERT INTO Game_Conference_attended_by_Member Values(@conf_id,@email)
go


--9 Add a conference review to a conference that I have attended.

CREATE PROC AddConfReview(
@email varchar(100),
@conf_id int,
@review_text varchar(1000))
AS
Declare @counter int
select @counter=count(*) from Game_Conference_attended_by_Member
where member_email=@email and game_conference_id=@conf_id
if(@counter > 0)
begin
INSERT into Gaming_Conference_Reviews values(@review_text,@email,@conf_id)
end
go

--10 Delete a conference review that I have written.

CREATE PROC DeleteConferenceReview(@email varchar(100),@review_id int)
AS
Declare @counter int
SELECT @counter=count(*) FROM Gaming_Conference_Reviews
where member_email=@email and @review_id=game_conference_review_id
if(@counter>0)
DELETE FROM Comments_on_Gaming_Conference_Reviews where gaming_conference_review_id=@review_id
DELETE FROM Gaming_Conference_Reviews where game_conference_review_id=@review_id
go


--11 Join a community.

Create PROC joinCommunity(@email varchar(100),@community_id int)
AS
INSERT INTO Community_has_Members values(@community_id,@email)
go

--12 View a community that I have joined and preview its name, description and list of members of that
--community. Also I should be able to view the list of topics posted on that community.

Create Proc viewCommunity(@community_id int, @email varchar(100))
AS
declare @counter int
select @counter=count(*) from Community_has_Members
where member_email=@email and community_id = @community_id
if(@counter>0)
begin
select C.community_name,C.community_description from Communities C where C.community_id=@community_id
select member_email from Community_has_Members where community_id=@community_id
select * from Topics where community_id=@community_id
end
go

--13 Post a topic on a community that I have joined. I should be able to provide a title and a descriptive
--text for the topic.

CREATE PROC PostTopic(@title varchar(100),@descriptive_text varchar(1000),@community_id int,@email varchar(100))
AS
declare @counter int
select @counter=count(*) from Community_has_Members
where community_id=@community_id and member_email = @email
if(@counter > 0)
Insert into Topics values(@title,@descriptive_text,@community_id,@email)
go

--14 Delete a topic that I have posted.

CREATE PROC DeleteTopic(@email varchar(100),@topic_id int)
AS
declare @counter int
select @counter=count(*) from Topics
where topic_id=@topic_id and member_email=@email
if(@counter > 0)
Delete FROM Comments_on_Topic where topic_id=@topic_id
Delete FROM Topics where topic_id=@topic_id
GO


--15 Add a comment on a conference review, a game review, or a topic posted in a community that I
--have joined.


CREATE PROC CommentConferenceReview(@email varchar(100),@comment varchar(1000),@confReview_id int)
AS
INSERT INTO Comments values(@comment,@email)
DECLARE @maximum int
select @maximum=max(comment_id)from Comments
INSERT INTO Comments_on_Gaming_Conference_Reviews values (@maximum,@confReview_id)
GO


CREATE PROC CommentGameReview(@email varchar(100),@comment varchar(1000),@Review_id int)
AS
INSERT INTO Comments values(@comment,@email)
DECLARE @maximum int
select @maximum=max(comment_id)from Comments
INSERT INTO Comments_on_Reviews values (@maximum,@Review_id)
GO

CREATE PROC CommentOnTopic(@email varchar(100),@comment varchar(1000),@topic_id int)
AS
DECLARE @counter int
select @counter=count(*)
from Topics t INNER JOIN Community_has_Members CM on t.community_id= CM.community_id
where CM.member_email=@email and t.topic_id=@topic_id
if(@counter > 0)
INSERT INTO Comments values(@comment,@email)
DECLARE @maximum int
select @maximum=max(comment_id)from Comments
INSERT INTO Comments_on_Topic values (@maximum,@topic_id)
GO

--16 View the list of comments on a conference review, a game review or a topic posted on a community
--that I have joined.


CREATE PROC ViewCommentsOnConfReview(@conf_id int)
AS
Select C.comment_text,C.member_email
FROM Comments_on_Gaming_Conference_Reviews CR INNER JOIN Comments C
on CR.comment_id=C.comment_id
where CR.gaming_conference_review_id=@conf_id
go

CREATE PROC ViewCommentsOnReview(@rev_id int)
AS
Select C.comment_text,C.member_email
FROM Comments_on_Reviews CR INNER JOIN Comments C
on CR.comment_id=C.comment_id
where CR.review_id=@rev_id
go

CREATE PROC ViewCommentsonTopic(@topic_id int,@email varchar(100))
AS
DECLARE @counter int
select @counter=count(*)
from Topics t INNER JOIN Community_has_Members CM on t.community_id= CM.community_id
where CM.member_email=@email and t.topic_id=@topic_id
if(@counter > 0)
SELECT C.comment_text,C.member_email
From Comments_on_Topic CT INNER JOIN Comments C on C.comment_id=CT.comment_id
where CT.topic_id=@topic_id
go



--17 Delete a comment that I have posted on a conference review, a game review or a topic posted on a
--community that I have joined.

CREATE PROC DeleteCommentsOnConfReview(@comment_id int,@email varchar(100))
AS
declare @counter int
select @counter=count(*) from Comments
where comment_id=@comment_id and member_email=@email
if(@counter > 0)
Delete from Comments_on_Gaming_Conference_Reviews where comment_id=@comment_id
Delete from Comments where comment_id=@comment_id
go

CREATE PROC DeleteCommentsOnReview(@email varchar(100),@comment_id int)
AS
declare @counter int
select @counter=count(*) from Comments
where comment_id=@comment_id and member_email=@email
if(@counter > 0)begin
Delete from Comments_on_Reviews where comment_id=@comment_id
Delete from Comments where comment_id=@comment_id
end
go

CREATE PROC DeleteCommentOnTopic(@email varchar(100),@comment_id int)
AS
DECLARE @counter int
select @counter=count(*)
FROM Comments_on_Topic CT INNER JOIN Topics T on CT.topic_id=T.topic_id
						  Inner Join Community_has_Members CM on CT.topic_id=T.topic_id
						  where CT.comment_id=@comment_id and CM.member_email=@email

if (@counter>0)
Delete from Comments_on_Topic where comment_id=@comment_id
Delete from Comments where comment_id=@comment_id
go



--18 Show top 5 members with the most attended conferences in common with me.


CREATE PROC TopFiveMembers(@email varchar(100))
AS
Select TOP 5 GM2.member_email,Count(*) AS 'Count' 
From Game_Conference_attended_by_Member GM1 ,Game_Conference_attended_by_Member GM2
where GM1.game_conference_id=GM2.game_conference_id and GM1.member_email=@email and GM2.member_email <> @email
Group by  GM2.member_email 
ORDER BY Count(*) DESC 
go


--19 Show top 10 game recommendations based on how many times they have been recommended by
--other members of the system. This should exclude games that I have rated or have already been
--recommended.

CREATE PROC Top10Games (@email varchar(100))
AS
Select TOP 10g.game_name,Count(*) AS 'Count'
FROM Games g ,Ratings r,Normal_User_recommends_Game nr
where g.game_id=r.game_id and r.game_id=nr.game_id and r.member_email<>@email and nr.receiver_email <> @email
Group by  g.game_name
ORDER BY Count(*) DESC 
go





--“As a normal user, I should be able to ...”
-- Update my account information by providing my first name, last name and date of birth.

CREATE PROC UpdateNormalUser( @email varchar(100),@first_name varchar(100), @last_name varchar(100), @date_of_birth date)
AS
update Normal_Users set Normal_Users.first_name=@first_name,Normal_Users.last_name=@last_name, Normal_Users.birth_date=@date_of_birth
where Normal_Users.email = @email
go

--Send friendship requests to other members of the system.

CREATE PROC SendRequestFriendship(@requester_email varchar(100), @receiver_email varchar(100))
AS
Insert into Members_add_Members values(@requester_email, @receiver_email, 0)
go
--Search the members of the network to find friends.

CREATE PROC SearchMembers (@name varchar(100))
AS
Select *
FROM Normal_Users where @name=first_name or @name=last_name
go

--View a list of pending friendship requests.

CREATE PROC ViewPendingRequests (@email varchar(100))
AS
Select N.email,N.first_name,N.email from Normal_Users N INNER JOIN Members_add_Members MM ON N.email=MM.requester_email
 where MM.receiver_email=@email and MM.accepts = 0
go


--Accept/Reject the friendship request of other normal users.

CREATE PROC AcceptFriendshipRequest(@receiver_email varchar(100), @requester_email varchar(100))
AS
update Members_add_Members set accepts=1
where receiver_email=@receiver_email and requester_email=@requester_email
go



CREATE PROC RejectFriendshipRequest(@receiver_email varchar(100), @requester_email varchar(100))
AS
delete from Members_add_Members 
where receiver_email =@receiver_email and requester_email=@requester_email
go

--View my friend list.

CREATE PROC ViewFriendsList(@email varchar(100))
AS
SELECT N.first_name, N.last_name, M.receiver_email As'email'
FROM Members_add_Members M INNER JOIN Normal_Users N on N.email= M.receiver_email  
where M.requester_email=@email and M.accepts = 1
UNION
SELECT N1.first_name, N1.last_name, M1.requester_email AS 'email'
FROM Members_add_Members M1 INNER JOIN Normal_Users N1 on  N1.email=M1.requester_email
where M1.receiver_email=@email and M1.accepts = 1
go

--View a friend’s profile. I should be able to view his/her information (first name, last name and age),
--a list of the conferences that he/she have attended, as well as the list of games that he/she have
--rated along with the rating he/she provided for each game.

CREATE PROC ViewFriendProfile(@useremail varchar(100), @friendemail varchar(100))
AS
declare @counter int
select @counter=count(*) from
(SELECT N.first_name, N.last_name, M.receiver_email As'email'
FROM Members_add_Members M INNER JOIN Normal_Users N on N.email= M.receiver_email  
where M.requester_email=@useremail and M.accepts = 1
UNION
SELECT N1.first_name, N1.last_name, M1.requester_email AS 'email'
FROM Members_add_Members M1 INNER JOIN Normal_Users N1 on  N1.email=M1.requester_email
where M1.receiver_email=@useremail and M1.accepts = 1) T where T.email=@friendemail

if(@counter>0)
begin
SELECT first_name, last_name, age FROM Normal_Users where email = @friendemail
SELECT GC.conference_name, GC.game_conference_id, GC.conference_start_date, GC.conference_end_date, GC.duration, GC.venue
FROM Gaming_Conferences GC INNER JOIN Game_Conference_attended_by_Member GCM on GC.game_conference_id= GCM.game_conference_id
where GCM.member_email = @friendemail
SELECT g.game_id, g.game_name, r.interactivity, r.uniqueness, r.level_design, r.graphics
FROM Ratings r INNER JOIN Games g on r.game_id = g.game_id
where r.member_email=@friendemail
end
go

-- Send and receive multiple messages through threads with my friends.
CREATE PROC SendMessages(@senderemail varchar(100), @receiver_email varchar(100), @text varchar(1000))
AS
declare @counter int
select @counter=count(*) from
(SELECT N.first_name, N.last_name, M.receiver_email As'email'
FROM Members_add_Members M INNER JOIN Normal_Users N on N.email= M.receiver_email  
where M.requester_email=@senderemail and M.accepts = 1
UNION
SELECT N1.first_name, N1.last_name, M1.requester_email AS 'email'
FROM Members_add_Members M1 INNER JOIN Normal_Users N1 on  N1.email=M1.requester_email
where M1.receiver_email=@senderemail and M1.accepts = 1) T where T.email=@receiver_email

if(@counter>0)
begin
Insert into Normal_User_sends_Thread values(@senderemail, @receiver_email, @text)
end
go

--View my different thread messages.


CREATE PROC ViewThreadMessages(@email varchar(100))
AS
Select *
From Normal_User_sends_Thread
where Normal_User_sends_Thread.receiver_email = @email
go

--Recommend a game to another normal user.

CREATE PROC RecommendGameToNormalUser(@game_id int, @receiver_email varchar(100), @recommender_email varchar(100))
AS
INSERT into Normal_User_recommends_Game values(@game_id, @recommender_email, @receiver_email)
go

--View the recommendations for different games that I have recieved.

CREATE PROC ViewMyRecommendations(@email varchar(100))
AS
SELECT *
FROM Normal_User_recommends_Game
where Normal_User_recommends_Game.receiver_email=@email
go

--Request to create a community providing its name and description.

CREATE PROC RequestForCommunity(@email varchar(100), @community_name varchar(100), @community_description varchar(1000))
AS
INSERT into Communities values(null, @community_description,@community_name, 0, @email)
go











--“As a verified reviewer, I should be able to ...”
--1 Update my account information by providing my first name, last name and years of experience.

CREATE PROC UpdateVerifiedReviewerInfo (
@email varchar(100),
@first_name varchar(100),
@last_name varchar(100),
@years_of_experience int)
AS
declare @counter int
Select @counter=count(*) from Verified_Reviewers
where email=@email
if(@counter>0)
UPDATE Verified_Reviewers
SET first_name=@first_name,last_name=@last_name,years_of_experience=@years_of_experience
where email=@email
go

--2 Add a game review.


CREATE PROC AddReview(@email varchar(100),@review_text varchar(1000),@game_id int)
AS
declare @counter int
Select @counter=count(*) from Verified_Reviewers
where email=@email
if(@counter>0)
INSERT INTO Reviews VALUES(@review_text,@email,@game_id)
go

--3 Delete a game review that I have written.

CREATE PROC DeleteGameReview(@email varchar(100),@review_id int)
AS
declare @counter int
declare @counter0 int
Select @counter=count(*) from Verified_Reviewers
where email=@email
if(@counter>0)
begin
	Select @counter0=count(*) from Reviews where verified_reviewer_email=@email
	if(@counter0 > 0)
	begin
		DELETE FROM Comments_on_Reviews where review_id=@review_id
		DELETE FROM Reviews where review_id=@review_id
		end
end
go


--4 View my top 10 game reviews based on the number of comments on them.

CREATE PROC ViewTopReviews (@email varchar(100))
AS
declare @counter int
select @counter=count(*) from Verified_Reviewers where email=@email
if(@counter>0)
begin
select top 10 R.review_id,R.review_text,R.game_id from Reviews R
INNER JOIN 
(select review_id,count(*) AS'count' from Comments_on_Reviews
 group by review_id) C on R.review_id=C.review_id
 where verified_reviewer_email = @email
 end
 go

-- “As a development team, we should be able to ...”
--1 Update our account’s information by providing our team name, date of formation and company we work for.

 CREATE PROC UpdateDevelopmentTeam(@email varchar(100),@team_name varchar(100),@dateOfFormation date,@company varchar(100))

 AS
 declare @counter int
select @counter=count(*) from Development_Teams where email=@email
if(@counter>0)
begin
UPDATE Development_Teams
SET team_name=@team_name,formation_date=@dateOfFormation,@team_name=@company
where email=@email
end
go

--2 Add a game to the list of games that we have developed.

CREATE PROC AddDevelopedGame(@email varchar(100),@game_id int)
AS
declare @counter int
select @counter=count(*) from Development_Teams where email=@email
if(@counter>0)
begin
INSERT INTO Development_Teams_develops_Games VALUES(@game_id,@email)
end
go

--3 Add screenshots and videos to a game that we have developed.

CREATE PROC AddScreenshot(@email varchar(100),@game_id int,@path varchar(100))
AS
declare @counter int
select @counter=count(*) from Development_Teams_develops_Games where development_team_email=@email  and game_id=@game_id
if(@counter>0)
begin INSERT INTO Game_Screenshots VALUES(@game_id,@path)
 end
 go

 CREATE PROC AddVideo(@email varchar(100),@game_id int,@path varchar(100))
AS
declare @counter int
select @counter=count(*) from Development_Teams_develops_Games where development_team_email=@email and game_id=@game_id
if(@counter>0)
begin INSERT INTO Game_Videos VALUES(@game_id,@path)
 end
 go

-- 4 Add a conference to the list of conferences that we have presented in. We should also be able to
--add the game(s) that we presented in that conference.

Create PROC GamesPresented(@email varchar(100),@game_id int,@conference_id int)
 AS
declare @counter int
select @counter=count(*) from Development_Teams_develops_Games where development_team_email=@email and game_id=@game_id
if(@counter>0)
begin
INSERT INTO Game_presented_in_Conference VALUES(@game_id,@conference_id)
end
go

--“As a system administrator, I should be able to ...”
--1 View a list of requests to form communities.


CREATE PROC PendingCommunities
AS
Select * From Communities
where is_approved=0
go

--2 Accept/Reject a request to create a community. In case of acceptance, the community should be
--created with the provided information (name and description).

CREATE PROC AcceptCommunity (@community_id int,@theme varchar(100) )
AS
UPDATE Communities
SET is_approved=1,theme=@theme
where community_id=@community_id
go

CREATE PROC RejectCommunity(@id int)
AS
DELETE FROM Communities
where community_id=@id
go


--3 Verify members who signed up as verified reviewers or development teams.
 
CREATE PROC AcceptReviewer(@email varchar(100))
AS
UPDATE Verified_Reviewers
SET isAccepted=1
where email=@email
go

CREATE PROC AcceptTeam(@email varchar(100))
AS
UPDATE Development_Teams
SET isAccepted=1
where email=@email
go

CREATE PROC RejectReviewer(@email varchar(100))
AS
DELETE FROM Verified_Reviewers
where email=@email
go
	   
CREATE PROC RejectTeam(@email varchar(100))
AS
DELETE FROM Development_Teams
where email=@email
go



--4 Create a conference with its information (names, start date, end date, duration and venue).

CREATE PROC CreateConf (@name varchar(100),@startdate date,@enddate date,@venue varchar(100))
AS
INSERT  Gaming_Conferences(conference_end_date,conference_start_date,venue,conference_name) values(@enddate,@startdate,@venue,@name)
go

--5 Create a game with its information (name, release date, age limit, and an intial rating equals to 0).

CREATE PROC CreateGame(@name varchar(100),@release_date date,@age_limit int)
AS
INSERT into Games values (@name,@release_date,@age_limit,0,0,0,0,0,null)
go


--6 Delete a community, a conference, or a game.

CREATE PROC DeleteCommunity(@id int)
AS
DELETE FROM Communities where community_id=@id
go

CREATE PROC DeleteConference(@id int)
AS
DELETE FROM Gaming_Conferences where game_conference_id=@id
go

CREATE PROC DeleteGame(@id int)
AS
DELETE FROM Games where game_id=@id
go
