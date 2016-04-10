CREATE TABLE Members(
email varchar(100) Primary Key ,
user_password varchar(100) not null,
preferred_genre varchar(100)
)
CREATE TABLE Normal_Users(
email varchar(100) FOREIGN KEY references Members PRIMARY KEY,
first_name varchar(100) not null,
last_name varchar(100) not null,
birth_date date not null,
age as (YEAR(current_timestamp)-Year(birth_date))
)
CREATE TABLE Verified_Reviewers(
email varchar(100) FOREIGN KEY references Members Primary key, 
years_of_experience int not null,
first_name varchar(100)not null,
last_name varchar (100)not null,
isAccepted bit DEFAULT 0
)
CREATE TABLE Development_Teams(
email varchar(100) FOREIGN KEY references Members Primary Key ,
team_name varchar(100) not null,
company_name varchar(100),
formation_date date not null,
isAccepted bit DEFAULT 0
)
CREATE TABLE Gaming_Conferences(
game_conference_id int primary key identity,
conference_end_date date not null,
conference_start_date date not null,
duration as  abs(Datediff(day,conference_start_date,conference_end_date)),
venue varchar(100) not null,
conference_name varchar(100) not null

)
CREATE TABLE Games(
game_id int Primary key identity,
game_name varchar(100) not null,
release_date date not null,
age_limit int not null,
interactivity_rating int not null,
uniqueness_rating int not null,
graphics_rating int not null,
level_design_rating int not null,
total_average_rating int not null,
conference_released_id int Foreign Key references Gaming_Conferences on delete set null
)



CREATE TABLE Ratings(
rating_id int primary key identity,
interactivity int not null,
uniqueness int not null,
level_design int not null,
graphics int not null,
game_id int FOREIGN KEY references Games on delete cascade not null,
member_email varchar(100)FOREIGN KEY REFERENCES Members not null
)

CREATE TABLE Game_Videos(
game_id int FOREIGN KEY references Games on delete cascade,
video_path varchar(100),
primary key  (game_id,video_path)
)

CREATE TABLE Game_Screenshots(
game_id int FOREIGN KEY  references Games on delete cascade,
screenshot_path varchar(100),
primary key  (game_id,screenshot_path)
)

CREATE TABLE Strategy_Games(
game_id int Foreign Key references Games on delete cascade primary key ,
is_real_time bit not null)


CREATE TABLE Action_Games(
game_id int Foreign Key references Games on delete cascade primary key  ,
sub_genre varchar(100) not null )


CREATE TABLE Sport_Games(
game_id int Foreign Key references Games on delete cascade primary key,
sports_type varchar(100) not null )


CREATE TABLE RPG_Games(
game_id int Foreign Key references Games on delete cascade primary key,
is_pvp bit not null,
has_story_line bit not null
)

CREATE TABLE Communities(
community_id int primary key identity,
theme varchar(100) ,
community_description varchar(1000) not null,
community_name varchar(100) not null,
is_approved bit not null,
owner_email varchar(100) FOREIGN KEY  references Members

)

CREATE TABLE Topics(
topic_id int primary key identity,
title varchar(100) not null,
descriptive_text varchar(1000) not null,
community_id int FOREIGN KEY  references Communities  on delete cascade not null,
member_email varchar(100) FOREIGN KEY references Members not null
)


CREATE TABLE Gaming_Conference_Reviews(
game_conference_review_id int Primary Key identity,
game_conferene_review_text varchar(1000) not null,
member_email varchar(100)FOREIGN KEY references Members not null,
conference_id int FOREIGN KEY references Gaming_Conferences on delete cascade not null
)
Create Table Comments(
comment_id int primary key identity,
comment_text varchar(1000)not null,
member_email varchar(100) FOREIGN KEY references members not null
)
CREATE TABLE Reviews(
review_id int  primary key identity,
review_text varchar(1000) not null,
verified_reviewer_email varchar(100) FOREIGN KEY REFERENCES Members not null,
game_id int FOREIGN KEY references Games on delete cascade not null
)
CREATE TABLE Development_Teams_develops_Games(
game_id int FOREIGN KEY REFERENCES Games on delete cascade not null,
development_team_email varchar(100) FOREIGN KEY REFERENCES Development_Teams not null,
PRIMARY KEY  (game_id,development_team_email)
)
CREATE TABLE Comments_on_Reviews(
comment_id int FOREIGN KEY REFERENCES Comments not null,
review_id int FOREIGN KEY REFERENCES Reviews on delete cascade not null,
PRIMARY KEY  (comment_id,review_id)
)
CREATE TABLE Comments_on_Topic(
comment_id int FOREIGN KEY REFERENCES Comments not null,
topic_id int FOREIGN KEY REFERENCES Topics on delete cascade not null,
PRIMARY KEY  (comment_id,topic_id)
)
CREATE TABLE Comments_on_Gaming_Conference_Reviews(
comment_id int FOREIGN KEY REFERENCES Comments not null,
gaming_conference_review_id int FOREIGN KEY REFERENCES Gaming_Conference_Reviews on delete cascade not null,
PRIMARY KEY  (comment_id,gaming_conference_review_id)
)

CREATE TABLE Game_presented_in_Conference(
game_id int FOREIGN KEY REFERENCES Games on delete cascade not null,
conference_id int FOREIGN KEY REFERENCES Gaming_Conferences on delete cascade not null,
PRIMARY KEY  (game_id,conference_id)

)
CREATE TABLE Members_add_Members(
requester_email varchar(100)FOREIGN KEY REFERENCES Members not null,
receiver_email varchar(100) FOREIGN KEY REFERENCES Members not null,
accepts bit DEFAULT 0 not null,
PRIMARY KEY  (requester_email,receiver_email)
)
CREATE TABLE Normal_User_sends_Thread(
Thread_id int primary key identity,
sender_email varchar(100) FOREIGN KEY REFERENCES Members not null,
receiver_email varchar(100) FOREIGN KEY REFERENCES Members not null,
thread_text varchar(1000) not null,

)
CREATE TABLE Game_Conference_attended_by_Member(
game_conference_id int FOREIGN KEY REFERENCES Gaming_Conferences on delete cascade,
member_email varchar(100) FOREIGN KEY REFERENCES Members,
PRIMARY KEY  (game_conference_id, member_email)
)
CREATE TABLE Community_has_Members(
community_id int FOREIGN KEY REFERENCES Communities on delete cascade,
member_email varchar(100) FOREIGN KEY REFERENCES Members,
PRIMARY KEY  (community_id, member_email)
)
CREATE TABLE Normal_User_recommends_Game(
game_id int FOREIGN KEY REFERENCES Games on delete cascade,
recommender_email varchar(100) FOREIGN KEY REFERENCES Normal_Users,
receiver_email varchar(100) FOREIGN KEY REFERENCES Normal_Users,
PRIMARY KEY  (game_id, recommender_email, receiver_email)
)


 






























