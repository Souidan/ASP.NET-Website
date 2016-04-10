EXEC InsertNormalUser 'mostafa@gmail.com','123456','Action','mostafa','anber','19900104'
EXEC InsertNormalUser 'mostafa_anber@gmail.com','123456','Action','mostafa','anber','19900104'

EXEC InsertDevelopmentTeam 'hassan@gmail.com','123456','Sports','team_khedr','adelsCompany','19001111'

EXEC InsertVerified_Reviewers 'tim@gmail.com','123456','RPG',15,'tim','mounir'

EXEC SearchGame 'call of duty'

EXEC   SearchConference 'e3'

EXEC SearchCommunities 'sporta'

EXEC SearchReviewer 'karim'

EXEC SearchTeam 'team_a'

EXEC ViewGame 1 

EXEC RateGame 1,'mostafa_anber@gmail.com',2,3,4,4

EXEC ViewRating 1

EXEC RatedGamesReviews 'karim@gmail.com'

EXEC ConferenceDetails 1

EXEC AttendConf 'zaher@gmail.com' ,4

EXEC AddConfReview 'karim@gmail.com',3,'one of the best conferences that i have attended'

EXEC DeleteConferenceReview 'karim@gmail.com' ,11

EXEC joinCommunity 'hassan@gmail.com' ,1

EXEC viewCommunity 1,'hassan@gmail.com'

EXEC PostTopic 'my first topic','Yes, it is my first topic',1,'hassan@gmail.com'
 
EXEC DeleteTopic 'hassan@gmail.com', 7

EXEC CommentConferenceReview 'hassan@gmail.com','my first comment',1

EXEC CommentGameReview 'hassan@gmail.com','2nd comment',1

EXEC CommentOnTopic 'hassan@gmail.com','3rd comment',4

EXEC  ViewCommentsOnConfReview 1

EXEC ViewCommentsOnReview 1

EXEC ViewCommentsonTopic 4, 'hassan@gmail.com';



EXEC DeleteCommentsOnConfReview 30,'hassan@gmail.com'


EXEC DeleteCommentsOnReview 'hassan@gmail.com',31

EXEC DeleteCommentOnTopic 'hassan@gmail.com',32

EXEC TopFiveMembers 'zaher@gmail.com'

EXEC Top10Games 'zaher@gmail.com'

EXEC UpdateNormalUser 'mostafa_anber@gmail.com', 'moustafa','anaaber','19980101'


EXEC SendRequestFriendship 'mostafa_anber@gmail.com','zaher@gmail.com'
EXEC SendRequestFriendship 'tarek@gmail.com','mostafa@gmail.com'


EXEC SearchMembers 'zaher'

EXEC ViewPendingRequests 'zaher@gmail.com'

EXEC AcceptFriendshipRequest 'zaher@gmail.com' , 'mostafa_anber@gmail.com'

EXEC RejectFriendshipRequest 'mostafa@gmail.com','tarek@gmail.com' 

EXEC ViewFriendsList 'zaher@gmail.com'

EXEC ViewFriendProfile 'zaher@gmail.com' ,'tarek@gmail.com'

EXEC SendMessages  'zaher@gmail.com' ,'tarek@gmail.com','YALA'

EXEC ViewThreadMessages 'tarek@gmail.com'

EXEC RecommendGameToNormalUser 1,'tarek@gmail.com','zaher@gmail.com'

EXEC ViewMyRecommendations 'zaher@gmail.com'


EXEC RequestForCommunity 'zaher@gmail.com','action_comm','community for action games'


EXEC UpdateVerifiedReviewerInfo 'karim@gmail.com','zaher','tarek',30

EXEC AddReview 'karim@gmail.com','this game is wonderful',1

EXEC DeleteGameReview 'karim@gmail.com', 28

EXEC ViewTopReviews'karim@gmail.com'

EXEC UpdateDevelopmentTeam 'hassan@gmail.com','team_10','19990201','Khedr'

EXEC AddDevelopedGame 'hassan@gmail.com',4

EXEC AddScreenshot 'hassan@gmail.com',4,'sc_1.jpg'

EXEC AddVideo 'hassan@gmail.com',4,'bd_1.avi'

EXEC GamesPresented 'hassan@gmail.com' ,4,1

EXEC PendingCommunities

EXEC AcceptCommunity 1,'alo'

EXEC RejectCommunity 2



EXEC AcceptReviewer 'amr@gmail.com'

EXEC AcceptTeam 'aly@gmail.com'

EXEC RejectReviewer  'abdo@gmail.com'

EXEC RejectTeam    'TWAM@gmail.com'

EXEC CreateConf 'E3','20150109','20100328','Madisson Square Garden'

EXEC CreateGame 'Star Wars:Battlefront','20150917',16

EXEC DeleteCommunity 1

EXEC DeleteConference 1

EXEC DeleteGame 1











