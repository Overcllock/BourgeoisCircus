//Bourgeois Circus 1.0

#include <a_samp>
#include <a_mail>
#include <a_engine>
#include <dini>
#include <mxINI>
#include <md5>
#include <morphinc>
#include <streamer>
#include <time>
#include <a_actor>
#include <FCNPC>
#include <float>

#pragma dynamic 31294

#define VERSION 1.00

//Colors
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_BLACK 0x000000FF
#define COLOR_RED 0xFF0000FF
#define COLOR_GREEN 0x00FF00FF
#define COLOR_GREY 0xCCCCCCFF
#define COLOR_BLUE 0x0066CCFF
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_LIGHTRED 0xFF6347FF

//Defaults
#define DEFAULT_SKIN_MALE 78
#define DEFAULT_DAMAGE_MIN 13
#define DEFAULT_DAMAGE_MAX 15
#define DEFAULT_DEFENSE 5
#define DEFAULT_CRIT 5
#define DEFAULT_DODGE 0
#define DEFAULT_ACCURACY 5
#define DEFAULT_POS_X -2170.3948
#define DEFAULT_POS_Y 645.6729
#define DEFAULT_POS_Z 1057.5938

//Limits
#define MAX_SLOTS 25
#define MAX_RANK 9
#define MAX_MOD 7
#define MAX_PROPERTIES 2

/* Forwards */
forward Time();
forward OnPlayerLogin(playerid);
forward UpdatePlayer(playerid);
forward Float:GetDistanceBetweenPlayers(p1, p2);

/* Variables */

//Global
new WorldTime_Timer = -1;

//Player
enum iInfo {
	ID,
	Type,
	Grade,
	Mod[MAX_MOD],
	Property[MAX_PROPERTIES],
	PropertyValue[MAX_PROPERTIES],
	Count,
	Price
};
enum pInfo {
	Rate,
	Rank,
	Cash,
	Sex,
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:FacingAngle,
	Interior,
	InventoryItems[MAX_SLOTS][iInfo],
	Skin,
	Admin,
	Kills,
	Deaths,
	DamageMin,
	DamageMax,
	Defense,
	Dodge,
	Accuracy,
	GlobalTopPosition,
	LocalTopPosition,
	CriticalChance,
	ParticipantsCount,
	Participants[MAX_PLAYERS]
};
new PlayerInfo[MAX_PLAYERS][pInfo];
new PlayerUpdater[MAX_PLAYERS];
new PlayerConnect[MAX_PLAYERS];
new bool:IsInventoryOpen[MAX_PLAYERS];
new SelectedSlot[MAX_PLAYERS];

//Arrays
new RateColors[MAX_RANK][16] = {
	{"85200c"},
	{"666666"},
	{"4c1130"},
	{"a61c00"},
	{"999999"},
	{"bf9000"},
	{"b7b7b7"},
	{"76a5af"},
	{"6d9eeb"}
};
new HexRateColors[MAX_RANK][1] = {
	{0x85200cff},
	{0x666666ff},
	{0x4c1130ff},
	{0xa61c00ff},
	{0x999999ff},
	{0xbf9000ff},
	{0xb7b7b7ff},
	{0x76a5afff},
	{0x6d9eebff}
};

///Textdraws
//Global
new Text:WorldTime;
new Text:GamemodeName1;
new Text:GamemodeName2;
new Text:Version;


main()
{
	new str[64];
	format(str, sizeof(str), "Bourgeois Circus ver. %.2f", VERSION);
	print(str);
}


/* Callbacks */
public OnGameModeInit()
{
	new mode_txt[64];
	format(mode_txt, sizeof(mode_txt), "Bourgeois Circus %.2f", VERSION);
	SetGameModeText(mode_txt);
	ShowNameTags(1);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	LimitPlayerMarkerRadius(1000.0);
	FCNPC_SetUpdateRate(15);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	DisableNameTagLOS();
	SetNameTagDrawDistance(9999.0);
	CreateMap();
	CreatePickups();
	InitTextDraws();
	WorldTime_Timer = SetTimer("Time", 1000, true);
	UpdateRatingTop();
	return 1;
}

public OnGameModeExit()
{
	DeleteTextDraws();
	KillTimer(WorldTime_Timer);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SendClientMessage(playerid, COLOR_WHITE, "Добро пожаловать в Bourgeois Circus.");
	new ok = LoadAccount(playerid);
	if (PlayerInfo[playerid][Admin] > 0 && ok > 0)
		OnPlayerLogin(playerid);
	else
	{
		CreateAccount(playerid, "Admin");
		//TODO
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    ShowTextDraws(playerid);
    PlayerUpdater[playerid] = SetTimerEx("UpdatePlayer", 1000, true, "i", playerid);
	return 1;
}

public OnPlayerLogin(playerid) {
	//InitPlayerTextDraws(playerid);
	PlayerConnect[playerid] = true;
	SpawnPlayer(playerid);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
	//ShowInterface(playerid);
	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;
}

public OnPlayerDisconnect(playerid, reason)
{
	KillTimer(PlayerUpdater[playerid]);
	SaveAccount(playerid);
	//DeletePlayerTextDraws(playerid);
	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;

	for (new i = 0; i < 10; i++)
	    if (IsPlayerAttachedObjectSlotUsed(playerid, i))
	        RemovePlayerAttachedObject(playerid, i);

	PlayerConnect[playerid] = false;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerHealth(playerid, GetPlayerMaxHP(playerid));
	if (IsDeath[playerid]) 
	{
	    IsDeath[playerid] = false;
	    SetPlayerInterior(playerid, 1);
	    SetPlayerPos(playerid, -2170.3948,645.6729,1057.5938);
	    SetPlayerFacingAngle(playerid, 180);
	}
	else 
	{
	    SetPlayerInterior(playerid, PlayerInfo[playerid][Interior]);
		SetPlayerPos(playerid, PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ]);
		SetPlayerFacingAngle(playerid, PlayerInfo[playerid][FacingAngle]);
	}
	SetCameraBehindPlayer(playerid);
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	SetPlayerColor(playerid, HexRateColors[PlayerInfo[playerid][Rank-1]][0]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    IsDeath[playerid] = true;
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new name[64];
	GetPlayerName(playerid, name, sizeof(name));
	new message[2048];
	format(message, sizeof(message), "[%s]: %s", name, text);
	SendClientMessageToAll(HexRateColors[PlayerInfo[playerid][Rank-1]][0]), message);
	return 0;
}

/* Public functions */
public Time()
{
    new hour, minute, second;
	new string[25];
	gettime(hour, minute, second);
	if (minute <= 9)
		format(string, 25, "%d:0%d", hour, minute);
	else
		format(string, 25, "%d:%d", hour, minute);
	TextDrawSetString(WorldTime, string);
}

public Float:GetDistanceBetweenPlayers(p1,p2)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
		return -1;
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,
		y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

/* Stock functions */
stock SaveAccount(playerid)
{
	new name[64];
	new string[255];
	GetPlayerPos(playerid, PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ]);
	GetPlayerFacingAngle(playerid, PlayerInfo[playerid][FacingAngle]);
	PlayerInfo[playerid][Interior] = GetPlayerInterior(playerid);
	GetPlayerName(playerid, name, sizeof(name));
	new path[128];
	format(path, sizeof(path), "Players/%s.ini", name);
	new File = ini_openFile(path);
	if (!File)
		return -1;

	ini_setInteger(File, "Rate", PlayerInfo[playerid][Rate]);
	ini_setInteger(File, "Rank", PlayerInfo[playerid][Rank]);
    ini_setInteger(File, "Cash", PlayerInfo[playerid][Cash]);
    ini_setInteger(File, "Sex", PlayerInfo[playerid][Sex]);
	ini_setFloat(File, "PosX", PlayerInfo[playerid][PosX]);
    ini_setFloat(File, "PosY", PlayerInfo[playerid][PosY]);
    ini_setFloat(File, "PosZ", PlayerInfo[playerid][PosZ]);
    ini_setFloat(File, "Angle", PlayerInfo[playerid][FacingAngle]);
    ini_setInteger(File, "Interior", PlayerInfo[playerid][Interior]);
	ini_setInteger(File, "Skin", PlayerInfo[playerid][Skin]);
	ini_setInteger(File, "Admin", PlayerInfo[playerid][Admin]);
    ini_setInteger(File, "Kills", PlayerInfo[playerid][Kills]);
    ini_setInteger(File, "Deaths", PlayerInfo[playerid][Deaths]);
    ini_setInteger(File, "DamageMin", PlayerInfo[playerid][DamageMin]);
	ini_setInteger(File, "DamageMax", PlayerInfo[playerid][DamageMax]);
    ini_setInteger(File, "Defense", PlayerInfo[playerid][Defense]);
    ini_setInteger(File, "Dodge", PlayerInfo[playerid][Dodge]);
    ini_setInteger(File, "Accuracy", PlayerInfo[playerid][Accuracy]);
	ini_setInteger(File, "Crit", PlayerInfo[playerid][CriticalChance]);
    ini_setInteger(File, "GlobalTopPosition", PlayerInfo[playerid][GlobalTopPosition]);
	ini_setInteger(File, "LocalTopPosition", PlayerInfo[playerid][LocalTopPosition]);
	ini_setInteger(File, "ParticipantsCount", PlayerInfo[playerid][ParticipantsCount]);
    for (new j = 0; j < MAX_SLOTS; j++) 
	{
        format(string, sizeof(string), "InventorySlot%dID", j);
        ini_setInteger(File, string, PlayerInfo[playerid][InventoryItems][j][ID]);
        format(string, sizeof(string), "InventorySlot%dType", j);
        ini_setInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Type]);
		format(string, sizeof(string), "InventorySlot%dGrade", j);
        ini_setInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Grade]);
		for (new x = 0; x < MAX_MOD; x++)
		{
			format(string, sizeof(string), "InventorySlot%dMod%d", j, x);
        	ini_setInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Mod][x]);
		}
		for (new x = 0; x < MAX_PROPERTIES; x++)
		{
			format(string, sizeof(string), "InventorySlot%dProp%d", j, x);
        	ini_setInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Property][x]);
			format(string, sizeof(string), "InventorySlot%dPropVal%d", j, x);
        	ini_setInteger(File, string, PlayerInfo[playerid][InventoryItems][j][PropertyValue][x]);
		}
		format(string, sizeof(string), "InventorySlot%dCount", j);
        ini_setInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Count]);
		format(string, sizeof(string), "InventorySlot%dPrice", j);
        ini_setInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Price]);
    }
    ini_closeFile(File);
}

stock LoadAccount(playerid)
{
	new name[64];
	new string[255];
	GetPlayerName(playerid, name, sizeof(name));
    new path[128];
	format(path, sizeof(path), "Players/%s.ini", name);
	new File = ini_openFile(path);
	if (!File)
		return -1;
	
	ini_getInteger(File, "Rate", PlayerInfo[playerid][Rate]);
	ini_getInteger(File, "Rank", PlayerInfo[playerid][Rank]);
    ini_getInteger(File, "Cash", PlayerInfo[playerid][Cash]);
    ini_getInteger(File, "Sex", PlayerInfo[playerid][Sex]);
	ini_getFloat(File, "PosX", PlayerInfo[playerid][PosX]);
    ini_getFloat(File, "PosY", PlayerInfo[playerid][PosY]);
    ini_getFloat(File, "PosZ", PlayerInfo[playerid][PosZ]);
    ini_getFloat(File, "Angle", PlayerInfo[playerid][FacingAngle]);
    ini_getInteger(File, "Interior", PlayerInfo[playerid][Interior]);
	ini_getInteger(File, "Skin", PlayerInfo[playerid][Skin]);
	ini_getInteger(File, "Admin", PlayerInfo[playerid][Admin]);
    ini_getInteger(File, "Kills", PlayerInfo[playerid][Kills]);
    ini_getInteger(File, "Deaths", PlayerInfo[playerid][Deaths]);
    ini_getInteger(File, "DamageMin", PlayerInfo[playerid][DamageMin]);
	ini_getInteger(File, "DamageMax", PlayerInfo[playerid][DamageMax]);
    ini_getInteger(File, "Defense", PlayerInfo[playerid][Defense]);
    ini_getInteger(File, "Dodge", PlayerInfo[playerid][Dodge]);
    ini_getInteger(File, "Accuracy", PlayerInfo[playerid][Accuracy]);
	ini_getInteger(File, "Crit", PlayerInfo[playerid][CriticalChance]);
    ini_getInteger(File, "GlobalTopPosition", PlayerInfo[playerid][GlobalTopPosition]);
	ini_getInteger(File, "LocalTopPosition", PlayerInfo[playerid][LocalTopPosition]);
	ini_getInteger(File, "ParticipantsCount", PlayerInfo[playerid][ParticipantsCount]);
    for (new j = 0; j < MAX_SLOTS; j++) 
	{
        format(string, sizeof(string), "InventorySlot%dID", j);
        ini_getInteger(File, string, PlayerInfo[playerid][InventoryItems][j][ID]);
        format(string, sizeof(string), "InventorySlot%dType", j);
        ini_getInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Type]);
		format(string, sizeof(string), "InventorySlot%dGrade", j);
        ini_getInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Grade]);
		for (new x = 0; x < MAX_MOD; x++)
		{
			format(string, sizeof(string), "InventorySlot%dMod%d", j, x);
        	ini_getInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Mod][x]);
		}
		for (new x = 0; x < MAX_PROPERTIES; x++)
		{
			format(string, sizeof(string), "InventorySlot%dProp%d", j, x);
        	ini_getInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Property][x]);
			format(string, sizeof(string), "InventorySlot%dPropVal%d", j, x);
        	ini_getInteger(File, string, PlayerInfo[playerid][InventoryItems][j][PropertyValue][x]);
		}
		format(string, sizeof(string), "InventorySlot%dCount", j);
        ini_getInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Count]);
		format(string, sizeof(string), "InventorySlot%dPrice", j);
        ini_getInteger(File, string, PlayerInfo[playerid][InventoryItems][j][Price]);
    }
    ini_closeFile(File);
}

stock CreateAccount(playerid, name[])
{
	new string[255];
	new path[128];
	format(path, sizeof(path), "Players/%s.ini", name);
	new File = ini_createFile(path);
	if(File < 0)
		File = ini_openFile(path);
	if(!File)
	{
		SendClientMessage(player, COLOR_LIGHTRED, "Account creating failed.");
		return -1;
	}

	ini_setInteger(File, "Rate", 0);
	ini_setInteger(File, "Rank", 1);
    ini_setInteger(File, "Cash", 0);
    ini_setInteger(File, "Sex", 0);
	ini_setFloat(File, "PosX", DEFAULT_POS_X);
    ini_setFloat(File, "PosY", DEFAULT_POS_Y);
    ini_setFloat(File, "PosZ", DEFAULT_POS_Z);
    ini_setFloat(File, "Angle", 0);
    ini_setInteger(File, "Interior", 0);
	ini_setInteger(File, "Skin", DEFAULT_SKIN_MALE);
	ini_setInteger(File, "Admin", 0);
    ini_setInteger(File, "Kills", 0);
    ini_setInteger(File, "Deaths", 0);
    ini_setInteger(File, "DamageMin", DEFAULT_DAMAGE_MIN);
	ini_setInteger(File, "DamageMax", DEFAULT_DAMAGE_MAX);
    ini_setInteger(File, "Defense", DEFAULT_DEFENSE);
    ini_setInteger(File, "Dodge", DEFAULT_DODGE);
    ini_setInteger(File, "Accuracy", DEFAULT_ACCURACY);
	ini_setInteger(File, "Crit", DEFAULT_CRIT);
    ini_setInteger(File, "GlobalTopPosition", 0);
	ini_setInteger(File, "LocalTopPosition", 0);
	ini_setInteger(File, "ParticipantsCount", 0);
    for (new j = 0; j < MAX_SLOTS; j++) 
	{
        format(string, sizeof(string), "InventorySlot%dID", j);
        ini_setInteger(File, string, -1);
        format(string, sizeof(string), "InventorySlot%dType", j);
        ini_setInteger(File, string, 0);
		format(string, sizeof(string), "InventorySlot%dGrade", j);
        ini_setInteger(File, string, 0);
		for (new x = 0; x < MAX_MOD; x++)
		{
			format(string, sizeof(string), "InventorySlot%dMod%d", j, x);
        	ini_setInteger(File, string, 0);
		}
		for (new x = 0; x < MAX_PROPERTIES; x++)
		{
			format(string, sizeof(string), "InventorySlot%dProp%d", j, x);
        	ini_setInteger(File, string, 0);
			format(string, sizeof(string), "InventorySlot%dPropVal%d", j, x);
        	ini_setInteger(File, string, 0);
		}
		format(string, sizeof(string), "InventorySlot%dCount", j);
        ini_setInteger(File, string, 0);
		format(string, sizeof(string), "InventorySlot%dPrice", j);
        ini_setInteger(File, string, 0);
    }
    ini_closeFile(File);

	format(path, sizeof(path), "Players/%s_participants.ini", name);
	File = ini_createFile(path);
	ini_closeFile(File);
	SendClientMessage(player, COLOR_GREEN, "Account created succesfully.");
	return 1;
}

stock GetPlayerMaxHP(playerid)
{
	new Float:max_hp = 1000.0;
	max_hp = floatmul(max_hp, PlayerInfo[playerid][Rank]);
	return max_hp;
}

stock GetColorByRate(rate) {
	new color[16];
	switch (rate) {
	    case 501..1000: color = RateColors[1];
	    case 1001..1200: color = RateColors[2];
	    case 1201..1400: color = RateColors[3];
	    case 1401..1600: color = RateColors[4];
	    case 1601..2000: color = RateColors[5];
	    case 2001..2300: color = RateColors[6];
	    case 2301..2700: color = RateColors[7];
	    case 2701..3000: color = RateColors[8];
	    default: color = RateColors[0];
	}
	return color;
}

stock GetRateInterval(rate) {
	new interval[32];
	switch (rate) {
	    case 501..1000: interval = "Камень";
	    case 1001..1200: interval = "Железо";
	    case 1201..1400: interval = "Бронза";
	    case 1401..1600: interval = "Серебро";
	    case 1601..2000: interval = "Золото";
	    case 2001..2300: interval = "Платина";
	    case 2301..2700: interval = "Алмаз";
	    case 2701..3000: interval = "Бриллиант";
	    default: interval = "Дерево";
	}
	return interval;
}

stock UpdateRatingTop()
{

}

stock InitTextDraws()
{
	GamemodeName1 = TextDrawCreate(550.233215, 23.229616, "Bourgeois");
	TextDrawLetterSize(GamemodeName1, 0.449999, 1.600000);
	TextDrawAlignment(GamemodeName1, 1);
	TextDrawColor(GamemodeName1, -1);
	TextDrawUseBox(GamemodeName1, true);
	TextDrawBoxColor(GamemodeName1, 0);
	TextDrawSetShadow(GamemodeName1, 0);
	TextDrawSetOutline(GamemodeName1, 1);
	TextDrawBackgroundColor(GamemodeName1, 51);
	TextDrawFont(GamemodeName1, 0);
	TextDrawSetProportional(GamemodeName1, 1);

	GamemodeName2 = TextDrawCreate(561.899658, 35.014785, "circus");
	TextDrawLetterSize(GamemodeName2, 0.449999, 1.600000);
	TextDrawAlignment(GamemodeName2, 1);
	TextDrawColor(GamemodeName2, -1);
	TextDrawUseBox(GamemodeName2, true);
	TextDrawBoxColor(GamemodeName2, 0);
	TextDrawSetShadow(GamemodeName2, 0);
	TextDrawSetOutline(GamemodeName2, 1);
	TextDrawBackgroundColor(GamemodeName2, 51);
	TextDrawFont(GamemodeName2, 0);
	TextDrawSetProportional(GamemodeName2, 1);

	WorldTime = TextDrawCreate(576.532958, 50.068149, "23:59");
	TextDrawLetterSize(WorldTime, 0.379332, 1.736888);
	TextDrawAlignment(WorldTime, 2);
	TextDrawColor(WorldTime, -1061109505);
	TextDrawSetShadow(WorldTime, 0);
	TextDrawSetOutline(WorldTime, 1);
	TextDrawBackgroundColor(WorldTime, 51);
	TextDrawFont(WorldTime, 3);
	TextDrawSetProportional(WorldTime, 1);

	new ver_txt[64];
	format(ver_txt, sizeof(ver_txt), "ver %.2f", VERSION);
	Version = TextDrawCreate(632.999633, 2.488877, ver_txt);
	TextDrawLetterSize(Version, 0.200663, 1.255702);
	TextDrawAlignment(Version, 3);
	TextDrawColor(Version, -1);
	TextDrawSetShadow(Version, 0);
	TextDrawSetOutline(Version, 1);
	TextDrawBackgroundColor(Version, 51);
	TextDrawFont(Version, 2);
	TextDrawSetProportional(Version, 1);
}

stock InitPlayerTextDraws(playerid)
{

}

stock ShowTextDraws(playerid)
{
	TextDrawShowForPlayer(playerid, GamemodeName1);
	TextDrawShowForPlayer(playerid, GamemodeName2);
	TextDrawShowForPlayer(playerid, Version);
	TextDrawShowForPlayer(playerid, WorldTime);
}

stock DeleteTextDraws()
{
	TextDrawDestroy(playerid, GamemodeName1);
	TextDrawDestroy(playerid, GamemodeName2);
	TextDrawDestroy(playerid, Version);
	TextDrawDestroy(playerid, WorldTime);
}

stock DeletePlayerTextDraws(playerid)
{

}

stock CreatePickups()
{

}

stock CreateMap()
{
	CreateObject(16006,224.0000000,-1830.0000000,2.2000000,0.0000000,0.0000000,270.0000000); //object(ros_townhall) (1)
	CreateObject(9339,235.0000000,-1826.7998000,3.2000000,0.0000000,0.0000000,0.0000000); //object(sfnvilla001_cm) (3)
	CreateObject(9339,213.1904300,-1826.7998000,2.7000000,0.0000000,0.0000000,0.0000000); //object(sfnvilla001_cm) (5)
	CreateObject(9339,213.1796900,-1826.7998000,3.2000000,0.0000000,0.0000000,0.0000000); //object(sfnvilla001_cm) (6)
	CreateObject(9339,227.0000000,-1813.7998000,3.2000000,0.0000000,0.0000000,90.0000000); //object(sfnvilla001_cm) (7)
	CreateObject(1597,214.0996100,-1818.9004000,5.7000000,1.5000000,0.0000000,0.0000000); //object(cntrlrsac1) (1)
	CreateObject(1597,214.0996100,-1826.9004000,5.5000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1) (2)
	CreateObject(1597,214.0996100,-1834.9004000,5.5000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1) (3)
	CreateObject(9339,215.4502000,-1826.7998000,3.2000000,0.0000000,0.0000000,0.0000000); //object(sfnvilla001_cm) (8)
	CreateObject(748,214.2002000,-1815.4004000,3.7000000,0.0000000,0.0000000,270.0000000); //object(sm_scrb_grp1) (3)
	CreateObject(748,214.3554700,-1838.0898000,3.1000000,0.0000000,0.0000000,90.0000000); //object(sm_scrb_grp1) (5)
	CreateObject(1231,219.4697300,-1839.7197000,4.7000000,0.0000000,0.0000000,353.9960000); //object(streetlamp2) (1)
	CreateObject(748,233.9003900,-1838.0000000,3.0000000,0.0000000,0.0000000,90.0000000); //object(sm_scrb_grp1) (1)
	CreateObject(1597,233.7002000,-1834.2998000,5.5000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1) (4)
	CreateObject(1597,233.7002000,-1826.2998000,5.5000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1) (5)
	CreateObject(1597,233.7002000,-1818.5996000,5.7000000,1.0000000,0.0000000,0.0000000); //object(cntrlrsac1) (6)
	CreateObject(748,233.8999900,-1815.4000000,3.7000000,0.0000000,0.0000000,270.0000000); //object(sm_scrb_grp1) (2)
	CreateObject(9339,232.7998000,-1826.7998000,3.2000000,0.0000000,0.0000000,0.0000000); //object(sfnvilla001_cm) (1)
	CreateObject(1231,228.0996100,-1839.6895000,4.7000000,0.0000000,0.0000000,179.9950000); //object(streetlamp2) (2)
	CreateObject(10401,210.5996100,-1826.7998000,5.0000000,2.9990000,0.0000000,314.9950000); //object(hc_shed02_sfs) (1)
	CreateObject(10401,248.8496100,-1826.7998000,5.0000000,2.9940000,0.0000000,314.9950000); //object(hc_shed02_sfs) (2)
	CreateObject(5848,224.2000000,-1780.5000000,8.7000000,0.0000000,0.0000000,351.8000000); //object(mainblk_lawn) (1)
	CreateObject(9339,220.9900100,-1813.7998000,3.2000000,0.0000000,0.0000000,90.0000000); //object(sfnvilla001_cm) (2)
	CreateObject(9339,259.0000000,-1813.7998000,3.2000000,0.0000000,0.0000000,90.0000000); //object(sfnvilla001_cm) (4)
	CreateObject(9339,251.4003900,-1826.7998000,3.2000000,0.0000000,0.0000000,0.0000000); //object(sfnvilla001_cm) (9)
	CreateObject(9339,196.7998000,-1826.7998000,3.2000000,0.0000000,0.0000000,0.0000000); //object(sfnvilla001_cm) (10)
	CreateObject(9339,189.0000000,-1813.7998000,3.2000000,0.0000000,0.0000000,90.0000000); //object(sfnvilla001_cm) (11)
	CreateObject(18241,194.5000000,-1780.5898000,3.0000000,0.0000000,0.0000000,358.0000000); //object(cuntw_weebuild) (1)
	CreateObject(18241,254.3500100,-1780.2000000,3.0000000,0.0000000,0.0000000,0.0000000); //object(cuntw_weebuild) (2)
	CreateObject(7231,223.6000100,-1796.8000000,23.0000000,0.0000000,0.0000000,0.0000000); //object(clwnpocksgn_d) (1)
	CreateObject(1368,199.3000000,-1814.4000000,4.1300000,0.0000000,0.0000000,0.0000000); //object(cj_blocker_bench) (1)
	CreateObject(1361,201.1000100,-1814.6000000,4.2000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (1)
	CreateObject(1361,197.5000000,-1814.6000000,4.2000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (2)
	CreateObject(2631,224.0000000,-1840.1000000,2.5500000,0.0000000,0.0000000,0.0000000); //object(gym_mat1) (1)
	CreateObject(1361,212.3999900,-1814.6000000,4.2000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (3)
	CreateObject(1368,210.6600000,-1814.6000000,4.1000000,0.0000000,0.0000000,0.0000000); //object(cj_blocker_bench) (2)
	CreateObject(1361,208.8000000,-1814.6000000,4.2000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (4)
	CreateObject(3640,183.8999900,-1819.8000000,7.6000000,0.0000000,0.0000000,0.0000000); //object(glenphouse02_lax) (1)
	CreateObject(2027,178.3000000,-1830.4000000,3.6000000,0.0000000,0.0000000,0.0000000); //object(dinerseat_4) (2)
	CreateObject(2027,182.3000000,-1833.1000000,3.6000000,0.0000000,0.0000000,0.0000000); //object(dinerseat_4) (3)
	CreateObject(2027,178.3000000,-1837.1000000,3.6000000,0.0000000,0.0000000,0.0000000); //object(dinerseat_4) (4)
	CreateObject(642,182.3000000,-1833.1200000,4.4000000,0.0000000,0.0000000,0.0000000); //object(kb_canopy_test) (1)
	CreateObject(642,178.3000000,-1830.4000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(kb_canopy_test) (2)
	CreateObject(716,194.2000000,-1816.8000000,3.4000000,0.0000000,0.0000000,0.0000000); //object(sjmpalmbigpv) (1)
	CreateObject(716,194.2000000,-1819.9000000,3.4000000,0.0000000,0.0000000,0.0000000); //object(sjmpalmbigpv) (2)
	CreateObject(716,194.2000000,-1823.0000000,3.4000000,0.0000000,0.0000000,0.0000000); //object(sjmpalmbigpv) (3)
	CreateObject(642,178.3000000,-1837.1000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(kb_canopy_test) (3)
	CreateObject(716,174.5000000,-1823.0000000,3.4000000,0.0000000,0.0000000,0.0000000); //object(sjmpalmbigpv) (4)
	CreateObject(716,174.5000000,-1819.9000000,3.4000000,0.0000000,0.0000000,0.0000000); //object(sjmpalmbigpv) (5)
	CreateObject(716,174.5000000,-1816.8000000,3.4000000,0.0000000,0.0000000,0.0000000); //object(sjmpalmbigpv) (6)
	CreateObject(1368,196.1000100,-1828.0000000,3.7300000,0.0000000,2.0000000,270.0000000); //object(cj_blocker_bench) (3)
	CreateObject(1368,196.1000100,-1832.0000000,3.6000000,0.0000000,2.0000000,270.0000000); //object(cj_blocker_bench) (4)
	CreateObject(1368,196.1000100,-1836.1000000,3.4800000,0.0000000,2.0000000,270.0000000); //object(cj_blocker_bench) (5)
	CreateObject(1361,196.1000100,-1830.0300000,3.7300000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (5)
	CreateObject(1361,196.1000100,-1834.0500000,3.6000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (6)
	CreateObject(1361,196.1000100,-1826.0500000,3.7300000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (7)
	CreateObject(1361,196.1000100,-1838.1000000,3.4800000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (8)
	CreateObject(1231,212.9600100,-1839.6700000,4.7000000,0.0000000,0.0000000,175.0000000); //object(streetlamp2) (3)
	CreateObject(1231,197.0300000,-1839.7000000,4.7000000,0.0000000,0.0000000,359.0000000); //object(streetlamp2) (4)
	CreateObject(1231,251.2000000,-1839.7000000,4.7000000,0.0000000,0.0000000,179.9950000); //object(streetlamp2) (5)
	CreateObject(1231,235.2000000,-1839.7100000,4.7000000,0.0000000,0.0000000,358.9950000); //object(streetlamp2) (6)
	CreateObject(1445,185.7000000,-1826.4000000,3.7000000,0.0000000,0.0000000,0.0000000); //object(dyn_ff_stand) (1)
	CreateObject(1445,183.2000000,-1826.4000000,3.7000000,0.0000000,0.0000000,0.0000000); //object(dyn_ff_stand) (2)
	CreateObject(3618,261.7000100,-1820.8800000,5.5000000,0.0000000,0.0000000,0.0000000); //object(nwlaw2husjm3_law2) (1)
	CreateObject(1646,254.0000000,-1832.5000000,3.0000000,0.0000000,0.0000000,0.0000000); //object(lounge_towel_up) (1)
	CreateObject(1646,255.0000000,-1832.5000000,3.0000000,0.0000000,0.0000000,0.0000000); //object(lounge_towel_up) (2)
	CreateObject(1646,256.0000000,-1832.5000000,3.0000000,0.0000000,0.0000000,0.0000000); //object(lounge_towel_up) (3)
	CreateObject(1597,257.1000100,-1830.6000000,5.3000000,0.0000000,0.0000000,90.0000000); //object(cntrlrsac1) (7)
	CreateObject(642,257.0000000,-1832.5000000,4.0000000,0.0000000,0.0000000,0.0000000); //object(kb_canopy_test) (4)
	CreateObject(1646,258.0000000,-1832.5000000,3.0000000,0.0000000,0.0000000,0.0000000); //object(lounge_towel_up) (4)
	CreateObject(1646,259.0000000,-1832.5000000,3.0000000,0.0000000,0.0000000,0.0000000); //object(lounge_towel_up) (5)
	CreateObject(1646,260.0000000,-1832.5000000,3.0000000,0.0000000,0.0000000,0.0000000); //object(lounge_towel_up) (6)
	CreateObject(1361,235.6000100,-1814.5000000,4.0000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (9)
	CreateObject(1368,237.3999900,-1814.5000000,3.9500000,0.0000000,1.0000000,0.0000000); //object(cj_blocker_bench) (6)
	CreateObject(1361,239.2000000,-1814.5000000,4.0000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (10)
	CreateObject(1361,250.6000100,-1814.5000000,4.0000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (11)
	CreateObject(1368,248.8000000,-1814.5000000,3.9000000,0.0000000,0.0000000,0.0000000); //object(cj_blocker_bench) (7)
	CreateObject(1361,246.9299900,-1814.5000000,4.0000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop2) (12)
	CreateObject(2226,257.0000000,-1832.8000000,2.7000000,0.0000000,0.0000000,0.0000000); //object(low_hi_fi_3) (1)
	CreateObject(2754,244.6000100,-1788.1000000,4.2000000,0.0000000,0.0000000,90.0000000); //object(otb_machine) (1)
	CreateObject(2754,259.1000100,-1822.2000000,4.2000000,0.0000000,0.0000000,90.0000000); //object(otb_machine) (2)
	CreateObject(2755,204.8000000,-1831.0000000,3.0000000,90.0000000,0.0000000,0.0000000); //object(dojo_wall) (1)
	CreateObject(2755,243.1000100,-1831.0000000,2.8000000,90.0000000,0.0000000,0.0000000); //object(dojo_wall) (2)
	CreateObject(2098,204.8000000,-1831.1000000,5.0000000,0.0000000,0.0000000,0.0000000); //object(cj_slotcover1) (1)
	CreateObject(2098,243.1000100,-1831.1000000,4.7000000,0.0000000,0.0000000,0.0000000); //object(cj_slotcover1) (2)
	CreateObject(13607,-2351.8999000,-1630.5000000,726.0999800,0.0000000,0.0000000,0.0000000); //object(ringwalls) (1)
	CreateObject(8417,-2372.2000000,-1651.9000000,722.2999900,0.0000000,0.0000000,0.0000000); //object(bballcourt01_lvs) (2)
	CreateObject(8417,-2331.3000500,-1651.9000200,722.2999900,0.0000000,0.0000000,0.0000000); //object(bballcourt01_lvs) (3)
	CreateObject(8417,-2372.5000000,-1609.1999500,722.2999900,0.0000000,0.0000000,0.0000000); //object(bballcourt01_lvs) (4)
	CreateObject(8417,-2331.3999000,-1609.4000000,722.2999900,0.0000000,0.0000000,0.0000000); //object(bballcourt01_lvs) (5)
	CreateObject(3452,-2378.0000000,-1680.4004000,725.4000200,0.0000000,0.0000000,0.0000000); //object(bballintvgn1) (3)
	CreateObject(3452,-2334.8000000,-1680.3000000,725.4000200,0.0000000,0.0000000,0.0000000); //object(bballintvgn1) (5)
	CreateObject(3453,-2307.5000000,-1673.9000000,725.4000200,0.0000000,0.0000000,0.0000000); //object(bballintvgn2) (3)
	CreateObject(3452,-2348.4001000,-1680.4000000,725.4000200,0.0000000,0.0000000,0.0000000); //object(bballintvgn1) (7)
	CreateObject(3453,-2394.7000000,-1674.9000000,725.4000200,0.0000000,0.0000000,270.0000000); //object(bballintvgn2) (4)
	CreateObject(3452,-2401.1001000,-1645.6000000,725.4000200,0.0000000,0.0000000,270.0000000); //object(bballintvgn1) (8)
	CreateObject(3453,-2308.3999000,-1586.2000000,725.4000200,0.0000000,0.0000000,90.0000000); //object(bballintvgn2) (5)
	CreateObject(3453,-2395.7000000,-1587.2000000,725.4000200,0.0000000,0.0000000,180.0000000); //object(bballintvgn2) (6)
	CreateObject(3452,-2401.1001000,-1616.0000000,725.4000200,0.0000000,0.0000000,270.0000000); //object(bballintvgn1) (9)
	CreateObject(3452,-2366.5996000,-1580.7998000,725.4000200,0.0000000,0.0000000,179.9950000); //object(bballintvgn1) (10)
	CreateObject(3452,-2337.2000000,-1580.8000000,725.4000200,0.0000000,0.0000000,179.9950000); //object(bballintvgn1) (11)
	CreateObject(3452,-2302.0015000,-1615.3000000,725.4000200,0.0000000,0.0000000,90.0000000); //object(bballintvgn1) (12)
	CreateObject(3452,-2302.0000000,-1644.2002000,725.4000200,0.0000000,0.0000000,89.9840000); //object(bballintvgn1) (13)
	CreateObject(7617,-2355.3000000,-1570.6000000,738.7999900,0.0000000,0.0000000,0.0000000); //object(vgnbballscorebrd) (1)
	CreateObject(7617,-2352.3999000,-1690.5000000,738.7999900,0.0000000,0.0000000,0.0000000); //object(vgnbballscorebrd) (2)
	CreateObject(3398,-2313.1001000,-1688.6000000,741.7000100,0.0000000,0.0000000,0.0000000); //object(cxrf_floodlite_) (1)
	CreateObject(3398,-2390.2000000,-1689.2000000,741.7000100,0.0000000,0.0000000,0.0000000); //object(cxrf_floodlite_) (2)
	CreateObject(3398,-2390.0000000,-1572.1000000,741.7000100,0.0000000,0.0000000,0.0000000); //object(cxrf_floodlite_) (3)
	CreateObject(3398,-2312.8000000,-1572.2000000,741.7000100,0.0000000,0.0000000,0.0000000); //object(cxrf_floodlite_) (4)
	CreateObject(1232,-2370.3000000,-1672.2000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (1)
	CreateObject(1232,-2365.3999000,-1672.2000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (2)
	CreateObject(1232,-2322.5000000,-1671.9000000,724.4002700,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (3)
	CreateObject(1232,-2327.0000000,-1672.1000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (4)
	CreateObject(1232,-2310.1001000,-1631.4000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (5)
	CreateObject(1232,-2310.5000000,-1636.6000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (6)
	CreateObject(1232,-2310.7000000,-1602.8000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (7)
	CreateObject(1232,-2310.7000000,-1607.8000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (8)
	CreateObject(1232,-2349.8000000,-1589.2000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (9)
	CreateObject(1232,-2344.7998000,-1589.4004000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (10)
	CreateObject(1232,-2379.2000000,-1588.9000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (11)
	CreateObject(1232,-2373.8999000,-1589.0000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (12)
	CreateObject(1232,-2392.3000000,-1628.7000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (13)
	CreateObject(1232,-2392.2000000,-1623.4000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (14)
	CreateObject(1232,-2392.1001000,-1658.4000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (15)
	CreateObject(1232,-2392.3000000,-1653.1000000,724.4000200,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (16)
	CreateObject(3434,-2295.1001000,-1627.7000000,741.7999900,0.0000000,0.0000000,270.0000000); //object(skllsgn01_lvs) (2)
	CreateObject(7313,-2352.6001000,-1689.1000000,733.7999900,0.0000000,0.0000000,180.0000000); //object(vgsn_scrollsgn01) (1)
	CreateObject(7313,-2355.5000000,-1572.1000000,733.7999900,0.0000000,0.0000000,0.0000000); //object(vgsn_scrollsgn01) (2)
	CreateObject(7231,-2412.1001000,-1631.4000000,749.2000100,0.0000000,0.0000000,90.0000000); //object(clwnpocksgn_d) (2)
	CreateObject(996,-2361.7000000,-1671.5000000,723.5000000,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier1) (1)
	CreateObject(996,-2383.3000000,-1671.5000000,723.5000000,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier1) (2)
	CreateObject(996,-2353.3000000,-1671.5000000,723.5000000,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier1) (3)
	CreateObject(996,-2345.0000000,-1671.5000000,723.5000000,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier1) (4)
	CreateObject(996,-2336.7000000,-1671.5000000,723.5000000,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier1) (5)
	CreateObject(996,-2316.2000000,-1670.8000000,723.5000000,0.0000000,0.0000000,46.0000000); //object(lhouse_barrier1) (6)
	CreateObject(996,-2311.0000000,-1664.7000000,723.5000000,0.0000000,0.0000000,90.0000000); //object(lhouse_barrier1) (7)
	CreateObject(996,-2311.0000000,-1656.4000000,723.5000000,0.0000000,0.0000000,89.9950000); //object(lhouse_barrier1) (8)
	CreateObject(996,-2311.0000000,-1648.1000000,723.5000000,0.0000000,0.0000000,89.9950000); //object(lhouse_barrier1) (9)
	CreateObject(996,-2310.8999000,-1628.9000000,723.5000000,0.0000000,0.0000000,89.9950000); //object(lhouse_barrier1) (10)
	CreateObject(996,-2310.8999000,-1620.6000000,723.5000000,0.0000000,0.0000000,89.9950000); //object(lhouse_barrier1) (11)
	CreateObject(996,-2311.2000000,-1595.0000000,723.5000000,0.0000000,0.0000000,133.9950000); //object(lhouse_barrier1) (12)
	CreateObject(996,-2317.3999000,-1589.5000000,723.5000000,0.0000000,0.0000000,179.9890000); //object(lhouse_barrier1) (13)
	CreateObject(996,-2325.7000000,-1589.6000000,723.5000000,0.0000000,0.0000000,179.9890000); //object(lhouse_barrier1) (14)
	CreateObject(996,-2334.0000000,-1589.7000000,723.5000000,0.0000000,0.0000000,179.9890000); //object(lhouse_barrier1) (15)
	CreateObject(996,-2353.3000000,-1589.8000000,723.5000000,0.0000000,0.0000000,179.9890000); //object(lhouse_barrier1) (16)
	CreateObject(996,-2362.0000000,-1589.7000000,723.5000000,0.0000000,0.0000000,179.9890000); //object(lhouse_barrier1) (17)
	CreateObject(996,-2386.3999000,-1590.2000000,723.5000000,0.0000000,0.0000000,219.9890000); //object(lhouse_barrier1) (18)
	CreateObject(996,-2392.2000000,-1596.2000000,723.5000000,0.0000000,0.0000000,269.9850000); //object(lhouse_barrier1) (19)
	CreateObject(996,-2392.2000000,-1604.5000000,723.5000000,0.0000000,0.0000000,269.9840000); //object(lhouse_barrier1) (20)
	CreateObject(996,-2392.2000000,-1612.8000000,723.5000000,0.0000000,0.0000000,269.9840000); //object(lhouse_barrier1) (21)
	CreateObject(996,-2392.2000000,-1631.9000000,723.5000000,0.0000000,0.0000000,269.9840000); //object(lhouse_barrier1) (22)
	CreateObject(996,-2392.2000000,-1640.4000000,723.5000000,0.0000000,0.0000000,269.9840000); //object(lhouse_barrier1) (23)
	CreateObject(996,-2391.6001000,-1666.0000000,723.5000000,0.0000000,0.0000000,315.9840000); //object(lhouse_barrier1) (24)
	CreateObject(5154,-2442.3999000,-1633.4000000,763.5000000,0.0000000,0.0000000,0.0000000); //object(dk_cargoshp03d) (1)
	CreateObject(5154,-2256.7000000,-1624.8000000,763.5000000,0.0000000,0.0000000,0.0000000); //object(dk_cargoshp03d) (2)
	CreateObject(3524,-2250.5000000,-1615.0000000,769.5999800,0.0000000,0.0000000,322.0000000); //object(skullpillar01_lvs) (2)
	CreateObject(3524,-2250.5000000,-1634.5000000,769.5999800,0.0000000,0.0000000,225.9980000); //object(skullpillar01_lvs) (3)
	CreateObject(3524,-2263.3000000,-1634.7000000,769.5999800,0.0000000,0.0000000,137.9940000); //object(skullpillar01_lvs) (4)
	CreateObject(3524,-2263.1001000,-1615.1000000,769.5999800,0.0000000,0.0000000,41.9940000); //object(skullpillar01_lvs) (5)
	CreateObject(3524,-2435.8999000,-1623.7000000,769.5999800,0.0000000,0.0000000,321.9980000); //object(skullpillar01_lvs) (6)
	CreateObject(3524,-2448.8999000,-1623.8000000,769.5999800,0.0000000,0.0000000,47.9980000); //object(skullpillar01_lvs) (7)
	CreateObject(3524,-2448.8999000,-1643.2000000,769.5999800,0.0000000,0.0000000,141.9940000); //object(skullpillar01_lvs) (8)
	CreateObject(3524,-2435.8999000,-1643.2000000,769.5999800,0.0000000,0.0000000,223.9930000); //object(skullpillar01_lvs) (9)
	CreateObject(2611,-2171.6001000,645.5999800,1053.3000000,0.0000000,0.0000000,90.0000000); //object(police_nb1) (1)
}