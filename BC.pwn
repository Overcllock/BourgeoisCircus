//Bourgeois Circus 0.94

#include <a_samp>
#include <a_mail>
#include <a_engine>
#include <a_mysql>
#include <md5>
#include <streamer>
#include <time>
#include <a_actor>
#include <FCNPC>
#include <float>
#include <crp>
#include <sscanf2>
#include <Pawn.CMD>
#include <YSF>
#include <vnpc>

#pragma dynamic 31294

#define VERSION 0.941

//Mysql settings

/*#define SQL_HOST "127.0.0.1"
#define SQL_USER "tsar"
#define SQL_DB "bcircus"
#define SQL_PASS "2151"*/
#define SQL_HOST "212.22.93.45"
#define SQL_USER "gsvtqhss"
#define SQL_DB "gsvtqhss_21809"
#define SQL_PASS "21510055"

//Data types
#define TYPE_INT 0x01
#define TYPE_FLOAT 0x02
#define TYPE_STRING 0x03

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
#define DEFAULT_SKIN_FEMALE 131
#define DEFAULT_WEAPON_ID 0
#define DEFAULT_ARMOR_ID 81
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
#define MAX_PARTICIPANTS 20
#define MAX_OWNERS 2
#define MAX_SLOTS 25
#define MAX_SLOTS_X 5
#define MAX_SLOTS_Y 5
#define MAX_RANK 9
#define MAX_MOD 7
#define MAX_PROPERTIES 2
#define MAX_DESCRIPTION_SIZE 45
#define MAX_GRADES 3
#define MAX_BOSSES 5
#define MAX_ITEM_ID 204
#define MAX_LOOT 20
#define MAX_PVP_PANEL_ITEMS 5
#define MAX_RELIABLE_TARGETS 5
#define MAX_TEAMCOLORS 2
#define MAX_RATE 3000
#define MAX_DEATH_MESSAGES 5

//Phases
#define PHASE_PEACE 0
#define PHASE_WAR 1

//Player params
#define PARAM_DAMAGE 1
#define PARAM_DEFENSE 2
#define PARAM_DODGE 3
#define PARAM_ACCURACY 4
#define PARAM_CRITICAL_CHANCE 5

//Item types
#define ITEMTYPE_WEAPON 1
#define ITEMTYPE_ARMOR 2
#define ITEMTYPE_ACCESSORY 3
#define ITEMTYPE_PASSIVE 4
#define ITEMTYPE_MATERIAL 5
#define ITEMTYPE_BOX 6

//Item grades
#define GRADE_N 1
#define GRADE_B 2
#define GRADE_C 3

//Props
#define PROPERTY_NONE 0
#define PROPERTY_DAMAGE 1
#define PROPERTY_DEFENSE 2
#define PROPERTY_DODGE 3
#define PROPERTY_ACCURACY 4
#define PROPERTY_HP 5
#define PROPERTY_CRIT 6
#define PROPERTY_LOOT 7

//Modifiers variations
#define MOD_DAMAGE 1
#define MOD_DEFENSE 2
#define MOD_DODGE 3
#define MOD_ACCURACY 4

#define MOD_RESULT_SUCCESS 0
#define MOD_RESULT_FAIL 1
#define MOD_RESULT_RESET 2
#define MOD_RESULT_DESTROY 3

//Other
#define DEFENSE_DIVIDER 7000
#define BOSS_SHOOT_DELAY 300
#define RND_EQUIP_TYPE_WEAPON 0
#define RND_EQUIP_TYPE_ARMOR 1
#define RND_EQUIP_TYPE_RANDOM 2
#define RND_EQUIP_GRADE_RANDOM 11

//Delays
#define DEFAULT_SHOOT_DELAY 200
#define COLT_SHOOT_DELAY 120
#define DEAGLE_SHOOT_DELAY 290
#define MP5_SHOOT_DELAY 110
#define TEC_SHOOT_DELAY 70
#define AK_SHOOT_DELAY 160
#define M4_SHOOT_DELAY 150
#define SHOTGUN_SHOOT_DELAY 430
#define SAWNOFF_SHOOT_DELAY 350
#define COMBAT_SHOOT_DELAY 270

/* Forwards */
forward Time();
forward OnPlayerLogin(playerid);
forward OnTourEnd(finished);
forward OnTournamentEnd();
forward Float:GetDistanceBetweenPlayers(p1, p2);
forward Float:GetPlayerMaxHP(playerid);
forward Float:GetPlayerHP(playerid);
forward SetPlayerHP(playerid, Float:hp);
forward GivePlayerHP(playerid, Float:hp);
forward SetPlayerMaxHP(playerid, Float:hp, bool:give_hp);
forward SetPlayerRate(playerid, rate);
forward SetPlayerRateOffline(name[], rate);
forward GivePlayerRate(playerid, rate);
forward GivePlayerRateOffline(name[], rate);
forward GivePlayerMoneyOffline(name[], money);
forward UpdatePlayerMaxHP(playerid);
forward CancelBossAttack();
forward FinishBossAttack();
forward TeleportBossAttackersToHome();
forward TeleportToHome(playerid);
forward bool:CheckChance(chance);
forward RegeneratePlayerHP(playerid);
forward UpdatePvpTable();
forward CheckDead(npcid);

/* Variables */

//Enums
enum TopItem
{
	Pos,
	Name[255],
	Score,
	Rate
};
enum tInfo
{
	Number,
	Phase,
	Tour,
	ParticipantsIDs[MAX_PARTICIPANTS]
};
enum BossInfo
{
	ID,
	Grade,
	Name[255],
	RespawnTime,
	DamageMin,
	DamageMax, 
	Defense,
	Accuracy,
	Dodge,
	HP
};
enum LootInfo
{
	ItemID,
	Count
};
enum RewardInfo
{
	ItemID,
	ItemsCount,
	Money
};
enum pvpInf
{
	ID,
	Name[255],
	Kills,
	Deaths,
	Score
};
enum TWindow
{
	bool:CharInfo,
	bool:ItemInfo,
	bool:EquipInfo,
	bool:Mod
};
enum iInfo 
{
	ID,
	Mod[MAX_MOD],
	Count,
};
enum BaseItem 
{
	ID,
	Name[255],
	Description[255],
	MinRank,
	Type,
	Grade,
	Price,
	Property[MAX_PROPERTIES],
	PropertyVal[MAX_PROPERTIES],
	Model,
	ModelRotX,
	ModelRotY,
	ModelRotZ
};
enum pInfo 
{
	ID,
	Name[255],
	Owner[255],
	Rate,
	Rank,
	MaxRank,
	TeamColor,
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
	Crit,
	WeaponSlotID,
	ArmorSlotID,
	AccSlot1ID,
	AccSlot2ID,
	WeaponMod[MAX_MOD],
	ArmorMod[MAX_MOD]
};

//Global
new WorldTime_Timer = -1;
new PrepareBossAttackTimer = -1;
new BossAttackTimer = -1;
new TeleportTimer = -1;
new Actors[MAX_ACTORS];
new ReadyIDs[MAX_OWNERS] = -1;
new MySQL:sql_handle;
new arena_area;
new Tournament[tInfo];
new TourParticipantsCount = 0;
new TournamentTab[MAX_PARTICIPANTS][TopItem];

new AttackedBoss = -1;
new bool:IsBossAttacker[MAX_PLAYERS] = false;
new BossAttackersCount = 0;
new BossNPC = -1;
new bool:IsBoss[MAX_PLAYERS] = false;
new BossLootPickups[MAX_LOOT];
new BossLootItems[MAX_LOOT][LootInfo];

new ModItemSlot[MAX_PLAYERS] = -1;
new ModStone[MAX_PLAYERS] = -1;
new ModPotion[MAX_PLAYERS] = -1;
new IsSlotsBlocked[MAX_PLAYERS] = false;

new IsTourStarted = false;
new TourPlayers[MAX_OWNERS] = -1;
new TourEndTimer = -1;
new PvpTableUpdTimer = -1;
new DeadCheckTimer[MAX_PLAYERS] = -1;
new PvpTtl = 0;
new PvpInfo[MAX_PARTICIPANTS][pvpInf];

new Windows[MAX_PLAYERS][TWindow];

//Pickups
new home_enter = 0;
new home_quit = 0;
new boss_tp = 0;
new arena_tp = 0;

//Player
new PlayerInventory[MAX_PLAYERS][MAX_SLOTS][iInfo];
new PlayerInfo[MAX_PLAYERS][pInfo];
new PlayerHPMultiplicator[MAX_PLAYERS];
new DamageCounter[MAX_PLAYERS] = 0;
new bool:PlayerConnect[MAX_PLAYERS] = false;
new Float:MaxHP[MAX_PLAYERS];
new bool:IsInventoryOpen[MAX_PLAYERS] = false;
new bool:IsDeath[MAX_PLAYERS] = false;
new bool:IsSpawned[MAX_PLAYERS] = false;
new bool:IsParticipant[MAX_PLAYERS] = false;
new bool:IsEasyMod[MAX_PLAYERS] = false;
new SelectedSlot[MAX_PLAYERS] = -1;

new AccountLogin[MAX_PLAYERS][128];
new ParticipantsCount[MAX_PLAYERS];
new Participants[MAX_PLAYERS][MAX_PARTICIPANTS][128];

new RegenerateTimer[MAX_PLAYERS] = -1;

//Arrays
new EmptyInvItem[iInfo] = {
	-1,
	{0,0,0,0,0,0,0},
	0
};
new MOD_CLEAR[MAX_MOD] = {0,0,0,0,0,0,0};
new BossesNames[MAX_BOSSES][128] = {
	{"BOSS_Edemsky"},
	{"BOSS_FactoryWorker"},
	{"BOSS_Maximus"},
	{"BOSS_ShazokVsemog"},
	{"BOSS_Bourgeois"}
};
new BossesSkins[MAX_BOSSES][1] = {
	{78},
	{8},
	{119},
	{149},
	{5}
};
new BossesWeapons[MAX_BOSSES][1] = {
	{22},
	{32},
	{30},
	{25},
	{26}
};

new GlobalRatingTop[MAX_PARTICIPANTS][TopItem];
new LocalRatingTop[MAX_PLAYERS][MAX_PARTICIPANTS / 2][TopItem];

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
new HexGradeColors[MAX_GRADES][1] = {
	{0xCCCCCCFF},
	{0xFFCC00FF},
	{0xCC6600FF}
};
new HexTeamColors[MAX_TEAMCOLORS][1] = {
	{0x339999FF},
	{0xFF0099FF}
};

///Textdraws
//Global
new Text:WorldTime;
new Text:GamemodeName1;
new Text:GamemodeName2;
new Text:Version;

//Player
new PlayerText:HPBar[MAX_PLAYERS];

new PlayerText:PvpPanelBox[MAX_PLAYERS];
new PlayerText:PvpPanelHeader[MAX_PLAYERS];
new PlayerText:PvpPanelTimer[MAX_PLAYERS];
new PlayerText:PvpPanelNameLabels[MAX_PLAYERS][MAX_PVP_PANEL_ITEMS];
new PlayerText:PvpPanelScoreLabels[MAX_PLAYERS][MAX_PVP_PANEL_ITEMS];
new PlayerText:PvpPanelDelim[MAX_PLAYERS];
new PlayerText:PvpPanelMyName[MAX_PLAYERS];
new PlayerText:PvpPanelMyScore[MAX_PLAYERS];

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
new PlayerText:ChrInfText1[MAX_PLAYERS];
new PlayerText:ChrInfAllRate[MAX_PLAYERS];
new PlayerText:ChrInfRate[MAX_PLAYERS];
new PlayerText:ChrInfText2[MAX_PLAYERS];
new PlayerText:ChrInfPersonalRate[MAX_PLAYERS];
new PlayerText:ChrInfDelim3[MAX_PLAYERS];
new PlayerText:ChrInfInvSlot[MAX_PLAYERS][MAX_SLOTS];
new PlayerText:ChrInfInvSlotCount[MAX_PLAYERS][MAX_SLOTS];
new PlayerText:ChrInfButUse[MAX_PLAYERS];
new PlayerText:ChrInfButInfo[MAX_PLAYERS];
new PlayerText:ChrInfButDel[MAX_PLAYERS];
new PlayerText:ChrInfButMod[MAX_PLAYERS];
new PlayerText:ChrInfDelim4[MAX_PLAYERS];

new PlayerText:EqInfBox[MAX_PLAYERS];
new PlayerText:EqInfTxt1[MAX_PLAYERS];
new PlayerText:EqInfClose[MAX_PLAYERS];
new PlayerText:EqInfDelim1[MAX_PLAYERS];
new PlayerText:EqInfItemName[MAX_PLAYERS];
new PlayerText:EqInfItemIcon[MAX_PLAYERS];
new PlayerText:EqInfMainStat[MAX_PLAYERS];
new PlayerText:EqInfBonusStat[MAX_PLAYERS][2];
new PlayerText:EqInfDelim2[MAX_PLAYERS];
new PlayerText:EqInfDelim3[MAX_PLAYERS];
new PlayerText:EqInfTxt2[MAX_PLAYERS];
new PlayerText:EqInfMod[MAX_PLAYERS][MAX_MOD];
new PlayerText:EqInfModStat[MAX_PLAYERS][4];
new PlayerText:EqInfDelim4[MAX_PLAYERS];
new PlayerText:EqInfDescriptionStr[MAX_PLAYERS][3];
new PlayerText:EqInfDelim5[MAX_PLAYERS];
new PlayerText:EqInfPrice[MAX_PLAYERS];

new PlayerText:InfBox[MAX_PLAYERS];
new PlayerText:InfTxt1[MAX_PLAYERS];
new PlayerText:InfDelim1[MAX_PLAYERS];
new PlayerText:InfItemIcon[MAX_PLAYERS];
new PlayerText:InfItemName[MAX_PLAYERS];
new PlayerText:InfItemType[MAX_PLAYERS];
new PlayerText:InfItemEffect[MAX_PLAYERS][2];
new PlayerText:InfDelim2[MAX_PLAYERS];
new PlayerText:InfDescriptionStr[MAX_PLAYERS][3];
new PlayerText:InfDelim3[MAX_PLAYERS];
new PlayerText:InfPrice[MAX_PLAYERS];
new PlayerText:InfClose[MAX_PLAYERS];

new PlayerText:UpgBox[MAX_PLAYERS];
new PlayerText:UpgTxt1[MAX_PLAYERS];
new PlayerText:UpgDelim1[MAX_PLAYERS];
new PlayerText:UpgModInfo[MAX_PLAYERS];
new PlayerText:UpgItemSlot[MAX_PLAYERS];
new PlayerText:UpgTxt2[MAX_PLAYERS];
new PlayerText:UpgStoneSlot[MAX_PLAYERS];
new PlayerText:UpgTxt3[MAX_PLAYERS];
new PlayerText:UpgPotionSlot[MAX_PLAYERS];
new PlayerText:UpgTxt4[MAX_PLAYERS];
new PlayerText:UpgBtn[MAX_PLAYERS];
new PlayerText:UpgClose[MAX_PLAYERS];

main()
{
	new str[64];
	format(str, sizeof(str), "Bourgeois Circus ver. %.2f", VERSION);
	print(str);
}

/* Commands */
//GM commands
cmd:setrate(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
	new rate;
	if(sscanf(params, "i", rate))
		return SendClientMessage(playerid, COLOR_GREY, "USAGE: /setrate [rate]");
	if(rate < 0 || rate > 3000)
		return SendClientMessage(playerid, COLOR_GREY, "Value should be between 0 and 3000.");
	SetPlayerRate(playerid, rate);
	return SendClientMessage(playerid, COLOR_GREY, "Rate changed succesfully.");
}

cmd:givemoney(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
	new money;
	if(sscanf(params, "i", money))
		return SendClientMessage(playerid, COLOR_GREY, "USAGE: /givemoney [value]");
	PlayerInfo[playerid][Cash] += money;
	GivePlayerMoney(playerid, money);
	return SendClientMessage(playerid, COLOR_GREY, "Done.");
}

cmd:giveitem(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
	new itemid;
	new count;
	if(sscanf(params, "ii", itemid, count))
		return SendClientMessage(playerid, COLOR_GREY, "USAGE: /giveitem [id][count]");
	if(itemid <= 0 || itemid == 81 || itemid > MAX_ITEM_ID)
		return SendClientMessage(playerid, COLOR_GREY, "Invalid item id.");
	if(count <= 0)
		return SendClientMessage(playerid, COLOR_GREY, "Invalid count.");
	if(IsInventoryFull(playerid))
		return SendClientMessage(playerid, COLOR_GREY, "Inventory is full.");
	
	new ok = false;
	if(IsEquip(itemid))
		ok = AddEquip(playerid, itemid, MOD_CLEAR);
	else
		ok = AddItem(playerid, itemid, count);

	if(ok)
		return SendClientMessage(playerid, COLOR_GREY, "Done.");
	return SendClientMessage(playerid, COLOR_GREY, "AddItem() function error. Contact with developer.");
}

cmd:home(playerid, params[])
{
	if(IsTourStarted) return 1;
	TeleportToHome(playerid);
	return SendClientMessage(playerid, COLOR_GREY, "Done.");
}

cmd:easymod(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
	IsEasyMod[playerid] = true;
	return SendClientMessage(playerid, COLOR_GREY, "Easymod on.");
}

cmd:spawnboss(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;

	new bossid;
	if(sscanf(params, "i", bossid))
		return SendClientMessage(playerid, COLOR_GREY, "USAGE: /spawnboss [bossid]");

	new query[255];
	format(query, sizeof(query), "UPDATE `bosses` SET `RespawnTime` = '0' WHERE `ID` = '%d' LIMIT 1", bossid);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	return SendClientMessage(playerid, COLOR_GREY, "Done.");
}

//Other commands
cmd:createplayer(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
	new name[128], owner[128];
	new sex;
	if(sscanf(params, "s[128]s[128]i", name, owner, sex))
		return SendClientMessage(playerid, COLOR_GREY, "USAGE: /createplayer [name][owner][sex]");

	CreatePlayer(playerid, name, owner, sex);
	return 1;
}

cmd:createinv(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;

	new name[64];
	new id;

	if(sscanf(params, "i", id))
		return SendClientMessage(playerid, COLOR_GREY, "USAGE: /createinv [playerid]");

	if(!IsPlayerConnected(id))
		return SendClientMessage(playerid, COLOR_GREY, "Player in not connected.");

	GetPlayerName(id, name, sizeof(name));
	CreateInventory(name);
	SendClientMessage(playerid, COLOR_GREEN, "Inventory created");
	return 1;
}

cmd:kill(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;

	SetPlayerHealth(playerid, 0);
	return 1;
}

cmd:arena(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
	
	SetPlayerWorldBounds(playerid, -2313.0295, -2390.5017, -1593.6758, -1669.8492);
	SetPlayerPos(playerid, -2353.16186,-1630.952,723.561);
	SetPlayerInterior(playerid, 0);
	return 1;
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
	FCNPC_SetUpdateRate(10);
	FCNPC_UseCrashLog(true);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	DisableNameTagLOS();
	SetNameTagDrawDistance(9999.0);

	CreateMap();
	CreatePickups();
	InitTextDraws();

	WorldTime_Timer = SetTimer("Time", 1000, true);
	arena_area = CreateDynamicRectangle(-2390.5017, -1669.8492, -2313.0295, -1593.6758, 0, 0, -1);

	for(new i = 0; i < MAX_OWNERS; i++)
		ReadyIDs[i] = -1;

	sql_handle = mysql_connect(SQL_HOST, SQL_USER, SQL_PASS, SQL_DB);
	if(sql_handle == MYSQL_INVALID_HANDLE)
	{
		print("Database connection failed.");
		return 0;
	}

	print("Database connection success.");
	mysql_set_charset("cp1251");

	LoadTournamentInfo();
	UpdateGlobalRatingTop();

	return 1;
}

public OnGameModeExit()
{
	SaveTournamentInfo();
	DeleteTextDraws();
	ResetLoot();
	KillTimer(WorldTime_Timer);
	for (new i = 0; i < MAX_ACTORS; i++)
		DestroyActor(Actors[i]);
	DestroyAllDynamicAreas();
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(FCNPC_IsValid(playerid)) return 0;

	if(IsTourStarted && !IsDeath[playerid] && areaid == arena_area && IsPlayerParticipant(playerid))
	{
		TeleportToRandomArenaPos(playerid);
		UpdatePlayerVisual(playerid);
	}

	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SendClientMessage(playerid, COLOR_WHITE, "����� ���������� � Bourgeois Circus.");
	new login[64];
	GetPlayerName(playerid, login, sizeof(login));
	new ok = LoadAccount(playerid, login);
	if(PlayerInfo[playerid][Admin] > 0 && ok > 0)
	{
		LoadPlayer(playerid);
		OnPlayerLogin(playerid);
	}
	else if(ok > 0)
		ShowPlayerDialog(playerid, 101, DIALOG_STYLE_PASSWORD, "�����������", "������� ������:", "����", "�������");
	else
	{
		new query[255] = "SELECT * FROM `accounts`";
		new Cache:q_result = mysql_query(sql_handle, query);
		new count = 0;
		cache_get_row_count(count);
		cache_delete(q_result);
		if(count < MAX_OWNERS + 1)
			ShowPlayerDialog(playerid, 100, DIALOG_STYLE_PASSWORD, "�����������", "��������� ����� �� ���������������.\n\n���������� ������:", "�����", "�������");\
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "���������������� ������������ ���������� ���������.");
			SendClientMessage(playerid, COLOR_GREEN, "������� /q ��� ������.");
			return 1;
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	IsDeath[playerid] = false;
	IsSpawned[playerid] = false;
    ShowTextDraws(playerid);
	return 1;
}

public OnPlayerLogin(playerid) 
{
	if(!FCNPC_IsValid(playerid))
	{
		InitPlayerTextDraws(playerid);
		PlayerTextDrawShow(playerid, HPBar[playerid]);
		HideAllWindows(playerid);
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
		UpdatePlayerPost(playerid);
	}
	PlayerConnect[playerid] = true;
	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;
	SetPVarInt(playerid, "LastKill", -1);
	UpdatePlayerMaxHP(playerid);
	SetPlayerSkills(playerid);
	SetPlayerHP(playerid, MaxHP[playerid]);
	if(!FCNPC_IsValid(playerid))
		SpawnPlayer(playerid);
	else
		FCNPC_Spawn(playerid, PlayerInfo[playerid][Skin], PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ]);
	UpdatePlayerStats(playerid);
	if(!FCNPC_IsValid(playerid))
		UpdateLocalRatingTop(playerid);
	UpdatePlayerSkin(playerid);
	RegenerateTimer[playerid] = SetTimerEx("RegeneratePlayerHP", 1000, true, "i", playerid);
}

public OnTourEnd(finished)
{
	if(IsValidTimer(TourEndTimer))
		KillTimer(TourEndTimer);
	if(IsValidTimer(PvpTableUpdTimer))
		KillTimer(PvpTableUpdTimer);

	for(new i = 0; i < MAX_DEATH_MESSAGES; i++)
		SendDeathMessage(-1, MAX_PLAYERS + 1, 0);

	if(finished == 1)
		UpdateTournamentTable();

	IsTourStarted = false;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		DamageCounter[i] = 0;
		if(FCNPC_IsValid(i))
		{
			if(IsValidTimer(DeadCheckTimer[i]))
				KillTimer(DeadCheckTimer[i]);
			for(new j = 0; j < MAX_OWNERS; j++)
				FCNPC_HideInTabListForPlayer(i, TourPlayers[j]);
			FCNPC_Destroy(i);
		}
	}
	for(new i = 0; i < MAX_OWNERS; i++)
	{
		SetPvpTableVisibility(TourPlayers[i], false);
		TeleportToHome(TourPlayers[i]);
		SetPlayerColor(TourPlayers[i], HexRateColors[PlayerInfo[TourPlayers[i]][Rank]-1][0]);
		SetPlayerHP(TourPlayers[i], MaxHP[TourPlayers[i]]);
	}

	new string[255];
	if(finished == 1)
	{
		format(string, sizeof(string), "%d ��� ��������.", Tournament[Tour]);
		SendClientMessageToAll(COLOR_LIGHTRED, string);
		GiveTourRates(Tournament[Tour]);
		GiveTourRewards(Tournament[Tour]);
		for(new i = 0; i < MAX_OWNERS; i++)
			ShowTournamentTab(TourPlayers[i]);
		Tournament[Tour]++;
		if(Tournament[Tour] > 5)
			OnTournamentEnd();
		else
		{
			UpdateTourParticipants();
			for(new i = 0; i < MAX_OWNERS; i++)
			{
				if(IsTourParticipant(PlayerInfo[TourPlayers[i]][ID]))
					SendClientMessage(TourPlayers[i], COLOR_GREEN, "�� ������ � ��������� ���.");
				else
					SendClientMessage(TourPlayers[i], COLOR_LIGHTRED, "�� ��������� �� �������.");
			}
		}
		UpdateGlobalRatingTop();
	}
	else
		SendClientMessageToAll(COLOR_LIGHTRED, "��� �������.");
}

public OnTournamentEnd()
{
	new string[255];
	format(string, sizeof(string), "%d ������ ��������!", Tournament[Number]);
	SendClientMessageToAll(COLOR_LIGHTRED, string);
	SendClientMessageToAll(COLOR_LIGHTRED, "���������� ���� ����.");

	Tournament[Tour] = 1;
	Tournament[Number]++;
	Tournament[Phase] = PHASE_PEACE;

	GiveTournamentRewards();
	UpdateTourParticipants();
	UpdateBossesCooldowns();
}

stock SortPvpData()
{
	new tmp[pvpInf];
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
    {
        for(new j = MAX_PARTICIPANTS-1; j > i; j--)
        {
            if(PvpInfo[j-1][Score] < PvpInfo[j][Score])
            {
				tmp = PvpInfo[j-1];
				PvpInfo[j-1] = PvpInfo[j];
				PvpInfo[j] = tmp;
            }
        }
    }
}

public UpdatePvpTable()
{
	new score[64];
	new name[512];
	new id = -1;
	new minute, second;
	new string[25];

	PvpTtl--;
	minute = PvpTtl / 60;
	second = PvpTtl - minute * 60;
	if(second <= 9)
		format(string, 25, "%d:0%d", minute, second);
	else
		format(string, 25, "%d:%d", minute, second);

	SortPvpData();

	for(new j = 0; j < MAX_OWNERS; j++)
	{
		new InitID = TourPlayers[j];
		if(!IsPlayerConnected(InitID)) continue;

		for(new i = 0; i < MAX_PVP_PANEL_ITEMS; i++)
		{
			PlayerTextDrawHide(InitID, PvpPanelNameLabels[InitID][i]);
			id = PvpInfo[i][ID];
			if(id == -1) continue;
			format(name, sizeof(name), "%d. %s", i+1, PvpInfo[i][Name]);
			PlayerTextDrawSetStringRus(InitID, PvpPanelNameLabels[InitID][i], name);
			PlayerTextDrawColor(InitID, PvpPanelNameLabels[InitID][i], HexRateColors[PlayerInfo[id][Rank]-1][0]);
			format(score, sizeof(score), "%d", PvpInfo[i][Score]);
			PlayerTextDrawSetStringRus(InitID, PvpPanelScoreLabels[InitID][i], score);
			PlayerTextDrawShow(InitID, PvpPanelNameLabels[InitID][i]);
		}

		new myplace = GetPvpIndex(InitID);
		if(myplace == -1)
			myplace = MAX_PARTICIPANTS-1;

		format(name, sizeof(name), "%d. %s", myplace+1, PvpInfo[myplace][Name]);
		PlayerTextDrawSetStringRus(InitID, PvpPanelMyName[InitID], name);
		format(score, sizeof(score), "%d", PvpInfo[myplace][Score]);
		PlayerTextDrawSetStringRus(InitID, PvpPanelMyScore[InitID], score);

		PlayerTextDrawSetStringRus(InitID, PvpPanelTimer[InitID], string);
	}
}

public FCNPC_OnGiveDamage(npcid, damagedid, Float:amount, weaponid, bodypart)
{
	return OnPlayerGiveDamage(npcid, damagedid, amount, weaponid, bodypart);
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(GetPlayerTeam(damagedid) != NO_TEAM && GetPlayerTeam(playerid) == GetPlayerTeam(damagedid))
	{
		if(FCNPC_IsValid(damagedid))
			FCNPC_GiveHealth(damagedid, amount);
		return 0;
	}

	new dodge = (PlayerInfo[damagedid][Dodge] - PlayerInfo[playerid][Accuracy]) / 2;
	if(dodge < 0) dodge = 0;
	new bool:dodged = CheckChance(dodge);
	new bool:is_crit = CheckChance(PlayerInfo[playerid][Crit]);
	new damage;
	if(dodged)
		damage = 0;
	else if(is_crit)
		damage = PlayerInfo[playerid][DamageMax];
	else
		damage = PlayerInfo[playerid][DamageMin] + random(PlayerInfo[playerid][DamageMax]-PlayerInfo[playerid][DamageMin]+1);
	
	new Float:defense_mul = floatsub(1.0, floatdiv(PlayerInfo[damagedid][Defense], DEFENSE_DIVIDER));
	damage = floatround(floatmul(damage, defense_mul));

	new real_damage;
	if((floatround(GetPlayerHP(damagedid)) - damage) <= 0)
		real_damage = floatround(GetPlayerHP(damagedid));
	else
		real_damage = damage;
	DamageCounter[playerid] += real_damage;
	new points = DamageCounter[playerid] / 100;
	if(points > 0)
	{
		DamageCounter[playerid] -= points * 100;
		if(DamageCounter[playerid] < 0)
			DamageCounter[playerid] = 0;
		
		new damager_idx = GetPvpIndex(playerid);
		if(damager_idx != -1)
			PvpInfo[damager_idx][Score] += points;
	}

	if(dodged)
		SetPlayerChatBubble(damagedid, "���������", 0x66CCCCFF, 80.0, 1200);
	else
	{
		new dmginf[32];
		format(dmginf, sizeof(dmginf), "%d", real_damage);
		SetPlayerChatBubble(damagedid, dmginf, is_crit ? 0xFFCC00FF : 0xFFFFFFFF, 80.0, 1200);
	}

	new Float:new_hp;
	new_hp = GetPlayerHP(damagedid);
	new_hp = floatsub(new_hp, damage);
	if(new_hp < 100)
	{
		new lastkill = GetPVarInt(playerid, "LastKill");
		if(lastkill != damagedid)
		{
			SetPVarInt(playerid, "LastKill", damagedid);
			OnPlayerDeath(damagedid, playerid, weaponid);
		}
		SetPlayerHP(damagedid, 0);
		return 1;
	}

	if(FCNPC_IsValid(damagedid))
	{
		FCNPC_GiveHealth(damagedid, amount);
		GivePlayerHP(damagedid, -damage);
	}
	else
		SetPlayerHP(damagedid, new_hp);

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(IsTourStarted && IsTourParticipant(PlayerInfo[playerid][ID]))
		OnTourEnd(0);
	if(IsBossAttacker[playerid] && BossNPC != -1)
	{
		BossAttackersCount--;
		if(BossAttackersCount <= 0)
			FinishBossAttack();
	}
	if(IsPlayerParticipant(playerid) || PlayerInfo[playerid][Admin] > 0)
		SavePlayer(playerid, !FCNPC_IsValid(playerid));

	DeletePlayerTextDraws(playerid);

	if(IsValidTimer(RegenerateTimer[playerid]))
		KillTimer(RegenerateTimer[playerid]);
	RegenerateTimer[playerid] = -1;

	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;
	IsParticipant[playerid] = false;
	IsEasyMod[playerid] = false;
	IsBossAttacker[playerid] = false;
	IsBoss[playerid] = false;
	IsDeath[playerid] = false;
	IsSpawned[playerid] = false;

	for (new i = 0; i < 10; i++)
	    if (IsPlayerAttachedObjectSlotUsed(playerid, i))
	        RemovePlayerAttachedObject(playerid, i);

	PlayerConnect[playerid] = false;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerHP(playerid, MaxHP[playerid]);

	if(IsDeath[playerid]) 
	{
	    IsDeath[playerid] = false;
		if(IsTourStarted && IsTourParticipant(PlayerInfo[playerid][ID]))
			TeleportToRandomArenaPos(playerid);
		else
		{
			ResetWorldBounds(playerid);
			SetPlayerInterior(playerid, 1);
			SetPlayerPos(playerid, -2170.3948,645.6729,1057.5938);
			SetPlayerFacingAngle(playerid, 180);
		}
	}
	else 
	{
		ResetWorldBounds(playerid);
	    SetPlayerInterior(playerid, PlayerInfo[playerid][Interior]);
		SetPlayerPos(playerid, PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ]);
		SetPlayerFacingAngle(playerid, PlayerInfo[playerid][FacingAngle]);
	}

	UpdatePlayerVisual(playerid);
	IsSpawned[playerid] = true;
	return 1;
}

stock UpdatePlayerVisual(playerid)
{
	SetCameraBehindPlayer(playerid);
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	SetPlayerColor(playerid, IsTourStarted ? HexTeamColors[PlayerInfo[playerid][TeamColor]][0] : HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
	if(!FCNPC_IsValid(playerid))
		UpdatePlayerWeapon(playerid);
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(IsBoss[playerid])
		return 0;

	if(killerid != INVALID_PLAYER_ID)
	{
		PlayerInfo[killerid][Kills]++;
		PlayerInfo[playerid][Deaths]++;
	}

	IsDeath[playerid] = true; 
	IsSpawned[playerid] = false;

	if(IsBossAttacker[playerid])
	{
		IsBossAttacker[playerid] = false;
		BossAttackersCount--;
		if(BossAttackersCount <= 0)
			FinishBossAttack();
		return 1;
	}
	if(IsTourStarted && killerid != INVALID_PLAYER_ID)
	{
		new lastkill = GetPVarInt(killerid, "LastKill");
		if(lastkill != -1) 
		{
			SetPVarInt(killerid, "LastKill", -1);
			return 1;
		}
		SetPVarInt(killerid, "LastKill", playerid);

		if(!FCNPC_IsDead(playerid))
			FCNPC_Kill(playerid);
		SendDeathMessage(killerid, playerid, reason);

		new killer_idx = GetPvpIndex(killerid);
		new player_idx = GetPvpIndex(playerid);
		if(killer_idx == -1 || player_idx == -1) return 1;
		if(GetPlayerTeam(playerid) == GetPlayerTeam(killerid))
		{
			SendClientMessage(killerid, COLOR_LIGHTRED, "����� �� �������� �������� 50 �����.");
			PvpInfo[player_idx][Score] -= 50;
			if(PvpInfo[player_idx][Score] < 0)
				PvpInfo[player_idx][Score] = 0;
			return 1;
		}

		PvpInfo[killer_idx][Kills]++;
		PvpInfo[player_idx][Deaths]++;
		PvpInfo[killer_idx][Score] += GetScoreDiff(PlayerInfo[playerid][Rate], PlayerInfo[killerid][Rate], true);
		PvpInfo[player_idx][Score] -= GetScoreDiff(PlayerInfo[playerid][Rate], PlayerInfo[killerid][Rate], false);
		if(PvpInfo[player_idx][Score] < 0)
			PvpInfo[player_idx][Score] = 0;
	}
	return 1;
}

public FCNPC_OnSpawn(npcid)
{
	if(IsBoss[npcid])
		return 0;
    FCNPC_SetHealth(npcid, 100);
	if(PlayerInfo[npcid][TeamColor] != -1 && IsTourStarted)
		SetPlayerColor(npcid, HexTeamColors[PlayerInfo[npcid][TeamColor]][0]);

	UpdatePlayerWeapon(npcid);
	UpdatePlayerSkin(npcid);
	if(IsTourStarted && IsTourParticipant(PlayerInfo[npcid][ID]))
		TeleportToRandomArenaPos(npcid);
	return 1;
}

public FCNPC_OnRespawn(npcid)
{
    FCNPC_OnSpawn(npcid);
}

public FCNPC_OnDeath(npcid, killerid, reason)
{
	if(IsBoss[npcid])
	{
		RollBossLoot();
		FinishBossAttack();
		return 1;
	}
	if(IsTourStarted)
		DeadCheckTimer[npcid] = SetTimerEx("CheckDead", 3000, false, "i", npcid);
	return 1;
}

public CheckDead(npcid)
{
	if(IsValidTimer(DeadCheckTimer[npcid]))
		KillTimer(DeadCheckTimer[npcid]);
    if(FCNPC_IsDead(npcid))
		FCNPC_Respawn(npcid);
}

public OnPlayerText(playerid, text[])
{
	new name[64];
	GetPlayerName(playerid, name, sizeof(name));
	new message[2048];
	if(PlayerInfo[playerid][Admin] > 0)
	{
		format(message, sizeof(message), "[�������������]: %s", text);
		SendClientMessageToAll(COLOR_LIGHTRED, message);
	}
	else
	{
		format(message, sizeof(message), "[%s]: %s", name, text);
		SendClientMessageToAll(HexRateColors[PlayerInfo[playerid][Rank]-1][0], message);
	}
	return 0;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == home_enter)
	{
		SetPlayerInterior(playerid, 1);
	    SetPlayerPos(playerid, -2160.8616,641.5761,1052.3817);
	    SetPlayerFacingAngle(playerid, 90);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	else if(pickupid == home_quit)
	{
	    SetPlayerPos(playerid, 224.0981,-1839.8425,3.6037);
	    SetPlayerFacingAngle(playerid, 180);
	    SetPlayerInterior(playerid, 0);
	    SetCameraBehindPlayer(playerid);
		return 1;
	}
	for(new i = 0; i < MAX_LOOT; i++)
	{
		if(pickupid == BossLootPickups[i])
		{
			if(IsInventoryFull(playerid))
			{
				SendClientMessage(playerid, COLOR_GREY, "��������� �����.");
				continue;
			}
			SafeDestroyPickup(BossLootPickups[i]);
			if(BossLootItems[i][ItemID] == -1) continue;

			if(IsEquip(BossLootItems[i][ItemID]))
				AddEquip(playerid, BossLootItems[i][ItemID], MOD_CLEAR);
			else
				AddItem(playerid, BossLootItems[i][ItemID], BossLootItems[i][Count]);
			
			new item[BaseItem];
			item = GetItem(BossLootItems[i][ItemID]);
			new string[255];
			format(string, sizeof(string), "���������: {%s}[%s] {ffffff}x%d.", 
				GetGradeColor(item[Grade]), item[Name], BossLootItems[i][Count]
			);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & 1024) SelectTextDraw(playerid,0xCCCCFF65);
	else if(newkeys & 16)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 221.0985,-1838.1259,3.6268))
		{
			new text[1024] = "{CCCCFF}\n\n";
			strcat(text, "                        ������! � - ������, �������� �����.      \n");
			strcat(text, "� ���� �������� � ��������� ��������, ������� ��� ����������.\n");
			strcat(text, "  ������ �� ��� ������, ����� �� ���������� ����� ����������! \n\n");
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", text, "�������", "");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 211.7733,-1838.2538,3.6687))
		{
			ShowPlayerPost(playerid);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 226.7674,-1837.6835,3.6120))
		{
			new listitems[] = "���������� � �������\n��������� �������\n��������� ���������� ����\n������ ������ ����������";
			ShowPlayerDialog(playerid, 200, DIALOG_STYLE_TABLIST, "���������� ���������", listitems, "�����", "�������");
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.2,-2171.3132,645.5896,1052.3817)) 
		{
			new listitems[] = "����� ������� ����������\n������� ���� ����������";
			ShowPlayerDialog(playerid, 300, DIALOG_STYLE_TABLIST, "����� ������", listitems, "�����", "�������");
        }
		//���������
		else if(IsPlayerInRangeOfPoint(playerid,1.8,189.2644,-1825.4902,4.1411))
		{
			new listitems[] = "������ ������\n��������������";
			ShowPlayerDialog(playerid, 500, DIALOG_STYLE_TABLIST, "���������", listitems, "�����", "�������");
		}
		//�������
		else if(IsPlayerInRangeOfPoint(playerid,1.8,262.6658,-1825.2792,3.9126))
		{
			new listitems[] = "������ ������\n��������������";
			ShowPlayerDialog(playerid, 600, DIALOG_STYLE_TABLIST, "�������", listitems, "�����", "�������");
		}
		//����������
		else if(IsPlayerInRangeOfPoint(playerid,1.8,-2166.7527,646.0400,1052.3750))
		{
			new listitems[2048];
			listitems = GetMaterialsSellerItemsList();
			ShowPlayerDialog(playerid, 700, DIALOG_STYLE_TABLIST_HEADERS, "�������� ������������", listitems, "������", "�������");
		}
		//�����
		else if(IsPlayerInRangeOfPoint(playerid,1.8,243.1539,-1831.6542,3.9772))
		{
			if(Tournament[Phase] == PHASE_WAR)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "�������� � ������� ���������� �� ����� ���� �����.", "�������", "");
				return 1;
			}
			if(BossNPC != -1)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "�������� ��� ����.", "�������", "");
				return 1;
			}
			new listitems[1024];
			listitems = GetBossesList();
			ShowPlayerDialog(playerid, 800, DIALOG_STYLE_TABLIST_HEADERS, "�����", listitems, "�����", "�������");
		}
		//�����
		else if(IsPlayerInRangeOfPoint(playerid,1.8,204.7617,-1831.6539,4.1772))
		{
			if(Tournament[Phase] == PHASE_PEACE)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "�������� �� ����� ���������� �� ����� ���� ����.", "�������", "");
				return 1;
			}
			if(IsTourStarted)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "�������� ��� ����.", "�������", "");
				return 1;
			}
			if(!IsAnyPlayersInRangeOfPoint(MAX_OWNERS,3.0,204.7617,-1831.6539,4.1772))
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "�� ��� ��������� ��������� �����.", "�������", "");
				return 1;
			}
			if(!FillTourPlayers())
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "��������� ��������� �� ��������� � ���� ����.", "�������", "");
				return 1;
			}
			StartTour();
		}
	}
	else if(newkeys & 131072)
	{
		if(IsTourStarted) return 1;
		new listitems[] = "���������� � ���������\n������� ���������";
		ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_TABLIST, "Bourgeois Circus", listitems, "�����", "�������");
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	//1 - ������
	//100-102 - �����������/�����������
	//103 - ����� �����
	//1000 - �������� ����
	switch (dialogid) 
	{
		//������
	    case 1: { return 1; }
		//�����������
		case 100:
		{
			if(response)
			{
				if(strlen(inputtext) < 4)
				{
					SendClientMessage(playerid, COLOR_GREY, "����� ������ ������ ���� �� ����� 4 ��������.");
					ShowPlayerDialog(playerid, 100, DIALOG_STYLE_PASSWORD, "�����������", "��������� ����� �� ���������������.\n\n���������� ������:", "�����", "�������");
					return 0;
				}

				new login[64];
				GetPlayerName(playerid, login, sizeof(login));
				new pass[255];
				pass = MD5_Hash(inputtext);

				new query[255];
				format(query, sizeof(query), "INSERT INTO `accounts`(`pass`, `admin`, `teamcolor`, `login`) VALUES ('%s','%d','%d','%s')", 
					pass, 0, 0, login
				);
				new Cache:q_result = mysql_query(sql_handle, query);
				cache_delete(q_result);

				AccountLogin[playerid] = login;
				SendClientMessage(playerid, COLOR_GREEN, "����������� ������ �������. �������� ����� �������������� ��� �������� ����������.");
				SendClientMessage(playerid, COLOR_WHITE, "������� /q ����� �����.");
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, "������� /q ����� �����.");
				return 0;
			}
		}

		case 102:
		{
			ShowPlayerDialog(playerid, 101, DIALOG_STYLE_PASSWORD, "�����������", "������� ������:", "����", "�������");
			return 1;
		}
		
		case 101:
		{
			if(strlen(inputtext) == 0)
			{
				ShowPlayerDialog(playerid, 101, DIALOG_STYLE_PASSWORD, "�����������", "������� ������:", "����", "�������");
				return 0;
			}

            new login[64];
			GetPlayerName(playerid, login, sizeof(login));

			new query[255];
			format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `login` = '%s' AND `pass` = '%s' LIMIT 1", login, MD5_Hash(inputtext));
			new Cache:q_result = mysql_query(sql_handle, query);

			new row_count = 0;
			cache_get_row_count(row_count);
			if(row_count <= 0)
			{
				cache_delete(q_result);
				ShowPlayerDialog(playerid, 102, DIALOG_STYLE_MSGBOX, "������", "�������� ������", "�������", "");
				return 0;
			}

			AccountLogin[playerid] = login;
			ConnectParticipants(playerid);

			if(ParticipantsCount[playerid] < 1)
			{
				SendClientMessage(playerid, COLOR_GREY, "� ����� ������� ������ �� ��������� ���������. ���������� � ��������������.");
				SendClientMessage(playerid, COLOR_WHITE, "������� /q ����� �����.");
				return 0;
			}

			SwitchPlayer(playerid);
			return 1;
		}

		case 103:
		{
			if(response)
			{
				if (PlayerConnect[playerid])
				    OnPlayerDisconnect(playerid, 1);
				SetPlayerName(playerid, Participants[playerid][listitem]);
				IsParticipant[playerid] = true;
				LoadPlayer(playerid);
				OnPlayerLogin(playerid);
			}
			else
			{
				return 0;
			}
		}

		case 200:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						new listitems[1024];
						new ptext[64];
						if(Tournament[Phase] == PHASE_PEACE) ptext = "����";
						else ptext = "�����";
						format(listitems, sizeof(listitems), "������ ���� ������ #%d.\n\n������� ����: ���� %s\n���: %d", 
							Tournament[Number], ptext, Tournament[Tour]
						);
						ShowPlayerDialog(playerid, 201, DIALOG_STYLE_MSGBOX, "���������� � �������", listitems, "�����", "�������");
					}
					case 1:
					{
						if(Tournament[Phase] == PHASE_PEACE)
						{
							ShowPlayerDialog(playerid, 201, DIALOG_STYLE_MSGBOX, "��������� �������", "������ �������� ���� ����.", "�����", "�������");
							return 0;
						}
						if(Tournament[Tour] <= 1)
						{
							ShowPlayerDialog(playerid, 201, DIALOG_STYLE_MSGBOX, "��������� �������", "������� ����� �������� ����� 1 ����.", "�����", "�������");
							return 0;
						}
						ShowTournamentTab(playerid);
					}
					case 2:
					{
						ShowTourParticipants(playerid);
					}
					case 3:
					{
						if(Tournament[Phase] == PHASE_WAR)
						{
							SendClientMessage(playerid, COLOR_GREY, "���� ����� ��� ����.");
							return 1;
						}
						for(new i = 0; i < MAX_OWNERS; i++)
						{
							if(ReadyIDs[i] == playerid)
							{
								SendClientMessage(playerid, COLOR_GREY, "�� ��� ������ ������.");
								return 1;
							}
							if(ReadyIDs[i] == -1)
							{
								ReadyIDs[i] = playerid;
								new name[255];
								new string[255];
								GetPlayerName(playerid, name, sizeof(name));
								format(string, sizeof(string), "%s �����(�) ������ � ���������� � ���� �����.", name);
								SendClientMessageToAll(COLOR_LIGHTRED, string);
								break;
							}
						}
						for(new i = 0; i < MAX_OWNERS; i++)
							if(ReadyIDs[i] == -1) return 1;
						SendClientMessageToAll(COLOR_LIGHTRED, "���������� ���� �����!");
						Tournament[Phase] = PHASE_WAR;
						SaveTournamentInfo();
						for(new i = 0; i < MAX_OWNERS; i++)
							ReadyIDs[i] = -1;
					}
				}
			}
			else
			{
				return 0;
			}
			return 1;
		}

		case 201:
		{
			if(response)
			{
				new listitems[] = "���������� � �������\n��������� �������\n��������� �������� ����\n������ ������ ����������";
				ShowPlayerDialog(playerid, 200, DIALOG_STYLE_TABLIST, "���������� ���������", listitems, "�����", "�������");
			}
			else
			{
				return 0;
			}
			return 1;
		}

		case 300:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						ShowGlobalRatingTop(playerid);
					}
					case 1:
					{
						ShowLocalRatingTop(playerid);
					}
				}
			}
			return 1;
		}

		case 400:
		{
			if(response)
			{
				if(SelectedSlot[playerid] == -1)
					return 0;
				
				new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
				if(itemid == -1)
					return 0;

				if(IsEquip(itemid))
				{
					new ok = DeleteItem(playerid, SelectedSlot[playerid], 1);
					if(ok)
					{
						new item[BaseItem];
						item = GetItem(itemid);
						new string[255];
						format(string, sizeof(string), "{ffffff}�� ���������: [{%s}%s{ffffff}].", GetGradeColor(item[Grade]), item[Name]);
						ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "���������", string, "�������", "");
					}
				}
				else
				{
					new string[255];
					format(string, sizeof(string), "������� ��������� ���������?\n� ������� - %d.", PlayerInventory[playerid][SelectedSlot[playerid]][Count]);
					ShowPlayerDialog(playerid, 402, DIALOG_STYLE_INPUT, "���������", string, "���������", "��������");
				}
			}
			return 1;
		}

		case 401:
		{
			if(response)
			{
				if(SelectedSlot[playerid] == -1)
					return 0;
				
				new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
				if(itemid == -1)
					return 0;

				if(IsEquip(itemid))
				{
					new ok = SellItem(playerid, SelectedSlot[playerid], 1);
					if(ok)
					{
						new item[BaseItem];
						item = GetItem(itemid);
						new price = item[Price] / 5;
						new string[255];
						format(string, sizeof(string), "{ffffff}�� �������: [{%s}%s{ffffff}].\n{66CC00}��������: %d$.", GetGradeColor(item[Grade]), item[Name], price);
						ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "���������", string, "�������", "");
					}
				}
				else
				{
					new string[255];
					format(string, sizeof(string), "������� ��������� �������?\n� ������� - %d.", PlayerInventory[playerid][SelectedSlot[playerid]][Count]);
					ShowPlayerDialog(playerid, 403, DIALOG_STYLE_INPUT, "���������", string, "�������", "��������");
				}
			}
			return 1;
		}

		case 402:
		{
			if(response)
			{
				if(SelectedSlot[playerid] == -1)
					return 0;

				new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
				if(itemid == -1)
					return 0;

				new item[BaseItem];
				item = GetItem(itemid);
				new count = strval(inputtext);
				if(count <= 0 || count > PlayerInventory[playerid][SelectedSlot[playerid]][Count])
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "�������� ����������.", "�������", "");
					return 0;
				}

				DeleteItem(playerid, SelectedSlot[playerid], count);
				
				new string[255];
				format(string, sizeof(string), "{ffffff}�� ���������: [{%s}%s{ffffff}] (x%d).", GetGradeColor(item[Grade]), item[Name], count);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "���������", string, "�������", "");
			}
			return 1;
		}

		case 403:
		{
			if(response)
			{
				if(SelectedSlot[playerid] == -1)
					return 0;

				new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
				if(itemid == -1)
					return 0;

				new item[BaseItem];
				item = GetItem(itemid);
				new count = strval(inputtext);
				if(count <= 0 || count > PlayerInventory[playerid][SelectedSlot[playerid]][Count])
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "�������� ����������.", "�������", "");
					return 0;
				}

				SellItem(playerid, SelectedSlot[playerid], count);
				
				new string[255];
				new price = (item[Price] * count) / 5;	
				format(string, sizeof(string), "{ffffff}�� �������: [{%s}%s{ffffff}] (x%d).\n{66CC00}��������: %d$.", GetGradeColor(item[Grade]), item[Name], count, price);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "���������", string, "�������", "");
			}
			return 1;
		}

		//���������
		case 500:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						new listitems[2048];
						listitems = GetWeaponSellerItemsList();
						ShowPlayerDialog(playerid, 501, DIALOG_STYLE_TABLIST_HEADERS, "���������", listitems, "������", "�������");
					}
					case 1:
					{
						ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "��������������", "���������� ����� �������� � ������ 1.0", "�������", "");
					}
				}
			}
			return 1;
		}
		case 501:
		{
			if(response)
			{
				new itemid = -1;

				new query[255];
				format(query, sizeof(query), "SELECT * FROM `weapon_seller` WHERE `ID` = '%d' LIMIT 1", listitem);
				new Cache:q_result = mysql_query(sql_handle, query);

				new row_count = 0;
				cache_get_row_count(row_count);
				if(row_count <= 0)
				{
					cache_delete(q_result);
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "�� ������� ������ �������.", "�������", "");
					return 0;
				}

				cache_get_value_name_int(0, "ItemID", itemid);
				cache_delete(q_result);

				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "�� ������� ������ �������.", "�������", "");
					return 0;
				}
				SetPVarInt(playerid, "BuyedItemID", itemid);

				new item[BaseItem];
				item = GetItem(itemid);

				if(PlayerInfo[playerid][Cash] < item[Price])
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "������������ �����.", "�������", "");
					return 0;
				}

				new text[255];
				format(text, sizeof(text), "{ffffff}[{%s}%s{ffffff}] - ������?", GetGradeColor(item[Grade]), item[Name]);
				ShowPlayerDialog(playerid, 502, DIALOG_STYLE_MSGBOX, "�������������", text, "��", "������");
			}	
			return 1;
		}
		case 502:
		{
			if(response)
			{
				if(IsInventoryFull(playerid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "��������� �����.", "�������", "");
					return 0;
				}
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				new item[BaseItem];
				item = GetItem(itemid);
				PlayerInfo[playerid][Cash] -= item[Price];
				GivePlayerMoney(playerid, -item[Price]);
				AddEquip(playerid, itemid, MOD_CLEAR);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�������", "{66CC00}������� ������.", "�������", "");
			}
			return 1;
		}
		//�������
		case 600:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						new listitems[2048];
						listitems = GetArmorSellerItemsList();
						ShowPlayerDialog(playerid, 601, DIALOG_STYLE_TABLIST_HEADERS, "�������", listitems, "������", "�������");
					}
					case 1:
					{
						ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "��������������", "���������� ����� �������� � ������ 1.0", "�������", "");
					}
				}
			}
			return 1;
		}
		case 601:
		{
			if(response)
			{
				new itemid = -1;

				new query[255];
				format(query, sizeof(query), "SELECT * FROM `armor_seller` WHERE `ID` = '%d' LIMIT 1", listitem);
				new Cache:q_result = mysql_query(sql_handle, query);

				new row_count = 0;
				cache_get_row_count(row_count);
				if(row_count <= 0)
				{
					cache_delete(q_result);
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "�� ������� ������ �������.", "�������", "");
					return 0;
				}

				cache_get_value_name_int(0, "ItemID", itemid);
				cache_delete(q_result);

				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "�� ������� ������ �������.", "�������", "");
					return 0;
				}
				SetPVarInt(playerid, "BuyedItemID", itemid);

				new item[BaseItem];
				item = GetItem(itemid);

				if(PlayerInfo[playerid][Cash] < item[Price])
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "������������ �����.", "�������", "");
					return 0;
				}

				new text[255];
				format(text, sizeof(text), "{ffffff}[{%s}%s{ffffff}] - ������?", GetGradeColor(item[Grade]), item[Name]);
				ShowPlayerDialog(playerid, 602, DIALOG_STYLE_MSGBOX, "�������������", text, "��", "������");
			}	
			return 1;
		}
		case 602:
		{
			if(response)
			{
				if(IsInventoryFull(playerid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "��������� �����.", "�������", "");
					return 0;
				}
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				new item[BaseItem];
				item = GetItem(itemid);
				PlayerInfo[playerid][Cash] -= item[Price];
				GivePlayerMoney(playerid, -item[Price]);
				AddEquip(playerid, itemid, MOD_CLEAR);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�������", "{66CC00}������� ������.", "�������", "");
			}
			return 1;
		}
		//����������
		case 700:
		{
			if(response)
			{
				new itemid = -1;

				new query[255];
				format(query, sizeof(query), "SELECT * FROM `materials_seller` WHERE `ID` = '%d' LIMIT 1", listitem);
				new Cache:q_result = mysql_query(sql_handle, query);

				new row_count = 0;
				cache_get_row_count(row_count);
				if(row_count <= 0)
				{
					cache_delete(q_result);
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "�� ������� ������ �������.", "�������", "");
					return 0;
				}

				cache_get_value_name_int(0, "ItemID", itemid);
				cache_delete(q_result);

				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "�� ������� ������ �������.", "�������", "");
					return 0;
				}

				new item[BaseItem];
				item = GetItem(itemid);
				
				if(item[Type] == ITEMTYPE_PASSIVE && HasItem(playerid, itemid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "� ��� ��� ���� ���� �������.", "�������", "");
					return 0;
				}

				SetPVarInt(playerid, "BuyedItemID", itemid);

				new available_count = item[Type] == ITEMTYPE_PASSIVE ? 1 : PlayerInfo[playerid][Cash] / item[Price];
				new text[255];
				format(text, sizeof(text), "������� ����������.\n�� ������ ������: %d", available_count);
				ShowPlayerDialog(playerid, 701, DIALOG_STYLE_INPUT, "�������", text, "������", "������");
			}	
			return 1;
		}
		case 701:
		{
			if(response)
			{
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "�� ������� ������ �������.", "�������", "");
					return 0;
				}

				new item[BaseItem];
				item = GetItem(itemid);

				new count = strval(inputtext);
				if(item[Type] == ITEMTYPE_PASSIVE && count > 1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "����� ����� ������ ���� �������.", "�������", "");
					return 0;
				}

				if(PlayerInfo[playerid][Cash] < item[Price] * count)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "������������ �����.", "�������", "");
					return 0;
				}

				SetPVarInt(playerid, "BuyedItemCount", count);

				new text[255];
				format(text, sizeof(text), "{ffffff}[{%s}%s{ffffff}] x%d - ������?", GetGradeColor(item[Grade]), item[Name], count);
				ShowPlayerDialog(playerid, 702, DIALOG_STYLE_MSGBOX, "�������������", text, "��", "������");
			}	
			return 1;
		}
		case 702:
		{
			if(response)
			{
				if(IsInventoryFull(playerid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "��������� �����.", "�������", "");
					return 0;
				}
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				new count = GetPVarInt(playerid, "BuyedItemCount");
				new item[BaseItem];
				item = GetItem(itemid);
				PlayerInfo[playerid][Cash] -= item[Price] * count;
				GivePlayerMoney(playerid, -(item[Price] * count));
				AddItem(playerid, itemid, count);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�������", "{66CC00}������� ������.", "�������", "");
			}
			return 1;
		}
		//�����
		case 800:
		{
			if(response)
			{
				if(AttackedBoss != -1 && listitem != AttackedBoss)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "�� ������ �� ������ ��� ���� �����.", "�������", "");
					return 0;
				}

				new bossid = listitem;
				new boss[BossInfo];
				boss = GetBoss(bossid);

				if(boss[RespawnTime] > 0)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "���� ���� ��� �� ��������.", "�������", "");
					return 0;
				}

				if(IsBossAttacker[playerid])
					return 0;
				BossAttackersCount++;
				IsBossAttacker[playerid] = true;
				AttackedBoss = bossid;

				new msg[255];
				if(BossAttackersCount >= MAX_OWNERS)
				{
					format(msg, sizeof(msg), "���������� %s!", boss[Name]);
					SendClientMessageToAll(0x990099FF, msg);
					if(IsValidTimer(PrepareBossAttackTimer))
						KillTimer(PrepareBossAttackTimer);
					PrepareBossAttackTimer = -1;
					StartBossAttack();
					return 1;
				}

				PrepareBossAttackTimer = SetTimer("CancelBossAttack", 120000, false);
				new name[255];
				GetPlayerName(playerid, name, sizeof(name));
				format(msg, sizeof(msg), "%s ����� ����� �� %s!", name, boss[Name]);
				SendClientMessageToAll(0x990099FF, msg);
			}
			return 1;
		}
		//�����
		case 900:
		{
			if(response)
			{
				ClaimMail(playerid, listitem);
			}
		}

		//�������� ����
		case 1000:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						ShowCharInfo(playerid);
					}
					case 1:
					{
						SwitchPlayer(playerid);
					}
				}
			}
			else
				return 0;
			return 1;
		}
	}
	return 1;
}

public FCNPC_OnUpdate(npcid)
{
	if(npcid == BossNPC && !IsTourStarted)
	{
		BossBehaviour(npcid);
		return 1;
	}

	if(!IsTourStarted) return 1;

	new lastkill = GetPVarInt(npcid, "LastKill");
	if(lastkill != -1)
	{
		if(FCNPC_IsValid(lastkill) && !FCNPC_IsDead(lastkill))
			SetPVarInt(npcid, "LastKill", -1);
		else if(!IsDeath[npcid])
			SetPVarInt(npcid, "LastKill", -1);
	}

	ParticipantBehaviour(npcid);

	return 1;
}

public OnPlayerUpdate(playerid)
{    
	if(FCNPC_IsValid(playerid)) return 0;
	if(!IsSpawned[playerid]) return 0;

	if(IsTourStarted)
	{
		if(IsValidDynamicArea(arena_area) && !IsPlayerInDynamicArea(playerid, arena_area))
		{
			TeleportToRandomArenaPos(playerid);
			UpdatePlayerVisual(playerid);
		}

		new lastkill = GetPVarInt(playerid, "LastKill");
		if(lastkill != -1)
		{
			if(FCNPC_IsValid(lastkill) && !FCNPC_IsDead(lastkill))
				SetPVarInt(playerid, "LastKill", -1);
			else if(!IsDeath[playerid])
				SetPVarInt(playerid, "LastKill", -1);
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid == ChrInfClose[playerid])
	{
		HideCharInfo(playerid);
		CancelSelectTextDraw(playerid);
	}
	else if(playertextid == UpgClose[playerid])
	{
		HideModWindow(playerid);
	}
	else if(playertextid == ChrInfWeaponSlot[playerid])
	{
		if(PlayerInfo[playerid][WeaponSlotID] == 0) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "��������� �����.", "�������", "");
			return 0;
		}

		UndressEquip(playerid, ITEMTYPE_WEAPON);
	}
	else if(playertextid == ChrInfArmorSlot[playerid])
	{
		if(PlayerInfo[playerid][ArmorSlotID] == 81) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "��������� �����.", "�������", "");
			return 0;
		}

		UndressEquip(playerid, ITEMTYPE_ARMOR);
	}
	else if(playertextid == ChrInfAccSlot1[playerid])
	{
		if(PlayerInfo[playerid][AccSlot1ID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "��������� �����.", "�������", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][AccSlot1ID], MOD_CLEAR);
		PlayerInfo[playerid][AccSlot1ID] = -1;
		UpdatePlayerStats(playerid);

		if(IsInventoryOpen[playerid])
			UpdateEquipSlots(playerid);
	}
	else if(playertextid == ChrInfAccSlot2[playerid])
	{
		if(PlayerInfo[playerid][AccSlot2ID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "��������� �����.", "�������", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][AccSlot2ID], MOD_CLEAR);
		PlayerInfo[playerid][AccSlot2ID] = -1;
		UpdatePlayerStats(playerid);

		if(IsInventoryOpen[playerid])
			UpdateEquipSlots(playerid);
	}
	else if(playertextid == ChrInfButUse[playerid])
	{
		if(SelectedSlot[playerid] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;

		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(itemid == -1)
			return 0;

		if(IsEquip(itemid))
		{
			new equip[BaseItem];
			equip = GetItem(itemid);
			if((HasItem(playerid, 186, 1) ? PlayerInfo[playerid][MaxRank] + 1 : PlayerInfo[playerid][MaxRank]) < equip[MinRank])
			{
				new string[255];
				format(string, sizeof(string), "{ffffff}��� ���� �� ������������� ������������ ��� ����� ��������.\n����������� ���� - {%s}%s", 
					RateColors[equip[MinRank]-1], GetRankInterval(equip[MinRank])
				);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "���������", string, "�������", "");
				return 0;
			}
			EquipItem(playerid, equip[Type], SelectedSlot[playerid]);
			return 1;
		}
		if(IsLockbox(itemid))
		{
			if(IsInventoryFull(playerid))
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "������", "��������� �����.", "�������", "");
				return 0;
			}
			DeleteItem(playerid, SelectedSlot[playerid], 1);
			OpenLockbox(playerid, itemid);
		}
	}
	else if(playertextid == ChrInfButInfo[playerid])
	{
		if(IsSlotsBlocked[playerid]) return 0;
		if(SelectedSlot[playerid] == -1)
			return 0;
		if(PlayerInventory[playerid][SelectedSlot[playerid]][ID] == -1)
			return 0;

		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(IsModifiableEquip(itemid))
			ShowEquipInfo(playerid, itemid, PlayerInventory[playerid][SelectedSlot[playerid]][Mod]);
		else
			ShowItemInfo(playerid, itemid);
	}
	else if(playertextid == ChrInfButDel[playerid])
	{
		if(IsSlotsBlocked[playerid]) return 0;
		if(SelectedSlot[playerid] == -1)
			return 0;
		if(PlayerInventory[playerid][SelectedSlot[playerid]][ID] == -1)
			return 0;

		new item[BaseItem];
		item = GetItem(PlayerInventory[playerid][SelectedSlot[playerid]][ID]);
		new desc[255];
		if(IsPlayerBesideNPC(playerid))
		{
			format(desc, sizeof(desc), "{ffffff}[{%s}%s{ffffff}] - �������?", GetGradeColor(item[Grade]), item[Name]);
			ShowPlayerDialog(playerid, 401, DIALOG_STYLE_MSGBOX, "���������", desc, "�����", "�������");
		}
		else
		{
			format(desc, sizeof(desc), "{ffffff}[{%s}%s{ffffff}] - ���������?", GetGradeColor(item[Grade]), item[Name]);
			ShowPlayerDialog(playerid, 400, DIALOG_STYLE_MSGBOX, "���������", desc, "�����", "�������");
		}
		return 1;
	}
	else if(playertextid == ChrInfButMod[playerid])
	{
		if(Windows[playerid][Mod])
		{
			HideModWindow(playerid);
			return 0;
		}
		if(SelectedSlot[playerid] != -1)
		{
			new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
			if(IsModifiableEquip(itemid))
			{
				if(GetModLevel(PlayerInventory[playerid][SelectedSlot[playerid]][Mod]) == MAX_MOD)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����������", "���� ������� ������ ������������� ������ �����������.", "�������", "");
					return 0;
				}
				ShowModWindow(playerid, SelectedSlot[playerid]);
				return 1;
			}
		}
		ShowModWindow(playerid);
	}
	else if(playertextid == UpgItemSlot[playerid])
	{
		if(SelectedSlot[playerid] == -1) return 0;
		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(itemid == -1) return 0;
		if(!IsModifiableEquip(itemid)) return 0;
		if(GetModLevel(PlayerInventory[playerid][SelectedSlot[playerid]][Mod]) == MAX_MOD)
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����������", "���� ������� ������ ������������� ������ �����������.", "�������", "");
			return 0;
		}

		ModItemSlot[playerid] = SelectedSlot[playerid];
		ModStone[playerid] = -1;
		ModPotion[playerid] = -1;
		UpdateModWindow(playerid);
	}
	else if(playertextid == UpgStoneSlot[playerid])
	{
		if(SelectedSlot[playerid] == -1) return 0;
		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(itemid == -1) return 0;
		if(!IsModStone(itemid)) return 0;
		if(ModItemSlot[playerid] == -1)
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����������", "�� ������ ������� ��� �����������.", "�������", "");
			return 0;
		}

		new equip[BaseItem];
		equip = GetItem(PlayerInventory[playerid][ModItemSlot[playerid]][ID]);
		if( ((itemid == 187 || itemid == 189) && equip[Type] == ITEMTYPE_WEAPON) ||
			((itemid == 188 || itemid == 190) && equip[Type] == ITEMTYPE_ARMOR) )
		{
			ModStone[playerid] = itemid;
			UpdateModWindow(playerid);
		}
		else
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����������", "������ ������������ ���� ������.", "�������", "");
			return 0;
		}
	}
	else if(playertextid == UpgPotionSlot[playerid])
	{
		if(SelectedSlot[playerid] == -1) return 0;
		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(itemid == -1) return 0;
		if(!IsModPotion(itemid)) return 0;
		if(ModItemSlot[playerid] == -1)
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����������", "�� ������ ������� ��� �����������.", "�������", "");
			return 0;
		}
		
		ModPotion[playerid] = itemid;
		UpdateModWindow(playerid);
	}
	else if(playertextid == UpgBtn[playerid])
	{
		if(ModItemSlot[playerid] == -1) return 0;
		if(ModStone[playerid] == -1) return 0;
		UpgradeItem(playerid, ModItemSlot[playerid], ModStone[playerid], ModPotion[playerid]);
		UpdateModWindow(playerid);
	}
	else if(playertextid == InfClose[playerid])
	{
		HideItemInfo(playerid);
	}
	else if(playertextid == EqInfClose[playerid])
	{
		HideEquipInfo(playerid);
	}

	for (new i = 0; i < MAX_SLOTS; i++) {
        if (playertextid == ChrInfInvSlot[playerid][i]) {
            if (SelectedSlot[playerid] != -1) 
			{
                if(!IsSlotsBlocked[playerid] && PlayerInventory[playerid][SelectedSlot[playerid]][ID] != -1 && PlayerInventory[playerid][i][ID] == -1) 
				{
					PlayerInventory[playerid][i] = PlayerInventory[playerid][SelectedSlot[playerid]];
					PlayerInventory[playerid][SelectedSlot[playerid]] = EmptyInvItem;
                    new oldslot = SelectedSlot[playerid];
                    SelectedSlot[playerid] = -1;
                    UpdateSlot(playerid, oldslot);
                    UpdateSlot(playerid, i);
                    break;
                }
                SetSlotSelection(playerid, SelectedSlot[playerid], false);
            }
            SelectedSlot[playerid] = i;
            SetSlotSelection(playerid, i, true);
            break;
        }
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

public bool:CheckChance(chance)
{
	new rnd = random(100);
	return rnd < chance;
}

public TeleportToHome(playerid)
{
	ResetWorldBounds(playerid);
	SetPlayerPos(playerid, 224.0761,-1839.8217,3.6037);
	SetPlayerInterior(playerid, 0);
	SetPlayerTeam(playerid, NO_TEAM);
}

public CancelBossAttack()
{
	if(IsValidTimer(PrepareBossAttackTimer))
		KillTimer(PrepareBossAttackTimer);
	PrepareBossAttackTimer = -1;
	AttackedBoss = -1;
	for(new i = 0; i < MAX_PLAYERS; i++)
		IsBossAttacker[i] = false;
	BossAttackersCount = 0;
	SendClientMessageToAll(0x990099FF, "����� �� ����� ��������.");
}

public FinishBossAttack()
{
	if(IsValidTimer(PrepareBossAttackTimer))
		KillTimer(PrepareBossAttackTimer);
	if(IsValidTimer(BossAttackTimer))
		KillTimer(BossAttackTimer);
	PrepareBossAttackTimer = -1;
	BossAttackTimer = -1;

	if(FCNPC_IsDead(BossNPC))
	{
		SendClientMessageToAll(COLOR_GREEN, "������! ����� 10 ������ ��� ��������� ����� ���������������.");
		TeleportTimer = SetTimer("TeleportBossAttackersToHome", 10000, false);
		SetBossCooldown(AttackedBoss);
	}
	else
	{
		SendClientMessageToAll(COLOR_RED, "���������. ��� ��������� ���������������.");
		TeleportBossAttackersToHome();
	}
}

public TeleportBossAttackersToHome()
{
	if(IsValidTimer(TeleportTimer))
		KillTimer(TeleportTimer);

	TeleportTimer = -1;
	for(new i = 0; i < MAX_PLAYERS; i++)
		if(IsBossAttacker[i] && !IsDeath[i]) 
			TeleportToHome(i);

	ResetLoot();
	DestroyBoss();
}

public UpdatePlayerMaxHP(playerid)
{
	new Float:max_hp = 1000.0;
	max_hp = floatmul(max_hp, PlayerInfo[playerid][Rank]);
	if(max_hp < 1000)
	    max_hp = 1000.0;
	MaxHP[playerid] = max_hp;
	PlayerHPMultiplicator[playerid] = floatround(floatdiv(max_hp, 100));
}

public SetPlayerMaxHP(playerid, Float:hp, bool:give_hp)
{
	new Float:diff;
	diff = floatsub(hp, MaxHP[playerid]);
	MaxHP[playerid] = hp;
	PlayerHPMultiplicator[playerid] = floatround(floatdiv(hp, 100));
	if(give_hp)
	{
		GivePlayerHP(playerid, diff);
		UpdateHPBar(playerid);
	}
}

public Float:GetPlayerMaxHP(playerid)
{
	return MaxHP[playerid];
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
	if(hp < 0)
		hp = 0;
	new Float:value = floatdiv(hp, PlayerHPMultiplicator[playerid]);
	if(value < 0.5)
		value = 0;

	if(FCNPC_IsValid(playerid))
		FCNPC_SetHealth(playerid, value);
	else
	{
		SetPlayerHealth(playerid, value);
		UpdateHPBar(playerid);
	}
}

public GivePlayerHP(playerid, Float:hp)
{
	new Float:max_hp = GetPlayerMaxHP(playerid);
	new Float:cur_hp = GetPlayerHP(playerid);
	new Float:new_hp = floatadd(cur_hp, hp);
	if(new_hp > max_hp)
		new_hp = max_hp;
	if(new_hp < 0)
		new_hp = 0;
	SetPlayerHP(playerid, new_hp);
}

public Float:GetPlayerHP(playerid)
{
	new Float:hp;
	if(FCNPC_IsValid(playerid))
		hp = FCNPC_GetHealth(playerid);
	else
		GetPlayerHealth(playerid, hp);
	hp = floatmul(hp, PlayerHPMultiplicator[playerid]);
	return hp;
}

public RegeneratePlayerHP(playerid)
{
	if(IsDeath[playerid]) return;
	if(FCNPC_IsValid(playerid) && FCNPC_IsDead(playerid)) return;
	new Float:hp;
	if(FCNPC_IsValid(playerid))
		hp = floatmul(GetPlayerMaxHP(playerid), 0.01);
	else
		hp = floatmul(GetPlayerMaxHP(playerid), HasItem(playerid, 182, 1) ? 0.02 : 0.01);
	GivePlayerHP(playerid, hp);
}

public GivePlayerRate(playerid, rate)
{
	new string[255];
	if(rate > 0)
		format(string, sizeof(string), "{66CC00}������� �������: %d", rate);
	else
		format(string, sizeof(string), "{CC0000}������� �������: %d", rate);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);

	PlayerInfo[playerid][Rate] += rate;
	if(PlayerInfo[playerid][Rate] < 0) PlayerInfo[playerid][Rate] = 0;
	if(PlayerInfo[playerid][Rate] > MAX_RATE) PlayerInfo[playerid][Rate] = MAX_RATE;
	GivePlayerRateOffline(PlayerInfo[playerid][Name], rate);
	UpdatePlayerRank(playerid);
	UpdateLocalRatingTop(playerid);
}

public GivePlayerMoneyOffline(name[], money)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Name` = '%s' LIMIT 1", name);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("Cannot give player money offline.");
		return;
	}

	new new_cash = 0;
	cache_get_value_name_int(0, "Cash", new_cash);
	cache_delete(q_result);

	new_cash += money;
	if(new_cash < 0) new_cash = 0;
	format(query, sizeof(query), "UPDATE `players` SET `Cash` = '%d' WHERE `Name` = '%s' LIMIT 1", new_cash, name);
	new Cache:result = mysql_query(sql_handle, query);
	cache_delete(result);
}

public GivePlayerRateOffline(name[], rate)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Name` = '%s' LIMIT 1", name);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("Cannot give player rate offline.");
		return;
	}

	new new_rate = 0;
	cache_get_value_name_int(0, "Rate", new_rate);
	cache_delete(q_result);

	new_rate += rate;
	if(new_rate < 0) new_rate = 0;
	if(new_rate > MAX_RATE) new_rate = MAX_RATE;
	format(query, sizeof(query), "UPDATE `players` SET `Rate` = '%d' WHERE `Name` = '%s' LIMIT 1", new_rate, name);
	new Cache:result = mysql_query(sql_handle, query);
	cache_delete(result);
}

public SetPlayerRateOffline(name[], rate)
{
	new new_rate = rate;
	if(new_rate < 0) new_rate = 0;
	if(new_rate > MAX_RATE) new_rate = MAX_RATE;
	new query[255];
	format(query, sizeof(query), "UPDATE `players` SET `Rate` = '%d' WHERE `Name` = '%s' LIMIT 1", new_rate, name);
	new Cache:result = mysql_query(sql_handle, query);
	cache_delete(result);
}

public SetPlayerRate(playerid, rate)
{
	PlayerInfo[playerid][Rate] = rate;
	if(PlayerInfo[playerid][Rate] < 0) PlayerInfo[playerid][Rate] = 0;
	if(PlayerInfo[playerid][Rate] > MAX_RATE) PlayerInfo[playerid][Rate] = MAX_RATE;
	SetPlayerRateOffline(PlayerInfo[playerid][Name], rate);
	UpdatePlayerRank(playerid);
	UpdateLocalRatingTop(playerid);
}

/* Stock functions */
stock IsValidTimer(timerid)
{
	if(timerid < 0) return false;
	return true;
}
stock StartTour()
{
	new string[255];
	//reset all
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new name[255];
		PvpInfo[i][ID] = -1;
		PvpInfo[i][Name] = name;
		PvpInfo[i][Score] = 0;
		PvpInfo[i][Kills] = 0;
		PvpInfo[i][Deaths] = 0;
	}

	IsTourStarted = true;

	//teleport all
	new npcid = -1;
	for(new i = 0; i < TourParticipantsCount; i++)
	{
		new player[pInfo];
		player = GetPlayer(Tournament[ParticipantsIDs][i]);
		new playerid = GetPlayerInGameID(player[ID]);
		if(playerid != -1 && !FCNPC_IsValid(playerid))
		{
			PvpInfo[i][ID] = playerid;
			format(PvpInfo[i][Name], 255, "%s", player[Name]);
			TeleportToRandomArenaPos(playerid);
			DamageCounter[playerid] = 0;
			SetPlayerColor(playerid, HexTeamColors[PlayerInfo[playerid][TeamColor]][0]);
			SetPlayerHP(playerid, MaxHP[playerid]);
			SetPvpTableVisibility(playerid, true);
			continue;
		}

		npcid = FCNPC_Create(player[Name]);
		if(!FCNPC_IsValid(npcid))
		{
			print("Failed to create NPC.");
			continue;
		}

		InitTourNPC(npcid);
		PvpInfo[i][ID] = npcid;
		format(PvpInfo[i][Name], 255, "%s", player[Name]);
		TeleportToRandomArenaPos(npcid);
	}

	//set teams
	new query[255] = "SELECT * FROM `accounts` WHERE `admin` = '0'";
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	q_result = cache_save();
	cache_unset_active();
	for(new i = 0; i < row_count; i++)
	{
		cache_set_active(q_result);
		new owner[255];
		cache_get_value_name(i, "login", owner);
		cache_unset_active();

		format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` = '%s'", owner);
		new Cache:result = mysql_query(sql_handle, query);
		
		new rows = 0;
		cache_get_row_count(rows);
		if(rows <= 0)
		{
			cache_delete(result);
			continue;
		}

		result = cache_save();
		cache_unset_active();

		for(new j = 0; j < rows; j++)
		{
			new id = -1;
			cache_set_active(result);
			cache_get_value_name_int(j, "ID", id);
			cache_unset_active();
			if(id == -1) continue;

			new playerid = GetPlayerInGameID(id);
			if(playerid != -1)
				SetPlayerTeam(playerid, i+1);
		}
		
		cache_delete(result);
	}

	cache_delete(q_result);
	
	format(string, sizeof(string), "���������� %d ���!", Tournament[Tour]);
	SendClientMessageToAll(COLOR_LIGHTRED, string);

	PvpTtl = 180;
	TourEndTimer = SetTimerEx("OnTourEnd", 180000, false, "i", 1);
	PvpTableUpdTimer = SetTimer("UpdatePvpTable", 1000, true);

	print("Tour started.");
}

stock GetScoreDiff(rate1, rate2, bool:is_killer)
{
	new diff = rate1 - rate2;
	if(diff > 0)
		diff = floatround(floatmul(diff, 0.15));
	else
		diff = floatround(floatabs(floatmul(3001 - floatabs(diff), 0.007)));
	if(is_killer)
		diff += 50;
	return diff;
}

stock GetWeaponDelay(weaponid)
{
	switch(weaponid)
	{
		case 22: return COLT_SHOOT_DELAY;
		case 24: return DEAGLE_SHOOT_DELAY;
		case 25: return SHOTGUN_SHOOT_DELAY;
		case 26: return SAWNOFF_SHOOT_DELAY;
		case 27: return COMBAT_SHOOT_DELAY;
		case 28,32: return TEC_SHOOT_DELAY;
		case 29: return MP5_SHOOT_DELAY;
		case 30: return AK_SHOOT_DELAY;
		case 31: return M4_SHOOT_DELAY;
	}
	return DEFAULT_SHOOT_DELAY;
}

stock GetPvpIndex(playerid)
{
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
		if(PvpInfo[i][ID] == playerid) return i;
	return -1;
}

stock GetPlayerInGameID(global_id)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
		if(IsPlayerConnected(i) && PlayerInfo[i][ID] == global_id) return i;
	return -1;
}

stock InitTourNPC(npcid)
{
	if(npcid == -1) return;

	LoadPlayer(npcid);
	DamageCounter[npcid] = 0;

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `login` = '%s' LIMIT 1", PlayerInfo[npcid][Owner]);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("Cannot init tour NPC.");
		return;
	}

	q_result = cache_save();
	cache_unset_active();

	new teamcolor = 0;
	cache_set_active(q_result);
	cache_get_value_name_int(0, "teamcolor", teamcolor);
	cache_unset_active();
	cache_delete(q_result);

	PlayerInfo[npcid][TeamColor] = teamcolor;

	for(new i = 0; i < MAX_OWNERS; i++)
		FCNPC_ShowInTabListForPlayer(npcid, TourPlayers[i]);

	FCNPC_SetInvulnerable(npcid, false);
	FCNPC_SetInterior(npcid, 0);
	OnPlayerLogin(npcid);
	UpdatePlayerWeapon(npcid);
}

stock ParticipantBehaviour(id)
{
	if(id == -1 || id == INVALID_PLAYER_ID) return 1;
	if(!FCNPC_IsValid(id)) return 1;

	//If NPC bumped any obstacle - move him
	if(FCNPC_IsMoving(id) && FCNPC_GetSpeed(id) < 0.1)
	{
		MoveAround(id);
		return 1;
	}

	//If NPC too close with other players - move him
	new target = FCNPC_GetAimingPlayer(id);
	if(IsNPCCloseToAnyPlayer(id))
	{
		if(!FCNPC_IsMoving(id) || (target != -1 && target != INVALID_PLAYER_ID && FCNPC_IsMovingAtPlayer(id, target)))
		{
			if(FCNPC_IsAiming(id))
				FCNPC_StopAim(id);
			MoveAround(id);
		}
		return 1;
	}

	//Checking available target
	if(!FCNPC_IsAiming(id) && !FCNPC_IsDead(id))
		SetPlayerTarget(id);

	//If current target is dead or invalid, set new
	target = FCNPC_GetAimingPlayer(id);
	if(target == -1 || target == INVALID_PLAYER_ID)
	{
		SetPlayerTarget(id);
		return 1;
	}
	if(FCNPC_IsDead(target) || (!FCNPC_IsValid(target) && (!IsPlayerInDynamicArea(target, arena_area) || IsDeath[target])))
	{
		SetPlayerTarget(id);
		return 1;
	}

	new Float:dist = GetDistanceBetweenPlayers(id, target);
	if(!FCNPC_IsMovingAtPlayer(id, target) && dist > 10.0)
		FCNPC_GoToPlayer(id, target);

	//If player so close to target - attack it
	if(dist <= 10)
	{
		if(FCNPC_IsMoving(id))
			FCNPC_Stop(id);
		if(!FCNPC_IsShooting(id))
			FCNPC_AimAtPlayer(id, target, true, GetWeaponDelay(FCNPC_GetWeapon(id)));
	}
	else
		FCNPC_AimAtPlayer(id, target, false);

	//If there are targets with less HP beside player - change target
	new potential_target = FindPlayerTarget(id, true);
	if(potential_target != -1)
	{
		new Float:t_hp = FCNPC_GetHealth(target);
		new Float:pt_hp = FCNPC_GetHealth(potential_target);
		if(floatsub(t_hp, pt_hp) >= 35)
			SetPlayerTarget(id, potential_target);
	}
	
	return 1;
}

stock BossBehaviour(id)
{
	if(id == -1 || id == INVALID_PLAYER_ID) return;

	//If NPC bumped any obstacle - move him
	if(FCNPC_IsMoving(id) && FCNPC_GetSpeed(id) < 0.1)
	{
		MoveAround(id);
		return;
	}

	//Checking available target
	if(!FCNPC_IsDead(id) && BossAttackersCount > 1 && CheckChance(15))
	{
		SetBossTarget(id);
		return;
	}

	//If current target is dead, set new
	new target = FCNPC_GetAimingPlayer(id);
	if(target == -1 || target == INVALID_PLAYER_ID || IsDeath[target])
	{
		SetBossTarget(id);
		return;
	}

	new Float:dist = GetDistanceBetweenPlayers(id, target);
	if(!FCNPC_IsMovingAtPlayer(id, target) && dist > 10.0)
	{
		FCNPC_AimAtPlayer(id, target, false);
		FCNPC_GoToPlayer(id, target);
	}

	//If player so close to target - attack it
	if(dist <= 10)
	{
		if(FCNPC_IsMoving(id))
			FCNPC_Stop(id);
		if(!FCNPC_IsShooting(id))
			FCNPC_AimAtPlayer(id, target, true, BOSS_SHOOT_DELAY);
	}
}

stock GiveTournamentRewards()
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` <> 'Admin' LIMIT %d", MAX_PARTICIPANTS);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("Cannot give tournament rewards.");
		return;
	}

	q_result = cache_save();
	cache_unset_active();

	for(new i = 0; i < row_count; i++)
	{
		new name[255];
		new rank = 1;
		new place = MAX_PARTICIPANTS;
		new money = 0;

		cache_set_active(q_result);
		cache_get_value_name(i, "Name", name);
		cache_get_value_name_int(i, "Rank", rank);
		cache_get_value_name_int(i, "GlobalTopPos", place);
		cache_unset_active();

		new reward[RewardInfo];
		switch(place)
		{
			case 1:
			{
				reward[ItemID] = 203;
				reward[ItemsCount] = 7;
				money = 1000;
			}
			case 2:
			{
				reward[ItemID] = 203;
				reward[ItemsCount] = 6;
				money = 800;
			}
			case 3:
			{
				reward[ItemID] = 203;
				reward[ItemsCount] = 5;
				money = 500;
			}
			case 4..5:
			{
				reward[ItemID] = 203;
				reward[ItemsCount] = 3;
				money = 350;
			}
			case 6..8:
			{
				reward[ItemID] = 202;
				reward[ItemsCount] = 4;
				money = 200;
			}
			case 9..12:
			{
				reward[ItemID] = 202;
				reward[ItemsCount] = 3;
				money = 100;
			}
			case 13..16:
			{
				reward[ItemID] = 202;
				reward[ItemsCount] = 2;
				money = 50;
			}
			default:
			{
				reward[ItemID] = 202;
				reward[ItemsCount] = 1;
				money = 10;
			}
		}

		money = money * floatround(floatpower(rank, 2));
		reward[Money] = money;

		new id = GetPlayerID(name);
		if(id == -1)
		{
			if(reward[ItemID] != -1)
				PendingItem(name, reward[ItemID], reward[ItemsCount]);
			if(reward[Money] > 0)
				GivePlayerMoneyOffline(name, reward[Money]);
		}
		else
		{
			if(reward[ItemID] != -1)
			{
				if(IsInventoryFull(id))
				{
					SendClientMessage(id, COLOR_GREY, "��������� �����, ������� ���������� �� �����.");
					PendingItem(name, reward[ItemID], reward[ItemsCount]);
					UpdatePlayerPost(id);
					continue;
				}
				if(IsEquip(reward[ItemID]))
					AddEquip(id, reward[ItemID], MOD_CLEAR);
				else
					AddItem(id, reward[ItemID], reward[ItemsCount]);
			}
			if(reward[Money] > 0)
				AddPlayerMoney(id, reward[Money]);
		}
	}
}

stock UpdateBossesCooldowns()
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `bosses` LIMIT %d", MAX_BOSSES);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("Cannot update boss cooldowns.");
		return;
	}

	q_result = cache_save();
	cache_unset_active();

	for(new i = 0; i < row_count; i++)
	{
		new cooldown = 0;
		cache_set_active(q_result);
		cache_get_value_name_int(i, "RespawnTime", cooldown);
		cache_unset_active();

		cooldown--;
		if(cooldown < 0)
			cooldown = 0;

		new sub_query[255];
		format(sub_query, sizeof(sub_query), "UPDATE `bosses` SET `RespawnTime` = '%d' WHERE `ID` = '%d' LIMIT 1", cooldown, i);
		new Cache:result = mysql_query(sql_handle, sub_query);
		cache_delete(result);
	}

	cache_delete(q_result);
}

stock GiveTourRates(tour)
{
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) break;

		new rate = GetRateDifference(tour, i+1);
		if(IsPlayerConnected(id))
			GivePlayerRate(id, rate);
		else
			GivePlayerRateOffline(PvpInfo[i][Name], rate);
	}
}

stock GetPlayerRankOffline(name[])
{
	new rank = 1;
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Name` = '%s' LIMIT 1", name);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("Cannot get player rank offline.");
		return rank;
	}

	cache_get_value_name_int(0, "Rank", rank);
	cache_delete(q_result);
	return rank;
}

stock GetTourReward(tour, place, name[])
{
	new reward[RewardInfo];
	reward[ItemID] = -1;
	reward[ItemsCount] = 0;
	
	new money = 0;
	new rank = GetPlayerRankOffline(name);
	switch(place)
	{
		case 1: money = 100;
		case 2: money = 80; 
		case 3: money = 60;
		case 4..5: money = 35;
		case 6..8: money = 30;
		case 9..12: money = 20;
		case 13..16: money = 10;
		case 17..20: money = 5;
	}
	money = money * floatround(floatpower(rank + tour, 2));
	reward[Money] = money;
	return reward;
}

stock GiveTourRewards(tour)
{
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) break;

		new reward[RewardInfo];
		reward = GetTourReward(tour, i+1, PvpInfo[i][Name]);

		if(IsPlayerConnected(id))
		{
			if(reward[ItemID] != -1 && reward[ItemsCount] > 0)
			{
				if(IsInventoryFull(id))
				{
					SendClientMessage(id, COLOR_GREY, "��������� �����, ������� ���������� �� �����.");
					PendingItem(PvpInfo[i][Name], reward[ItemID], reward[ItemsCount]);
					UpdatePlayerPost(id);
					continue;
				}
				if(IsEquip(reward[ItemID]))
					AddEquip(id, reward[ItemID], MOD_CLEAR);
				else
					AddItem(id, reward[ItemID], reward[ItemsCount]);
			}
			if(reward[Money] > 0)
				AddPlayerMoney(id, reward[Money]);
		}
		else
		{
			if(reward[ItemID] != -1 && reward[ItemsCount] > 0)
				PendingItem(PvpInfo[i][Name], reward[ItemID], reward[ItemsCount]);
			if(reward[Money] > 0)
				GivePlayerMoneyOffline(PvpInfo[i][Name], reward[Money]);
		}
	}
}

stock AddPlayerMoney(playerid, money)
{
	new string[255];
	format(string, sizeof(string), "�������� %d$.", money);
	SendClientMessage(playerid, 0x00CC00FF, string);

	PlayerInfo[playerid][Cash] += money;
	GivePlayerMoney(playerid, money);
}

stock UpdatePlayerPost(playerid)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `pendings` WHERE `PlayerName` = '%s'", PlayerInfo[playerid][Name]);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	cache_delete(q_result);
	if(row_count > 0)
	{
		new string[255];
		format(string, sizeof(string), "� ��� ���� ����� ������ [%d].", row_count);
		SendClientMessage(playerid, 0x3366CCFF, string);
	}
}

stock ShowPlayerPost(playerid)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `pendings` WHERE `PlayerName` = '%s' ORDER BY `PendingID` DESC", PlayerInfo[playerid][Name]);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	q_result = cache_save();
	cache_unset_active();

	new listitems[2048] = "�������\t����������";
	new string[255];
	for(new i = 0; i < row_count; i++)
	{
		cache_set_active(q_result);
		new reward[RewardInfo];
		cache_get_value_name_int(i, "ItemID", reward[ItemID]);
		cache_get_value_name_int(i, "Count", reward[ItemsCount]);
		cache_unset_active();

		new item[BaseItem];
		item = GetItem(reward[ItemID]);
		format(string, sizeof(string), "\n{%s}%s\t{ffffff}%d", GetGradeColor(item[Grade]), item[Name], reward[ItemsCount]);
		strcat(listitems, string);
	}
	cache_delete(q_result);
	
	if(row_count == 0)
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "����� ����� ���.", "�������", "");
	else
		ShowPlayerDialog(playerid, 900, DIALOG_STYLE_TABLIST_HEADERS, "�����", listitems, "��������", "�������");
}

stock ClaimMail(playerid, num)
{
	if(IsInventoryFull(playerid))
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����", "��������� �����.", "�������", "");
		return;
	}

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `pendings` WHERE `PlayerName` = '%s' ORDER BY `PendingID` DESC", PlayerInfo[playerid][Name]);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count < num)
	{
		print("Cannot claim mail.");
		return;
	}

	new reward[RewardInfo];
	new p_id = -1;
	cache_get_value_name_int(num, "ItemID", reward[ItemID]);
	cache_get_value_name_int(num, "Count", reward[ItemsCount]);
	cache_get_value_name_int(num, "PendingID", p_id);
	cache_delete(q_result);
	if(IsEquip(reward[ItemID]))
		AddEquip(playerid, reward[ItemID], MOD_CLEAR);
	else
		AddItem(playerid, reward[ItemID], reward[ItemsCount]);

	if(p_id == -1) return;
	new s_query[255];
	format(s_query, sizeof(s_query), "DELETE FROM `pendings` WHERE `PendingID` = '%d'", p_id);
	new Cache:result = mysql_query(sql_handle, s_query);
	cache_delete(result);

	SendClientMessage(playerid, COLOR_GREEN, "�������� ��������.");
}

stock UpdateTourParticipants()
{
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
		Tournament[ParticipantsIDs][i] = -1;

	if(Tournament[Tour] == 1)
	{
		new query[255];
		format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` <> 'Admin' LIMIT %d", MAX_PARTICIPANTS);
		new Cache:q_result = mysql_query(sql_handle, query);

		new row_count = 0;
		cache_get_row_count(row_count);
		if(row_count <= 0)
		{
			print("Cannot get participants.");
			return;
		}

		q_result = cache_save();
		cache_unset_active();

		for(new i = 0; i < row_count; i++)
		{
			new id = -1;
			cache_set_active(q_result);
			cache_get_value_name_int(i, "ID", id);
			cache_unset_active();

			if(id == -1) continue;
			Tournament[ParticipantsIDs][i] = id;
		}

		TourParticipantsCount = MAX_PARTICIPANTS;
		cache_delete(q_result);
	}
	else
	{
		new p_count = MAX_PARTICIPANTS - (MAX_OWNERS * 2 * (Tournament[Tour]-1));
		new query[255] = "SELECT * FROM `accounts` WHERE `admin` = '0'";
		new Cache:q_result = mysql_query(sql_handle, query);

		new row_count = 0;
		cache_get_row_count(row_count);
		q_result = cache_save();
		cache_unset_active();

		new idx = 0;
		for(new i = 0; i < row_count; i++)
		{
			cache_set_active(q_result);
			new owner[255];
			cache_get_value_name(i, "login", owner);
			cache_unset_active();
			new owner_parts = p_count / row_count;
			format(query, sizeof(query), "SELECT * FROM `tournament_tab` WHERE `Owner` = '%s' ORDER BY `Score` DESC LIMIT %d", owner, owner_parts);
			new Cache:result = mysql_query(sql_handle, query);
			
			new rows = 0;
			cache_get_row_count(rows);
			if(rows <= 0)
			{
				cache_delete(result);
				continue;
			}

			result = cache_save();
			cache_unset_active();

			for(new j = 0; j < rows; j++)
			{
				new id = -1;
				cache_set_active(result);
				cache_get_value_name_int(j, "ID", id);
				cache_unset_active();
				if(id == -1) continue;
				if(idx >= p_count) break;
				Tournament[ParticipantsIDs][idx] = id;
				idx++;
			}
			
			cache_delete(result);
		}

		TourParticipantsCount = p_count;
		cache_delete(q_result);
	}
	
	SaveTournamentInfo();
}

stock UpdateTournamentTable()
{
	new query[255] = "DELETE FROM `tournament_tab` WHERE 1";
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) break;
		
		format(query, sizeof(query), "INSERT INTO `tournament_tab`(`ID`, `Name`, `Score`, `Owner`) VALUES ('%d','%s','%d','%s')",
			PlayerInfo[id][ID], PlayerInfo[id][Name], PvpInfo[i][Score], PlayerInfo[id][Owner]
		);
		new Cache:q_res = mysql_query(sql_handle, query);
		cache_delete(q_res);
	}
}

stock FillTourPlayers()
{
	new i, j;
	for(i = 0, j = 0; i < MAX_PLAYERS && j < MAX_OWNERS; i++)
	{
		if(IsPlayerInRangeOfPoint(i,3.0,204.7617,-1831.6539,4.1772) && IsTourParticipant(PlayerInfo[i][ID]))
		{
			TourPlayers[j] = i;
			j++;
		}
	}

	if(j == MAX_OWNERS) return true;
	return false;
}

stock IsAnyPlayersInRangeOfPoint(max_count, Float:range, Float:x, Float:y, Float:z)
{
	new count = 0;
	for(new i = 0; i < MAX_PLAYERS && count < max_count; i++)
		if(IsPlayerInRangeOfPoint(i, range, x, y, z)) count++;

	if(count >= max_count) return true;
	return false;
}

stock GetRateDifference(tour, pos)
{
	new rate = 0;
	switch(tour)
	{
		case 1:
		{
			switch(pos)
			{
				case 1: rate = 30;
				case 2: rate = 27;
				case 3: rate = 24;
				case 4: rate = 21;
				case 5: rate = 16;
				case 6: rate = 13;
				case 7: rate = 10;
				case 8: rate = 7;
				case 9: rate = 5;
				case 10: rate = 2;
				case 11: rate = -2;
				case 12: rate = -5;
				case 13: rate = -7;
				case 14: rate = -10;
				case 15: rate = -13;
				case 16: rate = -16;
				case 17: rate = -21;
				case 18: rate = -24;
				case 19: rate = -27;
				case 20: rate = -30;
			}
		}
		case 2:
		{
			switch(pos)
			{
				case 1: rate = 36;
				case 2: rate = 32;
				case 3: rate = 28;
				case 4: rate = 25;
				case 5: rate = 22;
				case 6: rate = 18;
				case 7: rate = 12;
				case 8: rate = 6;
				case 9: rate = -2;
				case 10: rate = -4;
				case 11: rate = -6;
				case 12: rate = -9;
				case 13: rate = -12;
				case 14: rate = -15;
				case 15: rate = -18;
				case 16: rate = -22;
			}
		}
		case 3:
		{
			switch(pos)
			{
				case 1: rate = 43;
				case 2: rate = 40;
				case 3: rate = 36;
				case 4: rate = 30;
				case 5: rate = 24;
				case 6: rate = 16;
				case 7: rate = 7;
				case 8: rate = -3;
				case 9: rate = -5;
				case 10: rate = -8;
				case 11: rate = -12;
				case 12: rate = -16;
			}
		}
		case 4:
		{
			switch(pos)
			{
				case 1: rate = 51;
				case 2: rate = 46;
				case 3: rate = 40;
				case 4: rate = 32;
				case 5: rate = 20;
				case 6: rate = 8;
				case 7: rate = -4;
				case 8: rate = -10;
			}
		}
		case 5:
		{
			switch(pos)
			{
				case 1: rate = 65;
				case 2: rate = 45;
				case 3: rate = 25;
				case 4: rate = 0;
			}
		}
	}
	return rate;
}

stock SetPvpTableVisibility(playerid, bool:value)
{
	if(value)
	{
		PlayerTextDrawShow(playerid, PvpPanelBox[playerid]);
		PlayerTextDrawShow(playerid, PvpPanelHeader[playerid]);
		PlayerTextDrawShow(playerid, PvpPanelTimer[playerid]);
		PlayerTextDrawShow(playerid, PvpPanelDelim[playerid]);
		for(new i = 0; i < MAX_PVP_PANEL_ITEMS; i++)
		{
			PlayerTextDrawSetStringRus(playerid, PvpPanelNameLabels[playerid][i], " ");
			PlayerTextDrawSetStringRus(playerid, PvpPanelScoreLabels[playerid][i], " ");
			PlayerTextDrawShow(playerid, PvpPanelNameLabels[playerid][i]);
			PlayerTextDrawShow(playerid, PvpPanelScoreLabels[playerid][i]);
		}
		PlayerTextDrawColor(playerid, PvpPanelMyName[playerid], HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
		PlayerTextDrawShow(playerid, PvpPanelMyName[playerid]);
		PlayerTextDrawShow(playerid, PvpPanelMyScore[playerid]);
	}
	else
	{
		PlayerTextDrawHide(playerid, PvpPanelBox[playerid]);
		PlayerTextDrawHide(playerid, PvpPanelHeader[playerid]);
		PlayerTextDrawHide(playerid, PvpPanelTimer[playerid]);
		PlayerTextDrawHide(playerid, PvpPanelDelim[playerid]);
		for(new i = 0; i < MAX_PVP_PANEL_ITEMS; i++)
		{
			PlayerTextDrawHide(playerid, PvpPanelNameLabels[playerid][i]);
			PlayerTextDrawHide(playerid, PvpPanelScoreLabels[playerid][i]);
		}
		PlayerTextDrawHide(playerid, PvpPanelMyName[playerid]);
		PlayerTextDrawHide(playerid, PvpPanelMyScore[playerid]);
	}
}

stock OpenLockbox(playerid, lockboxid)
{
	new chance = random(10001);
	new itemid = -1;
	new count = 0;
	new rank = PlayerInfo[playerid][Rank];
	switch(lockboxid)
	{
		case 202:
		{
			switch(chance)
			{
				case 0..1299: { itemid = 196; count = 2; }
				case 1300..2599: { itemid = 197; count = 2; }
				case 2600..3899: { itemid = 198; count = 2; }
				case 3900..5199: { itemid = 199; count = 2; }
				case 5200..6499: { itemid = 200; count = 2; }
				case 6500..7799: { itemid = 201; count = 2; }
				case 7800..8399: { itemid = 191; count = 1; }
				case 8400..8699: { itemid = 195; count = 1; }
				case 8700..9099: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_WEAPON, GRADE_N); count = 1; }
				case 9100..9499: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_ARMOR, GRADE_N); count = 1; }
				case 9500..9699: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_WEAPON, GRADE_B); count = 1; }
				case 9700..9899: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_ARMOR, GRADE_B); count = 1; }
				case 9900..9989: { itemid = 192; count = 1; }
				default: { itemid = 193; count = 1; }
			}
		}
		case 203:
		{
			switch(chance)
			{
				case 0..1299: { itemid = 196; count = 5; }
				case 1300..2599: { itemid = 197; count = 5; }
				case 2600..3899: { itemid = 198; count = 5; }
				case 3900..5199: { itemid = 199; count = 5; }
				case 5200..6499: { itemid = 200; count = 5; }
				case 6500..7799: { itemid = 201; count = 5; }
				case 7800..8299: { itemid = 191; count = 2; }
				case 8400..8699: { itemid = 195; count = 2; }
				case 8700..9099: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_WEAPON, GRADE_N); count = 1; }
				case 9100..9499: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_ARMOR, GRADE_N); count = 1; }
				case 9500..9699: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_WEAPON, GRADE_B); count = 1; }
				case 9700..9899: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_ARMOR, GRADE_B); count = 1; }
				case 9900..9928: { itemid = 193; count = 1; }
				case 9929: { itemid = 194; count = 1; }
				default: { itemid = 192; count = 1; }
			}
		}
	}
	if(itemid == -1) return;

	if(IsEquip(itemid))
		AddEquip(playerid, itemid, MOD_CLEAR);
	else
		AddItem(playerid, itemid, count);

	new item[BaseItem];
	item = GetItem(itemid);
	new string[255];
	format(string, sizeof(string), "��������: {%s}[%s] {ffffff}x%d.", 
		GetGradeColor(item[Grade]), item[Name], count
	);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
}

stock SwitchPlayer(playerid)
{
	new listitems[1024] = "���\t�������";
	new string[255];
	new query[255];

	for(new i = 0; i < ParticipantsCount[playerid]; i++)
	{
		format(query, sizeof(query), "SELECT * FROM `players` WHERE `Name` = '%s' LIMIT 1", Participants[playerid][i]);
		new Cache:q_result = mysql_query(sql_handle, query);

		new row_count = 0;
		cache_get_row_count(row_count);
		if(row_count <= 0)
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "������ ������������� ����������. ���������� � ��������������.");
			return;
		}

		new rate;
		cache_get_value_name_int(0, "Rate", rate);
		cache_delete(q_result);

		format(string, sizeof(string), "\n{%s}%s\t%d", GetColorByRate(rate), Participants[playerid][i], rate);
		strcat(listitems, string);
	}
	ShowPlayerDialog(playerid, 103, DIALOG_STYLE_TABLIST_HEADERS, "����� ���������", listitems, "�����", "�������");
}

stock HideAllWindows(playerid)
{
	HideCharInfo(playerid);
	HideEquipInfo(playerid);
	HideItemInfo(playerid);
	HideModWindow(playerid);
}

stock HideOpenedInfoWindows(playerid)
{
	if(Windows[playerid][ItemInfo]) HideItemInfo(playerid);
	if(Windows[playerid][EquipInfo]) HideEquipInfo(playerid);
}

stock SetPlayerSkills(playerid)
{
	for(new i = 0; i < 10; i++)
	{
		if(FCNPC_IsValid(playerid))
		{
			FCNPC_SetWeaponSkillLevel(playerid, i, 1000);
			FCNPC_SetWeaponAccuracy(playerid, i, 1);
		}
		else
			SetPlayerSkillLevel(playerid, i, 1000);
	}
}

stock FindPlayerNearestTarget(npcid)
{
	if(npcid == -1) return -1;
	new targetid = -1;
	new Float:min_dist = 10000;

	for (new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) continue;
		if(npcid == id) continue;
		if(GetPlayerTeam(id) != NO_TEAM && GetPlayerTeam(npcid) == GetPlayerTeam(id))
			continue;
		
		new Float:dist;
		dist = GetDistanceBetweenPlayers(npcid, id);
		if(dist < min_dist)
		{
			min_dist = dist;
			targetid = id;
		}
	}

	return targetid;
}

stock FindPlayerTarget(npcid, bool:by_minhp = false)
{
	new targetid = -1;
	new nearest_targets[MAX_RELIABLE_TARGETS];
	new targets_count = 0;
	new Float:distances[MAX_PARTICIPANTS];
	new Float:available_dist = 0;

	for (new i = 0; i < MAX_RELIABLE_TARGETS; i++)
		nearest_targets[i] = -1;
	for (new i = 0; i < MAX_PARTICIPANTS; i++)
		distances[i] = 1000.0;

	for (new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		if(PvpInfo[i][ID] == -1) continue;
		if(npcid == PvpInfo[i][ID]) continue;
		distances[i] = GetDistanceBetweenPlayers(npcid, PvpInfo[i][ID]);
	}
	
	SortArrayAscending(distances);
	available_dist = distances[MAX_RELIABLE_TARGETS-1];

    for (new i = 0; i < MAX_PARTICIPANTS; i++) 
	{
		if(PvpInfo[i][ID] == -1) continue;
		if(PvpInfo[i][ID] == npcid || FCNPC_IsDead(PvpInfo[i][ID]))
			continue;
		if(GetPlayerTeam(PvpInfo[i][ID]) != NO_TEAM && GetPlayerTeam(npcid) == GetPlayerTeam(PvpInfo[i][ID]))
			continue;
		if(!FCNPC_IsValid(PvpInfo[i][ID]) && !IsPlayerInDynamicArea(PvpInfo[i][ID], arena_area))
			continue;
		
		new Float:dist;
		dist = GetDistanceBetweenPlayers(npcid, PvpInfo[i][ID]);
		if(dist <= available_dist)
		{
			nearest_targets[targets_count] = PvpInfo[i][ID];
			targets_count++;
		}
	}

	if(targets_count <= 0)
		targetid = FindPlayerNearestTarget(npcid);

	if(!by_minhp)
		return nearest_targets[0];

	for (new i = 0; i < MAX_RELIABLE_TARGETS; i++)
	{
		new Float:min_hp = 1001;
		if(nearest_targets[i] == -1)
			break;
		
		new Float:hp = FCNPC_GetHealth(nearest_targets[i]);
		if(hp < min_hp)
			targetid = nearest_targets[i];
	}

	return targetid;
}

stock SetPlayerTarget(playerid, target = -1)
{
	if(FCNPC_IsAiming(playerid))
		FCNPC_StopAim(playerid);
	new targetid;
	if(target == -1)
		targetid = FindPlayerTarget(playerid, true);
	else
		targetid = target;

	if(targetid == -1)
	{
		MoveAround(playerid);
		return 0;
	}

	FCNPC_AimAtPlayer(playerid, targetid, false);
	return 1;
}

stock FindBossTarget(npcid)
{
	new targetid = -1;
	new Float:min_dist = 9999;
    for (new i = 0; i < MAX_PLAYERS; i++) 
	{
		if(i == npcid) continue;
		if(IsDeath[i]) continue;
		if(!IsBossAttacker[i]) continue;
		
		new Float:dist;
		dist = GetDistanceBetweenPlayers(npcid, i);
		if(dist < min_dist)
		{
			min_dist = dist;
			targetid = i;
		}
	}

	return targetid;
}

stock SetBossTarget(playerid)
{
	if(!FCNPC_IsValid(playerid))
		return; 
	if(FCNPC_IsAiming(playerid))
		FCNPC_StopAim(playerid);
	new targetid = FindBossTarget(playerid);

	if(targetid == -1)
	{
		MoveAround(playerid);
		return;
	}

	if(!FCNPC_IsAiming(playerid))
		FCNPC_AimAtPlayer(playerid, targetid, false);
	if(!FCNPC_IsMoving(playerid))
		FCNPC_GoToPlayer(playerid, targetid);
	print("Target setted.");
	return;
}

stock IsNPCCloseToAnyPlayer(npcid)
{
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) continue;
		if(id == npcid) continue;

		if(GetDistanceBetweenPlayers(id, npcid) < 2) 
			return true;
	}
	
	return false;
}

stock MoveAround(playerid, bool:is_evading = false)
{
	if(!FCNPC_IsValid(playerid) || FCNPC_IsDead(playerid))
		return;
		
	new Float:x_offset = -20 + random(40);
	new Float:y_offset = -20 + random(40);
	new Float:x, Float:y, Float:z;

	FCNPC_GetPosition(playerid, x, y, z);
	
	while(x + x_offset < -2387 || x + x_offset > -2313)
		x_offset = -20 + random(40);
	while(y + y_offset < -1668 || y + y_offset > -1593)
		y_offset = -20 + random(40);
	
	if(is_evading)
		FCNPC_GoTo(playerid, x + x_offset, y + y_offset, z, FCNPC_MOVE_TYPE_SPRINT, FCNPC_MOVE_SPEED_SPRINT);
	else
		FCNPC_GoTo(playerid, x + x_offset, y + y_offset, z);
}

stock SortArrayDescending(Float:array[], const size = sizeof(array))
{
	for(new i = 1, j, Float:key; i < size; i++)
	{
		key = array[i];
		for(j = i - 1; j >= 0 && array[j] < key; j--)
			array[j + 1] = array[j];
		array[j + 1] = key;
	}
}

stock SortArrayAscending(Float:array[], const size = sizeof(array))
{
	for(new i = 1, j, Float:key; i < size; i++)
	{
		key = array[i];
		for(j = i - 1; j >= 0 && array[j] > key; j--)
			array[j + 1] = array[j];
		array[j + 1] = key;
	}
}

stock DestroyBoss()
{
	IsBoss[BossNPC] = false;
	FCNPC_Destroy(BossNPC);
	BossNPC = -1;

	for(new i = 0; i < MAX_PLAYERS; i++)
		IsBossAttacker[i] = false;
	BossAttackersCount = 0;
	AttackedBoss = -1;
	print("Boss destroyed.");
}

stock GetBossesList()
{
	new listitems[1024] = "����\t���������";
	new query[255] = "SELECT * FROM `bosses` ORDER BY `ID`";
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	
	if(row_count <= 0)
	{
		cache_delete(q_result);
		return listitems;
	}

	q_result = cache_save();
	cache_unset_active();

	new bossinfo[255];
	for(new i = 0; i < row_count; i++)
	{
		new bossid = -1;
		new resp_time = -1;
		cache_set_active(q_result);
		cache_get_value_name_int(i, "ID", bossid);
		cache_get_value_name_int(i, "RespawnTime", resp_time);
		cache_unset_active();

		if(bossid == -1 || resp_time == -1) continue;
		new boss[BossInfo];
		boss = GetBoss(bossid);
		if(bossid == AttackedBoss)
			format(bossinfo, sizeof(bossinfo), "\n{%s}%s\t{FFCC00}���� ����", GetGradeColor(boss[Grade]), boss[Name]);
		else if(resp_time == 0)
			format(bossinfo, sizeof(bossinfo), "\n{%s}%s\t{66CC00}����� ���������", GetGradeColor(boss[Grade]), boss[Name]);
		else
			format(bossinfo, sizeof(bossinfo), "\n{%s}%s\t{CC3333}����� ��������: %d", GetGradeColor(boss[Grade]), boss[Name], resp_time);
		strcat(listitems, bossinfo);
	}

	cache_delete(q_result);
	return listitems;
}

stock SetBossCooldown(bossid)
{
	if(bossid == -1) return;
	new resp_time;
	switch(bossid)
	{
		case 2: resp_time = 2;
		case 3: resp_time = 3;
		case 4: resp_time = 4;
		default: resp_time = 1;
	}

	new query[255];
	format(query, sizeof(query), "UPDATE `bosses` SET `RespawnTime` = '%d' WHERE `ID` = '%d' LIMIT 1", resp_time, bossid);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);
}

stock GetMaterialsSellerItemsList()
{
	new listitems[2048] = "�������\t����";
	new query[255] = "SELECT * FROM `materials_seller`";
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	
	if(row_count <= 0)
	{
		cache_delete(q_result);
		return listitems;
	}

	q_result = cache_save();
	cache_unset_active();

	new iteminfo[255];
	for(new i = 0; i < row_count; i++)
	{
		new itemid = -1;
		cache_set_active(q_result);
		cache_get_value_name_int(i, "ItemID", itemid);
		cache_unset_active();

		if(itemid == -1) continue;
		new item[BaseItem];
		item = GetItem(itemid);
		format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{66CC00}%d$", GetGradeColor(item[Grade]), item[Name], item[Price]);
		strcat(listitems, iteminfo);
	}

	cache_delete(q_result);
	return listitems;
}

stock GetWeaponSellerItemsList()
{
	new listitems[2048] = "�������\t���.����\t����";
	new query[255] = "SELECT * FROM `weapon_seller`";
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	
	if(row_count <= 0)
	{
		cache_delete(q_result);
		return listitems;
	}

	q_result = cache_save();
	cache_unset_active();

	new iteminfo[255];
	for(new i = 0; i < row_count; i++)
	{
		new itemid = -1;
		cache_set_active(q_result);
		cache_get_value_name_int(i, "ItemID", itemid);
		cache_unset_active();

		if(itemid == -1) continue;
		new item[BaseItem];
		item = GetItem(itemid);
		format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{%s}%s\t{66CC00}%d$", 
			GetGradeColor(item[Grade]), item[Name], RateColors[item[MinRank]-1], GetRankInterval(item[MinRank]), item[Price]
		);
		strcat(listitems, iteminfo);
	}

	cache_delete(q_result);
	return listitems;
}

stock GetArmorSellerItemsList()
{
	new listitems[2048] = "�������\t���.����\t����";
	new query[255] = "SELECT * FROM `armor_seller`";
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	
	if(row_count <= 0)
	{
		cache_delete(q_result);
		return listitems;
	}

	q_result = cache_save();
	cache_unset_active();

	new iteminfo[255];
	for(new i = 0; i < row_count; i++)
	{
		new itemid = -1;
		cache_set_active(q_result);
		cache_get_value_name_int(i, "ItemID", itemid);
		cache_unset_active();

		if(itemid == -1) continue;
		new item[BaseItem];
		item = GetItem(itemid);
		format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{%s}%s\t{66CC00}%d$", 
			GetGradeColor(item[Grade]), item[Name], RateColors[item[MinRank]-1], GetRankInterval(item[MinRank]), item[Price]
		);
		strcat(listitems, iteminfo);
	}

	cache_delete(q_result);
	return listitems;
}

stock SafeDestroyPickup(pickupid)
{
	if(	pickupid <= 0 || 
		pickupid == home_enter ||
		pickupid == home_quit ||
		pickupid == boss_tp ||
		pickupid == arena_tp)
		return;
	DestroyPickup(pickupid);
}

stock ResetLoot()
{
	for(new i = 0; i < MAX_LOOT; i++)
	{
		if(BossLootPickups[i] > 0)
		{
			SafeDestroyPickup(BossLootPickups[i]);
			BossLootPickups[i] = 0;
		}
		BossLootItems[i][ItemID] = -1;
		BossLootItems[i][Count] = 0;
	}
}

stock RollBossLoot()
{
	if(AttackedBoss == -1 || !FCNPC_IsValid(BossNPC)) return;
	new loot_mult = 4;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsBossAttacker[i]) continue;
		if(HasItem(i, 185, 1))
		{
			loot_mult /= 2;
			break;
		}
	}

	new iterations = random(MAX_LOOT / loot_mult) + MAX_LOOT / loot_mult + 1;
	for(new i = 0; i < iterations; i++)
	{
		new loot[LootInfo];
		loot = RollBossLootItem(AttackedBoss);
		if(loot[ItemID] == -1) continue;

		BossLootItems[i][ItemID] = loot[ItemID];
		BossLootItems[i][Count] = loot[Count];

		new Float:x, Float:y, Float:z;
		FCNPC_GetPosition(BossNPC, x, y, z);
		BossLootPickups[i] = CreatePickup(19055, 4, x + random(10), y + random(10), z, 0);
	}
}

stock RollBossLootItem(bossid)
{
	new chance = random(10001);
	new itemid = -1;
	new count = 1;
	switch(bossid)
	{
		case 0:
		{
			switch(chance)
			{
				case 0..199: itemid = GetRandomEquip(1, 1);
				case 200..499: itemid = GetRandomAccessory(0);
				case 500..4999: itemid = 195;
				default: itemid = GetRandomBooster();
			}
		}
		case 1:
		{
			switch(chance)
			{
				case 0..199: itemid = GetRandomEquip(2, 3);
				case 200..599: itemid = GetRandomAccessory(0);
				case 600..999: itemid = 191;
				case 1000..5499: { itemid = 195; count = 2; }
				default: { itemid = GetRandomBooster(); count = 2; }
			}
		}
		case 2:
		{
			switch(chance)
			{
				case 0..199: itemid = GetRandomEquip(4, 6);
				case 200..499: itemid = GetRandomAccessory(1);
				case 500..1099: itemid = 191;
				case 1100..1299: itemid = 192;
				case 1300..5499: { itemid = GetRandomBooster(); count = 4; }
				default: { itemid = 195; count = 4; }
			}
		}
		case 3:
		{
			switch(chance)
			{
				case 0..299: itemid = GetRandomEquip(7, 8);
				case 300..399: itemid = 202;
				case 400..599: itemid = 192;
				case 600..669: itemid = GetRandomAccessory(2);
				case 670..699: itemid = 193;
				case 700..999: { itemid = 191; count = 2; }
				case 1000..5499: { itemid = GetRandomBooster(); count = 7; }
				default: { itemid = 195; count = 7; }
			}
		}
		case 4:
		{
			switch(chance)
			{
				case 0..299: itemid = GetRandomEquip(9, 9);
				case 300..399: itemid = 203;
				case 400..419: itemid = GetRandomAccessory(3);
				case 420..479: itemid = 193;
				case 480: itemid = 194;
				case 481..699: { itemid = 192; count = 2; }
				case 700..999: { itemid = 191; count = 3; }
				case 1000..5499: { itemid = GetRandomBooster(); count = 14; }
				default: { itemid = 195; count = 14; }
			}
		}
	}

	new loot[LootInfo];
	loot[ItemID] = itemid;
	loot[Count] = count;
	return loot;
}

stock GetRandomEquip(minrank, maxrank, eq_type = RND_EQUIP_TYPE_RANDOM, grade = RND_EQUIP_GRADE_RANDOM)
{
	new rank = minrank + random(maxrank-minrank+1) - 1;
	new type = eq_type == RND_EQUIP_TYPE_RANDOM ? random(2) : eq_type;
	new baseid = type == 0 ? 1 : 82;

	if(type == 0 && rank == 5)
	{
		rank += random(2);
		return baseid + rank * 8 + (grade == RND_EQUIP_GRADE_RANDOM ? random(8) : grade-1);
	}
	if(type == 0 && rank > 5)
		return baseid + (rank+1) * 8 + (grade == RND_EQUIP_GRADE_RANDOM ? random(8) : grade-1);
	return baseid + rank * 8 + (grade == RND_EQUIP_GRADE_RANDOM ? random(8) : grade-1);
}

stock GetRandomAccessory(type)
{
	return 154 + type * 7 + random(7);
}

stock GetRandomBooster()
{
	return 196 + random(6);
}

stock DebugLogInt(msg[], variable)
{
	new string[255];
	format(string, sizeof(string), "%s [%d].", msg, variable);
	print(string);
}

stock DebugLogFloat(msg[], Float:variable)
{
	new string[255];
	format(string, sizeof(string), "%s [%.3f].", msg, variable);
	print(string);
}

stock UpdateHPBar(playerid)
{
	if(FCNPC_IsValid(playerid)) return;

	new Float:hp;
	new Float:max_hp;
	hp = GetPlayerHP(playerid);
	max_hp = GetPlayerMaxHP(playerid);
	new percents = floatround(floatmul(floatdiv(hp, max_hp), 100));
	new string[64];
	format(string, sizeof(string), "%d%% %d/%d", percents, floatround(hp), floatround(max_hp));
	PlayerTextDrawSetStringRus(playerid, HPBar[playerid], string);
	if(IsInventoryOpen[playerid])
	{
		format(string, sizeof(string), "HP: %.0f/%.0f", GetPlayerHP(playerid), GetPlayerMaxHP(playerid));
		PlayerTextDrawSetStringRus(playerid, ChrInfMaxHP[playerid], string);
	}
}

stock UpdatePlayerRank(playerid)
{
	new string[255];
	new new_rank = GetRankByRate(PlayerInfo[playerid][Rate]);

	if(new_rank > PlayerInfo[playerid][Rank])
	{
		format(string, sizeof(string), "���� ������� - %s.", GetRateInterval(PlayerInfo[playerid][Rate]));
		SendClientMessage(playerid, COLOR_GREEN, string);
	}
	else if(new_rank < PlayerInfo[playerid][Rank])
	{
		format(string, sizeof(string), "���� ������� - %s.", GetRateInterval(PlayerInfo[playerid][Rate]));
		SendClientMessage(playerid, COLOR_RED, string);
	}

	PlayerInfo[playerid][Rank] = new_rank;
	if(new_rank > PlayerInfo[playerid][MaxRank])
		PlayerInfo[playerid][MaxRank] = new_rank;
	SetPlayerColor(playerid, IsTourStarted ? HexTeamColors[PlayerInfo[playerid][TeamColor]][0] : HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
	UpdatePlayerStats(playerid);
}

stock UpdatePlayerSkin(playerid)
{
	if(IsBoss[playerid])
	{
		SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
		return;
	}

	switch(PlayerInfo[playerid][ArmorSlotID])
	{
		case 81: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 78 : 131;
		case 82..89: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 22 : 13;
		case 90..97: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 6 : 41;
		case 98..105: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 167 : 205;
		case 106..113: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 70 : 219;
		case 114..121: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 310 : 309;
		case 122..129: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 147 : 141;
		case 130..137: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 127 : 150;
		case 138..145: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 126 : 93;
		case 146..153: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 294 : 214;
		default: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? DEFAULT_SKIN_MALE : DEFAULT_SKIN_FEMALE;
	}
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
}

stock UpdatePlayerWeapon(playerid)
{
	if(IsBoss[playerid])
	{
		FCNPC_SetWeapon(playerid, PlayerInfo[playerid][WeaponSlotID]);
		FCNPC_SetAmmo(playerid, 10000);
		return;
	}

	new weaponid;
	switch(PlayerInfo[playerid][WeaponSlotID])
	{
		case 9..16: weaponid = 24;
		case 17..24: weaponid = 28;
		case 25..32: weaponid = 32;
		case 33..40: weaponid = 29;
		case 41..48: weaponid = 30;
		case 49..56: weaponid = 31;
		case 57..64: weaponid = 25;
		case 65..72: weaponid = 27;
		case 73..80: weaponid = 26;
		default: weaponid = 22;
	}

	ResetPlayerWeapons(playerid);
	if(FCNPC_IsValid(playerid))
	{
		FCNPC_SetWeapon(playerid, weaponid);
		FCNPC_SetAmmo(playerid, 999999);
	}
	else
		GivePlayerWeapon(playerid, weaponid, 999999);
}

stock UpdatePlayerStats(playerid)
{
	new weapon_damage[2];
	new default_damage[2];
	default_damage = GetWeaponBaseDamage(PlayerInfo[playerid][WeaponSlotID]);
	weapon_damage = GetWeaponModifiedDamage(default_damage, GetModifierLevel(PlayerInfo[playerid][WeaponMod], MOD_DAMAGE));
	PlayerInfo[playerid][DamageMin] = weapon_damage[0];
	PlayerInfo[playerid][DamageMax] = weapon_damage[1];
	
	new armor_defense;
	new default_defense;
	default_defense = GetArmorBaseDefense(PlayerInfo[playerid][ArmorSlotID]);
	armor_defense = GetArmorModifiedDefense(default_defense, GetModifierLevel(PlayerInfo[playerid][ArmorMod], MOD_DEFENSE));
	PlayerInfo[playerid][Defense] = armor_defense;

	PlayerInfo[playerid][Accuracy] = DEFAULT_ACCURACY + GetPlayerPropValue(playerid, PROPERTY_ACCURACY) + PlayerInfo[playerid][Rank] * 10;
	PlayerInfo[playerid][Dodge] = DEFAULT_DODGE + GetPlayerPropValue(playerid, PROPERTY_DODGE) + PlayerInfo[playerid][Rank] * 10;
	PlayerInfo[playerid][Crit] = DEFAULT_CRIT + GetPlayerPropValue(playerid, PROPERTY_CRIT) + PlayerInfo[playerid][Rank] * 2;

	new damage_multiplier = 100;
	new defense_multiplier = 100;

	damage_multiplier += GetPlayerPropValue(playerid, PROPERTY_DAMAGE);
	defense_multiplier += GetPlayerPropValue(playerid, PROPERTY_DEFENSE);

	PlayerInfo[playerid][DamageMin] = (PlayerInfo[playerid][DamageMin] * damage_multiplier) / 100;
	PlayerInfo[playerid][DamageMax] = (PlayerInfo[playerid][DamageMax] * damage_multiplier) / 100;
	PlayerInfo[playerid][Defense] = (PlayerInfo[playerid][Defense] * defense_multiplier) / 100;

	UpdatePlayerMaxHP(playerid);
	new hp_multiplier = 100 + GetPlayerPropValue(playerid, PROPERTY_HP);
	new Float:new_max_hp = floatmul(MaxHP[playerid], floatdiv(hp_multiplier, 100));
	SetPlayerMaxHP(playerid, new_max_hp, true);

	if(IsInventoryOpen[playerid] && !FCNPC_IsValid(playerid))
		UpdatePlayerStatsVisual(playerid);
}

stock GetPlayerPropValue(playerid, prop)
{
	new value = 0;

	new mod_value = 0;
	switch(prop)
	{
		case PROPERTY_ACCURACY:
			mod_value += GetModifierStatByLevel(PlayerInfo[playerid][WeaponMod], GetModifierLevel(PlayerInfo[playerid][WeaponMod], MOD_ACCURACY));
		case PROPERTY_DODGE:
			mod_value += GetModifierStatByLevel(PlayerInfo[playerid][ArmorMod], GetModifierLevel(PlayerInfo[playerid][ArmorMod], MOD_DODGE));
	}
	value += mod_value;

	new weapon[BaseItem];
	weapon = GetItem(PlayerInfo[playerid][WeaponSlotID]);
	for(new i = 0; i < MAX_PROPERTIES; i++)
	{
		if(weapon[Property][i] == prop)
			value += weapon[PropertyVal][i];
	}

	new armor[BaseItem];
	armor = GetItem(PlayerInfo[playerid][ArmorSlotID]);
	for(new i = 0; i < MAX_PROPERTIES; i++)
	{
		if(armor[Property][i] == prop)
			value += armor[PropertyVal][i];
	}

	if(PlayerInfo[playerid][AccSlot1ID] != -1)
	{
		new acc1[BaseItem];
		acc1 = GetItem(PlayerInfo[playerid][AccSlot1ID]);
		for(new i = 0; i < MAX_PROPERTIES; i++)
		{
			if(acc1[Property][i] == prop)
				value += acc1[PropertyVal][i];
		}
	}
	
	if(PlayerInfo[playerid][AccSlot2ID] != -1)
	{
		new acc2[BaseItem];
		acc2 = GetItem(PlayerInfo[playerid][AccSlot2ID]);
		for(new i = 0; i < MAX_PROPERTIES; i++)
		{
			if(acc2[Property][i] == prop)
				value += acc2[PropertyVal][i];
		}
	}

	if(prop == PROPERTY_DAMAGE && HasItem(playerid, 183, 1))
		value += 5;
	if(prop == PROPERTY_DEFENSE && HasItem(playerid, 184, 1))
		value += 5;
	
	return value;
}

stock UndressEquip(playerid, type)
{
	switch(type)
	{
		case ITEMTYPE_WEAPON:
		{
			if(PlayerInfo[playerid][WeaponSlotID] == 0) return;
			AddEquip(playerid, PlayerInfo[playerid][WeaponSlotID], PlayerInfo[playerid][WeaponMod]);
			PlayerInfo[playerid][WeaponSlotID] = 0;
			PlayerInfo[playerid][WeaponMod] = MOD_CLEAR;
			UpdatePlayerWeapon(playerid);
		}
		case ITEMTYPE_ARMOR:
		{
			if(PlayerInfo[playerid][ArmorSlotID] == 81) return;
			AddEquip(playerid, PlayerInfo[playerid][ArmorSlotID], PlayerInfo[playerid][ArmorMod]);
			PlayerInfo[playerid][ArmorSlotID] = 81;
			PlayerInfo[playerid][ArmorMod] = MOD_CLEAR;
			UpdatePlayerSkin(playerid);
		}
		case ITEMTYPE_ACCESSORY:
		{
			if(PlayerInfo[playerid][AccSlot1ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][AccSlot1ID], MOD_CLEAR);
				PlayerInfo[playerid][AccSlot1ID] = -1;
			}
			else if(PlayerInfo[playerid][AccSlot2ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][AccSlot2ID], MOD_CLEAR);
				PlayerInfo[playerid][AccSlot2ID] = -1;
			}
			else return;
		}
		default: return;
	}

	UpdatePlayerStats(playerid);

	if(IsInventoryOpen[playerid])
		UpdateEquipSlots(playerid);
}

stock EquipItem(playerid, type, slot)
{
	new itemid = PlayerInventory[playerid][slot][ID];
	if(itemid == -1 || !IsEquip(itemid)) return;

	new mod[MAX_MOD];
	for(new i = 0; i < MAX_MOD; i++)
		mod[i] = PlayerInventory[playerid][slot][Mod][i];

	DeleteItem(playerid, slot);

	switch(type)
	{
		case ITEMTYPE_WEAPON:
		{
			if(PlayerInfo[playerid][WeaponSlotID] != 0)
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
			}
			PlayerInfo[playerid][WeaponSlotID] = itemid;
			PlayerInfo[playerid][WeaponMod] = mod;
			UpdatePlayerWeapon(playerid);
		}
		case ITEMTYPE_ARMOR:
		{
			if(PlayerInfo[playerid][ArmorSlotID] != 81)
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
			}
			PlayerInfo[playerid][ArmorSlotID] = itemid;
			PlayerInfo[playerid][ArmorMod] = mod;
			UpdatePlayerSkin(playerid);
		}
		case ITEMTYPE_ACCESSORY:
		{
			if(PlayerInfo[playerid][AccSlot1ID] == -1)
				PlayerInfo[playerid][AccSlot1ID] = itemid;
			else if(PlayerInfo[playerid][AccSlot2ID] == -1)
				PlayerInfo[playerid][AccSlot2ID] = itemid;
			else
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
				PlayerInfo[playerid][AccSlot1ID] = itemid;
			}
		}
		default: return;
	}

	UpdatePlayerStats(playerid);

	if(IsInventoryOpen[playerid])
		UpdateEquipSlots(playerid);
}

stock IsInvSlotEmpty(playerid, slotid)
{
	return PlayerInventory[playerid][slotid][ID] == -1;
}

stock UpdateEquipSlots(playerid)
{
	PlayerTextDrawHide(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAccSlot1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAccSlot2[playerid]);

	PlayerTextDrawBackgroundColor(playerid, ChrInfWeaponSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfArmorSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccSlot1[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccSlot2[playerid], -1061109505);

	if(PlayerInfo[playerid][WeaponSlotID] == 0)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfWeaponSlot[playerid], 346);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfWeaponSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	}
	else
	{
		new weapon[BaseItem];
		weapon = GetItem(PlayerInfo[playerid][WeaponSlotID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfWeaponSlot[playerid], weapon[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfWeaponSlot[playerid], weapon[ModelRotX], weapon[ModelRotY], weapon[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfWeaponSlot[playerid], HexGradeColors[weapon[Grade]-1][0]);
	}

	if(PlayerInfo[playerid][ArmorSlotID] == 81)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfArmorSlot[playerid], 1275);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfArmorSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	}
	else
	{
		new armor[BaseItem];
		armor = GetItem(PlayerInfo[playerid][ArmorSlotID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfArmorSlot[playerid], armor[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfArmorSlot[playerid], armor[ModelRotX], armor[ModelRotY], armor[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfArmorSlot[playerid], HexGradeColors[armor[Grade]-1][0]);
	}

	if(PlayerInfo[playerid][AccSlot1ID] == -1)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfAccSlot1[playerid], 954);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfAccSlot1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	}
	else
	{
		new acc1[BaseItem];
		acc1 = GetItem(PlayerInfo[playerid][AccSlot1ID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfAccSlot1[playerid], acc1[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfAccSlot1[playerid], acc1[ModelRotX], acc1[ModelRotY], acc1[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfAccSlot1[playerid], HexGradeColors[acc1[Grade]-1][0]);
	}

	if(PlayerInfo[playerid][AccSlot2ID] == -1)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfAccSlot2[playerid], 954);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfAccSlot2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	}
	else
	{
		new acc2[BaseItem];
		acc2 = GetItem(PlayerInfo[playerid][AccSlot2ID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfAccSlot2[playerid], acc2[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfAccSlot2[playerid], acc2[ModelRotX], acc2[ModelRotY], acc2[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfAccSlot2[playerid], HexGradeColors[acc2[Grade]-1][0]);
	}

	PlayerTextDrawShow(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAccSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAccSlot2[playerid]);
}

stock UpdateSlot(playerid, slotid)
{
	if (!IsInventoryOpen[playerid]) return;

    PlayerTextDrawHide(playerid, ChrInfInvSlot[playerid][slotid]);
    PlayerTextDrawHide(playerid, ChrInfInvSlotCount[playerid][slotid]);

	PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][slotid], -1061109505);
	if(IsInvSlotEmpty(playerid, slotid))
	{
		PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][slotid], 0.0, 0.0, 0.0, -1.0);
		PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][slotid]);
		return;
	}

	new item[BaseItem];
	item = GetItem(PlayerInventory[playerid][slotid][ID]);

	PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][slotid], HexGradeColors[item[Grade]-1][0]);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfInvSlot[playerid][slotid], item[Model]);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][slotid], item[ModelRotX], item[ModelRotY], item[ModelRotZ], 1.0);
	PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][slotid]);

	new string[16];
	if(!IsEquip(PlayerInventory[playerid][slotid][ID]))
	{
		format(string, sizeof(string), "%d", PlayerInventory[playerid][slotid][Count]);
		PlayerTextDrawSetStringRus(playerid, ChrInfInvSlotCount[playerid][slotid], string);
		PlayerTextDrawShow(playerid, ChrInfInvSlotCount[playerid][slotid]);
	}
}

stock SetSlotSelection(playerid, slotid, bool:selection)
{
	if(IsInvSlotEmpty(playerid, slotid))
		PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][slotid], selection ? 0x999999AA : -1061109505);
	else
	{
		new item[BaseItem];
		item = GetItem(PlayerInventory[playerid][slotid][ID]);
		PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][slotid], selection ? HexGradeColors[item[Grade]-1][0] - 0x00000077 : HexGradeColors[item[Grade]-1][0]);
	}

	PlayerTextDrawHide(playerid, ChrInfInvSlot[playerid][slotid]);
	PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][slotid]);
}

stock UpdateInventory(playerid)
{
	if(IsInventoryOpen[playerid])
	{
		for (new i = 0; i < MAX_SLOTS; i++) 
		{
			PlayerTextDrawHide(playerid, ChrInfInvSlot[playerid][i]);
			PlayerTextDrawHide(playerid, ChrInfInvSlotCount[playerid][i]);
		}
	}

	for (new i = 0; i < MAX_SLOTS; i++) 
	{
		PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][i], -1061109505);
		if(PlayerInventory[playerid][i][ID] == -1)
		{
			PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][i], 0.0, 0.0, 0.0, -1.0);
			PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][i]);
			continue;
		}

		new item[BaseItem];
		item = GetItem(PlayerInventory[playerid][i][ID]);

		PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][i], HexGradeColors[item[Grade]-1][0]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfInvSlot[playerid][i], item[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][i], item[ModelRotX], item[ModelRotY], item[ModelRotZ], 1.0);
		PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][i]);

		if(!IsEquip(PlayerInventory[playerid][i][ID]))
		{
			new string[16];
			format(string, sizeof(string), "%d", PlayerInventory[playerid][i][Count]);
			PlayerTextDrawSetStringRus(playerid, ChrInfInvSlotCount[playerid][i], string);
			PlayerTextDrawShow(playerid, ChrInfInvSlotCount[playerid][i]);
		}
	}
}

stock GetInvEmptySlotID(playerid)
{
	for(new i = 0; i < MAX_SLOTS; i++)
		if(PlayerInventory[playerid][i][ID] == -1)
			return i;
	
	return -1;
}

stock IsInventoryFull(playerid)
{
	return GetInvEmptySlotID(playerid) == -1;
}

stock SaveInventorySlot(playerid, slot)
{
	new name[255];
	GetPlayerName(playerid, name, sizeof(name));

	new query[255];
	format(query, sizeof(query), "UPDATE `inventories` SET `ItemID` = '%d', `Count` = '%d', `SlotMod` = '%s' WHERE `PlayerName` = '%s' AND `SlotID` = '%d' LIMIT 1", 
		PlayerInventory[playerid][slot][ID], PlayerInventory[playerid][slot][Count], ArrayToString(PlayerInventory[playerid][slot][Mod], MAX_MOD), name, slot
	);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);
}

stock AddItem(playerid, id, count = 1)
{
	new slot = -1;
	slot = FindItem(playerid, id);

	if(slot == -1)
	{
		if(IsInventoryFull(playerid)) return false;
		slot = GetInvEmptySlotID(playerid);
	}
	PlayerInventory[playerid][slot][ID] = id;
	PlayerInventory[playerid][slot][Count] += count;

	SaveInventorySlot(playerid, slot);

	if(IsInventoryOpen[playerid])
		UpdateSlot(playerid, slot);

	return true;
}

stock PendingItem(name[], id, count = 1)
{
	new sub_query[255] = "SELECT MAX(`PendingID`) AS `PendingID` FROM `pendings`";
	new Cache:sq_result = mysql_query(sql_handle, sub_query);
	new p_id = -1;
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
		p_id = 0;
	else
		cache_get_value_name_int(0, "PendingID", p_id);
	cache_delete(sq_result);
	p_id++;

	new query[255];
	format(query, sizeof(query), "INSERT INTO `pendings`(`PendingID`, `PlayerName`, `ItemID`, `Count`) VALUES ('%d','%s','%d','%d')",
		p_id, name, id, count
	);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);
}

stock AddEquip(playerid, id, mod[])
{
	if(IsInventoryFull(playerid))
		return false;
	
	new slot = GetInvEmptySlotID(playerid);
	PlayerInventory[playerid][slot][ID] = id;
	PlayerInventory[playerid][slot][Count] = 1;
	for(new i = 0; i < MAX_MOD; i++)
		PlayerInventory[playerid][slot][Mod][i] = mod[i];

	SaveInventorySlot(playerid, slot);

	if(IsInventoryOpen[playerid])
		UpdateSlot(playerid, slot);

	return true;
}

stock DeleteItem(playerid, slotid, count = 1)
{
	if(slotid == -1) return false;

	PlayerInventory[playerid][slotid][Count] -= count;
	if(PlayerInventory[playerid][slotid][Count] <= 0)
	{
		for(new i = 0; i < MAX_MOD; i++)
			PlayerInventory[playerid][slotid][Mod][i] = 0;
		PlayerInventory[playerid][slotid][ID] = -1;
		PlayerInventory[playerid][slotid][Count] = 0;
	}

	if(IsInventoryOpen[playerid])
		UpdateSlot(playerid, slotid);

	SaveInventorySlot(playerid, slotid);
	return true;
}

stock SellItem(playerid, slotid, count = 1)
{
	if(slotid == -1) return false;

	new item[BaseItem];
	item = GetItem(PlayerInventory[playerid][slotid][ID]);
	new price = (item[Price] * count) / 5;

	PlayerInventory[playerid][slotid][Count] -= count;
	if(PlayerInventory[playerid][slotid][Count] <= 0)
	{
		for(new i = 0; i < MAX_MOD; i++)
			PlayerInventory[playerid][slotid][Mod][i] = 0;
		PlayerInventory[playerid][slotid][ID] = -1;
		PlayerInventory[playerid][slotid][Count] = 0;
	}

	if(IsInventoryOpen[playerid])
		UpdateSlot(playerid, slotid);

	SaveInventorySlot(playerid, slotid);

	PlayerInfo[playerid][Cash] += price;
	GivePlayerMoney(playerid, price);

	return true;
}

stock FindItem(playerid, itemid)
{
	if(IsPlayerConnected(playerid))
	{
		for(new i = 0; i < MAX_SLOTS; i++)
			if(PlayerInventory[playerid][i][ID] == itemid)
				return i;
	}
	return -1;
}

stock HasItem(playerid, id, count = 1)
{
	if(id == -1) return false;

	if(IsPlayerConnected(playerid))
	{
		for(new i = 0; i < MAX_SLOTS; i++)
			if(PlayerInventory[playerid][i][ID] == id && PlayerInventory[playerid][i][Count] >= count)
				return true;
		return false;
	}

	return HasItemOffline(playerid, id, count);
}

stock HasItemOffline(playerid, id, count = 1)
{
	if(id == -1) return false;

	new item[BaseItem];
	item = GetItem(id);

	new name[255];
	GetPlayerName(playerid, name, sizeof(name));

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `inventories` WHERE `PlayerName` = '%s' AND `ItemID` = '%d' LIMIT 1", name, id);
	new Cache:q_result = mysql_query(sql_handle, query);

	new r_count;
	cache_get_row_count(r_count);
	if(r_count <= 0)
		return false;
	
	if(IsEquip(id))
		return true;
	
	new _count;
	cache_get_value_name_int(0, "Count", _count);
	cache_delete(q_result);
	return _count >= count;
}

stock GetBoss(id)
{
	new string[255];
	new query[255];
	new boss[BossInfo];
	format(query, sizeof(query), "SELECT * FROM `bosses` WHERE `ID` = '%d' LIMIT 1", id);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count;
	cache_get_row_count(count);
	if(count <= 0)
	{
		format(string, sizeof(string), "Cannot get boss [ID = %d].", id);
		print(string);
		return boss;
	}

	boss[ID] = id;
	cache_get_value_name(0, "Name", string);
	sscanf(string, "s[255]", boss[Name]);
	cache_get_value_name_int(0, "Grade", boss[Grade]);
	cache_get_value_name_int(0, "RespawnTime", boss[RespawnTime]);
	cache_get_value_name_int(0, "DamageMin", boss[DamageMin]);
	cache_get_value_name_int(0, "DamageMax", boss[DamageMax]);
	cache_get_value_name_int(0, "Defense", boss[Defense]);
	cache_get_value_name_int(0, "Accuracy", boss[Accuracy]);
	cache_get_value_name_int(0, "Dodge", boss[Dodge]);
	cache_get_value_name_int(0, "HP", boss[HP]);

	cache_delete(q_result);
	return boss;
}

stock GetItem(id)
{
	new string[255];
	new query[255];
	new item[BaseItem];
	format(query, sizeof(query), "SELECT * FROM `items` WHERE `ID` = '%d' LIMIT 1", id);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count;
	cache_get_row_count(count);
	if(count <= 0)
	{
		format(string, sizeof(string), "Cannot get item [ID = %d].", id);
		print(string);
		return item;
	}

	item[ID] = id;
	cache_get_value_name(0, "Name", string);
	sscanf(string, "s[255]", item[Name]);
	cache_get_value_name_int(0, "Type", item[Type]);
	cache_get_value_name_int(0, "Grade", item[Grade]);
	cache_get_value_name_int(0, "MinRank", item[MinRank]);
	cache_get_value_name(0, "Description", string);
	sscanf(string, "s[255]", item[Description]);
	cache_get_value_name(0, "Property", string);
	sscanf(string, "a<i>[2]", item[Property]);
	cache_get_value_name(0, "PropertyVal", string);
	sscanf(string, "a<i>[2]", item[PropertyVal]);
	cache_get_value_name_int(0, "Price", item[Price]);
	cache_get_value_name_int(0, "Model", item[Model]);
	cache_get_value_name_int(0, "ModelRotX", item[ModelRotX]);
	cache_get_value_name_int(0, "ModelRotY", item[ModelRotY]);
	cache_get_value_name_int(0, "ModelRotZ", item[ModelRotZ]);

	cache_delete(q_result);
	return item;
}

stock IsModPotion(item_id)
{
	switch(item_id)
	{
		case 191..194: return true;
	}
	return false;
}

stock IsModStone(item_id)
{
	switch(item_id)
	{
		case 187..190: return true;
	}
	return false;
}

stock IsModifiableEquip(item_id)
{
	if(item_id == -1)
		return false;
	
	new item[BaseItem];
	item = GetItem(item_id);
	return item[Type] == ITEMTYPE_WEAPON || item[Type] == ITEMTYPE_ARMOR;
}

stock IsEquip(item_id)
{
	if(item_id == -1)
		return false;
	
	new item[BaseItem];
	item = GetItem(item_id);
	return item[Type] == ITEMTYPE_WEAPON || item[Type] == ITEMTYPE_ARMOR || item[Type] == ITEMTYPE_ACCESSORY;
}

stock IsLockbox(item_id)
{
	if(item_id == -1)
		return false;
	
	new item[BaseItem];
	item = GetItem(item_id);
	return item[Type] == ITEMTYPE_BOX;
}

stock IsPlayerParticipant(playerid)
{
	return IsParticipant[playerid];
}

stock bool:ModifierExists(mod[], modifier)
{
	for(new i = 0; i < MAX_MOD; i++)
		if(mod[i] == modifier) return true;
	return false;
}

stock InitBoss(bossid)
{
	new boss[BossInfo];
	boss = GetBoss(AttackedBoss);

	IsBoss[bossid] = true;
	PlayerInfo[bossid][DamageMin] = boss[DamageMin];
	PlayerInfo[bossid][DamageMax] = boss[DamageMax];
	PlayerInfo[bossid][Defense] = boss[Defense];
	PlayerInfo[bossid][Dodge] = boss[Dodge];
	PlayerInfo[bossid][Accuracy] = boss[Accuracy];
	PlayerInfo[bossid][Crit] = DEFAULT_CRIT;
	PlayerInfo[bossid][Sex] = 0;
	PlayerInfo[bossid][Skin] = BossesSkins[AttackedBoss][0];
	PlayerInfo[bossid][WeaponSlotID] = BossesWeapons[AttackedBoss][0];

	FCNPC_Spawn(bossid, PlayerInfo[bossid][Skin], -2352.9387,-1628.2875,723.5609);
	FCNPC_SetAngle(bossid, 90);
	SetPlayerMaxHP(bossid, boss[HP], false);
	SetPlayerHP(bossid, boss[HP]);
	SetPlayerSkills(bossid);

	UpdatePlayerSkin(bossid);
	UpdatePlayerWeapon(bossid);
}

stock StartBossAttack()
{
	if(AttackedBoss == -1)
		return;
	
	BossNPC = FCNPC_Create(BossesNames[AttackedBoss]);
	SetPlayerColor(BossNPC, 0x990099FF);
	ShowNPCInTabList(BossNPC); 
	FCNPC_SetInvulnerable(BossNPC, false);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsBossAttacker[i])
		{
			SetPlayerHP(i, MaxHP[i]);
			TeleportToRandomArenaPos(i);
			SendClientMessage(i, COLOR_GREEN, "� ��� ���� 2 ������, ����� ���������� �����.");
		}
	}
	InitBoss(BossNPC);
	BossAttackTimer = SetTimer("FinishBossAttack", 120000, false);
	SetBossTarget(BossNPC);
	print("Boss spawned!");
}

stock ResetWorldBounds(playerid)
{
	SetPlayerWorldBounds(playerid, 307.0, 163.0, -1774.0, -1895.0);
}

stock TeleportToRandomArenaPos(playerid)
{
	if(FCNPC_IsValid(playerid))
	{
		FCNPC_SetInterior(playerid, 0);
		FCNPC_SetPosition(playerid, -2315 - random(70), -1595 - random(75), 723.2609);
	}
	else
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerPos(playerid, -2314 - random(70), -1595 - random(75), 723.2609);
		SetPlayerWorldBounds(playerid, -2313.0295, -2390.5017, -1593.6758, -1669.8492);
	}
}

stock ConnectParticipants(playerid)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` = '%s' LIMIT 20", AccountLogin[playerid]);
	new Cache:q_result = mysql_query(sql_handle, query);

	cache_get_row_count(ParticipantsCount[playerid]);
	if(ParticipantsCount[playerid] <= 0)
		return;

	for(new i = 0; i < ParticipantsCount[playerid]; i++)
		cache_get_value_name(i, "Name", Participants[playerid][i]);

	cache_delete(q_result);
}

stock ShowItemInfo(playerid, itemid)
{
	new item[BaseItem];
	new string[255];
	item = GetItem(itemid);

	HideOpenedInfoWindows(playerid);

	PlayerTextDrawSetPreviewModel(playerid, InfItemIcon[playerid], item[Model]);
	PlayerTextDrawSetPreviewRot(playerid, InfItemIcon[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
	PlayerTextDrawBackgroundColor(playerid, InfItemIcon[playerid], HexGradeColors[item[Grade]-1][0]);
	PlayerTextDrawSetStringRus(playerid, InfItemName[playerid], item[Name]);
	PlayerTextDrawColor(playerid, InfItemName[playerid], HexGradeColors[item[Grade]-1][0]);
	PlayerTextDrawSetStringRus(playerid, InfItemType[playerid], GetItemTypeString(item[Type]));
	PlayerTextDrawSetStringRus(playerid, InfItemEffect[playerid][0], GetItemEffectString(item[Property][0], item[PropertyVal][0]));
	PlayerTextDrawSetStringRus(playerid, InfItemEffect[playerid][1], GetItemEffectString(item[Property][1], item[PropertyVal][1]));
	format(string, sizeof(string), "����: %d$", item[Price]);
	PlayerTextDrawSetStringRus(playerid, InfPrice[playerid], string);

	PlayerTextDrawShow(playerid, InfBox[playerid]);
	PlayerTextDrawShow(playerid, InfTxt1[playerid]);
	PlayerTextDrawShow(playerid, InfDelim1[playerid]);
	PlayerTextDrawShow(playerid, InfItemIcon[playerid]);
	PlayerTextDrawShow(playerid, InfItemName[playerid]);
	PlayerTextDrawShow(playerid, InfItemType[playerid]);
	PlayerTextDrawShow(playerid, InfItemEffect[playerid][0]);
	PlayerTextDrawShow(playerid, InfItemEffect[playerid][1]);
	PlayerTextDrawShow(playerid, InfDelim2[playerid]);
	PlayerTextDrawShow(playerid, InfDelim3[playerid]);
	PlayerTextDrawShow(playerid, InfPrice[playerid]);
	PlayerTextDrawShow(playerid, InfClose[playerid]);

	new desc_used_strings = strlen(item[Description]) / MAX_DESCRIPTION_SIZE + 1;
	if(desc_used_strings > 3)
		desc_used_strings = 3;
	
	for(new i = 0; i < desc_used_strings; i++)
	{
		string = "";
		strmid(string, item[Description], 0, MAX_DESCRIPTION_SIZE);
		strdel(item[Description], 0, MAX_DESCRIPTION_SIZE);
		PlayerTextDrawSetStringRus(playerid, InfDescriptionStr[playerid][i], string);
		PlayerTextDrawShow(playerid, InfDescriptionStr[playerid][i]);
	}

	Windows[playerid][ItemInfo] = true;
}

stock HideItemInfo(playerid)
{
	PlayerTextDrawHide(playerid, InfBox[playerid]);
	PlayerTextDrawHide(playerid, InfTxt1[playerid]);
	PlayerTextDrawHide(playerid, InfDelim1[playerid]);
	PlayerTextDrawHide(playerid, InfItemIcon[playerid]);
	PlayerTextDrawHide(playerid, InfItemName[playerid]);
	PlayerTextDrawHide(playerid, InfItemType[playerid]);
	PlayerTextDrawHide(playerid, InfItemEffect[playerid][0]);
	PlayerTextDrawHide(playerid, InfItemEffect[playerid][1]);
	PlayerTextDrawHide(playerid, InfDelim2[playerid]);
	PlayerTextDrawHide(playerid, InfDelim3[playerid]);
	PlayerTextDrawHide(playerid, InfPrice[playerid]);
	PlayerTextDrawHide(playerid, InfClose[playerid]);
	for(new i = 0; i < 3; i++)
		PlayerTextDrawHide(playerid, InfDescriptionStr[playerid][i]);

	Windows[playerid][ItemInfo] = false;
}

stock HideEquipInfo(playerid)
{
	PlayerTextDrawHide(playerid, EqInfBox[playerid]);
	PlayerTextDrawHide(playerid, EqInfTxt1[playerid]);
	PlayerTextDrawHide(playerid, EqInfTxt2[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim1[playerid]);
	PlayerTextDrawHide(playerid, EqInfItemIcon[playerid]);
	PlayerTextDrawHide(playerid, EqInfItemName[playerid]);
	PlayerTextDrawHide(playerid, EqInfMainStat[playerid]);
	PlayerTextDrawHide(playerid, EqInfBonusStat[playerid][0]);
	PlayerTextDrawHide(playerid, EqInfBonusStat[playerid][1]);
	PlayerTextDrawHide(playerid, EqInfDelim2[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim3[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim4[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim5[playerid]);
	PlayerTextDrawHide(playerid, EqInfPrice[playerid]);
	PlayerTextDrawHide(playerid, EqInfClose[playerid]);
	for(new i = 0; i < 4; i++)
		PlayerTextDrawHide(playerid, EqInfModStat[playerid][i]);
	for(new i = 0; i < MAX_MOD; i++)
		PlayerTextDrawHide(playerid, EqInfMod[playerid][i]);
	for(new i = 0; i < 3; i++)
		PlayerTextDrawHide(playerid, EqInfDescriptionStr[playerid][i]);

	Windows[playerid][EquipInfo] = false;
}

stock ShowEquipInfo(playerid, itemid, mod[])
{
	new item[BaseItem];
	new string[255];
	item = GetItem(itemid);

	HideOpenedInfoWindows(playerid);

	PlayerTextDrawSetPreviewModel(playerid, EqInfItemIcon[playerid], item[Model]);
	PlayerTextDrawSetPreviewRot(playerid, EqInfItemIcon[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemIcon[playerid], HexGradeColors[item[Grade]-1][0]);
	PlayerTextDrawSetStringRus(playerid, EqInfItemName[playerid], item[Name]);
	PlayerTextDrawColor(playerid, EqInfItemName[playerid], HexGradeColors[item[Grade]-1][0]);
	PlayerTextDrawSetStringRus(playerid, EqInfBonusStat[playerid][0], GetItemEffectString(item[Property][0], item[PropertyVal][0]));
	PlayerTextDrawSetStringRus(playerid, EqInfBonusStat[playerid][1], GetItemEffectString(item[Property][1], item[PropertyVal][1]));
	format(string, sizeof(string), "����: %d$", item[Price]);
	PlayerTextDrawSetStringRus(playerid, EqInfPrice[playerid], string);

	PlayerTextDrawShow(playerid, EqInfBox[playerid]);
	PlayerTextDrawShow(playerid, EqInfTxt1[playerid]);
	PlayerTextDrawShow(playerid, EqInfTxt2[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim1[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemIcon[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemName[playerid]);
	PlayerTextDrawShow(playerid, EqInfBonusStat[playerid][0]);
	PlayerTextDrawShow(playerid, EqInfBonusStat[playerid][1]);
	PlayerTextDrawShow(playerid, EqInfDelim2[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim3[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim4[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim5[playerid]);
	PlayerTextDrawShow(playerid, EqInfPrice[playerid]);
	PlayerTextDrawShow(playerid, EqInfClose[playerid]);

	for(new i = 0; i < MAX_MOD; i++)
	{
		PlayerTextDrawSetPreviewModel(playerid, EqInfMod[playerid][i], GetModModel(mod[i]));
		PlayerTextDrawSetPreviewRot(playerid, EqInfMod[playerid][i], 0.000000, 0.000000, 0.000000, 1.000000);
		PlayerTextDrawShow(playerid, EqInfMod[playerid][i]);
	}

	new modifiers[4];
	modifiers = GetModifiers(mod);
	new modifiers_count = GetModifiersCount(modifiers);
	new modifiers_effects_descs[4][255];
	modifiers_effects_descs = MapModifiersDescs(mod, modifiers, modifiers_count);
	for(new i = 0; i < 4; i++)
	{
		PlayerTextDrawSetStringRus(playerid, EqInfModStat[playerid][i], modifiers_effects_descs[i]);
		PlayerTextDrawShow(playerid, EqInfModStat[playerid][i]);
	}

	if(item[Type] == ITEMTYPE_WEAPON)
	{
		new bool:mod_exists = false;
		mod_exists = ModifierExists(mod, MOD_DAMAGE);
		PlayerTextDrawColor(playerid, EqInfMainStat[playerid], mod_exists ? 16711935 : -1);
		new damage[2];
		damage = GetWeaponBaseDamage(itemid);
		if(mod_exists)
			damage = GetWeaponModifiedDamage(damage, GetModifierLevel(mod, MOD_DAMAGE));
		format(string, sizeof(string), "����: %d-%d", damage[0], damage[1]);
	}
	else if(item[Type] == ITEMTYPE_ARMOR)
	{
		new bool:mod_exists = false;
		mod_exists = ModifierExists(mod, MOD_DEFENSE);
		PlayerTextDrawColor(playerid, EqInfMainStat[playerid], mod_exists ? 16711935 : -1);
		new defense;
		defense = GetArmorBaseDefense(itemid);
		if(mod_exists)
			defense = GetArmorModifiedDefense(defense, GetModifierLevel(mod, MOD_DEFENSE));
		format(string, sizeof(string), "������: %d", defense);
	}
	PlayerTextDrawSetStringRus(playerid, EqInfMainStat[playerid], string);
	PlayerTextDrawShow(playerid, EqInfMainStat[playerid]);

	new desc_used_strings = strlen(item[Description]) / MAX_DESCRIPTION_SIZE + 1;
	if(desc_used_strings > 3)
		desc_used_strings = 3;
	
	for(new i = 0; i < desc_used_strings; i++)
	{
		string = "";
		strmid(string, item[Description], 0, MAX_DESCRIPTION_SIZE);
		strdel(item[Description], 0, MAX_DESCRIPTION_SIZE);
		PlayerTextDrawSetStringRus(playerid, EqInfDescriptionStr[playerid][i], string);
		PlayerTextDrawShow(playerid, EqInfDescriptionStr[playerid][i]);
	}

	Windows[playerid][EquipInfo] = true;
}	

stock UpdatePlayerStatsVisual(playerid)
{
	new string[255];

	format(string, sizeof(string), "HP: %.0f/%.0f", GetPlayerHP(playerid), GetPlayerMaxHP(playerid));
	PlayerTextDrawSetStringRus(playerid, ChrInfMaxHP[playerid], string);
	format(string, sizeof(string), "%s: %d-%d", "����", PlayerInfo[playerid][DamageMin], PlayerInfo[playerid][DamageMax]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDamage[playerid], string);
	format(string, sizeof(string), "%s: %d", "������", PlayerInfo[playerid][Defense]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDefense[playerid], string);
	format(string, sizeof(string), "%s: %d", "��������", PlayerInfo[playerid][Accuracy]);
	PlayerTextDrawSetStringRus(playerid, ChrInfAccuracy[playerid], string);
	format(string, sizeof(string), "%s: %d", "���������", PlayerInfo[playerid][Dodge]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDodge[playerid], string);
}

stock ShowCharInfo(playerid)
{
	new string[255];

	format(string, sizeof(string), "%d", PlayerInfo[playerid][Rate]);
	PlayerTextDrawSetStringRus(playerid, ChrInfRate[playerid], string);
	PlayerTextDrawColor(playerid, ChrInfRate[playerid], HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
	format(string, sizeof(string), "%d", PlayerInfo[playerid][GlobalTopPosition]);
	PlayerTextDrawSetStringRus(playerid, ChrInfAllRate[playerid], string);
	PlayerTextDrawColor(playerid, ChrInfAllRate[playerid], GetHexPlaceColor(PlayerInfo[playerid][GlobalTopPosition]));
	format(string, sizeof(string), "%d", PlayerInfo[playerid][LocalTopPosition]);
	PlayerTextDrawSetStringRus(playerid, ChrInfPersonalRate[playerid], string);
	PlayerTextDrawColor(playerid, ChrInfPersonalRate[playerid], GetHexPlaceColor(PlayerInfo[playerid][LocalTopPosition]));

	UpdatePlayerStatsVisual(playerid);

	PlayerTextDrawShow(playerid, ChrInfoBox[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoHeader[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoDelim1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDelim2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDelim3[playerid]);
	PlayerTextDrawShow(playerid, ChrInfMaxHP[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDamage[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDefense[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAccuracy[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDodge[playerid]);
	PlayerTextDrawShow(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAccSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAccSlot2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfClose[playerid]);
	PlayerTextDrawShow(playerid, ChrInfText1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfText2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAllRate[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRate[playerid]);
	PlayerTextDrawShow(playerid, ChrInfPersonalRate[playerid]);
	PlayerTextDrawShow(playerid, ChrInfButUse[playerid]);
	PlayerTextDrawShow(playerid, ChrInfButInfo[playerid]);
	PlayerTextDrawShow(playerid, ChrInfButDel[playerid]);
	PlayerTextDrawShow(playerid, ChrInfButMod[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDelim4[playerid]);

	UpdateEquipSlots(playerid);
	UpdateInventory(playerid);
	
	IsInventoryOpen[playerid] = true;
	Windows[playerid][CharInfo] = true;
	SelectTextDraw(playerid,0xCCCCFF65);
}

stock HideCharInfo(playerid)
{
	PlayerTextDrawHide(playerid, ChrInfoBox[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoHeader[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoDelim1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDelim2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDelim3[playerid]);
	PlayerTextDrawHide(playerid, ChrInfMaxHP[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDamage[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDefense[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAccuracy[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDodge[playerid]);
	PlayerTextDrawHide(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAccSlot1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAccSlot2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfClose[playerid]);
	PlayerTextDrawHide(playerid, ChrInfText1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfText2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAllRate[playerid]);
	PlayerTextDrawHide(playerid, ChrInfRate[playerid]);
	PlayerTextDrawHide(playerid, ChrInfPersonalRate[playerid]);
	PlayerTextDrawHide(playerid, ChrInfButUse[playerid]);
	PlayerTextDrawHide(playerid, ChrInfButInfo[playerid]);
	PlayerTextDrawHide(playerid, ChrInfButDel[playerid]);
	PlayerTextDrawHide(playerid, ChrInfButMod[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDelim4[playerid]);

	for (new i = 0; i < MAX_SLOTS; i++)
	{
		PlayerTextDrawHide(playerid, ChrInfInvSlot[playerid][i]);
		PlayerTextDrawHide(playerid, ChrInfInvSlotCount[playerid][i]);
	}

	IsInventoryOpen[playerid] = false;
	Windows[playerid][CharInfo] = false;
}

stock ShowModWindow(playerid, itemslot = -1)
{
	Windows[playerid][Mod] = true;
	IsSlotsBlocked[playerid] = true;

	HideOpenedInfoWindows(playerid);

	PlayerTextDrawSetPreviewModel(playerid, UpgPotionSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgPotionSlot[playerid], 0, 0, 0);
	PlayerTextDrawSetPreviewModel(playerid, UpgStoneSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgStoneSlot[playerid], 0, 0, 0);
	PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], 0, 0, 0);
	PlayerTextDrawBackgroundColor(playerid, UpgStoneSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, UpgPotionSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], -1061109505);

	if(itemslot != -1)
	{
		new item[BaseItem];
		item = GetItem(PlayerInventory[playerid][itemslot][ID]);

		PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], item[Model]);
		PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
		PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], HexGradeColors[item[Grade]-1][0]);

		new mod_level = GetModLevel(PlayerInventory[playerid][itemslot][Mod]);
		new string[64];
		format(string, sizeof(string), "%d �����������", mod_level+1);
		PlayerTextDrawSetStringRus(playerid, UpgModInfo[playerid], string);
		PlayerTextDrawShow(playerid, UpgModInfo[playerid]);

		ModItemSlot[playerid] = itemslot;
	}

	PlayerTextDrawShow(playerid, UpgBox[playerid]);
	PlayerTextDrawShow(playerid, UpgTxt1[playerid]);
	PlayerTextDrawShow(playerid, UpgDelim1[playerid]);
	PlayerTextDrawShow(playerid, UpgItemSlot[playerid]);
	PlayerTextDrawShow(playerid, UpgTxt2[playerid]);
	PlayerTextDrawShow(playerid, UpgStoneSlot[playerid]);
	PlayerTextDrawShow(playerid, UpgTxt3[playerid]);
	PlayerTextDrawShow(playerid, UpgPotionSlot[playerid]);
	PlayerTextDrawShow(playerid, UpgTxt4[playerid]);
	PlayerTextDrawShow(playerid, UpgBtn[playerid]);
	PlayerTextDrawShow(playerid, UpgClose[playerid]);
}

stock HideModWindow(playerid)
{
	Windows[playerid][Mod] = false;
	IsSlotsBlocked[playerid] = false;

	ModItemSlot[playerid] = -1;
	ModPotion[playerid] = -1;
	ModStone[playerid] = -1;

	PlayerTextDrawHide(playerid, UpgBox[playerid]);
	PlayerTextDrawHide(playerid, UpgTxt1[playerid]);
	PlayerTextDrawHide(playerid, UpgDelim1[playerid]);
	PlayerTextDrawHide(playerid, UpgModInfo[playerid]);
	PlayerTextDrawHide(playerid, UpgItemSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgTxt2[playerid]);
	PlayerTextDrawHide(playerid, UpgStoneSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgTxt3[playerid]);
	PlayerTextDrawHide(playerid, UpgPotionSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgTxt4[playerid]);
	PlayerTextDrawHide(playerid, UpgBtn[playerid]);
	PlayerTextDrawHide(playerid, UpgClose[playerid]);
}

stock UpdateModWindow(playerid)
{
	PlayerTextDrawHide(playerid, UpgModInfo[playerid]);
	PlayerTextDrawHide(playerid, UpgItemSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgStoneSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgPotionSlot[playerid]);

	PlayerTextDrawSetPreviewModel(playerid, UpgPotionSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgPotionSlot[playerid], 0, 0, 0);
	PlayerTextDrawSetPreviewModel(playerid, UpgStoneSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgStoneSlot[playerid], 0, 0, 0);
	PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], 0, 0, 0);
	PlayerTextDrawBackgroundColor(playerid, UpgStoneSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, UpgPotionSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], -1061109505);

	if(ModItemSlot[playerid] != -1)
	{
		new item[BaseItem];
		item = GetItem(PlayerInventory[playerid][ModItemSlot[playerid]][ID]);

		PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], item[Model]);
		PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
		PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], HexGradeColors[item[Grade]-1][0]);

		new mod_level = GetModLevel(PlayerInventory[playerid][ModItemSlot[playerid]][Mod]);
		new string[64];
		format(string, sizeof(string), "%d �����������", mod_level+1);
		PlayerTextDrawSetStringRus(playerid, UpgModInfo[playerid], string);
		PlayerTextDrawShow(playerid, UpgModInfo[playerid]);
	}
	if(ModStone[playerid] != -1)
	{
		if(HasItem(playerid, ModStone[playerid]))
		{
			new item[BaseItem];
			item = GetItem(ModStone[playerid]);

			PlayerTextDrawSetPreviewModel(playerid, UpgStoneSlot[playerid], item[Model]);
			PlayerTextDrawSetPreviewRot(playerid, UpgStoneSlot[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
			PlayerTextDrawBackgroundColor(playerid, UpgStoneSlot[playerid], HexGradeColors[item[Grade]-1][0]);
		}
		else
			ModStone[playerid] = -1;
	}
	if(ModPotion[playerid] != -1)
	{
		if(HasItem(playerid, ModPotion[playerid]))
		{
			new item[BaseItem];
			item = GetItem(ModPotion[playerid]);

			PlayerTextDrawSetPreviewModel(playerid, UpgPotionSlot[playerid], item[Model]);
			PlayerTextDrawSetPreviewRot(playerid, UpgPotionSlot[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
			PlayerTextDrawBackgroundColor(playerid, UpgPotionSlot[playerid], HexGradeColors[item[Grade]-1][0]);
		}
		else
			ModPotion[playerid] = -1;
	}

	PlayerTextDrawShow(playerid, UpgItemSlot[playerid]);
	PlayerTextDrawShow(playerid, UpgStoneSlot[playerid]);
	PlayerTextDrawShow(playerid, UpgPotionSlot[playerid]);
}

stock UpgradeItem(playerid, itemslot, stoneid, potionid = -1)
{
	new itemid = PlayerInventory[playerid][itemslot][ID];
	new level = GetModLevel(PlayerInventory[playerid][itemslot][Mod]) + 1;
	if(level > MAX_MOD || itemid == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "������ �����������.");
		return;
	}

	new item[BaseItem];
	item = GetItem(itemid);

	new chances[4];
	chances = GetModChances(level, item[Grade], potionid);

	new stoneslot = FindItem(playerid, stoneid);
	if(stoneslot == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "������ �����������.");
		return;
	}

	DeleteItem(playerid, stoneslot, 1);

	if(potionid != -1)
	{
		new potionslot = FindItem(playerid, potionid);
		if(potionslot == -1)
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "������ �����������.");
			return;
		}

		DeleteItem(playerid, potionslot, 1);
	}

	new roll = random(10001);
	//success
	if(roll <= chances[0] || IsEasyMod[playerid])
	{
		PlayerInventory[playerid][itemslot][Mod][level-1] = GetModifierByStone(stoneid);
		if(level == MAX_MOD)
		{
			ModItemSlot[playerid] = -1;
			ModStone[playerid] = -1;
			ModPotion[playerid] = -1;
		}
		if(level >= 5)
		{
			new cng_string[255];
			new name[255];
			GetPlayerName(playerid, name, sizeof(name));
			format(cng_string, sizeof(cng_string), "{%s}%s{FF6347} ������� �������������� %d �� ������ {%s}%s.", 
				GetColorByRate(PlayerInfo[playerid][Rate]), name, level, GetGradeColor(item[Grade]), item[Name]
			);
			SendClientMessageToAll(COLOR_LIGHTRED, cng_string);
		}
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����������", "{66CC00}����������� ��������� �������.", "�������", "");
	}
	//fail
	else if(roll <= chances[0] + chances[1])
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����������", "{FFCC00}����������� �������� ��������.", "�������", "");
	}
	//reset
	else if(roll <= chances[0] + chances[1] + chances[2])
	{
		for(new i = 0; i < MAX_MOD; i++)
			PlayerInventory[playerid][itemslot][Mod][i] = 0;

		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����������", "{CC0000}����������� ��������: ����� ����������.", "�������", "");
	}
	//destroy
	else
	{
		DeleteItem(playerid, itemslot, 1);
		ModItemSlot[playerid] = -1;
		ModStone[playerid] = -1;
		ModPotion[playerid] = -1;

		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "�����������", "{CC0000}����������� ��������: ������� ���������.", "�������", "");
	}
}

stock GetModChances(level, grade, potionid = -1)
{
	new chances[4];

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `mod_chances` WHERE `Level` = '%d' AND `Grade` = '%d' AND `Potion` = '%d' LIMIT 1", level, grade, potionid);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		cache_delete(q_result);
		print("Modification error.");
		return chances;
	}

	new string[255];

	cache_get_value_name(0, "Chances", string);
	sscanf(string, "a<i>[4]", chances);
	cache_delete(q_result);

	return chances;
}

stock GetModifierByStone(stoneid)
{
	switch(stoneid)
	{
		case 187: return MOD_DAMAGE;
		case 188: return MOD_DEFENSE;
		case 189: return MOD_ACCURACY;
		case 190: return MOD_DODGE;
	}
	return 0;
}

stock GetWeaponBaseDamage(weaponid)
{
	new damage[2];
	switch(weaponid)
	{
		case 1: { damage[0] = 17; damage[1] = 20; }
		case 2..8: { damage[0] = 23; damage[1] = 27; }
		case 9: { damage[0] = 29; damage[1] = 40; }
		case 10..16: { damage[0] = 38; damage[1] = 54; }
		case 17: { damage[0] = 9; damage[1] = 18; }
		case 18..24: { damage[0] = 12; damage[1] = 24; }
		case 25: { damage[0] = 14; damage[1] = 31; }
		case 26..32: { damage[0] = 19; damage[1] = 42; }
		case 33: { damage[0] = 20; damage[1] = 47; }
		case 34..40: { damage[0] = 27; damage[1] = 63; }
		case 41: { damage[0] = 41; damage[1] = 53; }
		case 42..48: { damage[0] = 55; damage[1] = 72; }
		case 49: { damage[0] = 38; damage[1] = 66; }
		case 50..56: { damage[0] = 51; damage[1] = 89; }
		case 57: { damage[0] = 281; damage[1] = 429; }
		case 58..64: { damage[0] = 379; damage[1] = 579; }
		case 65: { damage[0] = 146; damage[1] = 312; }
		case 66..72: { damage[0] = 197; damage[1] = 421; }
		case 73: { damage[0] = 319; damage[1] = 534; }
		case 74..80: { damage[0] = 431; damage[1] = 721; }
		default: { damage[0] = 13; damage[1] = 15; }
	}
	return damage;
}

stock GetWeaponModifiedDamage(base_damage[], level)
{
	new damage[2];
	new multiplicator = GetModifierStatByLevel(MOD_DAMAGE, level);
	damage[0] = base_damage[0] + (base_damage[0] * multiplicator) / 100;
	damage[1] = base_damage[1] + (base_damage[1] * multiplicator) / 100;
	return damage;
}

stock GetArmorBaseDefense(armorid)
{
	new defense;
	switch(armorid)
	{
		case 82: defense = 9;
		case 83..89: defense = 12;
		case 90: defense = 16;
		case 91..97: defense = 22;
		case 98: defense = 31;
		case 99..105: defense = 42;
		case 106: defense = 56;
		case 107..113: defense = 76;
		case 114: defense = 99;
		case 115..121: defense = 134;
		case 122: defense = 168;
		case 123..129: defense = 227;
		case 130: defense = 302;
		case 131..137: defense = 408;
		case 138: defense = 517;
		case 139..145: defense = 698;
		case 146: defense = 841;
		case 147..153: defense = 1135;
		default: defense = 5;
	}
	return defense;
}

stock GetArmorModifiedDefense(base_defense, level)
{
	new defense;
	new multiplicator = GetModifierStatByLevel(MOD_DEFENSE, level);
	defense = base_defense + (base_defense * multiplicator) / 100;
	return defense;
}

stock MapModifiersDescs(mod[], modifiers[], count)
{
	new descs[4][255];
	new string[255];
	for(new i = 0; i < count; i++)
	{
		new modifier = modifiers[i];
		new modifier_level = GetModifierLevel(mod, modifier);
		if(modifier == MOD_DAMAGE || modifier == MOD_DEFENSE)
			format(string, sizeof(string), "%s �� %d%%", GetModifierName(modifier), GetModifierStatByLevel(modifier, modifier_level));
		else if(modifier == MOD_DODGE || modifier == MOD_ACCURACY)
			format(string, sizeof(string), "%s �� %d", GetModifierName(modifier), GetModifierStatByLevel(modifier, modifier_level));
		else
			string = "";
		descs[i] = string;
	}
	return descs;
}

stock GetModLevel(mod[])
{
	new level = 0;
	for(new i = 0; i < MAX_MOD; i++)
		if(mod[i] != 0) level++;
	return level;
}

stock GetModifierLevel(mod[], modifier)
{
	new modifier_level = 0;
	for(new i = 0; i < MAX_MOD; i++)
		if(mod[i] == modifier) modifier_level++;
	return modifier_level;
}

stock GetModifierName(modifier)
{
	new string[255];
	switch(modifier)
	{
		case MOD_DAMAGE: string = "���������� �����";
		case MOD_DEFENSE: string = "���������� ������";
		case MOD_ACCURACY: string = "���������� ��������";
		case MOD_DODGE: string = "���������� ���������";
		default: string = "";
	}
	return string;
}

stock GetModifierStatByLevel(modifier, level)
{
	switch(modifier)
	{
		case MOD_DAMAGE, MOD_DEFENSE:
		{
			switch(level)
			{
				case 1: return 5;
				case 2: return 13;
				case 3: return 25;
				case 4: return 50;
				case 5: return 80;
				case 6: return 135;
				case 7: return 200;
			}
		}
		case MOD_ACCURACY, MOD_DODGE:
		{
			switch(level)
			{
				case 1: return 5;
				case 2: return 10;
				case 3: return 25;
				case 4: return 45;
				case 5: return 60;
				case 6: return 80;
				case 7: return 100;
			}
		}
	}
	return 0;
}

stock GetModModel(modifier)
{
	switch(modifier)
	{
		case MOD_DAMAGE: return 3002;
		case MOD_DEFENSE: return 3101;
		case MOD_DODGE: return 3104;
		case MOD_ACCURACY: return 3100;
	}
	return 3106;
}

stock GetModifiers(mod[])
{
	new modifiers[4];
	for (new i = 0; i < MAX_MOD; i++)
	{
		if(mod[i] == 0) continue;
		if(ArrayValueExist(modifiers, 4, mod[i])) continue;

		for (new j = 0; j < 4; j++)
		{
			if(modifiers[j] == 0)
			{
				modifiers[j] = mod[i];
				break;
			}
		}
	}
	return modifiers;
}

stock GetModifiersCount(modfs[])
{
	new count = 0;
	for (new i = 0; i < 4; i++)
		if(modfs[i] != 0) count++;
	
	return count;
}

stock ArrayValueExist(arr[], size, value)
{
	for (new i = 0; i < size; i++)
	{
		if(arr[i] == value)
			return true;
	}
	return false;
}

stock GetItemEffectString(effect, value)
{
	new string[128];
	switch(effect) 
	{
	    case 1: format(string, sizeof(string), "���� +%d%%", value);
	    case 2: format(string, sizeof(string), "������ +%d%%", value);
	    case 3: format(string, sizeof(string), "��������� +%d", value);
	    case 4: format(string, sizeof(string), "�������� +%d", value);
	    case 5: format(string, sizeof(string), "HP +%d%%", value);
	    case 6: format(string, sizeof(string), "���� ����� +%d%%", value);
		case 7: format(string, sizeof(string), "��� � ������ X%d", value);
	    default: string = "";
	}

	return string;
}

stock GetItemTypeString(type)
{
	new string[64];
	switch(type) 
	{
	    case 1: string = "������";
	    case 2: string = "������";
	    case 3: string = "���������";
	    case 4: string = "��������� �������";
	    case 5: string = "��������";
	    case 6: string = "�������";
	    default: string = "�������";
	}
	return string;
}

stock GetPlaceColor(place)
{
    new color[16];
	switch(place) 
	{
	    case 1: color = "FFCC00";
	    case 2: color = "FF6600";
	    case 3: color = "FF3300";
	    case 4,5: color = "CC0099";
	    case 6..8: color = "CC33FF";
	    case 9..12: color = "6666FF";
		case 13..16: color = "66CC33";
	    default: color = "CCCCCC";
	}
	return color;
}

stock GetGradeColor(grade)
{
	new color[16];
	switch(grade)
	{
	    case 2: color = "FFCC00";
	    case 3: color = "CC6600";
	    default: color = "CCCCCC";
	}
	return color;
}

stock GetHexPlaceColor(place)
{
	new color;
	switch(place) 
	{
	    case 1: color = 0xFFCC00FF;
	    case 2: color = 0xFF6600FF;
	    case 3: color = 0xFF3300FF;
	    case 4,5: color = 0xCC0099FF;
	    case 6..8: color = 0xCC33FFFF;
	    case 9..12: color = 0x6666FFFF;
		case 13..16: color = 0x66CC33FF;
	    default: color = 0xCCCCCCFF;
	}
	return color;
}

stock ArrayToString(array[], size, type = TYPE_INT)
{
	new string[1024] = "";
	new buf[255];

	for(new i = 0; i < size; i++)
	{
		switch(type)
		{
			case TYPE_STRING: { format(buf, sizeof(buf), "%s ", array[i]); }
			case TYPE_FLOAT: { format(buf, sizeof(buf), "%f ", array[i]); }
			default: { format(buf, sizeof(buf), "%i ", array[i]); }
		}
		strcat(string, buf);
	}

	strdel(string, strlen(string)-1, strlen(string));
	return string;
}

stock GetRateInterval(rate) 
{
	new interval[32];
	switch(rate) 
	{
	    case 500..999: interval = "������";
	    case 1000..1199: interval = "������";
	    case 1200..1399: interval = "������";
	    case 1400..1599: interval = "�������";
	    case 1600..1999: interval = "������";
	    case 2000..2299: interval = "�������";
	    case 2300..2699: interval = "�����";
	    case 2700..3000: interval = "���������";
	    default: interval = "������";
	}
	return interval;
}

stock GetRankInterval(rank)
{
	new interval[32];
	switch(rank) 
	{
	    case 2: interval = "������";
	    case 3: interval = "������";
	    case 4: interval = "������";
	    case 5: interval = "�������";
	    case 6: interval = "������";
	    case 7: interval = "�������";
	    case 8: interval = "�����";
	    case 9: interval = "���������";
	    default: interval = "������";
	}
	return interval;
}

stock GetRankByRate(rate)
{
	new rank;
	switch(rate)
	{
		case 500..999: rank = 2;
	    case 1000..1199: rank = 3;
	    case 1200..1399: rank = 4;
	    case 1400..1599: rank = 5;
	    case 1600..1999: rank = 6;
	    case 2000..2299: rank = 7;
	    case 2300..2699: rank = 8;
	    case 2700..3000: rank = 9;
	    default: rank = 1;
	}
	return rank;
}

stock LoadTournamentInfo()
{
	new query[255] = "SELECT * FROM `tournament` LIMIT 1";
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		cache_delete(q_result);
		print("Tournament info loading error.");
		return;
	}

	cache_get_value_name_int(0, "Number", Tournament[Number]);
	cache_get_value_name_int(0, "Phase", Tournament[Phase]);
	cache_get_value_name_int(0, "Tour", Tournament[Tour]);

	for(new i = 0; i < MAX_PARTICIPANTS; i++)
		Tournament[ParticipantsIDs][i] = -1;

	new string[255];
	cache_get_value_name(0, "Participants", string);
	sscanf(string, "a<i>[20]", Tournament[ParticipantsIDs]);

	cache_delete(q_result);

	TourParticipantsCount = 0;
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
		if(Tournament[ParticipantsIDs][i] != -1)
			TourParticipantsCount++;

	print("Tournament info loaded.");
}

stock SaveTournamentInfo()
{
	new query[255];
	format(query, sizeof(query), "UPDATE `tournament` SET `Number` = '%d', `Phase` = '%d', `Tour` = '%d', `Participants` = '%s' LIMIT 1", 
		Tournament[Number], Tournament[Phase], Tournament[Tour], ArrayToString(Tournament[ParticipantsIDs], MAX_PARTICIPANTS)
	);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);
	print("Tournament info saved.");
}

stock LoadAccount(playerid, login[])
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `login` = '%s' LIMIT 1", login);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		cache_delete(q_result);
		return false;
	}

	cache_get_value_name_int(0, "admin", PlayerInfo[playerid][Admin]);
	cache_get_value_name_int(0, "teamcolor", PlayerInfo[playerid][TeamColor]);
	
    cache_delete(q_result);
	return true;
}

stock SavePlayer(playerid, bool:with_pos = true)
{
	new name[64];
	if(with_pos)
	{
		GetPlayerPos(playerid, PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ]);
		GetPlayerFacingAngle(playerid, PlayerInfo[playerid][FacingAngle]);
		PlayerInfo[playerid][Interior] = GetPlayerInterior(playerid);
	}
	GetPlayerName(playerid, name, sizeof(name));

	new query[2048] = "UPDATE `players` SET ";
	new tmp[255];

	format(tmp, sizeof(tmp), "`Sex` = '%d', `Rate` = '%d', `Rank` = '%d', ", PlayerInfo[playerid][Sex], PlayerInfo[playerid][Rate], PlayerInfo[playerid][Rank]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`MaxRank` = '%d', `Cash` = '%d', ", PlayerInfo[playerid][MaxRank], PlayerInfo[playerid][Cash]);
	strcat(query, tmp);
	if(with_pos)
	{
		format(tmp, sizeof(tmp), "`PosX` = '%f', `PosY` = '%f', `PosZ` = '%f', `Angle` = '%f', `Interior` = '%d', ", PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ], PlayerInfo[playerid][FacingAngle], PlayerInfo[playerid][Interior]);
		strcat(query, tmp);
	}
	format(tmp, sizeof(tmp), "`Skin` = '%d', `Kills` = '%d', ", PlayerInfo[playerid][Skin], PlayerInfo[playerid][Kills]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`Deaths` = '%d', `DamageMin` = '%d', `DamageMax` = '%d', ", PlayerInfo[playerid][Deaths], PlayerInfo[playerid][DamageMin], PlayerInfo[playerid][DamageMax]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`Defense` = '%d', `Dodge` = '%d', `Accuracy` = '%d', ", PlayerInfo[playerid][Defense], PlayerInfo[playerid][Dodge], PlayerInfo[playerid][Accuracy]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`Crit` = '%d', `GlobalTopPos` = '%d', `LocalTopPos` = '%d', ", PlayerInfo[playerid][Crit], PlayerInfo[playerid][GlobalTopPosition], PlayerInfo[playerid][LocalTopPosition]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`WeaponSlotID` = '%d', `ArmorSlotID` = '%d', `AccSlot1ID` = '%d', `AccSlot2ID` = '%d', ", PlayerInfo[playerid][WeaponSlotID], PlayerInfo[playerid][ArmorSlotID], PlayerInfo[playerid][AccSlot1ID], PlayerInfo[playerid][AccSlot2ID]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`WeaponMod` = '%s', `ArmorMod` = '%s' ", ArrayToString(PlayerInfo[playerid][WeaponMod], MAX_MOD), ArrayToString(PlayerInfo[playerid][ArmorMod], MAX_MOD));
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "WHERE `Name` = '%s' LIMIT 1", name);
	strcat(query, tmp);

	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	SaveInventory(playerid);
}

stock CreateInventory(name[])
{
	new query[512];

	for(new i = 0; i < MAX_SLOTS; i++)
	{
		format(query, sizeof(query), "INSERT INTO `inventories`(`PlayerName`, `SlotID`, `ItemID`, `SlotMod`, `Count`) VALUES ('%s','%d','%d','%s','%d')",
			name, i, -1, "0 0 0 0 0 0 0", 0
		);

		new Cache:q_result = mysql_query(sql_handle, query);
		cache_delete(q_result);
	}
}

stock SaveInventory(playerid)
{
	if(FCNPC_IsValid(playerid)) return;

	new name[128];
	new query[512];
	GetPlayerName(playerid, name, sizeof(name));

	for(new i = 0; i < MAX_SLOTS; i++)
	{
		format(query, sizeof(query), "UPDATE `inventories` SET `ItemID` = '%d', `SlotMod` = '%s', `Count` = '%d' WHERE `PlayerName` = '%s' AND `SlotID` = '%d' LIMIT 1", 
			PlayerInventory[playerid][i][ID], ArrayToString(PlayerInventory[playerid][i][Mod], MAX_MOD), PlayerInventory[playerid][i][Count], name, i
		);
		new Cache:q_result = mysql_query(sql_handle, query);
		cache_delete(q_result);
	}
}

stock LoadInventory(playerid)
{
	if(FCNPC_IsValid(playerid)) return;

	new name[128];
	new query[512];
	GetPlayerName(playerid, name, sizeof(name));

	format(query, sizeof(query), "SELECT * FROM `inventories` WHERE `PlayerName` = '%s'", name);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count < MAX_SLOTS)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "������ ��� �������� ���������. ���������� � ��������������.");
		cache_delete(q_result);
		return;
	}

	new slot_id;
	for(new i = 0; i < row_count; i++)
	{
		cache_get_value_name_int(i, "SlotID", slot_id);
		if(slot_id < 0)
			continue;

		cache_get_value_name_int(i, "ItemID", PlayerInventory[playerid][slot_id][ID]);
		cache_get_value_name_int(i, "Count", PlayerInventory[playerid][slot_id][Count]);

		new string[255];
		cache_get_value_name(i, "SlotMod", string);
		sscanf(string, "a<i>[7]", PlayerInventory[playerid][slot_id][Mod]);
	}

	cache_delete(q_result);
}

stock LoadPlayer(playerid)
{
	new name[255];
	GetPlayerName(playerid, name, sizeof(name));
	PlayerInfo[playerid][Name] = name;

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Name` = '%s' LIMIT 1", name);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "������ ��� �������� ���������. ���������� � ��������������.");
		cache_delete(q_result);
		return false;
	}

	cache_get_value_name_int(0, "ID", PlayerInfo[playerid][ID]);
	cache_get_value_name_int(0, "Sex", PlayerInfo[playerid][Sex]);
	cache_get_value_name_int(0, "Rate", PlayerInfo[playerid][Rate]);
	cache_get_value_name_int(0, "Rank", PlayerInfo[playerid][Rank]);
	cache_get_value_name_int(0, "MaxRank", PlayerInfo[playerid][MaxRank]);
	cache_get_value_name_int(0, "Cash", PlayerInfo[playerid][Cash]);
	cache_get_value_name_float(0, "PosX", PlayerInfo[playerid][PosX]);
	cache_get_value_name_float(0, "PosY", PlayerInfo[playerid][PosY]);
	cache_get_value_name_float(0, "PosZ", PlayerInfo[playerid][PosZ]);
	cache_get_value_name_float(0, "Angle", PlayerInfo[playerid][FacingAngle]);
	cache_get_value_name_int(0, "Interior", PlayerInfo[playerid][Interior]);
	cache_get_value_name_int(0, "Skin", PlayerInfo[playerid][Skin]);
	cache_get_value_name_int(0, "Kills", PlayerInfo[playerid][Kills]);
	cache_get_value_name_int(0, "Deaths", PlayerInfo[playerid][Deaths]);
	cache_get_value_name_int(0, "DamageMin", PlayerInfo[playerid][DamageMin]);
	cache_get_value_name_int(0, "DamageMax", PlayerInfo[playerid][DamageMax]);
	cache_get_value_name_int(0, "Defense", PlayerInfo[playerid][Defense]);
	cache_get_value_name_int(0, "Dodge", PlayerInfo[playerid][Dodge]);
	cache_get_value_name_int(0, "Accuracy", PlayerInfo[playerid][Accuracy]);
	cache_get_value_name_int(0, "Crit", PlayerInfo[playerid][Crit]);
	cache_get_value_name_int(0, "GlobalTopPos", PlayerInfo[playerid][GlobalTopPosition]);
	cache_get_value_name_int(0, "LocalTopPos", PlayerInfo[playerid][LocalTopPosition]);
	cache_get_value_name_int(0, "WeaponSlotID", PlayerInfo[playerid][WeaponSlotID]);
	cache_get_value_name_int(0, "ArmorSlotID", PlayerInfo[playerid][ArmorSlotID]);
	cache_get_value_name_int(0, "AccSlot1ID", PlayerInfo[playerid][AccSlot1ID]);
	cache_get_value_name_int(0, "AccSlot2ID", PlayerInfo[playerid][AccSlot2ID]);

	new owner[255];
	cache_get_value_name(0, "Owner", owner);
	sscanf(owner, "s[255]", PlayerInfo[playerid][Owner]);

	new string[255];
	cache_get_value_name(0, "WeaponMod", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][WeaponMod]);
	cache_get_value_name(0, "ArmorMod", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][ArmorMod]);

	cache_delete(q_result);

	LoadInventory(playerid);
	UpdatePlayerRank(playerid);
 	return 1;
}

stock CreatePlayer(playerid, name[], owner[], sex)
{
	new query[2048] = "INSERT INTO `players`( \
		`ID`, `Name`, `Owner`, `Sex`, `Rate`, `MaxRank`, `Rank`, `Cash`, `PosX`, `PosY`, `PosZ`, \
		`Angle`, `Interior`, `Skin`, `Kills`, `Deaths`, `DamageMin`, `DamageMax`, `Defense`, \
		`Dodge`, `Accuracy`, `Crit`, `GlobalTopPos`, `LocalTopPos`, `WeaponSlotID`, `WeaponMod`, \
		`ArmorSlotID`, `ArmorMod`, `AccSlot1ID`, `AccSlot2ID`) VALUES (";
	new tmp[1024];

	new sub_query[255] = "SELECT MAX(`ID`) AS `ID` FROM `players`";
	new Cache:sq_result = mysql_query(sql_handle, sub_query);
	new id = -1;
	cache_get_value_name_int(0, "ID", id);
	cache_delete(sq_result);

	if(id == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "������ ���������� ID: ��������� �������� ����.ID ��� ���� ������� �����.");
		return;
	}

	id++;

	format(tmp, sizeof(tmp), "'%d','%s','%s','%d','%d','%d','%d','%d','%f','%f','%f','%f','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%s','%d','%s','%d','%d')",
		id, name, owner, sex, 0, 1, 1, 0, DEFAULT_POS_X, DEFAULT_POS_Y, DEFAULT_POS_Z, 180, 1, 78, 0, 0, 13, 15, 5, 0, 5, 5, 20, 10, 0, "0 0 0 0 0 0 0", 81, "0 0 0 0 0 0 0", -1, -1
	);
	strcat(query, tmp);

	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	CreateInventory(name);

	SendClientMessage(playerid, COLOR_GREEN, "Player created succesfully.");
}

stock IsPlayerBesideNPC(playerid)
{
	return IsPlayerInRangeOfPoint(playerid, 2.0, -2166.7527,646.0400,1052.3750) ||
		   IsPlayerInRangeOfPoint(playerid, 2.0, 189.2644,-1825.4902,4.1411) ||
		   IsPlayerInRangeOfPoint(playerid, 2.0, 262.6658,-1825.2792,3.9126);
}

stock GetColorByRate(rate) 
{
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

stock UpdateGlobalRatingTop()
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` <> 'Admin' ORDER BY `Rate` DESC LIMIT %d", MAX_PARTICIPANTS);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("Global rating update error.");
		cache_delete(q_result);
		return;
	}

	q_result = cache_save();
	cache_unset_active();

	for(new i = 0; i < row_count; i++)
	{
		new name[255];
		new rate;

		cache_set_active(q_result);
		cache_get_value_name(i, "Name", name);
		cache_get_value_name_int(i, "Rate", rate);
		cache_unset_active();

		format(query, sizeof(query), "UPDATE `players` SET `GlobalTopPos` = '%d' WHERE `Name` = '%s' LIMIT 1", i+1, name);
		new Cache:temp_result = mysql_query(sql_handle, query);
		cache_delete(temp_result);

		GlobalRatingTop[i][Name] = name;
		GlobalRatingTop[i][Rate] = rate;

		new playerid = GetPlayerID(name);
		if(playerid != -1)
			PlayerInfo[playerid][GlobalTopPosition] = i+1;
	}

	cache_delete(q_result);
}

stock UpdateLocalRatingTop(playerid)
{
	new name[255];
	new query[255];
	new string[255];
	
	GetPlayerName(playerid, name, sizeof(name));
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Name` = '%s' LIMIT 1", name);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		format(string, sizeof(string), "Local rating update error. Player: %s", name);
		print(string);
		cache_delete(q_result);
		return;
	}

	new owner[255];
	cache_get_value_name(0, "Owner", owner);
	cache_delete(q_result);

	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` = '%s' ORDER BY `Rate` DESC LIMIT %d", owner, MAX_PARTICIPANTS / 2);
	q_result = mysql_query(sql_handle, query);

	row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		format(string, sizeof(string), "Local rating update error. Player: %s", name);
		print(string);
		cache_delete(q_result);
		return;
	}

	q_result = cache_save();
	cache_unset_active();

	for(new i = 0; i < row_count; i++)
	{
		new rate;

		cache_set_active(q_result);
		cache_get_value_name(i, "Name", name);
		cache_get_value_name_int(i, "Rate", rate);
		cache_unset_active();

		format(query, sizeof(query), "UPDATE `players` SET `LocalTopPos` = '%d' WHERE `Name` = '%s' LIMIT 1", i+1, name);
		new Cache:temp_result = mysql_query(sql_handle, query);
		cache_delete(temp_result);

		LocalRatingTop[playerid][i][Name] = name;
		LocalRatingTop[playerid][i][Rate] = rate;

		new pid = GetPlayerID(name);
		if(pid != -1)
			PlayerInfo[pid][LocalTopPosition] = i+1;
	}

	cache_delete(q_result);
}

stock ShowGlobalRatingTop(playerid)
{
	new top[4000] = "� �\\�\t���\t�������";
	new string[455];
	for (new i = 0; i < MAX_PARTICIPANTS; i++) 
	{
		format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t%d", 
			GetPlaceColor(i+1), i+1, GetColorByRate(GlobalRatingTop[i][Rate]), GlobalRatingTop[i][Name], GlobalRatingTop[i][Rate]
		);
		strcat(top, string);
	}
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST_HEADERS, "����� ������� ����������", top, "�������", "");
}

stock ShowLocalRatingTop(playerid)
{
	new top[4000] = "� �\\�\t���\t�������";
	new string[455];
	for (new i = 0; i < MAX_PARTICIPANTS / 2; i++) 
	{
		format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t%d", 
			GetPlaceColor(i+1), i+1, GetColorByRate(LocalRatingTop[playerid][i][Rate]), LocalRatingTop[playerid][i][Name], LocalRatingTop[playerid][i][Rate]
		);
		strcat(top, string);
	}
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST_HEADERS, "������� ���� ����������", top, "�������", "");
}

stock IsTourParticipant(id)
{
	for (new i = 0; i < TourParticipantsCount; i++)
		if(Tournament[ParticipantsIDs][i] == id) return true;
	return false;
}

stock ShowTourParticipants(playerid)
{
	new top[4000] = "� �\\�\t���\t�������";
	new string[255];
	for (new i = 0; i < TourParticipantsCount; i++) 
	{
		new player[pInfo];
		player = GetPlayer(Tournament[ParticipantsIDs][i]);
		format(string, sizeof(string), "\n{ffffff}%d\t{%s}%s\t%d", 
			i+1, GetColorByRate(player[Rate]), player[Name], player[Rate]
		);
		strcat(top, string);
	}
	ShowPlayerDialog(playerid, 201, DIALOG_STYLE_TABLIST_HEADERS, "��������� �������� ����", top, "�����", "�������");
}

stock ShowTournamentTab(playerid)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `tournament_tab` ORDER BY `Score` DESC LIMIT %d", MAX_PARTICIPANTS);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("ShowTournamentTab() error.");
		return;
	}

	q_result = cache_save();
	cache_unset_active();

	for(new i = 0; i < row_count; i++)
	{
		cache_set_active(q_result);
		new id = -1;
		new score = 0;
		cache_get_value_name_int(i, "ID", id);
		cache_get_value_name_int(i, "Score", score);
		if(id == -1) continue;

		new player[pInfo];
		player = GetPlayer(id);

		format(TournamentTab[i][Name], 255, "%s", player[Name]);
		TournamentTab[i][Rate] = player[Rate];
		TournamentTab[i][Score] = score;
		TournamentTab[i][Pos] = i+1;
	}

	cache_delete(q_result);

	new top[4000] = "� �\\�\t���\t�������\t����";
	new string[255];
	for (new i = 0; i < row_count; i++) 
	{
		format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t{%s}%s\t{9900CC}%d", 
			GetPlaceColor(i+1), i+1, GetColorByRate(TournamentTab[i][Rate]), TournamentTab[i][Name], 
			GetColorByRate(TournamentTab[i][Rate]), GetRateInterval(TournamentTab[i][Rate]), TournamentTab[i][Score]
		);
		strcat(top, string);
	}
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST_HEADERS, "��������� �������", top, "�������", "");
}

stock GetPlayer(id)
{
	new player[pInfo];
	new query[255];

	format(query, sizeof(query), "SELECT * FROM `players` WHERE `ID` = '%d' LIMIT 1", id);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("GetPlayer() error.");
		return player;
	}

	cache_get_value_name_int(0, "Rate", player[Rate]);
	new name[255];
	new owner[255];
	cache_get_value_name(0, "Name", name);
	cache_get_value_name(0, "Owner", owner);
	format(player[Name], 255, "%s", name);
	format(player[Owner], 255, "%s", owner);
	player[ID] = id;

	cache_delete(q_result);
	return player;
}

stock GetPlayerID(name[])
{
	new p_name[255];

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		GetPlayerName(i, p_name, sizeof(p_name));
		if(strcmp(name, p_name, true) == 0)
			return i;
	}

	return -1;
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

	ChrInfoHeader[playerid] = CreatePlayerTextDraw(playerid, 551.999877, 107.436988, "��������");
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
	PlayerTextDrawUseBox(playerid, ChrInfoDelim1[playerid], false);
	PlayerTextDrawBoxColor(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfoDelim1[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoDelim1[playerid], 0x00000000);
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

	ChrInfDamage[playerid] = CreatePlayerTextDraw(playerid, 501.366607, 126.605903, "����: 9999-9999");
	PlayerTextDrawLetterSize(playerid, ChrInfDamage[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDamage[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDamage[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDamage[playerid], 1);

	ChrInfDefense[playerid] = CreatePlayerTextDraw(playerid, 501.533477, 133.164413, "������: 9999");
	PlayerTextDrawLetterSize(playerid, ChrInfDefense[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDefense[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDefense[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDefense[playerid], 1);

	ChrInfAccuracy[playerid] = CreatePlayerTextDraw(playerid, 501.566833, 139.515502, "��������: 999");
	PlayerTextDrawLetterSize(playerid, ChrInfAccuracy[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAccuracy[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccuracy[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfAccuracy[playerid], 1);

	ChrInfDodge[playerid] = CreatePlayerTextDraw(playerid, 501.533447, 145.534683, "���������: 999");
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
	PlayerTextDrawUseBox(playerid, ChrInfDelim2[playerid], false);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim2[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim2[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDelim2[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim2[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfArmorSlot[playerid] = CreatePlayerTextDraw(playerid, 591.000000, 121.000000, "armor_slot");
	PlayerTextDrawLetterSize(playerid, ChrInfArmorSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfArmorSlot[playerid], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, ChrInfArmorSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfArmorSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfArmorSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfArmorSlot[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfArmorSlot[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfArmorSlot[playerid], 1275);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfArmorSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, ChrInfArmorSlot[playerid], true);

	ChrInfWeaponSlot[playerid] = CreatePlayerTextDraw(playerid, 575.000000, 121.000000, "weapon_slot");
	PlayerTextDrawLetterSize(playerid, ChrInfWeaponSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfWeaponSlot[playerid], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, ChrInfWeaponSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfWeaponSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfWeaponSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfWeaponSlot[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfWeaponSlot[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfWeaponSlot[playerid], 346);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfWeaponSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, ChrInfWeaponSlot[playerid], true);

	ChrInfAccSlot1[playerid] = CreatePlayerTextDraw(playerid, 575.000000, 137.000000, "acs_slot1");
	PlayerTextDrawLetterSize(playerid, ChrInfAccSlot1[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfAccSlot1[playerid], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, ChrInfAccSlot1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAccSlot1[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfAccSlot1[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfAccSlot1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfAccSlot1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAccSlot1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccSlot1[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfAccSlot1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfAccSlot1[playerid], 954);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfAccSlot1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, ChrInfAccSlot1[playerid], true);

	ChrInfAccSlot2[playerid] = CreatePlayerTextDraw(playerid, 591.000000, 137.000000, "acs_slot2");
	PlayerTextDrawLetterSize(playerid, ChrInfAccSlot2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfAccSlot2[playerid], 14.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, ChrInfAccSlot2[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAccSlot2[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfAccSlot2[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfAccSlot2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfAccSlot2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAccSlot2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccSlot2[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfAccSlot2[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfAccSlot2[playerid], 954);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfAccSlot2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, ChrInfAccSlot2[playerid], true);

	ChrInfClose[playerid] = CreatePlayerTextDraw(playerid, 601.999938, 106.607421, "X");
	PlayerTextDrawLetterSize(playerid, ChrInfClose[playerid], 0.315333, 1.010962);
	PlayerTextDrawTextSize(playerid, ChrInfClose[playerid], 6.666668, 4.977776);
	PlayerTextDrawAlignment(playerid, ChrInfClose[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfClose[playerid], -2147483393);
	PlayerTextDrawUseBox(playerid, ChrInfClose[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfClose[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfClose[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, ChrInfClose[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfClose[playerid], 1);
	PlayerTextDrawFont(playerid, ChrInfClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfClose[playerid], true);

	ChrInfText1[playerid] = CreatePlayerTextDraw(playerid, 519.999877, 156.385177, "�����");
	PlayerTextDrawLetterSize(playerid, ChrInfText1[playerid], 0.186000, 0.716444);
	PlayerTextDrawAlignment(playerid, ChrInfText1[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfText1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfText1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfText1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfText1[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfText1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfText1[playerid], 1);

	ChrInfAllRate[playerid] = CreatePlayerTextDraw(playerid, 520.299987, 163.151092, "99");
	PlayerTextDrawLetterSize(playerid, ChrInfAllRate[playerid], 0.263000, 1.243257);
	PlayerTextDrawAlignment(playerid, ChrInfAllRate[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfAllRate[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, ChrInfAllRate[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAllRate[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAllRate[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfAllRate[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfAllRate[playerid], 1);

	ChrInfRate[playerid] = CreatePlayerTextDraw(playerid, 554.632568, 156.767410, "2319");
	PlayerTextDrawLetterSize(playerid, ChrInfRate[playerid], 0.365332, 1.741037);
	PlayerTextDrawAlignment(playerid, ChrInfRate[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfRate[playerid], -1378294017);
	PlayerTextDrawSetShadow(playerid, ChrInfRate[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfRate[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRate[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfRate[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfRate[playerid], 1);

	ChrInfText2[playerid] = CreatePlayerTextDraw(playerid, 589.599487, 156.638442, "������");
	PlayerTextDrawLetterSize(playerid, ChrInfText2[playerid], 0.186000, 0.716444);
	PlayerTextDrawAlignment(playerid, ChrInfText2[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfText2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfText2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfText2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfText2[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfText2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfText2[playerid], 1);

	ChrInfPersonalRate[playerid] = CreatePlayerTextDraw(playerid, 589.832946, 163.487228, "11");
	PlayerTextDrawLetterSize(playerid, ChrInfPersonalRate[playerid], 0.263000, 1.243257);
	PlayerTextDrawAlignment(playerid, ChrInfPersonalRate[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfPersonalRate[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, ChrInfPersonalRate[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfPersonalRate[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfPersonalRate[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfPersonalRate[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfPersonalRate[playerid], 1);

	ChrInfDelim3[playerid] = CreatePlayerTextDraw(playerid, 498.399719, 174.978012, "chrinfo_delim3");
	PlayerTextDrawLetterSize(playerid, ChrInfDelim3[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, ChrInfDelim3[playerid], 108.999992, 2.074074);
	PlayerTextDrawAlignment(playerid, ChrInfDelim3[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDelim3[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, ChrInfDelim3[playerid], false);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim3[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim3[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim3[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDelim3[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim3[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	new inv_slot_x = 501;
	new inv_slot_y = 179;
	new inv_slot_count_x = 520;
	new inv_slot_count_y = 193;
	new inv_slot_offset = 21;
	new idx = 0;
	for(new i = 1; i <= MAX_SLOTS_X; i++)
	{
		for(new j = 1; j <= MAX_SLOTS_Y; j++)
		{
			ChrInfInvSlot[playerid][idx] = CreatePlayerTextDraw(playerid, inv_slot_x, inv_slot_y, "invslot");
			PlayerTextDrawLetterSize(playerid, ChrInfInvSlot[playerid][idx], 0.000000, 0.000000);
			PlayerTextDrawTextSize(playerid, ChrInfInvSlot[playerid][idx], 20.000000, 20.000000);
			PlayerTextDrawAlignment(playerid, ChrInfInvSlot[playerid][idx], 1);
			PlayerTextDrawColor(playerid, ChrInfInvSlot[playerid][idx], -1);
			PlayerTextDrawUseBox(playerid, ChrInfInvSlot[playerid][idx], true);
			PlayerTextDrawBoxColor(playerid, ChrInfInvSlot[playerid][idx], 0);
			PlayerTextDrawSetShadow(playerid, ChrInfInvSlot[playerid][idx], 0);
			PlayerTextDrawSetOutline(playerid, ChrInfInvSlot[playerid][idx], 0);
			PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][idx], -1378294017);
			PlayerTextDrawFont(playerid, ChrInfInvSlot[playerid][idx], 5);
			PlayerTextDrawSetSelectable(playerid, ChrInfInvSlot[playerid][idx], true);
			PlayerTextDrawSetPreviewModel(playerid, ChrInfInvSlot[playerid][idx], -1);
			PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][idx], 0.000000, 0.000000, 0.000000, 1.000000);

			ChrInfInvSlotCount[playerid][idx] = CreatePlayerTextDraw(playerid, inv_slot_count_x, inv_slot_count_y, "0");
			PlayerTextDrawLetterSize(playerid, ChrInfInvSlotCount[playerid][idx], 0.139999, 0.674960);
			PlayerTextDrawAlignment(playerid, ChrInfInvSlotCount[playerid][idx], 3);
			PlayerTextDrawColor(playerid, ChrInfInvSlotCount[playerid][idx], 255);
			PlayerTextDrawSetShadow(playerid, ChrInfInvSlotCount[playerid][idx], 0);
			PlayerTextDrawSetOutline(playerid, ChrInfInvSlotCount[playerid][idx], 0);
			PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlotCount[playerid][idx], 51);
			PlayerTextDrawFont(playerid, ChrInfInvSlotCount[playerid][idx], 1);
			PlayerTextDrawSetProportional(playerid, ChrInfInvSlotCount[playerid][idx], 1);

			inv_slot_x += inv_slot_offset;
			inv_slot_count_x += inv_slot_offset;
			idx++;
		}
		inv_slot_x = 501;
		inv_slot_count_x = 520;
		inv_slot_y += inv_slot_offset;
		inv_slot_count_y += inv_slot_offset;
	}

	ChrInfButUse[playerid] = CreatePlayerTextDraw(playerid, 517.000000, 290.000000, "but_use");
	PlayerTextDrawLetterSize(playerid, ChrInfButUse[playerid], 0.000000, 0.133331);
	PlayerTextDrawTextSize(playerid, ChrInfButUse[playerid], 17.000000, 17.000000);
	PlayerTextDrawAlignment(playerid, ChrInfButUse[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButUse[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfButUse[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfButUse[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButUse[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfButUse[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfButUse[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfButUse[playerid], true);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButUse[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButUse[playerid], 19131);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButUse[playerid], 0.000000, 90.000000, 90.000000, 1.000000);

	ChrInfButInfo[playerid] = CreatePlayerTextDraw(playerid, 537.000000, 290.000000, "but_info");
	PlayerTextDrawLetterSize(playerid, ChrInfButInfo[playerid], 0.000000, 0.133331);
	PlayerTextDrawTextSize(playerid, ChrInfButInfo[playerid], 17.000000, 17.000000);
	PlayerTextDrawAlignment(playerid, ChrInfButInfo[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButInfo[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfButInfo[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfButInfo[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButInfo[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfButInfo[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfButInfo[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfButInfo[playerid], true);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButInfo[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButInfo[playerid], 1239);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButInfo[playerid], 0.000000, 0.000000, 180.000000, 1.000000);

	ChrInfButDel[playerid] = CreatePlayerTextDraw(playerid, 557.000000, 290.000000, "but_del");
	PlayerTextDrawLetterSize(playerid, ChrInfButDel[playerid], 0.000000, 0.133331);
	PlayerTextDrawTextSize(playerid, ChrInfButDel[playerid], 17.000000, 17.000000);
	PlayerTextDrawAlignment(playerid, ChrInfButDel[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButDel[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfButDel[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfButDel[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButDel[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfButDel[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfButDel[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfButDel[playerid], true);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButDel[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButDel[playerid], 1409);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButDel[playerid], 0.000000, 0.000000, 180.000000, 1.000000);

	ChrInfButMod[playerid] = CreatePlayerTextDraw(playerid, 577.000000, 290.000000, "but_mod");
	PlayerTextDrawLetterSize(playerid, ChrInfButMod[playerid], 0.000000, 0.133331);
	PlayerTextDrawTextSize(playerid, ChrInfButMod[playerid], 17.000000, 17.000000);
	PlayerTextDrawAlignment(playerid, ChrInfButMod[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButMod[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfButMod[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfButMod[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButMod[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfButMod[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfButMod[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfButMod[playerid], true);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButMod[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButMod[playerid], 19132);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButMod[playerid], 180.000000, 0.000000, 90.000000, 1.000000);

	ChrInfDelim4[playerid] = CreatePlayerTextDraw(playerid, 498.333129, 285.281646, "chrinfo_delim4");
	PlayerTextDrawLetterSize(playerid, ChrInfDelim4[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, ChrInfDelim4[playerid], 108.999992, 2.074074);
	PlayerTextDrawAlignment(playerid, ChrInfDelim4[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDelim4[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, ChrInfDelim4[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim4[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim4[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim4[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim4[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim4[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfBox[playerid] = CreatePlayerTextDraw(playerid, 388.100067, 113.085182, "inf_box");
	PlayerTextDrawLetterSize(playerid, EqInfBox[playerid], 0.000000, 20.898159);
	PlayerTextDrawTextSize(playerid, EqInfBox[playerid], 246.666671, 0.000000);
	PlayerTextDrawAlignment(playerid, EqInfBox[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, EqInfBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfBox[playerid], 102);
	PlayerTextDrawSetShadow(playerid, EqInfBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfBox[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfBox[playerid], 0);

	EqInfTxt1[playerid] = CreatePlayerTextDraw(playerid, 318.333312, 114.115562, "����������");
	PlayerTextDrawLetterSize(playerid, EqInfTxt1[playerid], 0.239666, 0.986074);
	PlayerTextDrawAlignment(playerid, EqInfTxt1[playerid], 2);
	PlayerTextDrawColor(playerid, EqInfTxt1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfTxt1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfTxt1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfTxt1[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfTxt1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfTxt1[playerid], 1);

	EqInfClose[playerid] = CreatePlayerTextDraw(playerid, 377.533569, 111.128860, "x");
	PlayerTextDrawLetterSize(playerid, EqInfClose[playerid], 0.383332, 1.363554);
	PlayerTextDrawTextSize(playerid, EqInfClose[playerid], 384.666687, 14.933336);
	PlayerTextDrawAlignment(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfClose[playerid], -2147483393);
	PlayerTextDrawUseBox(playerid, EqInfClose[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfClose[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfClose[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, EqInfClose[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawFont(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfClose[playerid], true);

	EqInfDelim1[playerid] = CreatePlayerTextDraw(playerid, 248.599563, 126.121482, "inf_delim1");
	PlayerTextDrawLetterSize(playerid, EqInfDelim1[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, EqInfDelim1[playerid], 137.866516, 2.405925);
	PlayerTextDrawAlignment(playerid, EqInfDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim1[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, EqInfDelim1[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfItemName[playerid] = CreatePlayerTextDraw(playerid, 318.400054, 130.210311, "[Type C-HP increasing] Bourgeois destroyer");
	PlayerTextDrawLetterSize(playerid, EqInfItemName[playerid], 0.169999, 0.811851);
	PlayerTextDrawAlignment(playerid, EqInfItemName[playerid], 2);
	PlayerTextDrawColor(playerid, EqInfItemName[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, EqInfItemName[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfItemName[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemName[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfItemName[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfItemName[playerid], 1);

	EqInfItemIcon[playerid] = CreatePlayerTextDraw(playerid, 253.000000, 143.000000, "inf_itemicon");
	PlayerTextDrawLetterSize(playerid, EqInfItemIcon[playerid], 0.000000, -0.666666);
	PlayerTextDrawTextSize(playerid, EqInfItemIcon[playerid], 25.000000, 25.000000);
	PlayerTextDrawAlignment(playerid, EqInfItemIcon[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfItemIcon[playerid], -1);
	PlayerTextDrawUseBox(playerid, EqInfItemIcon[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemIcon[playerid], -1378294017);
	PlayerTextDrawFont(playerid, EqInfItemIcon[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, EqInfItemIcon[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, EqInfItemIcon[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfMainStat[playerid] = CreatePlayerTextDraw(playerid, 283.400146, 141.451766, "Damage: 950-1120");
	PlayerTextDrawLetterSize(playerid, EqInfMainStat[playerid], 0.284000, 1.085629);
	PlayerTextDrawAlignment(playerid, EqInfMainStat[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfMainStat[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, EqInfMainStat[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfMainStat[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfMainStat[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfMainStat[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfMainStat[playerid], 1);

	EqInfBonusStat[playerid][0] = CreatePlayerTextDraw(playerid, 283.499786, 154.352645, "Max HP +10%");
	PlayerTextDrawLetterSize(playerid, EqInfBonusStat[playerid][0], 0.188333, 0.757925);
	PlayerTextDrawAlignment(playerid, EqInfBonusStat[playerid][0], 1);
	PlayerTextDrawColor(playerid, EqInfBonusStat[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, EqInfBonusStat[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, EqInfBonusStat[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfBonusStat[playerid][0], 51);
	PlayerTextDrawFont(playerid, EqInfBonusStat[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, EqInfBonusStat[playerid][0], 1);

	EqInfDelim2[playerid] = CreatePlayerTextDraw(playerid, 278.732940, 152.840209, "inf_delim2");
	PlayerTextDrawLetterSize(playerid, EqInfDelim2[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, EqInfDelim2[playerid], 107.833137, 1.617777);
	PlayerTextDrawAlignment(playerid, EqInfDelim2[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim2[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, EqInfDelim2[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim2[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim2[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfBonusStat[playerid][1] = CreatePlayerTextDraw(playerid, 283.566345, 161.948440, "Increase damage up to 10%");
	PlayerTextDrawLetterSize(playerid, EqInfBonusStat[playerid][1], 0.188333, 0.757925);
	PlayerTextDrawAlignment(playerid, EqInfBonusStat[playerid][1], 1);
	PlayerTextDrawColor(playerid, EqInfBonusStat[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, EqInfBonusStat[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, EqInfBonusStat[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfBonusStat[playerid][1], 51);
	PlayerTextDrawFont(playerid, EqInfBonusStat[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, EqInfBonusStat[playerid][1], 1);

	EqInfDelim3[playerid] = CreatePlayerTextDraw(playerid, 248.866241, 170.386657, "inf_delim3");
	PlayerTextDrawLetterSize(playerid, EqInfDelim3[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, EqInfDelim3[playerid], 137.866516, 2.405925);
	PlayerTextDrawAlignment(playerid, EqInfDelim3[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim3[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, EqInfDelim3[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim3[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim3[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfTxt2[playerid] = CreatePlayerTextDraw(playerid, 319.100036, 173.973190, "�����������");
	PlayerTextDrawLetterSize(playerid, EqInfTxt2[playerid], 0.233666, 1.015111);
	PlayerTextDrawAlignment(playerid, EqInfTxt2[playerid], 2);
	PlayerTextDrawColor(playerid, EqInfTxt2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfTxt2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfTxt2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfTxt2[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfTxt2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfTxt2[playerid], 1);

	new mod_x = 252;
	new mod_offset = 19;
	idx = 0;
	for(new i = 1; i <= MAX_MOD; i++)
	{
		EqInfMod[playerid][idx] = CreatePlayerTextDraw(playerid, mod_x, 191, "mod");
		PlayerTextDrawLetterSize(playerid, EqInfMod[playerid][idx], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, EqInfMod[playerid][idx], 18.000000, 18.000000);
		PlayerTextDrawAlignment(playerid, EqInfMod[playerid][idx], 1);
		PlayerTextDrawColor(playerid, EqInfMod[playerid][idx], -1);
		PlayerTextDrawUseBox(playerid, EqInfMod[playerid][idx], true);
		PlayerTextDrawBoxColor(playerid, EqInfMod[playerid][idx], 0);
		PlayerTextDrawSetShadow(playerid, EqInfMod[playerid][idx], 0);
		PlayerTextDrawSetOutline(playerid, EqInfMod[playerid][idx], 0);
		PlayerTextDrawFont(playerid, EqInfMod[playerid][idx], 5);
		PlayerTextDrawBackgroundColor(playerid, EqInfMod[playerid][idx], 0x00000000);
		PlayerTextDrawSetPreviewModel(playerid, EqInfMod[playerid][idx], 3106);
		PlayerTextDrawSetPreviewRot(playerid, EqInfMod[playerid][idx], 0.000000, 0.000000, 0.000000, 1.000000);

		mod_x += mod_offset;
		idx++;
	}

	EqInfModStat[playerid][0] = CreatePlayerTextDraw(playerid, 253.399841, 215.993835, "Increases damage by 50%");
	PlayerTextDrawLetterSize(playerid, EqInfModStat[playerid][0], 0.200666, 0.894814);
	PlayerTextDrawAlignment(playerid, EqInfModStat[playerid][0], 1);
	PlayerTextDrawColor(playerid, EqInfModStat[playerid][0], 16711935);
	PlayerTextDrawSetShadow(playerid, EqInfModStat[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, EqInfModStat[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfModStat[playerid][0], 51);
	PlayerTextDrawFont(playerid, EqInfModStat[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, EqInfModStat[playerid][0], 1);

	EqInfModStat[playerid][1] = CreatePlayerTextDraw(playerid, 253.466476, 223.879959, "Bonus 2");
	PlayerTextDrawLetterSize(playerid, EqInfModStat[playerid][1], 0.200666, 0.894814);
	PlayerTextDrawAlignment(playerid, EqInfModStat[playerid][1], 1);
	PlayerTextDrawColor(playerid, EqInfModStat[playerid][1], 16711935);
	PlayerTextDrawSetShadow(playerid, EqInfModStat[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, EqInfModStat[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfModStat[playerid][1], 51);
	PlayerTextDrawFont(playerid, EqInfModStat[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, EqInfModStat[playerid][1], 1);

	EqInfModStat[playerid][2] = CreatePlayerTextDraw(playerid, 253.566345, 231.392700, "Bonus 3");
	PlayerTextDrawLetterSize(playerid, EqInfModStat[playerid][2], 0.200666, 0.894814);
	PlayerTextDrawAlignment(playerid, EqInfModStat[playerid][2], 1);
	PlayerTextDrawColor(playerid, EqInfModStat[playerid][2], 16711935);
	PlayerTextDrawSetShadow(playerid, EqInfModStat[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, EqInfModStat[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfModStat[playerid][2], 51);
	PlayerTextDrawFont(playerid, EqInfModStat[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, EqInfModStat[playerid][2], 1);

	EqInfModStat[playerid][3] = CreatePlayerTextDraw(playerid, 253.599548, 238.822448, "Bonus 4");
	PlayerTextDrawLetterSize(playerid, EqInfModStat[playerid][3], 0.200666, 0.894814);
	PlayerTextDrawAlignment(playerid, EqInfModStat[playerid][3], 1);
	PlayerTextDrawColor(playerid, EqInfModStat[playerid][3], 16711935);
	PlayerTextDrawSetShadow(playerid, EqInfModStat[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, EqInfModStat[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfModStat[playerid][3], 51);
	PlayerTextDrawFont(playerid, EqInfModStat[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, EqInfModStat[playerid][3], 1);

	EqInfDelim4[playerid] = CreatePlayerTextDraw(playerid, 248.366043, 250.118347, "inf_delim4");
	PlayerTextDrawLetterSize(playerid, EqInfDelim4[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, EqInfDelim4[playerid], 137.866516, 2.405925);
	PlayerTextDrawAlignment(playerid, EqInfDelim4[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim4[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, EqInfDelim4[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim4[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim4[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim4[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfDescriptionStr[playerid][0] = CreatePlayerTextDraw(playerid, 319.433380, 254.530380, "[Description string 1]");
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][0], 0.167666, 0.749629);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][0], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][0], 51);
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][0], 1);

	EqInfDescriptionStr[playerid][1] = CreatePlayerTextDraw(playerid, 319.400115, 264.200103, "[Description string 2]");
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][1], 0.167666, 0.749629);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][1], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][1], 51);
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][1], 1);

	EqInfDescriptionStr[playerid][2] = CreatePlayerTextDraw(playerid, 319.633575, 274.035766, "[Description string 3]");
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][2], 0.167666, 0.749629);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][2], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][2], 51);
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][2], 1);

	EqInfDelim5[playerid] = CreatePlayerTextDraw(playerid, 248.532775, 286.045776, "inf_delim5");
	PlayerTextDrawLetterSize(playerid, EqInfDelim5[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, EqInfDelim5[playerid], 137.866516, 2.405925);
	PlayerTextDrawAlignment(playerid, EqInfDelim5[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim5[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, EqInfDelim5[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim5[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim5[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim5[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfPrice[playerid] = CreatePlayerTextDraw(playerid, 385.366790, 289.913970, "Price: 9999999999$");
	PlayerTextDrawLetterSize(playerid, EqInfPrice[playerid], 0.234000, 1.069036);
	PlayerTextDrawAlignment(playerid, EqInfPrice[playerid], 3);
	PlayerTextDrawColor(playerid, EqInfPrice[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfPrice[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfPrice[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfPrice[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfPrice[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfPrice[playerid], 1);

	InfBox[playerid] = CreatePlayerTextDraw(playerid, 389.000030, 151.248153, "inf_box");
	PlayerTextDrawLetterSize(playerid, InfBox[playerid], 0.000000, 10.677566);
	PlayerTextDrawTextSize(playerid, InfBox[playerid], 249.333328, 0.000000);
	PlayerTextDrawAlignment(playerid, InfBox[playerid], 1);
	PlayerTextDrawColor(playerid, InfBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, InfBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, InfBox[playerid], 102);
	PlayerTextDrawSetShadow(playerid, InfBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfBox[playerid], 0);
	PlayerTextDrawFont(playerid, InfBox[playerid], 0);

	InfTxt1[playerid] = CreatePlayerTextDraw(playerid, 319.833190, 150.702148, "����������");
	PlayerTextDrawLetterSize(playerid, InfTxt1[playerid], 0.251999, 0.903110);
	PlayerTextDrawAlignment(playerid, InfTxt1[playerid], 2);
	PlayerTextDrawColor(playerid, InfTxt1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, InfTxt1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfTxt1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, InfTxt1[playerid], 51);
	PlayerTextDrawFont(playerid, InfTxt1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, InfTxt1[playerid], 1);

	InfDelim1[playerid] = CreatePlayerTextDraw(playerid, 250.666656, 160.575088, "inf_delim1");
	PlayerTextDrawLetterSize(playerid, InfDelim1[playerid], 0.000000, -0.233333);
	PlayerTextDrawTextSize(playerid, InfDelim1[playerid], 136.326660, 2.200000);
	PlayerTextDrawAlignment(playerid, InfDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, InfDelim1[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, InfDelim1[playerid], true);
	PlayerTextDrawBoxColor(playerid, InfDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, InfDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, InfDelim1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, InfDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, InfDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	InfItemIcon[playerid] = CreatePlayerTextDraw(playerid, 255.000000, 175.000000, "inf_itemicon");
	PlayerTextDrawLetterSize(playerid, InfItemIcon[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, InfItemIcon[playerid], 24.000000, 24.888885);
	PlayerTextDrawAlignment(playerid, InfItemIcon[playerid], 1);
	PlayerTextDrawColor(playerid, InfItemIcon[playerid], -1);
	PlayerTextDrawUseBox(playerid, InfItemIcon[playerid], true);
	PlayerTextDrawBoxColor(playerid, InfItemIcon[playerid], 0);
	PlayerTextDrawSetShadow(playerid, InfItemIcon[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfItemIcon[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemIcon[playerid], -1378294017);
	PlayerTextDrawFont(playerid, InfItemIcon[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, InfItemIcon[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, InfItemIcon[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	InfItemName[playerid] = CreatePlayerTextDraw(playerid, 320.166534, 164.805816, "Shazok's document");
	PlayerTextDrawLetterSize(playerid, InfItemName[playerid], 0.221333, 0.865777);
	PlayerTextDrawAlignment(playerid, InfItemName[playerid], 2);
	PlayerTextDrawColor(playerid, InfItemName[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, InfItemName[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfItemName[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemName[playerid], 51);
	PlayerTextDrawFont(playerid, InfItemName[playerid], 1);
	PlayerTextDrawSetProportional(playerid, InfItemName[playerid], 1);

	InfItemType[playerid] = CreatePlayerTextDraw(playerid, 282.899749, 176.093154, "Passive item");
	PlayerTextDrawLetterSize(playerid, InfItemType[playerid], 0.221333, 0.865777);
	PlayerTextDrawAlignment(playerid, InfItemType[playerid], 1);
	PlayerTextDrawColor(playerid, InfItemType[playerid], -1);
	PlayerTextDrawSetShadow(playerid, InfItemType[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfItemType[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemType[playerid], 51);
	PlayerTextDrawFont(playerid, InfItemType[playerid], 1);
	PlayerTextDrawSetProportional(playerid, InfItemType[playerid], 1);

	InfItemEffect[playerid][0] = CreatePlayerTextDraw(playerid, 282.866516, 187.131805, "Decreases required rank for equip by 1");
	PlayerTextDrawLetterSize(playerid, InfItemEffect[playerid][0], 0.167666, 0.749629);
	PlayerTextDrawAlignment(playerid, InfItemEffect[playerid][0], 1);
	PlayerTextDrawColor(playerid, InfItemEffect[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, InfItemEffect[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, InfItemEffect[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemEffect[playerid][0], 51);
	PlayerTextDrawFont(playerid, InfItemEffect[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, InfItemEffect[playerid][0], 1);

	InfItemEffect[playerid][1] = CreatePlayerTextDraw(playerid, 282.866546, 193.939468, "Damage +25%");
	PlayerTextDrawLetterSize(playerid, InfItemEffect[playerid][1], 0.167666, 0.749629);
	PlayerTextDrawAlignment(playerid, InfItemEffect[playerid][1], 1);
	PlayerTextDrawColor(playerid, InfItemEffect[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, InfItemEffect[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, InfItemEffect[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemEffect[playerid][1], 51);
	PlayerTextDrawFont(playerid, InfItemEffect[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InfItemEffect[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, InfItemEffect[playerid][1], 19134);
	PlayerTextDrawSetPreviewRot(playerid, InfItemEffect[playerid][1], 0.000000, 0.000000, 90.000000, 1.000000);

	InfDelim2[playerid] = CreatePlayerTextDraw(playerid, 251.033248, 204.010681, "inf_delim2");
	PlayerTextDrawLetterSize(playerid, InfDelim2[playerid], 0.000000, -0.233333);
	PlayerTextDrawTextSize(playerid, InfDelim2[playerid], 137.000000, 2.200000);
	PlayerTextDrawAlignment(playerid, InfDelim2[playerid], 1);
	PlayerTextDrawColor(playerid, InfDelim2[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, InfDelim2[playerid], true);
	PlayerTextDrawBoxColor(playerid, InfDelim2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, InfDelim2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfDelim2[playerid], 0);
	PlayerTextDrawFont(playerid, InfDelim2[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, InfDelim2[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, InfDelim2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	InfDescriptionStr[playerid][0] = CreatePlayerTextDraw(playerid, 320.033020, 209.909637, "Description string 1");
	PlayerTextDrawLetterSize(playerid, InfDescriptionStr[playerid][0], 0.167666, 0.749629);
	PlayerTextDrawAlignment(playerid, InfDescriptionStr[playerid][0], 2);
	PlayerTextDrawColor(playerid, InfDescriptionStr[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, InfDescriptionStr[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, InfDescriptionStr[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, InfDescriptionStr[playerid][0], 51);
	PlayerTextDrawFont(playerid, InfDescriptionStr[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, InfDescriptionStr[playerid][0], 1);

	InfDescriptionStr[playerid][1] = CreatePlayerTextDraw(playerid, 319.999633, 217.297683, "Description string 2");
	PlayerTextDrawLetterSize(playerid, InfDescriptionStr[playerid][1], 0.167666, 0.749629);
	PlayerTextDrawAlignment(playerid, InfDescriptionStr[playerid][1], 2);
	PlayerTextDrawColor(playerid, InfDescriptionStr[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, InfDescriptionStr[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, InfDescriptionStr[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, InfDescriptionStr[playerid][1], 51);
	PlayerTextDrawFont(playerid, InfDescriptionStr[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InfDescriptionStr[playerid][1], 1);

	InfDescriptionStr[playerid][2] = CreatePlayerTextDraw(playerid, 320.032867, 224.644271, "Description string 3");
	PlayerTextDrawLetterSize(playerid, InfDescriptionStr[playerid][2], 0.167666, 0.749629);
	PlayerTextDrawAlignment(playerid, InfDescriptionStr[playerid][2], 2);
	PlayerTextDrawColor(playerid, InfDescriptionStr[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, InfDescriptionStr[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, InfDescriptionStr[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, InfDescriptionStr[playerid][2], 51);
	PlayerTextDrawFont(playerid, InfDescriptionStr[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, InfDescriptionStr[playerid][2], 1);

	InfDelim3[playerid] = CreatePlayerTextDraw(playerid, 250.733505, 235.624023, "inf_delim3");
	PlayerTextDrawLetterSize(playerid, InfDelim3[playerid], 0.000000, -0.116666);
	PlayerTextDrawTextSize(playerid, InfDelim3[playerid], 137.000000, 2.200000);
	PlayerTextDrawAlignment(playerid, InfDelim3[playerid], 1);
	PlayerTextDrawColor(playerid, InfDelim3[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, InfDelim3[playerid], true);
	PlayerTextDrawBoxColor(playerid, InfDelim3[playerid], 0);
	PlayerTextDrawSetShadow(playerid, InfDelim3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfDelim3[playerid], 0);
	PlayerTextDrawFont(playerid, InfDelim3[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, InfDelim3[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, InfDelim3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	InfPrice[playerid] = CreatePlayerTextDraw(playerid, 385.499847, 238.776184, "Price: 999999999$");
	PlayerTextDrawLetterSize(playerid, InfPrice[playerid], 0.221333, 0.865777);
	PlayerTextDrawAlignment(playerid, InfPrice[playerid], 3);
	PlayerTextDrawColor(playerid, InfPrice[playerid], -1);
	PlayerTextDrawSetShadow(playerid, InfPrice[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfPrice[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, InfPrice[playerid], 51);
	PlayerTextDrawFont(playerid, InfPrice[playerid], 1);
	PlayerTextDrawSetProportional(playerid, InfPrice[playerid], 1);

	InfClose[playerid] = CreatePlayerTextDraw(playerid, 382.366668, 148.586669, "x");
	PlayerTextDrawLetterSize(playerid, InfClose[playerid], 0.354333, 1.272295);
	PlayerTextDrawTextSize(playerid, InfClose[playerid], 12.333333, 4.977777);
	PlayerTextDrawAlignment(playerid, InfClose[playerid], 2);
	PlayerTextDrawColor(playerid, InfClose[playerid], -2147483393);
	PlayerTextDrawUseBox(playerid, InfClose[playerid], true);
	PlayerTextDrawBoxColor(playerid, InfClose[playerid], 0);
	PlayerTextDrawSetShadow(playerid, InfClose[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfClose[playerid], 1);
	PlayerTextDrawFont(playerid, InfClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, InfClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, InfClose[playerid], true);
	PlayerTextDrawBackgroundColor(playerid, InfClose[playerid], 0x0000000);

	UpgBox[playerid] = CreatePlayerTextDraw(playerid, 383.666778, 153.737030, "upg_box");
	PlayerTextDrawLetterSize(playerid, UpgBox[playerid], 0.000000, 10.753333);
	PlayerTextDrawTextSize(playerid, UpgBox[playerid], 255.666656, 0.000000);
	PlayerTextDrawAlignment(playerid, UpgBox[playerid], 1);
	PlayerTextDrawColor(playerid, UpgBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, UpgBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgBox[playerid], 102);
	PlayerTextDrawSetShadow(playerid, UpgBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgBox[playerid], 0);
	PlayerTextDrawFont(playerid, UpgBox[playerid], 0);

	UpgTxt1[playerid] = CreatePlayerTextDraw(playerid, 320.166687, 153.481506, "�����������");
	PlayerTextDrawLetterSize(playerid, UpgTxt1[playerid], 0.267666, 1.044148);
	PlayerTextDrawAlignment(playerid, UpgTxt1[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgTxt1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt1[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt1[playerid], 1);

	UpgDelim1[playerid] = CreatePlayerTextDraw(playerid, 256.966674, 163.727508, "upg_delim1");
	PlayerTextDrawLetterSize(playerid, UpgDelim1[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, UpgDelim1[playerid], 124.566665, 2.200000);
	PlayerTextDrawAlignment(playerid, UpgDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, UpgDelim1[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, UpgDelim1[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, UpgDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, UpgDelim1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, UpgDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, UpgDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	UpgModInfo[playerid] = CreatePlayerTextDraw(playerid, 320.066711, 176.425201, "7 modification");
	PlayerTextDrawLetterSize(playerid, UpgModInfo[playerid], 0.245666, 0.919703);
	PlayerTextDrawAlignment(playerid, UpgModInfo[playerid], 2);
	PlayerTextDrawColor(playerid, UpgModInfo[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgModInfo[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgModInfo[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgModInfo[playerid], 51);
	PlayerTextDrawFont(playerid, UpgModInfo[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgModInfo[playerid], 1);

	UpgItemSlot[playerid] = CreatePlayerTextDraw(playerid, 305.100158, 193.345382, "item_slot");
	PlayerTextDrawLetterSize(playerid, UpgItemSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, UpgItemSlot[playerid], 30.000000, 30.000000);
	PlayerTextDrawAlignment(playerid, UpgItemSlot[playerid], 1);
	PlayerTextDrawColor(playerid, UpgItemSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, UpgItemSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgItemSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, UpgItemSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgItemSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], -1378294017);
	PlayerTextDrawFont(playerid, UpgItemSlot[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, UpgItemSlot[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	UpgTxt2[playerid] = CreatePlayerTextDraw(playerid, 320.500091, 225.543746, "�������");
	PlayerTextDrawLetterSize(playerid, UpgTxt2[playerid], 0.189999, 0.766222);
	PlayerTextDrawAlignment(playerid, UpgTxt2[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgTxt2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt2[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt2[playerid], 1);

	UpgStoneSlot[playerid] = CreatePlayerTextDraw(playerid, 271.533660, 203.217758, "stone_slot");
	PlayerTextDrawLetterSize(playerid, UpgStoneSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, UpgStoneSlot[playerid], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, UpgStoneSlot[playerid], 1);
	PlayerTextDrawColor(playerid, UpgStoneSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, UpgStoneSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgStoneSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, UpgStoneSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgStoneSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgStoneSlot[playerid], -1378294017);
	PlayerTextDrawFont(playerid, UpgStoneSlot[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, UpgStoneSlot[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, UpgStoneSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgStoneSlot[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	UpgTxt3[playerid] = CreatePlayerTextDraw(playerid, 282.066864, 224.967407, "������");
	PlayerTextDrawLetterSize(playerid, UpgTxt3[playerid], 0.189999, 0.766222);
	PlayerTextDrawAlignment(playerid, UpgTxt3[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt3[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgTxt3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt3[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt3[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt3[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt3[playerid], 1);

	UpgPotionSlot[playerid] = CreatePlayerTextDraw(playerid, 347.999938, 204.199996, "potion_slot");
	PlayerTextDrawLetterSize(playerid, UpgPotionSlot[playerid], 0.000000, 0.033333);
	PlayerTextDrawTextSize(playerid, UpgPotionSlot[playerid], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, UpgPotionSlot[playerid], 1);
	PlayerTextDrawColor(playerid, UpgPotionSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, UpgPotionSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgPotionSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, UpgPotionSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgPotionSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgPotionSlot[playerid], -1378294017);
	PlayerTextDrawFont(playerid, UpgPotionSlot[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, UpgPotionSlot[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, UpgPotionSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgPotionSlot[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	UpgTxt4[playerid] = CreatePlayerTextDraw(playerid, 358.533477, 225.677017, "�������");
	PlayerTextDrawLetterSize(playerid, UpgTxt4[playerid], 0.189999, 0.766222);
	PlayerTextDrawAlignment(playerid, UpgTxt4[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt4[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgTxt4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt4[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt4[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt4[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt4[playerid], 1);

	UpgBtn[playerid] = CreatePlayerTextDraw(playerid, 320.200012, 235.905120, "��������");
	PlayerTextDrawLetterSize(playerid, UpgBtn[playerid], 0.275332, 1.060739);
	PlayerTextDrawTextSize(playerid, UpgBtn[playerid], 15.033336, 99.389656);
	PlayerTextDrawAlignment(playerid, UpgBtn[playerid], 2);
	PlayerTextDrawColor(playerid, UpgBtn[playerid], 255);
	PlayerTextDrawUseBox(playerid, UpgBtn[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgBtn[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, UpgBtn[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgBtn[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgBtn[playerid], 0x00000000);
	PlayerTextDrawFont(playerid, UpgBtn[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgBtn[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, UpgBtn[playerid], true);

	UpgClose[playerid] = CreatePlayerTextDraw(playerid, 377.066680, 151.780822, "x");
	PlayerTextDrawLetterSize(playerid, UpgClose[playerid], 0.347000, 1.243258);
	PlayerTextDrawTextSize(playerid, UpgClose[playerid], 8.000000, 4.562961);
	PlayerTextDrawAlignment(playerid, UpgClose[playerid], 2);
	PlayerTextDrawColor(playerid, UpgClose[playerid], -2147483393);
	PlayerTextDrawUseBox(playerid, UpgClose[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgClose[playerid], 0);
	PlayerTextDrawSetShadow(playerid, UpgClose[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgClose[playerid], 1);
	PlayerTextDrawFont(playerid, UpgClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, UpgClose[playerid], true);
	PlayerTextDrawBackgroundColor(playerid, UpgClose[playerid], 0x00000000);

	PvpPanelBox[playerid] = CreatePlayerTextDraw(playerid, 164.000000, 274.448150, "box");
	PlayerTextDrawLetterSize(playerid, PvpPanelBox[playerid], 0.000000, 16.460287);
	PlayerTextDrawTextSize(playerid, PvpPanelBox[playerid], 6.666666, 0.000000);
	PlayerTextDrawAlignment(playerid, PvpPanelBox[playerid], 1);
	PlayerTextDrawColor(playerid, PvpPanelBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, PvpPanelBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, PvpPanelBox[playerid], 102);
	PlayerTextDrawSetShadow(playerid, PvpPanelBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PvpPanelBox[playerid], 0);
	PlayerTextDrawFont(playerid, PvpPanelBox[playerid], 0);

	PvpPanelHeader[playerid] = CreatePlayerTextDraw(playerid, 42.099964, 296.136383, "������� ���");
	PlayerTextDrawLetterSize(playerid, PvpPanelHeader[playerid], 0.449999, 1.600000);
	PlayerTextDrawAlignment(playerid, PvpPanelHeader[playerid], 1);
	PlayerTextDrawColor(playerid, PvpPanelHeader[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, PvpPanelHeader[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PvpPanelHeader[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, PvpPanelHeader[playerid], 51);
	PlayerTextDrawFont(playerid, PvpPanelHeader[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PvpPanelHeader[playerid], 1);

	PvpPanelTimer[playerid] = CreatePlayerTextDraw(playerid, 63.533309, 274.731781, "03:00");
	PlayerTextDrawLetterSize(playerid, PvpPanelTimer[playerid], 0.454333, 2.197332);
	PlayerTextDrawAlignment(playerid, PvpPanelTimer[playerid], 1);
	PlayerTextDrawColor(playerid, PvpPanelTimer[playerid], -1);
	PlayerTextDrawSetShadow(playerid, PvpPanelTimer[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PvpPanelTimer[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, PvpPanelTimer[playerid], 51);
	PlayerTextDrawFont(playerid, PvpPanelTimer[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PvpPanelTimer[playerid], 1);

	new Float:name_y = 320.1;
	new Float:score_y = 320.4;
	for(new i = 0; i < MAX_PVP_PANEL_ITEMS; i++)
	{
		PvpPanelNameLabels[playerid][i] = CreatePlayerTextDraw(playerid, 14.699981, name_y, " ");
		PlayerTextDrawLetterSize(playerid, PvpPanelNameLabels[playerid][i], 0.292666, 1.268148);
		PlayerTextDrawAlignment(playerid, PvpPanelNameLabels[playerid][i], 1);
		PlayerTextDrawColor(playerid, PvpPanelNameLabels[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, PvpPanelNameLabels[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, PvpPanelNameLabels[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, PvpPanelNameLabels[playerid][i], 51);
		PlayerTextDrawFont(playerid, PvpPanelNameLabels[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PvpPanelNameLabels[playerid][i], 1);

		PvpPanelScoreLabels[playerid][i] = CreatePlayerTextDraw(playerid, 128.066635, score_y, " ");
		PlayerTextDrawLetterSize(playerid, PvpPanelScoreLabels[playerid][i], 0.292666, 1.268148);
		PlayerTextDrawAlignment(playerid, PvpPanelScoreLabels[playerid][i], 1);
		PlayerTextDrawColor(playerid, PvpPanelScoreLabels[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid, PvpPanelScoreLabels[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid, PvpPanelScoreLabels[playerid][i], 1);
		PlayerTextDrawBackgroundColor(playerid, PvpPanelScoreLabels[playerid][i], 51);
		PlayerTextDrawFont(playerid, PvpPanelScoreLabels[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, PvpPanelScoreLabels[playerid][i], 1);

		name_y += 15.0;
		score_y += 15.0;
	}

	PvpPanelDelim[playerid] = CreatePlayerTextDraw(playerid, 8.399996, 398.471099, "delim");
	PlayerTextDrawLetterSize(playerid, PvpPanelDelim[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PvpPanelDelim[playerid], 153.666671, 4.562957);
	PlayerTextDrawAlignment(playerid, PvpPanelDelim[playerid], 1);
	PlayerTextDrawColor(playerid, PvpPanelDelim[playerid], -5963521);
	PlayerTextDrawUseBox(playerid, PvpPanelDelim[playerid], true);
	PlayerTextDrawBoxColor(playerid, PvpPanelDelim[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PvpPanelDelim[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, PvpPanelDelim[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PvpPanelDelim[playerid], 0);
	PlayerTextDrawFont(playerid, PvpPanelDelim[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, PvpPanelDelim[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, PvpPanelDelim[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	PvpPanelMyName[playerid] = CreatePlayerTextDraw(playerid, 14.699000, 406.053466, " ");
	PlayerTextDrawLetterSize(playerid, PvpPanelMyName[playerid], 0.292665, 1.268146);
	PlayerTextDrawAlignment(playerid, PvpPanelMyName[playerid], 1);
	PlayerTextDrawColor(playerid, PvpPanelMyName[playerid], -1);
	PlayerTextDrawSetShadow(playerid, PvpPanelMyName[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PvpPanelMyName[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, PvpPanelMyName[playerid], 51);
	PlayerTextDrawFont(playerid, PvpPanelMyName[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PvpPanelMyName[playerid], 1);

	PvpPanelMyScore[playerid] = CreatePlayerTextDraw(playerid, 128.066635, 406.053466, " ");
	PlayerTextDrawLetterSize(playerid, PvpPanelMyScore[playerid], 0.292665, 1.268146);
	PlayerTextDrawAlignment(playerid, PvpPanelMyScore[playerid], 1);
	PlayerTextDrawColor(playerid, PvpPanelMyScore[playerid], -1);
	PlayerTextDrawSetShadow(playerid, PvpPanelMyScore[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PvpPanelMyScore[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, PvpPanelMyScore[playerid], 51);
	PlayerTextDrawFont(playerid, PvpPanelMyScore[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PvpPanelMyScore[playerid], 1);
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
	PlayerTextDrawDestroy(playerid, ChrInfoDelim1[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDelim2[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDelim3[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDelim4[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfButMod[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfButDel[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfButInfo[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfButUse[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfPersonalRate[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfText1[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfText2[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfRate[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfAllRate[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfClose[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfAccSlot2[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfAccSlot1[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDodge[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfAccuracy[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDefense[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDamage[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfMaxHP[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoHeader[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoBox[playerid]);
	PlayerTextDrawDestroy(playerid, HPBar[playerid]);
	for(new i = 0; i < MAX_SLOTS; i++)
	{
		PlayerTextDrawDestroy(playerid, ChrInfInvSlot[playerid][i]);
		PlayerTextDrawDestroy(playerid, ChrInfInvSlotCount[playerid][i]);
	}

	PlayerTextDrawDestroy(playerid, EqInfBox[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfTxt1[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfTxt2[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfClose[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim1[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfItemName[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfItemIcon[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfMainStat[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim2[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim3[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim4[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim5[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfPrice[playerid]);
	for(new i = 0; i < 2; i++)
	{
		PlayerTextDrawDestroy(playerid, EqInfBonusStat[playerid][i]);
	}
	for(new i = 0; i < 3; i++)
	{
		PlayerTextDrawDestroy(playerid, EqInfDescriptionStr[playerid][i]);
	}
	for(new i = 0; i < 4; i++)
	{
		PlayerTextDrawDestroy(playerid, EqInfModStat[playerid][i]);
	}
	for(new i = 0; i < MAX_MOD; i++)
	{
		PlayerTextDrawDestroy(playerid, EqInfMod[playerid][i]);
	}

	PlayerTextDrawDestroy(playerid, InfClose[playerid]);
	PlayerTextDrawDestroy(playerid, InfPrice[playerid]);
	PlayerTextDrawDestroy(playerid, InfDelim1[playerid]);
	PlayerTextDrawDestroy(playerid, InfDelim2[playerid]);
	PlayerTextDrawDestroy(playerid, InfDelim3[playerid]);
	PlayerTextDrawDestroy(playerid, InfItemEffect[playerid][0]);
	PlayerTextDrawDestroy(playerid, InfItemEffect[playerid][1]);
	PlayerTextDrawDestroy(playerid, InfItemType[playerid]);
	PlayerTextDrawDestroy(playerid, InfItemName[playerid]);
	PlayerTextDrawDestroy(playerid, InfItemIcon[playerid]);
	PlayerTextDrawDestroy(playerid, InfTxt1[playerid]);
	PlayerTextDrawDestroy(playerid, InfBox[playerid]);
	for(new i = 0; i < 3; i++)
	{
		PlayerTextDrawDestroy(playerid, InfDescriptionStr[playerid][i]);
	}

	PlayerTextDrawDestroy(playerid, UpgClose[playerid]);
	PlayerTextDrawDestroy(playerid, UpgTxt1[playerid]);
	PlayerTextDrawDestroy(playerid, UpgTxt2[playerid]);
	PlayerTextDrawDestroy(playerid, UpgTxt3[playerid]);
	PlayerTextDrawDestroy(playerid, UpgTxt4[playerid]);
	PlayerTextDrawDestroy(playerid, UpgBtn[playerid]);
	PlayerTextDrawDestroy(playerid, UpgPotionSlot[playerid]);
	PlayerTextDrawDestroy(playerid, UpgStoneSlot[playerid]);
	PlayerTextDrawDestroy(playerid, UpgItemSlot[playerid]);
	PlayerTextDrawDestroy(playerid, UpgModInfo[playerid]);
	PlayerTextDrawDestroy(playerid, UpgDelim1[playerid]);
	PlayerTextDrawDestroy(playerid, UpgBox[playerid]);
}

stock CreatePickups()
{
    home_enter = CreatePickup(1318,23,224.0201,-1837.3518,4.2787);
    home_quit = CreatePickup(1318,23,-2158.6240,642.8425,1052.3750);
    boss_tp = CreatePickup(19605,23,243.1539,-1831.6542,3.3772); //tp1
    arena_tp = CreatePickup(19607,23,204.7617,-1831.6539,3.3772); //tp2
    
    Create3DTextLabel("��� �������",0xf2622bFF,224.0201,-1837.3518,4.2787,70.0,0,1);
    Create3DTextLabel("� ������",0xeaeaeaFF,243.1539,-1831.6542,3.9772,70.0,0,1);
    Create3DTextLabel("�� �����",0xeaeaeaFF,204.7617,-1831.6539,4.1772,70.0,0,1);
    Create3DTextLabel("����� ������",0xFFCC00FF,-2171.3132,645.5896,1053.3817,10.0,0,1);
    Create3DTextLabel("�������� ������������",0xFFCC00FF,-2166.7527,646.0400,1052.3750,55.0,0,1);
	Create3DTextLabel("���������",0xFFCC00FF,189.2644,-1825.4902,4.1411,55.0,0,1);
	Create3DTextLabel("�������",0xFFCC00FF,262.6658,-1825.2792,3.9126,55.0,0,1);
	Create3DTextLabel("������",0x9933CCFF,221.0985,-1838.1259,3.6268,55.0,0,1);
	Create3DTextLabel("���������� ���������",0x3366FFFF,226.7674,-1837.6835,3.6120,55.0,0,1);
	Create3DTextLabel("�����",0x3366CCFF,212.3999,-1838.2000,3.0000,55.0,0,0);

	Actors[0] =	CreateActor(26,-2166.7527,646.0400,1052.3750,179.9041);
	Actors[1] =	CreateActor(6,189.2644,-1825.4902,4.1411,185.0134);
	Actors[2] =	CreateActor(60,262.6658,-1825.2792,3.9126,181.2770);
	Actors[3] =	CreateActor(5,221.0985,-1838.1259,3.6268,177.8066);
	Actors[4] =	CreateActor(61,226.7674,-1837.6835,3.6120,188.3151);
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
	CreateObject(1291,212.3999900,-1838.2000000,3.0000000,0.0000000,0.0000000,270.0000000); //object(postbox1) (1)
}
