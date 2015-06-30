namespace java io.golgi.battleship.gen

struct Battleship{
	1:required string myMsg,
	2:required list<string> playerList,
	3:required i32 timestampLow,
	4:required i32 timestampHigh,
}


// User info
// status 0 available
// status 1 busy
// status 2 unavailable

struct PlayerInfo{
	1:required string name,
	2:required string appInstanceId,
	3:required list<string> pList,
	4:required i32 status,
    5:required string player2Name,
}

struct PlayerInfoList{
	1:required list<PlayerInfo> playerList,
}

service myBattleship{
    void startGame(1:PlayerInfo playerInfo),
	void reachOut(1:Battleship msg),
    void reachOutList(1:Battleship msg),
	void setPlayerInfo(1:PlayerInfo userInfo),
	void notifyPlayerInfo(1:string player),
	PlayerInfoList getPlayerInfoList(1:PlayerInfo dummy),
}
