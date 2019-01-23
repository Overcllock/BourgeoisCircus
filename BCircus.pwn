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

//Colors
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_BLACK 0x000000FF
#define COLOR_RED 0xFF0000FF
#define COLOR_GREEN 0x00FF00FF
#define COLOR_GREY 0xCCCCCCFF
#define COLOR_BLUE 0x0066CCFF
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_LIGHTRED 0xFF6347FF

//Limits
#define MAX_HP 100.00
#define MAX_RATE 3000
#define MAX_SLOTS 16
#define MAX_MOD 7
#define MAX_PROPERTIES 2
#define MAX_CL_ACTORS 4
#define MAX_CLOWNS 20
#define MAX_TRANSPORT 6
#define MAX_PVP_PLAYERS 30
#define MAX_RELIABLE_TARGETS 5
#define MAX_PVP_PANEL_ITEMS 5

//Player params
#define PARAM_DAMAGE 0
#define PARAM_DEFENSE 1
#define PARAM_DODGE 2
#define PARAM_ACCURACY 3
#define PARAM_CRITICAL_CHANCE 4

//Item types
#define ITEMTYPE_WEAPON 1
#define ITEMTYPE_ARMOR 2
#define ITEMTYPE_AMULET 3
#define ITEMTYPE_RING 4
#define ITEMTYPE_PASSIVE 5
#define ITEMTYPE_MATERIAL 6
#define ITEMTYPE_BOX 7

//Item grades
#define GRADE_N 1
#define GRADE_B 2
#define GRADE_C 3

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
#define MOD_DEFENCE 2
#define MOD_DODGE 3
#define MOD_ACCURACY 4

//Other
#define NPC_TICKRATE 15
#define VERSION 1.0

//Forwards
forward OnPlayerLogin(playerid);
forward Time();
forward UpdatePlayer(playerid);
forward UpdatePvpPlayers();
forward UpdatePvpTable();
forward StopPvp();
forward ReadyTimerTick();
forward Float:GetDistanceBetweenPlayers(p1,p2);
forward RegenerateHealth(playerid);

//Varialbles
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
	Wins,
	Loses,
	Damage,
	Defense,
	Dodge,
	Accuracy,
	TopPosition,
	CriticalChance
};
new PlayerInfo[MAX_PLAYERS][pInfo];
new PlayerUpdater[MAX_PLAYERS];
new currentTour = 1;
new SelectedSlot[MAX_PLAYERS] = -1;
new bool:IsInventoryOpen[MAX_PLAYERS] = false;
new bool:IsDeath[MAX_PLAYERS] = false;
new Actors[MAX_CL_ACTORS];
new bool:PlayerConnect[MAX_PLAYERS] = false;
new Transport[MAX_TRANSPORT];
new bool:IsBattleBegins = false;
new bool:IsReady[MAX_PLAYERS] = false;
new bool:IsEntered[MAX_PLAYERS] = false;
new bool:IsMatchRunned = false;
//Pvp
new PlayerText:PvpPanelBox[MAX_PLAYERS];
new PlayerText:PvpPanelHeader[MAX_PLAYERS];
new PlayerText:PvpPanelTimer[MAX_PLAYERS];
new PlayerText:PvpPanelNameLabels[MAX_PLAYERS][MAX_PVP_PANEL_ITEMS];
new PlayerText:PvpPanelScoreLabels[MAX_PLAYERS][MAX_PVP_PANEL_ITEMS];

new InitID = -1;
new bool:IsPvpStarted = false;
new Text3D:NPCName[MAX_PLAYERS];
new NPCs[MAX_PVP_PLAYERS];
new NPCKills[MAX_PLAYERS];
new NPCDeaths[MAX_PLAYERS];
new CheckTimer[MAX_PLAYERS];
new PvpTableUpdTimer = -1;
new StopPvpTimer = -1;
new RegenTimer[MAX_PLAYERS];
enum PvpResItem
{
	Name[128],
	Float:Score
};
new PvpRes[MAX_PVP_PLAYERS][PvpResItem];
//
new npcclowns[MAX_PVP_PLAYERS][128] = {
	{"Xion"},
	{"Citan"},
	{"Avilione"},
	{"K_G"},
	{"Remainer"},
	{"Adamantium_Cat"},
	{"Annitta"},
	{"Tim_Faters"},
	{"Rakudai"},
	{"Firecaster"},
	{"Powersturbo"},
	{"Gynes"},
	{"Sterneneisen"},
	{"Shichisu"},
	{"Water"},
	{"Des_Mayoko"},
	{"Maddoshi"},
	{"Ringshu"},
	{"Exiseon"},
	{"Little_Mousy"},
	{"Flexchuits"},
	{"Akeafar"},
	{"Waitmebabby"},
	{"Bloodvinserex"},
	{"Heizou"},
	{"Naomich"},
	{"Aspa"},
	{"Chock"},
	{"Chipsek"},
	{"Ognesvin"}
};
new Registration[2] = { -1, -1 };
new MatchTimer;
new ReadyTimerTicks;
enum TopItem
{
	Name[128],
	Class[64],
	Rate
};
new RatingTop[MAX_PVP_PLAYERS][TopItem];

new Text:WorldTime;
new WorldTime_Timer;
new Text:GamemodeName;

new PlayerText:TourPanelBox[MAX_PLAYERS];
new PlayerText:TourPlayerName1[MAX_PLAYERS];
new PlayerText:TourPlayerName2[MAX_PLAYERS];
new PlayerText:HPBar[MAX_PLAYERS];
new PlayerText:TourScoreBar[MAX_PLAYERS];
new PlayerText:InvBox[MAX_PLAYERS];
new PlayerText:InvSlot[MAX_PLAYERS][MAX_SLOTS];
new PlayerText:PanelInfo[MAX_PLAYERS];
new PlayerText:PanelInventory[MAX_PLAYERS];
new PlayerText:PanelUndress[MAX_PLAYERS];
new PlayerText:PanelSwitch[MAX_PLAYERS];
new PlayerText:PanelBox[MAX_PLAYERS];
new PlayerText:PanelDelimeter1[MAX_PLAYERS];
new PlayerText:PanelDelimeter2[MAX_PLAYERS];
new PlayerText:PanelDelimeter3[MAX_PLAYERS];
new PlayerText:btn_use[MAX_PLAYERS];
new PlayerText:btn_info[MAX_PLAYERS];
new PlayerText:btn_del[MAX_PLAYERS];
new PlayerText:btn_quick[MAX_PLAYERS];
new PlayerText:blue_flag[MAX_PLAYERS];
new PlayerText:red_flag[MAX_PLAYERS];
new PlayerText:inv_ico[MAX_PLAYERS];
new PlayerText:InvSlotCount[MAX_PLAYERS][MAX_SLOTS];
new PlayerText:EBox[MAX_PLAYERS][MAX_EFFECTS];
new PlayerText:EBox_Time[MAX_PLAYERS][MAX_EFFECTS];
new PlayerText:SkillIco[MAX_PLAYERS][MAX_SKILLS];
new PlayerText:SkillButton[MAX_PLAYERS][MAX_SKILLS];
new PlayerText:SkillTime[MAX_PLAYERS][MAX_SKILLS];

//Bases
new DimakClowns[10][64] = {
	{"Dmitriy_Staroverov"},
	{"Irina_Novichkova"},
	{"Maxim_Loginov"},
	{"Olga_Tsurikova"},
	{"Lusi_Staroverova"},
	{"Stanislav_Tihov"},
	{"Vladimir_Skorkin"},
	{"Michail_Medvedik"},
	{"Alexander_Shaikin"},
	{"Michail_Edemsky"}
};
new VovakClowns[10][64] = {
	{"Alexander_Zhukov"},
	{"Tatyana_Cherusheva"},
	{"Arkadiy_Zharikov"},
	{"Vladimir_Zuev"},
	{"Ilya_Staroverov"},
	{"Larisa_Zueva"},
	{"Walter_White"},
	{"Andrey_Zhiganov"},
	{"Michail_Staroverov"},
	{"Michail_Krasyukov"}
};
new RateColors[9][16] = {
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
new HexRateColors[9][1] = {
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
new all_male_skins[11][1] = {
	{83},	
	{84},	
	{120},	
	{264},	
	{147},	
	{127},	
	{204},	
	{114},	
	{97},	
	{161},	
	{287}
};
new all_female_skins[11][1] = {
	{91},	
	{214},	
	{141},	
	{152},	
	{150},	
	{169},	
	{298},	
	{195},	
	{140},	
	{198},	
	{191}	
};
//Pickups
new home_enter;
new home_quit;
new adm_enter;
new adm_quit;
new cafe_enter;
new cafe_quit;
new rest_enter;
new rest_quit;
new shop_enter;
new shop_quit;
new start_tp1;
new start_tp2;

main()
{
	new str[64];
	format(str, sizeof(str), "Bourgeois Circus ver. %.2f", VERSION);
	print(str);
}

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
	for (new i = 0; i < MAX_CL_ACTORS; i++)
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
		SendClientMessage(playerid, COLOR_LIGHTRED, "Access denied.");
		if (PlayerConnect[playerid])
			OnPlayerDisconnect(playerid, 1);
		Kick(playerid);
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
	InitPlayerTextDraws(playerid);
	PlayerConnect[playerid] = true;
	SpawnPlayer(playerid);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
	ShowInterface(playerid);
	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;
}

public OnPlayerDisconnect(playerid, reason)
{
	KillTimer(PlayerUpdater[playerid]);
	SaveAccount(playerid);
	DeletePlayerTextDraws(playerid);
	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;
	for (new i = 0; i < 10; i++)
	    if (IsPlayerAttachedObjectSlotUsed(playerid, i))
	        RemovePlayerAttachedObject(playerid, i);
	PlayerConnect[playerid] = false;
	for (new i = 0; i < 2; i++)
	    if (Registration[i] == playerid)
	        Registration[i] = -1;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerHealth(playerid, MAX_HP);
	if (IsDeath[playerid]) {
	    IsDeath[playerid] = false;
	    SetPlayerInterior(playerid, 1);
	    SetPlayerPos(playerid, -2170.3948,645.6729,1057.5938);
	    SetPlayerFacingAngle(playerid, 180);
	}
	else {
	    SetPlayerInterior(playerid, PlayerInfo[playerid][Interior]);
		SetPlayerPos(playerid, PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ]);
		SetPlayerFacingAngle(playerid, PlayerInfo[playerid][FacingAngle]);
	}
	SetCameraBehindPlayer(playerid);
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	SetPlayerColor(playerid, GetHexColorByRate(PlayerInfo[playerid][Rate]));
	UpdateCharacter(playerid);
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
	SendClientMessageToAll(GetHexColorByRate(PlayerInfo[playerid][Rate]), message);
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new string[255];
	if (strcmp("/spawn", cmdtext, true, 10) == 0)
	{
	    SetPlayerPos(playerid, 224.0761,-1839.8217,3.6037);
	    SetPlayerInterior(playerid, 0);
		return 1;
	}
	if (strcmp("/kill", cmdtext, true, 10) == 0)
	{
	    SetPlayerHealthEx(playerid, 0);
		return 1;
	}
	if (strcmp("/arena1", cmdtext, true, 10) == 0)
	{
	    SetPlayerPos(playerid, -2443.683,-1633.3514,767.6721);
	    SetPlayerInterior(playerid, 0);
		return 1;
	}
	if (strcmp("/arena2", cmdtext, true, 10) == 0)
	{
	    SetPlayerPos(playerid, -2256.331,-1625.8031,767.6721);
	    SetPlayerInterior(playerid, 0);
		return 1;
	}
	if (strcmp("/arena3", cmdtext, true, 10) == 0)
	{
	    SetPlayerPos(playerid, -2353.16186,-1630.952,723.561);
	    SetPlayerInterior(playerid, 0);
		return 1;
	}
	if (strcmp("/weapon", cmdtext, true, 10) == 0)
	{
	    GivePlayerWeapon(playerid, 33, 100000);
	    return 1;
	}
	if (strcmp("/add", cmdtext, true, 10) == 0)
	{
	    //
		return 1;
	}
	return 0;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if (pickupid == home_enter) {
	    SetPlayerPos(playerid, -2160.8616,641.5761,1052.3817);
	    SetPlayerFacingAngle(playerid, 90);
	    SetPlayerInterior(playerid, 1);
		SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == home_quit) {
	    SetPlayerPos(playerid, 224.0981,-1839.8425,3.6037);
	    SetPlayerFacingAngle(playerid, 180);
	    SetPlayerInterior(playerid, 0);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == adm_enter) {
	    SetPlayerPos(playerid, -2029.8918,-117.4907,1035.1719);
	    SetPlayerFacingAngle(playerid, 355);
	    SetPlayerInterior(playerid, 3);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == adm_quit) {
	    SetPlayerPos(playerid, -2170.3140,637.0324,1052.3750);
	    SetPlayerFacingAngle(playerid, 0);
	    SetPlayerInterior(playerid, 1);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == cafe_enter) {
	    SetPlayerPos(playerid, 458.0106,-88.7452,999.5547);
	    SetPlayerFacingAngle(playerid, 90);
	    SetPlayerInterior(playerid, 4);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == cafe_quit) {
	    SetPlayerPos(playerid, 184.4775,-1826.0322,4.1454);
	    SetPlayerFacingAngle(playerid, 180);
	    SetPlayerInterior(playerid, 0);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == rest_enter) {
	    SetPlayerPos(playerid, 376.8676,-191.2918,1000.6328);
	    SetPlayerFacingAngle(playerid, 0);
	    SetPlayerInterior(playerid, 17);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == rest_quit) {
	    SetPlayerPos(playerid, 265.0115,-1824.9915,3.9249);
	    SetPlayerFacingAngle(playerid, 180);
	    SetPlayerInterior(playerid, 0);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == shop_enter) {
	    SetPlayerPos(playerid, -27.0887,-55.6914,1003.5469);
	    SetPlayerFacingAngle(playerid, 355);
	    SetPlayerInterior(playerid, 6);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == shop_quit) {
	    SetPlayerPos(playerid, 256.2769,-1788.2694,4.2751);
	    SetPlayerFacingAngle(playerid, 180);
	    SetPlayerInterior(playerid, 0);
	    SetCameraBehindPlayer(playerid);
	}
	else if (pickupid == start_tp1) {
	    if (playerid == Registration[0] && IsMatchRunned) {
	        SetPlayerPos(playerid, -2444.4160,-1633.3875,767.6721);
	        IsReady[playerid] = false;
	        IsEntered[playerid] = true;
			if (IsEntered[Registration[1]])
			    StartReadyTimer();
	    }
	}
    else if (pickupid == start_tp2) {
	    if (playerid == Registration[1] && IsMatchRunned) {
	        SetPlayerPos(playerid, -2256.4973,-1625.5812,767.6721);
	        IsReady[playerid] = false;
	        IsEntered[playerid] = true;
			if (IsEntered[Registration[0]])
			    StartReadyTimer();
	    }
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & 1024) SelectTextDraw(playerid,0xCCCCFF65);
    else if(newkeys & 16) {
        if(IsPlayerInRangeOfPoint(playerid,2.0,-23.4700,-57.3214,1003.5469)) {
			new listitems[] = "Предмет\tЦена\n{999999}Бейсбольная бита\t{00CC00}25$\n{21aa18}Ноутбук\t{00CC00}75$\n{cc0000}Водительские права\t{00CC00}200$\n{e38614}Расписка Шажка\t{00CC00}800$";
            ShowPlayerDialog(playerid, 3000, DIALOG_STYLE_TABLIST_HEADERS, "Circus 24/7", listitems, "Купить", "Выход");
        }
        else if(IsPlayerInRangeOfPoint(playerid,2.0,450.5763,-82.2320,999.5547)) {
			new listitems[] = "Предмет\tМин. ранг\tЦена\n{85200c}Годовой майонез\t{85200c}Дерево\t{00CC00}25$\n{666666}Каменный мармелад\t{666666}Камень\t{00CC00}50$\n{4c1130}Салат Люси\t{4c1130}Железо\t{00CC00}75$";
            ShowPlayerDialog(playerid, 3100, DIALOG_STYLE_TABLIST_HEADERS, "Кафе 'У Люси'", listitems, "Купить", "Выход");
        }
        else if(IsPlayerInRangeOfPoint(playerid,2.0,380.7459,-189.1151,1000.6328)) {
			new listitems[] = "Предмет\tМин. ранг\tЦена\n{a61c00}Суп Люси\t{a61c00}Бронза\t{00CC00}100$\n{999999}Картофель 'Михаил Михайлович'\t{999999}Серебро\t{00CC00}150$\n{bf9000}Торт Дедка\t{bf9000}Золото\t{00CC00}200$\n{b7b7b7}Гусь\t{b7b7b7}Платина\t{00CC00}300$";
            ShowPlayerDialog(playerid, 3200, DIALOG_STYLE_TABLIST_HEADERS, "Pepe's Restaurant", listitems, "Купить", "Выход");
        }
        else if(IsPlayerInRangeOfPoint(playerid,1.5,-2166.7527,646.0400,1052.3750)) {
			new listitems[2800] = "Предмет\tМин. ранг\tЦена\n{999999}Маскировочный плащ\t{666666}Камень\t{00CC00}100$\n{21aa18}Красный нос\t{4c1130}Железо\t{00CC00}150$\n{21aa18}Прыгающее мороженое\t{a61c00}Бронза\t{00CC00}200$\n{379be3}Защитное одеяние Шажка\t{999999}Серебро\t{00CC00}275$";
			strcat(listitems, "\n{379be3}Фартук Люси\t{bf9000}Золото\t{00CC00}350$\n{cc0000}Бомба усталости\t{b7b7b7}Платина\t{00CC00}500$\n{8200d9}Гребешок с киви\t{76a5af}Алмаз\t{00CC00}725$\n{e38614}Временной пузырь\t{6d9eeb}Бриллиант\t{00CC00}1000$\n{a64d79}Модный сундук\t{bf9000}Золото\t{00CC00}2000$");
            ShowPlayerDialog(playerid, 3300, DIALOG_STYLE_TABLIST_HEADERS, "Торговец ранговыми наградами", listitems, "Купить", "Выход");
        }
        else if(IsPlayerInRangeOfPoint(playerid,1.5,244.6122,-1788.8988,4.2897) ||
				IsPlayerInRangeOfPoint(playerid,1.5,259.1209,-1822.9977,4.2996)) {
			new listitems[512];
			format(listitems, sizeof(listitems), "Ваш баланс: %d$\nСнять наличные\nПополнить счет", PlayerInfo[playerid][Bank]);
			ShowPlayerDialog(playerid, 4000, DIALOG_STYLE_TABLIST_HEADERS, "Банкомат", listitems, "Далее", "Выход");
        }
        else if(IsPlayerInRangeOfPoint(playerid,1.2,-2171.3132,645.5896,1052.3817)) {
			ShowRatingTop(playerid);
        }
        else if(IsPlayerInRangeOfPoint(playerid,1.0,-2159.0491,640.3581,1052.3817) ||
				IsPlayerInRangeOfPoint(playerid,1.0,-2161.3096,640.3589,1052.3817)) {
			if (IsMatchRunned) {
			    SendClientMessage(playerid, COLOR_GREY, "Ошибка регистрации: в данный момент уже идет бой.");
			 	return 1;
			}
			new name[64];
			GetPlayerName(playerid, name, sizeof(name));
			if (strcmp(name, grid[currentPair][blue], true) == 0) {
			    if (Registration[0] > -1) {
			        SendClientMessage(playerid, COLOR_GREY, "Ошибка регистрации: участник уже заявлен.");
			        return 1;
			    }
			    Registration[0] = playerid;
			    SendClientMessage(playerid, COLOR_GREEN, "Регистрация прошла успешно. Вы заявлены на синюю сторону.");
			}
			else if (strcmp(name, grid[currentPair][red], true) == 0) {
			    if (Registration[1] > -1) {
			        SendClientMessage(playerid, COLOR_GREY, "Ошибка регистрации: участник уже заявлен.");
			        return 1;
			    }
			    Registration[1] = playerid;
			    SendClientMessage(playerid, COLOR_GREEN, "Регистрация прошла успешно. Вы заявлены на красную сторону.");
			}
			else {
			    SendClientMessage(playerid, COLOR_GREY, "Ошибка регистрации: вы не заявлены в текущий матч.");
			 	return 1;
			}
			if (Registration[0] > -1 && Registration[1] > -1) {
			    new msg[255];
			    format(msg, sizeof(msg), "Начинается %d матч %d тура!", currentPair+1, currentTour);
			    SendClientMessageToAll(0xFFCC00FF, msg);
			    StartMatch();
			}
        }
    }
	return 1;
}

public OnPlayerUpdate(playerid)
{
	UpdateHPBar(playerid);
	switch (PlayerInfo[playerid][Class]) {
	    case 0:
	    {
			new weapon = GetPlayerWeapon(playerid);
			if (weapon != 8) {
				if(IsPlayerAttachedObjectSlotUsed(playerid, 2))
			    	RemovePlayerAttachedObject(playerid, 2);
			    if(!IsPlayerAttachedObjectSlotUsed(playerid, 0))
			   		SetPlayerAttachedObject(playerid,0,339,1,0.314999,-0.140000,-0.183999,-2.000004,-70.100013,0.000000,1.000000,1.000000,1.000000);
			    if(!IsPlayerAttachedObjectSlotUsed(playerid, 1))
			        SetPlayerAttachedObject(playerid,1,18702,1,-0.091000,-0.043999,-0.932000,4.900000,23.299947,-79.600044,0.368001,1.518997,0.576999);
			}
			else {
			    if(IsPlayerAttachedObjectSlotUsed(playerid, 0))
			    	RemovePlayerAttachedObject(playerid, 0);
			    if(IsPlayerAttachedObjectSlotUsed(playerid, 1))
			    	RemovePlayerAttachedObject(playerid, 1);
			    if(!IsPlayerAttachedObjectSlotUsed(playerid, 2))
			    	SetPlayerAttachedObject(playerid,2,18702,6,0.419999,-0.295993,0.066000,-89.599960,-48.299983,1.299939,1.005999,1.638997,0.292999);
			}
		}
        case 1:
	    {
			new weapon = GetPlayerWeapon(playerid);
			if (weapon != 33) {
				if(IsPlayerAttachedObjectSlotUsed(playerid, 2))
			    	RemovePlayerAttachedObject(playerid, 2);
			    if(!IsPlayerAttachedObjectSlotUsed(playerid, 0))
			   		SetPlayerAttachedObject(playerid,0,357,1,0.020000,-0.183000,-0.082999,-2.199997,5.299992,8.400010,1.000000,1.000000,1.000000);
			    if(!IsPlayerAttachedObjectSlotUsed(playerid, 1))
			        SetPlayerAttachedObject(playerid,1,18701,1,-1.767000,-0.110999,-0.000000,0.000000,88.999977,0.000000,0.274999,0.328999,1.581998);
			}
			else {
			    if(IsPlayerAttachedObjectSlotUsed(playerid, 0))
			    	RemovePlayerAttachedObject(playerid, 0);
			    if(IsPlayerAttachedObjectSlotUsed(playerid, 1))
			    	RemovePlayerAttachedObject(playerid, 1);
			    if(!IsPlayerAttachedObjectSlotUsed(playerid, 2))
			    	SetPlayerAttachedObject(playerid,2,18701,6,-0.846999,-0.049999,-0.038001,-0.599998,81.800041,0.000000,1.000000,1.000000,1.000000);
			}
		}
		case 4:
	    {
			new weapon = GetPlayerWeapon(playerid);
			if (weapon != 4) {
				if(IsPlayerAttachedObjectSlotUsed(playerid, 2))
			    	RemovePlayerAttachedObject(playerid, 2);
			    if(!IsPlayerAttachedObjectSlotUsed(playerid, 0))
			   		SetPlayerAttachedObject(playerid,0,335,1,-0.230000,-0.166000,-0.098999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
			    if(!IsPlayerAttachedObjectSlotUsed(playerid, 1))
			        SetPlayerAttachedObject(playerid,1,18700,1,-0.736002,-0.147000,-0.040999,-15.300129,88.900077,101.699996,1.273999,1.680000,0.358000);
			}
			else {
			    if(IsPlayerAttachedObjectSlotUsed(playerid, 0))
			    	RemovePlayerAttachedObject(playerid, 0);
			    if(IsPlayerAttachedObjectSlotUsed(playerid, 1))
			    	RemovePlayerAttachedObject(playerid, 1);
			    if(!IsPlayerAttachedObjectSlotUsed(playerid, 2))
			    	SetPlayerAttachedObject(playerid,2,18700,6,0.000000,0.107999,-1.505000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
			}
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	//1000-1005 - вход в игру
	//2000 - инвентарь
	//3000 - circus 24/7
	//3100 - кафе
	//3200 - ресторан
	//3300 - торговец ранговыми наградами
	//4000-4003 - банкомат
	//1 - пустой
	//2,3 - выбор класса
	
	switch (dialogid) {
	    case 1: { return 1; }
	    case 2:
	    {
	        if (response) {
	            for (new i = 0; i < 6; i++)
	                class_count[i] = 0;
				new listitems[1024];
				new path[64];
				new File;
				for (new i = 0; i < 10; i++) {
				    format(path, sizeof(path), "Players/%s.ini", VovakClowns[i]);
				    File = ini_openFile(path);
				    new pclass;
				    ini_getInteger(File, "Class", pclass);
				    if (pclass > -1)
				        class_count[pclass]++;
				    ini_closeFile(File);
				}
				for (new i = 0; i < 10; i++) {
				    format(path, sizeof(path), "Players/%s.ini", DimakClowns[i]);
				    File = ini_openFile(path);
				    new pclass;
				    ini_getInteger(File, "Class", pclass);
				    if (pclass > -1)
				        class_count[pclass]++;
				    ini_closeFile(File);
				}
				format(listitems, sizeof(listitems), "Класс\tПерсонажей\n{1155cc}Фехтовальщик\t{ffffff}%d\n{bc351f}Гренадер\t{ffffff}%d\n{134f5c}Боец\t{ffffff}%d\n{f97403}Чародей\t{ffffff}%d\n{5b419b}Ассасин\t{ffffff}%d\n{9900ff}Иллюзионист\t{ffffff}%d", class_count[0],
				       class_count[1], class_count[2], class_count[3], class_count[4], class_count[5]);
	            ShowPlayerDialog(playerid, 3, DIALOG_STYLE_TABLIST_HEADERS, "Выбор класса", listitems, "Выбрать", "Отмена");
	        }
	        else return 1;
	    }
		case 3:
		{
		    if (response) {
		        if (class_count[listitem] >= 5) {
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "{FF6347}Количество персонажей выбранного класса достигло максимума. Невозможно выбрать класс.\nОтключение от сервера.", "ОК", "");
					Kick(playerid);
					return 1;
		        }
		        PlayerInfo[playerid][Class] = listitem;
		        UpdateCharacter(playerid);
		        ShowSkillPanel(playerid);
		        SendClientMessage(playerid, COLOR_LIGHTRED, "Класс выбран успешно!");
		    }
		    else return 1;
		}
	    case 1000:
	    {
			if (response) {
			    switch (listitem)
			    {
			        case 0:
			        {
			            new listitems[] = "{FF0000}Участники Вовака\n{0066FF}Участники Димака\n{33FF66}Участники Тани";
			            ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Вход в игру", listitems, "Выбрать", "Назад");
			        }
			        case 1:
			        {
			        }
			        case 2:
			        {
			        }
			        case 3:
			        {
			            ShowTourGrid(playerid);
			        }
			    }
			}
			else
			    Kick(playerid);
	    }
	    case 1001:
	    {
            if (response) {
                new listitems[4000];
			    switch (listitem)
			    {
			        case 0:
			        {
			            listitems = CreateVovakPlayersList();
			            ShowPlayerDialog(playerid, 1002, DIALOG_STYLE_TABLIST_HEADERS, "Вход в игру", listitems, "Войти", "Назад");
			        }
			        case 1:
			        {
			            listitems = CreateDimakPlayersList();
			            ShowPlayerDialog(playerid, 1003, DIALOG_STYLE_TABLIST_HEADERS, "Вход в игру", listitems, "Войти", "Назад");
			        }
			        case 2:
			        {
			        	listitems = CreateTanyaPlayersList();
			            ShowPlayerDialog(playerid, 1004, DIALOG_STYLE_TABLIST_HEADERS, "Вход в игру", listitems, "Войти", "Назад");
			        }
			    }
			}
			else {
			    new listitems[] = "{82eb9d}Выбрать участника для входа\n{ca0000}Войти за участника (красная сторона)\n{007dff}Войти за участника (синяя сторона)\n{e5ff11}Турнирная сетка";
				ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_LIST, "Вход в игру", listitems, "Выбрать", "Выход");
			}
	    }
	    case 1002:
	    {
	        if (response) {
				new name[64];
				for (new i = 0; i < MAX_PLAYERS; i++) {
				    if (!IsPlayerConnected(i)) continue;
					GetPlayerName(i, name, sizeof(name));
					if (strcmp(name, VovakClowns[listitem], true) == 0) {
					    SendClientMessage(playerid, COLOR_GREY, "В данный момент этот персонаж находится в игре. Переключение невозможно.");
					    return 1;
					}
				}
				if (PlayerConnect[playerid])
				    OnPlayerDisconnect(playerid, 1);
				SetPlayerName(playerid, VovakClowns[listitem]);
				LoadAccount(playerid);
	            OnPlayerLogin(playerid);
	        }
	        else {
	            new listitems[] = "{FF0000}Участники Вовака\n{0066FF}Участники Димака\n{33FF66}Участники Тани";
			 	ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Вход в игру", listitems, "Выбрать", "Назад");
	        }
	    }
	    case 1003:
	    {
            if (response) {
                new name[64];
				for (new i = 0; i < MAX_PLAYERS; i++) {
				    if (!IsPlayerConnected(i)) continue;
					GetPlayerName(i, name, sizeof(name));
					if (strcmp(name, DimakClowns[listitem], true) == 0) {
					    SendClientMessage(playerid, COLOR_GREY, "В данный момент этот персонаж находится в игре. Переключение невозможно.");
					    return 1;
					}
				}
				if (PlayerConnect[playerid])
				    OnPlayerDisconnect(playerid, 1);
				SetPlayerName(playerid, DimakClowns[listitem]);
				LoadAccount(playerid);
	            OnPlayerLogin(playerid);
	        }
	        else {
	            new listitems[] = "{FF0000}Участники Вовака\n{0066FF}Участники Димака\n{33FF66}Участники Тани";
			 	ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Вход в игру", listitems, "Выбрать", "Назад");
	        }
	    }
	    case 1004:
	    {
            if (response) {
                new name[64];
				for (new i = 0; i < MAX_PLAYERS; i++) {
				    if (!IsPlayerConnected(i)) continue;
					GetPlayerName(i, name, sizeof(name));
					if (strcmp(name, TanyaClowns[listitem], true) == 0) {
					    SendClientMessage(playerid, COLOR_GREY, "В данный момент этот персонаж находится в игре. Переключение невозможно.");
					    return 1;
					}
				}
				if (PlayerConnect[playerid])
				    OnPlayerDisconnect(playerid, 1);
				SetPlayerName(playerid, TanyaClowns[listitem]);
				LoadAccount(playerid);
	            OnPlayerLogin(playerid);
	        }
	        else {
	            new listitems[] = "{FF0000}Участники Вовака\n{0066FF}Участники Димака\n{33FF66}Участники Тани";
			 	ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Вход в игру", listitems, "Выбрать", "Назад");
	        }
	    }
	    case 1005:
	    {
	        new listitems[] = "{82eb9d}Выбрать участника для входа\n{ca0000}Войти за участника (красная сторона)\n{007dff}Войти за участника (синяя сторона)\n{e5ff11}Турнирная сетка";
			ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_LIST, "Вход в игру", listitems, "Выбрать", "Выход");
	    }
	    case 2000:
	    {
	        if (response)
	        	DeleteSelectedItem(playerid);
	    }
	    case 3000:
	    {
	        if (response) {
	            new buying_item;
	            new price;
	            new count = 1;
	            switch (listitem) {
	                case 0:
	                {
	                    price = 25;
	                    buying_item = 336;
	                }
	                case 1:
	                {
	                    price = 75;
	                    buying_item = 19893;
	                }
	                case 2:
	                {
	                    price = 200;
	                    buying_item = 1581;
	                }
	                case 3:
	                {
	                    price = 800;
	                    buying_item = 2684;
	                }
	            }
	            if (PlayerInfo[playerid][Cash] >= price) {
                    if (GetItemSlot(playerid, buying_item) == -1 && GetInvEmptySlots(playerid) == 0) {
                        ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Невозможно приобрести предмет: инвентарь полон.", "Закрыть", "");
                        return 1;
                    }
                    PlayerInfo[playerid][Cash] -= price;
                    GivePlayerMoney(playerid, -price);
                    AddItem(playerid, buying_item, count);
                    SendClientMessage(playerid, 0xFFFFFFFF, "Предмет куплен.");
                }
                else SendClientMessage(playerid, COLOR_GREY, "Недостаточно средств.");
	        }
	        else return 1;
	    }
	    case 3100:
	    {
	        if (response) {
	            new price;
				new effect;
				new time;
	            switch (listitem) {
	                case 0:
	                {
	                    price = 25;
	                    if (GetRndResult(50)) effect = EFFECT_MAYO_POSITIVE;
	                    else effect = EFFECT_MAYO_NEGATIVE;
	                    time = 100;
	                }
	                case 1:
	                {
	                    if (PlayerInfo[playerid][Rate] < 501) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 50;
	                    if (GetRndResult(50)) effect = EFFECT_MARMELADE_POSITIVE;
	                    else effect = EFFECT_MARMELADE_NEGATIVE;
	                    time = 100;
	                }
	                case 2:
	                {
	                    if (PlayerInfo[playerid][Rate] < 1001) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 75;
	                    if (GetRndResult(50)) effect = EFFECT_SALAT_POSITIVE;
	                    else effect = EFFECT_SALAT_NEGATIVE;
	                    time = 120;
	                }
	            }
	            if (PlayerInfo[playerid][Cash] >= price) {
	                new slot = FindEffectSlotForEat(playerid);
                    PlayerInfo[playerid][Cash] -= price;
                    GivePlayerMoney(playerid, -price);
                    SetPlayerEffect(playerid, effect, time, slot);
                    SendClientMessage(playerid, 0xFFFFFFFF, "Предмет куплен.");
                }
                else SendClientMessage(playerid, COLOR_GREY, "Недостаточно средств.");
	        }
	        else return 1;
	    }
	    case 3200:
	    {
	        if (response) {
	            new price;
				new effect;
				new time;
	            switch (listitem) {
	                case 0:
	                {
	                    if (PlayerInfo[playerid][Rate] < 1201) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 100;
	                    effect = EFFECT_SOUP;
	                    time = 80;
	                }
	                case 1:
	                {
	                    if (PlayerInfo[playerid][Rate] < 1401) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 150;
	                    effect = EFFECT_POTATO;
	                    time = 90;
	                }
	                case 2:
	                {
	                    if (PlayerInfo[playerid][Rate] < 1601) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 200;
	                    effect = EFFECT_CAKE;
	                    time = 100;
	                }
	                case 3:
	                {
	                    if (PlayerInfo[playerid][Rate] < 2001) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 300;
	                    effect = EFFECT_GOOSE;
	                    time = 130;
	                }
	            }
	            if (PlayerInfo[playerid][Cash] >= price) {
	                new slot = FindEffectSlotForEat(playerid);
                    PlayerInfo[playerid][Cash] -= price;
                    GivePlayerMoney(playerid, -price);
                    SetPlayerEffect(playerid, effect, time, slot);
                    SendClientMessage(playerid, 0xFFFFFFFF, "Предмет куплен.");
                }
                else SendClientMessage(playerid, COLOR_GREY, "Недостаточно средств.");
	        }
	        else return 1;
	    }
        case 3300:
	    {
	        if (response) {
	            new buying_item;
	            new price;
	            new count = 1;
	            switch (listitem) {
	                case 0:
	                {
	                    if (PlayerInfo[playerid][Rate] < 501) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 100;
	                    buying_item = 1242;
	                }
	                case 1:
	                {
	                    if (PlayerInfo[playerid][Rate] < 1001) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 150;
	                    buying_item = 19577;
	                }
	                case 2:
	                {
	                    if (PlayerInfo[playerid][Rate] < 1201) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 200;
	                    buying_item = 2726;
	                }
	                case 3:
	                {
	                    if (PlayerInfo[playerid][Rate] < 1401) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 275;
	                    buying_item = 2689;
	                }
	                case 4:
	                {
	                    if (PlayerInfo[playerid][Rate] < 1601) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 350;
	                    buying_item = 2411;
	                }
	                case 5:
	                {
	                    if (PlayerInfo[playerid][Rate] < 2001) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 500;
	                    buying_item = 1252;
	                }
	                case 6:
	                {
	                    if (PlayerInfo[playerid][Rate] < 2301) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 725;
	                    buying_item = 19883;
	                }
	                case 7:
	                {
	                    if (PlayerInfo[playerid][Rate] < 2701) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 1000;
	                    buying_item = 1944;
	                }
	                case 8:
	                {
	                    if (PlayerInfo[playerid][Rate] < 1601) {
	                        SendClientMessage(playerid, COLOR_GREY, "У вас слишком низкий рейтинг для этого предмета.");
	                        return 1;
	                    }
	                    price = 2000;
	                    buying_item = 2710;
	                }
	            }
	            if (PlayerInfo[playerid][Cash] >= price) {
                    if (GetItemSlot(playerid, buying_item) == -1 && GetInvEmptySlots(playerid) == 0) {
                        ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Невозможно приобрести предмет: инвентарь полон.", "Закрыть", "");
                        return 1;
                    }
                    PlayerInfo[playerid][Cash] -= price;
                    GivePlayerMoney(playerid, -price);
                    AddItem(playerid, buying_item, count);
                    SendClientMessage(playerid, 0xFFFFFFFF, "Предмет куплен.");
                }
                else SendClientMessage(playerid, COLOR_GREY, "Недостаточно средств.");
	        }
	        else return 1;
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
    if (playertextid == PanelInventory[playerid])
    {
		ShowInventory(playerid);
		IsInventoryOpen[playerid] = true;
		return 1;
    }
    else if (playertextid == PanelInfo[playerid])
    {
		ShowInfo(playerid);
		return 1;
    }
    else if (playertextid == PanelUndress[playerid])
    {
		if (PlayerInfo[playerid][Skin] == 252 || PlayerInfo[playerid][Skin] == 138) {
		    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Костюм не используется.", "ОК", "");
		    return 1;
		}
		UndressSkin(playerid);
		return 1;
    }
    else if (playertextid == PanelSwitch[playerid])
    {
		new listitems[] = "{82eb9d}Выбрать участника для входа\n{ca0000}Войти за участника (красная сторона)\n{007dff}Войти за участника (синяя сторона)\n{e5ff11}Турнирная сетка";
		ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_LIST, "Вход в игру", listitems, "Выбрать", "Выход");
		return 1;
    }
	else if (playertextid == inv_ico[playerid])
    {
		HideInventory(playerid);
		IsInventoryOpen[playerid] = false;
		return 1;
    }
    else if (playertextid == btn_del[playerid])
    {
		if (SelectedSlot[playerid] == -1 || PlayerInfo[playerid][Inventory][SelectedSlot[playerid]] == 0)
		    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не выбран ни один предмет.", "ОК", "");
		else
			ShowPlayerDialog(playerid, 2000, DIALOG_STYLE_MSGBOX, "Подтверждение", "Вы действительно хотите выбросить предмет?", "Да", "Нет");
		return 1;
    }
    else if (playertextid == btn_info[playerid])
    {
		if (SelectedSlot[playerid] == -1 || PlayerInfo[playerid][Inventory][SelectedSlot[playerid]] == 0)
		    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не выбран ни один предмет.", "ОК", "");
		else {
		    new info[1024];
		    info = GetSelectedItemInfo(playerid);
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Информация", info, "Закрыть", "");
		}
		return 1;
    }
    else if (playertextid == btn_use[playerid])
    {
		if (SelectedSlot[playerid] == -1 || PlayerInfo[playerid][Inventory][SelectedSlot[playerid]] == 0)
		    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не выбран ни один предмет.", "ОК", "");
		else {
		    UseItem(playerid, SelectedSlot[playerid]);
		}
		return 1;
    }
    for (new i = 0; i < MAX_SLOTS; i++) {
        if (playertextid == InvSlot[playerid][i]) {
            if (SelectedSlot[playerid] != -1) {
                if (PlayerInfo[playerid][Inventory][SelectedSlot[playerid]] != 0 &&
                    PlayerInfo[playerid][Inventory][i] == 0) {
                    PlayerInfo[playerid][Inventory][i] = PlayerInfo[playerid][Inventory][SelectedSlot[playerid]];
                    PlayerInfo[playerid][InventoryCount][i] = PlayerInfo[playerid][InventoryCount][SelectedSlot[playerid]];
                    PlayerInfo[playerid][Inventory][SelectedSlot[playerid]] = 0;
                    PlayerInfo[playerid][InventoryCount][SelectedSlot[playerid]] = 0;
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
    return 0;
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

public FCNPC_OnSpawn(npcid)
{
    FCNPC_SetHealth(npcid, 100);
    FCNPC_SetWeapon(npcid, 8);
	RegenTimer[npcid] = SetTimerEx("RegenerateHealth", 3000, true, "i", npcid);
    if (Attach3DTextLabelToPlayer(NPCName[npcid], npcid, 0.0, 0.0, 0.2) == 0) 
		SendClientMessageToAll(COLOR_RED, "INVALID_3DTEXT_ID");
}
public FCNPC_OnRespawn(npcid)
{
	new idx = random(MAX_SPAWNS);
	FCNPC_SetPosition(npcid, RandomSpawn[idx][X], RandomSpawn[idx][Y], RandomSpawn[idx][Z]);
    FCNPC_OnSpawn(npcid);
	idx = random(MAX_SPAWNS);
    FCNPC_GoTo(npcid, RandomSpawn[idx][X], RandomSpawn[idx][Y], RandomSpawn[idx][Z], MOVE_TYPE_SPRINT);
}
public FCNPC_OnDeath(npcid, killerid, weaponid)
{
	SendDeathMessage(killerid, npcid, weaponid);
	KillTimer(RegenTimer[npcid]);
	NPCKills[killerid]++;
	NPCDeaths[npcid]++;
	CheckTimer[npcid] = SetTimerEx("CheckDead", 5000, false, "i", npcid);
}
public FCNPC_OnUpdate(npcid)
{
	if(IsPvpStarted)
		UpdatePvpPlayers();
}

forward CheckDead(npcid);
public CheckDead(npcid)
{
    if (FCNPC_IsDead(npcid)) 
		FCNPC_Respawn(npcid);
}

//==============================================================================
//========PvP=======
stock StartPvp()
{
	CreateNPCs();
    for (new i = 0; i < MAX_PVP_PLAYERS; i++) 
	{
		SetRandomSkin(NPCs[i]);
		FCNPC_Spawn(NPCs[i], PlayerInfo[NPCs[i]][Skin], 1304 + random(92), 2105 + random(85), 11.0234);
		FCNPC_SetInterior(NPCs[i], 0);
	}
	UpdatePvpPlayers();
	PvpTtl = 180;
    StopPvpTimer = SetTimer("StopPvp", 180000, false);
	PvpTableUpdTimer = SetTimer("UpdatePvpTable", 1000, true);

	SetPvpTableVisibility(true);
    SendClientMessageToAll(COLOR_GREEN, "PvP началось!");
	IsPvpStarted = true;
}
public StopPvp()
{
	if(!IsPvpStarted)
		return;

	if (StopPvpTimer != -1)
		KillTimer(StopPvpTimer);
	KillTimer(PvpTableUpdTimer);

	PvpPlayersUpdTimer = -1;
	StopPvpTimer = -1;
	PvpTableUpdTimer = -1;

	SetPvpTableVisibility(false);
	GetPvPResults();
	DeleteNPCs();
	SendClientMessageToAll(COLOR_GREEN, "PvP завершено.");
	IsPvpStarted = false;

	SetPlayerPos(InitID, 224.0761,-1839.8217,3.6037);
	SetPlayerInterior(InitID, 0);
	InitID = -1;
}
stock FindPlayerTarget(npcid, bool:by_minhp = false)
{
	new targetid = -1;
	new nearest_targets[MAX_RELIABLE_TARGETS];
	new targets_count = 0;
	new Float:distances[MAX_PVP_PLAYERS];
	new Float:available_dist = 0;

	for (new i = 0; i < MAX_RELIABLE_TARGETS; i++)
		nearest_targets[i] = -1;

	for (new i = 0; i < MAX_PVP_PLAYERS; i++)
		distances[i] = GetDistanceBetweenPlayers(npcid, NPCs[i]);
	
	SortArrayAscending(distances);
	available_dist = distances[MAX_RELIABLE_TARGETS-1];

    for (new i = 0; i < MAX_PVP_PLAYERS; i++) 
	{
		if(NPCs[i] == npcid || FCNPC_IsDead(NPCs[i]))
			continue;
		
		new Float:dist;
		dist = GetDistanceBetweenPlayers(npcid, NPCs[i]);
		if(dist <= PlayerInfo[npcid][RangeRate] && dist <= available_dist)
		{
			nearest_targets[targets_count] = NPCs[i];
			targets_count++;
		}
	}

	if(!by_minhp)
		return nearest_targets[0];

	for (new i = 0; i < MAX_RELIABLE_TARGETS; i++)
	{
		new Float:min_hp = 101;
		if(nearest_targets[i] == -1)
			break;
		
		new Float:hp = FCNPC_GetHealth(nearest_targets[i]);
		if(hp < min_hp)
			targetid = nearest_targets[i];
	}

	return targetid;
}
stock SetPlayerTarget(playerid)
{
	FCNPC_StopAim(playerid);
	new targetid = FindPlayerTarget(playerid, true);
	new Float:offset = PlayerInfo[playerid][PAccuracy];

	if(targetid == -1)
	{
		MoveAround(playerid);
		return 0;
	}

	FCNPC_AimAtPlayer(playerid, targetid, false, -1, true, 0, 0, 0, offset, offset, offset);
	FCNPC_GoToPlayer(playerid, targetid);
	return 1;
}
stock MoveAround(playerid)
{
	new Float:x_offset = -10 + random(20);
	new Float:y_offset = -10 + random(20);
	new Float:x, Float:y, Float:z;

	FCNPC_GetPosition(playerid, x, y, z);
	FCNPC_GoTo(playerid, x + x_offset, y + y_offset, z);
}
public RegenerateHealth(playerid)
{
	if(FCNPC_IsDead(playerid))
		return;

	new Float:hp = FCNPC_GetHealth(playerid);
	hp = floatadd(hp, 3.0);
	if(hp > 100)
		hp = 100;
	FCNPC_SetHealth(playerid, hp);
}
public UpdatePvpPlayers()
{
	for (new i = 0; i < MAX_PVP_PLAYERS; i++)
	{
		new id = NPCs[i];

		//If NPC bumped any obstacle - move him
		if(FCNPC_IsMoving(id) && FCNPC_GetSpeed(id) < 0.1)
		{
			MoveAround(id);
			continue;
		}

		//If player's HP is critical and enemy so close - run around
		new Float:p_hp = FCNPC_GetHealth(id);
		if(p_hp < 10 && GetMinDistanceForEnemy(id) < 3)
		{
			MoveAround(id);
			continue;
		}

		//Checking available target
		if(!FCNPC_IsAiming(id) && !FCNPC_IsDead(id))
		{
			new chance = random(100);
			if(FCNPC_IsMoving(id) && chance > 5)
				continue;
			
			SetPlayerTarget(id);
			continue;
		}

		//If current target is dead, set new
		new target = FCNPC_GetAimingPlayer(id);
		if(target == -1)
			continue;
		if(FCNPC_IsDead(target))
		{
			SetPlayerTarget(id);
			continue;
		}

		new Float:dist = GetDistanceBetweenPlayers(id, target);
		if(!FCNPC_IsMovingToPlayer(id, target) && dist > 2)
			FCNPC_GoToPlayer(id, target);

		//If player so close to target - attack it
		if(dist <= 2)
		{
			FCNPC_Stop(id);
			FCNPC_MeleeAttack(id, PlayerInfo[id][Reaction]);
		}
		else
			FCNPC_StopAttack(id);

		//If there are targets with less HP beside player - change target
		new potential_target = FindPlayerTarget(id, true);
		if(potential_target != -1)
		{
			new Float:t_hp = FCNPC_GetHealth(target);
			new Float:pt_hp = FCNPC_GetHealth(potential_target);
			if(floatabs(floatsub(t_hp, pt_hp)) >= 50)
				SetPlayerTarget(id);
		}
	}
}
stock GetMinDistanceForEnemy(playerid)
{
	new Float:min_dist = 1000;
	for (new i = 0; i < MAX_PVP_PLAYERS; i++)
	{
		new enemy_id = NPCs[i];
		new dist = GetDistanceBetweenPlayers(playerid, enemy_id);
		if(FCNPC_IsAimingAtPlayer(enemy_id, playerid) && dist < min_dist)
			min_dist = dist;
	}
	return min_dist;
}
stock CreateNPCs()
{
	for (new i = 0; i < MAX_PVP_PLAYERS; i++) 
	{
		NPCs[i] = FCNPC_Create(npcclowns[i]);
		LoadAccount(NPCs[i]);
		SetPlayerColor(NPCs[i], GetHexColorByRate(PlayerInfo[NPCs[i]][Rate]));
		NPCName[NPCs[i]] = Create3DTextLabel(npcclowns[i], GetPlayerColor(NPCs[i]), 7.77, 7.77, 7.77, 80.0, 0, 1);
		NPCKills[NPCs[i]] = 0;
		NPCDeaths[NPCs[i]] = 0;
	}
}
stock DeleteNPCs()
{
    for (new i = 0; i < MAX_PVP_PLAYERS; i++) 
	{
		SaveAccount(NPCs[i]);
		KillTimer(CheckTimer[NPCs[i]]);
		KillTimer(RegenTimer[NPCs[i]]);
		NPCKills[NPCs[i]] = 0;
		NPCDeaths[NPCs[i]] = 0;
		FCNPC_Destroy(NPCs[i]);
	}
}
stock GetPvPResults()
{
    UpdatePvpData();
    new finout[4090] = "№  Имя\tУбийств\tСмертей\tКоэф.(рейт.)\n";
    new output[120];
	new r_color[64] = "33CC66";
	new chr[8] = "+";
    for(new i = 0; i < MAX_PVP_PLAYERS; i++)
    {
		new id = GetNPCIDByName(PvpRes[i][Name]);
		new rate_diff = GetRateDifference(i+1, PvpRes[i][Score]);
		ChangeRate(id, rate_diff);

		if (i >= MAX_PVP_PLAYERS / 2 - 1)
		{
			r_color = "CC0000";
			chr = "-";
		}
		format(output,sizeof(output),"{CCFFFF}%d. {%s}%s\t{66CCFF}%d\t{9966CC}%d\t{FF9900}%.3f ({%s}%s%d)\n",
			i+1,
			GetColorByRate(PlayerInfo[id][Rate]),
			PvpRes[i][Name],
			NPCKills[id],
			NPCDeaths[id],
			PvpRes[i][Score],
			r_color,
			chr,
			rate_diff);
		strcat(finout,output);
    }
    ShowPlayerDialog(InitID,1,DIALOG_STYLE_TABLIST_HEADERS,"Результаты PvP",finout,"Закрыть","");
}
stock UpdatePvpData()
{
	new tmp[PvpResItem];
    for(new i = 0; i < MAX_PVP_PLAYERS; i++)
    {
		new Float:k;
		k = NPCKills[NPCs[i]];
		if (NPCDeaths[NPCs[i]] > 0)
		{
			k = floatdiv(NPCKills[NPCs[i]], NPCDeaths[NPCs[i]]);
		}
		PvpRes[i][Score] = k;
		PvpRes[i][Name] = npcclowns[i];
    }
    for(new i = 0; i < MAX_PVP_PLAYERS; i++)
    {
        for(new j = MAX_PVP_PLAYERS-1; j > i; j--)
        {
            if(PvpRes[j-1][Score] < PvpRes[j][Score])
            {
                tmp = PvpRes[j-1];
                PvpRes[j-1] = PvpRes[j];
                PvpRes[j] = tmp;
            }
        }
    }
}
public UpdatePvpTable()
{
	new score[64];
	new id = -1;

	UpdatePvpData();
	for(new i = 0; i < MAX_PVP_PANEL_ITEMS; i++)
	{
		PlayerTextDrawSetString(InitID, PvpPanelNameLabels[InitID][i], PvpRes[i][Name]);
		id = GetNPCIDByName(PvpRes[i][Name]);
		PlayerTextDrawColor(InitID, PvpPanelNameLabels[InitID][i], GetHexColorByRate(PlayerInfo[id][Rate]));
		format(score, sizeof(score), "%.3f", PvpRes[i][Score]);
		PlayerTextDrawSetString(InitID, PvpPanelScoreLabels[InitID][i], score)
	}

	new minute, second;
	new string[25];
	PvpTtl--;
	minute = PvpTtl / 60;
	second = PvpTtl - minute * 60;
	if(second <= 9)
		format(string, 25, "%d:0%d", minute, second);
	else
		format(string, 25, "%d:%d", minute, second);
	PlayerTextDrawSetString(InitID, PvpPanelTimer[InitID], string);
}
stock ChangeRate(playerid, diff)
{
	PlayerInfo[playerid][Rate] += diff;
	if(PlayerInfo[playerid][Rate] < 0)
		PlayerInfo[playerid][Rate] = 0;
	if(PlayerInfo[playerid][Rate] > 3000)
		PlayerInfo[playerid][Rate] = 3000;
}
stock GetRateDifference(pos, Float:k)
{
	new diff = 0;
	new ratebase = 1;

	if(k > 0.1)
		ratebase = floatround(floatmul(k, 10.0));
	if(ratebase > 30)
		ratebase = 30;

	if(pos <= MAX_PVP_PLAYERS / 2)
		diff = ratebase + (MAX_PVP_PLAYERS / 2 + 1) - pos;
	else
		diff = ratebase - (MAX_PVP_PLAYERS / 2 + 1) - pos;
	return diff;
}
stock SetPvpTableVisibility(bool:value)
{
	if(value)
	{
		PlayerTextDrawShow(InitID, PvpPanelBox[InitID]);
		PlayerTextDrawShow(InitID, PvpPanelHeader[InitID]);
		PlayerTextDrawShow(InitID, PvpPanelTimer[InitID]);
		for(new i = 0; i < MAX_PVP_PANEL_ITEMS; i++)
		{
			PlayerTextDrawShow(InitID, PvpPanelNameLabels[InitID][i]);
			PlayerTextDrawShow(InitID, PvpPanelScoreLabels[InitID][i]);
		}
	}
	else
	{
		PlayerTextDrawHide(InitID, PvpPanelBox[InitID]);
		PlayerTextDrawHide(InitID, PvpPanelHeader[InitID]);
		PlayerTextDrawHide(InitID, PvpPanelTimer[InitID]);
		for(new i = 0; i < MAX_PVP_PANEL_ITEMS; i++)
		{
			PlayerTextDrawHide(InitID, PvpPanelNameLabels[InitID][i]);
			PlayerTextDrawHide(InitID, PvpPanelScoreLabels[InitID][i]);
		}
	}
}

stock GetNPCIDByName(name[])
{
    for(new i = 0; i < MAX_PVP_PLAYERS; i++)
    {
        if(strcmp(name, npcclowns[i]) == 0) return NPCs[i];
    }
    return 0;
}
stock SetRandomSkin(id)
{
	new idx = random(11);
	if(PlayerInfo[id][Sex] == 0)
		PlayerInfo[id][Skin] = all_male_skins[idx];
	else
		PlayerInfo[id][Skin] = all_female_skins[idx];
}
stock SortArrayDescending(array[], const size = sizeof(array))
{
	for(new i = 1, j, key; i < size; i++)
	{
		key = array[i];
		for(j = i - 1; j >= 0 && array[j] < key; j--)
			array[j + 1] = array[j];
		array[j + 1] = key;
	}
}
stock SortArrayAscending(array[], const size = sizeof(array))
{
	for(new i = 1, j, key; i < size; i++)
	{
		key = array[i];
		for(j = i - 1; j >= 0 && array[j] > key; j--)
			array[j + 1] = array[j];
		array[j + 1] = key;
	}
}

//========Бои=======
//Старт матча
stock StartMatch()
{
	IsMatchRunned = true;
	
}
//Конец матча
stock StopMatch()
{
	IsMatchRunned = false;
	if (MatchTimer > -1) {
	    KillTimer(MatchTimer);
	    MatchTimer = -1;
	}
}
//Запуск таймера начала боя
stock StartReadyTimer()
{
	ReadyTimerTicks = 30;
	MatchTimer = SetTimer("ReadyTimerTick", 1000, true);
}
//Тик таймера начала раунда
public ReadyTimerTick()
{
	ReadyTimerTicks--;
	if (ReadyTimerTicks <= 0)
	    StartRound();
}
//Начало раунда
stock StartRound()
{
    if (MatchTimer > -1) {
	    KillTimer(MatchTimer);
	    MatchTimer = -1;
	}
}
//Прохождение проверки на шанс
stock GetRndResult(chance)
{
	new rnd = random(100);
	if (rnd < chance) return true;
	return false;
}

//Информация о персонаже
stock ShowInfo(playerid)
{
	new info[2000];
	new pinfo[768];
	new name[64];
	GetPlayerName(playerid, name, sizeof(name));
	format(info, sizeof(info), "{FFFFFF}Имя:\t%s\nПол:\t%s\nКласс:\t%s\n{FFFFFF}Рейтинг:\t{%s}%d\n{FFFFFF}Ранг:\t{%s}%s\n{3399FF}Позиция в топе:\t{%s}%d\n{66CC00}Победы:\t%d\n{CC0000}Поражения:\t%d\n{FFCC00}Процент побед:\t%d%%\n{FFFFFF}________________________\n",
		   name, GetPlayerSex(playerid), GetClassNameByID(PlayerInfo[playerid][Class]), GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Rate], GetColorByRate(PlayerInfo[playerid][Rate]), GetRateInterval(PlayerInfo[playerid][Rate]), GetPlaceColor(PlayerInfo[playerid][TopPosition]), PlayerInfo[playerid][TopPosition],
		   PlayerInfo[playerid][Wins], PlayerInfo[playerid][Loses], GetPlayerWinPercent(playerid));
	format(pinfo, sizeof(pinfo), "{0066CC}Атака:\t%d\n{CC0000}Защита:\t%d%%\n{FF9900}Точность:\t%d%%\n{33CC99}Уклонение:\t%d%%\n{FF6600}Шанс крита:\t%d%%",
		   PlayerInfo[playerid][Damage], PlayerInfo[playerid][Defense], PlayerInfo[playerid][Accuracy], PlayerInfo[playerid][Dodge], PlayerInfo[playerid][CriticalChance]);
	strcat(info, pinfo);
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST, "Информация", info, "Закрыть", "");
}

//Получить процент побед
stock GetPlayerWinPercent(playerid)
{
	new percent = floatround(floatmul(floatdiv(PlayerInfo[playerid][Wins], PlayerInfo[playerid][Loses]), 100));
	return percent;
}

//Получить пол персонажа
stock GetPlayerSex(playerid) {
	new sex[32];
	switch (PlayerInfo[playerid][Sex]) {
	    case 0: sex = "Мужской";
		default: sex = "Женский";
	}
	return sex;
}

//Снять костюм
stock UndressSkin(playerid)
{
    if (GetInvEmptySlots(playerid) == 0) {
	    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Невозможно снять костюм: инвентарь полон.", "ОК", "");
	    return;
	}
	AddItem(playerid, PlayerInfo[playerid][Skin], 1);
	if (PlayerInfo[playerid][Sex] == 0)
	    PlayerInfo[playerid][Skin] = 252;
	else
	    PlayerInfo[playerid][Skin] = 138;
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
}

//Использовать предмет
stock UseItem(playerid, slot)
{
	new item = PlayerInfo[playerid][Inventory][slot];
	switch (item) {
	    case 83,91,84,214,120,141,264,152,147,150,127,169,204,298,114,195,97,140,161,198,287,191:
	    {
            PlayerInfo[playerid][InventoryCount][slot]--;
	        if (PlayerInfo[playerid][InventoryCount][slot] <= 0) {
	            PlayerInfo[playerid][InventoryCount][slot] = 0;
	            PlayerInfo[playerid][Inventory][slot] = 0;
	        }
	        UpdateSlot(playerid, slot);
			if (PlayerInfo[playerid][Skin] != 252 && PlayerInfo[playerid][Skin] != 138)
			    UndressSkin(playerid);
	        PlayerInfo[playerid][Skin] = item;
	        SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	    }
	    case 296:
	    {
	        if (PlayerInfo[playerid][Sex] == 1) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Данный предмет могут носить только персонажи мужского пола.", "Закрыть", "");
	        	return;
	        }
	        PlayerInfo[playerid][InventoryCount][slot]--;
	        if (PlayerInfo[playerid][InventoryCount][slot] <= 0) {
	            PlayerInfo[playerid][InventoryCount][slot] = 0;
	            PlayerInfo[playerid][Inventory][slot] = 0;
	        }
	        UpdateSlot(playerid, slot);
			if (PlayerInfo[playerid][Skin] != 252 && PlayerInfo[playerid][Skin] != 138)
			    UndressSkin(playerid);
	        PlayerInfo[playerid][Skin] = item;
	        SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	    }
	    case 1581, 2684:
	    {
	        ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Данный предмет является пассивным. Использование невозможно.", "Закрыть", "");
	        return;
	    }
	    //Максировочный плащ
	    case 1242:
	    {
	        if (!IsBattleBegins) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Вы не находитесь в режиме боя. Использование невозможно.", "Закрыть", "");
				return;
	        }
	        //activity
	    }
	    //Красный нос
	    case 19577:
	    {
	        if (!IsBattleBegins) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Вы не находитесь в режиме боя. Использование невозможно.", "Закрыть", "");
				return;
	        }
	        //activity
	    }
	    //Прыгающее мороженое
	    case 2726:
	    {
	        if (!IsBattleBegins) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Вы не находитесь в режиме боя. Использование невозможно.", "Закрыть", "");
				return;
	        }
	        //activity
	    }
        //Защитное одеяние Шажка
	    case 2689:
	    {
	        if (!IsBattleBegins) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Вы не находитесь в режиме боя. Использование невозможно.", "Закрыть", "");
				return;
	        }
			SetPlayerEffect(playerid, EFFECT_SHAZOK_GEAR, 10, FindEffectSlot(playerid));
	    }
	    //Фартук Люси
	    case 2411:
	    {
	        if (!IsBattleBegins) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Вы не находитесь в режиме боя. Использование невозможно.", "Закрыть", "");
				return;
	        }
			SetPlayerEffect(playerid, EFFECT_LUSI_APRON, 6, FindEffectSlot(playerid));
	    }
	    //Бомба усталости
	    case 1252:
	    {
	        if (!IsBattleBegins) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Вы не находитесь в режиме боя. Использование невозможно.", "Закрыть", "");
				return;
	        }
	        //activity
	    }
	    //Гребешок с киви
	    case 19883:
	    {
	        if (!IsBattleBegins) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Вы не находитесь в режиме боя. Использование невозможно.", "Закрыть", "");
				return;
	        }
	        //activity
	    }
	    //Временной пузырь
	    case 1944:
	    {
	        if (!IsBattleBegins) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Вы не находитесь в режиме боя. Использование невозможно.", "Закрыть", "");
				return;
	        }
	        //activity
	    }
	    case 2710:
	    {
	        if (GetInvEmptySlots(playerid) == 0) {
	            ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Невозможно использовать предмет: инвентарь полон.", "Закрыть", "");
                return;
	        }
	        new rnd = random(100);
	        switch (rnd) {
	            case 0..29:
	            {
	                AddItem(playerid, 296, 1);
                    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{a64d79}Модный сундук", "{ffffff}Вы получили: [{a64d79}Костюм гея{ffffff}].", "Закрыть", "");
	            }
	            case 30..55:
	            {
					if (PlayerInfo[playerid][Sex] == 0)
	                	AddItem(playerid, 287, 1);
					else
					    AddItem(playerid, 191, 1);
                    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{a64d79}Модный сундук", "{ffffff}Вы получили: [{a64d79}Военная форма{ffffff}].", "Закрыть", "");
	            }
	            case 56..70:
	            {
					if (PlayerInfo[playerid][Sex] == 0)
	                	AddItem(playerid, 161, 1);
					else
					    AddItem(playerid, 198, 1);
                    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{a64d79}Модный сундук", "{ffffff}Вы получили: [{a64d79}Костюм фермера{ffffff}].", "Закрыть", "");
	            }
	            case 71..82:
	            {
					if (PlayerInfo[playerid][Sex] == 0)
	                	AddItem(playerid, 97, 1);
					else
					    AddItem(playerid, 140, 1);
                    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{a64d79}Модный сундук", "{ffffff}Вы получили: [{a64d79}Купальный костюм{ffffff}].", "Закрыть", "");
	            }
	            case 83..89:
	            {
					if (PlayerInfo[playerid][Sex] == 0)
	                	AddItem(playerid, 114, 1);
					else
					    AddItem(playerid, 195, 1);
                    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{a64d79}Модный сундук", "{ffffff}Вы получили: [{a64d79}Костюм 'Глава района'{ffffff}].", "Закрыть", "");
	            }
	            case 90..94:
	            {
					if (PlayerInfo[playerid][Sex] == 0)
	                	AddItem(playerid, 204, 1);
					else
					    AddItem(playerid, 298, 1);
                    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{a64d79}Модный сундук", "{ffffff}Вы получили: [{a64d79}Костюм мастера боевых искусств{ffffff}].", "Закрыть", "");
	            }
	            case 95..97:
	            {
					if (PlayerInfo[playerid][Sex] == 0)
	                	AddItem(playerid, 127, 1);
					else
					    AddItem(playerid, 169, 1);
                    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{a64d79}Модный сундук", "{ffffff}Вы получили: [{a64d79}Костюм правой руки Шажка{ffffff}].", "Закрыть", "");
	            }
	            default:
	            {
					if (PlayerInfo[playerid][Sex] == 0)
	                	AddItem(playerid, 147, 1);
					else
					    AddItem(playerid, 150, 1);
                    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "{a64d79}Модный сундук", "{ffffff}Вы получили: [{a64d79}Костюм 'ВСДД'{ffffff}].", "Закрыть", "");
	            }
	        }
	        PlayerInfo[playerid][InventoryCount][slot]--;
	        if (PlayerInfo[playerid][InventoryCount][slot] <= 0) {
	            PlayerInfo[playerid][InventoryCount][slot] = 0;
	            PlayerInfo[playerid][Inventory][slot] = 0;
	        }
	        UpdateSlot(playerid, slot);
	    }
	}
}

//Получить инфо о выбранном предмете
stock GetSelectedItemInfo(playerid)
{
	//
}
//Установить указанный слот как выбранный
stock SetSlotSelection(playerid, slot, bool:selection)
{
	if (selection)
		PlayerTextDrawBackgroundColor(playerid, InvSlot[playerid][slot], 0x999999AA);
	else
		PlayerTextDrawBackgroundColor(playerid, InvSlot[playerid][slot], -1061109505);
	PlayerTextDrawHide(playerid, InvSlot[playerid][slot]);
	PlayerTextDrawShow(playerid, InvSlot[playerid][slot]);
}

//Получить кол-во пустых слотов инвентаря
stock GetInvEmptySlots(playerid)
{
	new count = 0;
	for (new i = 0; i < MAX_SLOTS; i++) {
	    if (PlayerInfo[playerid][Inventory][i] == 0)
			count++;
	}
	return count;
}

//Получить первую свободную ячейку
stock GetFirstEmptySlot(playerid)
{
	new slot = -1;
	for (new i = 0; i < MAX_SLOTS; i++) {
	    if (PlayerInfo[playerid][Inventory][i] == 0) {
	        slot = i;
	        break;
	    }
	}
	return slot;
}

//Получить ячейку предмета
stock GetItemSlot(playerid, item)
{
    new slot = -1;
	for (new i = 0; i < MAX_SLOTS; i++) {
	    if (PlayerInfo[playerid][Inventory][i] == item) {
	        slot = i;
	        break;
	    }
	}
	return slot;
}

//Добавление предмета в инвентарь
stock AddItem(playerid, item, count)
{
    new slot;
	switch (item) {
	    case 83,91,84,214,120,141,264,152,147,150,127,169,204,298,114,195,97,140,161,198,287,191,296:
	    {
	        slot = GetFirstEmptySlot(playerid);
	    }
	    default:
	    {
	        slot = GetItemSlot(playerid, item);
			if (slot == -1)
			    slot = GetFirstEmptySlot(playerid);
	    }
	}
    if (slot == -1) {
        SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка при добавлении предмета: инвентарь полон.");
        return -1;
    }
    PlayerInfo[playerid][Inventory][slot] = item;
    PlayerInfo[playerid][InventoryCount][slot] += count;
    UpdateSlot(playerid, slot);
    return slot;
}

//Удаление выбранного предмета из инвентаря
stock DeleteSelectedItem(playerid)
{
	if (SelectedSlot[playerid] == -1) return;
    PlayerInfo[playerid][Inventory][SelectedSlot[playerid]] = 0;
    PlayerInfo[playerid][InventoryCount][SelectedSlot[playerid]] = 0;
    new oldslot = SelectedSlot[playerid];
    SelectedSlot[playerid] = -1;
    UpdateSlot(playerid, oldslot);
}

//Узнать наличие предмета в инвентаре
stock IsPlayerHaveItem(playerid, itemid, count)
{
	for (new i = 0; i < MAX_SLOTS; i++)
	    if (PlayerInfo[playerid][Inventory][i] == itemid)
	        if (PlayerInfo[playerid][InventoryCount][i] >= count)
	            return true;
	return false;
}

//Установить ХП
stock SetPlayerHealthEx(playerid, Float:health)
{
	SetPlayerHealth(playerid, health);
    UpdateHPBar(playerid);
}

//Обновить hpbar
stock UpdateHPBar(playerid)
{
	new Float:hp;
	GetPlayerHealth(playerid, hp);
	new percents = floatround(hp);
	new string[64];
	format(string, sizeof(string), "%d%% %d/%d", percents, floatround(floatmul(hp, 100)), 10000);
	PlayerTextDrawSetString(playerid, HPBar[playerid], string);
}

//Обновить ячейку инвентаря
stock UpdateSlot(playerid, slot)
{
	if (!IsInventoryOpen[playerid]) return;
    PlayerTextDrawHide(playerid, InvSlot[playerid][slot]);
    PlayerTextDrawHide(playerid, InvSlotCount[playerid][slot]);
    if (PlayerInfo[playerid][Inventory][slot] == 0) {
	    SetInvModel(playerid, slot);
	    PlayerTextDrawShow(playerid, InvSlot[playerid][slot]);
	    return;
	}
    new string[16];
    format(string, sizeof(string), "%d", PlayerInfo[playerid][InventoryCount][slot]);
    PlayerTextDrawSetString(playerid, InvSlotCount[playerid][slot], string);
    SetInvModel(playerid, slot);
    PlayerTextDrawShow(playerid, InvSlot[playerid][slot]);
    PlayerTextDrawShow(playerid, InvSlotCount[playerid][slot]);
}

//Установить модель ячейки инвентаря
stock SetInvModel(playerid, slot)
{
    SetSlotSelection(playerid, slot, SelectedSlot[playerid] == slot);
	if (PlayerInfo[playerid][Inventory][slot] == 0) {
	    PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][slot], 0, 0, 0, -1);
	    PlayerTextDrawSetPreviewModel(playerid, InvSlot[playerid][slot], -1);
	    return;
	}
    PlayerTextDrawSetPreviewModel(playerid, InvSlot[playerid][slot], PlayerInfo[playerid][Inventory][slot]);
	switch (PlayerInfo[playerid][Inventory][slot]) {
	    case 336, 1221, 1224, 19577:
	    {
			PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][slot], 45.0, 30.0, 0.0, 1.0);
	    }
	    case 19893, 1581:
	    {
            PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][slot], 0.0, 0.0, 180.0, 1.0);
	    }
	    case 19572, 19918:
	    {
            PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][slot], 45.0, 0.0, 0.0, 1.0);
	    }
	    case 19054..19058:
	    {
            PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][slot], 330.0, 0.0, 0.0, 1.0);
	    }
	    case 19883:
	    {
            PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][slot], 90.0, 0.0, 0.0, 1.0);
	    }
        case 2710:
	    {
            PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][slot], 0.0, 0.0, 90.0, 1.0);
	    }
	    default:
	    {
            PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][slot], 0.0, 0.0, 0.0, 1.0);
	    }
	}	
}

//Показать интерфейс
stock ShowInterface(playerid)
{
    PlayerTextDrawShow(playerid, HPBar[playerid]);
    PlayerTextDrawShow(playerid, PanelBox[playerid]);
    PlayerTextDrawShow(playerid, PanelInfo[playerid]);
	PlayerTextDrawShow(playerid, PanelInventory[playerid]);
	PlayerTextDrawShow(playerid, PanelUndress[playerid]);
	PlayerTextDrawShow(playerid, PanelSwitch[playerid]);
	PlayerTextDrawShow(playerid, PanelDelimeter1[playerid]);
	PlayerTextDrawShow(playerid, PanelDelimeter2[playerid]);
	PlayerTextDrawShow(playerid, PanelDelimeter3[playerid]);
}

//Показать инвентарь
stock ShowInventory(playerid)
{
    SelectedSlot[playerid] = -1;
	PlayerTextDrawShow(playerid, InvBox[playerid]);
	for (new i = 0; i < MAX_SLOTS; i++) {
		PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][i], 0.0, 0.0, 0.0, -1.0);
		PlayerTextDrawBackgroundColor(playerid, InvSlot[playerid][i], -1061109505);
		if (PlayerInfo[playerid][Inventory][i] != 0) {
			new string[16];
    		format(string, sizeof(string), "%d", PlayerInfo[playerid][InventoryCount][i]);
    		PlayerTextDrawSetString(playerid, InvSlotCount[playerid][i], string);
			PlayerTextDrawShow(playerid, InvSlotCount[playerid][i]);
			SetInvModel(playerid, i);
		}
		PlayerTextDrawShow(playerid, InvSlot[playerid][i]);
	}
	PlayerTextDrawShow(playerid, btn_use[playerid]);
	PlayerTextDrawShow(playerid, btn_del[playerid]);
	PlayerTextDrawShow(playerid, btn_quick[playerid]);
	PlayerTextDrawShow(playerid, btn_info[playerid]);
	PlayerTextDrawShow(playerid, inv_ico[playerid]);
}

//Скрыть инвентарь
stock HideInventory(playerid)
{
	PlayerTextDrawHide(playerid, InvBox[playerid]);
	for (new i = 0; i < MAX_SLOTS; i++) {
		PlayerTextDrawHide(playerid, InvSlot[playerid][i]);
		PlayerTextDrawHide(playerid, InvSlotCount[playerid][i]);
	}
	PlayerTextDrawHide(playerid, btn_use[playerid]);
	PlayerTextDrawHide(playerid, btn_del[playerid]);
	PlayerTextDrawHide(playerid, btn_quick[playerid]);
	PlayerTextDrawHide(playerid, btn_info[playerid]);
	PlayerTextDrawHide(playerid, inv_ico[playerid]);
	SelectedSlot[playerid] = -1;
}

//Формирует список участников Вовака
stock CreateVovakPlayersList() {
	new players[4000] = "Имя\tКласс\tРейтинг";
	new string[128];
	new data[512];
	new rate;
	new classid;
	for (new i = 0; i < 10; i++) {
		format(string, sizeof(string), "Players/%s.ini", VovakClowns[i]);
		new File = ini_openFile(string);
		if (File < 0) {
		    SendClientMessageToAll(COLOR_LIGHTRED, "Ошибка инициализации базы данных.");
		    players = "";
		    break;
		}
		ini_getInteger(File, "Rate", rate);
		ini_getInteger(File, "Class", classid);
		ini_closeFile(File);
		format(data, sizeof(data), "\n{%s}%s\t%s\t{%s}%d", GetColorByRate(rate), VovakClowns[i], GetClassNameByID(classid), GetColorByRate(rate), rate);
		strcat(players, data);
	}
	return players;
}

//Формирует список участников Димака
stock CreateDimakPlayersList() {
	new players[4000] = "Имя\tКласс\tРейтинг";
	new string[128];
	new data[512];
	new rate;
	new classid;
	for (new i = 0; i < 10; i++) {
		format(string, sizeof(string), "Players/%s.ini", DimakClowns[i]);
		new File = ini_openFile(string);
		if (File < 0) {
		    SendClientMessageToAll(COLOR_LIGHTRED, "Ошибка инициализации базы данных.");
		    players = "";
		    break;
		}
		ini_getInteger(File, "Rate", rate);
		ini_getInteger(File, "Class", classid);
		ini_closeFile(File);
		format(data, sizeof(data), "\n{%s}%s\t%s\t{%s}%d", GetColorByRate(rate), DimakClowns[i], GetClassNameByID(classid), GetColorByRate(rate), rate);
		strcat(players, data);
	}
	return players;
}

//Возвращает цвет по рейтингу
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

//Возвращает цвет по рейтингу (hex)
stock GetHexColorByRate(rate) {
	new color;
	switch (rate) {
	    case 501..1000: color = HexRateColors[1][0];
	    case 1001..1200: color = HexRateColors[2][0];
	    case 1201..1400: color = HexRateColors[3][0];
	    case 1401..1600: color = HexRateColors[4][0];
	    case 1601..2000: color = HexRateColors[5][0];
	    case 2001..2300: color = HexRateColors[6][0];
	    case 2301..2700: color = HexRateColors[7][0];
	    case 2701..3000: color = HexRateColors[8][0];
	    default: color = HexRateColors[0][0];
	}
	return color;
}

//Возвращает имя класса по ID
stock GetClassNameByID(id) {
	new classname[32];
	switch (id) {
	    case 0: classname = "{1155cc}Фехтовальщик";
	    case 1: classname = "{bc351f}Гренадер";
	    case 2: classname = "{134f5c}Боец";
	    case 3: classname = "{f97403}Чародей";
	    case 4: classname = "{5b419b}Ассасин";
	    case 5: classname = "{9900ff}Иллюзионист";
	    default: classname = "{ffffff}Не выбран";
	}
	return classname;
}

//Возвращает интервал рейтинга по значению
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

//Получить playerid по имени
stock GetPlayerID(const player_name[])
{
    for(new i; i<MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            new pName[MAX_PLAYER_NAME];
            GetPlayerName(i, pName, sizeof(pName));
            if(strcmp(player_name, pName, true) == 0)
                return i;
        }
    }
    return -1;
}

//Обновляет рейтинг игроков
stock UpdateRatingTop()
{
    new name[128];
    new classid;
    new rate;
	new path[64];
    for (new i = 0; i < MAX_PVP_PLAYERS; i++) {
    	name = npcclowns[i];
		format(path, sizeof(path), "Players/%s.ini", name);
		new File = ini_openFile(path);
		ini_getInteger(File, "Rate", rate);
		ini_closeFile(File);
		RatingTop[i][Name] = name;
		RatingTop[i][Rate] = rate;
	}
	new tmp[TopItem];
	for(new i = 0; i < MAX_PVP_PLAYERS; i++) {
        for(new j = MAX_PVP_PLAYERS - 1; j > i; j--) {
            if(RatingTop[j-1][Rate] < RatingTop[j][Rate]) {
                tmp = RatingTop[j-1];
                RatingTop[j-1] = RatingTop[j];
                RatingTop[j] = tmp;
            }
        }
    }
    for(new i = 0; i < MAX_PVP_PLAYERS; i++) {
        format(path, sizeof(path), "Players/%s.ini", RatingTop[i][Name]);
		new File = ini_openFile(path);
		ini_setInteger(File, "TopPosition", i+1);
		ini_closeFile(File);
    }
}

//Получает цвет места
stock GetPlaceColor(place)
{
    new color[16];
	switch (place) {
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

//Отображает топ участников для игрока
stock ShowRatingTop(playerid)
{
	new top[4000] = "№ п\\п\tИмя\tРейтинг";
	new string[455];
	for (new i = 0; i < MAX_CLOWNS; i++) {
		format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t{%s}%d", GetPlaceColor(i+1), i+1, GetColorByRate(RatingTop[i][Rate]), RatingTop[i][Name], GetColorByRate(RatingTop[i][Rate]), RatingTop[i][Rate]);
		strcat(top, string);
	}
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST_HEADERS, "Рейтинг игроков", top, "Закрыть", "");
}

//Загрузка аккаунта
stock LoadAccount(playerid) {
	new name[64];
	new string[255];
	GetPlayerName(playerid, name, sizeof(name));
    new path[128];
	format(path, sizeof(path), "Players/%s.ini", name);
	new File = ini_openFile(path);
	if (!File)
		return -1;

	ini_getInteger(File, "Sex", PlayerInfo[playerid][Sex]);
	ini_getInteger(File, "Rate", PlayerInfo[playerid][Rate]);
    ini_getInteger(File, "Class", PlayerInfo[playerid][Class]);
    ini_getInteger(File, "Cash", PlayerInfo[playerid][Cash]);
    ini_getInteger(File, "Bank", PlayerInfo[playerid][Bank]);
    ini_getInteger(File, "QItem", PlayerInfo[playerid][QItem]);
    ini_getInteger(File, "Admin", PlayerInfo[playerid][Admin]);
    ini_getInteger(File, "Skin", PlayerInfo[playerid][Skin]);
    ini_getInteger(File, "Wins", PlayerInfo[playerid][Wins]);
    ini_getInteger(File, "Loses", PlayerInfo[playerid][Loses]);
    ini_getInteger(File, "TopPosition", PlayerInfo[playerid][TopPosition]);
	ini_getInteger(File, "Reaction", PlayerInfo[playerid][Reaction]);
	ini_getFloat(File, "PAccuracy", PlayerInfo[playerid][PAccuracy]);
	ini_getFloat(File, "RangeRate", PlayerInfo[playerid][RangeRate]);
    ini_getFloat(File, "PosX", PlayerInfo[playerid][PosX]);
    ini_getFloat(File, "PosY", PlayerInfo[playerid][PosY]);
    ini_getFloat(File, "PosZ", PlayerInfo[playerid][PosZ]);
    ini_getFloat(File, "Angle", PlayerInfo[playerid][FacingAngle]);
    ini_getInteger(File, "Interior", PlayerInfo[playerid][Interior]);
    for (new j = 0; j < MAX_SLOTS; j++) {
        format(string, sizeof(string), "InventorySlot%d", j);
        ini_getInteger(File, string, PlayerInfo[playerid][Inventory][j]);
        format(string, sizeof(string), "InventorySlotCount%d", j);
        ini_getInteger(File, string, PlayerInfo[playerid][InventoryCount][j]);
    }
    ini_closeFile(File);
    SetPlayerName(playerid, name);
    SetPlayerParams(playerid);
	return 1;
}

//Сохранение аккаунта
stock SaveAccount(playerid) {
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
	
	ini_setInteger(File, "Sex", PlayerInfo[playerid][Sex]);
	ini_setInteger(File, "Rate", PlayerInfo[playerid][Rate]);
    ini_setInteger(File, "Class", PlayerInfo[playerid][Class]);
    ini_setInteger(File, "Cash", PlayerInfo[playerid][Cash]);
    ini_setInteger(File, "Bank", PlayerInfo[playerid][Bank]);
    ini_setInteger(File, "QItem", PlayerInfo[playerid][QItem]);
    ini_setInteger(File, "Admin", PlayerInfo[playerid][Admin]);
    ini_setInteger(File, "Skin", PlayerInfo[playerid][Skin]);
    ini_setInteger(File, "Wins", PlayerInfo[playerid][Wins]);
    ini_setInteger(File, "Loses", PlayerInfo[playerid][Loses]);
    ini_setInteger(File, "TopPosition", PlayerInfo[playerid][TopPosition]);
	ini_setInteger(File, "Reaction", PlayerInfo[playerid][Reaction]);
	ini_setFloat(File, "PAccuracy", PlayerInfo[playerid][PAccuracy]);
	ini_setFloat(File, "RangeRate", PlayerInfo[playerid][RangeRate]);
    ini_setFloat(File, "PosX", PlayerInfo[playerid][PosX]);
    ini_setFloat(File, "PosY", PlayerInfo[playerid][PosY]);
    ini_setFloat(File, "PosZ", PlayerInfo[playerid][PosZ]);
    ini_setFloat(File, "Angle", PlayerInfo[playerid][FacingAngle]);
    ini_setInteger(File, "Interior", PlayerInfo[playerid][Interior]);
    for (new j = 0; j < MAX_SLOTS; j++) {
        format(string, sizeof(string), "InventorySlot%d", j);
        ini_setInteger(File, string, PlayerInfo[playerid][Inventory][j]);
        format(string, sizeof(string), "InventorySlotCount%d", j);
        ini_setInteger(File, string, PlayerInfo[playerid][InventoryCount][j]);
    }
    ini_closeFile(File);
	return 1;
}
stock CreateAccount(name[])
{
	new string[255];
	new path[128];
	format(path, sizeof(path), "Players/%s.ini", name);
	new File = ini_createFile(path);
	if(File < 0)
		File = ini_openFile(path);
	if(!File)
		return -1;

	ini_setInteger(File, "Sex", 0);
	ini_setInteger(File, "Rate", 0);
    ini_setInteger(File, "Class", -1);
    ini_setInteger(File, "Cash", 0);
    ini_setInteger(File, "Bank", 0);
    ini_setInteger(File, "QItem", -1);
    ini_setInteger(File, "Admin", 0);
    ini_setInteger(File, "Skin", 0);
    ini_setInteger(File, "Wins", 0);
    ini_setInteger(File, "Loses", 0);
    ini_setInteger(File, "TopPosition", 0);
	ini_setInteger(File, "Reaction", 0);
	ini_setFloat(File, "PAccuracy", 0);
	ini_setFloat(File, "RangeRate", 0);
    ini_setFloat(File, "PosX", 0);
    ini_setFloat(File, "PosY", 0);
    ini_setFloat(File, "PosZ", 0);
    ini_setFloat(File, "Angle", 0);
    ini_setInteger(File, "Interior", 0);
    for (new j = 0; j < MAX_SLOTS; j++) {
        format(string, sizeof(string), "InventorySlot%d", j);
        ini_setInteger(File, string, -1);
        format(string, sizeof(string), "InventorySlotCount%d", j);
        ini_setInteger(File, string, 0);
    }
    ini_closeFile(File);
	return 1;
}

//Загрузка пикапов
stock CreatePickups()
{
    home_enter = CreatePickup(1318,23,224.0201,-1837.3518,4.2787);
    home_quit = CreatePickup(1318,23,-2158.6240,642.8425,1052.3750);
    adm_enter = CreatePickup(19130,23,-2170.3340,635.3892,1052.3750);
    adm_quit = CreatePickup(19130,23,-2029.7946,-119.6238,1035.1719);
    cafe_enter = CreatePickup(19133,23,184.5765,-1823.2200,5.1312);
    cafe_quit = CreatePickup(19133,23,460.5555,-88.6005,999.5547);
    rest_enter = CreatePickup(19133,23,265.0125,-1822.7384,4.2996);
    rest_quit = CreatePickup(19133,23,377.0888,-193.3045,1000.6328);
    shop_enter = CreatePickup(19133,23,255.8797,-1786.0399,4.2521);
    shop_quit = CreatePickup(19133,23,-27.4040,-58.2740,1003.5469);
    start_tp1 = CreatePickup(19605,23,243.1539,-1831.6542,3.3772);
    start_tp2 = CreatePickup(19607,23,204.7617,-1831.6539,3.3772);
    
    Create3DTextLabel("Clown's House",0xf2622bFF,224.0201,-1837.3518,4.2787,70.0,0,1);
    Create3DTextLabel("Администрация",0x990000FF,-2170.3340,635.3892,1052.3750,70.0,0,1);
    Create3DTextLabel("Кафе 'У Люси'",0x9fc91fFF,184.5765,-1823.2200,5.1312,70.0,0,1);
    Create3DTextLabel("Pepe's Restaurant",0xead11fFF,265.0125,-1822.7384,4.2996,70.0,0,1);
    Create3DTextLabel("Circus 24/7",0x1f95eaFF,255.8797,-1786.0399,4.2521,70.0,0,1);
    Create3DTextLabel("К боссам",0xeaeaeaFF,243.1539,-1831.6542,3.9772,70.0,0,1);
    Create3DTextLabel("На арену",0xeaeaeaFF,204.7617,-1831.6539,4.1772,70.0,0,1);
    Create3DTextLabel("Доска почета",0xFFCC00FF,-2171.3132,645.5896,1053.3817,5.0,0,1);
    
    Create3DTextLabel("Нажмите [F] для взаимодействия",0xFFCC00FF,-23.4700,-57.3214,1003.5469,5.0,0,1);
    Create3DTextLabel("Нажмите [F] для взаимодействия",0xFFCC00FF,380.7459,-189.1151,1000.6328,5.0,0,1);
    Create3DTextLabel("Нажмите [F] для взаимодействия",0xFFCC00FF,450.5763,-82.2320,999.5547,5.0,0,1);
    Create3DTextLabel("Нажмите [F] для взаимодействия",0xFFCC00FF,-2166.7527,646.0400,1052.3750,5.0,0,1);
    
	Actors[0] =	CreateActor(155,450.5763,-82.2320,999.5547,180.2773);
	Actors[1] =	CreateActor(171,380.7459,-189.1151,1000.6328,180.5317);
	Actors[2] =	CreateActor(226,-23.4700,-57.3214,1003.5469,354.9999);
	Actors[3] =	CreateActor(61,-2166.7527,646.0400,1052.3750,179.9041);
}

//Отображение textdraw-ов
stock ShowTextDraws(playerid)
{
	TextDrawShowForPlayer(playerid,GamemodeName);
	TextDrawShowForPlayer(playerid,WorldTime);
}

//Отображние ВСЕХ textdraws
stock ShowAllTextDraws(playerid)
{
	PlayerTextDrawShow(playerid, TourPanelBox[playerid]);
	PlayerTextDrawShow(playerid, TourPlayerName1[playerid]);
	PlayerTextDrawShow(playerid, TourPlayerName2[playerid]);
	PlayerTextDrawShow(playerid, TourScoreBar[playerid]);
	PlayerTextDrawShow(playerid, HPBar[playerid]);
	PlayerTextDrawShow(playerid, InvBox[playerid]);
	for (new i = 0; i < MAX_SLOTS; i++) {
		PlayerTextDrawShow(playerid, InvSlot[playerid][i]);
		PlayerTextDrawShow(playerid, InvSlotCount[playerid][i]);
	}
	PlayerTextDrawShow(playerid, PanelInfo[playerid]);
	PlayerTextDrawShow(playerid, PanelInventory[playerid]);
	PlayerTextDrawShow(playerid, PanelUndress[playerid]);
	PlayerTextDrawShow(playerid, PanelBox[playerid]);
	PlayerTextDrawShow(playerid, PanelDelimeter1[playerid]);
	PlayerTextDrawShow(playerid, PanelDelimeter2[playerid]);
	PlayerTextDrawShow(playerid, btn_use[playerid]);
	PlayerTextDrawShow(playerid, btn_del[playerid]);
	PlayerTextDrawShow(playerid, btn_quick[playerid]);
	PlayerTextDrawShow(playerid, btn_info[playerid]);
	PlayerTextDrawShow(playerid, blue_flag[playerid]);
	PlayerTextDrawShow(playerid, red_flag[playerid]);
	PlayerTextDrawShow(playerid, inv_ico[playerid]);
	for (new i = 0; i < MAX_EFFECTS; i++) {
		PlayerTextDrawShow(playerid, EBox[playerid][i]);
		PlayerTextDrawShow(playerid, EBox_Time[playerid][i]);
	}
	for (new i = 0; i < MAX_SKILLS; i++) {
		PlayerTextDrawShow(playerid, SkillIco[playerid][i]);
		PlayerTextDrawShow(playerid, SkillButton[playerid][i]);
		PlayerTextDrawShow(playerid, SkillTime[playerid][i]);
	}
}

//Удаление textdraw-ов
stock DeleteTextDraws()
{
	TextDrawDestroy(GamemodeName);
	TextDrawDestroy(WorldTime);
}

//Удаление textdraw-ов (игрок)
stock DeletePlayerTextDraws(playerid)
{
	PlayerTextDrawDestroy(playerid, TourPanelBox[playerid]);
	PlayerTextDrawDestroy(playerid, TourPlayerName1[playerid]);
	PlayerTextDrawDestroy(playerid, TourPlayerName2[playerid]);
	PlayerTextDrawDestroy(playerid, HPBar[playerid]);
	PlayerTextDrawDestroy(playerid, InvBox[playerid]);
	for (new i = 0; i < MAX_SLOTS; i++) {
		PlayerTextDrawDestroy(playerid, InvSlot[playerid][i]);
		PlayerTextDrawDestroy(playerid, InvSlotCount[playerid][i]);
	}
	PlayerTextDrawDestroy(playerid, PanelInfo[playerid]);
	PlayerTextDrawDestroy(playerid, PanelInventory[playerid]);
	PlayerTextDrawDestroy(playerid, PanelUndress[playerid]);
	PlayerTextDrawDestroy(playerid, PanelBox[playerid]);
	PlayerTextDrawDestroy(playerid, PanelDelimeter1[playerid]);
	PlayerTextDrawDestroy(playerid, PanelDelimeter2[playerid]);
	PlayerTextDrawDestroy(playerid, btn_use[playerid]);
	PlayerTextDrawDestroy(playerid, btn_del[playerid]);
	PlayerTextDrawDestroy(playerid, btn_quick[playerid]);
	PlayerTextDrawDestroy(playerid, btn_info[playerid]);
	PlayerTextDrawDestroy(playerid, blue_flag[playerid]);
	PlayerTextDrawDestroy(playerid, red_flag[playerid]);
	PlayerTextDrawDestroy(playerid, inv_ico[playerid]);
	for (new i = 0; i < MAX_EFFECTS; i++) {
		PlayerTextDrawDestroy(playerid, EBox[playerid][i]);
		PlayerTextDrawDestroy(playerid, EBox_Time[playerid][i]);
	}
	for (new i = 0; i < MAX_SKILLS; i++) {
		PlayerTextDrawDestroy(playerid, SkillIco[playerid][i]);
		PlayerTextDrawDestroy(playerid, SkillButton[playerid][i]);
		PlayerTextDrawDestroy(playerid, SkillTime[playerid][i]);
	}
}

//Инициализация textdraw-ов
stock InitTextDraws()
{
    GamemodeName = TextDrawCreate(547.367431, 22.980691, "RCircus 1.0");
	TextDrawLetterSize(GamemodeName, 0.415998, 1.886222);
	TextDrawAlignment(GamemodeName, 1);
	TextDrawColor(GamemodeName, -5963521);
	TextDrawSetShadow(GamemodeName, 1);
	TextDrawSetOutline(GamemodeName, 0);
	TextDrawBackgroundColor(GamemodeName, 51);
	TextDrawFont(GamemodeName, 1);
	TextDrawSetProportional(GamemodeName, 1);
	TextDrawSetPreviewModel(GamemodeName, 0);
	TextDrawSetPreviewRot(GamemodeName, 0.000000, 0.000000, 0.000000, 0.000000);

    WorldTime = TextDrawCreate(578.033020, 42.103794, "00:00");
	TextDrawLetterSize(WorldTime, 0.433663, 2.168296);
	TextDrawAlignment(WorldTime, 2);
	TextDrawColor(WorldTime, -1061109505);
	TextDrawSetShadow(WorldTime, 0);
	TextDrawSetOutline(WorldTime, 1);
	TextDrawBackgroundColor(WorldTime, 51);
	TextDrawFont(WorldTime, 2);
	TextDrawSetProportional(WorldTime, 1);
}

//Инициализация textdraw-ов (игрок)
stock InitPlayerTextDraws(playerid)
{
    TourPanelBox[playerid] = CreatePlayerTextDraw(playerid, 641.666687, 429.174072, "TourPanelBox");
	PlayerTextDrawLetterSize(playerid, TourPanelBox[playerid], 0.000000, 1.895681);
	PlayerTextDrawTextSize(playerid, TourPanelBox[playerid], -2.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, TourPanelBox[playerid], 1);
	PlayerTextDrawColor(playerid, TourPanelBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, TourPanelBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, TourPanelBox[playerid], 102);
	PlayerTextDrawSetShadow(playerid, TourPanelBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, TourPanelBox[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, TourPanelBox[playerid], -16776961);
	PlayerTextDrawFont(playerid, TourPanelBox[playerid], 0);

	TourPlayerName1[playerid] = CreatePlayerTextDraw(playerid, 4.666664, 429.043029, "Dmitriy_Staroverov [GR]");
	PlayerTextDrawLetterSize(playerid, TourPlayerName1[playerid], 0.370999, 1.707851);
	PlayerTextDrawAlignment(playerid, TourPlayerName1[playerid], 1);
	PlayerTextDrawColor(playerid, TourPlayerName1[playerid], -1061109505);
	PlayerTextDrawSetShadow(playerid, TourPlayerName1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, TourPlayerName1[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, TourPlayerName1[playerid], 51);
	PlayerTextDrawFont(playerid, TourPlayerName1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TourPlayerName1[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, TourPlayerName1[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, TourPlayerName1[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	TourPlayerName2[playerid] = CreatePlayerTextDraw(playerid, 637.066345, 428.798431, "Alexander_Shaikin [IL]");
	PlayerTextDrawLetterSize(playerid, TourPlayerName2[playerid], 0.370999, 1.707851);
	PlayerTextDrawAlignment(playerid, TourPlayerName2[playerid], 3);
	PlayerTextDrawColor(playerid, TourPlayerName2[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, TourPlayerName2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, TourPlayerName2[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, TourPlayerName2[playerid], 51);
	PlayerTextDrawFont(playerid, TourPlayerName2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TourPlayerName2[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, TourPlayerName2[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, TourPlayerName2[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	HPBar[playerid] = CreatePlayerTextDraw(playerid, 577.659973, 67.550003, "100% 10000/10000");
	PlayerTextDrawLetterSize(playerid, HPBar[playerid], 0.134663, 0.666665);
	PlayerTextDrawAlignment(playerid, HPBar[playerid], 2);
	PlayerTextDrawColor(playerid, HPBar[playerid], 255);
	PlayerTextDrawSetShadow(playerid, HPBar[playerid], 0);
	PlayerTextDrawSetOutline(playerid, HPBar[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, HPBar[playerid], 51);
	PlayerTextDrawFont(playerid, HPBar[playerid], 2);
	PlayerTextDrawSetProportional(playerid, HPBar[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, HPBar[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, HPBar[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	TourScoreBar[playerid] = CreatePlayerTextDraw(playerid, 294.033538, 428.296325, "1  -  0");
	PlayerTextDrawLetterSize(playerid, TourScoreBar[playerid], 0.508665, 2.085334);
	PlayerTextDrawAlignment(playerid, TourScoreBar[playerid], 1);
	PlayerTextDrawColor(playerid, TourScoreBar[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, TourScoreBar[playerid], 0);
	PlayerTextDrawSetOutline(playerid, TourScoreBar[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, TourScoreBar[playerid], 51);
	PlayerTextDrawFont(playerid, TourScoreBar[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TourScoreBar[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, TourScoreBar[playerid], 19134);
	PlayerTextDrawSetPreviewRot(playerid, TourScoreBar[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	InvBox[playerid] = CreatePlayerTextDraw(playerid, 513.499938, 181.944458, "InvBox");
	PlayerTextDrawLetterSize(playerid, InvBox[playerid], 0.000000, 14.641860);
	PlayerTextDrawTextSize(playerid, InvBox[playerid], 614.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, InvBox[playerid], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, InvBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid], 102);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid], 0);
	PlayerTextDrawFont(playerid, InvBox[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, InvBox[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, InvBox[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	new inv_slot_x = 514;
	new inv_slot_y = 183;
	new idx = 0;
	for (new i = 1; i <= 4; i++) {
	    for (new j = 1; j <= 4; j++) {
	        InvSlot[playerid][idx] = CreatePlayerTextDraw(playerid, inv_slot_x, inv_slot_y, "LD_SPAC:white");
	        PlayerTextDrawLetterSize(playerid, InvSlot[playerid][idx], 0.000000, 0.000000);
			PlayerTextDrawTextSize(playerid, InvSlot[playerid][idx], 24.000000, 25.000000);
			PlayerTextDrawAlignment(playerid, InvSlot[playerid][idx], 2);
			PlayerTextDrawColor(playerid, InvSlot[playerid][idx], -1);
			PlayerTextDrawUseBox(playerid, InvSlot[playerid][idx], true);
			PlayerTextDrawBoxColor(playerid, InvSlot[playerid][idx], 0);
			PlayerTextDrawSetShadow(playerid, InvSlot[playerid][idx], 0);
			PlayerTextDrawSetOutline(playerid, InvSlot[playerid][idx], 0);
			PlayerTextDrawBackgroundColor(playerid, InvSlot[playerid][idx], -1061109505);
			PlayerTextDrawFont(playerid, InvSlot[playerid][idx], 5);
			PlayerTextDrawSetProportional(playerid, InvSlot[playerid][idx], 1);
			PlayerTextDrawSetSelectable(playerid, InvSlot[playerid][idx], true);
			PlayerTextDrawSetPreviewModel(playerid, InvSlot[playerid][idx], -1);
			PlayerTextDrawSetPreviewRot(playerid, InvSlot[playerid][idx], 0.000000, 0.000000, 0.000000, 1.000000);
	        inv_slot_x += 25;
	        idx++;
	    }
	    inv_slot_x = 514;
	    inv_slot_y += 26;
	}
	
	PanelBox[playerid] = CreatePlayerTextDraw(playerid, 621.566833, 181.529617, "PanelBox");
	PlayerTextDrawLetterSize(playerid, PanelBox[playerid], 0.000000, 9.711589);
	PlayerTextDrawTextSize(playerid, PanelBox[playerid], 637.333251, 0.000000);
	PlayerTextDrawAlignment(playerid, PanelBox[playerid], 1);
	PlayerTextDrawColor(playerid, PanelBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, PanelBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, PanelBox[playerid], 102);
	PlayerTextDrawSetShadow(playerid, PanelBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PanelBox[playerid], 0);
	PlayerTextDrawFont(playerid, PanelBox[playerid], 0);

	PanelInfo[playerid] = CreatePlayerTextDraw(playerid, 620.666625, 181.688888, "PanelInfo");
	PlayerTextDrawLetterSize(playerid, PanelInfo[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PanelInfo[playerid], 16.666687, 17.837036);
	PlayerTextDrawAlignment(playerid, PanelInfo[playerid], 2);
	PlayerTextDrawColor(playerid, PanelInfo[playerid], -1);
	PlayerTextDrawUseBox(playerid, PanelInfo[playerid], true);
	PlayerTextDrawBoxColor(playerid, PanelInfo[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, PanelInfo[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, PanelInfo[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PanelInfo[playerid], 0);
	PlayerTextDrawFont(playerid, PanelInfo[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, PanelInfo[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PanelInfo[playerid], 1239);
	PlayerTextDrawSetPreviewRot(playerid, PanelInfo[playerid], 0.000000, 0.000000, 180.000000, 1.000000);

	PanelInventory[playerid] = CreatePlayerTextDraw(playerid, 620.666625, 204.503707, "PanelInventory");
	PlayerTextDrawLetterSize(playerid, PanelInventory[playerid], 0.000000, -0.066665);
	PlayerTextDrawTextSize(playerid, PanelInventory[playerid], 18.666687, 20.740722);
	PlayerTextDrawAlignment(playerid, PanelInventory[playerid], 1);
	PlayerTextDrawColor(playerid, PanelInventory[playerid], -2147483393);
	PlayerTextDrawUseBox(playerid, PanelInventory[playerid], true);
	PlayerTextDrawBoxColor(playerid, PanelInventory[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, PanelInventory[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, PanelInventory[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PanelInventory[playerid], 0);
	PlayerTextDrawFont(playerid, PanelInventory[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, PanelInventory[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PanelInventory[playerid], 1210);
	PlayerTextDrawSetPreviewRot(playerid, PanelInventory[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	
	PanelUndress[playerid] = CreatePlayerTextDraw(playerid, 620.999877, 228.562988, "PanelUndress");
	PlayerTextDrawLetterSize(playerid, PanelUndress[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PanelUndress[playerid], 17.333396, 18.251846);
	PlayerTextDrawAlignment(playerid, PanelUndress[playerid], 1);
	PlayerTextDrawColor(playerid, PanelUndress[playerid], -1);
	PlayerTextDrawUseBox(playerid, PanelUndress[playerid], true);
	PlayerTextDrawBoxColor(playerid, PanelUndress[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, PanelUndress[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, PanelUndress[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PanelUndress[playerid], 0);
	PlayerTextDrawFont(playerid, PanelUndress[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, PanelUndress[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PanelUndress[playerid], 1275);
	PlayerTextDrawSetPreviewRot(playerid, PanelUndress[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	
	PanelSwitch[playerid] = CreatePlayerTextDraw(playerid, 621.233093, 249.557052, "PanelSwitch");
	PlayerTextDrawLetterSize(playerid, PanelSwitch[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PanelSwitch[playerid], 16.566728, 18.251846);
	PlayerTextDrawAlignment(playerid, PanelSwitch[playerid], 1);
	PlayerTextDrawColor(playerid, PanelSwitch[playerid], -1);
	PlayerTextDrawUseBox(playerid, PanelSwitch[playerid], true);
	PlayerTextDrawBoxColor(playerid, PanelSwitch[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, PanelSwitch[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, PanelSwitch[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PanelSwitch[playerid], 0);
	PlayerTextDrawFont(playerid, PanelSwitch[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, PanelSwitch[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, PanelSwitch[playerid], 18963);
	PlayerTextDrawSetPreviewRot(playerid, PanelSwitch[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	
	PanelDelimeter1[playerid] = CreatePlayerTextDraw(playerid, 621.333312, 202.014846, "PanelDelimeter1");
	PlayerTextDrawLetterSize(playerid, PanelDelimeter1[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PanelDelimeter1[playerid], 17.666624, 1.244444);
	PlayerTextDrawAlignment(playerid, PanelDelimeter1[playerid], 1);
	PlayerTextDrawColor(playerid, PanelDelimeter1[playerid], -1);
	PlayerTextDrawUseBox(playerid, PanelDelimeter1[playerid], true);
 	PlayerTextDrawBoxColor(playerid, PanelDelimeter1[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, PanelDelimeter1[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, PanelDelimeter1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PanelDelimeter1[playerid], 0);
	PlayerTextDrawFont(playerid, PanelDelimeter1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, PanelDelimeter1[playerid], 18657);
	PlayerTextDrawSetPreviewRot(playerid, PanelDelimeter1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	PanelDelimeter2[playerid] = CreatePlayerTextDraw(playerid, 620.333312, 226.074050, "PanelDelimeter2");
	PlayerTextDrawLetterSize(playerid, PanelDelimeter2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PanelDelimeter2[playerid], 17.666687, 1.244475);
	PlayerTextDrawAlignment(playerid, PanelDelimeter2[playerid], 1);
	PlayerTextDrawColor(playerid, PanelDelimeter2[playerid], -1);
	PlayerTextDrawUseBox(playerid, PanelDelimeter2[playerid], true);
	PlayerTextDrawBoxColor(playerid, PanelDelimeter2[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, PanelDelimeter2[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, PanelDelimeter2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PanelDelimeter2[playerid], 0);
	PlayerTextDrawFont(playerid, PanelDelimeter2[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, PanelDelimeter2[playerid], 18657);
	PlayerTextDrawSetPreviewRot(playerid, PanelDelimeter2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	
	PanelDelimeter3[playerid] = CreatePlayerTextDraw(playerid, 620.333007, 248.000000, "PanelDelimeter3");
	PlayerTextDrawLetterSize(playerid, PanelDelimeter3[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PanelDelimeter3[playerid], 17.666687, 1.244475);
	PlayerTextDrawAlignment(playerid, PanelDelimeter3[playerid], 1);
	PlayerTextDrawColor(playerid, PanelDelimeter3[playerid], -1);
	PlayerTextDrawUseBox(playerid, PanelDelimeter3[playerid], true);
	PlayerTextDrawBoxColor(playerid, PanelDelimeter3[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, PanelDelimeter3[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, PanelDelimeter3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PanelDelimeter3[playerid], 0);
	PlayerTextDrawFont(playerid, PanelDelimeter3[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, PanelDelimeter3[playerid], 18657);
	PlayerTextDrawSetPreviewRot(playerid, PanelDelimeter3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	btn_use[playerid] = CreatePlayerTextDraw(playerid, 514.000000, 290.000000, "btn_use");
	PlayerTextDrawLetterSize(playerid, btn_use[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, btn_use[playerid], 24.000000, 25.000000);
	PlayerTextDrawAlignment(playerid, btn_use[playerid], 2);
	PlayerTextDrawColor(playerid, btn_use[playerid], -1);
	PlayerTextDrawUseBox(playerid, btn_use[playerid], true);
	PlayerTextDrawBoxColor(playerid, btn_use[playerid], 0);
	PlayerTextDrawSetShadow(playerid, btn_use[playerid], 0);
	PlayerTextDrawSetOutline(playerid, btn_use[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, btn_use[playerid], 2424832);
	PlayerTextDrawFont(playerid, btn_use[playerid], 5);
	PlayerTextDrawSetProportional(playerid, btn_use[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, btn_use[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, btn_use[playerid], 19131);
	PlayerTextDrawSetPreviewRot(playerid, btn_use[playerid], 0.000000, 90.000000, 90.000000, 1.000000);

	btn_info[playerid] = CreatePlayerTextDraw(playerid, 539.000000, 290.000000, "btn_info");
	PlayerTextDrawLetterSize(playerid, btn_info[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, btn_info[playerid], 24.000000, 25.000000);
	PlayerTextDrawAlignment(playerid, btn_info[playerid], 2);
	PlayerTextDrawColor(playerid, btn_info[playerid], -1);
	PlayerTextDrawUseBox(playerid, btn_info[playerid], true);
	PlayerTextDrawBoxColor(playerid, btn_info[playerid], 0);
	PlayerTextDrawSetShadow(playerid, btn_info[playerid], 0);
	PlayerTextDrawSetOutline(playerid, btn_info[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, btn_info[playerid], 2424832);
	PlayerTextDrawFont(playerid, btn_info[playerid], 5);
	PlayerTextDrawSetProportional(playerid, btn_info[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, btn_info[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, btn_info[playerid], 1239);
	PlayerTextDrawSetPreviewRot(playerid, btn_info[playerid], 0.000000, 0.000000, 180.000000, 1.000000);

	btn_del[playerid] = CreatePlayerTextDraw(playerid, 564.000000, 290.000000, "btn_del");
	PlayerTextDrawLetterSize(playerid, btn_del[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, btn_del[playerid], 24.000000, 25.000000);
	PlayerTextDrawAlignment(playerid, btn_del[playerid], 2);
	PlayerTextDrawColor(playerid, btn_del[playerid], -1);
	PlayerTextDrawUseBox(playerid, btn_del[playerid], true);
	PlayerTextDrawBoxColor(playerid, btn_del[playerid], 0);
	PlayerTextDrawSetShadow(playerid, btn_del[playerid], 0);
	PlayerTextDrawSetOutline(playerid, btn_del[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, btn_del[playerid], 2424832);
	PlayerTextDrawFont(playerid, btn_del[playerid], 5);
	PlayerTextDrawSetProportional(playerid, btn_del[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, btn_del[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, btn_del[playerid], 1409);
	PlayerTextDrawSetPreviewRot(playerid, btn_del[playerid], 0.000000, 0.000000, 180.000000, 1.000000);

	btn_quick[playerid] = CreatePlayerTextDraw(playerid, 589.000000, 290.000000, "btn_quick");
	PlayerTextDrawLetterSize(playerid, btn_quick[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, btn_quick[playerid], 24.000000, 25.000000);
	PlayerTextDrawAlignment(playerid, btn_quick[playerid], 2);
	PlayerTextDrawColor(playerid, btn_quick[playerid], -1);
	PlayerTextDrawUseBox(playerid, btn_quick[playerid], true);
	PlayerTextDrawBoxColor(playerid, btn_quick[playerid], 0);
	PlayerTextDrawSetShadow(playerid, btn_quick[playerid], 0);
	PlayerTextDrawSetOutline(playerid, btn_quick[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, btn_quick[playerid], 2424832);
	PlayerTextDrawFont(playerid, btn_quick[playerid], 5);
	PlayerTextDrawSetProportional(playerid, btn_quick[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, btn_quick[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, btn_quick[playerid], 1273);
	PlayerTextDrawSetPreviewRot(playerid, btn_quick[playerid], 0.000000, 0.000000, 180.000000, 1.000000);

	blue_flag[playerid] = CreatePlayerTextDraw(playerid, 271.800048, 428.959960, "blue_flag");
	PlayerTextDrawLetterSize(playerid, blue_flag[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, blue_flag[playerid], 17.000000, 18.000000);
	PlayerTextDrawAlignment(playerid, blue_flag[playerid], 1);
	PlayerTextDrawColor(playerid, blue_flag[playerid], -1);
	PlayerTextDrawUseBox(playerid, blue_flag[playerid], true);
	PlayerTextDrawBoxColor(playerid, blue_flag[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, blue_flag[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, blue_flag[playerid], 0);
	PlayerTextDrawSetOutline(playerid, blue_flag[playerid], 0);
	PlayerTextDrawFont(playerid, blue_flag[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, blue_flag[playerid], 19307);
	PlayerTextDrawSetPreviewRot(playerid, blue_flag[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	red_flag[playerid] = CreatePlayerTextDraw(playerid, 318.299957, 429.124633, "red_flag");
	PlayerTextDrawLetterSize(playerid, red_flag[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, red_flag[playerid], 35.533332, 18.000000);
	PlayerTextDrawAlignment(playerid, red_flag[playerid], 1);
	PlayerTextDrawColor(playerid, red_flag[playerid], -1);
	PlayerTextDrawUseBox(playerid, red_flag[playerid], true);
	PlayerTextDrawBoxColor(playerid, red_flag[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, red_flag[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, red_flag[playerid], 0);
	PlayerTextDrawSetOutline(playerid, red_flag[playerid], 0);
	PlayerTextDrawFont(playerid, red_flag[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, red_flag[playerid], 19306);
	PlayerTextDrawSetPreviewRot(playerid, red_flag[playerid], 0.000000, 0.000000, 200.000000, 1.000000);

	inv_ico[playerid] = CreatePlayerTextDraw(playerid, 547.766601, 162.358520, "inv_ico");
	PlayerTextDrawLetterSize(playerid, inv_ico[playerid], 0.000000, 1.666666);
	PlayerTextDrawTextSize(playerid, inv_ico[playerid], 30.433334, 23.000000);
	PlayerTextDrawAlignment(playerid, inv_ico[playerid], 1);
	PlayerTextDrawColor(playerid, inv_ico[playerid], -1);
	PlayerTextDrawUseBox(playerid, inv_ico[playerid], true);
 	PlayerTextDrawBoxColor(playerid, inv_ico[playerid], 0x00000000);
	PlayerTextDrawBackgroundColor(playerid, inv_ico[playerid], 0x00000000);
	PlayerTextDrawSetShadow(playerid, inv_ico[playerid], 0);
	PlayerTextDrawSetOutline(playerid, inv_ico[playerid], 0);
	PlayerTextDrawFont(playerid, inv_ico[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, inv_ico[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, inv_ico[playerid], 1210);
	PlayerTextDrawSetPreviewRot(playerid, inv_ico[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	new invslot_count_x = 537;
	new invslot_count_y = 200;
	idx = 0;
	for (new i = 1; i <= 4; i++) {
	    for (new j = 1; j <= 4; j++) {
	        InvSlotCount[playerid][idx] = CreatePlayerTextDraw(playerid, invslot_count_x, invslot_count_y, "0");
			PlayerTextDrawLetterSize(playerid, InvSlotCount[playerid][idx], 0.196998, 0.762072);
			PlayerTextDrawAlignment(playerid, InvSlotCount[playerid][idx], 3);
			PlayerTextDrawColor(playerid, InvSlotCount[playerid][idx], 255);
			PlayerTextDrawSetShadow(playerid, InvSlotCount[playerid][idx], 0);
			PlayerTextDrawSetOutline(playerid, InvSlotCount[playerid][idx], 0);
			PlayerTextDrawBackgroundColor(playerid, InvSlotCount[playerid][idx], 51);
			PlayerTextDrawFont(playerid, InvSlotCount[playerid][idx], 1);
			PlayerTextDrawSetProportional(playerid, InvSlotCount[playerid][idx], 1);
	        invslot_count_x += 25;
	        idx++;
	    }
	    invslot_count_x = 537;
	    invslot_count_y += 26;
	}
}

//Загрузка объектов
stock CreateMap()
{
    AddStaticVehicleEx(481,211.3000000,-1836.1000000,3.3000000,90.0000000,228,4,60); //BMX
	AddStaticVehicleEx(481,211.3999900,-1834.5000000,3.3000000,90.0000000,228,4,60); //BMX
	AddStaticVehicleEx(481,211.6000100,-1832.7000000,3.3000000,90.0000000,228,4,60); //BMX
	AddStaticVehicleEx(481,211.8000000,-1830.6000000,3.3000000,90.0000000,228,4,60); //BMX
	AddStaticVehicleEx(481,236.7000000,-1836.8000000,3.3000000,270.0000000,228,4,60); //BMX
	AddStaticVehicleEx(481,236.6000100,-1834.7000000,3.3000000,269.9950000,228,4,60); //BMX
	AddStaticVehicleEx(481,236.6000100,-1832.9000000,3.3000000,269.9950000,228,4,60); //BMX
	AddStaticVehicleEx(481,236.3999900,-1831.1000000,3.3000000,269.9950000,228,4,60); //BMX
	Transport[0] = AddStaticVehicleEx(522,198.7000000,-1835.9000000,3.4000000,270.0000000,228,222,60); //NRG-500
	Transport[1] = AddStaticVehicleEx(522,198.6000100,-1833.5000000,3.4000000,270.0000000,228,222,60); //NRG-500
	Transport[2] = AddStaticVehicleEx(522,198.3999900,-1830.5000000,3.4000000,270.0000000,228,222,60); //NRG-500
	Transport[3] = AddStaticVehicleEx(522,248.8999900,-1836.3000000,3.4000000,90.0000000,228,222,60); //NRG-500
	Transport[4] = AddStaticVehicleEx(522,249.0000000,-1833.5000000,3.4000000,89.9950000,228,222,60); //NRG-500
	Transport[5] = AddStaticVehicleEx(522,249.3000000,-1830.9000000,3.4000000,89.9950000,228,222,60); //NRG-500
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
