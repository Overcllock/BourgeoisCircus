//Bourgeois Circus 1.0

#include <a_samp>
#include <a_mail>
#include <a_engine>
#include <a_mysql>
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
#include <sscanf2>
#include <Pawn.CMD>

#pragma dynamic 31294
#define NULL (0)

#define VERSION 1.00

//Mysql settings
#define SQL_HOST "127.0.0.1"
#define SQL_USER "tsar"
#define SQL_DB "bcircus"
#define SQL_PASS "2151"

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
#define MAX_SLOTS 25
#define MAX_SLOTS_X 5
#define MAX_SLOTS_Y 5
#define MAX_RANK 9
#define MAX_MOD 7
#define MAX_PROPERTIES 2
#define MAX_DESCRIPTION_SIZE 30
#define MAX_GRADES 3

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
#define MOD_DEFENCE 2
#define MOD_DODGE 3
#define MOD_ACCURACY 4

/* Forwards */
forward Time();
forward OnPlayerLogin(playerid);
forward UpdatePlayer(playerid);
forward Float:GetDistanceBetweenPlayers(p1, p2);
forward Float:GetPlayerMaxHP(playerid);
forward Float:GetPlayerHP(playerid);
forward SetPlayerHP(playerid, Float:hp);
forward GivePlayerRate(playerid, rate);

/* Variables */

//Global
new WorldTime_Timer = -1;
new Actors[MAX_ACTORS];
new MySQL:sql_handle;
enum TopItem
{
	Pos,
	Name[255],
	Rate
};
enum tInfo
{
	Number,
	Phase,
	Tour,
	ParticipantsIDs[MAX_PARTICIPANTS]
};
new Tournament[tInfo];
new TourParticipantsCount = 0;
new PrevTourParticipantsCount = 0;
new TournamentTab[MAX_PARTICIPANTS][TopItem];

//Pickups
new home_enter = -1;
new home_quit = -1;
new start_tp1 = -1;
new start_tp2 = -1;

//Player
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
	Rate,
	Rank,
	MaxRank,
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
new PlayerInventory[MAX_PLAYERS][MAX_SLOTS][iInfo];
new PlayerInfo[MAX_PLAYERS][pInfo];
new PlayerHPMultiplicator[MAX_PLAYERS];
new PlayerUpdater[MAX_PLAYERS];
new PlayerConnect[MAX_PLAYERS];
new bool:IsInventoryOpen[MAX_PLAYERS] = false;
new bool:IsDeath[MAX_PLAYERS] = false;
new bool:IsParticipant[MAX_PLAYERS] = false;
new SelectedSlot[MAX_PLAYERS] = -1;

new AccountLogin[MAX_PLAYERS][128];
new ParticipantsCount[MAX_PLAYERS];
new Participants[MAX_PLAYERS][MAX_PARTICIPANTS][128];

//Arrays
new EmptyInvItem[iInfo] = {
	-1,
	{0,0,0,0,0,0,0},
	0
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

///Textdraws
//Global
new Text:WorldTime;
new Text:GamemodeName1;
new Text:GamemodeName2;
new Text:Version;

//Player
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
new PlayerText:InfItemEffect[MAX_PLAYERS];
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
new PlayerText:UpgTxt5[MAX_PLAYERS];
new PlayerText:UpgClose[MAX_PLAYERS];

main()
{
	new str[64];
	format(str, sizeof(str), "Bourgeois Circus ver. %.2f", VERSION);
	print(str);
}

/* Commands */
cmd:createplayer(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
	new name[128], owner[128];
	if(sscanf(params, "s[128]s[128]", name, owner))
		return SendClientMessage(playerid, COLOR_GREY, "USAGE: /createplayer [name][owner]");

	CreatePlayer(playerid, name, owner);
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

cmd:spawn(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;

	SetPlayerPos(playerid, 224.0761,-1839.8217,3.6037);
	SetPlayerInterior(playerid, 0);
	return 1;
}

cmd:kill(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;

	SetPlayerHealth(playerid, 0);
	return 1;
}

cmd:arena1(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
	SetPlayerPos(playerid, -2443.683,-1633.3514,767.6721);
	SetPlayerInterior(playerid, 0);
	return 1;
}

cmd:arena2(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
	SetPlayerPos(playerid, -2256.331,-1625.8031,767.6721);
	SetPlayerInterior(playerid, 0);
	return 1;
}

cmd:arena3(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
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
	FCNPC_SetUpdateRate(15);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	DisableNameTagLOS();
	SetNameTagDrawDistance(9999.0);
	CreateMap();
	CreatePickups();
	InitTextDraws();
	WorldTime_Timer = SetTimer("Time", 1000, true);

	sql_handle = mysql_connect(SQL_HOST, SQL_USER, SQL_PASS, SQL_DB);
	if(!sql_handle)
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
	KillTimer(WorldTime_Timer);
	for (new i = 0; i < MAX_ACTORS; i++)
		DestroyActor(Actors[i]);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SendClientMessage(playerid, COLOR_WHITE, "Добро пожаловать в Bourgeois Circus.");
	new login[64];
	GetPlayerName(playerid, login, sizeof(login));
	new ok = LoadAccount(playerid, login);
	if(PlayerInfo[playerid][Admin] > 0 && ok > 0)
	{
		LoadPlayer(playerid);
		OnPlayerLogin(playerid);
	}
	else if(ok > 0)
		ShowPlayerDialog(playerid, 101, DIALOG_STYLE_PASSWORD, "Авторизация", "Введите пароль:", "Вход", "Закрыть");
	else
		ShowPlayerDialog(playerid, 100, DIALOG_STYLE_PASSWORD, "Регистрация", "Указанный логин не зарегистрирован.\n\nПридумайте пароль:", "Далее", "Закрыть");
	return 1;
}

public OnPlayerConnect(playerid)
{
    ShowTextDraws(playerid);
    PlayerUpdater[playerid] = SetTimerEx("UpdatePlayer", 1000, true, "i", playerid);
	return 1;
}

public OnPlayerLogin(playerid) 
{
	InitPlayerTextDraws(playerid);
	PlayerTextDrawShow(playerid, HPBar[playerid]);
	PlayerConnect[playerid] = true;
	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;
	PlayerHPMultiplicator[playerid] = PlayerInfo[playerid][Rank] * 10;
	if(PlayerHPMultiplicator[playerid] <= 10)
		PlayerHPMultiplicator[playerid] = 10;
	
	SpawnPlayer(playerid);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
	UpdateLocalRatingTop(playerid);
}

public OnPlayerDisconnect(playerid, reason)
{
	KillTimer(PlayerUpdater[playerid]);
	if(IsPlayerParticipant(playerid) || PlayerInfo[playerid][Admin] > 0)
		SavePlayer(playerid);
	DeletePlayerTextDraws(playerid);
	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;
	IsParticipant[playerid] = false;

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

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & 1024) SelectTextDraw(playerid,0xCCCCFF65);
	else if(newkeys & 16)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 221.0985,-1838.1259,3.6268))
		{
			new text[1024] = "{CCCCFF}\n\n";
			strcat(text, "                        Привет! Я - Буржуа, владелец цирка.      \n");
			strcat(text, "Я буду сообщать о важнейших событиях, которые тут происходят.\n");
			strcat(text, "  Заходи ко мне почаще, чтобы не пропустить самое интересное! \n\n");
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Буржуа", text, "Закрыть", "");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 226.7674,-1837.6835,3.6120))
		{
			new listitems[] = "Информация о турнире\nТурнирная таблица\nУчастники следующего тура\nПодать сигнал готовности";
			ShowPlayerDialog(playerid, 200, DIALOG_STYLE_TABLIST, "Заведующий турнирами", listitems, "Далее", "Закрыть");
		}
		else if(IsPlayerInRangeOfPoint(playerid,1.2,-2171.3132,645.5896,1052.3817)) 
		{
			new listitems[] = "Общий рейтинг участников\nРейтинг моих участников";
			ShowPlayerDialog(playerid, 300, DIALOG_STYLE_TABLIST, "Доска почета", listitems, "Далее", "Закрыть");
        }
	}
	else if(newkeys & 131072)
	{
		new listitems[] = "Информация о персонаже\nСменить персонажа";
		ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_TABLIST, "Bourgeois Circus", listitems, "Далее", "Закрыть");
	}
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	//1 - пустой
	//100-102 - регистрация/авторизация
	//103 - выбор перса
	//1000 - основное меню
	switch (dialogid) 
	{
		//Пустой
	    case 1: { return 1; }
		//Регистрация
		case 100:
		{
			if(response)
			{
				if(strlen(inputtext) < 4)
				{
					SendClientMessage(playerid, COLOR_GREY, "Длина пароля должна быть не менее 4 символов.");
					ShowPlayerDialog(playerid, 100, DIALOG_STYLE_PASSWORD, "Регистрация", "Указанный логин не зарегистрирован.\n\nПридумайте пароль:", "Далее", "Закрыть");
					return 0;
				}

				new login[64];
				GetPlayerName(playerid, login, sizeof(login));
				new pass[255];
				pass = MD5_Hash(inputtext);

				new query[255];
				format(query, sizeof(query), "INSERT INTO `accounts`(`pass`, `admin`, `part_count`, `login`) VALUES ('%s','%d','%d','%s')", 
					pass, 0, 0, login
				);
				new Cache:q_result = mysql_query(sql_handle, query);
				cache_delete(q_result);

				AccountLogin[playerid] = login;
				SendClientMessage(playerid, COLOR_GREEN, "Регистрация прошла успешно. Сообщите логин администратору для привязки участников.");
				SendClientMessage(playerid, COLOR_WHITE, "Введите /q чтобы выйти.");
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, "Введите /q чтобы выйти.");
				return 0;
			}
		}

		case 102:
		{
			ShowPlayerDialog(playerid, 101, DIALOG_STYLE_PASSWORD, "Авторизация", "Введите пароль:", "Вход", "Закрыть");
			return 1;
		}
		
		case 101:
		{
			if(strlen(inputtext) == 0)
			{
				ShowPlayerDialog(playerid, 101, DIALOG_STYLE_PASSWORD, "Авторизация", "Введите пароль:", "Вход", "Закрыть");
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
				ShowPlayerDialog(playerid, 102, DIALOG_STYLE_MSGBOX, "Ошибка", "Неверный пароль", "Закрыть", "");
				return 0;
			}

			AccountLogin[playerid] = login;
			ConnectParticipants(playerid);

			if(ParticipantsCount[playerid] < 1)
			{
				SendClientMessage(playerid, COLOR_GREY, "К вашей учетной записи не привязаны участники. Обратитесь к администратору.");
				SendClientMessage(playerid, COLOR_WHITE, "Введите /q чтобы выйти.");
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
						if(Tournament[Phase] == PHASE_PEACE) ptext = "мира";
						else ptext = "войны";
						format(listitems, sizeof(listitems), "Сейчас идет турнир #%d.\n\nТекущая фаза: фаза %s\nТур: %d", 
							Tournament[Number], ptext, Tournament[Tour]
						);
						ShowPlayerDialog(playerid, 201, DIALOG_STYLE_MSGBOX, "Информация о турнире", listitems, "Назад", "Закрыть");
					}
					case 1:
					{
						if(Tournament[Phase] == PHASE_PEACE)
						{
							ShowPlayerDialog(playerid, 201, DIALOG_STYLE_MSGBOX, "Турнирная таблица", "Сейчас проходит фаза мира.", "Назад", "Закрыть");
							return 0;
						}
						if(Tournament[Tour] <= 1)
						{
							ShowPlayerDialog(playerid, 201, DIALOG_STYLE_MSGBOX, "Турнирная таблица", "Таблица будет доступна после 1 тура.", "Назад", "Закрыть");
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
				new listitems[] = "Информация о турнире\nТурнирная таблица\nУчастники текущего тура\nПодать сигнал готовности";
				ShowPlayerDialog(playerid, 200, DIALOG_STYLE_TABLIST, "Заведующий турнирами", listitems, "Далее", "Закрыть");
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
			else
			{
				return 0;
			}
			return 1;
		}

		//Основное меню
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

public OnPlayerUpdate(playerid)
{
	UpdateHPBar(playerid);
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

	for (new i = 0; i < MAX_SLOTS; i++) {
        if (playertextid == ChrInfInvSlot[playerid][i]) {
            if (SelectedSlot[playerid] != -1) 
			{
                if (PlayerInventory[playerid][SelectedSlot[playerid]][ID] != -1 && PlayerInventory[playerid][i][ID] == -1) 
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
	UpdateHPBar(playerid);
}

public Float:GetPlayerHP(playerid)
{
	new Float:hp;
	GetPlayerHealth(playerid, hp);
	hp = floatmul(hp, PlayerHPMultiplicator[playerid]);
	hp = floatround(hp);
	return hp;
}

public GivePlayerRate(playerid, rate)
{
	PlayerInfo[playerid][Rate] += rate;
	UpdatePlayerRank(playerid);
	UpdateLocalRatingTop(playerid);
}

/* Stock functions */
stock SwitchPlayer(playerid)
{
	new listitems[1024] = "Имя\tРейтинг";
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
			SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка инициализации участников. Обратитесь к администратору.");
			return;
		}

		new rate;
		cache_get_value_name_int(0, "Rate", rate);
		cache_delete(q_result);

		format(string, sizeof(string), "\n{%s}%s\t%d", GetColorByRate(rate), Participants[playerid][i], rate);
		strcat(listitems, string);
	}
	ShowPlayerDialog(playerid, 103, DIALOG_STYLE_TABLIST_HEADERS, "Выбор участника", listitems, "Войти", "Закрыть");
}

stock UpdateHPBar(playerid)
{
	new Float:hp;
	new Float:max_hp;
	hp = GetPlayerHP(playerid);
	max_hp = GetPlayerMaxHP(playerid);
	new percents = floatround(floatmul(floatdiv(hp, max_hp), 100));
	new string[64];
	format(string, sizeof(string), "%d%% %d/%d", percents, floatround(hp), floatround(max_hp));
	PlayerTextDrawSetString(playerid, HPBar[playerid], string);
}

stock UpdatePlayerRank(playerid)
{
	new string[255];
	new new_rank = GetRankByRate(PlayerInfo[playerid][Rate]);

	if(new_rank > PlayerInfo[playerid][Rank])
	{
		format(string, sizeof(string), "Ранг повышен - %s.", GetRateInterval(PlayerInfo[playerid][Rate]));
		SendClientMessage(playerid, COLOR_GREEN, string);
	}
	else if(new_rank < PlayerInfo[playerid][Rank])
	{
		format(string, sizeof(string), "Ранг понижен - %s.", GetRateInterval(PlayerInfo[playerid][Rate]));
		SendClientMessage(playerid, COLOR_RED, string);
	}

	PlayerInfo[playerid][Rank] = new_rank;
	if(new_rank > PlayerInfo[playerid][MaxRank])
		PlayerInfo[playerid][MaxRank] = new_rank;
}

stock IsInvSlotEmpty(playerid, slotid)
{
	return PlayerInventory[playerid][slotid][ID] == -1;
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
		PlayerTextDrawSetString(playerid, ChrInfInvSlotCount[playerid][slotid], string);
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
		PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][slotid], selection ? HexGradeColors[item[Grade]-1][0] - 0x00000033 : HexGradeColors[item[Grade]-1][0]);
	}

	PlayerTextDrawHide(playerid, ChrInfInvSlot[playerid][slotid]);
	PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][slotid]);
}

stock UpdateInventory(playerid)
{
	if(IsInventoryOpen(playerid))
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
			format(string, sizeof(string), "%d", PlayerInventory[playerid][i][Count]);
			PlayerTextDrawSetString(playerid, ChrInfInvSlotCount[playerid][i], string);
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
	if(IsInventoryFull(playerid))
		return false;

	new slot = GetInvEmptySlotID(playerid);
	PlayerInventory[playerid][slot][ID] = id;
	PlayerInventory[playerid][slot][Count] = count;

	SaveInventorySlot(playerid, slot);

	if(IsInventoryOpen(playerid))
		UpdateInventory(playerid);

	return true;
}

stock DeleteItem(playerid, slotid, count = 1)
{
	PlayerInventory[playerid][slotid][Count] -= count;
	if(PlayerInventory[playerid][slotid][Count] <= 0)
	{
		for(new i = 0; i < MAX_MOD; i++)
			PlayerInventory[playerid][slotid][Mod][i] = 0;
		PlayerInventory[playerid][slotid][ID] = -1;
	}

	SaveInventorySlot(playerid, slotid);
	SendClientMessage(playerid, COLOR_GREY, "Предмет удален.");
}

stock ItemExist(playerid, id, count = 1)
{
	new item[BaseItem];
	item = GetItem(id);

	new name[255];
	GetPlayerName(playerid, name, sizeof(name));

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `inventories` WHERE `PlayerName` = '%s' AND `ItemID` = '%d' LIMIT 1", name, id);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count;
	cache_get_row_count(count);
	if(count <= 0)
		return false;
	
	if(IsEquip(id))
		return true;
	
	new _count;
	cache_get_value_name_int(0, "Count", _count);
	return _count >= count;
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

stock IsEquip(item_id)
{
	new item[BaseItem];
	item = GetItem(item_id);
	return item[Type] == ITEMTYPE_WEAPON || item[Type] == ITEMTYPE_ARMOR || item[Type] == ITEMTYPE_ACCESSORY;
}

stock IsPlayerParticipant(playerid)
{
	return IsParticipant[playerid];
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

stock ShowCharInfo(playerid)
{
	new string[255];

	format(string, sizeof(string), "HP: %.0f/%.0f", GetPlayerHP(playerid), GetPlayerMaxHP(playerid));
	PlayerTextDrawSetString(playerid, ChrInfMaxHP[playerid], string);
	format(string, sizeof(string), "%s: %d-%d", TranslateText("Урон"), PlayerInfo[playerid][DamageMin], PlayerInfo[playerid][DamageMax]);
	PlayerTextDrawSetString(playerid, ChrInfDamage[playerid], string);
	format(string, sizeof(string), "%s: %d", TranslateText("Защита"), PlayerInfo[playerid][Defense]);
	PlayerTextDrawSetString(playerid, ChrInfDefense[playerid], string);
	format(string, sizeof(string), "%s: %d", TranslateText("Точность"), PlayerInfo[playerid][Accuracy]);
	PlayerTextDrawSetString(playerid, ChrInfAccuracy[playerid], string);
	format(string, sizeof(string), "%s: %d", TranslateText("Уклонение"), PlayerInfo[playerid][Dodge]);
	PlayerTextDrawSetString(playerid, ChrInfDodge[playerid], string);
	format(string, sizeof(string), "%d", PlayerInfo[playerid][Rate]);
	PlayerTextDrawSetString(playerid, ChrInfRate[playerid], string);
	PlayerTextDrawColor(playerid, ChrInfRate[playerid], HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
	format(string, sizeof(string), "%d", PlayerInfo[playerid][GlobalTopPosition]);
	PlayerTextDrawSetString(playerid, ChrInfAllRate[playerid], string);
	PlayerTextDrawColor(playerid, ChrInfAllRate[playerid], GetHexPlaceColor(PlayerInfo[playerid][GlobalTopPosition]));
	format(string, sizeof(string), "%d", PlayerInfo[playerid][LocalTopPosition]);
	PlayerTextDrawSetString(playerid, ChrInfPersonalRate[playerid], string);
	PlayerTextDrawColor(playerid, ChrInfPersonalRate[playerid], GetHexPlaceColor(PlayerInfo[playerid][LocalTopPosition]));

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

	UpdateInventory(playerid);
	
	IsInventoryOpen[playerid] = true;
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

stock GetRankByRate(rate)
{
	new rank;
	switch(rate)
	{
		case 501..1000: rank = 2;
	    case 1001..1200: rank = 3;
	    case 1201..1400: rank = 4;
	    case 1401..1600: rank = 5;
	    case 1601..2000: rank = 6;
	    case 2001..2300: rank = 7;
	    case 2301..2700: rank = 8;
	    case 2701..3000: rank = 9;
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

	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		if(Tournament[ParticipantsIDs][i] == -1)
		{
			TourParticipantsCount = i;
			break;
		}
	}

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
	
    cache_delete(q_result);
	return true;
}

stock SavePlayer(playerid)
{
	new name[64];
	GetPlayerPos(playerid, PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ]);
	GetPlayerFacingAngle(playerid, PlayerInfo[playerid][FacingAngle]);
	PlayerInfo[playerid][Interior] = GetPlayerInterior(playerid);
	GetPlayerName(playerid, name, sizeof(name));

	new query[2048] = "UPDATE `players` SET ";
	new tmp[255];

	format(tmp, sizeof(tmp), "`Sex` = '%d', `Rate` = '%d', `Rank` = '%d', ", PlayerInfo[playerid][Sex], PlayerInfo[playerid][Rate], PlayerInfo[playerid][Rank]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`MaxRank` = '%d', `Cash` = '%d', `PosX` = '%f', ", PlayerInfo[playerid][MaxRank], PlayerInfo[playerid][Cash], PlayerInfo[playerid][PosX]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`PosY` = '%f', `PosZ` = '%f', `Angle` = '%f', ", PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ], PlayerInfo[playerid][FacingAngle]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`Interior` = '%d', `Skin` = '%d', `Kills` = '%d', ", PlayerInfo[playerid][Interior], PlayerInfo[playerid][Skin], PlayerInfo[playerid][Kills]);
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
	new name[128];
	new query[512];
	GetPlayerName(playerid, name, sizeof(name));

	format(query, sizeof(query), "SELECT * FROM `inventories` WHERE `PlayerName` = '%s'", name);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count < MAX_SLOTS)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка при загрузке инвентаря. Обратитесь к администратору.");
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
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка при загрузке участника. Обратитесь к администратору.");
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

stock CreatePlayer(playerid, name[], owner[])
{
	new query[2048] = "INSERT INTO `players`( \
		`ID`, `Name`, `Owner`, `Sex`, `Rate`, `MaxRank`, `Rank`, `Cash`, `PosX`, `PosY`, `PosZ`, \
		`Angle`, `Interior`, `Skin`, `Kills`, `Deaths`, `DamageMin`, `DamageMax`, `Defense`, \
		`Dodge`, `Accuracy`, `Crit`, `GlobalTopPos`, `LocalTopPos`, `WeaponSlotID`, `WeaponMod`, \
		`ArmorSlotID`, `ArmorMod`, `AccSlot1ID`, `AccSlot2ID`) VALUES (";
	new tmp[1024];

	new sub_query[255] = "SELECT MAX(`ID`) AS `ID` FROM `players";
	new Cache:sq_result = mysql_query(sql_handle, sub_query);
	new id = -1;
	cache_get_value_name_int(0, "ID", id);
	cache_delete(sq_result);

	if(id == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка присвоения ID: неудалось получить макс.ID или база игроков пуста.");
		return;
	}

	id++;

	format(tmp, sizeof(tmp), "'%d','%s','%s','%d','%d','%d','%d','%d','%f','%f','%f','%f','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%s','%d','%s','%d','%d')",
		id, name, owner, 0, 0, 1, 1, 0, DEFAULT_POS_X, DEFAULT_POS_Y, DEFAULT_POS_Z, 180, 1, 78, 0, 0, 13, 15, 5, 0, 5, 5, 20, 10, 0, "0 0 0 0 0 0 0", 81, "0 0 0 0 0 0 0", -1, -1
	);
	strcat(query, tmp);

	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	//CreateInventory(name);

	SendClientMessage(playerid, COLOR_GREEN, "Player created succesfully.");
}

stock IsPlayerBesideNPC(playerid)
{
	return IsPlayerInRangeOfPoint(playerid, 2.0, -2166.7527,646.0400,1052.3750) ||
		   IsPlayerInRangeOfPoint(playerid, 2.0, 189.2644,-1825.4902,4.1411) ||
		   IsPlayerInRangeOfPoint(playerid, 2.0, 262.6658,-1825.2792,3.9126);
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

stock TranslateText(string[])
{
	new result[128];
	for (new i = 0; i < sizeof(result); i++)
	{
		switch (string[i])
		{
			case 'а': result[i] = 'a';
			case 'А': result[i] = 'A';
			case 'б': result[i] = '—';
			case 'Б': result[i] = 'Ђ';
			case 'в': result[i] = 'ў';
			case 'В': result[i] = '‹';
			case 'г': result[i] = '™';
			case 'Г': result[i] = '‚';
			case 'д': result[i] = 'љ';
			case 'Д': result[i] = 'ѓ';
			case 'е': result[i] = 'e';
			case 'Е': result[i] = 'E';
			case 'ё': result[i] = 'e';
			case 'Ё': result[i] = 'E';
			case 'ж': result[i] = '›';
			case 'Ж': result[i] = '„';
			case 'з': result[i] = 'џ';
			case 'З': result[i] = '€';
			case 'и': result[i] = 'њ';
			case 'И': result[i] = '…';
			case 'й': result[i] = 'ќ';
			case 'Й': result[i] = '…';
			case 'к': result[i] = 'k';
			case 'К': result[i] = 'K';
			case 'л': result[i] = 'ћ';
			case 'Л': result[i] = '‡';
			case 'м': result[i] = 'Ї';
			case 'М': result[i] = 'M';
			case 'н': result[i] = '®';
			case 'Н': result[i] = ' ';
			case 'о': result[i] = 'o';
			case 'О': result[i] = 'O';
			case 'п': result[i] = 'Ј';
			case 'П': result[i] = 'Њ';
			case 'р': result[i] = 'p';
			case 'Р': result[i] = 'P';
			case 'с': result[i] = 'c';
			case 'С': result[i] = 'C';
			case 'т': result[i] = '¦';
			case 'Т': result[i] = 'Џ';
			case 'у': result[i] = 'y';
			case 'У': result[i] = 'Y';
			case 'ф': result[i] = '~';
			case 'Ф': result[i] = 'Ѓ';
			case 'х': result[i] = 'x';
			case 'Х': result[i] = 'X';
			case 'ц': result[i] = '*';
			case 'Ц': result[i] = '‰';
			case 'ч': result[i] = '¤';
			case 'Ч': result[i] = 'Ќ';
			case 'ш': result[i] = 'Ґ';
			case 'Ш': result[i] = 'Ћ';
			case 'щ': result[i] = 'Ў';
			case 'Щ': result[i] = 'Љ';
			case 'ь': result[i] = '©';
			case 'Ь': result[i] = '’';
			case 'ъ': result[i] = 'ђ';
			case 'Ъ': result[i] = '§';
			case 'ы': result[i] = 'Ё';
			case 'Ы': result[i] = '‘';
			case 'э': result[i] = 'Є';
			case 'Э': result[i] = '“';
			case 'ю': result[i] = '«';
			case 'Ю': result[i] = '”';
			case 'я': result[i] = '¬';
			case 'Я': result[i] = '•';
			default: result[i] = string[i];
		}
	}
	return result;
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
	new top[4000] = "№ п\\п\tИмя\tРейтинг";
	new string[455];
	for (new i = 0; i < MAX_PARTICIPANTS; i++) 
	{
		format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t%d", 
			GetPlaceColor(i+1), i+1, GetColorByRate(GlobalRatingTop[i][Rate]), GlobalRatingTop[i][Name], GlobalRatingTop[i][Rate]
		);
		strcat(top, string);
	}
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST_HEADERS, "Общий рейтинг участников", top, "Закрыть", "");
}

stock ShowLocalRatingTop(playerid)
{
	new top[4000] = "№ п\\п\tИмя\tРейтинг";
	new string[455];
	for (new i = 0; i < MAX_PARTICIPANTS / 2; i++) 
	{
		format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t%d", 
			GetPlaceColor(i+1), i+1, GetColorByRate(LocalRatingTop[playerid][i][Rate]), LocalRatingTop[playerid][i][Name], LocalRatingTop[playerid][i][Rate]
		);
		strcat(top, string);
	}
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST_HEADERS, "Рейтинг моих участников", top, "Закрыть", "");
}

stock ShowTourParticipants(playerid)
{
	new top[4000] = "№ п\\п\tИмя\tРейтинг";
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
	ShowPlayerDialog(playerid, 201, DIALOG_STYLE_TABLIST_HEADERS, "Участники текущего тура", top, "Назад", "Закрыть");
}

stock ShowTournamentTab(playerid)
{
	new top[4000] = "№ п\\п\tИмя\tОчки";
	new string[255];
	for (new i = 0; i < PrevTourParticipantsCount; i++) 
	{
		format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t%d", 
			GetPlaceColor(i+1), i+1, GetColorByRate(TournamentTab[i][Rate]), TournamentTab[i][Name], TournamentTab[i][Rate]
		);
		strcat(top, string);
	}
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST_HEADERS, "Турнирная таблица", top, "Закрыть", "");
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
	cache_get_value_name(0, "Name", name);
	player[Name] = name;

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

	ChrInfoHeader[playerid] = CreatePlayerTextDraw(playerid, 551.999877, 107.436988, TranslateText("Персонаж"));
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

	ChrInfDamage[playerid] = CreatePlayerTextDraw(playerid, 501.366607, 126.605903, TranslateText("Урон: 9999-9999"));
	PlayerTextDrawLetterSize(playerid, ChrInfDamage[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDamage[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDamage[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDamage[playerid], 1);

	ChrInfDefense[playerid] = CreatePlayerTextDraw(playerid, 501.533477, 133.164413, TranslateText("Защита: 9999"));
	PlayerTextDrawLetterSize(playerid, ChrInfDefense[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDefense[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDefense[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDefense[playerid], 1);

	ChrInfAccuracy[playerid] = CreatePlayerTextDraw(playerid, 501.566833, 139.515502, TranslateText("Точность: 999"));
	PlayerTextDrawLetterSize(playerid, ChrInfAccuracy[playerid], 0.193332, 0.737185);
	PlayerTextDrawAlignment(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAccuracy[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccuracy[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfAccuracy[playerid], 1);

	ChrInfDodge[playerid] = CreatePlayerTextDraw(playerid, 501.533447, 145.534683, TranslateText("Уклонение: 999"));
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

	ChrInfText1[playerid] = CreatePlayerTextDraw(playerid, 519.999877, 156.385177, TranslateText("Общий"));
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

	ChrInfText2[playerid] = CreatePlayerTextDraw(playerid, 589.599487, 156.638442, TranslateText("Личный"));
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

	EqInfTxt1[playerid] = CreatePlayerTextDraw(playerid, 318.333312, 114.115562, "Information");
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

	EqInfTxt2[playerid] = CreatePlayerTextDraw(playerid, 319.100036, 173.973190, "Modifications");
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
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][0], 0.234333, 1.006815);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][0], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][0], 51);
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][0], 1);

	EqInfDescriptionStr[playerid][1] = CreatePlayerTextDraw(playerid, 319.400115, 264.200103, "[Description string 2]");
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][1], 0.234333, 1.006815);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][1], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][1], 51);
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][1], 1);

	EqInfDescriptionStr[playerid][2] = CreatePlayerTextDraw(playerid, 319.633575, 274.035766, "[Description string 3]");
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][2], 0.234333, 1.006815);
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

	InfTxt1[playerid] = CreatePlayerTextDraw(playerid, 319.833190, 150.702148, "Information");
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

	InfItemEffect[playerid] = CreatePlayerTextDraw(playerid, 283.033142, 189.206115, "Decreases required rank for equip by 1");
	PlayerTextDrawLetterSize(playerid, InfItemEffect[playerid], 0.167666, 0.749629);
	PlayerTextDrawAlignment(playerid, InfItemEffect[playerid], 1);
	PlayerTextDrawColor(playerid, InfItemEffect[playerid], -1);
	PlayerTextDrawSetShadow(playerid, InfItemEffect[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfItemEffect[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemEffect[playerid], 51);
	PlayerTextDrawFont(playerid, InfItemEffect[playerid], 1);
	PlayerTextDrawSetProportional(playerid, InfItemEffect[playerid], 1);

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

	UpgTxt1[playerid] = CreatePlayerTextDraw(playerid, 320.166687, 153.481506, "Modification");
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

	UpgModInfo[playerid] = CreatePlayerTextDraw(playerid, 320.066711, 176.425201, "7th modification");
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

	UpgTxt2[playerid] = CreatePlayerTextDraw(playerid, 320.500091, 225.543746, "Item");
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

	UpgTxt3[playerid] = CreatePlayerTextDraw(playerid, 282.066864, 224.967407, "Stone");
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

	UpgTxt4[playerid] = CreatePlayerTextDraw(playerid, 358.533477, 225.677017, "Potion");
	PlayerTextDrawLetterSize(playerid, UpgTxt4[playerid], 0.189999, 0.766222);
	PlayerTextDrawAlignment(playerid, UpgTxt4[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt4[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgTxt4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt4[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt4[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt4[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt4[playerid], 1);

	UpgBtn[playerid] = CreatePlayerTextDraw(playerid, 369.333312, 237.654083, "btn_upg");
	PlayerTextDrawLetterSize(playerid, UpgBtn[playerid], 0.000000, 0.835599);
	PlayerTextDrawTextSize(playerid, UpgBtn[playerid], 270.333312, 0.000000);
	PlayerTextDrawAlignment(playerid, UpgBtn[playerid], 1);
	PlayerTextDrawColor(playerid, UpgBtn[playerid], 0);
	PlayerTextDrawUseBox(playerid, UpgBtn[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgBtn[playerid], 8388863);
	PlayerTextDrawSetShadow(playerid, UpgBtn[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgBtn[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgBtn[playerid], 8388863);
	PlayerTextDrawFont(playerid, UpgBtn[playerid], 0);
	PlayerTextDrawSetSelectable(playerid, UpgBtn[playerid], true);

	UpgTxt5[playerid] = CreatePlayerTextDraw(playerid, 320.200012, 235.905120, "Upgrade");
	PlayerTextDrawLetterSize(playerid, UpgTxt5[playerid], 0.275333, 1.060740);
	PlayerTextDrawAlignment(playerid, UpgTxt5[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt5[playerid], 255);
	PlayerTextDrawUseBox(playerid, UpgTxt5[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgTxt5[playerid], 0);
	PlayerTextDrawSetShadow(playerid, UpgTxt5[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt5[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt5[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt5[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt5[playerid], 1);

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
	PlayerTextDrawDestroy(playerid, InfItemEffect[playerid]);
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
	PlayerTextDrawDestroy(playerid, UpgTxt5[playerid]);
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
    start_tp1 = CreatePickup(19605,23,243.1539,-1831.6542,3.3772);
    start_tp2 = CreatePickup(19607,23,204.7617,-1831.6539,3.3772);
    
    Create3DTextLabel("Дом клоунов",0xf2622bFF,224.0201,-1837.3518,4.2787,70.0,0,1);
    Create3DTextLabel("К боссам",0xeaeaeaFF,243.1539,-1831.6542,3.9772,70.0,0,1);
    Create3DTextLabel("На арену",0xeaeaeaFF,204.7617,-1831.6539,4.1772,70.0,0,1);
    Create3DTextLabel("Доска почета",0xFFCC00FF,-2171.3132,645.5896,1053.3817,10.0,0,1);
    Create3DTextLabel("Торговец расходниками",0xFFCC00FF,-2166.7527,646.0400,1052.3750,55.0,0,1);
	Create3DTextLabel("Оружейник",0xFFCC00FF,189.2644,-1825.4902,4.1411,55.0,0,1);
	Create3DTextLabel("Портной",0xFFCC00FF,262.6658,-1825.2792,3.9126,55.0,0,1);
	Create3DTextLabel("Буржуа",0x9933CCFF,221.0985,-1838.1259,3.6268,55.0,0,1);
	Create3DTextLabel("Заведующий турнирами",0x3366FFFF,226.7674,-1837.6835,3.6120,55.0,0,1);

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
}
