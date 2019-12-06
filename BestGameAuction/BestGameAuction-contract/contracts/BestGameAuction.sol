pragma solidity >=0.4.22 <0.6.0;
contract BestGameAuction {

    struct Voter{

        uint gender;
        uint age;
        uint years_played;
        uint games_owned;

        uint points; ///The amount of points the voter's vote is

        bool accepted;
        bool pastVoter;
        uint8 voteChoice;

    }

    struct Proposal {
        uint voteCount;
    }

    address user;
    mapping(address => Voter) voters;
    Proposal[] games;

    constructor(uint8 numGames) public {
        voters[msg.sender].accepted = true;
        user = msg.sender;
        games.length = numGames;
    }

    ///---- Modifier functions ----
    ///Requires the user to be atleast the age of 16
    modifier checkAgeReq(uint n){
        require(n >= 16);
        _;
    }
    ///Requires user to only input 0 or 1 for gender (Female = 0, Male = 1)
    modifier checkGenderReq(uint n){
        require(n < 2);
        _;
    }
    ///Requires the user to have played games for atleast 2 years
    modifier checkYearCount(uint n){
        require(n >= 2);
        _;
    }
    ///Requires the user to own atleast 1 games
    modifier checkGameCount(uint n){
        require(n >= 1 );
        _;
    }

    ///---- Functionality ----

    /// Adding points according to specific user information
    /// If user is atleast 21, their vote is weighted more

    function setAge(uint _age) checkAgeReq(_age) public{
        voters[user].age = _age;

        if(voters[user].age >= 21) voters[user].points += 4;
            else{voters[user].points += 2;}

    }

    /// If user is a female, their vote is weighted more
    /// Guide: Female = 0, Male = 1
    function setGender(uint _gender) checkGenderReq(_gender) public{
        voters[user].gender = _gender;

        if(voters[user].gender == 0) voters[user].points += 4;
        else{ voters[user].points += 2;}
        return;
    }

    /// If user has played games for 3 or more years, their vote is weighted more
    function setYearCount(uint _yearsPlayed) checkYearCount(_yearsPlayed) public{
        voters[user].years_played= _yearsPlayed;

        if(voters[user].years_played > 3) voters[user].points += 4;
        else{ voters[user].points += 2;}
        return;
    }

    /// If user has owned more than 2 games, their vote is weighted more
    function setGameCount(uint _gamesOwned) checkGameCount(_gamesOwned) public{
        voters[user].games_owned = _gamesOwned;

        if(voters[user].games_owned > 3) voters[user].points += 4;
        else{ voters[user].points += 2;}
        return;
    }

    function getPointsB4Vote() view public returns (uint){
        return(voters[user].points);
    }

    ///User will cast their vote according to the options that will be shown in the Dapp
    ///Options will be acceptable as 0 - 9 (10 options)
    function Vote(uint8 _choice) public{
        Voter memory sender = voters[msg.sender];

        require (sender.pastVoter == false);
        require (_choice < games.length);

        sender.pastVoter = true;
        //voters[user].pastVoter = true;
        sender.voteChoice = _choice;
        games[_choice].voteCount += voters[user].points; // sender.weight; // change 2
        voters[user].points = 0;

    }

    function reqWinner() public view returns (uint8 winningProposal) {

        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < games.length; prop++)
            if (games[prop].voteCount > winningVoteCount) {
                winningVoteCount = games[prop].voteCount;
                winningProposal = prop;
            }
       assert(winningVoteCount>=4);
    }

}
