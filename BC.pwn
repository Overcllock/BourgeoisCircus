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
#include <crp>

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
forward Float:GetPlayerMaxHP(playerid);
forward Float:GetPlayerHP(playerid);
forward SetPlayerHP(playerid, Float:hp);

/* Variables */

//Global
new WorldTime_Timer = -1;
new Actors[MAX_ACTORS];

//Pickups
new home_enter = -1;
new home_quit = -1;
new start_tp1 = -1;
new start_tp2 = -1;

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
new PlayerInventory[MAX_PLAYERS][MAX_SLOTS][iInfo];
new PlayerInfo[MAX_PLAYERS][pInfo];
new PlayerHPMultiplicator[MAX_PLAYERS];
new PlayerUpdater[MAX_PLAYERS];
new PlayerConnect[MAX_PLAYERS];
new bool:IsInventoryOpen[MAX_PLAYERS] = false;
new bool:IsDeath[MAX_PLAYERS] = false;
new SelectedSlot[MAX_PLAYERS] = -1;

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

//Player
new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:HPBar[MAX_PLAYERS];
new PlayerText:ChrInfoBox[MAX_PLAYERS];
new PlayerText:ChrInfoHeader[MAX_PLAYERS];
new PlayerText:ChrInfoDelim1[MAX_PLAYERS];
new PlayerText:ChrInfMaxHP[MAX_PLAYERS];
new PlayerText:ChrInfDamage[MAX_PLAYERS];
new PlayerText:ChrInfDefense[MAX_PLAYERS];
new PlayerText:ChrInfAccuracy[MAX_PLAYERS];
new PlayerText:ChrInfDodge[MAX_PLAYERS];
new PlayerText:ChrInfDelim2[MAX_PLAYERS];
new PlayerText:ChrInfArmorSlot[MAX_PLAYERS];
new PlayerText:ChrInfWeaponSlot[MAX_PLAYERS];
new PlayerText:ChrInfAccSlot1[MAX_PLAYERS];
new PlayerText:ChrInfAccSlot2[MAX_PLAYERS];
new PlayerText:ChrInfClose[MAX_PLAYERS];
new PlayerText:Textdraw16[MAX_PLAYERS];
new PlayerText:Textdraw17[MAX_PLAYERS];
new PlayerText:Textdraw18[MAX_PLAYERS];
new PlayerText:Textdraw19[MAX_PLAYERS];
new PlayerText:Textdraw20[MAX_PLAYERS];
new PlayerText:Textdraw21[MAX_PLAYERS];
new PlayerText:Textdraw22[MAX_PLAYERS];
new PlayerText:Textdraw23[MAX_PLAYERS];
new PlayerText:Textdraw24[MAX_PLAYERS];
new PlayerText:Textdraw25[MAX_PLAYERS];
new PlayerText:Textdraw26[MAX_PLAYERS];
new PlayerText:Textdraw27[MAX_PLAYERS];
new PlayerText:Textdraw28[MAX_PLAYERS];
new PlayerText:Textdraw29[MAX_PLAYERS];
new PlayerText:Textdraw30[MAX_PLAYERS];
new PlayerText:Textdraw31[MAX_PLAYERS];
new PlayerText:Textdraw32[MAX_PLAYERS];
new PlayerText:Textdraw33[MAX_PLAYERS];
new PlayerText:Textdraw34[MAX_PLAYERS];
new PlayerText:Textdraw35[MAX_PLAYERS];
new PlayerText:Textdraw36[MAX_PLAYERS];
new PlayerText:Textdraw37[MAX_PLAYERS];
new PlayerText:Textdraw38[MAX_PLAYERS];
new PlayerText:Textdraw39[MAX_PLAYERS];
new PlayerText:Textdraw40[MAX_PLAYERS];
new PlayerText:Textdraw41[MAX_PLAYERS];
new PlayerText:Textdraw42[MAX_PLAYERS];
new PlayerText:Textdraw43[MAX_PLAYERS];
new PlayerText:Textdraw44[MAX_PLAYERS];
new PlayerText:Textdraw45[MAX_PLAYERS];
new PlayerText:Textdraw46[MAX_PLAYERS];
new PlayerText:Textdraw47[MAX_PLAYERS];
new PlayerText:Textdraw48[MAX_PLAYERS];
new PlayerText:Textdraw49[MAX_PLAYERS];
new PlayerText:Textdraw50[MAX_PLAYERS];
new PlayerText:Textdraw51[MAX_PLAYERS];
new PlayerText:Textdraw52[MAX_PLAYERS];
new PlayerText:Textdraw53[MAX_PLAYERS];
new PlayerText:Textdraw54[MAX_PLAYERS];

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
	for (new i = 0; i < MAX_ACTORS; i++)
		DestroyActor(Actors[i]);
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
	//ShowInterface(playerid);
	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;
	PlayerHPMultiplicator[playerid] = PlayerInfo[playerid][Rank] * 10;
	if(PlayerHPMultiplicator[playerid] <= 10)
		PlayerHPMultiplicator[playerid] = 10;
	
	SpawnPlayer(playerid);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
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
	SetPlayerHealth(playerid, 100.0);
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
	SetPlayerColor(playerid, HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
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
	if(PlayerInfo[playerid][Admin] > 0)
	{
		format(message, sizeof(message), "[Администратор]: %s", text);
		SendClientMessageToAll(COLOR_LIGHTRED, message);
	}
	else
	{
		format(message, sizeof(message), "[%s]: %s", name, text);
		SendClientMessageToAll(HexRateColors[PlayerInfo[playerid][Rank]-1][0], message);
	}
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/spawn", cmdtext, true, 10) == 0)
	{
		if(PlayerInfo[playerid][Admin] == 0)
			return 0;

	    SetPlayerPos(playerid, 224.0761,-1839.8217,3.6037);
	    SetPlayerInterior(playerid, 0);
		return 1;
	}
	if (strcmp("/kill", cmdtext, true, 10) == 0)
	{
		if(PlayerInfo[playerid][Admin] == 0)
			return 0;

	    SetPlayerHealth(playerid, 0);
		return 1;
	}
	if (strcmp("/arena1", cmdtext, true, 10) == 0)
	{
		if(PlayerInfo[playerid][Admin] == 0)
			return 0;
			
	    SetPlayerPos(playerid, -2443.683,-1633.3514,767.6721);
	    SetPlayerInterior(playerid, 0);
		return 1;
	}
	if (strcmp("/arena2", cmdtext, true, 10) == 0)
	{
		if(PlayerInfo[playerid][Admin] == 0)
			return 0;
			
	    SetPlayerPos(playerid, -2256.331,-1625.8031,767.6721);
	    SetPlayerInterior(playerid, 0);
		return 1;
	}
	if (strcmp("/arena3", cmdtext, true, 10) == 0)
	{
		if(PlayerInfo[playerid][Admin] == 0)
			return 0;
			
	    SetPlayerPos(playerid, -2353.16186,-1630.952,723.561);
	    SetPlayerInterior(playerid, 0);
		return 1;
	}
	return 0;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if (pickupid == home_enter)
	{
	    SetPlayerPos(playerid, -2160.8616,641.5761,1052.3817);
	    SetPlayerFacingAngle(playerid, 90);
	    SetPlayerInterior(playerid, 1);
		SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == home_quit)
	{
	    SetPlayerPos(playerid, 224.0981,-1839.8425,3.6037);
	    SetPlayerFacingAngle(playerid, 180);
	    SetPlayerInterior(playerid, 0);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == start_tp1) 
	{

	}
    else if (pickupid == start_tp2) 
	{
	    
	}
	return 1;
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

public Float:GetPlayerMaxHP(playerid)
{
	new Float:max_hp = 1000.0;
	max_hp = floatmul(max_hp, PlayerInfo[playerid][Rank]);
	if(max_hp < 1000)
	    max_hp = 1000.0;
	return max_hp;
}

public Float:GetDistanceBetweenPlayers(p1,p2)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
		return -1.0;
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,
		y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

public SetPlayerHP(playerid, Float:hp)
{
	new Float:max_hp = GetPlayerMaxHP(playerid);
	if(hp > max_hp)
		hp = max_hp;
	new Float:value = floatdiv(hp, PlayerHPMultiplicator[playerid]);
	
	SetPlayerHealth(playerid, value);
}

public Float:GetPlayerHP(playerid)
{
	new Float:hp;
	GetPlayerHealth(playerid, hp);
	hp = floatmul(hp, PlayerHPMultiplicator[playerid]);
	hp = floatround(hp);
	return hp;
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
        ini_setInteger(File, string, PlayerInventory[playerid][j][ID]);
        format(string, sizeof(string), "InventorySlot%dType", j);
        ini_setInteger(File, string, PlayerInventory[playerid][j][Type]);
		format(string, sizeof(string), "InventorySlot%dGrade", j);
        ini_setInteger(File, string, PlayerInventory[playerid][j][Grade]);
		for (new x = 0; x < MAX_MOD; x++)
		{
			format(string, sizeof(string), "InventorySlot%dMod%d", j, x);
        	ini_setInteger(File, string, PlayerInventory[playerid][j][Mod][x]);
		}
		for (new x = 0; x < MAX_PROPERTIES; x++)
		{
			format(string, sizeof(string), "InventorySlot%dProp%d", j, x);
        	ini_setInteger(File, string, PlayerInventory[playerid][j][Property][x]);
			format(string, sizeof(string), "InventorySlot%dPropVal%d", j, x);
        	ini_setInteger(File, string, PlayerInventory[playerid][j][PropertyValue][x]);
		}
		format(string, sizeof(string), "InventorySlot%dCount", j);
        ini_setInteger(File, string, PlayerInventory[playerid][j][Count]);
		format(string, sizeof(string), "InventorySlot%dPrice", j);
        ini_setInteger(File, string, PlayerInventory[playerid][j][Price]);
    }
    ini_closeFile(File);
    return 1;
}

stock LoadAccount(playerid)
{
	new name[64];
	new string[255];
	GetPlayerName(playerid, name, sizeof(name));
    new path[128];
	format(path, sizeof(path), "Players/%s.ini", name);
	new File = ini_openFile(path);
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
        ini_getInteger(File, string, PlayerInventory[playerid][j][ID]);
        format(string, sizeof(string), "InventorySlot%dType", j);
        ini_getInteger(File, string, PlayerInventory[playerid][j][Type]);
		format(string, sizeof(string), "InventorySlot%dGrade", j);
        ini_getInteger(File, string, PlayerInventory[playerid][j][Grade]);
		for (new x = 0; x < MAX_MOD; x++)
		{
			format(string, sizeof(string), "InventorySlot%dMod%d", j, x);
        	ini_getInteger(File, string, PlayerInventory[playerid][j][Mod][x]);
		}
		for (new x = 0; x < MAX_PROPERTIES; x++)
		{
			format(string, sizeof(string), "InventorySlot%dProp%d", j, x);
        	ini_getInteger(File, string, PlayerInventory[playerid][j][Property][x]);
			format(string, sizeof(string), "InventorySlot%dPropVal%d", j, x);
        	ini_getInteger(File, string, PlayerInventory[playerid][j][PropertyValue][x]);
		}
		format(string, sizeof(string), "InventorySlot%dCount", j);
        ini_getInteger(File, string, PlayerInventory[playerid][j][Count]);
		format(string, sizeof(string), "InventorySlot%dPrice", j);
        ini_getInteger(File, string, PlayerInventory[playerid][j][Price]);
    }
    ini_closeFile(File);
    return 1;
}

stock CreateAccount(playerid, name[])
{
	new string[255];
	new path[128];
	format(path, sizeof(path), "Players/%s.ini", name);
	new File = ini_createFile(path);
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
	new File2 = ini_createFile(path);
	ini_setString(File2, "Owner", name);
	ini_closeFile(File2);
	SendClientMessage(playerid, COLOR_GREEN, "Account created succesfully.");
	return 1;
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
	HPBar[playerid] = CreatePlayerTextDraw(playerid, 577.599609, 67.365921, "100% 10000/10000");
	PlayerTextDrawLetterSize(playerid, HPBar[playerid], 0.174998, 0.766222);
	PlayerTextDrawAlignment(playerid, HPBar[playerid], 2);
	PlayerTextDrawColor(playerid, HPBar[playerid], 255);
	PlayerTextDrawSetShadow(playerid, HPBar[playerid], 0);
	PlayerTextDrawSetOutline(playerid, HPBar[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, HPBar[playerid], 51);
	PlayerTextDrawFont(playerid, HPBar[playerid], 1);
	PlayerTextDrawSetProportional(playerid, HPBar[playerid], 1);

	ChrInfoBox[playerid] = CreatePlayerTextDraw(playerid, 499.533386, 107.319213, "chrinfobox");
	PlayerTextDrawLetterSize(playerid, ChrInfoBox[playerid], 0.000000, 22.429840);
	PlayerTextDrawTextSize(playerid, ChrInfoBox[playerid], 606.567382, 0.000000);
	PlayerTextDrawAlignment(playerid, ChrInfoBox[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfoBox[playerid], 102);
	PlayerTextDrawSetShadow(playerid, ChrInfoBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfoBox[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfoBox[playerid], 0);

	ChrInfoHeader[playerid] = CreatePlayerTextDraw(playerid, 551.999877, 107.436988, "Character");
	PlayerTextDrawLetterSize(playerid, ChrInfoHeader[playerid], 0.235999, 0.932147);
	PlayerTextDrawAlignment(playerid, ChrInfoHeader[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfoHeader[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfoHeader[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfoHeader[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoHeader[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfoHeader[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoHeader[playerid], 1);

	ChrInfoDelim1[playerid] = CreatePlayerTextDraw(playerid, 498.299621, 116.480003, "chrinfo_delim1");
	PlayerTextDrawLetterSize(playerid, ChrInfoDelim1[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, ChrInfoDelim1[playerid], 108.999992, 2.074074);
	PlayerTextDrawAlignment(playerid, ChrInfoDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoDelim1[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, ChrInfoDelim1[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfoDelim1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfoDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfoDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfMaxHP[playerid] = CreatePlayerTextDraw(playerid, 501.333282, 119.881446, "HP: 10000/10000");
	PlayerTextDrawLetterSize(playerid, ChrInfMaxHP[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfMaxHP[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfMaxHP[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfMaxHP[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfMaxHP[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfMaxHP[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfMaxHP[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfMaxHP[playerid], 1);

	ChrInfDamage[playerid] = CreatePlayerTextDraw(playerid, 501.366607, 126.605903, "Damage: 9999-9999");
	PlayerTextDrawLetterSize(playerid, ChrInfDamage[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDamage[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDamage[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDamage[playerid], 1);

	ChrInfDefense[playerid] = CreatePlayerTextDraw(playerid, 501.533477, 133.164413, "Defense: 9999");
	PlayerTextDrawLetterSize(playerid, ChrInfDefense[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDefense[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDefense[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDefense[playerid], 1);

	ChrInfAccuracy[playerid] = CreatePlayerTextDraw(playerid, 501.566833, 139.515502, "Accuracy: 999");
	PlayerTextDrawLetterSize(playerid, ChrInfAccuracy[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAccuracy[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccuracy[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfAccuracy[playerid], 1);

	ChrInfDodge[playerid] = CreatePlayerTextDraw(playerid, 501.533447, 145.534683, "Dodge: 999");
	PlayerTextDrawLetterSize(playerid, ChrInfDodge[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfDodge[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDodge[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDodge[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDodge[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDodge[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDodge[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDodge[playerid], 1);

	ChrInfDelim2[playerid] = CreatePlayerTextDraw(playerid, 498.466400, 153.693481, "chrinfo_delim2");
	PlayerTextDrawLetterSize(playerid, ChrInfDelim2[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, ChrInfDelim2[playerid], 108.999992, 2.074074);
	PlayerTextDrawAlignment(playerid, ChrInfDelim2[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDelim2[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, ChrInfDelim2[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim2[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim2[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim2[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfArmorSlot[playerid] = CreatePlayerTextDraw(playerid, 591.000000, 121.000000, "armor_slot");
	PlayerTextDrawLetterSize(playerid, ChrInfArmorSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfArmorSlot[playerid], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, ChrInfArmorSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfArmorSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfArmorSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfArmorSlot[playerid], 255);
	PlayerTextDrawSetShadow(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfArmorSlot[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfArmorSlot[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfArmorSlot[playerid], 1275);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfArmorSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfWeaponSlot[playerid] = CreatePlayerTextDraw(playerid, 575.000000, 121.000000, "weapon_slot");
	PlayerTextDrawLetterSize(playerid, ChrInfWeaponSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfWeaponSlot[playerid], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, ChrInfWeaponSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfWeaponSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfWeaponSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfWeaponSlot[playerid], 255);
	PlayerTextDrawSetShadow(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfWeaponSlot[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfWeaponSlot[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfWeaponSlot[playerid], 346);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfWeaponSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfAccSlot1[playerid] = CreatePlayerTextDraw(playerid, 575.000000, 137.000000, "acs_slot1");
	PlayerTextDrawLetterSize(playerid, ChrInfAccSlot1[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfAccSlot1[playerid], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, ChrInfAccSlot1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAccSlot1[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfAccSlot1[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfAccSlot1[playerid], 255);
	PlayerTextDrawSetShadow(playerid, ChrInfAccSlot1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAccSlot1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccSlot1[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfAccSlot1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfAccSlot1[playerid], 954);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfAccSlot1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfAccSlot2[playerid] = CreatePlayerTextDraw(playerid, 591.000000, 137.000000, "acs_slot2");
	PlayerTextDrawLetterSize(playerid, ChrInfAccSlot2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfAccSlot2[playerid], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, ChrInfAccSlot2[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAccSlot2[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfAccSlot2[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfAccSlot2[playerid], 255);
	PlayerTextDrawSetShadow(playerid, ChrInfAccSlot2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAccSlot2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccSlot2[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfAccSlot2[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfAccSlot2[playerid], 954);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfAccSlot2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfClose[playerid] = CreatePlayerTextDraw(playerid, 601.999938, 106.607421, "X");
	PlayerTextDrawLetterSize(playerid, ChrInfClose[playerid], 0.315333, 1.010962);
	PlayerTextDrawAlignment(playerid, ChrInfClose[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfClose[playerid], -2147483393);
	PlayerTextDrawSetShadow(playerid, ChrInfClose[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfClose[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfClose[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfClose[playerid], true);

	Textdraw16[playerid] = CreatePlayerTextDraw(playerid, 519.999877, 156.385177, "All rate");
	PlayerTextDrawLetterSize(playerid, Textdraw16[playerid], 0.186000, 0.716444);
	PlayerTextDrawAlignment(playerid, Textdraw16[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw16[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw16[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw16[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw16[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw16[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw16[playerid], 1);

	Textdraw17[playerid] = CreatePlayerTextDraw(playerid, 520.299987, 163.151092, "99");
	PlayerTextDrawLetterSize(playerid, Textdraw17[playerid], 0.263000, 1.243257);
	PlayerTextDrawAlignment(playerid, Textdraw17[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw17[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, Textdraw17[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw17[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw17[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw17[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw17[playerid], 1);

	Textdraw18[playerid] = CreatePlayerTextDraw(playerid, 554.632568, 156.767410, "2319");
	PlayerTextDrawLetterSize(playerid, Textdraw18[playerid], 0.365332, 1.741037);
	PlayerTextDrawAlignment(playerid, Textdraw18[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw18[playerid], -1378294017);
	PlayerTextDrawSetShadow(playerid, Textdraw18[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw18[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw18[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw18[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw18[playerid], 1);

	Textdraw19[playerid] = CreatePlayerTextDraw(playerid, 589.599487, 156.638442, "Personal");
	PlayerTextDrawLetterSize(playerid, Textdraw19[playerid], 0.186000, 0.716444);
	PlayerTextDrawAlignment(playerid, Textdraw19[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw19[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw19[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw19[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw19[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw19[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw19[playerid], 1);

	Textdraw20[playerid] = CreatePlayerTextDraw(playerid, 589.832946, 163.487228, "11");
	PlayerTextDrawLetterSize(playerid, Textdraw20[playerid], 0.263000, 1.243257);
	PlayerTextDrawAlignment(playerid, Textdraw20[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw20[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, Textdraw20[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw20[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw20[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw20[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw20[playerid], 1);

	Textdraw21[playerid] = CreatePlayerTextDraw(playerid, 498.399719, 174.978012, "chrinfo_delim3");
	PlayerTextDrawLetterSize(playerid, Textdraw21[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, Textdraw21[playerid], 108.999992, 2.074074);
	PlayerTextDrawAlignment(playerid, Textdraw21[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw21[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, Textdraw21[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw21[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw21[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw21[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw21[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw21[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw21[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw22[playerid] = CreatePlayerTextDraw(playerid, 501.000000, 179.000000, "invslot1");
	PlayerTextDrawLetterSize(playerid, Textdraw22[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Textdraw22[playerid], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, Textdraw22[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw22[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw22[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw22[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw22[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw22[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw22[playerid], -1378294017);
	PlayerTextDrawFont(playerid, Textdraw22[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, Textdraw22[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw22[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw22[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw23[playerid] = CreatePlayerTextDraw(playerid, 520.000000, 193.000000, "1111");
	PlayerTextDrawLetterSize(playerid, Textdraw23[playerid], 0.139999, 0.674960);
	PlayerTextDrawAlignment(playerid, Textdraw23[playerid], 3);
	PlayerTextDrawColor(playerid, Textdraw23[playerid], 255);
	PlayerTextDrawSetShadow(playerid, Textdraw23[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw23[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw23[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw23[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw23[playerid], 1);

	Textdraw24[playerid] = CreatePlayerTextDraw(playerid, 517.000000, 290.000000, "but_1");
	PlayerTextDrawLetterSize(playerid, Textdraw24[playerid], 0.000000, 0.133331);
	PlayerTextDrawTextSize(playerid, Textdraw24[playerid], 17.000000, 17.000000);
	PlayerTextDrawAlignment(playerid, Textdraw24[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw24[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw24[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw24[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw24[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw24[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw24[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, Textdraw24[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw24[playerid], 19132);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw24[playerid], 180.000000, 0.000000, 90.000000, 1.000000);

	Textdraw25[playerid] = CreatePlayerTextDraw(playerid, 498.333129, 285.281646, "chrinfo_delim4");
	PlayerTextDrawLetterSize(playerid, Textdraw25[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, Textdraw25[playerid], 108.999992, 2.074074);
	PlayerTextDrawAlignment(playerid, Textdraw25[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw25[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, Textdraw25[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw25[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw25[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw25[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw25[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw25[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw25[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw26[playerid] = CreatePlayerTextDraw(playerid, 388.100067, 113.085182, "inf_box");
	PlayerTextDrawLetterSize(playerid, Textdraw26[playerid], 0.000000, 20.898159);
	PlayerTextDrawTextSize(playerid, Textdraw26[playerid], 246.666671, 0.000000);
	PlayerTextDrawAlignment(playerid, Textdraw26[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw26[playerid], 0);
	PlayerTextDrawUseBox(playerid, Textdraw26[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw26[playerid], 102);
	PlayerTextDrawSetShadow(playerid, Textdraw26[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw26[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw26[playerid], 0);

	Textdraw27[playerid] = CreatePlayerTextDraw(playerid, 318.333312, 114.115562, "Information");
	PlayerTextDrawLetterSize(playerid, Textdraw27[playerid], 0.239666, 0.986074);
	PlayerTextDrawAlignment(playerid, Textdraw27[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw27[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw27[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw27[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw27[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw27[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw27[playerid], 1);

	Textdraw28[playerid] = CreatePlayerTextDraw(playerid, 377.533569, 111.128860, "x");
	PlayerTextDrawLetterSize(playerid, Textdraw28[playerid], 0.383333, 1.363555);
	PlayerTextDrawAlignment(playerid, Textdraw28[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw28[playerid], -2147483393);
	PlayerTextDrawSetShadow(playerid, Textdraw28[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw28[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, Textdraw28[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw28[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw28[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Textdraw28[playerid], true);

	Textdraw29[playerid] = CreatePlayerTextDraw(playerid, 248.599563, 126.121482, "inf_delim1");
	PlayerTextDrawLetterSize(playerid, Textdraw29[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, Textdraw29[playerid], 137.866516, 2.405925);
	PlayerTextDrawAlignment(playerid, Textdraw29[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw29[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, Textdraw29[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw29[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw29[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw29[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw29[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw29[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw29[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw30[playerid] = CreatePlayerTextDraw(playerid, 318.400054, 130.210311, "[Type C-HP increasing] Bourgeois destroyer");
	PlayerTextDrawLetterSize(playerid, Textdraw30[playerid], 0.169999, 0.811851);
	PlayerTextDrawAlignment(playerid, Textdraw30[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw30[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, Textdraw30[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw30[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw30[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw30[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw30[playerid], 1);

	Textdraw31[playerid] = CreatePlayerTextDraw(playerid, 253.000000, 143.000000, "inf_itemicon");
	PlayerTextDrawLetterSize(playerid, Textdraw31[playerid], 0.000000, -0.666666);
	PlayerTextDrawTextSize(playerid, Textdraw31[playerid], 25.000000, 25.000000);
	PlayerTextDrawAlignment(playerid, Textdraw31[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw31[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw31[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw31[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw31[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw31[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw31[playerid], -1378294017);
	PlayerTextDrawFont(playerid, Textdraw31[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw31[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw31[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw32[playerid] = CreatePlayerTextDraw(playerid, 283.400146, 141.451766, "Damage: 950-1120");
	PlayerTextDrawLetterSize(playerid, Textdraw32[playerid], 0.284000, 1.085629);
	PlayerTextDrawAlignment(playerid, Textdraw32[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw32[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, Textdraw32[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw32[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw32[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw32[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw32[playerid], 1);

	Textdraw33[playerid] = CreatePlayerTextDraw(playerid, 283.499786, 154.352645, "Max HP +10%");
	PlayerTextDrawLetterSize(playerid, Textdraw33[playerid], 0.188333, 0.757925);
	PlayerTextDrawAlignment(playerid, Textdraw33[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw33[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw33[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw33[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw33[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw33[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw33[playerid], 1);

	Textdraw34[playerid] = CreatePlayerTextDraw(playerid, 278.732940, 152.840209, "inf_delim2");
	PlayerTextDrawLetterSize(playerid, Textdraw34[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, Textdraw34[playerid], 107.833137, 1.617777);
	PlayerTextDrawAlignment(playerid, Textdraw34[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw34[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, Textdraw34[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw34[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw34[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw34[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw34[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw34[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw34[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw35[playerid] = CreatePlayerTextDraw(playerid, 283.566345, 161.948440, "Increase damage up to 10%");
	PlayerTextDrawLetterSize(playerid, Textdraw35[playerid], 0.188333, 0.757925);
	PlayerTextDrawAlignment(playerid, Textdraw35[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw35[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw35[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw35[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw35[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw35[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw35[playerid], 1);

	Textdraw36[playerid] = CreatePlayerTextDraw(playerid, 248.866241, 170.386657, "inf_delim3");
	PlayerTextDrawLetterSize(playerid, Textdraw36[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, Textdraw36[playerid], 137.866516, 2.405925);
	PlayerTextDrawAlignment(playerid, Textdraw36[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw36[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, Textdraw36[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw36[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw36[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw36[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw36[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw36[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw36[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw37[playerid] = CreatePlayerTextDraw(playerid, 319.100036, 173.973190, "Modifications");
	PlayerTextDrawLetterSize(playerid, Textdraw37[playerid], 0.233666, 1.015111);
	PlayerTextDrawAlignment(playerid, Textdraw37[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw37[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw37[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw37[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw37[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw37[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw37[playerid], 1);

	Textdraw38[playerid] = CreatePlayerTextDraw(playerid, 252.000000, 191.000000, "mod_1");
	PlayerTextDrawLetterSize(playerid, Textdraw38[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Textdraw38[playerid], 18.000000, 18.000000);
	PlayerTextDrawAlignment(playerid, Textdraw38[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw38[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw38[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw38[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw38[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw38[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw38[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw38[playerid], 3002);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw38[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw39[playerid] = CreatePlayerTextDraw(playerid, 271.000000, 191.000000, "mod_2");
	PlayerTextDrawLetterSize(playerid, Textdraw39[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Textdraw39[playerid], 18.000000, 18.000000);
	PlayerTextDrawAlignment(playerid, Textdraw39[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw39[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw39[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw39[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw39[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw39[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw39[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw39[playerid], 3002);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw39[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw40[playerid] = CreatePlayerTextDraw(playerid, 290.000000, 191.000000, "mod_3");
	PlayerTextDrawLetterSize(playerid, Textdraw40[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Textdraw40[playerid], 18.000000, 18.000000);
	PlayerTextDrawAlignment(playerid, Textdraw40[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw40[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw40[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw40[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw40[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw40[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw40[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw40[playerid], 3002);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw40[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw41[playerid] = CreatePlayerTextDraw(playerid, 309.000000, 191.000000, "mod_4");
	PlayerTextDrawLetterSize(playerid, Textdraw41[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Textdraw41[playerid], 18.000000, 18.000000);
	PlayerTextDrawAlignment(playerid, Textdraw41[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw41[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw41[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw41[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw41[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw41[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw41[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw41[playerid], 3002);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw41[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw42[playerid] = CreatePlayerTextDraw(playerid, 328.000000, 191.000000, "mod_5");
	PlayerTextDrawLetterSize(playerid, Textdraw42[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Textdraw42[playerid], 18.000000, 18.000000);
	PlayerTextDrawAlignment(playerid, Textdraw42[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw42[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw42[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw42[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw42[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw42[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw42[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw42[playerid], 3106);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw42[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw43[playerid] = CreatePlayerTextDraw(playerid, 347.000000, 191.000000, "mod_6");
	PlayerTextDrawLetterSize(playerid, Textdraw43[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Textdraw43[playerid], 18.000000, 18.000000);
	PlayerTextDrawAlignment(playerid, Textdraw43[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw43[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw43[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw43[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw43[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw43[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw43[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw43[playerid], 3106);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw43[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw44[playerid] = CreatePlayerTextDraw(playerid, 366.000000, 191.000000, "mod_7");
	PlayerTextDrawLetterSize(playerid, Textdraw44[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Textdraw44[playerid], 18.000000, 18.000000);
	PlayerTextDrawAlignment(playerid, Textdraw44[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw44[playerid], -1);
	PlayerTextDrawUseBox(playerid, Textdraw44[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw44[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw44[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw44[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw44[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw44[playerid], 3106);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw44[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw45[playerid] = CreatePlayerTextDraw(playerid, 253.399841, 215.993835, "Increases damage by 50%");
	PlayerTextDrawLetterSize(playerid, Textdraw45[playerid], 0.200666, 0.894814);
	PlayerTextDrawAlignment(playerid, Textdraw45[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw45[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, Textdraw45[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw45[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw45[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw45[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw45[playerid], 1);

	Textdraw46[playerid] = CreatePlayerTextDraw(playerid, 253.466476, 223.879959, "Bonus 2");
	PlayerTextDrawLetterSize(playerid, Textdraw46[playerid], 0.200666, 0.894814);
	PlayerTextDrawAlignment(playerid, Textdraw46[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw46[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, Textdraw46[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw46[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw46[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw46[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw46[playerid], 1);

	Textdraw47[playerid] = CreatePlayerTextDraw(playerid, 253.566345, 231.392700, "Bonus 3");
	PlayerTextDrawLetterSize(playerid, Textdraw47[playerid], 0.200666, 0.894814);
	PlayerTextDrawAlignment(playerid, Textdraw47[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw47[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, Textdraw47[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw47[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw47[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw47[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw47[playerid], 1);

	Textdraw48[playerid] = CreatePlayerTextDraw(playerid, 253.599548, 238.822448, "Bonus 4");
	PlayerTextDrawLetterSize(playerid, Textdraw48[playerid], 0.200666, 0.894814);
	PlayerTextDrawAlignment(playerid, Textdraw48[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw48[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, Textdraw48[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw48[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw48[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw48[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw48[playerid], 1);

	Textdraw49[playerid] = CreatePlayerTextDraw(playerid, 248.366043, 250.118347, "inf_delim4");
	PlayerTextDrawLetterSize(playerid, Textdraw49[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, Textdraw49[playerid], 137.866516, 2.405925);
	PlayerTextDrawAlignment(playerid, Textdraw49[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw49[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, Textdraw49[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw49[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw49[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw49[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw49[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw49[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw49[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw50[playerid] = CreatePlayerTextDraw(playerid, 319.433380, 254.530380, "[Description string 1]");
	PlayerTextDrawLetterSize(playerid, Textdraw50[playerid], 0.234333, 1.006815);
	PlayerTextDrawAlignment(playerid, Textdraw50[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw50[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw50[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw50[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw50[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw50[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw50[playerid], 1);

	Textdraw51[playerid] = CreatePlayerTextDraw(playerid, 319.400115, 264.200103, "[Description string 2]");
	PlayerTextDrawLetterSize(playerid, Textdraw51[playerid], 0.234333, 1.006815);
	PlayerTextDrawAlignment(playerid, Textdraw51[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw51[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw51[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw51[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw51[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw51[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw51[playerid], 1);

	Textdraw52[playerid] = CreatePlayerTextDraw(playerid, 319.633575, 274.035766, "[Description string 3]");
	PlayerTextDrawLetterSize(playerid, Textdraw52[playerid], 0.234333, 1.006815);
	PlayerTextDrawAlignment(playerid, Textdraw52[playerid], 2);
	PlayerTextDrawColor(playerid, Textdraw52[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw52[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw52[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw52[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw52[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw52[playerid], 1);

	Textdraw53[playerid] = CreatePlayerTextDraw(playerid, 248.532775, 286.045776, "inf_delim5");
	PlayerTextDrawLetterSize(playerid, Textdraw53[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, Textdraw53[playerid], 137.866516, 2.405925);
	PlayerTextDrawAlignment(playerid, Textdraw53[playerid], 1);
	PlayerTextDrawColor(playerid, Textdraw53[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, Textdraw53[playerid], true);
	PlayerTextDrawBoxColor(playerid, Textdraw53[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Textdraw53[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw53[playerid], 0);
	PlayerTextDrawFont(playerid, Textdraw53[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, Textdraw53[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, Textdraw53[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	Textdraw54[playerid] = CreatePlayerTextDraw(playerid, 385.366790, 289.913970, "Price: 9999999999$");
	PlayerTextDrawLetterSize(playerid, Textdraw54[playerid], 0.234000, 1.069036);
	PlayerTextDrawAlignment(playerid, Textdraw54[playerid], 3);
	PlayerTextDrawColor(playerid, Textdraw54[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Textdraw54[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Textdraw54[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, Textdraw54[playerid], 51);
	PlayerTextDrawFont(playerid, Textdraw54[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Textdraw54[playerid], 1);
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
	TextDrawDestroy(GamemodeName1);
	TextDrawDestroy(GamemodeName2);
	TextDrawDestroy(Version);
	TextDrawDestroy(WorldTime);
}

stock DeletePlayerTextDraws(playerid)
{

}

stock CreatePickups()
{
    home_enter = CreatePickup(1318,23,224.0201,-1837.3518,4.2787);
    home_quit = CreatePickup(1318,23,-2158.6240,642.8425,1052.3750);
    start_tp1 = CreatePickup(19605,23,243.1539,-1831.6542,3.3772);
    start_tp2 = CreatePickup(19607,23,204.7617,-1831.6539,3.3772);
    
    Create3DTextLabel("Дом клоунов",0xf2622bFF,224.0201,-1837.3518,4.2787,70.0,0,1);
    Create3DTextLabel("К боссам",0xeaeaeaFF,243.1539,-1831.6542,3.9772,70.0,0,1);
    Create3DTextLabel("На арену",0xeaeaeaFF,204.7617,-1831.6539,4.1772,70.0,0,1);
    Create3DTextLabel("Доска почета",0xFFCC00FF,-2171.3132,645.5896,1053.3817,5.0,0,1);
    Create3DTextLabel("Торговец расходниками",0xFFCC00FF,-2166.7527,646.0400,1052.3750,5.0,0,1);
	Create3DTextLabel("Оружейник",0xFFCC00FF,189.2644,-1825.4902,4.1411,5.0,0,1);
	Create3DTextLabel("Портной",0xFFCC00FF,262.6658,-1825.2792,3.9126,5.0,0,1);

	Actors[0] =	CreateActor(61,-2166.7527,646.0400,1052.3750,179.9041);
	Actors[1] =	CreateActor(6,189.2644,-1825.4902,4.1411,185.0134);
	Actors[2] =	CreateActor(60,262.6658,-1825.2792,3.9126,181.2770);
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
