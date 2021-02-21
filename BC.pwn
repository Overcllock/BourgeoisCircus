//Bourgeois Circus 3.0

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

#define VERSION 3.001

//Mysql settings

/*#define SQL_HOST "127.0.0.1"
#define SQL_USER "tsar"
#define SQL_DB "bcircus"
#define SQL_PASS "2151"*/
#define SQL_HOST "212.22.93.13"
#define SQL_USER "nilzjciu"
#define SQL_DB "nilzjciu_33518"
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
#define DEFAULT_DEFENSE 100
#define DEFAULT_CRIT 10
#define DEFAULT_DODGE 0
#define DEFAULT_ACCURACY 20
#define DEFAULT_POS_X -2170.3948
#define DEFAULT_POS_Y 645.6729
#define DEFAULT_POS_Z 1057.5938

//Tweaks. 0 = off, 1 = on
#define IS_BNS_MODE 0

//Limits
#define MAX_TOUR 5
#define MAX_PARTICIPANTS 20
#define MAX_OWNERS 2
#define MAX_TEAMCOLORS 5
#define MAX_SLOTS 125
#define MAX_PAGE_SLOTS 25
#define MAX_SLOTS_X 5
#define MAX_SLOTS_Y 5
#define MAX_INV_PAGES 5
#define MAX_RANK 9
#define MAX_MOD 7
#define MAX_PROPERTIES 3
#define MAX_DESCRIPTION_SIZE 40
#define MAX_GRADES 6
#define MAX_BOSSES 8
#define MAX_ITEM_ID 1000

//x1 - 36, x1.5 - 48, x2 - 54, x3 - 70
#define MAX_LOOT 36
//x1 - 6, x1.5 - 10, x2 - 12, x3 - 16
#define MAX_WALKER_LOOT 6
//x1 - 16, x1.5 - 22, x2 - 28, x3 - 36
#define MAX_DUNGEON_LOOT 16

#define MAX_PVP_PANEL_ITEMS 5
#define MAX_RELIABLE_TARGETS 5
#define MAX_RATE 3000
#define MAX_DEATH_MESSAGES 5
#define MAX_NPC_MOVING_TICKS 60
#define MAX_NPC_IDLE_TICKS 30
#define MAX_NPC_SHOT_TICKS 60
#define MAX_CMB_ITEMS 3
#define MAX_MARKET_CATEGORIES 4
#define MAX_MARKET_ITEMS 20
#define MAX_TOUR_TIME 180
#define MAX_WALKERS 20
#define MAX_COOPERATE_MSGS 10
#define WALKERS_LIMIT 20
#define MAX_WALKERS_ONE_RANK 3
#define MAX_WATCHERS_POSITIONS 4
#define MAX_DUNGEONS 50
#define MAX_DUNGEON_MOBS 3
#define MAX_DUNGEON_BOSSES 2
#define MAX_DUNGEON_REWARDS 13

//Market
#define MARKET_CATEGORY_WEAPON 0
#define MARKET_CATEGORY_ARMOR 1
#define MARKET_CATEGORY_HAT 2
#define MARKET_CATEGORY_GLASSES 3
#define MARKET_CATEGORY_WATCH 4
#define MARKET_CATEGORY_ACCESSORY 5
#define MARKET_CATEGORY_MATERIAL 6
#define MARKET_CATEGORY_MYLOTS 7

//Phases
#define PHASE_PEACE 0
#define PHASE_WAR 1
#define PHASE_BATTLE 2

//Player params
#define PARAM_DAMAGE 1
#define PARAM_DEFENSE 2
#define PARAM_DODGE 3
#define PARAM_ACCURACY 4
#define PARAM_CRITICAL_CHANCE 5

//Item types
#define ITEMTYPE_WEAPON 1
#define ITEMTYPE_ARMOR 2
#define ITEMTYPE_HAT 3
#define ITEMTYPE_GLASSES 4
#define ITEMTYPE_WATCH 5
#define ITEMTYPE_RING 6
#define ITEMTYPE_AMULETTE 7
#define ITEMTYPE_PASSIVE 8
#define ITEMTYPE_MATERIAL 9
#define ITEMTYPE_BOX 10
#define ITEMTYPE_MODIFIER 11

//Item grades
#define GRADE_N 1
#define GRADE_B 2
#define GRADE_C 3
#define GRADE_L 4
#define GRADE_R 5
#define GRADE_S	6

//Props
#define PROPERTY_NONE 0
#define PROPERTY_DAMAGE 1
#define PROPERTY_DEFENSE 2
#define PROPERTY_DODGE 3
#define PROPERTY_ACCURACY 4
#define PROPERTY_HP 5
#define PROPERTY_CRIT 6
#define PROPERTY_LOOT 7
#define PROPERTY_HEAL 8
#define PROPERTY_INVUL 9
#define PROPERTY_MAXHP 10
#define PROPERTY_VAMP 11
#define PROPERTY_REGEN 12

//Modifiers variations
#define MOD_DAMAGE 1
#define MOD_DEFENSE 2
#define MOD_DODGE 3
#define MOD_ACCURACY 4

#define MOD_RESULT_SUCCESS 0
#define MOD_RESULT_FAIL 1
#define MOD_RESULT_RESET 2
#define MOD_RESULT_DESTROY 3

//Hierarchy
#define HIERARCHY_STATUSES_COUNT 5
#define HIERARCHY_NONE 0
#define HIERARCHY_LEADER 1
#define HIERARCHY_ARCHONT 2
#define HIERARCHY_ATTACK 3
#define HIERARCHY_DEFENSE 4
#define HIERARCHY_SUPPORT 5

//Other
#define RND_EQUIP_TYPE_WEAPON 0
#define RND_EQUIP_TYPE_ARMOR 1
#define RND_EQUIP_TYPE_ARMORHAT 2
#define RND_EQUIP_TYPE_WATCH 3
#define RND_EQUIP_TYPE_GLASSES 4
#define RND_EQUIP_TYPE_RANDOM 5
#define RND_EQUIP_GRADE_RANDOM 11
#define TOUR_INVULNEARABLE_TIME 5
#define COOPERATE_COOLDOWN 10

//Delays
#define DEFAULT_SHOOT_DELAY 	200
#define COLT_SHOOT_DELAY 		190
#define DEAGLE_SHOOT_DELAY 		260
#define MP5_SHOOT_DELAY 		130
#define TEC_SHOOT_DELAY 		70
#define AK_SHOOT_DELAY 			185
#define M4_SHOOT_DELAY 			175
#define SHOTGUN_SHOOT_DELAY 	410
#define SAWNOFF_SHOOT_DELAY 	380
#define COMBAT_SHOOT_DELAY 		350
#define RIFLE_SHOOT_DELAY		420

//Static items
#define ITEM_GEN_HP_ID 			277
#define ITEM_GEN_ATTACK_ID 		278
#define ITEM_GEN_DEFENSE_ID 	279
#define ITEM_LUCKY_CARD_ID 		280
#define ITEM_SHAZOK_LETTER_ID 	281

//Special abilites
#define SPECIAL_AB_EFFECT_NONE 			0
#define SPECIAL_AB_EFFECT_CONFUSION 	1
#define SPECIAL_AB_EFFECT_SHAZOK_FORCE 	2

//Special activites
#define SPECIAL_ACTIVITY_NONE 		0
#define SPECIAL_ACTIVITY_S_DELIVERY 1
#define SPECIAL_ACTIVITY_COOLDOWN 	10

//Special effects
#define SPECIAL_EFFECT_NONE					0
#define SPECIAL_EFFECT_VICTORY_FLAG_I 		1
#define SPECIAL_EFFECT_VICTORY_FLAG_II 		2
#define SPECIAL_EFFECT_VICTORY_FLAG_III 	3
#define SPECIAL_EFFECT_SCAR_OF_DEFEAT_I 	4
#define SPECIAL_EFFECT_SCAR_OF_DEFEAT_II 	5
#define SPECIAL_EFFECT_SCAR_OF_DEFEAT_III 	6

/* Forwards */
forward Time();
forward OnPlayerLogin(playerid);
forward OnTourEnd(finished);
forward OnTournamentEnd();
forward OnBattleEnd(winner[], finished);
forward OnPhaseChanged(oldphase, newphase);
forward Float:GetDistanceBetweenPoints(Float:p1_x,Float:p1_y,Float:p1_z,Float:p2_x,Float:p2_y,Float:p2_z);
forward Float:GetDistanceBetweenPlayers(p1, p2);
forward Float:GetDistanceBetweenPlayerAndVeh(playerid, vehicleid);
forward Float:GetPlayerMaxHP(playerid);
forward Float:GetPlayerHP(playerid);
forward Float:GetDefenseMul(defense);
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
forward RespawnWalker(walkerid);
forward TickMinute();
forward RefreshWalkers();
forward TickSecond(playerid);
forward TickSecondGlobal();
forward TickHour();
forward OnSpecialActivityStart(activityid);
forward OnSpecialActivityEnd(win);
forward bool:IsPlayerInDungeon(playerid);

/* Variables */

//Enums
enum TopItem
{
	Pos,
	Name[255],
	Kills,
	Deaths,
	Score,
	Rate,
	RateDiff
};
enum MarketItem
{
	ID,
	LotID,
	Count,
	Price,
	rTime,
	Owner[255],
	Mod[MAX_MOD]
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
	Count,
	OwnerID
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
	Score,
	RateDiff
};
enum TWindow
{
	bool:CharInfo,
	bool:ItemInfo,
	bool:EquipInfo,
	bool:Mod,
	bool:Cmb,
	bool:MarketSell
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
	IsTradeble,
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
enum BaseDungeon
{
	ID,
	KeyID,
	Rank,
	Type,
	Damage,
	Defense,
	MobsCount,
	MobsTypesCount,
	BossesCount,
	BossesTypesCount,
	Mobs[MAX_DUNGEON_MOBS],
	Bosses[MAX_DUNGEON_BOSSES]
};
enum pDungeon
{
	Mobs[MAX_PLAYERS],
	Bosses[MAX_PLAYERS],
	BossesIds[MAX_PLAYERS],
	Text3D:PortalLabel
};
enum pInfo 
{
	ID,
	Name[255],
	Owner[255],
	Rate,
	Rank,
	Status,
	Simulations,
	IsWatcher,
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
	Vamp,
	GlobalTopPosition,
	LocalTopPosition,
	WalkersLimit,
	Crit,
	WeaponSlotID,
	ArmorSlotID,
    HatSlotID,
    GlassesSlotID,
    WatchSlotID,
	RingSlot1ID,
	RingSlot2ID,
    AmuletteSlot1ID,
	AmuletteSlot2ID,
	WeaponMod[MAX_MOD],
	ArmorMod[MAX_MOD],
    HatMod[MAX_MOD],
    GlassesMod[MAX_MOD],
    WatchMod[MAX_MOD]
};
enum wInfo
{
	ID,
	Text3D:LabelID,
	Name[255],
	Rank,
	Skin,
	HP,
	DamageMin,
	DamageMax,
	Defense,
	Dodge,
	Accuracy,
	Crit,
	WeaponID
};

//Global
new is_bns_mode = IS_BNS_MODE;

new WalkersRefreshTimer = -1;
new WorldTime_Timer = -1;
new PrepareBossAttackTimer = -1;
new BossAttackTimer = -1;
new TeleportTimer = -1;
new Actors[MAX_ACTORS];
new ReadyIDs[MAX_OWNERS] = -1;
new MySQL:sql_handle;
new arena_area;
new walkers_area;
new Tournament[tInfo];
new TourParticipantsCount = 0;
new TournamentTab[MAX_PARTICIPANTS][TopItem];

new SpecialActivity = SPECIAL_ACTIVITY_NONE;
new SpecialActivityDelay = 0;
new SpecialActivityTimer = 0;
new SpecialActivityVehicleID = -1;

new AttackedBoss = -1;
new bool:IsBossAttacker[MAX_PLAYERS] = false;
new BossAttackersCount = 0;
new BossNPC = -1;
new bool:IsBoss[MAX_PLAYERS] = false;
new BossLootPickups[MAX_LOOT];
new BossLootItems[MAX_LOOT][LootInfo];

new WalkerLootPickups[MAX_PLAYERS][MAX_WALKER_LOOT];
new WalkerLootItems[MAX_PLAYERS][MAX_WALKER_LOOT][LootInfo];

new DungeonLootPickups[MAX_PLAYERS][MAX_DUNGEON_LOOT];
new DungeonLootItems[MAX_PLAYERS][MAX_DUNGEON_LOOT][LootInfo];

new ModItemSlot[MAX_PLAYERS] = -1;
new ModStone[MAX_PLAYERS] = -1;
new ModPotion[MAX_PLAYERS] = -1;
new IsSlotsBlocked[MAX_PLAYERS] = false;

new CmbItem[MAX_PLAYERS][MAX_CMB_ITEMS];
new CmbItemCount[MAX_PLAYERS][MAX_CMB_ITEMS];
new CmbItemInvSlot[MAX_PLAYERS][MAX_CMB_ITEMS];

new MarketSellingItem[MAX_PLAYERS][MarketItem];

new IsTourStarted = false;
new TourPlayers[MAX_OWNERS] = -1;
new TourEndTimer = -1;
new PvpTableUpdTimer = -1;
new DeadCheckTimer[MAX_PLAYERS] = -1;
new PvpTtl = 0;
new PvpInfo[MAX_PARTICIPANTS][pvpInf];
new DmgInfo[MAX_PLAYERS][MAX_PARTICIPANTS];

new Windows[MAX_PLAYERS][TWindow];

new TourTeam[MAX_PLAYERS] = NO_TEAM;

new Walkers[MAX_WALKERS][wInfo];
new WalkersDamagers[MAX_WALKERS][MAX_PLAYERS];

new IsSpecialAbilityUsed = false;
new IsNuclearBombExplodes = false;
new IsTeamHealing = false;
new SpecialAbilityDelay = 0;
new SpecialAbilityEffect = SPECIAL_AB_EFFECT_NONE;
new SpecialAbilityEffectTeam = NO_TEAM;
new SpecialAbilityEffectTime = 0;

//Pickups
new home_enter = 0;
new home_quit = 0;
new boss_tp = 0;
new arena_tp = 0;
new war_tp = 0;
new health_pickup = 0;

//Player
new PlayerInventory[MAX_PLAYERS][MAX_SLOTS][iInfo];
new PlayerInfo[MAX_PLAYERS][pInfo];
new AvailableDungeons[MAX_PLAYERS][MAX_DUNGEONS];
new PlayerDungeon[MAX_PLAYERS][pDungeon];
new PlayerHPMultiplicator[MAX_PLAYERS];
new bool:PlayerConnect[MAX_PLAYERS] = false;
new Float:MaxHP[MAX_PLAYERS];
new bool:IsInventoryOpen[MAX_PLAYERS] = false;
new bool:IsDeath[MAX_PLAYERS] = false;
new bool:IsSpawned[MAX_PLAYERS] = false;
new bool:IsParticipant[MAX_PLAYERS] = false;
new bool:IsWalker[MAX_PLAYERS] = false;
new bool:IsDungeonBoss[MAX_PLAYERS] = false;
new bool:IsDungeonMob[MAX_PLAYERS] = false;
new bool:IsEasyMod[MAX_PLAYERS] = false;
new SelectedSlot[MAX_PLAYERS] = -1;

new AccountLogin[MAX_PLAYERS][128];
new ParticipantsCount[MAX_PLAYERS];
new Participants[MAX_PLAYERS][MAX_PARTICIPANTS][128];

new WalkerRespawnTimer[MAX_PLAYERS] = -1;
new SecondTimer[MAX_PLAYERS] = -1;

//Arrays
new EmptyInvItem[iInfo] = {
	-1,
	{0,0,0,0,0,0,0},
	0
};
new MOD_CLEAR[MAX_MOD] = {0,0,0,0,0,0,0};
new EmptyMarketSellingItem[MarketItem] = {
	-1,
	-1,
	0,
	0,
	0,
	"None",
	{0,0,0,0,0,0,0}
};
new BossesNames[MAX_BOSSES][128] = {
	{"BOSS_Edemsky"},
	{"BOSS_FactoryWorker"},
	{"BOSS_Maximus"},
	{"BOSS_ShazokVsemog"},
	{"BOSS_Bourgeois"},
	{"BOSS_Priest"},
	{"BOSS_MadGrandfather"},
	{"BOSS_CJ"}
};
new BossesSkins[MAX_BOSSES][1] = {
	{78},
	{8},
	{119},
	{149},
	{249},
	{1},
	{161},
	{0}
};
new BossesWeapons[MAX_BOSSES][1] = {
	{22},
	{32},
	{30},
	{25},
	{26},
	{25},
	{25},
	{30}
};
new CooperateMessages[MAX_COOPERATE_MSGS][64] = {
	{"Есть!"},
	{"Так точно!"},
	{"Вижу цель."},
	{"Будет сделано."},
	{"Да!"},
	{"За цирк!"},
	{"Выполняю."},
	{"Клоун будет уничтожен!"},
	{"Информация принята."},
	{"АРРРР!"}
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
	{0xCC6600FF},
	{0x6AA84FFF},
	{0x1C4587FF},
	{0x9900FFFF}
};
new HexTeamColors[MAX_TEAMCOLORS][1] = {
	{0x339999FF},
	{0xFF0099FF},
	{0xFFCC00FF},
	{0x33CC00FF},
	{0xCC6600FF}
};

new Float:WatchersPositions[MAX_WATCHERS_POSITIONS][3] = {
	{-2352.5862,-1676.3812,724.5875},
	{-2396.7134,-1631.7484,724.5875},
	{-2353.7573,-1586.3749,724.1573},
	{-2306.6067,-1626.8363,724.5875}
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
new PlayerText:ChrInfMaxHP[MAX_PLAYERS];
new PlayerText:ChrInfInvSlot[MAX_PLAYERS][MAX_PAGE_SLOTS];
new PlayerText:ChrInfInvSlotCount[MAX_PLAYERS][MAX_PAGE_SLOTS];
new PlayerText:ChrInfDamage[MAX_PLAYERS];
new PlayerText:ChrInfDefense[MAX_PLAYERS];
new PlayerText:ChrInfAccuracy[MAX_PLAYERS];
new PlayerText:ChrInfDodge[MAX_PLAYERS];
new PlayerText:ChrInfCrit[MAX_PLAYERS];
new PlayerText:ChrInfHatSlot[MAX_PLAYERS];
new PlayerText:ChrInfArmorSlot[MAX_PLAYERS];
new PlayerText:ChrInfWatchSlot[MAX_PLAYERS];
new PlayerText:ChrInfGlassesSlot[MAX_PLAYERS];
new PlayerText:ChrInfAmuletteSlot1[MAX_PLAYERS];
new PlayerText:ChrInfAmuletteSlot2[MAX_PLAYERS];
new PlayerText:ChrInfRingSlot2[MAX_PLAYERS];
new PlayerText:ChrInfRingSlot1[MAX_PLAYERS];
new PlayerText:ChrInfWeaponSlot[MAX_PLAYERS];
new PlayerText:ChrInfDelim1[MAX_PLAYERS];
new PlayerText:ChrInfDelim2[MAX_PLAYERS];
new PlayerText:ChrInfDelim3[MAX_PLAYERS];
new PlayerText:ChrInfDelim4[MAX_PLAYERS];
new PlayerText:ChrInfDelim5[MAX_PLAYERS];
new PlayerText:ChrInfClose[MAX_PLAYERS];
new PlayerText:ChrInfRate[MAX_PLAYERS];
new PlayerText:ChrInfText2[MAX_PLAYERS];
new PlayerText:ChrInfText1[MAX_PLAYERS];
new PlayerText:ChrInfPersonalRate[MAX_PLAYERS];
new PlayerText:ChrInfAllRate[MAX_PLAYERS];
new PlayerText:ChrInfNextInvBtn[MAX_PLAYERS];
new PlayerText:ChrInfPrevInvBtn[MAX_PLAYERS];
new PlayerText:ChrInfCurInv[MAX_PLAYERS];
new PlayerText:ChrInfButUse[MAX_PLAYERS];
new PlayerText:ChrInfButMod[MAX_PLAYERS];
new PlayerText:ChrInfButDel[MAX_PLAYERS];
new PlayerText:ChrInfButInfo[MAX_PLAYERS];
new PlayerText:ChrInfButSort[MAX_PLAYERS];

new PlayerText:EqInfBox[MAX_PLAYERS];
new PlayerText:EqInfTxt1[MAX_PLAYERS];
new PlayerText:EqInfClose[MAX_PLAYERS];
new PlayerText:EqInfDelim1[MAX_PLAYERS];
new PlayerText:EqInfItemName[MAX_PLAYERS];
new PlayerText:EqInfItemIcon[MAX_PLAYERS];
new PlayerText:EqInfMainStat[MAX_PLAYERS];
new PlayerText:EqInfBonusStat[MAX_PLAYERS][3];
new PlayerText:EqInfDelim2[MAX_PLAYERS];
new PlayerText:EqInfDelim3[MAX_PLAYERS];
new PlayerText:EqInfTxt2[MAX_PLAYERS];
new PlayerText:EqInfMod[MAX_PLAYERS][MAX_MOD];
new PlayerText:EqInfModStat[MAX_PLAYERS][2];
new PlayerText:EqInfDelim4[MAX_PLAYERS];
new PlayerText:EqInfDescriptionStr[MAX_PLAYERS][3];
new PlayerText:EqInfDelim5[MAX_PLAYERS];
new PlayerText:EqInfPrice[MAX_PLAYERS];
new PlayerText:EqInfItemType[MAX_PLAYERS];
new PlayerText:EqInfItemMinRank[MAX_PLAYERS];
new PlayerText:EqInfItemGrade[MAX_PLAYERS];
new PlayerText:EqInfTrading[MAX_PLAYERS];

new PlayerText:InfBox[MAX_PLAYERS];
new PlayerText:InfTxt1[MAX_PLAYERS];
new PlayerText:InfDelim1[MAX_PLAYERS];
new PlayerText:InfItemIcon[MAX_PLAYERS];
new PlayerText:InfItemName[MAX_PLAYERS];
new PlayerText:InfItemType[MAX_PLAYERS];
new PlayerText:InfItemEffect[MAX_PLAYERS][3];
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

new PlayerText:CmbBox[MAX_PLAYERS];
new PlayerText:CmbTxt1[MAX_PLAYERS];
new PlayerText:CmbDelim1[MAX_PLAYERS];
new PlayerText:CmbItemSlot[MAX_PLAYERS][MAX_CMB_ITEMS];
new PlayerText:CmbItemSlotCount[MAX_PLAYERS][MAX_CMB_ITEMS];
new PlayerText:CmbTxt2[MAX_PLAYERS];
new PlayerText:CmbTxt3[MAX_PLAYERS];
new PlayerText:CmbTxt4[MAX_PLAYERS];
new PlayerText:CmbBtn[MAX_PLAYERS];
new PlayerText:CmbBtnBox[MAX_PLAYERS];
new PlayerText:CmbClose[MAX_PLAYERS];

new PlayerText:MpBox[MAX_PLAYERS];
new PlayerText:MpDelim1[MAX_PLAYERS];
new PlayerText:MpClose[MAX_PLAYERS];
new PlayerText:MpTxt1[MAX_PLAYERS];
new PlayerText:MpItem[MAX_PLAYERS];
new PlayerText:MpItemCount[MAX_PLAYERS];
new PlayerText:MpTxt2[MAX_PLAYERS];
new PlayerText:MpDelim2[MAX_PLAYERS];
new PlayerText:MpTxtPrice[MAX_PLAYERS];
new PlayerText:MpTxtCount[MAX_PLAYERS];
new PlayerText:MpBtn1Box[MAX_PLAYERS];
new PlayerText:MpBtn2Box[MAX_PLAYERS];
new PlayerText:MpBtn1[MAX_PLAYERS];
new PlayerText:MpBtn2[MAX_PLAYERS];
new PlayerText:MpBtnBox[MAX_PLAYERS];
new PlayerText:MpBtn[MAX_PLAYERS];

main()
{
	new str[64];
	format(str, sizeof(str), "Bourgeois Circus ver. %.2f", VERSION);
	print(str);
}

/* Commands */
//GM commands
cmd:tp1(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
	
	RemoveWorldBounds(playerid);
	SetPlayerPos(playerid, 1435.2000000,1504.6000000,12.9000000);
	SetPlayerInterior(playerid, 0);
	return SendClientMessage(playerid, COLOR_GREY, "Done.");
}
cmd:tp2(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
	
	RemoveWorldBounds(playerid);
	SetPlayerPos(playerid, -60.7000000,1516.9000000,12.9000000);
	SetPlayerInterior(playerid, 0);
	return SendClientMessage(playerid, COLOR_GREY, "Done.");
}
cmd:tests(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
	
	TickHour();
	return SendClientMessage(playerid, COLOR_GREY, "Done.");
}
cmd:sort(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
	
	SortInventory(playerid);
	return SendClientMessage(playerid, COLOR_GREY, "Done.");
}
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
	if(itemid <= 0 || itemid == 81 || itemid > MAX_ITEM_ID || !DbItemExists(itemid))
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
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;

	if(IsTourStarted) return 0;
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

cmd:happybirthday(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;

	new owner[64];

	if(sscanf(params, "s[64]", owner))
		return SendClientMessage(playerid, COLOR_GREY, "USAGE: /happybirthday [owner]");

	HappyBirthday(owner);
	SendClientMessage(playerid, COLOR_GREY, "Done");
	return 1;
}

cmd:reloadinv(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
	SendClientMessage(playerid, COLOR_GREY, "Reloading...");
	LoadInventory(playerid);
	SendClientMessage(playerid, COLOR_GREEN, "Inventory reloading completed.");
	return 1;
}

cmd:updhier(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
	UpdateHierarchy();
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
	
	RemoveWorldBounds(playerid);
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
	FCNPC_UseCrashLog(true);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	DisableNameTagLOS();
	SetNameTagDrawDistance(300.0);
	//SetWorldTime(1);

	CreateMap();
	CreatePickups();
	InitTextDraws();

	WorldTime_Timer = SetTimer("Time", 1000, true);
	WalkersRefreshTimer = SetTimer("RefreshWalkers", 600000, true);

	arena_area = CreateDynamicRectangle(-2390.5017, -1669.8492, -2313.0295, -1593.6758, 0, 0, -1);
	walkers_area = CreateDynamicRectangle(183.5849, -1867.2853, 298.7423, -1842.1835, 0, 0, -1);

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
	if(Tournament[Phase] == PHASE_PEACE)
		InitWalkers();

	UpdateGlobalRatingTop();

	return 1;
}

public OnGameModeExit()
{
	SaveTournamentInfo();
	DeleteTextDraws();
	ResetLoot();
	ResetAllSpecialAbilites();
	KillTimer(WorldTime_Timer);
	KillTimer(WalkersRefreshTimer);
	for (new i = 0; i < MAX_ACTORS; i++)
		DestroyActor(Actors[i]);
	DestroyWalkers();
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

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(FCNPC_IsValid(playerid)) return 0;
	if(PlayerInfo[playerid][IsWatcher] <= 0) return 0;

	if(IsTourStarted && !IsDeath[playerid] && areaid == arena_area)
	{
		TeleportToRandomWatcherPos(playerid);
		UpdatePlayerVisual(playerid);
	}

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
	{
		new query[255] = "SELECT * FROM `accounts`";
		new Cache:q_result = mysql_query(sql_handle, query);
		new count = 0;
		cache_get_row_count(count);
		cache_delete(q_result);
		if(count < MAX_OWNERS + 1)
			ShowPlayerDialog(playerid, 100, DIALOG_STYLE_PASSWORD, "Регистрация", "Указанный логин не зарегистрирован.\n\nПридумайте пароль:", "Далее", "Закрыть");\
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "Зарегистрировано максимальное количество аккаунтов.");
			SendClientMessage(playerid, COLOR_GREEN, "Введите /q для выхода.");
			return 1;
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	IsDeath[playerid] = false;
	IsSpawned[playerid] = false;

	if(!FCNPC_IsValid(playerid))
    	ShowTextDraws(playerid);
	return 1;
}

public OnPlayerLogin(playerid) 
{
	SetPlayerTeam(playerid, 10);
	SetPlayerTourTeam(playerid, NO_TEAM);

	if(!FCNPC_IsValid(playerid))
	{
		InitPlayerTextDraws(playerid);
		PlayerTextDrawShow(playerid, HPBar[playerid]);
		HideAllWindows(playerid);
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
		UpdatePlayerPost(playerid);
		SetPVarInt(playerid, "InvPage", 1);
	}

	PlayerConnect[playerid] = true;
	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;

	SetPVarInt(playerid, "LastKill", -1);
	SetPVarInt(playerid, "SpecialAbilityCooldown", 0);
	SetPVarInt(playerid, "ActiveDungeon", -1);
	SetPVarInt(playerid, "DungeonEnemiesKilled", 0);
	SetPVarInt(playerid, "DungeonEnemiesRequired", 0);

	UpdatePlayerMaxHP(playerid);
	SetPlayerSkills(playerid);
	SetPVarFloat(playerid, "HP", MaxHP[playerid]);
	SetPlayerHP(playerid, MaxHP[playerid]);

	if(!FCNPC_IsValid(playerid))
		SpawnPlayer(playerid);
	else
		FCNPC_Spawn(playerid, PlayerInfo[playerid][Skin], PlayerInfo[playerid][PosX], PlayerInfo[playerid][PosY], PlayerInfo[playerid][PosZ]);

	UpdatePlayerStats(playerid);
	if(!FCNPC_IsValid(playerid))
		UpdateLocalRatingTop(playerid);
	UpdatePlayerSkin(playerid);
	UpdatePlayerEffects(playerid);
	
	SecondTimer[playerid] = SetTimerEx("TickSecond", 1000, true, "i", playerid);
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
	if(SpecialActivity == SPECIAL_ACTIVITY_S_DELIVERY && vehicleid == SpecialActivityVehicleID)
	{
		if(GetDistanceBetweenPoints(new_x,new_y,new_z,221.0985,-1838.1259,3.6268) < 4)
			OnSpecialActivityEnd(1);
	}

	return 1;
}

public OnSpecialActivityStart(activityid)
{
	if(activityid == SPECIAL_ACTIVITY_NONE) return;
	if(activityid == SPECIAL_ACTIVITY_S_DELIVERY)
	{
		//spawn S
		SpecialActivityVehicleID = CreateVehicle(466,282.7999900,-1872.8000000,2.4000000,0.0000000,0,0,-1); //S
		SetVehicleParamsEx(SpecialActivityVehicleID, 0, 0, 0, 1, 0, 0, 0);

		SendClientMessageToAll(COLOR_YELLOW, "Обнаружен S! Доставьте его скорее Буржуа и вас ждут награды!");
		SendClientMessageToAll(COLOR_YELLOW, "У вас есть 100 секунд! Поторопитесь!");
	}

	SpecialActivity = activityid;
	SpecialActivityTimer = 100;
}

public OnSpecialActivityEnd(win)
{
	if(SpecialActivity == SPECIAL_ACTIVITY_NONE) return;
	if(SpecialActivity == SPECIAL_ACTIVITY_S_DELIVERY)
	{
		DestroyVehicle(SpecialActivityVehicleID);
		SpecialActivityVehicleID = -1;
		ResetAllWalkersTargets();

		if(win)
		{
			SendClientMessageToAll(COLOR_GREEN, "S успешно доставлен получателю! Буржуа щедро одарил помощников, проверьте почту!");
			GiveSpecialActivityRewards(SpecialActivity);
		}
		else
			SendClientMessageToAll(COLOR_RED, "S не был доставлен в срок! Буржуа сильно недоволен...");
	}

	SpecialActivity = SPECIAL_ACTIVITY_NONE;
	SpecialActivityDelay = SPECIAL_ACTIVITY_COOLDOWN;
	SpecialActivityTimer = 0;
}

public OnTourEnd(finished)
{
	if(IsValidTimer(TourEndTimer))
		KillTimer(TourEndTimer);
	if(IsValidTimer(PvpTableUpdTimer))
		KillTimer(PvpTableUpdTimer);

	for(new i = 0; i < MAX_DEATH_MESSAGES; i++)
		SendDeathMessage(-1, MAX_PLAYERS + 1, 0);

	IsTourStarted = false;
	ResetAllSpecialAbilites();

	if(finished == 1)
	{
		GiveTourRates(Tournament[Tour]);
		UpdateTournamentTable();
	}

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(FCNPC_IsValid(i))
		{
			if(IsValidTimer(DeadCheckTimer[i]))
				KillTimer(DeadCheckTimer[i]);
			for(new j = 0; j < MAX_OWNERS; j++)
				FCNPC_HideInTabListForPlayer(i, TourPlayers[j]);
			FCNPC_Destroy(i);
			ResetPlayerVariables(i);
		}
	}
	for(new i = 0; i < MAX_OWNERS; i++)
	{
		SetPvpTableVisibility(TourPlayers[i], false);
		TeleportToHome(TourPlayers[i]);
		UpdatePlayerVisual(TourPlayers[i]);
		SetPVarFloat(TourPlayers[i], "HP", MaxHP[TourPlayers[i]]);
		SetPlayerHP(TourPlayers[i], MaxHP[TourPlayers[i]]);
	}

	new string[255];
	if(finished == 1)
	{
		format(string, sizeof(string), "%d тур завершен.", Tournament[Tour]);
		SendClientMessageToAll(COLOR_LIGHTRED, string);
		GiveTourRewards(Tournament[Tour]);
		Tournament[Tour]++;
		for(new i = 0; i < MAX_OWNERS; i++)
			ShowTournamentTab(TourPlayers[i]);
		if(Tournament[Tour] > MAX_TOUR)
			OnTournamentEnd();
		else
		{
			UpdateTourParticipants();
			for(new i = 0; i < MAX_OWNERS; i++)
			{
                if(PlayerInfo[TourPlayers[i]][IsWatcher] != 0)
					continue;
				if(IsTourParticipant(PlayerInfo[TourPlayers[i]][ID]))
					SendClientMessage(TourPlayers[i], COLOR_GREEN, "Вы прошли в следующий тур.");
				else
					SendClientMessage(TourPlayers[i], COLOR_LIGHTRED, "Вы выбываете из турнира.");
			}
		}
		UpdateGlobalRatingTop();
	}
	else
		SendClientMessageToAll(COLOR_LIGHTRED, "Тур прерван.");
}

public OnPhaseChanged(oldphase, newphase)
{
	if(newphase == PHASE_PEACE)
		InitWalkers();
	else
		DestroyWalkers();
}

public OnTournamentEnd()
{
	new string[255];
	format(string, sizeof(string), "%d турнир завершен!", Tournament[Number]);
	SendClientMessageToAll(COLOR_LIGHTRED, string);

	if(Tournament[Number] % 10 == 0)
		UpdateHierarchy();

	Tournament[Tour] = 1;
	Tournament[Number]++;
	Tournament[Phase] = PHASE_PEACE;

	UpdateMarketItems();
	UpdateTempItems();
	GiveTournamentRewards();
	UpdateTourParticipants();
	AddSimulationLimit();

	OnPhaseChanged(PHASE_WAR, PHASE_PEACE);
	SendClientMessageToAll(COLOR_LIGHTRED, "Начинается фаза мира.");
}

public OnBattleEnd(winner[], finished)
{
	/*if(IsValidTimer(BattleEndTimer))
		KillTimer(BattleEndTimer);
	if(IsValidTimer(PvpTableUpdTimer))
		KillTimer(PvpTableUpdTimer);

	for(new i = 0; i < MAX_DEATH_MESSAGES; i++)
		SendDeathMessage(-1, MAX_PLAYERS + 1, 0);

	StopBattleCapture();
	IsBattleStarted = false;
	ResetAllSpecialAbilites();

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(FCNPC_IsValid(i))
		{
			if(IsValidTimer(DeadCheckTimer[i]))
				KillTimer(DeadCheckTimer[i]);
			for(new j = 0; j < MAX_OWNERS; j++)
				FCNPC_HideInTabListForPlayer(i, BattlePlayers[j]);
			FCNPC_Destroy(i);
			ResetPlayerVariables(i);
		}
	}
	for(new i = 0; i < MAX_OWNERS; i++)
	{
		SetBattleTableVisibility(BattlePlayers[i], false);
		SetPvpTableVisibility(BattlePlayers[i], false);
		TeleportToHome(BattlePlayers[i]);
		UpdatePlayerVisual(BattlePlayers[i]);
		SetPVarFloat(BattlePlayers[i], "HP", MaxHP[BattlePlayers[i]]);
		SetPlayerHP(BattlePlayers[i], MaxHP[BattlePlayers[i]]);
	}

	if(finished == 0)
	{
		SendClientMessageToAll(COLOR_LIGHTRED, "Захват прерван.");
		return 0;
	}

	new string[255];
	format(string, sizeof(string), "%s - победитель в войне.", winner);
	SendClientMessageToAll(COLOR_WHITE, string);

	Tournament[Phase] = PHASE_PEACE;

	UpdateSpecialEffects(winner);
	GiveBattleRewards(winner);

	OnPhaseChanged(PHASE_BATTLE, PHASE_PEACE);
	SendClientMessageToAll(COLOR_LIGHTRED, "Начинается фаза мира.");

	return 1;*/
}

stock AddSimulationLimit()
{
	new query[512] = "UPDATE `players` SET `Simulations` = Simulations+1";
	new Cache:result = mysql_query(sql_handle, query);
	cache_delete(result);

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		PlayerInfo[i][Simulations]++;
	}
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

        if(PlayerInfo[InitID][IsWatcher] <= 0)
		{
			new myplace = GetPvpIndex(InitID);
			if(myplace == -1)
				myplace = MAX_PARTICIPANTS-1;

			format(name, sizeof(name), "%d. %s", myplace+1, PvpInfo[myplace][Name]);
			PlayerTextDrawSetStringRus(InitID, PvpPanelMyName[InitID], name);
			format(score, sizeof(score), "%d", PvpInfo[myplace][Score]);
			PlayerTextDrawSetStringRus(InitID, PvpPanelMyScore[InitID], score);
		}

		PlayerTextDrawSetStringRus(InitID, PvpPanelTimer[InitID], string);
	}
}

public Float:GetDefenseMul(defense)
{
    new Float:mul = 1.0;
    mul = floatsub(1.0, floatdiv(floatmul(3.086,floatlog(floatadd(floatmul(0.0006227, defense), 1), 1.139)), 100));
	if(mul < 0)
		mul = 0.05;
	return mul;
}

public FCNPC_OnGiveDamage(npcid, damagedid, Float:amount, weaponid, bodypart)
{
	return OnPlayerGiveDamage(npcid, damagedid, amount, weaponid, bodypart);
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(!IsBoss[damagedid] && !IsWalker[damagedid] && !IsDungeonBoss[damagedid] && !IsDungeonMob[damagedid] && 
		GetPlayerTourTeam(damagedid) != NO_TEAM && GetPlayerTourTeam(playerid) == GetPlayerTourTeam(damagedid))
	{
		if(FCNPC_IsValid(damagedid))
			FCNPC_GiveHealth(damagedid, amount);
		return 0;
	}

	if(IsBossAttacker[playerid] && IsBossAttacker[damagedid])
	{
		new Float:c_hp;
		GetPlayerHealth(damagedid, c_hp);
		SetPlayerHealth(damagedid, floatadd(amount, c_hp));
		return 0;
	}

	if(IsWalker[playerid] && IsWalker[damagedid])
	{
		FCNPC_GiveHealth(damagedid, amount);
		return 0;
	}

	if(IsDungeonMob[playerid] && (IsDungeonMob[damagedid] || IsDungeonBoss[damagedid]))
	{
		FCNPC_GiveHealth(damagedid, amount);
		return 0;
	}

	if(IsDungeonBoss[playerid] && (IsDungeonMob[damagedid] || IsDungeonBoss[damagedid]))
	{
		FCNPC_GiveHealth(damagedid, amount);
		return 0;
	}

	if(FCNPC_IsValid(damagedid))
		FCNPC_GiveHealth(damagedid, amount);
	else
	{
		new Float:c_hp;
		GetPlayerHealth(damagedid, c_hp);
		SetPlayerHealth(damagedid, floatadd(amount, c_hp));
	}

	if(PlayerInfo[playerid][IsWatcher] <= 0 && IsWalker[damagedid] && FCNPC_GetAimingPlayer(damagedid) == INVALID_PLAYER_ID)
	{
		if(PlayerInfo[playerid][WalkersLimit] > 0 || SpecialActivity == SPECIAL_ACTIVITY_S_DELIVERY)
			SetPlayerTarget(damagedid, playerid);
		else 
			return 0;
	}

	if(IsPlayerInDungeon(playerid) && (IsDungeonBoss[damagedid] || IsDungeonMob[damagedid]) && FCNPC_GetAimingPlayer(damagedid) == INVALID_PLAYER_ID)
	{
		SetPlayerTarget(damagedid, playerid);
	}

	new is_invulnearable = GetPVarInt(damagedid, "Invulnearable");
	new dodge = (PlayerInfo[damagedid][Dodge] - PlayerInfo[playerid][Accuracy]) / 3;
	if(dodge < 0) dodge = 0;
	if(dodge > 95) dodge = 95;
	new bool:dodged = CheckChance(dodge);

	new bool:is_crit = CheckChance(PlayerInfo[playerid][Crit]);
	if(IsTourStarted && SpecialAbilityEffect == SPECIAL_AB_EFFECT_SHAZOK_FORCE && GetPlayerTourTeam(playerid) == SpecialAbilityEffectTeam)
		is_crit = true;

	new damage;
	if(dodged || is_invulnearable > 0 || weaponid == 0)
		damage = 0;
	else if(is_crit)
		damage = PlayerInfo[playerid][DamageMax];
	else
		damage = PlayerInfo[playerid][DamageMin] + random(PlayerInfo[playerid][DamageMax]-PlayerInfo[playerid][DamageMin]+1);
	
	new Float:defense_mul = GetDefenseMul(PlayerInfo[damagedid][Defense]);
	damage = floatround(floatmul(damage, defense_mul));

	if(IsTourStarted && SpecialAbilityEffect == SPECIAL_AB_EFFECT_SHAZOK_FORCE && GetPlayerTourTeam(playerid) == SpecialAbilityEffectTeam)
		damage = damage * 2;

	new real_damage;
	if(floatsub(GetPlayerHP(damagedid), damage) < 0)
	{
		real_damage = floatround(GetPlayerHP(damagedid)) + 1;
		if(real_damage < 0)
			real_damage = 0;
	}
	else
		real_damage = damage;
	
	if(PlayerInfo[playerid][Vamp] > 0 && real_damage > 0)
	{
		new Float:vamp_hp = floatmul(floatdiv(PlayerInfo[playerid][Vamp], 100), real_damage);
		GivePlayerHP(playerid, vamp_hp);
	}

	if(IsTourStarted)
	{
		new damagerid = GetPvpIndex(playerid);
		if(damagerid != -1 && damagerid < MAX_PARTICIPANTS)
			DmgInfo[damagedid][damagerid] += real_damage;
	}

	if(IsWalker[damagedid])
	{
		new d_idx = GetWalkerIdx(damagedid);
		if(d_idx != -1)
			WalkersDamagers[d_idx][playerid] += real_damage;
	}

	if(dodged)
		SetPlayerChatBubble(damagedid, "Уклонение", 0x66CCCCFF, 80.0, 1200);
	else if(is_invulnearable > 0)
		SetPlayerChatBubble(damagedid, "Неуязвимость", 0x9933FFFF, 80.0, 1200);
	else
	{
		new dmginf[32];
		format(dmginf, sizeof(dmginf), "%d", real_damage);
		SetPlayerChatBubble(damagedid, dmginf, is_crit ? 0xFFCC00FF : 0xFFFFFFFF, 80.0, 1200);
	}

	new Float:new_hp;
	new_hp = GetPVarFloat(damagedid, "HP");
	new_hp = floatsub(new_hp, damage);
	SetPVarFloat(damagedid, "HP", new_hp);
	if(IsNuclearBombExplodes || IsTeamHealing)
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
	if(IsPlayerInDungeon(playerid))
	{
		CompleteDungeon(playerid, false);
		TeleportToHome(playerid);
	}
	if(!IsWalker[playerid] && !IsDungeonBoss[playerid] && !IsDungeonMob[playerid] && (IsPlayerParticipant(playerid) || PlayerInfo[playerid][Admin] > 0))
		SavePlayer(playerid, !FCNPC_IsValid(playerid));

	if(!FCNPC_IsValid(playerid))
		DeletePlayerTextDraws(playerid);
	
	if(IsValidTimer(SecondTimer[playerid]))
		KillTimer(SecondTimer[playerid]);
	SecondTimer[playerid] = -1;

	IsInventoryOpen[playerid] = false;
	SelectedSlot[playerid] = -1;
	IsParticipant[playerid] = false;
	IsEasyMod[playerid] = false;
	IsBossAttacker[playerid] = false;
	IsBoss[playerid] = false;
	IsDeath[playerid] = false;
	IsSpawned[playerid] = false;
	IsWalker[playerid] = false;
	IsDungeonBoss[playerid] = false;
	IsDungeonMob[playerid] = false;

	SetPVarInt(playerid, "SpecialAbilityCooldown", 0);
	SetPVarInt(playerid, "ActiveDungeon", -1);
	SetPVarInt(playerid, "DungeonEnemiesKilled", 0);
	SetPVarInt(playerid, "DungeonEnemiesRequired", 0);

	for (new i = 0; i < 10; i++)
	    if (IsPlayerAttachedObjectSlotUsed(playerid, i))
	        RemovePlayerAttachedObject(playerid, i);

	PlayerConnect[playerid] = false;
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	SetVehicleToRespawn(vehicleid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerTeam(playerid, 10);
	SetPlayerVirtualWorld(playerid, 0);
	SetPVarFloat(playerid, "HP", MaxHP[playerid]);
	SetPlayerHP(playerid, MaxHP[playerid]);
	SetPVarInt(playerid, "Invulnearable", 0);
	TogglePlayerControllable(playerid, 1);

	if(IsDeath[playerid]) 
	{
	    IsDeath[playerid] = false;
		if(IsTourStarted && IsTourParticipant(PlayerInfo[playerid][ID]))
		{
			ResetDamagersInfo(playerid);
			TeleportToRandomArenaPos(playerid);
			SetPlayerInvulnearable(playerid, TOUR_INVULNEARABLE_TIME);
			if(SpecialAbilityEffect == SPECIAL_AB_EFFECT_CONFUSION && GetPlayerTourTeam(playerid) != SpecialAbilityEffectTeam)
				TogglePlayerControllable(playerid, 0);
		}
        else if(IsTourStarted && PlayerInfo[playerid][IsWatcher] != 0)
		{
			TeleportToRandomWatcherPos(playerid);
		}
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
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);

    if(PlayerInfo[playerid][IsWatcher] != 0)
		SetPlayerColor(playerid, HexTeamColors[PlayerInfo[playerid][TeamColor]][0]);
	else if(PlayerInfo[playerid][Status] != HIERARCHY_NONE && !IsTourStarted)
		SetPlayerColor(playerid, 0x0066FFFF);
	else
		SetPlayerColor(playerid, IsTourStarted ? HexTeamColors[PlayerInfo[playerid][TeamColor]][0] : HexRateColors[PlayerInfo[playerid][Rank]-1][0]);

    UpdatePlayerEffects(playerid);

	if(!FCNPC_IsValid(playerid))
    {
        SetCameraBehindPlayer(playerid);
		UpdatePlayerWeapon(playerid);
		UpdatePlayerHat(playerid);
		UpdatePlayerGlasses(playerid);
		UpdatePlayerWatch(playerid);
    }
}

stock DisableEffects(playerid)
{
    for(new i = 0; i < 10; i++)
    {
    	if(IsPlayerAttachedObjectSlotUsed(playerid, i))
    		RemovePlayerAttachedObject(playerid, i);
    }
}

stock UpdatePlayerEffects(playerid)
{
    new mod_level = GetModLevel(PlayerInfo[playerid][WeaponMod]);
	switch(mod_level)
	{
	    case 0..4:
	    {
			RemovePlayerAttachedObject(playerid, 0);
			RemovePlayerAttachedObject(playerid, 1);
	    }
	    case 5:
	    {
	        SetPlayerAttachedObject(playerid, 0, 18700, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
   			SetPlayerAttachedObject(playerid, 1, 18700, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
	    }
	    case 6:
	    {
	        SetPlayerAttachedObject(playerid, 0, 18699, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
   			SetPlayerAttachedObject(playerid, 1, 18699, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
	    }
	    case 7:
	    {
	        SetPlayerAttachedObject(playerid, 0, 18693, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
   			SetPlayerAttachedObject(playerid, 1, 18693, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
	    }
	}

	if(PlayerInfo[playerid][Status] == HIERARCHY_LEADER)
	{
		SetPlayerAttachedObject(playerid,2,18728,17,3.547008,-1.172998,-1.610998,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
		SetPlayerAttachedObject(playerid,3,18741,1,-1.177999,0.087000,-2.082005,0.000000,0.000000,0.000000,1.654000,1.481000,1.257000);
	}
	else
	{
		RemovePlayerAttachedObject(playerid, 2);
		RemovePlayerAttachedObject(playerid, 3);
	}
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(IsBoss[playerid])
		return 0;

	IsDeath[playerid] = true; 
	IsSpawned[playerid] = false;

    if(PlayerInfo[playerid][IsWatcher] != 0)
		return 0;

	if(IsTourStarted)
	{
		new _killerid = GetRealKillerId(playerid, killerid);
		if(_killerid == -1)
		{
			if(killerid == -1 || killerid == INVALID_PLAYER_ID)
				return 0;
			_killerid = killerid;
		}

		new lastkill = GetPVarInt(_killerid, "LastKill");
		if(lastkill == playerid) 
		{
			SetPVarInt(_killerid, "LastKill", -1);
			return 1;
		}
		SetPVarInt(_killerid, "LastKill", playerid);

		if(!FCNPC_IsDead(playerid))
			FCNPC_Kill(playerid);

		SendDeathMessage(_killerid, playerid, reason);
		PlayerInfo[_killerid][Kills]++;
		PlayerInfo[playerid][Deaths]++;

		new killer_idx = GetPvpIndex(_killerid);
		new player_idx = GetPvpIndex(playerid);
		if(killer_idx == -1 || player_idx == -1) return 1;
		if(GetPlayerTourTeam(playerid) == GetPlayerTourTeam(_killerid))
		{
			SendClientMessage(_killerid, COLOR_LIGHTRED, "Штраф за убийство союзника 50 очков.");
			PvpInfo[player_idx][Score] -= 50;
			if(PvpInfo[player_idx][Score] < 0)
				PvpInfo[player_idx][Score] = 0;
			return 1;
		}

		PvpInfo[killer_idx][Kills]++;
		PvpInfo[player_idx][Deaths]++;
		
		GiveKillScore(playerid, _killerid);
		if((PlayerInfo[_killerid][Rate] - PlayerInfo[playerid][Rate]) < 100)
		{
			PvpInfo[player_idx][Score] -= GetScoreDiff(PlayerInfo[playerid][Rate], PlayerInfo[_killerid][Rate], false);
			if(PvpInfo[player_idx][Score] < 0)
				PvpInfo[player_idx][Score] = 0;
		}
	}
	else
	{
		if(IsBossAttacker[playerid])
		{
			IsBossAttacker[playerid] = false;
			BossAttackersCount--;
			if(BossAttackersCount <= 0)
				FinishBossAttack();
			return 1;
		}
		if(IsWalker[playerid])
		{
			new idx = GetWalkerIdx(playerid);
			if(idx != -1)
				DestroyDynamic3DTextLabel(Walkers[idx][LabelID]);
			WalkerRespawnTimer[playerid] = SetTimerEx("RespawnWalker", GetWalkerRespawnTime(PlayerInfo[playerid][Rank]), false, "i", playerid);

			if(killerid != -1 && killerid != INVALID_PLAYER_ID)
			{
				if(PlayerInfo[killerid][WalkersLimit] > 0)
					RollWalkerLoot(playerid, killerid);

				PlayerInfo[killerid][WalkersLimit]--;
				if(PlayerInfo[killerid][WalkersLimit] <= 0)
				{
					PlayerInfo[killerid][WalkersLimit] = 0;
					if(SpecialActivity != SPECIAL_ACTIVITY_S_DELIVERY)
						SendClientMessage(killerid, COLOR_LIGHTRED, "Достигнут лимит прохожих.");
				}
			}

			return 1;
		}
		if((IsDungeonMob[playerid] || IsDungeonBoss[playerid]) && IsPlayerInDungeon(killerid))
		{
			if(killerid != -1 && killerid != INVALID_PLAYER_ID)
			{
				RollDungeonLoot(playerid, killerid);
				new killed = GetPVarInt(killerid, "DungeonEnemiesKilled");
				new required = GetPVarInt(killerid, "DungeonEnemiesRequired");

				killed++;
				SetPVarInt(killerid, "DungeonEnemiesKilled", killed);
				
				new dinfstr[255];
				format(dinfstr, sizeof(dinfstr), "Убито: %d/%d", killed, required);
				SendClientMessage(killerid, COLOR_YELLOW, dinfstr);

				if(killed >= required)
					CompleteDungeon(killerid, true);
			}

			return 1;
		}
		if(killerid != -1 && killerid != INVALID_PLAYER_ID)
		{
			if(IsWalker[killerid])
			{
				PlayerInfo[playerid][WalkersLimit]--;
				if(PlayerInfo[playerid][WalkersLimit] < 0)
					PlayerInfo[playerid][WalkersLimit] = 0;
			}
			if((IsDungeonMob[killerid] || IsDungeonBoss[killerid]) && IsPlayerInDungeon(playerid))
			{
				CompleteDungeon(playerid, false);
			}
		}
	}
	return 1;
}

public FCNPC_OnSpawn(npcid)
{
	if(IsBoss[npcid])
		return 0;
	SetPVarInt(npcid, "Invulnearable", 0);
	SetPVarFloat(npcid, "HP", MaxHP[npcid]);
	if(PlayerInfo[npcid][TeamColor] != -1 && IsTourStarted)
		SetPlayerColor(npcid, HexTeamColors[PlayerInfo[npcid][TeamColor]][0]);

	UpdatePlayerWeapon(npcid);
	UpdatePlayerSkin(npcid);
	UpdatePlayerHat(npcid);
	UpdatePlayerGlasses(npcid);
	UpdatePlayerWatch(npcid);
    UpdatePlayerEffects(npcid);
	if(IsTourStarted && IsTourParticipant(PlayerInfo[npcid][ID]))
	{
		SetPVarInt(npcid, "MovingTicks", 0);
		SetPVarInt(npcid, "IdleTicks", 0);
		SetPVarInt(npcid, "FixTargetID", -1);
		ResetDamagersInfo(npcid);
		TeleportToRandomArenaPos(npcid);
		SetPlayerInvulnearable(npcid, TOUR_INVULNEARABLE_TIME);
	}
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

public RespawnWalker(walkerid)
{
	if(IsValidTimer(WalkerRespawnTimer[walkerid]))
		KillTimer(WalkerRespawnTimer[walkerid]);
	if(!IsWalker[walkerid])
		return;

	new i = GetWalkerIdx(walkerid);
	if(i == -1) return;

	new rank = random(MAX_RANK) + 1;
	new w_count = GetWalkersCountByRank(rank);
	new iterations = 0;
	while(w_count >= MAX_WALKERS_ONE_RANK && iterations < 30)
	{
		rank = random(MAX_RANK) + 1;
		w_count = GetWalkersCountByRank(rank);
		iterations++;
	}

	Walkers[i] = GetWalker(rank);
	Walkers[i][ID] = walkerid;

	ResetWalkerDamagersInfo(walkerid);
	ResetWalkerLoot(walkerid);

	MaxHP[Walkers[i][ID]] = Walkers[i][HP];
	SetPlayerMaxHP(Walkers[i][ID], Walkers[i][HP], false);

	PlayerInfo[walkerid][Rank] = rank;
	PlayerInfo[walkerid][DamageMin] = Walkers[i][DamageMin];
	PlayerInfo[walkerid][DamageMax] = Walkers[i][DamageMax];
	PlayerInfo[walkerid][Defense] = Walkers[i][Defense];
	PlayerInfo[walkerid][Dodge] = Walkers[i][Dodge];
	PlayerInfo[walkerid][Accuracy] = Walkers[i][Accuracy];
	PlayerInfo[walkerid][Crit] = Walkers[i][Crit];
	PlayerInfo[walkerid][Sex] = 0;
	PlayerInfo[walkerid][Skin] = Walkers[i][Skin];
	PlayerInfo[walkerid][WeaponSlotID] = Walkers[i][WeaponID];

	new name[255];
	format(name, sizeof(name), "[LV%d] %s", Walkers[i][Rank], Walkers[i][Name]);
	Walkers[i][LabelID] = CreateDynamic3DTextLabel(name, HexRateColors[Walkers[i][Rank]-1][0], 0, 0, 0.15, 40, Walkers[i][ID]);

	FCNPC_Respawn(walkerid);
	FCNPC_SetSkin(walkerid, Walkers[i][Skin]);
	SetRandomWalkerPos(walkerid);
	FCNPC_StopAim(walkerid);
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
    else if(PlayerInfo[playerid][IsWatcher] != 0)
	{
		format(message, sizeof(message), "[Наблюдатель][%s]: %s", AccountLogin[playerid], text);
		SendClientMessageToAll(HexTeamColors[PlayerInfo[playerid][TeamColor]][0], message);
	}
	else if(PlayerInfo[playerid][Status] != HIERARCHY_NONE)
	{
		format(message, sizeof(message), "[Основатель][%s]: %s", name, text);
		SendClientMessageToAll(0x0066FFFF, message);
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
	else if(pickupid == health_pickup)
	{
		SetPlayerHP(playerid, MaxHP[playerid]);
		SetPVarFloat(playerid, "HP", MaxHP[playerid]);
	}
	for(new i = 0; i < MAX_LOOT; i++)
	{
		if(pickupid == BossLootPickups[i])
		{
			if(IsInventoryFull(playerid))
			{
				SendClientMessage(playerid, COLOR_GREY, "Инвентарь полон.");
				continue;
			}
			SafeDestroyPickup(BossLootPickups[i]);
			if(BossLootItems[i][ItemID] == -1) continue;

			new string[255];
			new item[BaseItem];
			item = GetItem(BossLootItems[i][ItemID]);

			if(IsEquip(BossLootItems[i][ItemID]))
			{
				AddEquip(playerid, BossLootItems[i][ItemID], MOD_CLEAR);
				if(item[Grade] >= GRADE_C)
				{
					format(string, sizeof(string), "{%s}%s {ffffff}приобрел {%s}[%s]{ffffff}.", 
						GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name], GetGradeColor(item[Grade]), item[Name]
					);
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
			}
			else
				AddItem(playerid, BossLootItems[i][ItemID], BossLootItems[i][Count]);
			
			format(string, sizeof(string), "Подобрано: {%s}[%s] {ffffff}x%d.", 
				GetGradeColor(item[Grade]), item[Name], BossLootItems[i][Count]
			);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
	}
	for(new j = 0; j < MAX_PLAYERS; j++)
	{
		if(!IsPlayerConnected(j) || !IsWalker[j]) continue;
		for(new i = 0; i < MAX_WALKER_LOOT; i++)
		{
			if(pickupid != WalkerLootPickups[j][i]) continue;
			if(WalkerLootItems[j][i][OwnerID] == -1 || WalkerLootItems[j][i][OwnerID] == playerid)
			{
				if(IsInventoryFull(playerid))
				{
					SendClientMessage(playerid, COLOR_GREY, "Инвентарь полон.");
					continue;
				}
				SafeDestroyPickup(WalkerLootPickups[j][i]);
				if(WalkerLootItems[j][i][ItemID] == -1) continue;

				new string[255];
				new item[BaseItem];
				item = GetItem(WalkerLootItems[j][i][ItemID]);

				if(IsEquip(WalkerLootItems[j][i][ItemID]))
				{
					AddEquip(playerid, WalkerLootItems[j][i][ItemID], MOD_CLEAR);
					if(item[Grade] >= GRADE_C)
					{
						format(string, sizeof(string), "{%s}%s {ffffff}приобрел {%s}[%s]{ffffff}.", 
							GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name], GetGradeColor(item[Grade]), item[Name]
						);
						SendClientMessageToAll(0xFFFFFFFF, string);
					}
				}
				else
					AddItem(playerid, WalkerLootItems[j][i][ItemID], WalkerLootItems[j][i][Count]);
				
				format(string, sizeof(string), "Подобрано: {%s}[%s] {ffffff}x%d.", 
					GetGradeColor(item[Grade]), item[Name], WalkerLootItems[j][i][Count]
				);
				SendClientMessage(playerid, 0xFFFFFFFF, string);

				WalkerLootItems[j][i][ItemID] = -1;
				WalkerLootItems[j][i][Count] = 0;
				WalkerLootItems[j][i][OwnerID] = -1;
				WalkerLootPickups[j][i] = 0;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не имеете прав на этот предмет.");
				break;
			}
		}
	}
	for(new j = 0; j < MAX_PLAYERS; j++)
	{
		if(!IsPlayerConnected(j) || (!IsDungeonBoss[j] && !IsDungeonMob[j])) continue;
		for(new i = 0; i < MAX_DUNGEON_LOOT; i++)
		{
			if(pickupid != DungeonLootPickups[j][i]) continue;
			if(IsInventoryFull(playerid))
			{
				SendClientMessage(playerid, COLOR_GREY, "Инвентарь полон.");
				continue;
			}
			SafeDestroyPickup(DungeonLootPickups[j][i]);
			if(DungeonLootItems[j][i][ItemID] == -1) continue;

			new string[255];
			new item[BaseItem];
			item = GetItem(DungeonLootItems[j][i][ItemID]);

			if(IsEquip(DungeonLootItems[j][i][ItemID]))
			{
				AddEquip(playerid, DungeonLootItems[j][i][ItemID], MOD_CLEAR);
				if(item[Grade] >= GRADE_C)
				{
					format(string, sizeof(string), "{%s}%s {ffffff}приобрел {%s}[%s]{ffffff}.", 
						GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name], GetGradeColor(item[Grade]), item[Name]
					);
					SendClientMessageToAll(0xFFFFFFFF, string);
				}
			}
			else
				AddItem(playerid, DungeonLootItems[j][i][ItemID], DungeonLootItems[j][i][Count]);
			
			format(string, sizeof(string), "Подобрано: {%s}[%s] {ffffff}x%d.", 
				GetGradeColor(item[Grade]), item[Name], DungeonLootItems[j][i][Count]
			);
			SendClientMessage(playerid, 0xFFFFFFFF, string);

			DungeonLootItems[j][i][ItemID] = -1;
			DungeonLootItems[j][i][Count] = 0;
			DungeonLootItems[j][i][OwnerID] = -1;
			DungeonLootPickups[j][i] = 0;
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & 1024) SelectTextDraw(playerid,0xCCCCFF65);
	else if(newkeys & 65536)
	{
		if(IsTourStarted && IsTourParticipant(PlayerInfo[playerid][ID]))
		{
			new cooldown = GetPVarInt(playerid, "CooperateCooldown");
			if(cooldown <= 0)
				CooperateTeammatesWithPlayer(playerid);
			else
			{
				new str[64];
				format(str, sizeof(str), "Повторите попытку через %d сек.", cooldown);
				SendClientMessage(playerid, COLOR_GREY, str);
			}
		}
	}
	else if(newkeys & 16)
	{
		//special ability
		if(IsTourStarted && IsTourParticipant(PlayerInfo[playerid][ID]))
		{
			if(IsDeath[playerid])
				return 1;

			if(PlayerInfo[playerid][Status] == HIERARCHY_NONE)
			{
				SendClientMessage(playerid, COLOR_GREY, "Вы не состоите в Иерархии.");
				return 1;
			}

			new sp_ab_cooldown = GetPVarInt(playerid, "SpecialAbilityCooldown");
			if(sp_ab_cooldown > 0)
			{
				new str[64];
				format(str, sizeof(str), "Повторите попытку через %d сек.", sp_ab_cooldown);
				SendClientMessage(playerid, COLOR_GREY, str);
			}
			else
				TryUseSpecialAbility(playerid, 100);
			
			return 1;
		}

		//буржуа
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 221.0985,-1838.1259,3.6268))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			ShowCmbWindow(playerid);
		}
		//коллекционер
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 218.1786,-1835.7053,3.7114))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			ShowPlayerDialog(playerid, 920, DIALOG_STYLE_MSGBOX, "Коллекционер", "Вы уверены, что хотите продать весь хлам?", "Продать", "Закрыть");
		}
		//рынок
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, 231.7, -1840.6, 2.5))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			ShowMarketMenu(playerid);
		}
		//почта
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 211.7733,-1838.2538,3.6687))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			ShowPlayerPost(playerid);
		}
		//заведующий турнирами
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 226.7674,-1837.6835,3.6120))
		{
			new listitems[] = "Информация о турнире\nТурнирная таблица\nУчастники следующего тура\nСимуляция автопрокачки\nПодать сигнал готовности";
			ShowPlayerDialog(playerid, 200, DIALOG_STYLE_TABLIST, "Заведующий турнирами", listitems, "Далее", "Закрыть");
		}
		//доска почета
		else if(IsPlayerInRangeOfPoint(playerid,1.2,-2171.3132,645.5896,1052.3817)) 
		{
			new listitems[] = "Иерархия\nОбщий рейтинг участников\nРейтинг моих участников";
			ShowPlayerDialog(playerid, 300, DIALOG_STYLE_TABLIST, "Доска почета", listitems, "Далее", "Закрыть");
		}
		//оружейник
		else if(IsPlayerInRangeOfPoint(playerid,1.8,189.2644,-1825.4902,4.1411))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			new listitems[2048];
			listitems = GetWeaponSellerItemsList();
			ShowPlayerDialog(playerid, 500, DIALOG_STYLE_TABLIST_HEADERS, "Оружейник", listitems, "Купить", "Закрыть");
		}
		//портной
		else if(IsPlayerInRangeOfPoint(playerid,1.8,262.6658,-1825.2792,3.9126))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			new listitems[2048];
			listitems = GetArmorSellerItemsList();
			ShowPlayerDialog(playerid, 600, DIALOG_STYLE_TABLIST_HEADERS, "Портной", listitems, "Купить", "Закрыть");
		}
		//расходники
		else if(IsPlayerInRangeOfPoint(playerid,1.8,-2166.7527,646.0400,1052.3750))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			new listitems[2048];
			listitems = GetMaterialsSellerItemsList(playerid);
			ShowPlayerDialog(playerid, 700, DIALOG_STYLE_TABLIST_HEADERS, "Торговец расходниками", listitems, "Купить", "Закрыть");
		}
		//новогодний Шажок
		/*else if(IsPlayerInRangeOfPoint(playerid,1.8,198.3415,-1854.9188,3.2889))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			new listitems[2048];
			listitems = GetNYShazokItemsList();
			ShowPlayerDialog(playerid, 710, DIALOG_STYLE_TABLIST_HEADERS, "Новогодний Шажок", listitems, "Купить", "Закрыть");
		}*/
		//поставщик
		else if(IsPlayerInRangeOfPoint(playerid,1.8,237.1899,-1827.0797,3.8839))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			new listitems[2048];
			listitems = GetKeysSellerItemsList();
			ShowPlayerDialog(playerid, 720, DIALOG_STYLE_TABLIST_HEADERS, "Поставщик территории войны", listitems, "Купить", "Закрыть");
		}
		//данжи
		else if(IsPlayerInRangeOfPoint(playerid, 1.8, 243.0740,-1824.2559,4.1772))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			if(Tournament[Phase] != PHASE_PEACE)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Территория войны", "Территория войны недоступна во время этой фазы.", "Закрыть", "");
				return 1;
			}

			new listitems[2048];
			listitems = GetAvailableDungeonsList(playerid);
			if(strlen(listitems) == 0)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Территория войны", "Нет доступных территорий войны.", "Закрыть", "");
				return 1;
			}

			ShowPlayerDialog(playerid, 810, DIALOG_STYLE_TABLIST_HEADERS, "Территория войны", listitems, "Войти", "Закрыть");
		}
		//возврат из данжа
		else if(IsPlayerInRangeOfPoint(playerid, 1.8, -66.2243,1516.9169,12.9772))
		{
			ShowPlayerDialog(playerid, 1200, DIALOG_STYLE_MSGBOX, "Территория войны", "Покинуть территорию войны?", "Да", "Закрыть");
		}
		//боссы
		else if(IsPlayerInRangeOfPoint(playerid,1.8,243.1539,-1831.6542,3.9772))
		{
			if(PlayerInfo[playerid][IsWatcher] != 0)
			{
				SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
				return 1;
			}

			if(Tournament[Phase] == PHASE_WAR)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Боссы", "Сражения с боссами недоступны во время фазы войны.", "Закрыть", "");
				return 1;
			}
			if(BossNPC != -1)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Боссы", "Сражение уже идет.", "Закрыть", "");
				return 1;
			}
			new listitems[1024];
			listitems = GetBossesList();
			ShowPlayerDialog(playerid, 800, DIALOG_STYLE_TABLIST_HEADERS, "Боссы", listitems, "Атака", "Закрыть");
		}
		//арена
		else if(IsPlayerInRangeOfPoint(playerid,1.8,204.7617,-1831.6539,4.1772))
		{
			if(Tournament[Phase] == PHASE_PEACE)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Арена", "Сражения на арене недоступны во время фазы мира.", "Закрыть", "");
				return 1;
			}
			if(IsTourStarted)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Арена", "Сражение уже идет.", "Закрыть", "");
				return 1;
			}
			if(!IsAnyPlayersInRangeOfPoint(MAX_OWNERS,3.0,204.7617,-1831.6539,4.1772))
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Арена", "Не все участники находятся рядом.", "Закрыть", "");
				return 1;
			}
			if(!FillTourPlayers())
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Арена", "Некоторые участники не участвуют в этом туре.", "Закрыть", "");
				return 1;
			}
			StartTour();
		}
	}
	else if(newkeys & 131072)
	{
		if(IsTourStarted) return 1;
		ShowMainMenu(playerid);
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	//1 - пустой
	//100-102 - регистрация/авторизация
	//103 - выбор перса
    //200 - симуляция прокачки
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
				format(query, sizeof(query), "INSERT INTO `accounts`(`pass`, `admin`, `teamcolor`, `login`) VALUES ('%s','%d','%d','%s')", 
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
						if(PlayerInfo[playerid][IsWatcher] != 0)
						{
							SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
							return 1;
						}

						if(PlayerInfo[playerid][Simulations] == 0)
						{
							SendClientMessage(playerid, COLOR_LIGHTRED, "Для этого участника симуляция сейчас недоступна.");
							return 1;
						}

						new rank = PlayerInfo[playerid][Rank];
						for(new i = 0; i < MAX_WALKERS; i++)
						{
							rank = PlayerInfo[playerid][Rank] - 1 + random(4);
							if(rank < PlayerInfo[playerid][Rank]) rank = PlayerInfo[playerid][Rank];
							if(rank > MAX_RANK) rank = MAX_RANK;

							for(new j = 0; j < MAX_WALKER_LOOT; j++)
							{
								new w_loot[LootInfo];
								w_loot = RollWalkerLootItem(rank, playerid);
								if(w_loot[ItemID] == -1) continue;
								
								if(IsInventoryFull(playerid))
								{
									if(IsEquip(w_loot[ItemID]))
										PendingItem(PlayerInfo[playerid][Name], w_loot[ItemID], MOD_CLEAR, w_loot[Count], "Награда симуляции");
									continue;
								}

								if(IsEquip(w_loot[ItemID]))
									AddEquip(playerid, w_loot[ItemID], MOD_CLEAR);
								else
									AddItem(playerid, w_loot[ItemID], w_loot[Count]);
							}
						}

						PlayerInfo[playerid][Simulations]--;
						SendClientMessage(playerid, COLOR_GREEN, "Симуляция завершена, награды выданы.");

						new str[128];
						format(str, sizeof(str), "Осталось попыток: %d.", PlayerInfo[playerid][Simulations]);
						SendClientMessage(playerid, COLOR_YELLOW, str);
					}
					case 4:
					{
						if(Tournament[Phase] == PHASE_WAR)
						{
							SendClientMessage(playerid, COLOR_GREY, "Фаза войны уже идет.");
							return 1;
						}
						for(new i = 0; i < MAX_OWNERS; i++)
						{
							if(ReadyIDs[i] == playerid)
							{
								SendClientMessage(playerid, COLOR_GREY, "Вы уже подали сигнал.");
								return 1;
							}
							if(ReadyIDs[i] == -1)
							{
								ReadyIDs[i] = playerid;
								new name[255];
								new string[255];
								GetPlayerName(playerid, name, sizeof(name));
								format(string, sizeof(string), "%s подал(а) сигнал о готовности к фазе войны.", name);
								SendClientMessageToAll(COLOR_LIGHTRED, string);
								break;
							}
						}
						for(new i = 0; i < MAX_OWNERS; i++)
							if(ReadyIDs[i] == -1) return 1;
						SendClientMessageToAll(COLOR_LIGHTRED, "Начинается фаза войны!");
						Tournament[Phase] = PHASE_WAR;
						OnPhaseChanged(PHASE_PEACE, PHASE_WAR);
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
				new listitems[] = "Информация о турнире\nТурнирная таблица\nУчастники следующего тура\nСимуляция автопрокачки\nПодать сигнал готовности";
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
						ShowHierarchy(playerid);
					}
					case 1:
					{
						ShowGlobalRatingTop(playerid);
					}
					case 2:
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
						format(string, sizeof(string), "{ffffff}Вы выбросили: [{%s}%s{ffffff}].", GetGradeColor(item[Grade]), item[Name]);
						ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", string, "Закрыть", "");
					}
				}
				else
				{
					new string[255];
					format(string, sizeof(string), "Сколько предметов выбросить?\nВ наличии - %d.", PlayerInventory[playerid][SelectedSlot[playerid]][Count]);
					ShowPlayerDialog(playerid, 402, DIALOG_STYLE_INPUT, "Инвентарь", string, "Выбросить", "Отменить");
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
						new price = item[Price] / 7;
						price -= price / 99;
						new string[255];
						format(string, sizeof(string), "{ffffff}Вы продали: [{%s}%s{ffffff}].\n{66CC00}Получено: %s$.", GetGradeColor(item[Grade]), item[Name], FormatMoney(price));
						ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", string, "Закрыть", "");
					}
				}
				else
				{
					new string[255];
					format(string, sizeof(string), "Сколько предметов продать?\nВ наличии - %d.\nОставьте поле пустым, чтобы продать всё.", PlayerInventory[playerid][SelectedSlot[playerid]][Count]);
					ShowPlayerDialog(playerid, 403, DIALOG_STYLE_INPUT, "Инвентарь", string, "Продать", "Отменить");
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
				if(count == 0)
					count = PlayerInventory[playerid][SelectedSlot[playerid]][Count];
				if(count <= 0 || count > PlayerInventory[playerid][SelectedSlot[playerid]][Count])
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Неверное количество.", "Закрыть", "");
					return 0;
				}

				DeleteItem(playerid, SelectedSlot[playerid], count);
				
				new string[255];
				format(string, sizeof(string), "{ffffff}Вы выбросили: [{%s}%s{ffffff}] (x%d).", GetGradeColor(item[Grade]), item[Name], count);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", string, "Закрыть", "");
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
				if(count == 0)
					count = PlayerInventory[playerid][SelectedSlot[playerid]][Count];
				if(count < 0 || count > PlayerInventory[playerid][SelectedSlot[playerid]][Count])
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Неверное количество.", "Закрыть", "");
					return 0;
				}

				SellItem(playerid, SelectedSlot[playerid], count);
				
				new string[255];
				new price = (item[Price] * count) / 5;	
				format(string, sizeof(string), "{ffffff}Вы продали: [{%s}%s{ffffff}] (x%d).\n{66CC00}Получено: %s$.", GetGradeColor(item[Grade]), item[Name], count, FormatMoney(price));
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", string, "Закрыть", "");
			}
			return 1;
		}

		//оружейник
		case 500:
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
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				cache_get_value_name_int(0, "ItemID", itemid);
				cache_delete(q_result);

				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}
				SetPVarInt(playerid, "BuyedItemID", itemid);

				new item[BaseItem];
				item = GetItem(itemid);

				if(PlayerInfo[playerid][Cash] < item[Price])
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Недостаточно денег.", "Закрыть", "");
					return 0;
				}

				new text[255];
				format(text, sizeof(text), "{ffffff}[{%s}%s{ffffff}] - купить?", GetGradeColor(item[Grade]), item[Name]);
				ShowPlayerDialog(playerid, 501, DIALOG_STYLE_MSGBOX, "Подтверждение", text, "ОК", "Отмена");
			}	
			return 1;
		}
		case 501:
		{
			if(response)
			{
				if(IsInventoryFull(playerid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
					return 0;
				}
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				new item[BaseItem];
				item = GetItem(itemid);
				PlayerInfo[playerid][Cash] -= item[Price];
				GivePlayerMoney(playerid, -item[Price]);
				AddEquip(playerid, itemid, MOD_CLEAR);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Покупка", "{66CC00}Предмет куплен.", "Закрыть", "");
			}
			return 1;
		}
		//портной
		case 600:
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
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				cache_get_value_name_int(0, "ItemID", itemid);
				cache_delete(q_result);

				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}
				SetPVarInt(playerid, "BuyedItemID", itemid);

				new item[BaseItem];
				item = GetItem(itemid);

				if(PlayerInfo[playerid][Cash] < item[Price])
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Недостаточно денег.", "Закрыть", "");
					return 0;
				}

				new text[255];
				format(text, sizeof(text), "{ffffff}[{%s}%s{ffffff}] - купить?", GetGradeColor(item[Grade]), item[Name]);
				ShowPlayerDialog(playerid, 601, DIALOG_STYLE_MSGBOX, "Подтверждение", text, "ОК", "Отмена");
			}	
			return 1;
		}
		case 601:
		{
			if(response)
			{
				if(IsInventoryFull(playerid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
					return 0;
				}
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				new item[BaseItem];
				item = GetItem(itemid);
				PlayerInfo[playerid][Cash] -= item[Price];
				GivePlayerMoney(playerid, -item[Price]);
				AddEquip(playerid, itemid, MOD_CLEAR);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Покупка", "{66CC00}Предмет куплен.", "Закрыть", "");
			}
			return 1;
		}
		//расходники
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
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				cache_get_value_name_int(0, "ItemID", itemid);
				cache_delete(q_result);

				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				new item[BaseItem];
				item = GetItem(itemid);
				
				if(item[Type] == ITEMTYPE_PASSIVE && HasItem(playerid, itemid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "У вас уже есть этот предмет.", "Закрыть", "");
					return 0;
				}

				SetPVarInt(playerid, "BuyedItemID", itemid);

				new available_count = PlayerInfo[playerid][Cash] / item[Price];
				if(item[Type] == ITEMTYPE_PASSIVE)
					available_count = available_count >= 1 ? 1 : 0;

				new text[255];
				format(text, sizeof(text), "Укажите количество.\nВы можете купить: %d", available_count);
				ShowPlayerDialog(playerid, 701, DIALOG_STYLE_INPUT, "Покупка", text, "Купить", "Отмена");
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
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				new count = strval(inputtext);
				if(count <= 0)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Неверное количество.", "Закрыть", "");
					return 0;
				}

				new item[BaseItem];
				item = GetItem(itemid);

				if(item[Type] == ITEMTYPE_PASSIVE && count > 1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Можно иметь только один предмет.", "Закрыть", "");
					return 0;
				}

				if((itemid != 281 && PlayerInfo[playerid][Cash] < item[Price] * count) || 
				   (itemid == 280 && PlayerInfo[playerid][Cash] < (item[Price] + 4000 * PlayerInfo[playerid][Rank] * PlayerInfo[playerid][Rank]) * count) ||
				   (itemid == 281 && PlayerInfo[playerid][Cash] < (item[Price] + 2000 * PlayerInfo[playerid][Rank] * PlayerInfo[playerid][Rank]) * count))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Недостаточно денег.", "Закрыть", "");
					return 0;
				}

				SetPVarInt(playerid, "BuyedItemCount", count);

				new text[255];
				format(text, sizeof(text), "{ffffff}[{%s}%s{ffffff}] x%d - купить?", GetGradeColor(item[Grade]), item[Name], count);
				ShowPlayerDialog(playerid, 702, DIALOG_STYLE_MSGBOX, "Подтверждение", text, "ОК", "Отмена");
			}	
			return 1;
		}
		case 702:
		{
			if(response)
			{
				if(IsInventoryFull(playerid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
					return 0;
				}
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				new count = GetPVarInt(playerid, "BuyedItemCount");
				new item[BaseItem];
				item = GetItem(itemid);

				new price = 0;
				if(itemid == 280)
					price = (item[Price] + 4000 * PlayerInfo[playerid][Rank] * PlayerInfo[playerid][Rank]) * count;
				else if(itemid == 281)
					price = (item[Price] + 2000 * PlayerInfo[playerid][Rank] * PlayerInfo[playerid][Rank]) * count;
				else
					price = item[Price] * count;

				PlayerInfo[playerid][Cash] -= price;
				GivePlayerMoney(playerid, -price);

				AddItem(playerid, itemid, count);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Покупка", "{66CC00}Предмет куплен.", "Закрыть", "");

				if(item[Type] == ITEMTYPE_PASSIVE)
					UpdatePlayerStats(playerid);
			}
			return 1;
		}
		//новогодий Шажок
		/*case 710:
		{
			if(response)
			{
				new itemid = -1;
				new price = 0;

				new query[255];
				format(query, sizeof(query), "SELECT * FROM `ny_shazok_seller` WHERE `ID` = '%d' LIMIT 1", listitem);
				new Cache:q_result = mysql_query(sql_handle, query);

				new row_count = 0;
				cache_get_row_count(row_count);
				if(row_count <= 0)
				{
					cache_delete(q_result);
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				cache_get_value_name_int(0, "ItemID", itemid);
				cache_get_value_name_int(0, "Price", price);
				cache_delete(q_result);

				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				new item[BaseItem];
				item = GetItem(itemid);
				
				if(item[Type] == ITEMTYPE_PASSIVE && HasItem(playerid, itemid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "У вас уже есть этот предмет.", "Закрыть", "");
					return 0;
				}

				SetPVarInt(playerid, "BuyedItemID", itemid);
				SetPVarInt(playerid, "BuyedItemPrice", price);

				new player_noses = GetItemsCount(playerid, 370);
				new available_count = player_noses / price;
				if(item[Type] == ITEMTYPE_PASSIVE)
					available_count = available_count >= 1 ? 1 : 0;

				new text[255];
				format(text, sizeof(text), "Укажите количество.\nВы можете купить: %d", available_count);
				ShowPlayerDialog(playerid, 711, DIALOG_STYLE_INPUT, "Покупка", text, "Купить", "Отмена");
			}	
			return 1;
		}
		case 711:
		{
			if(response)
			{
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				new price = GetPVarInt(playerid, "BuyedItemPrice");
				new count = strval(inputtext);
				if(count <= 0)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Неверное количество.", "Закрыть", "");
					return 0;
				}

				new item[BaseItem];
				item = GetItem(itemid);

				if(item[Type] == ITEMTYPE_PASSIVE && count > 1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Можно иметь только один предмет.", "Закрыть", "");
					return 0;
				}

				new player_noses = GetItemsCount(playerid, 370);
				if(player_noses < price * count)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Недостаточно носов.", "Закрыть", "");
					return 0;
				}

				SetPVarInt(playerid, "BuyedItemCount", count);

				new text[255];
				format(text, sizeof(text), "{ffffff}[{%s}%s{ffffff}] x%d - купить?", GetGradeColor(item[Grade]), item[Name], count);
				ShowPlayerDialog(playerid, 712, DIALOG_STYLE_MSGBOX, "Подтверждение", text, "ОК", "Отмена");
			}	
			return 1;
		}
		case 712:
		{
			if(response)
			{
				if(IsInventoryFull(playerid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
					return 0;
				}
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				new count = GetPVarInt(playerid, "BuyedItemCount");
				new item[BaseItem];
				item = GetItem(itemid);

				new price = GetPVarInt(playerid, "BuyedItemPrice") * count;
				new noses_slot = FindItem(playerid, 370);

				DeleteItem(playerid, noses_slot, price);

				AddItem(playerid, itemid, count);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Покупка", "{66CC00}Предмет куплен.", "Закрыть", "");

				if(item[Type] == ITEMTYPE_PASSIVE)
					UpdatePlayerStats(playerid);
			}
			return 1;
		}*/
		//поставщик
		case 720:
		{
			if(response)
			{
				new itemid = -1;
				new price = 0;

				new query[255];
				format(query, sizeof(query), "SELECT * FROM `keys_seller` WHERE `ID` = '%d' LIMIT 1", listitem);
				new Cache:q_result = mysql_query(sql_handle, query);

				new row_count = 0;
				cache_get_row_count(row_count);
				if(row_count <= 0)
				{
					cache_delete(q_result);
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				cache_get_value_name_int(0, "ItemID", itemid);
				cache_get_value_name_int(0, "Price", price);
				cache_delete(q_result);

				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				new item[BaseItem];
				item = GetItem(itemid);
				SetPVarInt(playerid, "BuyedItemID", itemid);

				new available_count = PlayerInfo[playerid][Cash] / price;

				new text[255];
				format(text, sizeof(text), "Укажите количество.\nВы можете купить: %d", available_count);
				ShowPlayerDialog(playerid, 721, DIALOG_STYLE_INPUT, "Покупка", text, "Купить", "Отмена");
			}	
			return 1;
		}
		case 721:
		{
			if(response)
			{
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				if(itemid == -1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				new price = 0;
				new query[255];
				format(query, sizeof(query), "SELECT * FROM `keys_seller` WHERE `ItemID` = '%d' LIMIT 1", itemid);
				new Cache:q_result = mysql_query(sql_handle, query);

				new row_count = 0;
				cache_get_row_count(row_count);
				if(row_count <= 0)
				{
					cache_delete(q_result);
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Не удалось купить предмет.", "Закрыть", "");
					return 0;
				}

				cache_get_value_name_int(0, "Price", price);
				cache_delete(q_result);

				new count = strval(inputtext);
				if(count <= 0)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Неверное количество.", "Закрыть", "");
					return 0;
				}

				new item[BaseItem];
				item = GetItem(itemid);

				if(PlayerInfo[playerid][Cash] < price * count)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Недостаточно денег.", "Закрыть", "");
					return 0;
				}

				SetPVarInt(playerid, "BuyedItemCount", count);
				SetPVarInt(playerid, "BuyedItemPrice", price * count);

				new text[255];
				format(text, sizeof(text), "{ffffff}[{%s}%s{ffffff}] x%d - купить?", GetGradeColor(item[Grade]), item[Name], count);
				ShowPlayerDialog(playerid, 722, DIALOG_STYLE_MSGBOX, "Подтверждение", text, "ОК", "Отмена");
			}	
			return 1;
		}
		case 722:
		{
			if(response)
			{
				if(IsInventoryFull(playerid))
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
					return 0;
				}
				new itemid = GetPVarInt(playerid, "BuyedItemID");
				new count = GetPVarInt(playerid, "BuyedItemCount");
				new price = GetPVarInt(playerid, "BuyedItemPrice");
				new item[BaseItem];
				item = GetItem(itemid);

				PlayerInfo[playerid][Cash] -= price;
				GivePlayerMoney(playerid, -price);

				AddItem(playerid, itemid, count);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Покупка", "{66CC00}Предмет куплен.", "Закрыть", "");
			}
			return 1;
		}
		//боссы
		case 800:
		{
			if(response)
			{
				if(AttackedBoss != -1 && listitem != AttackedBoss)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Боссы", "На одного из боссов уже идет атака.", "Закрыть", "");
					return 0;
				}

				new bossid = listitem;
				new boss[BossInfo];
				boss = GetBoss(bossid);

				if(boss[RespawnTime] > 0)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Боссы", "Этот босс еще не появился.", "Закрыть", "");
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
					format(msg, sizeof(msg), "Появляется %s!", boss[Name]);
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
				format(msg, sizeof(msg), "%s начал атаку на %s!", name, boss[Name]);
				SendClientMessageToAll(0x990099FF, msg);
			}
			return 1;
		}
		//данжи
		case 810:
		{
			if(response)
			{
				if(AvailableDungeons[playerid][listitem] != -1)
					EnterToDungeon(playerid, AvailableDungeons[playerid][listitem]);
				else
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Ошибка получения списка территорий.", "Закрыть", "");
					return 1;
				}
			}
		}
		//почта
		case 900:
		{
			if(response)
			{
				ClaimMail(playerid, listitem);
			}
		}

		//комбинации
		case 910:
		{
			if(response)
			{
				new cmbitem = GetPVarInt(playerid, "CmbItemID");
				new cmbslot = GetPVarInt(playerid, "CmbItemSlot");
				new cmbinvslot = GetPVarInt(playerid, "CmbItemInvSlot");
				new have_count = GetPVarInt(playerid, "CmbItemCount");

				if(cmbitem == -1) return 1;
				if(cmbslot < 1 || cmbslot > 3) return 1;

				new item[BaseItem];
				item = GetItem(cmbitem);
				
				new count = strval(inputtext);
				if(count < 1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Неверное количество.", "Закрыть", "");
					return 1;
				}
				if(count > have_count)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Недостаточно предметов.", "Закрыть", "");
					return 1;
				}

				SetCmbItem(playerid, cmbslot, cmbinvslot, cmbitem, count);
			}
		}

		//коллекционер
		case 920:
		{
			if(response)
			{
				SellAllUselessItems(playerid);
			}
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
                    case 2:
					{
						SwitchToWatcher(playerid);
					}
					case 3:
					{
						if(IsTourStarted || IsBossAttacker[playerid] || IsPlayerInDungeon(playerid))
						{
							SendClientMessage(playerid, COLOR_GREY, "Быстрое перемещение сейчас недоступно.");
							return 0;
						}

						new cooldown = GetPVarInt(playerid, "TeleportCooldown");
						if(cooldown <= 0 || PlayerInfo[playerid][IsWatcher] != 0)
						{
							new listitems[] = "Вход в дом\nОружейник\nПортной\nТорговец расходниками\nДоска почета\nГостиная\nБуржуа\nЗаведующий турнирами\nВход на арену\nПроход к боссам";
							ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_TABLIST, "Быстрое перемещение", listitems, "Выбрать", "Назад");
						}
						else
						{
							new string[255];
							format(string, sizeof(string), "Повторите попытку через %d сек.", cooldown);
							SendClientMessage(playerid, COLOR_GREY, string);
							ShowMainMenu(playerid);
						}
					}
				}
			}
			else
				return 0;
			return 1;
		}

		//быстрое перемещение
		case 1001:
		{
			if(response)
			{
				TeleportToHome(playerid);
				switch(listitem)
				{			
					case 0:
					{
						//do nothing
					}
					case 1:
					{
						SetPlayerPos(playerid, 189.3021,-1826.8640,4.1014);
						SetPlayerFacingAngle(playerid, 2);
						SetPlayerInterior(playerid, 0);
					}
					case 2:
					{
						SetPlayerPos(playerid, 262.7971,-1826.9108,3.8658);
						SetPlayerFacingAngle(playerid, 3);
						SetPlayerInterior(playerid, 0);
					}
					case 3:
					{
						SetPlayerPos(playerid, -2166.6460,644.8119,1052.3750);
						SetPlayerFacingAngle(playerid, 5);
						SetPlayerInterior(playerid, 1);
					}
					case 4:
					{
						SetPlayerPos(playerid, -2170.8745,645.5780,1052.3750);
						SetPlayerFacingAngle(playerid, 92);
						SetPlayerInterior(playerid, 1);
					}
					case 5:
					{
						SetPlayerPos(playerid, -2166.5366,642.6519,1057.5938);
						SetPlayerFacingAngle(playerid, 270);
						SetPlayerInterior(playerid, 1);
					}
					case 6:
					{
						SetPlayerPos(playerid, 221.1456,-1839.6755,3.5815);
						SetPlayerFacingAngle(playerid, 2);
						SetPlayerInterior(playerid, 0);
					}
					case 7:
					{
						SetPlayerPos(playerid, 226.8728,-1839.7069,3.5527);
						SetPlayerFacingAngle(playerid, 2);
						SetPlayerInterior(playerid, 0);
					}
					case 8:
					{
						SetPlayerPos(playerid, 204.8678,-1833.2555,3.8560);
						SetPlayerFacingAngle(playerid, 2);
						SetPlayerInterior(playerid, 0);
					}
					case 9:
					{
						SetPlayerPos(playerid, 243.1952,-1832.9827,3.6996);
						SetPlayerFacingAngle(playerid, 0);
						SetPlayerInterior(playerid, 0);
					}
				}
				
				SetCameraBehindPlayer(playerid);
				SetPVarInt(playerid, "TeleportCooldown", 60);
			}
			else
				ShowMainMenu(playerid);
		}

		//создание наблюдателя
		case 1002:
		{
			if(response)
			{
				if(CreateWatcher(AccountLogin[playerid]))
				{
					SendClientMessage(playerid, COLOR_GREEN, "Наблюдатель создан успешно. Переключение...");
					SwitchToWatcher(playerid);
				}
				else
					SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка при создании наблюдателя.");
			}
			else
				return 1;
		}

		//рынок
		case 1100:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:	ShowPlayerDialog(playerid, 1103, DIALOG_STYLE_TABLIST, "Рынок", "Оружие\nДоспехи\nГоловные уборы\nОчки\nЧасы\nБижутерия\nРасходные материалы", "Далее", "Назад");
					case 1:	ShowMarketSellWindow(playerid);
					case 2:	ShowMarketMyLotList(playerid);
				}
			}
		}
		case 1101:
		{
			if(response)
			{
				new category = GetPVarInt(playerid, "MarketBuyCategory");
				if(category == MARKET_CATEGORY_MATERIAL)
				{
					SetPVarInt(playerid, "MarketBuyItemID", listitem);
					ShowPlayerDialog(playerid, 1104, DIALOG_STYLE_INPUT, "Рынок", "Введите количество:", "Купить", "Отмена");
				}
				else
				{
					new item[MarketItem];
					item = GetMarketItem(listitem, category);

					if(PlayerInfo[playerid][Cash] < item[Price])
					{
						SendClientMessage(playerid, COLOR_GREY, "Недостаточно денег.");
						ShowMarketBuyList(playerid, category);
						return 1;
					}

					if(IsInventoryFull(playerid))
					{
						SendClientMessage(playerid, COLOR_GREY, "Инвентарь полон.");
						ShowMarketBuyList(playerid, category);
						return 1;
					}

					BuyItem(playerid, item[LotID]);
				}
			}
			else
				ShowPlayerDialog(playerid, 1103, DIALOG_STYLE_TABLIST, "Рынок", "Оружие\nДоспехи\nГоловные уборы\nОчки\nЧасы\nБижутерия\nРасходные материалы", "Далее", "Назад");
		}
		case 1102:
		{
			if(response)
				CancelItem(playerid, listitem);
			else
				ShowMarketMenu(playerid);
		}
		case 1103:
		{
			if(response)
			{
				SetPVarInt(playerid, "MarketBuyCategory", listitem);
				ShowMarketBuyList(playerid, listitem);
			}
			else
				ShowMarketMenu(playerid);
		}
		case 1104:
		{
			new category = GetPVarInt(playerid, "MarketBuyCategory");
			if(response)
			{
				new item[MarketItem];
				new id = GetPVarInt(playerid, "MarketBuyItemID");
				if(id < 0)
				{
					print("Cannot buy item.");
					return 1;
				}

				item = GetMarketItem(id, category);

				new count = strval(inputtext);
				if(count < 1 || count > item[Count])
				{
					SendClientMessage(playerid, COLOR_GREY, "Неверное количество.");
					ShowMarketBuyList(playerid, category);
					return 1;
				}

				new amount = item[Price] * count;
				if(amount > PlayerInfo[playerid][Cash])
				{
					SendClientMessage(playerid, COLOR_GREY, "Недостаточно денег.");
					ShowMarketBuyList(playerid, category);
					return 1;
				}

				if(IsInventoryFull(playerid))
				{
					SendClientMessage(playerid, COLOR_GREY, "Инвентарь полон.");
					ShowMarketBuyList(playerid, category);
					return 1;
				}

				BuyItem(playerid, item[LotID], count);
			}
			else
				ShowMarketBuyList(playerid, category);
		}
		case 1105:
		{
			if(response)
			{
				new count = strval(inputtext);

				if(count < 1)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Неверное значение.", "Закрыть", "");
					return 1;
				}

				if(HasItem(playerid, MarketSellingItem[playerid][ID], count))
				{
					MarketSellingItem[playerid][Count] = count;
					UpdateMarketSellWindow(playerid);
				}
				else
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "У вас нет такого количества предметов.", "Закрыть", "");
					return 1;
				}
			}
		}
		case 1106:
		{
			if(response)
			{
				new price = strval(inputtext);

				if(price < 1 || price > 1000000000)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Неверное значение.", "Закрыть", "");
					return 1;
				}

				MarketSellingItem[playerid][Price] = price;
				UpdateMarketSellWindow(playerid);
			}
		}
		//возврат из данжа
		case 1200:
		{
			if(response)
			{
				if(IsPlayerInDungeon(playerid))
					CompleteDungeon(playerid, false);

				TeleportToHome(playerid);
			}
		}
	}
	return 1;
}

public FCNPC_OnUpdate(npcid)
{
	if(!IsNuclearBombExplodes && !IsTeamHealing)
	{
		new Float:hp;
		hp = GetPVarFloat(npcid, "HP");
		SetPlayerHP(npcid, hp);
	}
	
	if(npcid == BossNPC && !IsTourStarted)
	{
		BossBehaviour(npcid);
		return 1;
	}

	if(IsDungeonMob[npcid] || IsDungeonBoss[npcid])
	{
		DungeonEnemyBehaviour(npcid);
		return 1;
	}

	if(IsWalker[npcid] && !IsTourStarted)
	{
		WalkerBehaviour(npcid);
		return 1;
	}

	if(!IsTourStarted) return 1;

	new lastkill = GetPVarInt(npcid, "LastKill");
	if(lastkill != -1)
	{
		if(FCNPC_IsValid(lastkill) && !FCNPC_IsDead(lastkill))
			SetPVarInt(npcid, "LastKill", -1);
		else if(!IsDeath[lastkill])
			SetPVarInt(npcid, "LastKill", -1);
	}

	ParticipantBehaviour(npcid);

	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(FCNPC_IsValid(playerid)) return 0;
	if(!IsSpawned[playerid]) return 0;

	if(!IsNuclearBombExplodes && !IsTeamHealing)
	{
		new Float:hp;
		hp = GetPVarFloat(playerid, "HP");
		SetPlayerHP(playerid, hp);
	}

	UpdateHPBar(playerid);

	if(IsTourStarted)
	{
		if(PlayerInfo[playerid][IsWatcher] <= 0 && IsValidDynamicArea(arena_area) && !IsPlayerInDynamicArea(playerid, arena_area))
		{
			TeleportToRandomArenaPos(playerid);
			UpdatePlayerVisual(playerid);
		}

		new lastkill = GetPVarInt(playerid, "LastKill");
		if(lastkill != -1)
		{
			if(FCNPC_IsValid(lastkill) && !FCNPC_IsDead(lastkill))
				SetPVarInt(playerid, "LastKill", -1);
			else if(!IsDeath[lastkill])
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
	else if(playertextid == CmbClose[playerid])
	{
		HideCmbWindow(playerid);
	}
	else if(playertextid == CmbBtn[playerid])
	{
		CombineItems(playerid);
	}
	else if(playertextid == MpClose[playerid])
	{
		HideMarketSellWindow(playerid);
	}
	else if(playertextid == MpBtn[playerid])
	{
		new category = GetMarketCategoryByItem(MarketSellingItem[playerid][ID]);
		RegisterMarketItem(playerid, category);
	}
	else if(playertextid == MpBtn1[playerid])
	{
		ShowPlayerDialog(playerid, 1106, DIALOG_STYLE_INPUT, "Рынок", "Введите новое значение:", "Принять", "Закрыть");
	}
	else if(playertextid == MpBtn2[playerid])
	{
		ShowPlayerDialog(playerid, 1105, DIALOG_STYLE_INPUT, "Рынок", "Введите новое значение:", "Принять", "Закрыть");
	}
	else if(playertextid == MpItem[playerid])
	{
		if(SelectedSlot[playerid] == -1) return 0;
		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(itemid == -1) return 0;

		new item[BaseItem];
		item = GetItem(itemid);

		if(item[IsTradeble] == 0)
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Этот предмет нельзя продать.", "Закрыть", "");
			return 0;
		}

		MarketSellingItem[playerid][ID] = itemid;
		for(new i = 0; i < MAX_MOD; i++)
			MarketSellingItem[playerid][Mod][i] = PlayerInventory[playerid][SelectedSlot[playerid]][Mod][i];
		MarketSellingItem[playerid][Count] = 1;
		MarketSellingItem[playerid][Price] = item[Price] / 2;
		MarketSellingItem[playerid][rTime] = 10;
		sscanf(PlayerInfo[playerid][Name], "s[255]", MarketSellingItem[playerid][Owner]);
		MarketSellingItem[playerid][LotID] = GetMarketNextLotID();
		SetPVarInt(playerid, "MarketSellingItemInvSlot", SelectedSlot[playerid]);

		UpdateMarketSellWindow(playerid);
	}
	else if(playertextid == ChrInfWeaponSlot[playerid])
	{
		if(PlayerInfo[playerid][WeaponSlotID] == 0) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
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
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		UndressEquip(playerid, ITEMTYPE_ARMOR);
	}
	else if(playertextid == ChrInfHatSlot[playerid])
	{
		if(PlayerInfo[playerid][HatSlotID] == 136) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		UndressEquip(playerid, ITEMTYPE_HAT);
	}
	else if(playertextid == ChrInfWatchSlot[playerid])
	{
		if(PlayerInfo[playerid][WatchSlotID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		UndressEquip(playerid, ITEMTYPE_WATCH);
	}
	else if(playertextid == ChrInfGlassesSlot[playerid])
	{
		if(PlayerInfo[playerid][ArmorSlotID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		UndressEquip(playerid, ITEMTYPE_GLASSES);
	}
	else if(playertextid == ChrInfRingSlot1[playerid])
	{
		if(PlayerInfo[playerid][RingSlot1ID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][RingSlot1ID], MOD_CLEAR);
		PlayerInfo[playerid][RingSlot1ID] = -1;
		UpdatePlayerStats(playerid);

		if(IsInventoryOpen[playerid])
			UpdateEquipSlots(playerid);
	}
	else if(playertextid == ChrInfRingSlot2[playerid])
	{
		if(PlayerInfo[playerid][RingSlot2ID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][RingSlot2ID], MOD_CLEAR);
		PlayerInfo[playerid][RingSlot2ID] = -1;
		UpdatePlayerStats(playerid);

		if(IsInventoryOpen[playerid])
			UpdateEquipSlots(playerid);
	}
	else if(playertextid == ChrInfAmuletteSlot1[playerid])
	{
		if(PlayerInfo[playerid][AmuletteSlot1ID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][AmuletteSlot1ID], MOD_CLEAR);
		PlayerInfo[playerid][AmuletteSlot1ID] = -1;
		UpdatePlayerStats(playerid);

		if(IsInventoryOpen[playerid])
			UpdateEquipSlots(playerid);
	}
	else if(playertextid == ChrInfAmuletteSlot2[playerid])
	{
		if(PlayerInfo[playerid][AmuletteSlot2ID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][AmuletteSlot2ID], MOD_CLEAR);
		PlayerInfo[playerid][AmuletteSlot2ID] = -1;
		UpdatePlayerStats(playerid);

		if(IsInventoryOpen[playerid])
			UpdateEquipSlots(playerid);
	}
	else if(playertextid == ChrInfNextInvBtn[playerid])
	{
		new page = GetPVarInt(playerid, "InvPage");
		page++;

		if(page < 1)
			page = 1;
		else if(page > MAX_INV_PAGES)
			page = MAX_INV_PAGES;

		if(GetPVarInt(playerid, "InvPage") != page)
		{
			SetPVarInt(playerid, "InvPage", page);
			UpdateInventory(playerid);
		}
	}
	else if(playertextid == ChrInfPrevInvBtn[playerid])
	{
		new page = GetPVarInt(playerid, "InvPage");
		page--;

		if(page < 1)
			page = 1;
		else if(page > MAX_INV_PAGES)
			page = MAX_INV_PAGES;

		if(GetPVarInt(playerid, "InvPage") != page)
		{
			SetPVarInt(playerid, "InvPage", page);
			UpdateInventory(playerid);
		}
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
			if((HasItem(playerid, ITEM_SHAZOK_LETTER_ID, 1) ? PlayerInfo[playerid][Rank] + 1 : PlayerInfo[playerid][Rank]) < equip[MinRank])
			{
				new string[255];
				format(string, sizeof(string), "{ffffff}Ваш ранг не соответствует минимальному для этого предмета.\nМинимальный ранг - {%s}%s", 
					RateColors[equip[MinRank]-1], GetRankInterval(equip[MinRank])
				);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", string, "Закрыть", "");
				return 0;
			}
			if((itemid == 274 || itemid == 276) && PlayerInfo[playerid][Status] != HIERARCHY_LEADER)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", "{ffffff}Данная экипировка доступна только Патриарху.", "Закрыть", "");
				return 0;
			}
			if((itemid == 273 || itemid == 275) && PlayerInfo[playerid][Status] == HIERARCHY_NONE)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", "{ffffff}Данная экипировка доступна только лидерам Цирка.", "Закрыть", "");
				return 0;
			}
			EquipItem(playerid, equip[Type], SelectedSlot[playerid]);
			return 1;
		}
		if(IsLockbox(itemid))
		{
			if(IsInventoryFull(playerid))
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
				return 0;
			}
			DeleteItem(playerid, SelectedSlot[playerid], 1);
			OpenLockbox(playerid, itemid);
		}
	}
	else if(playertextid == ChrInfButSort[playerid])
	{
		if(IsSlotsBlocked[playerid]) return 0;
		SortInventory(playerid);
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
			format(desc, sizeof(desc), "{ffffff}[{%s}%s{ffffff}] - продать?", GetGradeColor(item[Grade]), item[Name]);
			ShowPlayerDialog(playerid, 401, DIALOG_STYLE_MSGBOX, "Инвентарь", desc, "Далее", "Закрыть");
		}
		else
		{
			format(desc, sizeof(desc), "{ffffff}[{%s}%s{ffffff}] - выбросить?", GetGradeColor(item[Grade]), item[Name]);
			ShowPlayerDialog(playerid, 400, DIALOG_STYLE_MSGBOX, "Инвентарь", desc, "Далее", "Закрыть");
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
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "Этот предмет достиг максимального уровня модификации.", "Закрыть", "");
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
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "Этот предмет достиг максимального уровня модификации.", "Закрыть", "");
			return 0;
		}

		ModItemSlot[playerid] = SelectedSlot[playerid];
		ModStone[playerid] = -1;
		ModPotion[playerid] = -1;
		UpdateModWindow(playerid);
	}
	else if(playertextid == UpgStoneSlot[playerid])
	{
		if(ModStone[playerid] != -1)
		{
			ModStone[playerid] = -1;
			UpdateModWindow(playerid);
			return 0;
		}

		if(SelectedSlot[playerid] == -1) return 0;
		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(itemid == -1) return 0;
		if(!IsModStone(itemid)) return 0;
		if(ModItemSlot[playerid] == -1)
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "Не выбран предмет для модификации.", "Закрыть", "");
			return 0;
		}

		new equip[BaseItem];
		equip = GetItem(PlayerInventory[playerid][ModItemSlot[playerid]][ID]);
		if( ((itemid == 282 || itemid == 284) && equip[Type] == ITEMTYPE_WEAPON) ||
			((itemid == 283 || itemid == 285) && equip[Type] == ITEMTYPE_ARMOR) ||
			((itemid == 283 || itemid == 285) && equip[Type] == ITEMTYPE_HAT) ||
			((itemid == 283 || itemid == 284 || itemid == 285) && equip[Type] == ITEMTYPE_GLASSES) || 
			((itemid == 283 || itemid == 284 || itemid == 285) && equip[Type] == ITEMTYPE_WATCH) )
		{
			ModStone[playerid] = itemid;
			UpdateModWindow(playerid);
		}
		else
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "Нельзя использовать этот камень.", "Закрыть", "");
			return 0;
		}
	}
	else if(playertextid == UpgPotionSlot[playerid])
	{
		if(ModPotion[playerid] != -1)
		{
			ModPotion[playerid] = -1;
			UpdateModWindow(playerid);
			return 0;
		}

		if(SelectedSlot[playerid] == -1) return 0;
		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(itemid == -1) return 0;
		if(!IsModPotion(itemid)) return 0;
		if(ModItemSlot[playerid] == -1)
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "Не выбран предмет для модификации.", "Закрыть", "");
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

	if(Windows[playerid][Cmb])
	{
		for(new slotid = 1; slotid <= MAX_CMB_ITEMS; slotid++)
		{
			if(playertextid != CmbItemSlot[playerid][slotid-1]) continue;

			if(SelectedSlot[playerid] == -1) continue;
			new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
			if(itemid == -1) continue;

			SetPVarInt(playerid, "CmbItemID", itemid);
			SetPVarInt(playerid, "CmbItemSlot", slotid);
			SetPVarInt(playerid, "CmbItemInvSlot", SelectedSlot[playerid]);

			if(IsEquip(itemid))
			{
				SetPVarInt(playerid, "CmbItemCount", 1);
				SetCmbItem(playerid, slotid, SelectedSlot[playerid], itemid, 1);
			}
			else
			{
				SetPVarInt(playerid, "CmbItemCount", PlayerInventory[playerid][SelectedSlot[playerid]][Count]);
				ShowPlayerDialog(playerid, 910, DIALOG_STYLE_INPUT, "Комбинирование", "Укажите количество:", "ОК", "Отмена");
			}
		}
	}

	if(IsInventoryOpen[playerid])
	{
		for(new i = 0; i < MAX_PAGE_SLOTS; i++) 
		{
			if(playertextid == ChrInfInvSlot[playerid][i]) 
			{
				new inv_slotid = GetSlotIdByPage(playerid, i);
				if(SelectedSlot[playerid] != -1) 
				{
					if(!IsSlotsBlocked[playerid] && PlayerInventory[playerid][SelectedSlot[playerid]][ID] != -1 && PlayerInventory[playerid][inv_slotid][ID] == -1) 
					{
						PlayerInventory[playerid][inv_slotid] = PlayerInventory[playerid][SelectedSlot[playerid]];
						PlayerInventory[playerid][SelectedSlot[playerid]] = EmptyInvItem;
						new oldslot = SelectedSlot[playerid];
						SelectedSlot[playerid] = -1;
						UpdateSlot(playerid, oldslot);
						UpdateSlot(playerid, inv_slotid);
						break;
					}
					SetSlotSelection(playerid, SelectedSlot[playerid], false);
				}
				SelectedSlot[playerid] = inv_slotid;
				SetSlotSelection(playerid, inv_slotid, true);
				break;
			}
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
	if(minute <= 9)
		format(string, 25, "%d:0%d", hour, minute);
	else
		format(string, 25, "%d:%d", hour, minute);
	TextDrawSetString(WorldTime, string);

	TickSecondGlobal();
	if(minute == 0 && second == 0)
		TickHour();
	if(second == 0)
		TickMinute();
}

stock TryUseHealProp(playerid)
{
	if(IsDeath[playerid]) return;
	if(FCNPC_IsValid(playerid) && FCNPC_IsDead(playerid)) return;

	new prop = GetPlayerPropValue(playerid, PROPERTY_HEAL);
	if(prop <= 0)
		return;
	
	if(!CheckChance(8))
		return;
	
	new Float:hp;
	hp = floatmul(GetPlayerMaxHP(playerid), floatmul(0.1, prop));
	GivePlayerHP(playerid, hp);
}

stock TryUseRegenProp(playerid)
{
	if(IsDeath[playerid]) return;
	if(FCNPC_IsValid(playerid) && FCNPC_IsDead(playerid)) return;

	new prop = GetPlayerPropValue(playerid, PROPERTY_REGEN);
	if(prop <= 0)
		return;
	
	if(!CheckChance(prop * 3))
		return;
	
	new Float:hp = GetPlayerMaxHP(playerid);
	GivePlayerHP(playerid, hp);
}

stock TryUseInvulProp(playerid)
{
	if(IsDeath[playerid]) return;
	if(FCNPC_IsValid(playerid) && FCNPC_IsDead(playerid)) return;

	new prop = GetPlayerPropValue(playerid, PROPERTY_INVUL);
	if(prop <= 0)
		return;
	
	if(!CheckChance(8))
		return;
	
	SetPlayerInvulnearable(playerid, 2 * prop);
}

stock IsAllOwnersConnected()
{
	new connected_owners = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(FCNPC_IsValid(i)) continue;
		if(!PlayerConnect[i]) continue;
		connected_owners++;
	}

	if(connected_owners >= MAX_OWNERS)
		return true;
	return false;
}

stock TryRunSpecialActivity(activityid)
{
	if(Tournament[Phase] != PHASE_PEACE) return;
	if(SpecialActivityDelay > 0) return;
	if(!IsAllOwnersConnected())	return;
	if(AttackedBoss != -1) return;
	if(!CheckChance(5)) return;

	OnSpecialActivityStart(activityid);
}

stock TryUseSpecialAbility(playerid, chance)
{
	if(!IsTourStarted) return;
	if(SpecialAbilityDelay > 0) return;
	if(IsSpecialAbilityUsed) return;
	if(PlayerInfo[playerid][Status] == HIERARCHY_NONE) return;
	if(GetPVarInt(playerid, "SpecialAbilityCooldown") > 0) return;
	if(!CheckChance(chance)) return;

	switch(PlayerInfo[playerid][Status])
	{
		case HIERARCHY_LEADER:
		{
			//растерянность
			new team = GetPlayerTourTeam(playerid);

			IsSpecialAbilityUsed = true;
			SpecialAbilityEffect = SPECIAL_AB_EFFECT_CONFUSION;
			SpecialAbilityEffectTime = 7;
			SpecialAbilityEffectTeam = team;
			ResetAllTeamTargets(team);

			SetPVarInt(playerid, "SpecialAbilityCooldown", 40);

			new string[255];
			format(string, sizeof(string), "{cc0000}[Патриарх] {ffffff}%s использует {cc0000}<Растерянность>", PlayerInfo[playerid][Name]);
			SendClientMessageToAll(COLOR_WHITE, string);
		}
		case HIERARCHY_ARCHONT:
		{
			//ядерная бомба
			new team = GetPlayerTourTeam(playerid);
			ExplodeNuclearBomb(team);
			SetPVarInt(playerid, "SpecialAbilityCooldown", 40);

			new string[255];
			format(string, sizeof(string), "{674ea7}[Архонт] {ffffff}%s использует {674ea7}<Ядерная ракета>", PlayerInfo[playerid][Name]);
			SendClientMessageToAll(COLOR_WHITE, string);
		}
		case HIERARCHY_ATTACK:
		{
			//сила великого Шажка
			new team = GetPlayerTourTeam(playerid);
			
			IsSpecialAbilityUsed = true;
			SpecialAbilityEffect = SPECIAL_AB_EFFECT_SHAZOK_FORCE;
			SpecialAbilityEffectTime = 5;
			SpecialAbilityEffectTeam = team;

			SetPVarInt(playerid, "SpecialAbilityCooldown", 45);

			new string[255];
			format(string, sizeof(string), "{0000ff}[Атакующий] {ffffff}%s использует {0000ff}<Сила великого Шажка>", PlayerInfo[playerid][Name]);
			SendClientMessageToAll(COLOR_WHITE, string);
		}
		case HIERARCHY_DEFENSE:
		{
			//доспехи Бога
			new team = GetPlayerTourTeam(playerid);
			SetAllTeamInvulnearable(team, 5);
			SetPVarInt(playerid, "SpecialAbilityCooldown", 45);

			new string[255];
			format(string, sizeof(string), "{e69138}[Защитник] {ffffff}%s использует {e69138}<Доспехи Бога>", PlayerInfo[playerid][Name]);
			SendClientMessageToAll(COLOR_WHITE, string);
		}
		case HIERARCHY_SUPPORT:
		{
			//целитель
			new team = GetPlayerTourTeam(playerid);
			HealAllTeam(team);
			SetPVarInt(playerid, "SpecialAbilityCooldown", 40);

			new string[255];
			format(string, sizeof(string), "{c27ba0}[Поддержка] {ffffff}%s использует {c27ba0}<Целитель>", PlayerInfo[playerid][Name]);
			SendClientMessageToAll(COLOR_WHITE, string);
		}
	}
}

stock ResetAllSpecialAbCooldowns()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i))
			continue;
		SetPVarInt(i, "SpecialAbilityCooldown", 0);
	}
}

stock ResetAllSpecialAbilites()
{
	IsSpecialAbilityUsed = false;
	IsNuclearBombExplodes = false;
	IsTeamHealing = false;

	UnfreezeAll();
	ResetAllSpecialAbCooldowns();

	SpecialAbilityDelay = 0;
	SpecialAbilityEffectTime = 0;
	SpecialAbilityEffectTeam = NO_TEAM;
	SpecialAbilityEffect = SPECIAL_AB_EFFECT_NONE;
}

stock UnfreezeAll()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i) || FCNPC_IsValid(i))
			continue;
		TogglePlayerControllable(i, 1);
	}
}

public TickSecond(playerid)
{
	if(!IsTourStarted)
		RegeneratePlayerHP(playerid);

	TryUseHealProp(playerid);
	TryUseInvulProp(playerid);
	TryUseRegenProp(playerid);

	if(FCNPC_IsValid(playerid) && !FCNPC_IsDead(playerid))
		TryUseSpecialAbility(playerid, 15);

	new inv_time = GetPVarInt(playerid, "Invulnearable");
	if(inv_time > 0)
	{
		inv_time--;
		SetPVarInt(playerid, "Invulnearable", inv_time);
	}

	new coop_cooldown = GetPVarInt(playerid, "CooperateCooldown");
	if(coop_cooldown > 0)
	{
		coop_cooldown--;
		SetPVarInt(playerid, "CooperateCooldown", coop_cooldown);
	}

	new tp_cooldown = GetPVarInt(playerid, "TeleportCooldown");
	if(tp_cooldown > 0)
	{
		tp_cooldown--;
		SetPVarInt(playerid, "TeleportCooldown", tp_cooldown);
	}

	new sp_cooldown = GetPVarInt(playerid, "SpecialAbilityCooldown");
	if(sp_cooldown > 0)
	{
		sp_cooldown--;
		SetPVarInt(playerid, "SpecialAbilityCooldown", sp_cooldown);
	}
}

public TickSecondGlobal()
{
	if(SpecialActivity == SPECIAL_ACTIVITY_NONE) {}
		//TryRunSpecialActivity(SPECIAL_ACTIVITY_S_DELIVERY);
	else if(SpecialActivityTimer > 0)
	{
		SpecialActivityTimer--;
		if(SpecialActivityTimer <= 0)
			OnSpecialActivityEnd(0);
		else
		{
			new text[64];
			format(text, sizeof(text), "~y~%d", SpecialActivityTimer);
			GameTextForAll(text, 1000, 6);
		}
	}

	if(SpecialAbilityDelay > 0)
		SpecialAbilityDelay--;
	
	if(SpecialAbilityEffectTime > 0)
	{
		SpecialAbilityEffectTime--;
		if(SpecialAbilityEffectTime <= 0)
		{
			if(SpecialAbilityEffect == SPECIAL_AB_EFFECT_CONFUSION)
				UnfreezeAll();

			SpecialAbilityEffectTime = 0;
			SpecialAbilityEffectTeam = NO_TEAM;
			SpecialAbilityEffect = SPECIAL_AB_EFFECT_NONE;
			IsSpecialAbilityUsed = false;
		}
	}
}

public TickHour()
{
	new query[255];
	format(query, sizeof(query), "UPDATE `players` SET `WalkersLimit` = '%d'", WALKERS_LIMIT);
	new Cache:result = mysql_query(sql_handle, query);
	cache_delete(result);

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		PlayerInfo[i][WalkersLimit] = WALKERS_LIMIT;
	}

	SendClientMessageToAll(COLOR_LIGHTRED, "Лимиты сброшены.");
}

public bool:CheckChance(chance)
{
	new rnd = random(100);
	return rnd < chance;
}

public TickMinute()
{
	UpdateBossesCooldowns();
	//if(SpecialActivityDelay > 0)
		//SpecialActivityDelay--;
}

public RefreshWalkers()
{
	if(Tournament[Phase] == PHASE_WAR) return 0;
	for(new i = 0; i < MAX_WALKERS; i++)
	{
		if(FCNPC_GetAimingPlayer(Walkers[i][ID]) != INVALID_PLAYER_ID)
			return 0;
		for(new j = 0; i < MAX_WALKER_LOOT; i++)
		{
			if(WalkerLootItems[Walkers[i][ID]][j][ItemID] != -1)
				return 0;
		}
	}
	DestroyWalkers();
	InitWalkers();
	return 1;
}

public TeleportToHome(playerid)
{
	ResetWorldBounds(playerid);
	SetPlayerPos(playerid, 224.0761,-1839.8217,3.6037);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerTourTeam(playerid, NO_TEAM);
	DestroyDungeon(playerid);
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
	SendClientMessageToAll(0x990099FF, "Атака на босса отменена.");
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
		SendClientMessageToAll(COLOR_GREEN, "Победа! Через 10 секунд все участники будут телепортированы.");
		TeleportTimer = SetTimer("TeleportBossAttackersToHome", 10000, false);
		SetBossCooldown(AttackedBoss);
	}
	else
	{
		SendClientMessageToAll(COLOR_RED, "Поражение. Все участники телепортированы.");
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
	max_hp = floatadd(max_hp, floatmul(100.0, PlayerInfo[playerid][Rank] - 1));
	max_hp = floatadd(max_hp, GetPlayerPropValue(playerid, PROPERTY_MAXHP));
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

public Float:GetDistanceBetweenPoints(Float:p1_x,Float:p1_y,Float:p1_z,Float:p2_x,Float:p2_y,Float:p2_z)
{
	return floatsqroot(floatpower(floatabs(floatsub(p2_x,p1_x)),2)+floatpower(floatabs(floatsub(p2_y,
		p1_y)),2)+floatpower(floatabs(floatsub(p2_z,p1_z)),2));
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

public Float:GetDistanceBetweenPlayerAndVeh(playerid, vehicleid)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if(!IsPlayerConnected(playerid) || vehicleid == -1)
		return -1.0;
	GetPlayerPos(playerid,x1,y1,z1);
	GetVehiclePos(vehicleid,x2,y2,z2);
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
		SetPlayerHealth(playerid, value);
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
	SetPVarFloat(playerid, "HP", new_hp);
	SetPlayerHP(playerid, new_hp);
}

public Float:GetPlayerHP(playerid)
{
	new Float:hp;
	hp = GetPVarFloat(playerid, "HP");
	return hp;
}

public RegeneratePlayerHP(playerid)
{
	if(IsDeath[playerid]) return;
	if(FCNPC_IsValid(playerid) && FCNPC_IsDead(playerid)) return;
	new Float:hp;
	if(FCNPC_IsValid(playerid))
		hp = floatmul(GetPlayerMaxHP(playerid), 0.02);
	else
		hp = floatmul(GetPlayerMaxHP(playerid), HasItem(playerid, ITEM_GEN_HP_ID, 1) ? 0.04 : 0.02);
	GivePlayerHP(playerid, hp);
}

public GivePlayerRate(playerid, rate)
{
	new string[255];
	if(rate > 0)
		format(string, sizeof(string), "{66CC00}Получен рейтинг: %d", rate);
	else
		format(string, sizeof(string), "{CC0000}Потерян рейтинг: %d", rate);
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
	new tax = money / 99;
	money -= tax;
	GivePatriarchMoney(tax);

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

	ResetAllSpecialAbilites();
	SpecialAbilityDelay = 10;
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
			SetPlayerColor(playerid, HexTeamColors[PlayerInfo[playerid][TeamColor]][0]);
			SetPVarFloat(playerid, "HP", MaxHP[playerid]);
			SetPlayerHP(playerid, MaxHP[playerid]);
			SetPlayerInvulnearable(playerid, TOUR_INVULNEARABLE_TIME);
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

    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(PlayerInfo[i][IsWatcher] <= 0)
			continue;
		
		TeleportToRandomWatcherPos(i);
		SetPvpTableVisibility(i, true);
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

        format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` = '%s' AND `IsWatcher`=0", owner);
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
				SetPlayerTourTeam(playerid, i+1);
		}
		
		cache_delete(result);
	}

	cache_delete(q_result);
	
	format(string, sizeof(string), "Начинается %d тур!", Tournament[Tour]);
	SendClientMessageToAll(COLOR_LIGHTRED, string);

	new tour_time = MAX_TOUR_TIME - (20 * (Tournament[Tour] - 1));
	PvpTtl = tour_time;
	TourEndTimer = SetTimerEx("OnTourEnd", tour_time * 1000, false, "i", 1);
	PvpTableUpdTimer = SetTimer("UpdatePvpTable", 1000, true);

	print("Tour started.");
}

stock StartBattle()
{
	/*new string[255];
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

	ResetAllSpecialAbilites();
	SpecialAbilityDelay = 10;
	IsBattleStarted = true;

	//teleport all
	new npcid = -1;
	for(new i = 0; i < BattleParticipantsCount; i++)
	{
		new player[pInfo];
		player = GetPlayer(Battle[ParticipantsIDs][i]);
		new playerid = GetPlayerInGameID(player[ID]);
		if(playerid != -1 && !FCNPC_IsValid(playerid))
		{
			PvpInfo[i][ID] = playerid;
			format(PvpInfo[i][Name], 255, "%s", player[Name]);
			TeleportToRandomArenaPos(playerid);
			SetPlayerColor(playerid, HexTeamColors[PlayerInfo[playerid][TeamColor]][0]);
			SetPVarFloat(playerid, "HP", MaxHP[playerid]);
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

		InitBattleNPC(npcid);
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

        format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` = '%s' AND `IsWatcher`=0", owner);
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
				SetPlayerTourTeam(playerid, i+1);
		}
		
		cache_delete(result);
	}

	cache_delete(q_result);
	
	format(string, sizeof(string), "Начинается %d тур!", Tournament[Tour]);
	SendClientMessageToAll(COLOR_LIGHTRED, string);

	new tour_time = MAX_TOUR_TIME - (20 * (Tournament[Tour] - 1));
	PvpTtl = tour_time;
	TourEndTimer = SetTimerEx("OnTourEnd", tour_time * 1000, false, "i", 1);
	PvpTableUpdTimer = SetTimer("UpdatePvpTable", 1000, true);

	print("Battle started.");*/
}

stock GetScoreDiff(rate1, rate2, bool:is_killer)
{
	new diff = rate1 - rate2;
	if(diff > 2500)
		diff = floatround(floatmul(diff, 0.5));
	else if(diff > 2000)
		diff = floatround(floatmul(diff, 0.45));
	else if(diff > 1500)
		diff = floatround(floatmul(diff, 0.4));
	else if(diff > 1000)
		diff = floatround(floatmul(diff, 0.35));
	else if(diff > 500)
		diff = floatround(floatmul(diff, 0.3));
	else if(diff > 0)
		diff = floatround(floatmul(diff, 0.2));
	else
		diff = floatround(floatabs(floatmul(3001 - floatabs(diff), 0.007)));

	if(is_killer)
		diff += 40;
	else
		diff = floatround(floatmul(diff, 0.5));
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
		case 33: return RIFLE_SHOOT_DELAY;
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

stock GetWalkersCountByRank(rank)
{
	new count = 0;
	for(new i = 0; i < MAX_WALKERS; i++)
	{
		if(Walkers[i][Rank] == rank)
			count++;
	}

	return count;
}

stock InitTourNPC(npcid)
{
	if(npcid == -1) return;

	LoadPlayer(npcid);

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

stock SetPlayerHPPercent(playerid, percent)
{
	new Float:hp;
	hp = floatmul(GetPlayerMaxHP(playerid), floatdiv(percent, 100));

	SetPVarFloat(playerid, "HP", hp);
	SetPlayerHP(playerid, hp);
}

stock GetPlayerHPPercent(playerid)
{
	new Float:hp = GetPlayerHP(playerid);
	new Float:max_hp = GetPlayerMaxHP(playerid);
	new Float:percent = floatmul(floatdiv(hp, max_hp), 100);

	return floatround(percent);
}

stock SetPlayerInvulnearable(playerid, time)
{
	new inv = GetPVarInt(playerid, "Invulnearable");
	if(inv < 0) 
		inv = 0;

	SetPVarInt(playerid, "Invulnearable", inv + time);
}

stock GetRandomCooperateMessage()
{
	new idx = random(MAX_COOPERATE_MSGS);
	return CooperateMessages[idx];
}

stock CooperateTeammatesWithPlayer(playerid)
{
	new target = GetPlayerTargetPlayer(playerid);
	if(target == INVALID_PLAYER_ID || target == -1 || target == playerid || GetPlayerTourTeam(playerid) == GetPlayerTourTeam(target))
		return SendClientMessage(playerid, COLOR_GREY, "Не соблюдены условия использования.");
	
	new targets_count = 0;
	new string[255];
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new part_id = PvpInfo[i][ID];
		if(!FCNPC_IsValid(part_id) || part_id == -1 || part_id == playerid || GetPlayerTourTeam(playerid) != GetPlayerTourTeam(part_id))
			continue;
		
		if(GetDistanceBetweenPlayers(playerid, part_id) > 30.0)
			continue;
		
		new part_target = FCNPC_GetAimingPlayer(part_id);
		if(part_target != INVALID_PLAYER_ID && part_target != -1 && GetPlayerHPPercent(part_target) <= 5)
			continue;
		
		SetPVarInt(part_id, "FixTargetID", target);
		SetPlayerTarget(part_id, target);
		targets_count++;

		if(targets_count == 1)
		{
			format(string, sizeof(string), "[%s]: В атаку на %s, клоуны!", PlayerInfo[playerid][Name], PlayerInfo[target][Name]);
			SendClientMessageToAll(COLOR_YELLOW, string);
		}

		format(string, sizeof(string), "[%s]: %s", PlayerInfo[part_id][Name], GetRandomCooperateMessage());
		SendClientMessageToAll(0x0099FFFF, string);
	}

	if(targets_count > 0)
	{
		SetPVarInt(playerid, "CooperateCooldown", COOPERATE_COOLDOWN);
		return 1;
	}

	return SendClientMessage(playerid, COLOR_GREY, "Поблизости нет союзников.");
}

stock ParticipantBehaviour(id)
{
	if(id == -1 || id == INVALID_PLAYER_ID) return 1;
	if(!FCNPC_IsValid(id)) return 1;

	new moving_ticks = GetPVarInt(id, "MovingTicks");
	new idle_ticks = GetPVarInt(id, "IdleTicks");
	new fix_target = GetPVarInt(id, "FixTargetID");
	new shotting_ticks = GetPVarInt(id, "ShotTicks");

	if(FCNPC_IsShooting(id))
		shotting_ticks++;
	else
		shotting_ticks = 0;
	SetPVarInt(id, "ShotTicks", shotting_ticks);

	if(FCNPC_IsMoving(id))
	{
		moving_ticks++;
		idle_ticks = 0;
	}
	else
	{
		moving_ticks = 0;
		if(!FCNPC_IsShooting(id))
			idle_ticks++;
		else
			idle_ticks = 0;
	}

	SetPVarInt(id, "MovingTicks", moving_ticks);
	SetPVarInt(id, "IdleTicks", idle_ticks);

	//If NPC is moving too long - try to find new target.
	if(fix_target == -1 && FCNPC_IsMoving(id) && moving_ticks > MAX_NPC_MOVING_TICKS)
	{
		FCNPC_Stop(id);
		SetPVarInt(id, "MovingTicks", 0);
		SetPlayerTarget(id);
		return 1;
	}

	//If NPC is idle too long - move him
	if(!FCNPC_IsMoving(id) && !FCNPC_IsShooting(id) && idle_ticks > MAX_NPC_IDLE_TICKS)
	{
		MoveAround(id);
		return 1;
	}

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
			MoveAround(id);
		return 1;
	}

	//If NPC's HP is low, but target's HP is not critical - run away
	if(fix_target == -1 && GetPlayerHPPercent(id) < 10 && !FCNPC_IsMoving(id))
	{
		MoveAround(id, true);
		return 1;
	}

	//If NPC has a lot of aimers - run away
	if(GetAimingPlayersCount(id) > 3 && GetPlayerHPPercent(id) < 50 && !FCNPC_IsMoving(id))
	{
		MoveAround(id, true);
		return 1;
	}

	//Checking available target
	if(!FCNPC_IsAiming(id) && !FCNPC_IsDead(id))
	{
		if(fix_target == -1) SetPlayerTarget(id);
		else SetPlayerTarget(id, fix_target);
	}

	//If current target is dead or invalid, set new
	target = FCNPC_GetAimingPlayer(id);
	if(target == -1 || target == INVALID_PLAYER_ID)
	{
		if(fix_target == -1) SetPlayerTarget(id);
		else SetPlayerTarget(id, fix_target);
		return 1;
	}
	if(FCNPC_IsDead(target) || (!FCNPC_IsValid(target) && (!IsPlayerInDynamicArea(target, arena_area) || IsDeath[target])))
	{
		SetPlayerTarget(id);
		return 1;
	}

	//If current target's HP > 30%, trying to find common target
	new common_finded = -1;
	if(fix_target == -1 && GetPlayerHPPercent(target) > 30 && GetAimingPlayersCount(target) < 3)
		common_finded = TryFindCommonTarget(id, target);

	//If there are targets with less HP beside player - change target
	if(common_finded == -1 && fix_target == -1 && GetPlayerHPPercent(target) >= 20)
	{
		new potential_target = FindPlayerTarget(id, true);
		if(potential_target != -1 && potential_target != target)
		{
			if(GetPlayerHPPercent(potential_target) < 20)
				SetPlayerTarget(id, potential_target);
		}
	}

	target = FCNPC_GetAimingPlayer(id);

	new Float:dist = GetDistanceBetweenPlayers(id, target);
	if(!FCNPC_IsMovingAtPlayer(id, target) && dist > 10.0)
	{
		if(!FCNPC_IsShooting(id) || shotting_ticks > MAX_NPC_SHOT_TICKS)
			FCNPC_GoToPlayer(id, target);
	}

	//If player so close to target - attack it
	if(dist <= 10)
	{
		if(FCNPC_IsMoving(id))
			FCNPC_Stop(id);
		if(!FCNPC_IsShooting(id))
			FCNPC_AimAtPlayer(id, target, true, GetWeaponDelay(FCNPC_GetWeapon(id)));
	}
	else if(shotting_ticks > MAX_NPC_SHOT_TICKS)
		FCNPC_AimAtPlayer(id, target, false);
	
	return 1;
}

stock GetWalkerIdx(walkerid)
{
	for(new i = 0; i < MAX_WALKERS; i++)
	{
		if(Walkers[i][ID] == walkerid)
			return i;
	}
	return -1;
}

stock GetWalkerTopDamager(walkerid)
{
	new idx = GetWalkerIdx(walkerid);
	if(idx == -1) return -1;

	new max_damage = 0;
	new damagerid = -1;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(i == walkerid || !IsPlayerConnected(i))
			continue;
		if(WalkersDamagers[idx][i] > max_damage)
		{
			max_damage = WalkersDamagers[idx][i];
			damagerid = i;
		}
	}

	return damagerid;
}

stock GetWalkerAvailableTarget(walkerid, oldtarget)
{
	new target = -1;
	new idx = GetWalkerIdx(walkerid);
	if(idx == -1) return target;

	new max_damage = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(i == oldtarget || i == walkerid || !IsPlayerConnected(i) || FCNPC_IsValid(i)) continue;
		if(WalkersDamagers[idx][i] > 0 && !IsDeath[i] && IsPlayerInDynamicArea(i, walkers_area))
		{
			if(WalkersDamagers[idx][i] > max_damage)
			{
				max_damage = WalkersDamagers[idx][i];
				target = i;
			}
		}
	}

	return target;
}

stock ResetDungeonEnemyTarget(id)
{
	if(FCNPC_IsMoving(id))
		FCNPC_Stop(id);
	if(FCNPC_IsAiming(id))
		FCNPC_StopAim(id);
	SetPVarFloat(id, "HP", MaxHP[id]);
	SetMobDestPoint(id);
}

stock ResetWalkerTarget(id)
{
	ResetWalkerDamagersInfo(id);
	if(FCNPC_IsMoving(id))
		FCNPC_Stop(id);
	if(FCNPC_IsAiming(id))
		FCNPC_StopAim(id);
	SetPVarFloat(id, "HP", MaxHP[id]);
	SetWalkerDestPoint(id);
}

stock ResetAllWalkersTargets()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i) || !FCNPC_IsValid(i)) continue;
		if(IsWalker[i] && !IsTourStarted)
			ResetWalkerTarget(i);
	}
}

stock FindWalkerNearestTarget(id, radius)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i) || FCNPC_IsValid(i)) continue;
		if(GetDistanceBetweenPlayers(id, i) <= radius)
			return i;
	}

	return -1;
}

stock DungeonEnemyBehaviour(id)
{
	if(id == -1 || id == INVALID_PLAYER_ID) return;
	if(!FCNPC_IsValid(id)) return;

	new shotting_ticks = GetPVarInt(id, "ShotTicks");
	if(FCNPC_IsShooting(id))
		shotting_ticks++;
	else
		shotting_ticks = 0;
	SetPVarInt(id, "ShotTicks", shotting_ticks);

	new target = FCNPC_GetAimingPlayer(id);

	if(target == -1 || target == INVALID_PLAYER_ID)
	{
		if(FCNPC_IsAiming(id))
			FCNPC_StopAim(id);
		if(!FCNPC_IsMoving(id))
			SetMobDestPoint(id);
		return;
	}

	if(IsDeath[target])
	{
		if(FCNPC_IsAiming(id))
			FCNPC_StopAim(id);
		if(FCNPC_IsMoving(id))
			FCNPC_Stop(id);
			
		SetPVarFloat(id, "HP", MaxHP[id]);
		SetMobDestPoint(id);
		return;
	}

	new Float:dist = GetDistanceBetweenPlayers(id, target);
	if(dist > 35)
	{
		ResetDungeonEnemyTarget(id);
		return;
	}

	if(!FCNPC_IsMovingAtPlayer(id, target) && dist > 14.0)
	{
		if(!FCNPC_IsShooting(id) || shotting_ticks > MAX_NPC_SHOT_TICKS)
			FCNPC_GoToPlayer(id, target);
	}

	//If npc so close to target - attack it
	if(dist <= 14)
	{
		if(FCNPC_IsMoving(id))
			FCNPC_Stop(id);
		if(!FCNPC_IsShooting(id))
			FCNPC_AimAtPlayer(id, target, true, GetWeaponDelay(FCNPC_GetWeapon(id)));
	}
	else if(shotting_ticks > MAX_NPC_SHOT_TICKS)
		FCNPC_AimAtPlayer(id, target, false);
}

stock WalkerBehaviour(id)
{
	if(id == -1 || id == INVALID_PLAYER_ID) return;
	if(!FCNPC_IsValid(id) || !IsWalker[id]) return;

	new shotting_ticks = GetPVarInt(id, "ShotTicks");
	if(FCNPC_IsShooting(id))
		shotting_ticks++;
	else
		shotting_ticks = 0;
	SetPVarInt(id, "ShotTicks", shotting_ticks);

	new target = FCNPC_GetAimingPlayer(id);
	if(SpecialActivity == SPECIAL_ACTIVITY_S_DELIVERY && SpecialActivityVehicleID != -1 && GetDistanceBetweenPlayerAndVeh(id, SpecialActivityVehicleID) < 5)
	{
		new new_target = FindWalkerNearestTarget(id, 6);
		if(new_target != -1)
			target = new_target;
	}

	new Float:x, Float:y, Float:z;
	FCNPC_GetPosition(id, x, y, z);
	if(!IsPointInDynamicArea(walkers_area, x, y, z))
	{
		if(FCNPC_IsMoving(id) && (target == -1 || target == INVALID_PLAYER_ID))
			return;

		ResetWalkerTarget(id);
		return;
	}

	if(target == -1 || target == INVALID_PLAYER_ID)
	{
		if(FCNPC_IsAiming(id))
			FCNPC_StopAim(id);
		if(!FCNPC_IsMoving(id))
			SetWalkerDestPoint(id);
		return;
	}

	if(IsDeath[target] || (PlayerInfo[target][WalkersLimit] <= 0 && SpecialActivity != SPECIAL_ACTIVITY_S_DELIVERY))
	{
		if(FCNPC_IsAiming(id))
			FCNPC_StopAim(id);
		if(FCNPC_IsMoving(id))
			FCNPC_Stop(id);
		new new_target = GetWalkerAvailableTarget(id, target);
		if(new_target != -1)
			SetPlayerTarget(id, new_target);
		else
		{
			ResetWalkerDamagersInfo(id);
			SetPVarFloat(id, "HP", MaxHP[id]);
			SetWalkerDestPoint(id);
		}
		return;
	}

	new another_target = GetWalkerTopDamager(id);
	if(another_target != target && another_target != -1)
	{
		SetPlayerTarget(id, another_target);
		return;
	}

	new Float:dist = GetDistanceBetweenPlayers(id, target);
	if(dist > 30)
	{
		ResetWalkerTarget(id);
		return;
	}

	if(!FCNPC_IsMovingAtPlayer(id, target) && dist > 10.0)
	{
		if(!FCNPC_IsShooting(id) || shotting_ticks > MAX_NPC_SHOT_TICKS)
			FCNPC_GoToPlayer(id, target);
	}

	//If walker so close to target - attack it
	if(dist <= 10)
	{
		if(FCNPC_IsMoving(id))
			FCNPC_Stop(id);
		if(!FCNPC_IsShooting(id))
			FCNPC_AimAtPlayer(id, target, true, GetWeaponDelay(FCNPC_GetWeapon(id)));
	}
	else if(shotting_ticks > MAX_NPC_SHOT_TICKS)
		FCNPC_AimAtPlayer(id, target, false);
}

stock BossBehaviour(id)
{
	if(id == -1 || id == INVALID_PLAYER_ID) return;

	new shotting_ticks = GetPVarInt(id, "ShotTicks");
	if(FCNPC_IsShooting(id))
		shotting_ticks++;
	else
		shotting_ticks = 0;
	SetPVarInt(id, "ShotTicks", shotting_ticks);

	//If NPC bumped any obstacle - move him
	if(FCNPC_IsMoving(id) && FCNPC_GetSpeed(id) < 0.1)
	{
		MoveAround(id);
		return;
	}

	//Checking available target
	if(!FCNPC_IsDead(id) && BossAttackersCount > 1)
		SetBossTarget(id);

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
		if(!FCNPC_IsShooting(id) || shotting_ticks > MAX_NPC_SHOT_TICKS)
			FCNPC_GoToPlayer(id, target);
	}

	//If player so close to target - attack it
	if(dist <= 10)
	{
		if(FCNPC_IsMoving(id))
			FCNPC_Stop(id);
		if(!FCNPC_IsShooting(id))
			FCNPC_AimAtPlayer(id, target, true, GetWeaponDelay(FCNPC_GetWeapon(id)));
	}
	else if(shotting_ticks > MAX_NPC_SHOT_TICKS)
		FCNPC_AimAtPlayer(id, target, false);
}

stock GiveSpecialActivityRewards(activityid)
{
	if(activityid == SPECIAL_ACTIVITY_NONE) return;
	if(activityid == SPECIAL_ACTIVITY_S_DELIVERY)
	{
		new count = 0;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(count >= MAX_OWNERS) break;
			if(!IsPlayerConnected(i) || FCNPC_IsValid(i)) continue;

			PendingItem(PlayerInfo[i][Name], 368, MOD_CLEAR, random(6) + 5, "Награда за доставку S-а");
			count++;
		}
	}
}

stock GiveTournamentRewards()
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` <> 'Admin' AND `IsWatcher`=0 LIMIT %d", MAX_PARTICIPANTS);
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
				reward[ItemID] = 313;
				reward[ItemsCount] = 15;
				money = 4000;
			}
			case 2:
			{
				reward[ItemID] = 313;
				reward[ItemsCount] = 13;
				money = 3800;
			}
			case 3:
			{
				reward[ItemID] = 313;
				reward[ItemsCount] = 11;
				money = 3500;
			}
			case 4..5:
			{
				reward[ItemID] = 313;
				reward[ItemsCount] = 7;
				money = 2750;
			}
			case 6..8:
			{
				reward[ItemID] = 312;
				reward[ItemsCount] = 10;
				money = 2200;
			}
			case 9..12:
			{
				reward[ItemID] = 312;
				reward[ItemsCount] = 8;
				money = 1600;
			}
			case 13..16:
			{
				reward[ItemID] = 312;
				reward[ItemsCount] = 6;
				money = 1350;
			}
			default:
			{
				reward[ItemID] = 312;
				reward[ItemsCount] = 4;
				money = 1000;
			}
		}

		money = money * floatround(floatpower(rank, 2));
		reward[Money] = money;

		new id = GetPlayerID(name);
		if(id == -1)
		{
			if(reward[ItemID] != -1)
			{
				new string[255];
				format(string, sizeof(string), "Награда за %d место", place);
				PendingItem(name, reward[ItemID], MOD_CLEAR, reward[ItemsCount], string);
			}
			if(reward[Money] > 0)
				GivePlayerMoneyOffline(name, reward[Money]);
		}
		else
		{
			if(reward[ItemID] != -1)
			{
				if(IsInventoryFull(id))
				{
					new string[255];
					format(string, sizeof(string), "Награда за %d место", place);
					SendClientMessage(id, COLOR_GREY, "Инвентарь полон, награды отправлены на почту.");
					PendingItem(name, reward[ItemID], MOD_CLEAR, reward[ItemsCount], string);
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

		//PendingItem(name, 368, MOD_CLEAR, 1, "С Новым годом!");
	}
}

stock SellAllUselessItems(playerid)
{
	new money = 0;
	new items = 0;

	for(new i = 0; i < MAX_SLOTS; i++)
	{
		new itemid = PlayerInventory[playerid][i][ID];
		new item[BaseItem];
		item = GetItem(itemid);
		if(PlayerInventory[playerid][i][ID] == 366)
		{
			money += PlayerInventory[playerid][i][Count] * (item[Price] / 7);
			items++;
			DeleteItem(playerid, i, PlayerInventory[playerid][i][Count]);
			continue;
		}
		if(item[Grade] == GRADE_N && IsModifiableEquip(itemid) && GetModLevel(PlayerInventory[playerid][i][Mod]) == 0)
		{
			money += item[Price] / 7;
			items++;
			DeleteItem(playerid, i);
			continue;
		}
	}
	
	new tax = money / 99;
	money -= tax;
	PlayerInfo[playerid][Cash] += money;
	GivePlayerMoney(playerid, money);
	GivePatriarchMoney(tax);

	new string[255];
	format(string, sizeof(string), "Продано предметов: %d", items);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Получено: %s$", FormatMoney(money));
	SendClientMessage(playerid, COLOR_GREEN, string);
}

stock HappyBirthday(owner[])
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` <> 'Admin' AND `Owner` = '%s' AND `IsWatcher`=0 LIMIT %d", owner, MAX_PARTICIPANTS);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("Cannot get player list.");
		return;
	}

	q_result = cache_save();
	cache_unset_active();

	for(new i = 0; i < row_count; i++)
	{
		new name[255];
		new place;
		cache_set_active(q_result);
		cache_get_value_name(i, "Name", name);
		cache_get_value_name_int(i, "LocalTopPos", place);
		cache_unset_active();

		PendingItem(name, 367, MOD_CLEAR, MAX_PARTICIPANTS / 2 + 1 - place, "С Днем рождения!");
	}

	cache_delete(q_result);
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

stock UpdateTempHierarchyItems()
{
	new query[255] = "UPDATE `players` SET `WeaponSlotID` = '0', `WeaponMod` = '0 0 0 0 0 0 0' WHERE `Status` = '0' AND `WeaponSlotID`='275'";
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	query = "UPDATE `players` SET `WeaponSlotID` = '0', `WeaponMod` = '0 0 0 0 0 0 0' WHERE `Status` <> '1' AND `WeaponSlotID` = '276'";
	q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	query = "UPDATE `players` SET `ArmorSlotID` = '81', `ArmorMod` = '0 0 0 0 0 0 0' WHERE `Status` = '0' AND `ArmorSlotID` = '273'";
	q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	query = "UPDATE `players` SET `ArmorSlotID` = '81', `ArmorMod` = '0 0 0 0 0 0 0' WHERE `Status` <> '1' AND `ArmorSlotID` = '274'";
	q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		for(new j = 0; j < MAX_SLOTS; j++)
		{
			if((PlayerInfo[i][WeaponSlotID] == 275 && PlayerInfo[i][Status] == HIERARCHY_NONE) ||
			   (PlayerInfo[i][WeaponSlotID] == 276 && PlayerInfo[i][Status] != HIERARCHY_LEADER))
			{
				PlayerInfo[i][WeaponSlotID] = 0;
				PlayerInfo[i][WeaponMod] = MOD_CLEAR;
				UpdatePlayerStats(i);
			}
			if((PlayerInfo[i][ArmorSlotID] == 273 && PlayerInfo[i][Status] == HIERARCHY_NONE) ||
			   (PlayerInfo[i][ArmorSlotID] == 274 && PlayerInfo[i][Status] != HIERARCHY_LEADER))
			{
				PlayerInfo[i][ArmorSlotID] = 81;
				PlayerInfo[i][ArmorMod] = MOD_CLEAR;
				UpdatePlayerStats(i);
			}
		}
	}
}

stock UpdateTempItems()
{
	new query[255] = "UPDATE `inventories` SET `ItemID` = '-1', `Count` = '0' WHERE `ItemID` >= '277' AND `ItemID` <= '281'";
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		for(new j = 0; j < MAX_SLOTS; j++)
		{
			if(PlayerInventory[i][j][ID] >= 277 && PlayerInventory[i][j][ID] <= 281)
			{
				DeleteItem(i, j);
				UpdatePlayerStats(i);
			}
		}
	}
}

stock UpdateMarketItems()
{
	new query[255] = "SELECT * FROM `marketplace`";
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("Cannot update marketplace.");
		return;
	}

	q_result = cache_save();
	cache_unset_active();

	for(new i = 0; i < row_count; i++)
	{
		new id = -1;
		new time = 0;
		cache_set_active(q_result);

		cache_get_value_name_int(i, "ID", id);
		cache_get_value_name_int(i, "Time", time);

		time--;
		if(time <= 0)
		{
			new itemid = -1;
			new count = 0;
			new owner[255];
			new mod[MAX_MOD];
			new string[255];

			cache_get_value_name_int(i, "ItemID", itemid);
			cache_get_value_name_int(i, "ItemCount", count);
			cache_get_value_name(i, "Owner", owner);
			cache_get_value_name(i, "ItemMod", string);
			sscanf(string, "a<i>[7]", mod);

			cache_unset_active();

			PendingItem(owner, itemid, mod, count, "Срок регистрации предмета истек");

			new sub_query[255];
			format(sub_query, sizeof(sub_query), "DELETE FROM `marketplace` WHERE `ID` = '%d'", id);
			new Cache:result = mysql_query(sql_handle, sub_query);
			cache_delete(result);
		}
		else
		{
			cache_unset_active();

			new sub_query[255];
			format(sub_query, sizeof(sub_query), "UPDATE `marketplace` SET `Time` = '%d' WHERE `ID` = '%d' LIMIT 1", time, id);
			new Cache:result = mysql_query(sql_handle, sub_query);
			cache_delete(result);
		}
	}

	cache_delete(q_result);
}

stock GetMarketItem(id, category)
{
	new item[MarketItem];
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `marketplace` WHERE `Category` = '%d' ORDER BY `Price` LIMIT %d", category, MAX_MARKET_ITEMS);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("GetMarketItem() error.");
		return item;
	}

	new string[255];

	cache_get_value_name_int(id, "ID", item[LotID]);
	cache_get_value_name_int(id, "ItemID", item[ID]);
	cache_get_value_name_int(id, "Price", item[Price]);
	cache_get_value_name_int(id, "Time", item[rTime]);
	cache_get_value_name_int(id, "ItemCount", item[Count]);
	cache_get_value_name(id, "Owner", string);
	sscanf(string, "s[255]", item[Owner]);
	cache_get_value_name(id, "ItemMod", string);
	sscanf(string, "a<i>[7]", item[Mod]);

	cache_delete(q_result);
	return item;
}

stock GetMarketItemByLotID(id)
{
	new item[MarketItem];
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `marketplace` WHERE `ID` = '%d' LIMIT 1", id);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("GetMarketItemByLotID() error.");
		return item;
	}

	new string[255];
	
	item[LotID] = id;
	cache_get_value_name_int(0, "ItemID", item[ID]);
	cache_get_value_name_int(0, "Price", item[Price]);
	cache_get_value_name_int(0, "Time", item[rTime]);
	cache_get_value_name_int(0, "ItemCount", item[Count]);
	cache_get_value_name(0, "Owner", string);
	sscanf(string, "s[255]", item[Owner]);
	cache_get_value_name(0, "ItemMod", string);
	sscanf(string, "a<i>[7]", item[Mod]);

	cache_delete(q_result);
	return item;
}

stock AddItemToMarket(playerid, slotid, lotid, category, time = 2)
{
	new item[MarketItem];
	item = GetMarketItemByLotID(lotid)

	new query[255] = "SELECT MAX(`ID`) AS `ID` FROM `marketplace`";
	new Cache:q_result = mysql_query(sql_handle, query);
	new id = -1;
	cache_get_value_name_int(0, "ID", id);
	cache_delete(q_result);

	if(id == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка: не удалось сгенерировать ID лота.");
		return;
	}

	id++;

	format(query, sizeof(query), "INSERT INTO `marketplace`(`ID`, `Owner`, `ItemID`, `Category`, `ItemCount`, `ItemMod`, `Price`, `Time`) VALUES ('%d','%s','%d','%d','%d','%s','%d','%d')",
		id, item[Owner], item[ID], category, item[Count], ArrayToString(item[Mod]), item[Price], time
	);
	new Cache:sq_result = mysql_query(sql_handle, query);
	cache_delete(sq_result);

	DeleteItem(playerid, slotid, item[Count]);
	SendClientMessage(playerid, COLOR_GREEN, "Предмет зарегистрирован.");
}

stock DeleteItemFromMarket(lotid, count = 1)
{
	new item[MarketItem];
	item = GetMarketItemByLotID(lotid);
	if(item[Count] <= count)
	{
		new query[255];
		format(query, sizeof(query), "DELETE FROM `marketplace` WHERE `ID` = '%d'", item[LotID]);
		new Cache:q_result = mysql_query(sql_handle, query);
		cache_delete(q_result);
	}
	else
	{
		new query[255];
		format(query, sizeof(query), "UPDATE `marketplace` SET `ItemCount` = '%d' WHERE `ID` = '%d'", item[Count] - count, item[LotID]);
		new Cache:q_result = mysql_query(sql_handle, query);
		cache_delete(q_result);
	}
}

stock MarketItemExist(id)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `marketplace` WHERE `ID` = '%d'", id);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count = 0;
	cache_get_row_count(count);
	cache_delete(q_result);

	if(count > 0)
		return true;
	return false;
}

stock GetMarketLotsCountByCategory(category)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `marketplace` WHERE `Category` = '%d' ORDER BY `Price` LIMIT %d", category, MAX_MARKET_ITEMS);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count = 0;
	cache_get_row_count(count);
	cache_delete(q_result);

	return count;
}

stock GetMarketLotsCountByOwner(owner[])
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `marketplace` WHERE `Owner` = '%d'", owner);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count = 0;
	cache_get_row_count(count);
	cache_delete(q_result);

	return count;
}

stock RegisterMarketItem(playerid, category)
{
	if(MarketSellingItem[playerid][ID] == -1) return;
	if(!HasItem(playerid, MarketSellingItem[playerid][ID], MarketSellingItem[playerid][Count])) return;
	if(GetMarketLotsCountByCategory(category) >= MAX_MARKET_ITEMS)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Достигнут лимит лотов в этой категории.", "Закрыть", "");
		return;
	}
	if(GetMarketLotsCountByOwner(PlayerInfo[playerid][Name]) >= MAX_MARKET_ITEMS)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Достигнут персональный лимит зарегистрированных лотов.", "Закрыть", "");
		return;
	}

	new query[255];
	format(query, sizeof(query), "INSERT INTO `marketplace`(`ID`, `Owner`, `ItemID`, `Category`, `ItemCount`, `ItemMod`, `Price`, `Time`) VALUES ('%d', '%s', '%d', '%d', '%d', '%s', '%d', '%d')",
		MarketSellingItem[playerid][LotID], MarketSellingItem[playerid][Owner], MarketSellingItem[playerid][ID], category, MarketSellingItem[playerid][Count],
		ArrayToString(MarketSellingItem[playerid][Mod], MAX_MOD), MarketSellingItem[playerid][Price], MarketSellingItem[playerid][rTime]
	);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	new slotid = GetPVarInt(playerid, "MarketSellingItemInvSlot");
	DeleteItem(playerid, slotid, MarketSellingItem[playerid][Count]);
	SendClientMessageToAll(0xFFCC66FF, "Зарегистрирован новый предмет на рынке.");

	MarketSellingItem[playerid] = EmptyMarketSellingItem;
	UpdateMarketSellWindow(playerid);
}

stock GetMarketCategoryByItem(itemid)
{
	new item[BaseItem];
	item = GetItem(itemid);
	new category = MARKET_CATEGORY_MATERIAL;

	switch(item[Type])
	{
		case ITEMTYPE_ARMOR: category = MARKET_CATEGORY_ARMOR;
		case ITEMTYPE_WEAPON: category = MARKET_CATEGORY_WEAPON;
        case ITEMTYPE_HAT: category = MARKET_CATEGORY_HAT;
        case ITEMTYPE_GLASSES: category = MARKET_CATEGORY_GLASSES;
        case ITEMTYPE_WATCH: category = MARKET_CATEGORY_WATCH;
        case ITEMTYPE_RING, ITEMTYPE_AMULETTE: category = MARKET_CATEGORY_ACCESSORY;
	}

	return category;
}

stock GetMarketNextLotID()
{
	new query[255] = "SELECT MAX(`ID`) AS `ID` FROM `marketplace`";
	new Cache:q_result = mysql_query(sql_handle, query);
	new id = -1;
	new row_count = 0;
	cache_get_row_count(row_count);

	if(row_count <= 0)
		id = 0;
	else
		cache_get_value_name_int(0, "ID", id);
	cache_delete(q_result);

	id++;
	return id;
}

stock BuyItem(playerid, lotid, count = 1)
{
	new item[MarketItem];
	item = GetMarketItemByLotID(lotid);

	new category = GetPVarInt(playerid, "MarketBuyCategory");

	new player[pInfo];
	player = GetPlayerByName(item[Owner]);
	if(strcmp(player[Owner], PlayerInfo[playerid][Owner], true) == 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "Вы не можете приобретать предметы у своих же участников.");
		ShowMarketBuyList(playerid, category);
		return;
	}

	if(!MarketItemExist(item[LotID]))
	{
		SendClientMessage(playerid, COLOR_GREY, "Предложение больше не актуально.");
		ShowMarketBuyList(playerid, category);
		return;
	}

	DeleteItemFromMarket(item[LotID], count);

	new amount = item[Price] * count;
	new comission = floatround(floatmul(amount, 0.05));
	
	PlayerInfo[playerid][Cash] -= amount;
	GivePlayerMoney(playerid, -amount);

	amount -= comission;

	if(IsEquip(item[ID]))
		AddEquip(playerid, item[ID], item[Mod]);
	else
		AddItem(playerid, item[ID], count);
	
	new owner_id = GetPlayerID(item[Owner]);

	new b_item[BaseItem];
	b_item = GetItem(item[ID]);

	new string[255];
	format(string, sizeof(string), "Предмет [{%s}%s{ffffff}] продан.", GetGradeColor(b_item[Grade]), b_item[Name]);

	if(owner_id != -1)
	{
		PlayerInfo[owner_id][Cash] += amount;
		GivePlayerMoney(owner_id, amount);
		SendClientMessage(owner_id, 0xFFFFFFFF, string);
	}
	else
	{
		PendingMessage(item[Owner], string);
		GivePlayerMoneyOffline(item[Owner], amount);
	}

	GivePatriarchMoney(comission);
	
	SendClientMessage(playerid, COLOR_GREEN, "Предмет куплен.");
	ShowMarketBuyList(playerid, category);
}

stock GivePatriarchMoney(value)
{
	new query[255];
	format(query, sizeof(query), "UPDATE `hierarchy` SET `Money` = Money+%d LIMIT 1", value);
	new Cache:temp_result = mysql_query(sql_handle, query);
	cache_delete(temp_result);
}

stock CancelItem(playerid, listitem)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `marketplace` WHERE `Owner` = '%s' ORDER BY `Time` LIMIT %d", PlayerInfo[playerid][Name], MAX_MARKET_ITEMS);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		cache_delete(q_result);
		SendClientMessage(playerid, COLOR_GREY, "Не зарегистрировано ни одного предмета.");
		ShowMarketMenu(playerid);
		return;
	}

	new lotid = -1;
	cache_get_value_name_int(listitem, "ID", lotid);
	cache_delete(q_result);

	if(lotid == -1)
	{
		SendClientMessage(playerid, COLOR_GREY, "Не удалось отменить регистрацию.");
		ShowMarketMenu(playerid);
		return;
	}

	new item[MarketItem];
	item = GetMarketItemByLotID(lotid);

	if(!MarketItemExist(item[LotID]))
	{
		SendClientMessage(playerid, COLOR_GREY, "Предмет уже снят или куплен.");
		ShowMarketMenu(playerid);
		return;
	}

	SendClientMessage(playerid, COLOR_GREEN, "Регистрация отменена. Предметы отправлены на почту.");
	PendingItem(item[Owner], item[ID], item[Mod], item[Count], "Предмет возвращен");

	DeleteItemFromMarket(item[LotID], item[Count]);
	ShowMarketMenu(playerid);
}

stock ShowMarketMenu(playerid)
{
	new listitems[] = "Купить предмет\nПродать предмет\nМои лоты";
	ShowPlayerDialog(playerid, 1100, DIALOG_STYLE_TABLIST, "Рынок", listitems, "Далее", "Закрыть");
}

stock ShowMarketSellingItems(playerid, category, content[])
{
	new listitems[4096];
	if(category == MARKET_CATEGORY_MATERIAL)
		listitems = "Предмет\tЦена за 1 шт\tВладелец\tВремя регистрации";
	else
		listitems = "[Предмет](улучшения)\t[Ранг] цена\tВладелец\tВремя регистрации";
	strcat(listitems, content);
	ShowPlayerDialog(playerid, 1101, DIALOG_STYLE_TABLIST_HEADERS, "Рынок", listitems, "Купить", "Назад");
}

stock ShowMarketMyItems(playerid, content[])
{
	new listitems[4096] = "Предмет\tЦена за 1 шт\tВремя регистрации";
	strcat(listitems, content);
	ShowPlayerDialog(playerid, 1102, DIALOG_STYLE_TABLIST_HEADERS, "Рынок", listitems, "Снять", "Назад");
}

stock GetColorByStoneModifier(value)
{
	new color[32] = "ffffff";
	switch(value)
	{
		case MOD_DAMAGE: color = "FFCC00";
		case MOD_DEFENSE: color = "CC0000";
		case MOD_ACCURACY: color = "3366FF";
		case MOD_DODGE: color = "00CC00";
	}
	return color;
}

stock GetModString(mod[])
{
	new out[255] = "";
	for(new i = 0; i < MAX_MOD; i++)
	{
		if(mod[i] == 0) break;
		new mstr[32];
		format(mstr, sizeof(mstr), " {%s}o", GetColorByStoneModifier(mod[i]));
		strcat(out, mstr);
	}

	if(strlen(out) > 0)
	{
		strdel(out, 0, 1);
		strins(out, "{ffffff}(", 0);
		strcat(out, "{ffffff})");
	}

	return out;
}

stock ShowMarketBuyList(playerid, category)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `marketplace` WHERE `Category` = '%d' ORDER BY `Price` LIMIT %d", category, MAX_MARKET_ITEMS);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	q_result = cache_save();
	cache_unset_active();

	if(row_count <= 0)
	{
		cache_delete(q_result);
		SendClientMessage(playerid, COLOR_GREY, "В этой категории нет лотов.");
		ShowPlayerDialog(playerid, 1103, DIALOG_STYLE_TABLIST, "Рынок", "Оружие\nДоспехи\nГоловные уборы\nОчки\nЧасы\nБижутерия\nРасходные материалы", "Далее", "Назад");
		return;
	}

	new content[4096] = "";
	new buf[255];
	for(new i = 0; i < row_count; i++)
	{
		new item[BaseItem];
		new m_item[MarketItem];

		new m_id = -1;
		cache_set_active(q_result);
		cache_get_value_name_int(i, "ID", m_id);
		cache_unset_active();

		if(m_id == -1)
		{
			print("MySql error in ShowMarketBuyList().");
			SendClientMessage(playerid, COLOR_LIGHTRED, "Произошла ошибка, возврат в меню.");
			ShowMarketMenu(playerid);
			return;
		}

		m_item = GetMarketItemByLotID(m_id);
		item = GetItem(m_item[ID]);

		if(category == MARKET_CATEGORY_MATERIAL)
		{
			format(buf, sizeof(buf), "\n{%s}[%s]{ffffff}[x%d]\t{00CC00}%s$\t{ffffff}%s\t{ffffff}%d",
				GetGradeColor(item[Grade]), item[Name], m_item[Count], FormatMoney(m_item[Price]), m_item[Owner], m_item[rTime]
			);
		}
		else
		{
			format(buf, sizeof(buf), "\n{%s}[%s]%s\t{ffffff}[{%s}%s{ffffff}] {00CC00}%s$\t{ffffff}%s\t{ffffff}%d",
				GetGradeColor(item[Grade]), item[Name], GetModString(m_item[Mod]), GetColorByRank(item[MinRank]), GetRankInterval(item[MinRank]), FormatMoney(m_item[Price]), m_item[Owner], m_item[rTime]
			);
		}

		strcat(content, buf);
	}

	cache_delete(q_result);
	ShowMarketSellingItems(playerid, category, content);
}

stock ShowMarketMyLotList(playerid)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `marketplace` WHERE `Owner` = '%s' ORDER BY `Time` LIMIT %d", PlayerInfo[playerid][Name], MAX_MARKET_ITEMS);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	q_result = cache_save();
	cache_unset_active();

	if(row_count <= 0)
	{
		cache_delete(q_result);
		SendClientMessage(playerid, COLOR_GREY, "Не зарегистрировано ни одного предмета.");
		ShowMarketMenu(playerid);
		return;
	}

	new content[2048] = "";
	new buf[255];
	for(new i = 0; i < row_count; i++)
	{
		new item[BaseItem];
		new m_item[MarketItem];

		new m_id = -1;
		cache_set_active(q_result);
		cache_get_value_name_int(i, "ID", m_id);
		cache_unset_active();

		if(m_id == -1)
		{
			print("MySql error in ShowMarketMyLotList().");
			SendClientMessage(playerid, COLOR_LIGHTRED, "Произошла ошибка, возврат в меню.");
			ShowMarketMenu(playerid);
			return;
		}

		m_item = GetMarketItemByLotID(m_id);
		item = GetItem(m_item[ID]);

		format(buf, sizeof(buf), "\n{%s}[%s]{ffffff}[x%d]\t{00CC00}%s$\t{ffffff}%d",
			GetGradeColor(item[Grade]), item[Name], m_item[Count], FormatMoney(m_item[Price]), m_item[rTime]
		);

		strcat(content, buf);
	}

	cache_delete(q_result);
	ShowMarketMyItems(playerid, content);
}

stock GiveTourRates(tour)
{
	for(new i = 0; i < TourParticipantsCount; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) break;

		new down_mid_rate = 0;
		for(new j = i + 1; j < TourParticipantsCount; j++)
			down_mid_rate += PlayerInfo[PvpInfo[j][ID]][Rate];
		
		if(down_mid_rate == 0)
			down_mid_rate = PlayerInfo[PvpInfo[i][ID]][Rate];
		
		new divider = TourParticipantsCount - i - 1;
		if(divider <= 0)
			divider = 1;
		down_mid_rate /= divider;

		new up_mid_rate = 0;
		if(i > 0)
		{
			for(new j = 0; j < i; j++)
				up_mid_rate += PlayerInfo[PvpInfo[j][ID]][Rate];
			
			up_mid_rate /= i;
		}

		if(up_mid_rate == 0)
			up_mid_rate = PlayerInfo[PvpInfo[i][ID]][Rate];

		new rate = GetRateDifference(id, tour, i+1, up_mid_rate, down_mid_rate);
		PvpInfo[i][RateDiff] = rate;

		if(IsPlayerConnected(id) && !FCNPC_IsValid(id))
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
		case 1: money = 400;
		case 2: money = 320; 
		case 3: money = 240;
		case 4..5: money = 140;
		case 6..8: money = 120;
		case 9..12: money = 80;
		case 13..16: money = 40;
		case 17..20: money = 20;
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
					SendClientMessage(id, COLOR_GREY, "Инвентарь полон, награды отправлены на почту.");
					PendingItem(PvpInfo[i][Name], reward[ItemID], MOD_CLEAR, reward[ItemsCount], "Награда за тур");
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
				PendingItem(PvpInfo[i][Name], reward[ItemID], MOD_CLEAR, reward[ItemsCount], "Награда за тур");
			if(reward[Money] > 0)
				GivePlayerMoneyOffline(PvpInfo[i][Name], reward[Money]);
		}
	}
}

stock AddPlayerMoney(playerid, money)
{
	new tax = money / 99;
	money -= tax;

	new string[255];
	format(string, sizeof(string), "Получено %s$.", FormatMoney(money));
	SendClientMessage(playerid, 0x00CC00FF, string);

	PlayerInfo[playerid][Cash] += money;
	GivePlayerMoney(playerid, money);
	GivePatriarchMoney(tax);
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
		format(string, sizeof(string), "У вас есть новые письма [%d].", row_count);
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

	new listitems[2048] = "Сообщение\tВложения\tКоличество";
	new string[255];
	for(new i = 0; i < row_count; i++)
	{
		cache_set_active(q_result);
		new reward[RewardInfo];
		new text[255];
		cache_get_value_name(i, "Text", text);
		cache_get_value_name_int(i, "ItemID", reward[ItemID]);
		cache_get_value_name_int(i, "Count", reward[ItemsCount]);
		cache_unset_active();

		if(strlen(text) <= 0)
			format(text, sizeof(text), "-");

		if(reward[ItemID] != -1)
		{
			new item[BaseItem];
			item = GetItem(reward[ItemID]);
			format(string, sizeof(string), "\n{ffffff}%s\t{%s}%s\t{ffffff}%d", text, GetGradeColor(item[Grade]), item[Name], reward[ItemsCount]);
		}
		else
			format(string, sizeof(string), "\n{ffffff}%s\t{ffffff}-\t-", text);

		strcat(listitems, string);
	}
	cache_delete(q_result);
	
	if(row_count == 0)
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Почта", "Новых писем нет.", "Закрыть", "");
	else
		ShowPlayerDialog(playerid, 900, DIALOG_STYLE_TABLIST_HEADERS, "Почта", listitems, "Получить", "Закрыть");
}

stock ClaimMail(playerid, num)
{
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

	new string[255];
	new mod[MAX_MOD];
	cache_get_value_name(num, "ItemMod", string);
	sscanf(string, "a<i>[7]", mod);

	cache_delete(q_result);

	if(reward[ItemID] != -1 && IsInventoryFull(playerid))
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Почта", "Инвентарь полон.", "Закрыть", "");
		return;
	}

	if(reward[ItemID] != -1)
	{
		if(IsEquip(reward[ItemID]))
			AddEquip(playerid, reward[ItemID], mod);
		else
			AddItem(playerid, reward[ItemID], reward[ItemsCount]);
	}

	if(p_id == -1) return;
	new s_query[255];
	format(s_query, sizeof(s_query), "DELETE FROM `pendings` WHERE `PendingID` = '%d'", p_id);
	new Cache:result = mysql_query(sql_handle, s_query);
	cache_delete(result);

	SendClientMessage(playerid, COLOR_GREEN, "Письмо прочитано.");
}

stock UpdateTourParticipants()
{
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
		Tournament[ParticipantsIDs][i] = -1;

	if(Tournament[Tour] == 1)
	{
		new query[255];
        format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` <> 'Admin' AND `IsWatcher`=0 LIMIT %d", MAX_PARTICIPANTS);
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
		new ejected_count = is_bns_mode > 0 ? 5 : 4;
		new p_count = MAX_PARTICIPANTS - (ejected_count * (Tournament[Tour]-1));
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
		
		format(query, sizeof(query), "INSERT INTO `tournament_tab`(`ID`, `Name`, `Score`, `Kills`, `Deaths`, `Owner`, `RateDiff`) VALUES ('%d','%s','%d','%d','%d','%s','%d')",
			PlayerInfo[id][ID], PlayerInfo[id][Name], PvpInfo[i][Score], PvpInfo[i][Kills], PvpInfo[i][Deaths], PlayerInfo[id][Owner], PvpInfo[i][RateDiff]
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
		if(IsPlayerInRangeOfPoint(i,3.0,204.7617,-1831.6539,4.1772) && (IsTourParticipant(PlayerInfo[i][ID]) || PlayerInfo[i][IsWatcher] != 0))
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
	{
		if(!IsPlayerConnected(i)) continue;
		if(IsPlayerInRangeOfPoint(i, range, x, y, z)) count++;
	}

	if(count >= max_count) return true;
	return false;
}

stock GetRateDifference(playerid, tour, pos, up_mid_rate, down_mid_rate)
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
				case 1: rate = 32;
				case 2: rate = 28;
				case 3: rate = 25;
				case 4: rate = 22;
				case 5: rate = 17;
				case 6: rate = 14;
				case 7: rate = 11;
				case 8: rate = 6;
				case 9: rate = 1;
				case 10: rate = -2;
				case 11: rate = -4;
				case 12: rate = -7;
				case 13: rate = -11;
				case 14: rate = -14;
				case 15: rate = -16;
				case 16: rate = -20;
			}
		}
		case 3:
		{
			switch(pos)
			{
				case 1: rate = 36;
				case 2: rate = 34;
				case 3: rate = 32;
				case 4: rate = 26;
				case 5: rate = 20;
				case 6: rate = 14;
				case 7: rate = 7;
				case 8: rate = -1;
				case 9: rate = -4;
				case 10: rate = -7;
				case 11: rate = -11;
				case 12: rate = -15;
			}
		}
		case 4:
		{
			switch(pos)
			{
				case 1: rate = 40;
				case 2: rate = 37;
				case 3: rate = 34;
				case 4: rate = 28;
				case 5: rate = 20;
				case 6: rate = 6;
				case 7: rate = -4;
				case 8: rate = -10;
			}
		}
		case 5:
		{
			switch(pos)
			{
				case 1: rate = 50;
				case 2: rate = 35;
				case 3: rate = 20;
				case 4: rate = 0;
			}
		}
	}

	new up_rate_diff = up_mid_rate - PlayerInfo[playerid][Rate];
	new down_rate_diff = down_mid_rate - PlayerInfo[playerid][Rate];
	if(down_rate_diff > 0)
		rate += down_rate_diff / 20;
	if(up_rate_diff < 0)
		rate += up_rate_diff / 25;

	if(rate > 65) rate = 65;
	if(rate < -65) rate = -65;

	return rate;
}

stock SetPvpTableVisibility(playerid, bool:value)
{
	if(value)
	{
		PlayerTextDrawShow(playerid, PvpPanelBox[playerid]);
		PlayerTextDrawShow(playerid, PvpPanelHeader[playerid]);
		PlayerTextDrawShow(playerid, PvpPanelTimer[playerid]);
		for(new i = 0; i < MAX_PVP_PANEL_ITEMS; i++)
		{
			PlayerTextDrawSetStringRus(playerid, PvpPanelNameLabels[playerid][i], " ");
			PlayerTextDrawSetStringRus(playerid, PvpPanelScoreLabels[playerid][i], " ");
			PlayerTextDrawShow(playerid, PvpPanelNameLabels[playerid][i]);
			PlayerTextDrawShow(playerid, PvpPanelScoreLabels[playerid][i]);
		}

		if(PlayerInfo[playerid][IsWatcher] <= 0)
		{
			PlayerTextDrawShow(playerid, PvpPanelDelim[playerid]);
			PlayerTextDrawColor(playerid, PvpPanelMyName[playerid], HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
			PlayerTextDrawShow(playerid, PvpPanelMyName[playerid]);
			PlayerTextDrawShow(playerid, PvpPanelMyScore[playerid]);
		}
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
		case 312:
		{
			switch(chance)
			{
				case 0..1299: { itemid = 291; count = 2; }
				case 1300..2599: { itemid = 292; count = 2; }
				case 2600..3899: { itemid = 293; count = 2; }
				case 3900..5199: { itemid = 294; count = 2; }
				case 5200..6499: { itemid = 295; count = 2; }
				case 6500..7799: { itemid = 296; count = 2; }
				case 7800..8199: { itemid = 286; count = 1; }
				case 8200..8299: { itemid = GetKeyByRank(rank, GRADE_N); count = 1; }
				case 8300..8699: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_WEAPON, GRADE_N); count = 1; }
				case 8700..9099: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_ARMORHAT, GRADE_N); count = 1; }
				case 9100..9299: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_WEAPON, GRADE_B); count = 1; }
				case 9300..9499: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_ARMORHAT, GRADE_B); count = 1; }
				case 9500..9799: { itemid = 290; count = 1; }
				case 9800..9889: { itemid = 287; count = 1; }
				case 9890..9899: { itemid = 288; count = 1; }
				default: { itemid = 306; count = 1; }
			}
		}
		case 313:
		{
			switch(chance)
			{
				case 0..1199: { itemid = 291; count = 5; }
				case 1200..2399: { itemid = 292; count = 5; }
				case 2400..3599: { itemid = 293; count = 5; }
				case 3600..4799: { itemid = 294; count = 5; }
				case 4800..5999: { itemid = 295; count = 5; }
				case 6000..7199: { itemid = 296; count = 5; }
				case 7200..7599: { itemid = 286; count = 2; }
				case 7600..7699: { itemid = GetKeyByRank(rank, GRADE_B); count = 1; }
				case 7700..8099: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_WEAPON, GRADE_N); count = 1; }
				case 8100..8499: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_ARMORHAT, GRADE_N); count = 1; }
				case 8500..8699: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_WEAPON, GRADE_B); count = 1; }
				case 8700..8899: { itemid = GetRandomEquip(rank, rank, RND_EQUIP_TYPE_ARMORHAT, GRADE_B); count = 1; }
				case 8900..9299: { itemid = 290; count = 2; }
				case 9300..9469: { itemid = 287; count = 1; }
				case 9470..9499: { itemid = 288; count = 1; }
				case 9500..9599: { itemid = GetRandomWatch(rank, rank); count = 1; }
				case 9600..9679: { itemid = 305; count = 1; }
				case 9680..9699: { itemid = 307; count = 1; }
				case 9700: { itemid = 289; count = 1; }
				default: { itemid = 306; count = 2; }
			}
		}
		case 314:
		{
			count = 1;
			switch(chance)
			{
				case 0..3999: itemid = 321 + 6 * random(3);
				case 4000..6999: itemid = 322 + 6 * random(3);
				case 7000..8299: itemid = 323 + 6 * random(3);
				case 8300..8999: itemid = 324 + 6 * random(3);
				case 9000..9599: itemid = 325 + 6 * random(3);
				default: itemid = 326 + 6 * random(3);
			}
		}
		case 315:
		{
			count = 1;
			switch(chance)
			{
				case 0..3999: itemid = 339 + 5 * random(3);
				case 4000..6999: itemid = 340 + 5 * random(3);
				case 7000..8299: itemid = 341 + 5 * random(3);
				case 8300..9199: itemid = 342 + 5 * random(3);
				default: itemid = 343 + 5 * random(3);
			}
		}
		case 316:
		{
			count = 1;
			switch(chance)
			{
				case 0..5999: itemid = 354 + 4 * random(3);
				case 6000..9499: itemid = 355 + 4 * random(3);
				case 9500..9899: itemid = 356 + 4 * random(3);
				default: itemid = 357 + 4 * random(3);
			}
		}
		case 317:
		{
			count = 1;
			itemid = 209 + random(7);
		}
		case 318:
		{
			count = 1;
			itemid = 216 + random(7);
		}
		case 319:
		{
			count = 1;
			itemid = 223 + random(14);
		}
		case 320:
		{
			count = 1;
			switch(chance)
			{
				case 0..1499: itemid = 287;
				case 1500..1699: itemid = 288;
				case 1700..1704: itemid = 289;
				default: itemid = 286;
			}
		}
		case 367:
		{
			count = 1;
			switch(chance)
			{
				case 0..2499: { itemid = 320; count = 5; }
				case 2500..3999: itemid = 314;
				case 4000..4799: itemid = 315;
				case 4800..5199: itemid = 316;
				case 5200..7999: { itemid = 313; count = 5; }
				case 8000..8999: itemid = 288;
				default: itemid = GetRandomShazokPart(rank);
			}
		}
		case 368:
		{
			count = 1;
			switch(chance)
			{
				case 0..3499: { itemid = 320; count = random(3) + 1; }
				case 3500..4199: itemid = 314;
				case 4200..4299: itemid = 315;
				case 4300..4349: itemid = 316;
				case 4350..4999: itemid = 369;
				case 5000..8999: { itemid = 370; count = 3; }
				case 9000..9399: itemid = 288;
				default: { itemid = 287; count = 10; }
			}
		}
		case 369:
		{
			count = 1;
			switch(chance)
			{
				case 0..3499: { itemid = 320; count = random(2) + 1; }
				case 3500..4699: itemid = 314;
				case 4700..5099: itemid = 315;
				case 5100..5199: itemid = 316;
				case 5200..8999: { itemid = 370; count = 2; }
				case 9000..9399: itemid = 288;
				default: itemid = GetRandomShazokPart(rank);
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
	format(string, sizeof(string), "Получено: {%s}[%s] {ffffff}x%d.", 
		GetGradeColor(item[Grade]), item[Name], count
	);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
}

stock SwitchToWatcher(playerid)
{
	if(PlayerInfo[playerid][IsWatcher] != 0)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Вы уже переключились на наблюдателя.");
		return;
	}

	new query[512];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` = '%s' AND `IsWatcher` > 0 LIMIT 1", AccountLogin[playerid]);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		cache_delete(q_result);
		ShowPlayerDialog(playerid, 1002, DIALOG_STYLE_MSGBOX, "Наблюдатель", "{ffffff}На вашем аккаунте отсутствует наблюдатель.\nСоздать его и переключиться?", "Да", "Нет");
		return;
	}

	new name[255];
	cache_get_value_name(0, "Name", name);
	cache_delete(q_result);

	if(PlayerConnect[playerid])
		OnPlayerDisconnect(playerid, 1);
	SetPlayerName(playerid, name);
	IsParticipant[playerid] = false;
	LoadPlayer(playerid);
	OnPlayerLogin(playerid);
}

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

stock HideAllWindows(playerid)
{
	HideCharInfo(playerid);
	HideEquipInfo(playerid);
	HideItemInfo(playerid);
	HideModWindow(playerid);
	HideCmbWindow(playerid);
	HideMarketSellWindow(playerid);
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

stock SetPlayerTourTeam(playerid, team)
{
	if(playerid == -1 || playerid == INVALID_PLAYER_ID)
		return;

	TourTeam[playerid] = team;
}

stock GetPlayerTourTeam(playerid)
{
	if(playerid == -1 || playerid == INVALID_PLAYER_ID)
		return NO_TEAM;

	return TourTeam[playerid];
}

stock ExplodeNuclearBomb(team)
{
	IsNuclearBombExplodes = true;

	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) continue;
		if(FCNPC_IsDead(id) || GetPlayerHP(id) <= 0) continue;

		new p_team = GetPlayerTourTeam(id);
		if(p_team != NO_TEAM && team != p_team)
			SetPlayerHPPercent(id, 1);
	}

	IsNuclearBombExplodes = false;
}

stock HealAllTeam(team)
{
	IsTeamHealing = true;

	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) continue;
		if(FCNPC_IsDead(id) || GetPlayerHP(id) <= 0) continue;

		new p_team = GetPlayerTourTeam(id);
		if(p_team != NO_TEAM && team == p_team)
		{
			SetPVarFloat(id, "HP", MaxHP[id]);
			SetPlayerHP(id, MaxHP[id]);
		}
	}

	IsTeamHealing = false;
}

stock ResetAllTeamTargets(team)
{
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) continue;
		if(FCNPC_IsDead(id) || GetPlayerHP(id) <= 0) continue;

		new p_team = GetPlayerTourTeam(id);
		if(p_team != NO_TEAM && team != p_team)
		{
			if(FCNPC_IsValid(id))
				ResetPlayerTarget(id);
			else
				TogglePlayerControllable(id, 0);
		}
	}
}

stock SetAllTeamInvulnearable(team, second)
{
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) continue;

		new p_team = GetPlayerTourTeam(id);
		if(p_team != NO_TEAM && team == p_team)
			SetPlayerInvulnearable(id, second);
	}
}

stock FindPlayerNearestTarget(npcid)
{
	if(npcid == -1) return -1;
	if(SpecialAbilityEffect == SPECIAL_AB_EFFECT_CONFUSION && GetPlayerTourTeam(npcid) != NO_TEAM && GetPlayerTourTeam(npcid) != SpecialAbilityEffectTeam) return -1;

	new targetid = -1;
	new Float:min_dist = 10000;

	for (new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new id = PvpInfo[i][ID];
		if(id == -1) continue;
		if(npcid == id) continue;
		if(FCNPC_IsDead(id) || GetPlayerHP(id) <= 0) continue;
		if(GetPlayerTourTeam(id) != NO_TEAM && GetPlayerTourTeam(npcid) == GetPlayerTourTeam(id))
			continue;
		
		new invulnearable = GetPVarInt(id, "Invulnearable");
		if(invulnearable > 0)
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
	if(npcid == -1) return -1;
	if(SpecialAbilityEffect == SPECIAL_AB_EFFECT_CONFUSION && GetPlayerTourTeam(npcid) != NO_TEAM && GetPlayerTourTeam(npcid) != SpecialAbilityEffectTeam) return -1;

	new targetid = -1;
	new nearest_targets[MAX_RELIABLE_TARGETS];
	new targets_count = 0;
	new Float:distances[MAX_PARTICIPANTS];
	new Float:available_dist = 0;

	for(new i = 0; i < MAX_RELIABLE_TARGETS; i++)
		nearest_targets[i] = -1;
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
		distances[i] = 1000.0;

	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		if(PvpInfo[i][ID] == -1) continue;
		if(npcid == PvpInfo[i][ID]) continue;
		if(FCNPC_IsDead(PvpInfo[i][ID]) || GetPlayerHP(PvpInfo[i][ID]) <= 0) continue;
		distances[i] = GetDistanceBetweenPlayers(npcid, PvpInfo[i][ID]);
	}
	
	SortArrayAscending(distances);
	available_dist = distances[MAX_RELIABLE_TARGETS-1];

    for(new i = 0; i < MAX_PARTICIPANTS; i++) 
	{
		if(PvpInfo[i][ID] == -1) continue;
		if(PvpInfo[i][ID] == npcid || FCNPC_IsDead(PvpInfo[i][ID]))
			continue;
		if(GetPlayerTourTeam(PvpInfo[i][ID]) != NO_TEAM && GetPlayerTourTeam(npcid) == GetPlayerTourTeam(PvpInfo[i][ID]))
			continue;
		if(!FCNPC_IsValid(PvpInfo[i][ID]) && !IsPlayerInDynamicArea(PvpInfo[i][ID], arena_area))
			continue;

		new invulnearable = GetPVarInt(PvpInfo[i][ID], "Invulnearable");
		if(invulnearable > 0)
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

	for(new i = 0; i < MAX_RELIABLE_TARGETS; i++)
	{
		new Float:min_hp = 50001;
		if(nearest_targets[i] == -1)
			break;
		
		new Float:hp = FCNPC_GetHealth(nearest_targets[i]);
		if(hp < min_hp)
			targetid = nearest_targets[i];
	}

	return targetid;
}

stock GetAimingPlayersCount(playerid)
{
	new count = 0;
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new part_id = PvpInfo[i][ID];
		if(part_id == -1 || part_id == playerid || GetPlayerTourTeam(playerid) == GetPlayerTourTeam(part_id))
			continue;
		if(FCNPC_IsValid(part_id))
		{
			if(FCNPC_GetAimingPlayer(part_id) == playerid)
				count++;
		}
		else
		{
			if(GetPlayerTargetPlayer(part_id) == playerid)
				count++;
		}
	}
	return count;
}

stock TryFindCommonTarget(playerid, current_target)
{
	new target = current_target;
	new max_aimers = 0;

	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		new part_id = PvpInfo[i][ID];
		if(part_id == -1 || part_id == playerid || GetPlayerTourTeam(playerid) == GetPlayerTourTeam(part_id))
			continue;

		if(FCNPC_IsDead(part_id) || GetPlayerHP(part_id) <= 0) continue;

		new invulnearable = GetPVarInt(part_id, "Invulnearable");
		if(invulnearable > 0)
			continue;
		
		if(GetDistanceBetweenPlayers(playerid, part_id) > 15.0)
			continue;
		
		new aimers = GetAimingPlayersCount(part_id);
		if(aimers > max_aimers)
		{
			max_aimers = aimers;
			target = part_id;
		}
	}

	if(target != current_target)
	{
		SetPlayerTarget(playerid, target);
		return 1;
	}

	return -1;
}

stock ResetPlayerTarget(playerid)
{
	if(FCNPC_IsAiming(playerid))
		FCNPC_StopAim(playerid);

	SetPVarInt(playerid, "FixTargetID", -1);

	if(!FCNPC_IsMoving(playerid))
		MoveAround(playerid);
}

stock SetPlayerTarget(playerid, target = -1)
{
	if(FCNPC_IsAiming(playerid))
		FCNPC_StopAim(playerid);
	new targetid;
	if(SpecialAbilityEffect == SPECIAL_AB_EFFECT_CONFUSION && GetPlayerTourTeam(playerid) != NO_TEAM && GetPlayerTourTeam(playerid) != SpecialAbilityEffectTeam)
		targetid = -1;
	else if(target == -1)
	{
		SetPVarInt(playerid, "FixTargetID", -1);
		targetid = FindPlayerTarget(playerid, true);
	}
	else
		targetid = target;

	if(targetid == -1)
	{
		if(!FCNPC_IsMoving(playerid))
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
	new targetid = FindBossTarget(playerid);

	if(targetid == -1)
	{
		MoveAround(playerid);
		return;
	}

	new cur_target = FCNPC_GetAimingPlayer(playerid);
	if(cur_target == targetid)
		return;

	if(FCNPC_IsAiming(playerid))
		FCNPC_StopAim(playerid);
	if(!FCNPC_IsAiming(playerid))
		FCNPC_AimAtPlayer(playerid, targetid, false);
	if(!FCNPC_IsMoving(playerid))
		FCNPC_GoToPlayer(playerid, targetid);
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

	if(FCNPC_IsAiming(playerid))
		FCNPC_StopAim(playerid);
		
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
	ResetPlayerVariables(BossNPC);
	BossNPC = -1;

	for(new i = 0; i < MAX_PLAYERS; i++)
		IsBossAttacker[i] = false;
	BossAttackersCount = 0;
	AttackedBoss = -1;
	print("Boss destroyed.");
}

stock GetAvailableDungeonsList(playerid)
{
	new listitems[2048] = "";
	new min_id = 383;
	new max_id = 426;

	new query[255];
	new Cache:q_result;
	new itemid = 0;
	new string[64];

	for(new i = 0; i < MAX_DUNGEONS; i++)
		AvailableDungeons[playerid][i] = -1;

	for(new cur_id = min_id; cur_id <= max_id; cur_id++)
	{
		if(!HasItem(playerid, cur_id, 1)) continue;

		new keys_count = GetItemsCount(playerid, cur_id);
		new dungeon_id = -1;
		new dungeon_rank = 1;
		new dungeon_type = 1;

		format(query, sizeof(query), "SELECT * FROM `dungeons` WHERE `KeyID` = %d LIMIT 1", cur_id);
		q_result = mysql_query(sql_handle, query);

		new row_count = 0;
		cache_get_row_count(row_count);
		if(row_count <= 0)
		{
			cache_delete(q_result);
			return listitems;
		}

		cache_get_value_name_int(0, "ID", dungeon_id);
		cache_get_value_name_int(0, "Rank", dungeon_rank);
		cache_get_value_name_int(0, "Type", dungeon_type);

		cache_delete(q_result);

		AvailableDungeons[playerid][itemid] = dungeon_id;
		itemid++;

		format(string, sizeof(string), "\n{%s}Территория войны [%d]\t{ffffff}%d", GetGradeColor(dungeon_type), dungeon_rank, keys_count);
		strcat(listitems, string);
	}
	
	new header[32] = "Имя\tКлючей";
	if(itemid > 0) strins(listitems, header, 0);

	return listitems;
}

stock EnterToDungeon(playerid, dungeonid)
{
	new dungeon[BaseDungeon];
	dungeon = GetDungeon(dungeonid);

	new slotid = FindItem(playerid, dungeon[KeyID]);
	if(slotid == -1) return;

	DeleteItem(playerid, slotid, 1);
	SetPVarInt(playerid, "ActiveDungeon", dungeonid);
	SetPVarInt(playerid, "DungeonEnemiesKilled", 0);
	SetPVarInt(playerid, "DungeonEnemiesRequired", dungeon[MobsCount] + dungeon[BossesCount]);
	
	new worldid = 1001 + playerid;

	FillDungeon(playerid, dungeonid, worldid);
	TeleportToDungeon(playerid, worldid);

	SendClientMessage(playerid, COLOR_WHITE, "Вы попали на территорию войны.");
	SendClientMessage(playerid, COLOR_YELLOW, "Убейте всех врагов чтобы получить награду!");
}

stock FillDungeon(playerid, dungeonid, worldid)
{
	new dungeon[BaseDungeon];
	dungeon = GetDungeon(dungeonid);

	for(new i = 0; i < MAX_PLAYERS; i++)
		PlayerDungeon[playerid][Mobs][i] = -1;
	for(new i = 0; i < MAX_PLAYERS; i++)
		PlayerDungeon[playerid][Bosses][i] = -1;

	for(new i = 0; i < dungeon[MobsCount]; i++)
	{
		new mob_type = random(dungeon[MobsTypesCount]);
		new mobid = dungeon[Mobs][mob_type];
		if(mobid == -1) continue;
		
		new walker[wInfo];
		walker = GetWalker(mobid);

		new npc_name[255];
		npc_name = ResolveMobName(mobid);

		new suffix[8];
		format(suffix, sizeof(suffix), "_%d_%d", i+1, playerid);
		strcat(npc_name, suffix);

		new npcid = FCNPC_Create(npc_name);
		PlayerDungeon[playerid][Mobs][i] = npcid;
		ResetPlayerVariables(npcid);

		IsDungeonMob[npcid] = true;
		MaxHP[npcid] = walker[HP];
		SetPlayerMaxHP(npcid, walker[HP], false);

		PlayerInfo[npcid][Rank] = mobid;
		PlayerInfo[npcid][DamageMin] = dungeon[Damage];
		PlayerInfo[npcid][DamageMax] = dungeon[Damage];
		PlayerInfo[npcid][Defense] = dungeon[Defense];
		PlayerInfo[npcid][Dodge] = walker[Dodge];
		PlayerInfo[npcid][Accuracy] = walker[Accuracy];
		PlayerInfo[npcid][Crit] = walker[Crit];
		PlayerInfo[npcid][Sex] = 0;
		PlayerInfo[npcid][Skin] = walker[Skin];
		PlayerInfo[npcid][WeaponSlotID] = 31;

		SetPlayerColor(npcid, HexRateColors[mobid-1][0]);
		ShowNPCInTabList(npcid);

		FCNPC_Spawn(npcid, walker[Skin], 0, 0, 0);
		SetRandomMobPos(npcid);
		FCNPC_SetInvulnerable(npcid, false);
		FCNPC_SetInterior(npcid, 0);
		FCNPC_SetVirtualWorld(npcid, worldid);
		UpdatePlayerWeapon(npcid);
		SetMobDestPoint(npcid);
	}

	for(new i = 0; i < dungeon[BossesCount]; i++)
	{
		new boss_type = random(dungeon[BossesTypesCount]);
		new bossid = dungeon[Bosses][boss_type];
		if(bossid == -1) continue;

		new boss[BossInfo];
		boss = GetBoss(bossid);

		new npc_name[64];
		format(npc_name, sizeof(npc_name), "%s_%d_%d", BossesNames[bossid], i+1, playerid);

		new npcid = FCNPC_Create(npc_name);
		PlayerDungeon[playerid][Bosses][i] = npcid;
		PlayerDungeon[playerid][BossesIds][npcid] = bossid;
		ResetPlayerVariables(npcid);

		SetPlayerColor(npcid, 0x990099FF);
		ShowNPCInTabList(npcid); 
		FCNPC_SetInvulnerable(npcid, false);

		IsDungeonBoss[npcid] = true;
		PlayerInfo[npcid][DamageMin] = boss[DamageMin];
		PlayerInfo[npcid][DamageMax] = boss[DamageMax];
		PlayerInfo[npcid][Defense] = boss[Defense];
		PlayerInfo[npcid][Dodge] = boss[Dodge];
		PlayerInfo[npcid][Accuracy] = boss[Accuracy];
		PlayerInfo[npcid][Crit] = DEFAULT_CRIT;
		PlayerInfo[npcid][Sex] = 0;
		PlayerInfo[npcid][Skin] = BossesSkins[bossid][0];
		PlayerInfo[npcid][WeaponSlotID] = BossesWeapons[bossid][0];

		FCNPC_Spawn(npcid, PlayerInfo[npcid][Skin], 0, 0, 0);
		SetRandomMobPos(npcid);
		SetPlayerMaxHP(npcid, boss[HP], false);
		SetPVarFloat(npcid, "HP", boss[HP]);
		SetPlayerHP(npcid, boss[HP]);
		SetPlayerSkills(npcid);
		FCNPC_SetInterior(npcid, 0);
		FCNPC_SetVirtualWorld(npcid, worldid);

		UpdatePlayerSkin(npcid);
		UpdatePlayerWeapon(npcid);
		SetMobDestPoint(npcid);
	}

	PlayerDungeon[playerid][PortalLabel] = Create3DTextLabel("Дом Клоунов",0xeaeaeaFF,-66.2243,1516.9169,12.9772,100.0,worldid,1);
}

stock CompleteDungeon(playerid, bool:is_win)
{
	if(!IsPlayerInDungeon(playerid)) return;

	new dungeonid = GetPVarInt(playerid, "ActiveDungeon");
	if(is_win)
	{
		SendClientMessage(playerid, COLOR_GREEN, "Победа! Территория войны пройдена.");
		SendClientMessage(playerid, COLOR_WHITE, "Чтобы вернуться домой воспользуйтесь порталом или меню N.");
		SetPVarInt(playerid, "TeleportCooldown", 0);
		ClaimDungeonReward(playerid, dungeonid);
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "Поражение. Территория войны закрыта.");
		DestroyDungeon(playerid);
	}

	SetPVarInt(playerid, "ActiveDungeon", -1);
	SetPVarInt(playerid, "DungeonEnemiesKilled", 0);
	SetPVarInt(playerid, "DungeonEnemiesRequired", 0);
}

stock DestroyDungeon(playerid)
{
	Delete3DTextLabel(PlayerDungeon[playerid][PortalLabel]);
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		new id = PlayerDungeon[playerid][Mobs][i];
		if(id == -1 || id == playerid) continue;
		if(!FCNPC_IsValid(id)) continue;

		FCNPC_Destroy(id);
		IsDungeonMob[id] = false;
		ResetPlayerVariables(id);
		ResetDungeonLoot(id);
		PlayerDungeon[playerid][Mobs][i] = -1;
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		new id = PlayerDungeon[playerid][Bosses][i];
		if(id == -1 || id == playerid) continue;
		if(!FCNPC_IsValid(id)) continue;

		FCNPC_Destroy(id);
		IsDungeonBoss[id] = false;
		ResetPlayerVariables(id);
		ResetDungeonLoot(id);
		PlayerDungeon[playerid][Bosses][i] = -1;
	}
}

stock ClaimDungeonReward(playerid, dungeonid)
{
	new chance = random(10001);
	new itemid = -1;
	new count = 0;

	switch(dungeonid)
	{
		case 0:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(1, 1, RND_EQUIP_TYPE_RANDOM, GRADE_B); count = 1; }
				case 1000..1499: { itemid = 200; count = 1; } //часы
				case 1500..1999: { itemid = 317; count = 1; } //коробка с бижутерией низкого качества
				case 2000..4699: { itemid = 320; count = 1; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 1; } //золотой слиток
				case 4800..5299: { itemid = 387; count = 1; } //ключ N
				case 5300..5599: { itemid = 384; count = 1; } //ключ B
				default: { itemid = 290; count = 10; } //усилитель
			}
		}
		case 1:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(1, 1, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1499: { itemid = 200; count = 1; } //часы
				case 1500..1999: { itemid = 317; count = 1; } //коробка с бижутерией низкого качества
				case 2000..4699: { itemid = 320; count = 2; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 1; } //золотой слиток
				case 4800..5299: { itemid = 388; count = 1; } //ключ B
				case 5300..5599: { itemid = 385; count = 1; } //ключ C
				case 5600..5899: { itemid = 191; count = 1; } //очки
				case 5900..6099: { itemid = 288; count = 1; } //эликсир удачи мастера
				default: { itemid = 290; count = 20; } //усилитель
			}
		}
		case 2:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(1, 1, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1699: { itemid = 200; count = 1; } //часы
				case 1700..2699: { itemid = 317; count = 1; } //коробка с бижутерией низкого качества
				case 2700..5199: { itemid = 320; count = 4; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 2; } //золотой слиток
				case 5300..5799: { itemid = 389; count = 1; } //ключ C
				case 5800..6099: { itemid = 386; count = 1; } //ключ L
				case 6100..6599: { itemid = 191; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 1; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 40; } //усилитель
			}
		}
		case 3:
		{
			switch(chance)
			{
				case 0..999: { itemid = 297; count = 3; } //оружие L
				case 1000..1699: { itemid = 200; count = 1; } //часы
				case 1700..2699: { itemid = 317; count = 1; } //коробка с бижутерией низкого качества
				case 2700..5199: { itemid = 320; count = 8; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 3; } //золотой слиток
				case 5300..5799: { itemid = 389; count = 1; } //ключ C
				case 5800..6099: { itemid = 386; count = 1; } //ключ L
				case 6100..6599: { itemid = 191; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 2; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 80; } //усилитель
			}
		}
		case 4:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(2, 2, RND_EQUIP_TYPE_RANDOM, GRADE_B); count = 1; }
				case 1000..1499: { itemid = 201; count = 1; } //часы
				case 1500..1999: { itemid = 317; count = 1; } //коробка с бижутерией низкого качества
				case 2000..4699: { itemid = 320; count = 1; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 1; } //золотой слиток
				case 4800..5299: { itemid = 391; count = 1; } //ключ N
				case 5300..5599: { itemid = 388; count = 1; } //ключ B
				default: { itemid = 290; count = 20; } //усилитель
			}
		}
		case 5:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(2, 2, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1499: { itemid = 201; count = 1; } //часы
				case 1500..1999: { itemid = 317; count = 2; } //коробка с бижутерией низкого качества
				case 2000..4699: { itemid = 320; count = 3; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 2; } //золотой слиток
				case 4800..5299: { itemid = 392; count = 1; } //ключ B
				case 5300..5599: { itemid = 389; count = 1; } //ключ C
				case 5600..5899: { itemid = 192; count = 1; } //очки
				case 5900..6099: { itemid = 288; count = 1; } //эликсир удачи мастера
				default: { itemid = 290; count = 40; } //усилитель
			}
		}
		case 6:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(2, 2, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1699: { itemid = 201; count = 1; } //часы
				case 1700..2699: { itemid = 317; count = 3; } //коробка с бижутерией низкого качества
				case 2700..5199: { itemid = 320; count = 7; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 3; } //золотой слиток
				case 5300..5799: { itemid = 393; count = 1; } //ключ C
				case 5800..6099: { itemid = 390; count = 1; } //ключ L
				case 6100..6599: { itemid = 192; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 2; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 70; } //усилитель
			}
		}
		case 7:
		{
			switch(chance)
			{
				case 0..999: { itemid = 298; count = 3; } //оружие L
				case 1000..1699: { itemid = 201; count = 1; } //часы
				case 1700..2699: { itemid = 317; count = 4; } //коробка с бижутерией низкого качества
				case 2700..5199: { itemid = 320; count = 11; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 5; } //золотой слиток
				case 5300..5799: { itemid = 393; count = 1; } //ключ C
				case 5800..6099: { itemid = 390; count = 1; } //ключ L
				case 6100..6599: { itemid = 192; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 3; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 110; } //усилитель
			}
		}
		case 8:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(3, 3, RND_EQUIP_TYPE_RANDOM, GRADE_B); count = 1; }
				case 1000..1499: { itemid = 202; count = 1; } //часы
				case 1500..1999: { itemid = 317; count = 1; } //коробка с бижутерией низкого качества
				case 2000..4699: { itemid = 320; count = 2; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 2; } //золотой слиток
				case 4800..5299: { itemid = 395; count = 1; } //ключ N
				case 5300..5599: { itemid = 392; count = 1; } //ключ B
				default: { itemid = 290; count = 30; } //усилитель
			}
		}
		case 9:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(3, 3, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1499: { itemid = 202; count = 1; } //часы
				case 1500..1999: { itemid = 317; count = 2; } //коробка с бижутерией низкого качества
				case 2000..4699: { itemid = 320; count = 4; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 3; } //золотой слиток
				case 4800..5299: { itemid = 396; count = 1; } //ключ B
				case 5300..5599: { itemid = 393; count = 1; } //ключ C
				case 5600..5899: { itemid = 193; count = 1; } //очки
				case 5900..6099: { itemid = 288; count = 1; } //эликсир удачи мастера
				default: { itemid = 290; count = 60; } //усилитель
			}
		}
		case 10:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(3, 3, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1699: { itemid = 202; count = 1; } //часы
				case 1700..2699: { itemid = 317; count = 3; } //коробка с бижутерией низкого качества
				case 2700..5199: { itemid = 320; count = 9; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 4; } //золотой слиток
				case 5300..5799: { itemid = 397; count = 1; } //ключ C
				case 5800..6099: { itemid = 394; count = 1; } //ключ L
				case 6100..6599: { itemid = 193; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 2; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 90; } //усилитель
			}
		}
		case 11:
		{
			switch(chance)
			{
				case 0..999: { itemid = 299; count = 3; } //оружие L
				case 1000..1699: { itemid = 202; count = 1; } //часы
				case 1700..2699: { itemid = 317; count = 4; } //коробка с бижутерией низкого качества
				case 2700..5199: { itemid = 320; count = 13; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 6; } //золотой слиток
				case 5300..5799: { itemid = 397; count = 1; } //ключ C
				case 5800..6099: { itemid = 394; count = 1; } //ключ L
				case 6100..6599: { itemid = 193; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 3; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 140; } //усилитель
			}
		}
		case 12:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(4, 4, RND_EQUIP_TYPE_RANDOM, GRADE_B); count = 1; }
				case 1000..1499: { itemid = 203; count = 1; } //часы
				case 1500..1999: { itemid = 317; count = 2; } //коробка с бижутерией низкого качества
				case 2000..4699: { itemid = 320; count = 3; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 3; } //золотой слиток
				case 4800..5299: { itemid = 399; count = 1; } //ключ N
				case 5300..5599: { itemid = 396; count = 1; } //ключ B
				default: { itemid = 290; count = 40; } //усилитель
			}
		}
		case 13:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(4, 4, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1499: { itemid = 203; count = 1; } //часы
				case 1500..1999: { itemid = 317; count = 3; } //коробка с бижутерией низкого качества
				case 2000..4699: { itemid = 320; count = 6; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 4; } //золотой слиток
				case 4800..5299: { itemid = 400; count = 1; } //ключ B
				case 5300..5599: { itemid = 397; count = 1; } //ключ C
				case 5600..5899: { itemid = 194; count = 1; } //очки
				case 5900..6099: { itemid = 288; count = 1; } //эликсир удачи мастера
				default: { itemid = 290; count = 80; } //усилитель
			}
		}
		case 14:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(4, 4, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1699: { itemid = 203; count = 1; } //часы
				case 1700..2699: { itemid = 318; count = 1; } //коробка с бижутерией среднего качества
				case 2700..5199: { itemid = 320; count = 11; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 5; } //золотой слиток
				case 5300..5799: { itemid = 401; count = 1; } //ключ C
				case 5800..6099: { itemid = 398; count = 1; } //ключ L
				case 6100..6599: { itemid = 194; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 2; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 110; } //усилитель
			}
		}
		case 15:
		{
			switch(chance)
			{
				case 0..999: { itemid = 299; count = 5; } //оружие L
				case 1000..1699: { itemid = 203; count = 1; } //часы
				case 1700..2699: { itemid = 318; count = 1; } //коробка с бижутерией среднего качества
				case 2700..5199: { itemid = 320; count = 15; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 6; } //золотой слиток
				case 5300..5799: { itemid = 401; count = 1; } //ключ C
				case 5800..6099: { itemid = 398; count = 1; } //ключ L
				case 6100..6599: { itemid = 194; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 3; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 160; } //усилитель
			}
		}
		case 16:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(5, 5, RND_EQUIP_TYPE_RANDOM, GRADE_B); count = 1; }
				case 1000..1499: { itemid = 204; count = 1; } //часы
				case 1500..1999: { itemid = 318; count = 1; } //коробка с бижутерией среднего качества
				case 2000..4699: { itemid = 320; count = 4; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 4; } //золотой слиток
				case 4800..5299: { itemid = 403; count = 1; } //ключ N
				case 5300..5599: { itemid = 400; count = 1; } //ключ B
				default: { itemid = 290; count = 60; } //усилитель
			}
		}
		case 17:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(5, 5, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1499: { itemid = 204; count = 1; } //часы
				case 1500..1999: { itemid = 318; count = 1; } //коробка с бижутерией среднего качества
				case 2000..4699: { itemid = 320; count = 7; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 5; } //золотой слиток
				case 4800..5299: { itemid = 404; count = 1; } //ключ B
				case 5300..5599: { itemid = 401; count = 1; } //ключ C
				case 5600..5899: { itemid = 195; count = 1; } //очки
				case 5900..6099: { itemid = 288; count = 1; } //эликсир удачи мастера
				default: { itemid = 290; count = 100; } //усилитель
			}
		}
		case 18:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(5, 5, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1699: { itemid = 204; count = 1; } //часы
				case 1700..2699: { itemid = 318; count = 1; } //коробка с бижутерией среднего качества
				case 2700..5199: { itemid = 320; count = 12; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 6; } //золотой слиток
				case 5300..5799: { itemid = 405; count = 1; } //ключ C
				case 5800..6099: { itemid = 402; count = 1; } //ключ L
				case 6100..6599: { itemid = 195; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 2; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 130; } //усилитель
			}
		}
		case 19:
		{
			switch(chance)
			{
				case 0..999: { itemid = 300; count = 3; } //оружие L
				case 1000..1699: { itemid = 204; count = 1; } //часы
				case 1700..2699: { itemid = 318; count = 2; } //коробка с бижутерией среднего качества
				case 2700..5199: { itemid = 320; count = 15; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 7; } //золотой слиток
				case 5300..5799: { itemid = 405; count = 1; } //ключ C
				case 5800..6099: { itemid = 402; count = 1; } //ключ L
				case 6100..6599: { itemid = 195; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 3; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 180; } //усилитель
			}
		}
		case 20:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(6, 6, RND_EQUIP_TYPE_RANDOM, GRADE_B); count = 1; }
				case 1000..1499: { itemid = 205; count = 1; } //часы
				case 1500..1999: { itemid = 318; count = 1; } //коробка с бижутерией среднего качества
				case 2000..4699: { itemid = 320; count = 5; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 5; } //золотой слиток
				case 4800..5299: { itemid = 409; count = 1; } //ключ N
				case 5300..5599: { itemid = 404; count = 1; } //ключ B
				default: { itemid = 290; count = 80; } //усилитель
			}
		}
		case 21:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(6, 6, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1499: { itemid = 205; count = 1; } //часы
				case 1500..1999: { itemid = 318; count = 2; } //коробка с бижутерией среднего качества
				case 2000..4699: { itemid = 320; count = 7; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 6; } //золотой слиток
				case 4800..5299: { itemid = 410; count = 1; } //ключ B
				case 5300..5599: { itemid = 405; count = 1; } //ключ C
				case 5600..5899: { itemid = 196; count = 1; } //очки
				case 5900..6099: { itemid = 288; count = 2; } //эликсир удачи мастера
				default: { itemid = 290; count = 120; } //усилитель
			}
		}
		case 22:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(6, 6, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1699: { itemid = 205; count = 1; } //часы
				case 1700..2699: { itemid = 318; count = 2; } //коробка с бижутерией среднего качества
				case 2700..5199: { itemid = 320; count = 13; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 7; } //золотой слиток
				case 5300..5799: { itemid = 411; count = 1; } //ключ C
				case 5800..6099: { itemid = 406; count = 1; } //ключ L
				case 6100..6599: { itemid = 196; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 3; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 140; } //усилитель
			}
		}
		case 23:
		{
			switch(chance)
			{
				case 0..999: { itemid = 301; count = 3; } //оружие L
				case 1000..1699: { itemid = 205; count = 1; } //часы
				case 1700..2699: { itemid = 318; count = 2; } //коробка с бижутерией среднего качества
				case 2700..5199: { itemid = 320; count = 16; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 8; } //золотой слиток
				case 5300..5799: { itemid = 411; count = 1; } //ключ C
				case 5800..6099: { itemid = 407; count = 1; } //ключ R
				case 6100..6599: { itemid = 196; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 4; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 2; } //коробка со средним модификатором
				default: { itemid = 290; count = 190; } //усилитель
			}
		}
		case 24:
		{
			switch(chance)
			{
				case 0..99: { itemid = 308; count = 1; } //оружие R
				case 100..1199: { itemid = 205; count = 1; } //часы
				case 1200..2199: { itemid = 318; count = 3; } //коробка с бижутерией среднего качества
				case 2200..4899: { itemid = 320; count = 21; } //коробка с эликсиром
				case 4900..5099: { itemid = 427; count = 10; } //золотой слиток
				case 5100..5399: { itemid = 412; count = 1; } //ключ L
				case 5400..5599: { itemid = 408; count = 1; } //ключ S
				case 5600..6399: { itemid = 196; count = 1; } //очки
				case 6400..6799: { itemid = 288; count = 5; } //эликсир удачи мастера
				case 6800..6999: { itemid = 315; count = 3; } //коробка со средним модификатором
				default: { itemid = 290; count = 230; } //усилитель
			}
		}
		case 25:
		{
			switch(chance)
			{
				case 0..99: { itemid = 308; count = 1; } //оружие R
				case 100..199: { itemid = 379; count = 1; } //часы
				case 200..499: { itemid = GetRandomAccessory(4); count = 1; } //бижутерия сил земли
				case 500..5199: { itemid = 320; count = 25; } //коробка с эликсиром
				case 5200..5499: { itemid = 427; count = 13; } //золотой слиток
				case 5500..5699: { itemid = 413; count = 1; } //ключ R
				case 5700..5799: { itemid = 414; count = 1; } //ключ S
				case 5800..5899: { itemid = 375; count = 1; } //очки
				case 5900..6399: { itemid = 288; count = 6; } //эликсир удачи мастера
				case 6400..6599: { itemid = 315; count = 4; } //коробка со средним модификатором
				default: { itemid = 290; count = 260; } //усилитель
			}
		}
		case 26:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(7, 7, RND_EQUIP_TYPE_RANDOM, GRADE_B); count = 1; }
				case 1000..1499: { itemid = 206; count = 1; } //часы
				case 1500..1999: { itemid = 318; count = 2; } //коробка с бижутерией среднего качества
				case 2000..4699: { itemid = 320; count = 7; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 6; } //золотой слиток
				case 4800..5299: { itemid = 415; count = 1; } //ключ N
				case 5300..5599: { itemid = 410; count = 1; } //ключ B
				default: { itemid = 290; count = 100; } //усилитель
			}
		}
		case 27:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(7, 7, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1499: { itemid = 206; count = 1; } //часы
				case 1500..1999: { itemid = 318; count = 3; } //коробка с бижутерией среднего качества
				case 2000..4699: { itemid = 320; count = 9; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 7; } //золотой слиток
				case 4800..5299: { itemid = 416; count = 1; } //ключ B
				case 5300..5599: { itemid = 411; count = 1; } //ключ C
				case 5600..5899: { itemid = 197; count = 1; } //очки
				case 5900..6099: { itemid = 288; count = 3; } //эликсир удачи мастера
				default: { itemid = 290; count = 140; } //усилитель
			}
		}
		case 28:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(7, 7, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1699: { itemid = 206; count = 1; } //часы
				case 1700..2699: { itemid = 318; count = 3; } //коробка с бижутерией среднего качества
				case 2700..5199: { itemid = 320; count = 15; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 8; } //золотой слиток
				case 5300..5799: { itemid = 417; count = 1; } //ключ C
				case 5800..6099: { itemid = 412; count = 1; } //ключ L
				case 6100..6599: { itemid = 197; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 4; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 1; } //коробка со средним модификатором
				default: { itemid = 290; count = 160; } //усилитель
			}
		}
		case 29:
		{
			switch(chance)
			{
				case 0..999: { itemid = 302; count = 3; } //оружие L
				case 1000..1699: { itemid = 206; count = 1; } //часы
				case 1700..2699: { itemid = 318; count = 3; } //коробка с бижутерией среднего качества
				case 2700..5199: { itemid = 320; count = 18; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 10; } //золотой слиток
				case 5300..5799: { itemid = 417; count = 1; } //ключ C
				case 5800..6099: { itemid = 413; count = 1; } //ключ R
				case 6100..6599: { itemid = 197; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 5; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 2; } //коробка со средним модификатором
				default: { itemid = 290; count = 210; } //усилитель
			}
		}
		case 30:
		{
			switch(chance)
			{
				case 0..99: { itemid = 309; count = 1; } //оружие R
				case 100..1199: { itemid = 206; count = 1; } //часы
				case 1200..2199: { itemid = 318; count = 4; } //коробка с бижутерией среднего качества
				case 2200..4899: { itemid = 320; count = 24; } //коробка с эликсиром
				case 4900..5099: { itemid = 427; count = 12; } //золотой слиток
				case 5100..5399: { itemid = 418; count = 1; } //ключ L
				case 5400..5599: { itemid = 414; count = 1; } //ключ S
				case 5600..6399: { itemid = 197; count = 1; } //очки
				case 6400..6799: { itemid = 288; count = 6; } //эликсир удачи мастера
				case 6800..6999: { itemid = 315; count = 3; } //коробка со средним модификатором
				default: { itemid = 290; count = 250; } //усилитель
			}
		}
		case 31:
		{
			switch(chance)
			{
				case 0..99: { itemid = 309; count = 1; } //оружие R
				case 100..199: { itemid = 380; count = 1; } //часы
				case 200..499: { itemid = GetRandomAccessory(4); count = 1; } //бижутерия сил земли
				case 500..5199: { itemid = 320; count = 29; } //коробка с эликсиром
				case 5200..5499: { itemid = 427; count = 15; } //золотой слиток
				case 5500..5699: { itemid = 419; count = 1; } //ключ R
				case 5700..5799: { itemid = 420; count = 1; } //ключ S
				case 5800..5899: { itemid = 376; count = 1; } //очки
				case 5900..6399: { itemid = 288; count = 7; } //эликсир удачи мастера
				case 6400..6599: { itemid = 315; count = 4; } //коробка со средним модификатором
				default: { itemid = 290; count = 280; } //усилитель
			}
		}
		case 32:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(8, 8, RND_EQUIP_TYPE_RANDOM, GRADE_B); count = 1; }
				case 1000..1499: { itemid = 207; count = 1; } //часы
				case 1500..1999: { itemid = 318; count = 3; } //коробка с бижутерией среднего качества
				case 2000..4699: { itemid = 320; count = 9; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 8; } //золотой слиток
				case 4800..5299: { itemid = 421; count = 1; } //ключ N
				case 5300..5599: { itemid = 416; count = 1; } //ключ B
				default: { itemid = 290; count = 120; } //усилитель
			}
		}
		case 33:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(8, 8, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1499: { itemid = 207; count = 1; } //часы
				case 1500..1999: { itemid = 318; count = 4; } //коробка с бижутерией среднего качества
				case 2000..4699: { itemid = 320; count = 11; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 9; } //золотой слиток
				case 4800..5299: { itemid = 422; count = 1; } //ключ B
				case 5300..5599: { itemid = 417; count = 1; } //ключ C
				case 5600..5899: { itemid = 198; count = 1; } //очки
				case 5900..6099: { itemid = 288; count = 3; } //эликсир удачи мастера
				default: { itemid = 290; count = 150; } //усилитель
			}
		}
		case 34:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(8, 8, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1699: { itemid = 207; count = 1; } //часы
				case 1700..2699: { itemid = 318; count = 5; } //коробка с бижутерией среднего качества
				case 2700..5199: { itemid = 320; count = 16; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 10; } //золотой слиток
				case 5300..5799: { itemid = 423; count = 1; } //ключ C
				case 5800..6099: { itemid = 418; count = 1; } //ключ L
				case 6100..6599: { itemid = 198; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 5; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 2; } //коробка со средним модификатором
				default: { itemid = 290; count = 170; } //усилитель
			}
		}
		case 35:
		{
			switch(chance)
			{
				case 0..999: { itemid = 303; count = 3; } //оружие L
				case 1000..1699: { itemid = 207; count = 1; } //часы
				case 1700..2699: { itemid = 319; count = 1; } //коробка с бижутерией высокого качества
				case 2700..5199: { itemid = 320; count = 21; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 12; } //золотой слиток
				case 5300..5799: { itemid = 423; count = 1; } //ключ C
				case 5800..6099: { itemid = 419; count = 1; } //ключ R
				case 6100..6599: { itemid = 198; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 6; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 3; } //коробка со средним модификатором
				default: { itemid = 290; count = 230; } //усилитель
			}
		}
		case 36:
		{
			switch(chance)
			{
				case 0..99: { itemid = 310; count = 1; } //оружие R
				case 100..1199: { itemid = 207; count = 1; } //часы
				case 1200..2199: { itemid = 319; count = 1; } //коробка с бижутерией высокого качества
				case 2200..4899: { itemid = 320; count = 26; } //коробка с эликсиром
				case 4900..5099: { itemid = 427; count = 15; } //золотой слиток
				case 5100..5399: { itemid = 424; count = 1; } //ключ L
				case 5400..5599: { itemid = 420; count = 1; } //ключ S
				case 5600..6399: { itemid = 198; count = 1; } //очки
				case 6400..6799: { itemid = 288; count = 7; } //эликсир удачи мастера
				case 6800..6999: { itemid = 316; count = 1; } //коробка с крупным модификатором
				default: { itemid = 290; count = 270; } //усилитель
			}
		}
		case 37:
		{
			switch(chance)
			{
				case 0..99: { itemid = 310; count = 1; } //оружие R
				case 100..199: { itemid = 381; count = 1; } //часы
				case 200..499: { itemid = GetRandomAccessory(5); count = 1; } //бижутерия Древних
				case 500..5199: { itemid = 320; count = 34; } //коробка с эликсиром
				case 5200..5499: { itemid = 427; count = 19; } //золотой слиток
				case 5500..5699: { itemid = 425; count = 1; } //ключ R
				case 5700..5799: { itemid = 420; count = 1; } //ключ S
				case 5800..5899: { itemid = 377; count = 1; } //очки
				case 5900..6399: { itemid = 288; count = 9; } //эликсир удачи мастера
				case 6400..6599: { itemid = 316; count = 1; } //коробка с крупным модификатором
				default: { itemid = 290; count = 320; } //усилитель
			}
		}
		case 38:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(9, 9, RND_EQUIP_TYPE_RANDOM, GRADE_B); count = 1; }
				case 1000..1499: { itemid = 208; count = 1; } //часы
				case 1500..1999: { itemid = 318; count = 4; } //коробка с бижутерией среднего качества
				case 2000..4699: { itemid = 320; count = 12; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 10; } //золотой слиток
				case 4800..5299: { itemid = 421; count = 1; } //ключ N
				case 5300..5599: { itemid = 422; count = 1; } //ключ B
				default: { itemid = 290; count = 140; } //усилитель
			}
		}
		case 39:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(9, 9, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1499: { itemid = 208; count = 1; } //часы
				case 1500..1999: { itemid = 319; count = 1; } //коробка с бижутерией высокого качества
				case 2000..4699: { itemid = 320; count = 14; } //коробка с эликсиром
				case 4700..4799: { itemid = 427; count = 11; } //золотой слиток
				case 4800..5299: { itemid = 422; count = 1; } //ключ B
				case 5300..5599: { itemid = 423; count = 1; } //ключ C
				case 5600..5899: { itemid = 199; count = 1; } //очки
				case 5900..6099: { itemid = 288; count = 4; } //эликсир удачи мастера
				default: { itemid = 290; count = 170; } //усилитель
			}
		}
		case 40:
		{
			switch(chance)
			{
				case 0..999: { itemid = GetRandomEquip(9, 9, RND_EQUIP_TYPE_RANDOM, GRADE_C); count = 1; }
				case 1000..1699: { itemid = 208; count = 1; } //часы
				case 1700..2699: { itemid = 319; count = 1; } //коробка с бижутерией высокого качества
				case 2700..5199: { itemid = 320; count = 18; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 13; } //золотой слиток
				case 5300..5799: { itemid = 423; count = 1; } //ключ C
				case 5800..6099: { itemid = 424; count = 1; } //ключ L
				case 6100..6599: { itemid = 199; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 6; } //эликсир удачи мастера
				case 7000..7099: { itemid = 315; count = 3; } //коробка со средним модификатором
				default: { itemid = 290; count = 190; } //усилитель
			}
		}
		case 41:
		{
			switch(chance)
			{
				case 0..999: { itemid = 304; count = 3; } //оружие L
				case 1000..1699: { itemid = 208; count = 1; } //часы
				case 1700..2699: { itemid = 319; count = 2; } //коробка с бижутерией высокого качества
				case 2700..5199: { itemid = 320; count = 24; } //коробка с эликсиром
				case 5200..5299: { itemid = 427; count = 15; } //золотой слиток
				case 5300..5799: { itemid = 423; count = 1; } //ключ C
				case 5800..6099: { itemid = 425; count = 1; } //ключ R
				case 6100..6599: { itemid = 199; count = 1; } //очки
				case 6600..6999: { itemid = 288; count = 7; } //эликсир удачи мастера
				case 7000..7099: { itemid = 316; count = 1; } //коробка с крупным модификатором
				default: { itemid = 290; count = 250; } //усилитель
			}
		}
		case 42:
		{
			switch(chance)
			{
				case 0..99: { itemid = 311; count = 1; } //оружие R
				case 100..1199: { itemid = 208; count = 1; } //часы
				case 1200..2199: { itemid = 319; count = 3; } //коробка с бижутерией высокого качества
				case 2200..4899: { itemid = 320; count = 32; } //коробка с эликсиром
				case 4900..5099: { itemid = 427; count = 19; } //золотой слиток
				case 5100..5399: { itemid = 424; count = 1; } //ключ L
				case 5400..5599: { itemid = 426; count = 1; } //ключ S
				case 5600..6399: { itemid = 199; count = 1; } //очки
				case 6400..6799: { itemid = 288; count = 9; } //эликсир удачи мастера
				case 6800..6999: { itemid = 316; count = 1; } //коробка с крупным модификатором
				default: { itemid = 290; count = 300; } //усилитель
			}
		}
		case 43:
		{
			switch(chance)
			{
				case 0..99: { itemid = 311; count = 1; } //оружие R
				case 100..199: { itemid = 382; count = 1; } //часы
				case 200..499: { itemid = GetRandomAccessory(6); count = 1; } //бижутерия священной горы
				case 500..5199: { itemid = 320; count = 42; } //коробка с эликсиром
				case 5200..5499: { itemid = 427; count = 24; } //золотой слиток
				case 5500..5699: { itemid = 425; count = 1; } //ключ R
				case 5700..5799: { itemid = 426; count = 1; } //ключ S
				case 5800..5899: { itemid = 378; count = 1; } //очки
				case 5900..6399: { itemid = 288; count = 12; } //эликсир удачи мастера
				case 6400..6599: { itemid = 316; count = 2; } //коробка с крупным модификатором
				default: { itemid = 290; count = 360; } //усилитель
			}
		}
	}

	if(itemid == -1) return;

	new item[BaseItem];
	item = GetItem(itemid);

	new string[255];
	if(IsEquip(itemid))
	{
		AddEquip(playerid, itemid, MOD_CLEAR);
		if(item[Grade] >= GRADE_C)
		{
			format(string, sizeof(string), "{%s}%s {ffffff}приобрел {%s}[%s]{ffffff}.", 
				GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name], GetGradeColor(item[Grade]), item[Name]
			);
			SendClientMessageToAll(0xFFFFFFFF, string);
		}
	}
	else
		AddItem(playerid, itemid, count);

	format(string, sizeof(string), "Получено: {%s}[%s] {ffffff}x%d.", 
		GetGradeColor(item[Grade]), item[Name], count
	);
	SendClientMessage(playerid, 0xFFFFFFFF, string);
}

stock ResolveMobName(mobid)
{
	new name[64] = "Mob";
	switch(mobid)
	{
		case 1: name = "Mob_Bomj";
		case 2: name = "Mob_Gay";
		case 3: name = "Mob_Gopstop";
		case 4: name = "Mob_Policeman";
		case 5: name = "Mob_Clown";
		case 6: name = "Mob_Proletary";
		case 7: name = "Mob_VSDDMan";
		case 8: name = "Mob_Authority";
		case 9: name = "Mob_LocalBourgeois";
		default: name = "Mob";
	}

	return name;
}

public bool:IsPlayerInDungeon(playerid)
{
	if(playerid == INVALID_PLAYER_ID) return false;

	new dungeonid = GetPVarInt(playerid, "ActiveDungeon");
	if(dungeonid != -1) return true;
	return false;
}

stock GetBossesList()
{
	new listitems[1024] = "Босс\tСостояние";
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
			format(bossinfo, sizeof(bossinfo), "\n{%s}%s\t{FFCC00}Идет сбор", GetGradeColor(boss[Grade]), boss[Name]);
		else if(resp_time == 0)
			format(bossinfo, sizeof(bossinfo), "\n{%s}%s\t{66CC00}Можно атаковать", GetGradeColor(boss[Grade]), boss[Name]);
		else
			format(bossinfo, sizeof(bossinfo), "\n{%s}%s\t{CC3333}Ждать минут: %d", GetGradeColor(boss[Grade]), boss[Name], resp_time);
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
		case 1: resp_time = 10;
		case 2: resp_time = 15;
		case 3: resp_time = 20;
		case 4: resp_time = 30;
		case 5: resp_time = 45;
		case 6: resp_time = 60;
		case 7: resp_time = 90;
		default: resp_time = 5;
	}

	new query[255];
	format(query, sizeof(query), "UPDATE `bosses` SET `RespawnTime` = '%d' WHERE `ID` = '%d' LIMIT 1", resp_time, bossid);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);
}

stock GetNYShazokItemsList()
{
	new listitems[2048] = "Предмет\tЦена (красных носов)";
	new query[255] = "SELECT * FROM `ny_shazok_seller`";
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
		new price = 0;
		cache_set_active(q_result);
		cache_get_value_name_int(i, "ItemID", itemid);
		cache_get_value_name_int(i, "Price", price);
		cache_unset_active();

		if(itemid == -1) continue;
		new item[BaseItem];
		item = GetItem(itemid);
		format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{66CC00}%d", GetGradeColor(item[Grade]), item[Name], price);
		strcat(listitems, iteminfo);
	}

	cache_delete(q_result);
	return listitems;
}

stock GetKeysSellerItemsList()
{
	new listitems[2048] = "Предмет\tЦена";
	new query[255] = "SELECT * FROM `keys_seller`";
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
		new price = 0;
		cache_set_active(q_result);
		cache_get_value_name_int(i, "ItemID", itemid);
		cache_get_value_name_int(i, "Price", price);
		cache_unset_active();

		if(itemid == -1) continue;
		new item[BaseItem];
		item = GetItem(itemid);
		format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{66CC00}%s$", GetGradeColor(item[Grade]), item[Name], FormatMoney(price));
		strcat(listitems, iteminfo);
	}

	cache_delete(q_result);
	return listitems;
}

stock GetMaterialsSellerItemsList(playerid)
{
	new listitems[2048] = "Предмет\tЦена";
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
		if(itemid == 280)
			format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{66CC00}%s$", GetGradeColor(item[Grade]), item[Name], FormatMoney(item[Price] + 4000 * PlayerInfo[playerid][Rank] * PlayerInfo[playerid][Rank]));
		else if(itemid == 281)
			format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{66CC00}%s$", GetGradeColor(item[Grade]), item[Name], FormatMoney(item[Price] + 2000 * PlayerInfo[playerid][Rank] * PlayerInfo[playerid][Rank]));
		else
			format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{66CC00}%s$", GetGradeColor(item[Grade]), item[Name], FormatMoney(item[Price]));
		strcat(listitems, iteminfo);
	}

	cache_delete(q_result);
	return listitems;
}

stock GetWeaponSellerItemsList()
{
	new listitems[2048] = "Предмет\tМин.ранг\tЦена";
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
		format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{%s}%s\t{66CC00}%s$", 
			GetGradeColor(item[Grade]), item[Name], RateColors[item[MinRank]-1], GetRankInterval(item[MinRank]), FormatMoney(item[Price])
		);
		strcat(listitems, iteminfo);
	}

	cache_delete(q_result);
	return listitems;
}

stock GetArmorSellerItemsList()
{
	new listitems[2048] = "Предмет\tМин.ранг\tЦена";
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
		format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{%s}%s\t{66CC00}%s$", 
			GetGradeColor(item[Grade]), item[Name], RateColors[item[MinRank]-1], GetRankInterval(item[MinRank]), FormatMoney(item[Price])
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
		pickupid == arena_tp ||
		pickupid == war_tp ||
		pickupid == health_pickup)
		return;
	DestroyPickup(pickupid);
}

stock ResetDamagersInfo(playerid)
{
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
		DmgInfo[playerid][i] = 0;
}

stock GetRealKillerId(playerid, lastshotterid)
{
	new killerid = -1;
	new max_damage = 0;
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		if(GetPlayerTourTeam(PvpInfo[i][ID]) == GetPlayerTourTeam(playerid))
			continue;

		new damage = DmgInfo[playerid][i];
		if(PvpInfo[i][ID] == lastshotterid)
			damage += MaxHP[playerid] / 3;
		if(damage > max_damage)
		{
			max_damage = damage;
			killerid = PvpInfo[i][ID];
		}
	}
	return killerid;
}

stock GiveKillScore(playerid, killerid)
{
	new base_score = GetScoreDiff(PlayerInfo[playerid][Rate], PlayerInfo[killerid][Rate], true);
	new killer_idx = GetPvpIndex(killerid);

	new kills_diff = PvpInfo[killer_idx][Kills] - PvpInfo[killer_idx][Deaths];
	if(kills_diff > 1)
		base_score = floatround(floatmul(base_score, floatpower(0.97, kills_diff)));
	PvpInfo[killer_idx][Score] += base_score;

	new damagers_ids[MAX_PARTICIPANTS];
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
		damagers_ids[i] = DmgInfo[playerid][i] > 0 ? i : -1;

	new tmp;
	for(new i = 0; i < MAX_PARTICIPANTS; i++)
    {
        for(new j = MAX_PARTICIPANTS-1; j > i; j--)
        {
            if(DmgInfo[playerid][j-1] < DmgInfo[playerid][j])
            {
				tmp = DmgInfo[playerid][j-1];
				DmgInfo[playerid][j-1] = DmgInfo[playerid][j];
				DmgInfo[playerid][j] = tmp;

				tmp = damagers_ids[j-1];
				damagers_ids[j-1] = damagers_ids[j];
				damagers_ids[j] = tmp;
            }
        }
    }

	for(new i = 0; i < MAX_PARTICIPANTS; i++)
	{
		if(damagers_ids[i] == killer_idx)
			continue;
		if(DmgInfo[playerid][i] <= 0)
			break;

		new part_id = PvpInfo[damagers_ids[i]][ID];
		if(part_id == -1 || part_id == killerid || part_id == playerid || part_id == INVALID_PLAYER_ID || GetPlayerTourTeam(playerid) == GetPlayerTourTeam(part_id))
			continue;
		
		base_score = floatround(floatmul(base_score, 0.75));
		PvpInfo[damagers_ids[i]][Score] += base_score;
	}
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
		BossLootItems[i][OwnerID] = -1;
	}
}

stock ResetWalkerLoot(walkerid)
{
	for(new i = 0; i < MAX_WALKER_LOOT; i++)
	{
		if(WalkerLootPickups[walkerid][i] > 0)
		{
			SafeDestroyPickup(WalkerLootPickups[walkerid][i]);
			WalkerLootPickups[walkerid][i] = 0;
		}
		WalkerLootItems[walkerid][i][ItemID] = -1;
		WalkerLootItems[walkerid][i][Count] = 0;
		WalkerLootItems[walkerid][i][OwnerID] = -1;
	}
}

stock ResetDungeonLoot(npcid)
{
	for(new i = 0; i < MAX_DUNGEON_LOOT; i++)
	{
		if(DungeonLootPickups[npcid][i] > 0)
		{
			SafeDestroyPickup(DungeonLootPickups[npcid][i]);
			DungeonLootPickups[npcid][i] = 0;
		}
		DungeonLootItems[npcid][i][ItemID] = -1;
		DungeonLootItems[npcid][i][Count] = 0;
		DungeonLootItems[npcid][i][OwnerID] = -1;
	}
}

stock RollDungeonLoot(npcid, playerid)
{
	if(playerid == -1 || playerid == INVALID_PLAYER_ID) return;

	new loot_mult = 4;
	if(HasItem(playerid, 280, 1))
		loot_mult /= 2;
	
	new max_loot = IsDungeonBoss[npcid] ? MAX_DUNGEON_LOOT : MAX_DUNGEON_LOOT / 2;
	new iterations = random(max_loot / loot_mult) + max_loot / loot_mult + 1;
	for(new i = 0; i < iterations; i++)
	{
		new loot[LootInfo];
		if(IsDungeonBoss[npcid])
			loot = RollBossLootItem(PlayerDungeon[playerid][BossesIds][npcid]);
		else
			loot = RollWalkerLootItem(PlayerInfo[npcid][Rank], playerid);
		
		if(loot[ItemID] == -1) continue;
		loot[OwnerID] = -1;

		DungeonLootItems[npcid][i][ItemID] = loot[ItemID];
		DungeonLootItems[npcid][i][Count] = loot[Count];
		DungeonLootItems[npcid][i][OwnerID] = loot[OwnerID];

		new Float:x, Float:y, Float:z;
		FCNPC_GetPosition(npcid, x, y, z);
		DungeonLootPickups[npcid][i] = CreatePickup(19055, 1, x + random(6), y + random(6), z, 1001 + playerid);
	}
}

stock RollWalkerLoot(walkerid, killerid)
{
	if(killerid == -1 || killerid == INVALID_PLAYER_ID) return;

	new loot_mult = 4;
	if(HasItem(killerid, 280, 1))
		loot_mult /= 2;

	new iterations = random(MAX_WALKER_LOOT / loot_mult) + MAX_WALKER_LOOT / loot_mult + 1;
	for(new i = 0; i < iterations; i++)
	{
		new loot[LootInfo];
		loot = RollWalkerLootItem(PlayerInfo[walkerid][Rank], killerid);
		if(loot[ItemID] == -1) continue;

		WalkerLootItems[walkerid][i][ItemID] = loot[ItemID];
		WalkerLootItems[walkerid][i][Count] = loot[Count];
		WalkerLootItems[walkerid][i][OwnerID] = loot[OwnerID];

		new Float:x, Float:y, Float:z;
		FCNPC_GetPosition(walkerid, x, y, z);
		WalkerLootPickups[walkerid][i] = CreatePickup(19055, 1, x + random(6), y + random(6), z, 0);
	}
}

stock RollBossLoot()
{
	if(AttackedBoss == -1 || !FCNPC_IsValid(BossNPC)) return;
	new loot_mult = 4;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsBossAttacker[i]) continue;
		if(HasItem(i, 280, 1))
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

stock RollWalkerLootItem(rank, ownerid)
{
	new chance = random(10001);
	new itemid = -1;
	new count = 1;
	switch(rank)
	{
		case 1:
		{
			switch(chance)
			{
				case 0..49: itemid = GetRandomEquip(1, 1);
				case 50..799: itemid = GetRandomStone();
				case 800..999: { itemid = 290; count = 1; }
				default: { itemid = 366; count = (rank * 5 - rank) + random(rank * 3); }
			}
		}
		case 2:
		{
			switch(chance)
			{
				case 0..49: itemid = GetRandomEquip(1, 2);
				case 50..799: { itemid = GetRandomStone(); count = 2; }
				case 800..999: { itemid = 290; count = 1; }
				default: { itemid = 366; count = (rank * 5 - rank) + random(rank * 3); }
			}
		}
		case 3:
		{
			switch(chance)
			{
				case 0..49: itemid = GetRandomEquip(2, 3);
				case 50..749: { itemid = GetRandomStone(); count = 4; }
				case 750..949: { itemid = 290; count = 2; }
				case 950..999: { itemid = 306; count = 1; }
				case 1000..1099: { itemid = 286; count = 1; }
				default: { itemid = 366; count = (rank * 5 - rank) + random(rank * 3); }
			}
		}
		case 4:
		{
			switch(chance)
			{
				case 0..49: itemid = GetRandomEquip(3, 4);
				case 50..749: { itemid = GetRandomStone(); count = 6; }
				case 750..949: { itemid = 290; count = 3; }
				case 950..999: { itemid = 306; count = 2; }
				case 1000..1099: { itemid = 286; count = 2; }
				default: { itemid = 366; count = (rank * 5 - rank) + random(rank * 3); }
			}
		}
		case 5:
		{
			switch(chance)
			{
				case 0..49: itemid = GetRandomEquip(4, 5);
				case 50..824: { itemid = GetRandomBooster(); count = 4; }
				case 825..1024: { itemid = 290; count = 4; }
				case 1025..1074: { itemid = 306; count = 3; }
				case 1075..1099: itemid = 320;
				default: { itemid = 366; count = (rank * 5 - rank) + random(rank * 3); }
			}
		}
		case 6:
		{
			switch(chance)
			{
				case 0..49: itemid = GetRandomEquip(5, 6);
				case 50..824: { itemid = GetRandomBooster(); count = 6; }
				case 825..1024: { itemid = 290; count = 5; }
				case 1025..1114: { itemid = 306; count = 4; }
				case 1115..1164: itemid = 320;
				case 1165..1174: itemid = 307;
				default: { itemid = 366; count = (rank * 5 - rank) + random(rank * 3); }
			}
		}
		case 7:
		{
			switch(chance)
			{
				case 0..49: itemid = GetRandomEquip(6, 7);
				case 50..774: { itemid = GetRandomBooster(); count = 8; }
				case 775..974: { itemid = 290; count = 6; }
				case 975..1064: { itemid = 306; count = 5; }
				case 1065..1139: itemid = 320;
				case 1140..1149: itemid = 307;
				default: { itemid = 366; count = (rank * 5 - rank) + random(rank * 3); }
			}
		}
		case 8:
		{
			switch(chance)
			{
				case 0..49: itemid = GetRandomEquip(7, 8);
				case 50..749: { itemid = GetRandomBooster(); count = 10; }
				case 750..949: { itemid = 290; count = 7; }
				case 950..1029: { itemid = 306; count = 6; }
				case 1030..1129: itemid = 320;
				case 1130..1149: itemid = 307;
				default: { itemid = 366; count = (rank * 5 - rank) + random(rank * 3); }
			}
		}
		case 9:
		{
			switch(chance)
			{
				case 0..49: itemid = GetRandomEquip(8, 9);
				case 50..699: { itemid = GetRandomBooster(); count = 12; }
				case 700..899: { itemid = 290; count = 8; }
				case 900..979: { itemid = 306; count = 7; }
				case 980..1129: itemid = 320;
				case 1130..1149: itemid = 307;
				default: { itemid = 366; count = (rank * 5 - rank) + random(rank * 3); }
			}
		}
	}

	new loot[LootInfo];
	loot[ItemID] = itemid;
	loot[Count] = count;
	loot[OwnerID] = ownerid;
	return loot;
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
				case 0..499: itemid = GetRandomEquip(1, 2);
				case 500..599: itemid = GetRandomGlasses(1, 2);
				case 600..799: itemid = GetRandomWatch(1, 2);
				case 800..1099: itemid = 317; //коробка с бижутерией
				case 1100..1399: itemid = 314; //коробка с модификатором
				case 1450..1549: itemid = 305; //инструкция Шажка
				case 1550..1749: { itemid = 306; count = 1; } //катализатор
				case 1750..2049: { itemid = 286; count = 1; } //эликсир удачи
				case 2050..2199: { itemid = 287; count = 1; } //качественный эликсир удачи
				case 2200..2239: { itemid = 288; count = 1; } //эликсир удачи мастера
				case 2240..2249: { itemid = 289; count = 1; } //редкий эликсир удачи
				case 2250..6149: { itemid = 290; count = 2; } //усилитель
				case 6150..6349: itemid = 297; //часть оружия Шажка
				default: { itemid = GetRandomBooster(); count = 2; } //случайный бустер
			}
		}
		case 1:
		{
			switch(chance)
			{
				case 0..499: itemid = GetRandomEquip(2, 3);
				case 500..599: itemid = GetRandomGlasses(2, 3);
				case 600..799: itemid = GetRandomWatch(2, 3);
				case 800..1099: itemid = 317; //коробка с бижутерией
				case 1100..1399: itemid = 314; //коробка с модификатором
				case 1450..1579: itemid = 305; //инструкция Шажка
				case 1580..1679: { itemid = 306; count = 2; } //катализатор
				case 1680..2004: { itemid = 286; count = 1; } //эликсир удачи
				case 2005..2179: { itemid = 287; count = 1; } //качественный эликсир удачи
				case 2180..2234: { itemid = 288; count = 1; } //эликсир удачи мастера
				case 2235..2249: { itemid = 289; count = 1; } //редкий эликсир удачи
				case 2250..6149: { itemid = 290; count = 4; } //усилитель
				case 6150..6249: itemid = 298; //часть оружия Шажка
				case 6250..6349: itemid = 299; //часть оружия Шажка
				default: { itemid = GetRandomBooster(); count = 4; } //случайный бустер
			}
		}
		case 2:
		{
			switch(chance)
			{
				case 0..499: itemid = GetRandomEquip(4, 6);
				case 500..599: itemid = GetRandomGlasses(4, 6);
				case 600..799: itemid = GetRandomWatch(4, 6);
				case 800..1099: itemid = 318; //коробка с бижутерией
				case 1100..1399: itemid = 315; //коробка с модификатором
				case 1450..1599: itemid = 305; //инструкция Шажка
				case 1600..1609: itemid = 308; //оружие Древних
				case 1610..1699: itemid = 307; //печать Древних
				case 1700..1799: { itemid = 306; count = 4; } //катализатор
				case 1800..2124: { itemid = 286; count = 2; } //эликсир удачи
				case 2125..2299: { itemid = 287; count = 2; } //качественный эликсир удачи
				case 2300..2374: { itemid = 288; count = 2; } //эликсир удачи мастера
				case 2375..2399: { itemid = 289; count = 1; } //редкий эликсир удачи
				case 2400..6199: { itemid = 290; count = 8; } //усилитель
				case 6200..6299: itemid = 300; //часть оружия Шажка
				case 6300..6399: itemid = 301; //часть оружия Шажка
				default: { itemid = GetRandomBooster(); count = 8; } //случайный бустер
			}
		}
		case 3:
		{
			switch(chance)
			{
				case 0..499: itemid = GetRandomEquip(7, 8);
				case 500..599: itemid = GetRandomGlasses(7, 8);
				case 600..799: itemid = GetRandomWatch(7, 8);
				case 800..1099: itemid = 319; //коробка с бижутерией
				case 1100..1399: itemid = 315; //коробка с модификатором
				case 1450..1679: itemid = 305; //инструкция Шажка
				case 1680..1689: itemid = 309; //оружие Древних
				case 1690..1699: itemid = 310; //оружие Древних
				case 1700..1749: itemid = GetRandomAccessory(4); //бижутерия сил земли
				case 1750..1759: itemid = 316; //коробка с крупным модификатором
				case 1760..1849: { itemid = 307; count = 2; } //печать Древних
				case 1850..2049: { itemid = 306; count = 8; } //катализатор
				case 2050..2374: { itemid = 286; count = 3; } //эликсир удачи
				case 2375..2549: { itemid = 287; count = 3; } //качественный эликсир удачи
				case 2550..2624: { itemid = 288; count = 2; } //эликсир удачи мастера
				case 2625..2649: { itemid = 289; count = 1; } //редкий эликсир удачи
				case 2650..6299: { itemid = 290; count = 14; } //усилитель
				case 6300..6399: itemid = 302; //часть оружия Шажка
				case 6400..6499: itemid = 303; //часть оружия Шажка
				default: { itemid = GetRandomBooster(); count = 14; } //случайный бустер
			}
		}
		case 4:
		{
			switch(chance)
			{
				case 0..499: itemid = GetRandomEquip(9, 9);
				case 500..599: itemid = GetRandomGlasses(9, 9);
				case 600..799: itemid = GetRandomWatch(9, 9);
				case 800..1099: itemid = 319; //коробка с бижутерией
				case 1100..1399: { itemid = 315; count = 2; } //коробка с модификатором
				case 1450..1679: itemid = 305; //инструкция Шажка
				case 1680..1689: itemid = 311; //оружие Древних
				case 1690..1699: itemid = GetRandomAccessory(5); //бижутерия Древних
				case 1700..1749: itemid = GetRandomAccessory(4); //бижутерия сил земли
				case 1750..1759: itemid = 316; //коробка с крупным модификатором
				case 1760..1849: { itemid = 307; count = 3; } //печать Древних
				case 1850..2049: { itemid = 306; count = 14; } //катализатор
				case 2050..2374: { itemid = 286; count = 5; } //эликсир удачи
				case 2375..2549: { itemid = 287; count = 4; } //качественный эликсир удачи
				case 2550..2624: { itemid = 288; count = 3; } //эликсир удачи мастера
				case 2625..2649: { itemid = 289; count = 2; } //редкий эликсир удачи
				case 2650..6299: { itemid = 290; count = 28; } //усилитель
				case 6300..6599: itemid = 304; //часть оружия Шажка
				default: { itemid = GetRandomBooster(); count = 28; } //случайный бустер
			}
		}
		case 5:
		{
			switch(chance)
			{
				case 0..24: itemid = 308;
				case 25..49: itemid = 309;
				case 50..74: itemid = 310;
				case 75..99: itemid = 311;
				case 200..224: itemid = GetRandomAccessory(5); //бижутерия Древних
				case 250..299: itemid = GetRandomAccessory(4); //бижутерия сил земли
				case 400..799: { itemid = 315; count = 3; } //коробка с модификатором
				case 800..849: itemid = 316; //коробка с крупным модификатором
				case 850..5149: { itemid = 307; count = 5; } //печать Древних
				case 5150..5349: { itemid = 288; count = 5; } //эликсир удачи мастера
				case 5350..5374: { itemid = 289; count = 2; } //редкий эликсир удачи
				case 5400..5899: { itemid = 427; count = 5; } //золотой слиток
				default: { itemid = 320; count = 10; } //коробка с эликсиром
			}
		}
		case 6:
		{
			switch(chance)
			{
				case 0..99: itemid = 375;
				case 100..199: itemid = 376;
				case 200..299: itemid = 379;
				case 300..399: itemid = 380;
				case 400..449: itemid = GetRandomAccessory(6); //бижутерия священной горы
				case 600..1099: { itemid = 315; count = 4; } //коробка с модификатором
				case 1100..1149: { itemid = 316; count = 2; } //коробка с крупным модификатором
				case 1150..5249: { itemid = 307; count = 7; } //печать Древних
				case 5250..5449: { itemid = 288; count = 6; } //эликсир удачи мастера
				case 5450..5499: { itemid = 289; count = 2; } //редкий эликсир удачи
				case 5500..5999: { itemid = 427; count = 8; } //золотой слиток
				default: { itemid = 320; count = 16; } //коробка с эликсиром
			}
		}
		case 7:
		{
			switch(chance)
			{
				case 0..99: itemid = 377;
				case 100..199: itemid = 378;
				case 200..299: itemid = 381;
				case 300..399: itemid = 382;
				case 400..499: itemid = GetRandomAccessory(6); //бижутерия священной горы
				case 600..1099: { itemid = 315; count = 6; } //коробка с модификатором
				case 1100..1149: { itemid = 316; count = 3; } //коробка с крупным модификатором
				case 1150..5249: { itemid = 307; count = 10; } //печать Древних
				case 5250..5449: { itemid = 288; count = 9; } //эликсир удачи мастера
				case 5450..5499: { itemid = 289; count = 3; } //редкий эликсир удачи
				case 5500..5999: { itemid = 427; count = 14; } //золотой слиток
				default: { itemid = 320; count = 24; } //коробка с эликсиром
			}
		}
	}

	new loot[LootInfo];
	loot[ItemID] = itemid;
	loot[Count] = count;
	loot[OwnerID] = -1;
	return loot;
}

stock GetRandomEquip(minrank, maxrank, eq_type = RND_EQUIP_TYPE_RANDOM, grade = RND_EQUIP_GRADE_RANDOM)
{
	new rank = minrank + random(maxrank-minrank+1) - 1;
	new type = eq_type == RND_EQUIP_TYPE_RANDOM ? random(3) : eq_type;
	new baseid = 1;
	if(type == 1)
		baseid = 82;
	else if(type == 2)
		baseid = 137;

	if(type == 0 && rank == 5)
	{
		rank += random(2);
		return baseid + rank * 8 + (grade == RND_EQUIP_GRADE_RANDOM ? random(8) : grade-1);
	}
	if(type == 0 && rank > 5)
		return baseid + (rank+1) * 8 + (grade == RND_EQUIP_GRADE_RANDOM ? random(8) : grade-1);
	
	if(type == 0)
		return baseid + rank * 8 + (grade == RND_EQUIP_GRADE_RANDOM ? random(8) : grade-1);
	else
		return baseid + rank * 6 + (grade == RND_EQUIP_GRADE_RANDOM ? random(6) : grade-1);
}

stock GetKeyByRank(rank, grade)
{
	if(rank < 6)
		return 383 + (rank-1) * 4 + grade - 1;
	else
		return 403 + (rank-6) * 6 + grade - 1;
}

stock GetRandomGlasses(minrank, maxrank)
{
	new rank = minrank + random(maxrank-minrank+1) - 1;
	return 191 + rank;
}

stock GetRandomWatch(minrank, maxrank)
{
	new rank = minrank + random(maxrank-minrank+1) - 1;
	return 200 + rank;
}

stock GetRandomShazokPart(rank)
{
	if(rank > 3)
		return 299 + rank - 4;
	return 297 + rank - 1;
}

stock GetRandomAccessory(type)
{
	if(type < 4)
		return 209 + type * 7 + random(7);
	else if(type < 6)
	{
		type = type - 4;
		return 237 + type * 4 + random(4);
	}
	else
	{
		type = type - 6;
		return 371 + type * 4 + random(4);
	}
}

stock GetRandomBooster()
{
	return 291 + random(6);
}

stock GetRandomStone()
{
	return 282 + random(4);
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

stock FormatMoney(value)
{
	new string[64];
	if(value < 1000)
	{
		format(string, sizeof(string), "%d", value);
		return string;
	}

	new dec;
	new dec_str[8];
	while(value > 0)
	{
		dec = value % 1000;
		value /= 1000;

		if(dec >= 100 || value == 0) format(dec_str, sizeof(dec_str), ".%d", dec);
		else if(dec >= 10) format(dec_str, sizeof(dec_str), ".0%d", dec);
		else format(dec_str, sizeof(dec_str), ".00%d", dec);
		strins(string, dec_str, 0);
	}

	strdel(string, 0, 1); //remove first '.'

	return string;
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
		format(string, sizeof(string), "Ранг повышен - %s.", GetRateInterval(PlayerInfo[playerid][Rate]));
		SendClientMessage(playerid, COLOR_GREEN, string);
	}
	else if(new_rank < PlayerInfo[playerid][Rank])
	{
		format(string, sizeof(string), "Ранг понижен - %s.", GetRateInterval(PlayerInfo[playerid][Rate]));
		SendClientMessage(playerid, COLOR_RED, string);
	}

	PlayerInfo[playerid][Rank] = new_rank;
	if(PlayerInfo[playerid][Status] == HIERARCHY_NONE)
		SetPlayerColor(playerid, IsTourStarted ? HexTeamColors[PlayerInfo[playerid][TeamColor]][0] : HexRateColors[PlayerInfo[playerid][Rank]-1][0]);

	UpdatePlayerStats(playerid);
}

stock UpdatePlayerSkin(playerid)
{
	if(IsBoss[playerid] || IsWalker[playerid] || IsDungeonBoss[playerid] || IsDungeonMob[playerid])
	{
		SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
		return;
	}

    if(PlayerInfo[playerid][IsWatcher] != 0)
	{
		PlayerInfo[playerid][Skin] = 264;
		SetPlayerSkin(playerid, 264);
		return;
	}

	switch(PlayerInfo[playerid][ArmorSlotID])
	{
		case 81: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 78 : 131;
		case 82..87: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 22 : 13;
		case 88..93: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 6 : 41;
		case 94..99: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 167 : 205;
		case 100..105: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 70 : 219;
		case 106..111: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 310 : 309;
		case 112..117: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 147 : 141;
		case 118..123: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 127 : 150;
		case 124..129: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 126 : 93;
		case 130..135: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 294 : 214;
		case 273: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 113 : 91;
		case 274: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 165 : 141;
		default: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? DEFAULT_SKIN_MALE : DEFAULT_SKIN_FEMALE;
	}
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
}

stock UpdatePlayerWeapon(playerid)
{
	if(IsBoss[playerid] || IsWalker[playerid] || IsDungeonBoss[playerid] || IsDungeonMob[playerid])
	{
		FCNPC_SetWeapon(playerid, PlayerInfo[playerid][WeaponSlotID]);
		FCNPC_SetAmmo(playerid, 10000);
		return;
	}

    if(PlayerInfo[playerid][IsWatcher] != 0)
	{
		ResetPlayerWeapons(playerid);
		return;
	}

	new weaponid;
	switch(PlayerInfo[playerid][WeaponSlotID])
	{
		case 9..16,248..250: weaponid = 24;
		case 17..24: weaponid = 28;
		case 25..32,251..253: weaponid = 32;
		case 33..40,254..256: weaponid = 29;
		case 41..48: weaponid = 30;
		case 49..56,257..259,269: weaponid = 31;
		case 57..64,260..262,270,275: weaponid = 25;
		case 65..72,263..265,271: weaponid = 27;
		case 73..80,266..268,272: weaponid = 26;
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

stock UpdatePlayerHat(playerid)
{
	RemovePlayerAttachedObject(playerid,4);
	if(IsBoss[playerid] || IsWalker[playerid] || IsDungeonBoss[playerid] || IsDungeonMob[playerid])
		return;

	new hat[BaseItem];
	hat = GetItem(PlayerInfo[playerid][HatSlotID]);
	SetPlayerAttachedObject(playerid,4,hat[Model],2,0.141000,0.006000,-0.000000,0.000000,0.000000,0.000000,1.084001,1.073000,1.137001);
}

stock UpdatePlayerGlasses(playerid)
{
	RemovePlayerAttachedObject(playerid,5);
	if(IsBoss[playerid] || IsWalker[playerid] || IsDungeonBoss[playerid] || IsDungeonMob[playerid])
		return;
	
	if(PlayerInfo[playerid][GlassesSlotID] != -1)
	{
		new glasses[BaseItem];
		glasses = GetItem(PlayerInfo[playerid][GlassesSlotID]);
		SetPlayerAttachedObject(playerid,5,glasses[Model],2,0.093999,0.036000,-0.003999,91.899948,92.699890,0.000000,1.070999,1.037001,1.176002);
	}
}

stock UpdatePlayerWatch(playerid)
{
	RemovePlayerAttachedObject(playerid,6);
	if(IsBoss[playerid] || IsWalker[playerid] || IsDungeonBoss[playerid] || IsDungeonMob[playerid])
		return;
	
	if(PlayerInfo[playerid][WatchSlotID] != -1)
	{
		new watch[BaseItem];
		watch = GetItem(PlayerInfo[playerid][WatchSlotID]);
		SetPlayerAttachedObject(playerid,6,watch[Model],5,0.012999,-0.015000,-0.019999,169.700500,-96.600479,-41.199993,1.077000,1.459998,1.277999);
	}
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
	new default_armor_defense;
	default_armor_defense = GetArmorBaseDefense(PlayerInfo[playerid][ArmorSlotID]);
	armor_defense = GetArmorModifiedDefense(default_armor_defense, GetModifierLevel(PlayerInfo[playerid][ArmorMod], MOD_DEFENSE));
	if(armor_defense == 0)
		armor_defense = DEFAULT_DEFENSE;

	new hat_defense;
	new default_hat_defense;
	default_hat_defense = GetArmorBaseDefense(PlayerInfo[playerid][HatSlotID]);
	hat_defense = GetArmorModifiedDefense(default_hat_defense, GetModifierLevel(PlayerInfo[playerid][HatMod], MOD_DEFENSE));

	new glasses_defense = 0;
	if(PlayerInfo[playerid][GlassesSlotID] != -1)
	{
		new default_glasses_defense;
		default_glasses_defense = GetArmorBaseDefense(PlayerInfo[playerid][GlassesSlotID]);
		glasses_defense = GetArmorModifiedDefense(default_glasses_defense, GetModifierLevel(PlayerInfo[playerid][GlassesMod], MOD_DEFENSE));
	}
	
	new watch_defense = 0;
	if(PlayerInfo[playerid][WatchSlotID] != -1)
	{
		new default_watch_defense;
		default_watch_defense = GetArmorBaseDefense(PlayerInfo[playerid][WatchSlotID]);
		watch_defense = GetArmorModifiedDefense(default_watch_defense, GetModifierLevel(PlayerInfo[playerid][WatchMod], MOD_DEFENSE));
	}

	PlayerInfo[playerid][Defense] = armor_defense + hat_defense + glasses_defense + watch_defense;
	PlayerInfo[playerid][Accuracy] = DEFAULT_ACCURACY + GetPlayerPropValue(playerid, PROPERTY_ACCURACY);
	PlayerInfo[playerid][Dodge] = DEFAULT_DODGE + GetPlayerPropValue(playerid, PROPERTY_DODGE);
	PlayerInfo[playerid][Crit] = DEFAULT_CRIT + GetPlayerPropValue(playerid, PROPERTY_CRIT) + PlayerInfo[playerid][Rank] * 2;
	PlayerInfo[playerid][Vamp] = GetPlayerPropValue(playerid, PROPERTY_VAMP);

	new damage_multiplier = 100 + GetPlayerPropValue(playerid, PROPERTY_DAMAGE);
	new defense_multiplier = 100 + GetPlayerPropValue(playerid, PROPERTY_DEFENSE);
	new hp_multiplier = 100 + GetPlayerPropValue(playerid, PROPERTY_HP);

	switch(PlayerInfo[playerid][Status])
	{
		case HIERARCHY_LEADER:
		{
			damage_multiplier += 50;
			defense_multiplier += 50;
		}
		case HIERARCHY_ARCHONT:
		{
			defense_multiplier += 50;
			hp_multiplier += 20;
		}
		case HIERARCHY_ATTACK:
		{
			damage_multiplier += 30;
		}
		case HIERARCHY_DEFENSE:
		{
			damage_multiplier += 30;
		}
		case HIERARCHY_SUPPORT:
		{
			damage_multiplier += 20;
			defense_multiplier += 20;
			hp_multiplier += 15;
		}
	}

	PlayerInfo[playerid][DamageMin] = (PlayerInfo[playerid][DamageMin] * damage_multiplier) / 100;
	PlayerInfo[playerid][DamageMax] = (PlayerInfo[playerid][DamageMax] * damage_multiplier) / 100;
	PlayerInfo[playerid][Defense] = (PlayerInfo[playerid][Defense] * defense_multiplier) / 100;

	UpdatePlayerMaxHP(playerid);
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
		{
			mod_value += GetModifierStatByLevel(PlayerInfo[playerid][WeaponMod], GetModifierLevel(PlayerInfo[playerid][WeaponMod], MOD_ACCURACY));
			mod_value += GetModifierStatByLevel(PlayerInfo[playerid][GlassesMod], GetModifierLevel(PlayerInfo[playerid][GlassesMod], MOD_ACCURACY));
			mod_value += GetModifierStatByLevel(PlayerInfo[playerid][WatchMod], GetModifierLevel(PlayerInfo[playerid][WatchMod], MOD_ACCURACY));
		}
		case PROPERTY_DODGE:
		{
			mod_value += GetModifierStatByLevel(PlayerInfo[playerid][ArmorMod], GetModifierLevel(PlayerInfo[playerid][ArmorMod], MOD_DODGE));
			mod_value += GetModifierStatByLevel(PlayerInfo[playerid][HatMod], GetModifierLevel(PlayerInfo[playerid][HatMod], MOD_DODGE));
			mod_value += GetModifierStatByLevel(PlayerInfo[playerid][GlassesMod], GetModifierLevel(PlayerInfo[playerid][GlassesMod], MOD_DODGE));
			mod_value += GetModifierStatByLevel(PlayerInfo[playerid][WatchMod], GetModifierLevel(PlayerInfo[playerid][WatchMod], MOD_DODGE));
		}
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

	new hat[BaseItem];
	hat = GetItem(PlayerInfo[playerid][HatSlotID]);
	for(new i = 0; i < MAX_PROPERTIES; i++)
	{
		if(hat[Property][i] == prop)
			value += hat[PropertyVal][i];
	}

	if(PlayerInfo[playerid][GlassesSlotID] != -1)
	{
		new glasses[BaseItem];
		glasses = GetItem(PlayerInfo[playerid][GlassesSlotID]);
		for(new i = 0; i < MAX_PROPERTIES; i++)
		{
			if(glasses[Property][i] == prop)
				value += glasses[PropertyVal][i];
		}
	}

	if(PlayerInfo[playerid][WatchSlotID] != -1)
	{
		new watch[BaseItem];
		watch = GetItem(PlayerInfo[playerid][WatchSlotID]);
		for(new i = 0; i < MAX_PROPERTIES; i++)
		{
			if(watch[Property][i] == prop)
				value += watch[PropertyVal][i];
		}
	}

	if(PlayerInfo[playerid][RingSlot1ID] != -1)
	{
		new ring1[BaseItem];
		ring1 = GetItem(PlayerInfo[playerid][RingSlot1ID]);
		for(new i = 0; i < MAX_PROPERTIES; i++)
		{
			if(ring1[Property][i] == prop)
				value += ring1[PropertyVal][i];
		}
	}

	if(PlayerInfo[playerid][RingSlot2ID] != -1)
	{
		new ring2[BaseItem];
		ring2 = GetItem(PlayerInfo[playerid][RingSlot2ID]);
		for(new i = 0; i < MAX_PROPERTIES; i++)
		{
			if(ring2[Property][i] == prop)
				value += ring2[PropertyVal][i];
		}
	}

	if(PlayerInfo[playerid][AmuletteSlot1ID] != -1)
	{
		new amulette1[BaseItem];
		amulette1 = GetItem(PlayerInfo[playerid][AmuletteSlot1ID]);
		for(new i = 0; i < MAX_PROPERTIES; i++)
		{
			if(amulette1[Property][i] == prop)
				value += amulette1[PropertyVal][i];
		}
	}

	if(PlayerInfo[playerid][AmuletteSlot2ID] != -1)
	{
		new amulette2[BaseItem];
		amulette2 = GetItem(PlayerInfo[playerid][AmuletteSlot2ID]);
		for(new i = 0; i < MAX_PROPERTIES; i++)
		{
			if(amulette2[Property][i] == prop)
				value += amulette2[PropertyVal][i];
		}
	}

	if(prop == PROPERTY_DAMAGE && HasItem(playerid, ITEM_GEN_ATTACK_ID, 1))
		value += 5;
	if(prop == PROPERTY_DEFENSE && HasItem(playerid, ITEM_GEN_DEFENSE_ID, 1))
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
        case ITEMTYPE_HAT:
		{
			if(PlayerInfo[playerid][HatSlotID] == 136) return;
			AddEquip(playerid, PlayerInfo[playerid][HatSlotID], PlayerInfo[playerid][HatMod]);
			PlayerInfo[playerid][HatSlotID] = 136;
			PlayerInfo[playerid][HatMod] = MOD_CLEAR;
			UpdatePlayerHat(playerid);
		}
        case ITEMTYPE_GLASSES:
		{
			if(PlayerInfo[playerid][GlassesSlotID] == -1) return;
			AddEquip(playerid, PlayerInfo[playerid][GlassesSlotID], PlayerInfo[playerid][GlassesMod]);
			PlayerInfo[playerid][GlassesSlotID] = -1;
			PlayerInfo[playerid][GlassesMod] = MOD_CLEAR;
			UpdatePlayerGlasses(playerid);
		}
        case ITEMTYPE_WATCH:
		{
			if(PlayerInfo[playerid][WatchSlotID] == -1) return;
			AddEquip(playerid, PlayerInfo[playerid][WatchSlotID], PlayerInfo[playerid][WatchMod]);
			PlayerInfo[playerid][WatchSlotID] = -1;
			PlayerInfo[playerid][WatchMod] = MOD_CLEAR;
			UpdatePlayerWatch(playerid);
		}
		case ITEMTYPE_RING:
		{
			if(PlayerInfo[playerid][RingSlot1ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][RingSlot1ID], MOD_CLEAR);
				PlayerInfo[playerid][RingSlot1ID] = -1;
			}
			else if(PlayerInfo[playerid][RingSlot2ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][RingSlot2ID], MOD_CLEAR);
				PlayerInfo[playerid][RingSlot2ID] = -1;
			}
			else return;
		}
        case ITEMTYPE_AMULETTE:
		{
			if(PlayerInfo[playerid][AmuletteSlot1ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][AmuletteSlot1ID], MOD_CLEAR);
				PlayerInfo[playerid][AmuletteSlot1ID] = -1;
			}
			else if(PlayerInfo[playerid][AmuletteSlot2ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][AmuletteSlot2ID], MOD_CLEAR);
				PlayerInfo[playerid][AmuletteSlot2ID] = -1;
			}
			else return;
		}
		default: return;
	}

	UpdatePlayerStats(playerid);
    UpdatePlayerEffects(playerid);

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
        case ITEMTYPE_HAT:
		{
			if(PlayerInfo[playerid][HatSlotID] != 136)
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
			}
			PlayerInfo[playerid][HatSlotID] = itemid;
			PlayerInfo[playerid][HatMod] = mod;
			UpdatePlayerHat(playerid);
		}
        case ITEMTYPE_GLASSES:
		{
			if(PlayerInfo[playerid][GlassesSlotID] != -1)
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
			}
			PlayerInfo[playerid][GlassesSlotID] = itemid;
			PlayerInfo[playerid][GlassesMod] = mod;
			UpdatePlayerGlasses(playerid);
		}
        case ITEMTYPE_WATCH:
		{
			if(PlayerInfo[playerid][WatchSlotID] != -1)
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
			}
			PlayerInfo[playerid][WatchSlotID] = itemid;
			PlayerInfo[playerid][WatchMod] = mod;
			UpdatePlayerWatch(playerid);
		}
		case ITEMTYPE_RING:
		{
			if(PlayerInfo[playerid][RingSlot1ID] == -1)
				PlayerInfo[playerid][RingSlot1ID] = itemid;
			else if(PlayerInfo[playerid][RingSlot2ID] == -1)
				PlayerInfo[playerid][RingSlot2ID] = itemid;
			else
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
				PlayerInfo[playerid][RingSlot1ID] = itemid;
			}
		}
        case ITEMTYPE_AMULETTE:
		{
			if(PlayerInfo[playerid][AmuletteSlot1ID] == -1)
				PlayerInfo[playerid][AmuletteSlot1ID] = itemid;
			else if(PlayerInfo[playerid][AmuletteSlot2ID] == -1)
				PlayerInfo[playerid][AmuletteSlot2ID] = itemid;
			else
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
				PlayerInfo[playerid][AmuletteSlot1ID] = itemid;
			}
		}
		default: return;
	}

	UpdatePlayerStats(playerid);
    UpdatePlayerEffects(playerid);

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
	PlayerTextDrawHide(playerid, ChrInfHatSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfWatchSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfGlassesSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfRingSlot1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfRingSlot2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAmuletteSlot1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAmuletteSlot2[playerid]);

	PlayerTextDrawBackgroundColor(playerid, ChrInfWeaponSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfArmorSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfHatSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfWatchSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfGlassesSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRingSlot1[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRingSlot2[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAmuletteSlot1[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAmuletteSlot2[playerid], -1061109505);

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
	
	if(PlayerInfo[playerid][HatSlotID] == 136)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfHatSlot[playerid], 18954);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfHatSlot[playerid], 0.000000, -45.000000, 0.000000, 1.000000);
	}
	else
	{
		new hat[BaseItem];
		hat = GetItem(PlayerInfo[playerid][HatSlotID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfHatSlot[playerid], hat[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfHatSlot[playerid], hat[ModelRotX], hat[ModelRotY], hat[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfHatSlot[playerid], HexGradeColors[hat[Grade]-1][0]);
	}

	if(PlayerInfo[playerid][WatchSlotID] == -1)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfWatchSlot[playerid], 19046);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfWatchSlot[playerid], 0.000000, -45.000000, 0.000000, 1.000000);
	}
	else
	{
		new watch[BaseItem];
		watch = GetItem(PlayerInfo[playerid][WatchSlotID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfWatchSlot[playerid], watch[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfWatchSlot[playerid], watch[ModelRotX], watch[ModelRotY], watch[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfWatchSlot[playerid], HexGradeColors[watch[Grade]-1][0]);
	}

	if(PlayerInfo[playerid][GlassesSlotID] == -1)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfGlassesSlot[playerid], 19034);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfGlassesSlot[playerid], 0.000000, -45.000000, 135.000000, 1.000000);
	}
	else
	{
		new glasses[BaseItem];
		glasses = GetItem(PlayerInfo[playerid][GlassesSlotID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfGlassesSlot[playerid], glasses[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfGlassesSlot[playerid], glasses[ModelRotX], glasses[ModelRotY], glasses[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfGlassesSlot[playerid], HexGradeColors[glasses[Grade]-1][0]);
	}

	if(PlayerInfo[playerid][RingSlot1ID] == -1)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfRingSlot1[playerid], 954);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfRingSlot1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	}
	else
	{
		new ring1[BaseItem];
		ring1 = GetItem(PlayerInfo[playerid][RingSlot1ID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfRingSlot1[playerid], ring1[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfRingSlot1[playerid], ring1[ModelRotX], ring1[ModelRotY], ring1[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfRingSlot1[playerid], HexGradeColors[ring1[Grade]-1][0]);
	}

	if(PlayerInfo[playerid][RingSlot2ID] == -1)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfRingSlot2[playerid], 954);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfRingSlot2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	}
	else
	{
		new ring2[BaseItem];
		ring2 = GetItem(PlayerInfo[playerid][RingSlot2ID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfRingSlot2[playerid], ring2[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfRingSlot2[playerid], ring2[ModelRotX], ring2[ModelRotY], ring2[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfRingSlot2[playerid], HexGradeColors[ring2[Grade]-1][0]);
	}

	if(PlayerInfo[playerid][AmuletteSlot1ID] == -1)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfAmuletteSlot1[playerid], 954);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfAmuletteSlot1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	}
	else
	{
		new amulette1[BaseItem];
		amulette1 = GetItem(PlayerInfo[playerid][AmuletteSlot1ID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfAmuletteSlot1[playerid], amulette1[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfAmuletteSlot1[playerid], amulette1[ModelRotX], amulette1[ModelRotY], amulette1[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfAmuletteSlot1[playerid], HexGradeColors[amulette1[Grade]-1][0]);
	}

	if(PlayerInfo[playerid][AmuletteSlot2ID] == -1)
	{
		PlayerTextDrawSetPreviewModel(playerid, ChrInfAmuletteSlot2[playerid], 954);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfAmuletteSlot2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	}
	else
	{
		new amulette2[BaseItem];
		amulette2 = GetItem(PlayerInfo[playerid][AmuletteSlot2ID]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfAmuletteSlot2[playerid], amulette2[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfAmuletteSlot2[playerid], amulette2[ModelRotX], amulette2[ModelRotY], amulette2[ModelRotZ], 1.000000);
		PlayerTextDrawBackgroundColor(playerid, ChrInfAmuletteSlot2[playerid], HexGradeColors[amulette2[Grade]-1][0]);
	}

	PlayerTextDrawShow(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfHatSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfWatchSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfGlassesSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRingSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRingSlot2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAmuletteSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAmuletteSlot2[playerid]);
}

stock CurrentPageContainsSlot(playerid, slotid)
{
	new page = GetPVarInt(playerid, "InvPage");
	if(page < 1 || page > MAX_INV_PAGES)
		return false;
	
	new first_page_slotid = (page-1) * MAX_PAGE_SLOTS;
	new last_page_slotid = first_page_slotid + MAX_PAGE_SLOTS - 1;

	return slotid >= first_page_slotid && slotid <= last_page_slotid;
}

stock GetPageSlotId(playerid, slotid)
{
	new page = GetPVarInt(playerid, "InvPage");
	if(page < 1 || page > MAX_INV_PAGES)
		return slotid;
	
	return slotid - (page-1) * MAX_PAGE_SLOTS;
}

stock GetSlotIdByPage(playerid, pageslot)
{
	new page = GetPVarInt(playerid, "InvPage");
	if(page < 1 || page > MAX_INV_PAGES)
		return pageslot;

	return pageslot + (page-1) * MAX_PAGE_SLOTS;
}

stock UpdateSlot(playerid, slotid)
{
	if(!IsInventoryOpen[playerid]) return;
	if(!CurrentPageContainsSlot(playerid, slotid)) return;

	new txd_slotid = GetPageSlotId(playerid, slotid);

    PlayerTextDrawHide(playerid, ChrInfInvSlot[playerid][txd_slotid]);
    PlayerTextDrawHide(playerid, ChrInfInvSlotCount[playerid][txd_slotid]);

	PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][txd_slotid], -1061109505);
	if(IsInvSlotEmpty(playerid, slotid))
	{
		PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][txd_slotid], 0.0, 0.0, 0.0, -1.0);
		PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][txd_slotid]);
		return;
	}

	new item[BaseItem];
	item = GetItem(PlayerInventory[playerid][slotid][ID]);

	PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][txd_slotid], HexGradeColors[item[Grade]-1][0]);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfInvSlot[playerid][txd_slotid], item[Model]);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][txd_slotid], item[ModelRotX], item[ModelRotY], item[ModelRotZ], 1.0);
	PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][txd_slotid]);

	new string[16];
	if(!IsEquip(PlayerInventory[playerid][slotid][ID]))
	{
		format(string, sizeof(string), "%d", PlayerInventory[playerid][slotid][Count]);
		PlayerTextDrawSetStringRus(playerid, ChrInfInvSlotCount[playerid][txd_slotid], string);
		PlayerTextDrawShow(playerid, ChrInfInvSlotCount[playerid][txd_slotid]);
	}
}

stock SetSlotSelection(playerid, slotid, bool:selection)
{
	if(!IsInventoryOpen[playerid]) return;
	if(!CurrentPageContainsSlot(playerid, slotid)) return;

	new txd_slotid = GetPageSlotId(playerid, slotid);

	if(IsInvSlotEmpty(playerid, slotid))
		PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][txd_slotid], selection ? 0x999999AA : -1061109505);
	else
	{
		new item[BaseItem];
		item = GetItem(PlayerInventory[playerid][slotid][ID]);
		PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][txd_slotid], selection ? HexGradeColors[item[Grade]-1][0] - 0x00000077 : HexGradeColors[item[Grade]-1][0]);
	}

	PlayerTextDrawHide(playerid, ChrInfInvSlot[playerid][txd_slotid]);
	PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][txd_slotid]);
}

stock SortInventory(playerid)
{
	if(!IsInventoryOpen[playerid]) return;

	IsSlotsBlocked[playerid] = true;
	SendClientMessage(playerid, COLOR_WHITE, "Идет сортировка инвентаря...");

	new tmpitem1[BaseItem];
	new tmpitem2[BaseItem];
	//sort by type
	for(new i = 0; i < MAX_SLOTS; i++)
    {
        for(new j = MAX_SLOTS-1; j > i; j--)
        {
			if(IsInvSlotEmpty(playerid, j) && IsInvSlotEmpty(playerid, j-1)) continue;
			if(IsInvSlotEmpty(playerid, j)) continue;
			if(IsInvSlotEmpty(playerid, j-1))
			{
				SwapInventoryItems(playerid, j, j-1);
				continue;
			}

			tmpitem1 = GetItem(PlayerInventory[playerid][j][ID]);
			tmpitem2 = GetItem(PlayerInventory[playerid][j-1][ID]);
            if(tmpitem2[Type] > tmpitem1[Type])
            {
				SwapInventoryItems(playerid, j, j-1);
            }
        }
    }
	//sort by rank
	for(new i = 0; i < MAX_SLOTS; i++)
    {
        for(new j = MAX_SLOTS-1; j > i; j--)
        {
			if(IsInvSlotEmpty(playerid, j) && IsInvSlotEmpty(playerid, j-1)) continue;
			if(IsInvSlotEmpty(playerid, j)) continue;
			if(IsInvSlotEmpty(playerid, j-1))
			{
				SwapInventoryItems(playerid, j, j-1);
				continue;
			}

			tmpitem1 = GetItem(PlayerInventory[playerid][j][ID]);
			tmpitem2 = GetItem(PlayerInventory[playerid][j-1][ID]);
            if(tmpitem2[Type] == tmpitem1[Type] && tmpitem2[MinRank] < tmpitem1[MinRank])
            {
				SwapInventoryItems(playerid, j, j-1);
            }
        }
    }
	//sort by grade
	for(new i = 0; i < MAX_SLOTS; i++)
    {
        for(new j = MAX_SLOTS-1; j > i; j--)
        {
			if(IsInvSlotEmpty(playerid, j) && IsInvSlotEmpty(playerid, j-1)) continue;
			if(IsInvSlotEmpty(playerid, j)) continue;
			if(IsInvSlotEmpty(playerid, j-1))
			{
				SwapInventoryItems(playerid, j, j-1);
				continue;
			}

			tmpitem1 = GetItem(PlayerInventory[playerid][j][ID]);
			tmpitem2 = GetItem(PlayerInventory[playerid][j-1][ID]);
            if(tmpitem2[Type] == tmpitem1[Type] && tmpitem2[MinRank] == tmpitem1[MinRank] && tmpitem2[Grade] < tmpitem1[Grade])
            {
				SwapInventoryItems(playerid, j, j-1);
            }
        }
    }

	UpdateInventory(playerid);

	SendClientMessage(playerid, COLOR_GREEN, "Сортировка инвентаря завершена");
	IsSlotsBlocked[playerid] = false;
}

stock SwapInventoryItems(playerid, idx1, idx2)
{
	new tmp[iInfo];
	tmp = PlayerInventory[playerid][idx2];
	PlayerInventory[playerid][idx2] = PlayerInventory[playerid][idx1];
	PlayerInventory[playerid][idx1] = tmp;
}

stock UpdateInventory(playerid)
{
	if(!IsInventoryOpen[playerid]) return;

	new page = GetPVarInt(playerid, "InvPage");
	if(page < 1)
		SetPVarInt(playerid, "InvPage", 1);
	else if(page > MAX_INV_PAGES)
		SetPVarInt(playerid, "InvPage", MAX_INV_PAGES);

	new string[32];
	format(string, sizeof(string), "%d/%d", page, MAX_INV_PAGES);
	PlayerTextDrawSetStringRus(playerid, ChrInfCurInv[playerid], string);

	for(new i = 0; i < MAX_PAGE_SLOTS; i++) 
	{
		new inv_slot = GetSlotIdByPage(playerid, i);
		new bool:selection = inv_slot == SelectedSlot[playerid];

		PlayerTextDrawHide(playerid, ChrInfInvSlot[playerid][i]);
		PlayerTextDrawHide(playerid, ChrInfInvSlotCount[playerid][i]);

		PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][i], selection ? 0x999999AA : -1061109505);
		if(PlayerInventory[playerid][inv_slot][ID] == -1)
		{
			PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][i], 0.0, 0.0, 0.0, -1.0);
			PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][i]);
			continue;
		}

		new item[BaseItem];
		item = GetItem(PlayerInventory[playerid][inv_slot][ID]);

		PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][i], selection ? HexGradeColors[item[Grade]-1][0] - 0x00000077 : HexGradeColors[item[Grade]-1][0]);
		PlayerTextDrawSetPreviewModel(playerid, ChrInfInvSlot[playerid][i], item[Model]);
		PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][i], item[ModelRotX], item[ModelRotY], item[ModelRotZ], 1.0);
		PlayerTextDrawShow(playerid, ChrInfInvSlot[playerid][i]);

		if(!IsEquip(PlayerInventory[playerid][inv_slot][ID]))
		{
			format(string, sizeof(string), "%d", PlayerInventory[playerid][inv_slot][Count]);
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

stock PendingMessage(name[], text[])
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
	format(query, sizeof(query), "INSERT INTO `pendings`(`PendingID`, `PlayerName`, `ItemID`, `Count`, `ItemMod`, `Text`) VALUES ('%d','%s','%d','%d','%s','%s')",
		p_id, name, -1, 0, "0 0 0 0 0 0 0", text
	);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	new id = GetPlayerID(name);
	if(id != -1 && IsPlayerConnected(id) && !FCNPC_IsValid(id))
		UpdatePlayerPost(id);
}

stock PendingItem(name[], id, mod[], count = 1, text[])
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
	format(query, sizeof(query), "INSERT INTO `pendings`(`PendingID`, `PlayerName`, `ItemID`, `Count`, `ItemMod`, `Text`) VALUES ('%d','%s','%d','%d','%s','%s')",
		p_id, name, id, count, ArrayToString(mod, MAX_MOD), text
	);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	new playerid = GetPlayerID(name);
	if(playerid != -1 && IsPlayerConnected(playerid) && !FCNPC_IsValid(playerid))
		UpdatePlayerPost(playerid);
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
	new price = (item[Price] * count) / 7;
	new tax = price / 99;
	price -= tax;

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
	GivePatriarchMoney(tax);

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

stock GetItemsCount(playerid, id)
{
	if(id == -1) return 0;

	if(IsPlayerConnected(playerid))
	{
		for(new i = 0; i < MAX_SLOTS; i++)
			if(PlayerInventory[playerid][i][ID] == id)
				return PlayerInventory[playerid][i][Count];
		return 0;
	}

	return 0;
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

stock DbItemExists(id)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `items` WHERE `ID` = '%d' LIMIT 1", id);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count;
	cache_get_row_count(count);
	cache_delete(q_result);

	if(count <= 0)
		return false;
	return true;
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
	cache_get_value_name_int(0, "IsTradeble", item[IsTradeble]);
	cache_get_value_name(0, "Name", string);
	sscanf(string, "s[255]", item[Name]);
	cache_get_value_name_int(0, "Type", item[Type]);
	cache_get_value_name_int(0, "Grade", item[Grade]);
	cache_get_value_name_int(0, "MinRank", item[MinRank]);
	cache_get_value_name(0, "Description", string);
	sscanf(string, "s[255]", item[Description]);
	cache_get_value_name(0, "Property", string);
	sscanf(string, "a<i>[3]", item[Property]);
	cache_get_value_name(0, "PropertyVal", string);
	sscanf(string, "a<i>[3]", item[PropertyVal]);
	cache_get_value_name_int(0, "Price", item[Price]);
	cache_get_value_name_int(0, "Model", item[Model]);
	cache_get_value_name_int(0, "ModelRotX", item[ModelRotX]);
	cache_get_value_name_int(0, "ModelRotY", item[ModelRotY]);
	cache_get_value_name_int(0, "ModelRotZ", item[ModelRotZ]);

	cache_delete(q_result);
	return item;
}

stock GetDungeon(id)
{
	new string[255];
	new query[255];
	new dungeon[BaseDungeon];
	format(query, sizeof(query), "SELECT * FROM `dungeons` WHERE `ID` = '%d' LIMIT 1", id);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count;
	cache_get_row_count(count);
	if(count <= 0)
	{
		format(string, sizeof(string), "Cannot get dungeon [ID = %d].", id);
		print(string);
		return dungeon;
	}

	dungeon[ID] = id;
	cache_get_value_name_int(0, "KeyID", dungeon[KeyID]);
	cache_get_value_name_int(0, "Rank", dungeon[Rank]);
	cache_get_value_name_int(0, "Type", dungeon[Type]);
	cache_get_value_name_int(0, "Damage", dungeon[Damage]);
	cache_get_value_name_int(0, "Defense", dungeon[Defense]);
	cache_get_value_name_int(0, "MobsCount", dungeon[MobsCount]);
	cache_get_value_name_int(0, "MobsTypesCount", dungeon[MobsTypesCount]);
	cache_get_value_name_int(0, "BossesCount", dungeon[BossesCount]);
	cache_get_value_name_int(0, "BossesTypesCount", dungeon[BossesTypesCount]);

	cache_get_value_name(0, "Mobs", string);
	sscanf(string, "a<i>[3]", dungeon[Mobs]);
	cache_get_value_name(0, "Bosses", string);
	sscanf(string, "a<i>[2]", dungeon[Bosses]);

	cache_delete(q_result);
	return dungeon;
}

stock IsModPotion(item_id)
{
	switch(item_id)
	{
		case 286..289: return true;
	}
	return false;
}

stock IsModStone(item_id)
{
	switch(item_id)
	{
		case 282..285: return true;
	}
	return false;
}

stock IsModifiableEquip(item_id)
{
	if(item_id == -1)
		return false;
	
	new item[BaseItem];
	item = GetItem(item_id);
	return item[Type] == ITEMTYPE_WEAPON || item[Type] == ITEMTYPE_ARMOR || item[Type] == ITEMTYPE_HAT || item[Type] == ITEMTYPE_GLASSES || item[Type] == ITEMTYPE_WATCH;
}

stock IsEquip(item_id)
{
	if(item_id == -1)
		return false;
	
	new item[BaseItem];
	item = GetItem(item_id);
	return item[Type] == ITEMTYPE_WEAPON || item[Type] == ITEMTYPE_ARMOR || item[Type] == ITEMTYPE_HAT || item[Type] == ITEMTYPE_GLASSES || item[Type] == ITEMTYPE_WATCH || item[Type] == ITEMTYPE_RING || item[Type] == ITEMTYPE_AMULETTE;
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
	SetPVarFloat(bossid, "HP", boss[HP]);
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
			SetPVarFloat(i, "HP", MaxHP[i]);
			SetPlayerHP(i, MaxHP[i]);
			TeleportToRandomArenaPos(i);
			SetPlayerInvulnearable(i, TOUR_INVULNEARABLE_TIME);
			SendClientMessage(i, COLOR_GREEN, "У вас есть 2 минуты, чтобы уничтожить босса.");
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

stock RemoveWorldBounds(playerid)
{
	SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
}

stock TeleportToDungeon(playerid, worldid)
{
	RemoveWorldBounds(playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, -63.6603,1518.1443,12.7500);
	SetPlayerVirtualWorld(playerid, worldid);
	SetPlayerFacingAngle(playerid, 292.1078);
	SetCameraBehindPlayer(playerid);
	SetPlayerWorldBounds(playerid, 93.0163, -75.3017, 1584.2813, 1463.9381);
}

stock TeleportToRandomWatcherPos(playerid)
{
	new idx = random(MAX_WATCHERS_POSITIONS);
	RemoveWorldBounds(playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid, WatchersPositions[idx][0], WatchersPositions[idx][1], WatchersPositions[idx][2]);
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
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` = '%s' AND `IsWatcher`=0 LIMIT 20", AccountLogin[playerid]);
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
	PlayerTextDrawSetStringRus(playerid, InfItemType[playerid], ResolveItemType(item[Type]));

	for(new i = 0; i < MAX_PROPERTIES; i++)
	{
		PlayerTextDrawSetStringRus(playerid, InfItemEffect[playerid][i], GetItemEffectString(item[Property][i], item[PropertyVal][i]));
		if(item[Property][i] == PROPERTY_HEAL || item[Property][i] == PROPERTY_INVUL || item[Property][i] == PROPERTY_REGEN)
			PlayerTextDrawColor(playerid, InfItemEffect[playerid][i], 16711935);
		else
			PlayerTextDrawColor(playerid, InfItemEffect[playerid][i], -1);
		
		PlayerTextDrawShow(playerid, InfItemEffect[playerid][i]);
	}

	format(string, sizeof(string), "Цена: %s$", FormatMoney(item[Price]));
	PlayerTextDrawSetStringRus(playerid, InfPrice[playerid], string);

	PlayerTextDrawShow(playerid, InfBox[playerid]);
	PlayerTextDrawShow(playerid, InfTxt1[playerid]);
	PlayerTextDrawShow(playerid, InfDelim1[playerid]);
	PlayerTextDrawShow(playerid, InfItemIcon[playerid]);
	PlayerTextDrawShow(playerid, InfItemName[playerid]);
	PlayerTextDrawShow(playerid, InfItemType[playerid]);
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
	PlayerTextDrawHide(playerid, InfItemEffect[playerid][2]);
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
	PlayerTextDrawHide(playerid, EqInfDelim2[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim3[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim4[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim5[playerid]);
	PlayerTextDrawHide(playerid, EqInfPrice[playerid]);
	PlayerTextDrawHide(playerid, EqInfClose[playerid]);
	PlayerTextDrawHide(playerid, EqInfItemType[playerid]);
	PlayerTextDrawHide(playerid, EqInfItemMinRank[playerid]);
	PlayerTextDrawHide(playerid, EqInfItemGrade[playerid]);
	PlayerTextDrawHide(playerid, EqInfTrading[playerid]);
	for(new i = 0; i < 2; i++)
		PlayerTextDrawHide(playerid, EqInfModStat[playerid][i]);
	for(new i = 0; i < 3; i++)
		PlayerTextDrawHide(playerid, EqInfBonusStat[playerid][i]);
	for(new i = 0; i < MAX_MOD; i++)
		PlayerTextDrawHide(playerid, EqInfMod[playerid][i]);
	for(new i = 0; i < 3; i++)
		PlayerTextDrawHide(playerid, EqInfDescriptionStr[playerid][i]);

	Windows[playerid][EquipInfo] = false;
}

stock ResolveItemType(type)
{
	new string[64];
	switch(type) 
	{
	    case ITEMTYPE_WEAPON: string = "Оружие";
		case ITEMTYPE_ARMOR: string = "Доспех";
		case ITEMTYPE_HAT: string = "Шапка";
		case ITEMTYPE_WATCH: string = "Часы";
		case ITEMTYPE_GLASSES: string = "Очки";
		case ITEMTYPE_AMULETTE: string = "Амулет";
		case ITEMTYPE_RING: string = "Кольцо";
		case ITEMTYPE_BOX: string = "Коробка";
		case ITEMTYPE_MODIFIER: string = "Модификатор";
		case ITEMTYPE_PASSIVE: string = "Пассивный предмет";
	    default: string = "Материал";
	}
	return string;
}

stock ResolveItemGrade(grade)
{
	new string[8];
	switch(grade) 
	{
	    case GRADE_B: string = "B";
		case GRADE_C: string = "C";
		case GRADE_L: string = "L";
		case GRADE_R: string = "R";
		case GRADE_S: string = "S";
	    default: string = "N";
	}
	return string;
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

	format(string, sizeof(string), "Тип: %s", ResolveItemType(item[Type]));
	PlayerTextDrawSetStringRus(playerid, EqInfItemType[playerid], string);

	format(string, sizeof(string), "Мин. ранг: %s", GetRankInterval(item[MinRank]));
	PlayerTextDrawSetStringRus(playerid, EqInfItemMinRank[playerid], string);
	new min_rank = item[MinRank];
	if(HasItem(playerid, ITEM_SHAZOK_LETTER_ID))
		min_rank--;
	if(PlayerInfo[playerid][Rank] >= min_rank)
		PlayerTextDrawColor(playerid, EqInfItemMinRank[playerid], -1);
	else
		PlayerTextDrawColor(playerid, EqInfItemMinRank[playerid], 0xFF0000FF);

	format(string, sizeof(string), "Грейд: %s", ResolveItemGrade(item[Grade]));
	PlayerTextDrawSetStringRus(playerid, EqInfItemGrade[playerid], string);

	for(new i = 0; i < MAX_PROPERTIES; i++)
	{
		if(item[Property][i] == PROPERTY_HEAL || item[Property][i] == PROPERTY_INVUL)
			PlayerTextDrawColor(playerid, EqInfBonusStat[playerid][i], 16711935);
		else
			PlayerTextDrawColor(playerid, EqInfBonusStat[playerid][i], -1);

		PlayerTextDrawSetStringRus(playerid, EqInfBonusStat[playerid][i], GetItemEffectString(item[Property][i], item[PropertyVal][i]));
	}

	format(string, sizeof(string), "Цена: %s$", FormatMoney(item[Price]));
	PlayerTextDrawSetStringRus(playerid, EqInfPrice[playerid], string);

	if(item[IsTradeble] == 1)
		PlayerTextDrawSetStringRus(playerid, EqInfTrading[playerid], "Обмен: возможен");
	else
		PlayerTextDrawSetStringRus(playerid, EqInfTrading[playerid], "Обмен: невозможен");

	PlayerTextDrawShow(playerid, EqInfBox[playerid]);
	PlayerTextDrawShow(playerid, EqInfTxt1[playerid]);
	PlayerTextDrawShow(playerid, EqInfTxt2[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim1[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemIcon[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemName[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemType[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemMinRank[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemGrade[playerid]);
	PlayerTextDrawShow(playerid, EqInfBonusStat[playerid][0]);
	PlayerTextDrawShow(playerid, EqInfBonusStat[playerid][1]);
	PlayerTextDrawShow(playerid, EqInfBonusStat[playerid][2]);
	PlayerTextDrawShow(playerid, EqInfDelim2[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim3[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim4[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim5[playerid]);
	PlayerTextDrawShow(playerid, EqInfPrice[playerid]);
	PlayerTextDrawShow(playerid, EqInfTrading[playerid]);
	PlayerTextDrawShow(playerid, EqInfClose[playerid]);

	for(new i = 0; i < MAX_MOD; i++)
	{
		PlayerTextDrawSetPreviewModel(playerid, EqInfMod[playerid][i], GetModModel(mod[i]));
		PlayerTextDrawSetPreviewRot(playerid, EqInfMod[playerid][i], 0.000000, 0.000000, 0.000000, 1.000000);
		PlayerTextDrawShow(playerid, EqInfMod[playerid][i]);
	}

	new modifiers[2];
	modifiers = GetModifiers(mod);
	new modifiers_count = GetModifiersCount(modifiers);
	new modifiers_effects_descs[2][255];
	modifiers_effects_descs = MapModifiersDescs(mod, modifiers, modifiers_count);
	for(new i = 0; i < 2; i++)
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
		format(string, sizeof(string), "Урон: %d-%d", damage[0], damage[1]);
	}
	else if(item[Type] == ITEMTYPE_ARMOR || item[Type] == ITEMTYPE_HAT || item[Type] == ITEMTYPE_GLASSES || item[Type] == ITEMTYPE_WATCH)
	{
		new bool:mod_exists = false;
		mod_exists = ModifierExists(mod, MOD_DEFENSE);
		PlayerTextDrawColor(playerid, EqInfMainStat[playerid], mod_exists ? 16711935 : -1);
		new defense;
		defense = GetArmorBaseDefense(itemid);
		if(mod_exists)
			defense = GetArmorModifiedDefense(defense, GetModifierLevel(mod, MOD_DEFENSE));
		format(string, sizeof(string), "Защита: %d", defense);
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
	format(string, sizeof(string), "%s: %d-%d", "Урон", PlayerInfo[playerid][DamageMin], PlayerInfo[playerid][DamageMax]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDamage[playerid], string);
	format(string, sizeof(string), "%s: %d", "Защита", PlayerInfo[playerid][Defense]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDefense[playerid], string);
	format(string, sizeof(string), "%s: %d", "Точность", PlayerInfo[playerid][Accuracy]);
	PlayerTextDrawSetStringRus(playerid, ChrInfAccuracy[playerid], string);
	format(string, sizeof(string), "%s: %d", "Уклонение", PlayerInfo[playerid][Dodge]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDodge[playerid], string);
	format(string, sizeof(string), "%s: %d", "Крит", PlayerInfo[playerid][Crit]);
	PlayerTextDrawSetStringRus(playerid, ChrInfCrit[playerid], string);
}

stock ShowMainMenu(playerid)
{
	new listitems[] = "Информация о персонаже\nСменить персонажа\nПереключиться на наблюдателя\nБыстрое перемещение";
	ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_TABLIST, "Bourgeois Circus", listitems, "Далее", "Закрыть");
}

stock ShowCharInfo(playerid)
{
    if(PlayerInfo[playerid][IsWatcher] != 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "Данная функция недоступна для наблюдателя.");
		return;
	}

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

	new inv_page = GetPVarInt(playerid, "InvPage");
	if(inv_page < 1)
		inv_page = 1;
	if(inv_page > MAX_INV_PAGES)
		inv_page = MAX_INV_PAGES;

	format(string, sizeof(string), "%d/%d", inv_page, MAX_INV_PAGES);
	PlayerTextDrawSetStringRus(playerid, ChrInfCurInv[playerid], string);

	UpdatePlayerStatsVisual(playerid);

	PlayerTextDrawShow(playerid, ChrInfoBox[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoHeader[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDelim1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDelim2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDelim3[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDelim4[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDelim5[playerid]);
	PlayerTextDrawShow(playerid, ChrInfMaxHP[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDamage[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDefense[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAccuracy[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDodge[playerid]);
	PlayerTextDrawShow(playerid, ChrInfCrit[playerid]);
	PlayerTextDrawShow(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfHatSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfWatchSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfGlassesSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRingSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRingSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAmuletteSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAmuletteSlot2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfClose[playerid]);
	PlayerTextDrawShow(playerid, ChrInfText1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfText2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAllRate[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRate[playerid]);
	PlayerTextDrawShow(playerid, ChrInfPersonalRate[playerid]);
	PlayerTextDrawShow(playerid, ChrInfButUse[playerid]);
	PlayerTextDrawShow(playerid, ChrInfButInfo[playerid]);
	PlayerTextDrawShow(playerid, ChrInfButSort[playerid]);
	PlayerTextDrawShow(playerid, ChrInfButDel[playerid]);
	PlayerTextDrawShow(playerid, ChrInfButMod[playerid]);
	PlayerTextDrawShow(playerid, ChrInfCurInv[playerid]);
	PlayerTextDrawShow(playerid, ChrInfNextInvBtn[playerid]);
	PlayerTextDrawShow(playerid, ChrInfPrevInvBtn[playerid]);

	UpdateEquipSlots(playerid);
	
	IsInventoryOpen[playerid] = true;
	UpdateInventory(playerid);

	Windows[playerid][CharInfo] = true;
	SelectTextDraw(playerid,0xCCCCFF65);
}

stock HideCharInfo(playerid)
{
	PlayerTextDrawHide(playerid, ChrInfoBox[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoHeader[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDelim1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDelim2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDelim3[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDelim4[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDelim5[playerid]);
	PlayerTextDrawHide(playerid, ChrInfMaxHP[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDamage[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDefense[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAccuracy[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDodge[playerid]);
	PlayerTextDrawHide(playerid, ChrInfCrit[playerid]);
	PlayerTextDrawHide(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfHatSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfWatchSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfGlassesSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfRingSlot1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfRingSlot2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAmuletteSlot1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAmuletteSlot2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfClose[playerid]);
	PlayerTextDrawHide(playerid, ChrInfText1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfText2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAllRate[playerid]);
	PlayerTextDrawHide(playerid, ChrInfRate[playerid]);
	PlayerTextDrawHide(playerid, ChrInfPersonalRate[playerid]);
	PlayerTextDrawHide(playerid, ChrInfButUse[playerid]);
	PlayerTextDrawHide(playerid, ChrInfButInfo[playerid]);
	PlayerTextDrawHide(playerid, ChrInfButSort[playerid]);
	PlayerTextDrawHide(playerid, ChrInfButDel[playerid]);
	PlayerTextDrawHide(playerid, ChrInfButMod[playerid]);
	PlayerTextDrawHide(playerid, ChrInfCurInv[playerid]);
	PlayerTextDrawHide(playerid, ChrInfNextInvBtn[playerid]);
	PlayerTextDrawHide(playerid, ChrInfPrevInvBtn[playerid]);

	for(new i = 0; i < MAX_PAGE_SLOTS; i++)
	{
		PlayerTextDrawHide(playerid, ChrInfInvSlot[playerid][i]);
		PlayerTextDrawHide(playerid, ChrInfInvSlotCount[playerid][i]);
	}

	IsInventoryOpen[playerid] = false;
	Windows[playerid][CharInfo] = false;
}

stock ShowCmbWindow(playerid)
{
	Windows[playerid][Cmb] = true;
	IsSlotsBlocked[playerid] = true;

	HideOpenedInfoWindows(playerid);

	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		PlayerTextDrawSetPreviewModel(playerid, CmbItemSlot[playerid][i], -1);
		PlayerTextDrawSetPreviewRot(playerid, CmbItemSlot[playerid][i], 0, 0, 0);
		PlayerTextDrawBackgroundColor(playerid, CmbItemSlot[playerid][i], -1061109505);
		PlayerTextDrawShow(playerid, CmbItemSlot[playerid][i]);
	}

	PlayerTextDrawShow(playerid, CmbBox[playerid]);
	PlayerTextDrawShow(playerid, CmbTxt1[playerid]);
	PlayerTextDrawShow(playerid, CmbTxt2[playerid]);
	PlayerTextDrawShow(playerid, CmbTxt3[playerid]);
	PlayerTextDrawShow(playerid, CmbTxt4[playerid]);
	PlayerTextDrawShow(playerid, CmbDelim1[playerid]);
	PlayerTextDrawShow(playerid, CmbBtn[playerid]);
	PlayerTextDrawShow(playerid, CmbBtnBox[playerid]);
	PlayerTextDrawShow(playerid, CmbClose[playerid]);

	SelectTextDraw(playerid,0xCCCCFF65);
	if(!IsInventoryOpen[playerid])
		ShowCharInfo(playerid);
}

stock HideCmbWindow(playerid)
{
	Windows[playerid][Cmb] = false;
	IsSlotsBlocked[playerid] = false;

	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		CmbItem[playerid][i] = -1;
		CmbItemCount[playerid][i] = 0;
		PlayerTextDrawHide(playerid, CmbItemSlot[playerid][i]);
		PlayerTextDrawHide(playerid, CmbItemSlotCount[playerid][i]);
	}

	PlayerTextDrawHide(playerid, CmbBox[playerid]);
	PlayerTextDrawHide(playerid, CmbTxt1[playerid]);
	PlayerTextDrawHide(playerid, CmbTxt2[playerid]);
	PlayerTextDrawHide(playerid, CmbTxt3[playerid]);
	PlayerTextDrawHide(playerid, CmbTxt4[playerid]);
	PlayerTextDrawHide(playerid, CmbDelim1[playerid]);
	PlayerTextDrawHide(playerid, CmbBtn[playerid]);
	PlayerTextDrawHide(playerid, CmbBtnBox[playerid]);
	PlayerTextDrawHide(playerid, CmbClose[playerid]);

	if(IsInventoryOpen[playerid])
		HideCharInfo(playerid);
	CancelSelectTextDraw(playerid);
}

stock ShowMarketSellWindow(playerid)
{
	Windows[playerid][MarketSell] = true;
	IsSlotsBlocked[playerid] = true;

	HideOpenedInfoWindows(playerid);

	MarketSellingItem[playerid] = EmptyMarketSellingItem;

	PlayerTextDrawShow(playerid, MpBox[playerid]);
	PlayerTextDrawShow(playerid, MpDelim1[playerid]);
	PlayerTextDrawShow(playerid, MpClose[playerid]);
	PlayerTextDrawShow(playerid, MpTxt1[playerid]);
	PlayerTextDrawShow(playerid, MpTxt2[playerid]);
	PlayerTextDrawShow(playerid, MpDelim2[playerid]);

	PlayerTextDrawSetPreviewModel(playerid, MpItem[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, MpItem[playerid], 0, 0, 0);
	PlayerTextDrawBackgroundColor(playerid, MpItem[playerid], -1061109505);
	PlayerTextDrawShow(playerid, MpItem[playerid]);

	SelectTextDraw(playerid,0xCCCCFF65);
	if(!IsInventoryOpen[playerid])
		ShowCharInfo(playerid);
}

stock HideMarketSellWindow(playerid)
{
	Windows[playerid][MarketSell] = false;
	IsSlotsBlocked[playerid] = false;

	MarketSellingItem[playerid] = EmptyMarketSellingItem;

	PlayerTextDrawHide(playerid, MpBox[playerid]);
	PlayerTextDrawHide(playerid, MpDelim1[playerid]);
	PlayerTextDrawHide(playerid, MpClose[playerid]);
	PlayerTextDrawHide(playerid, MpTxt1[playerid]);
	PlayerTextDrawHide(playerid, MpTxt2[playerid]);
	PlayerTextDrawHide(playerid, MpDelim2[playerid]);
	PlayerTextDrawHide(playerid, MpTxtPrice[playerid]);
	PlayerTextDrawHide(playerid, MpTxtCount[playerid]);
	PlayerTextDrawHide(playerid, MpBtn1Box[playerid]);
	PlayerTextDrawHide(playerid, MpBtn2Box[playerid]);
	PlayerTextDrawHide(playerid, MpBtn1[playerid]);
	PlayerTextDrawHide(playerid, MpBtn2[playerid]);
	PlayerTextDrawHide(playerid, MpBtnBox[playerid]);
	PlayerTextDrawHide(playerid, MpBtn[playerid]);
	PlayerTextDrawHide(playerid, MpItem[playerid]);
	PlayerTextDrawHide(playerid, MpItemCount[playerid]);

	if(IsInventoryOpen[playerid])
		HideCharInfo(playerid);
	CancelSelectTextDraw(playerid);
}

stock UpdateMarketSellWindow(playerid)
{
	PlayerTextDrawHide(playerid, MpItem[playerid]);
	PlayerTextDrawHide(playerid, MpItemCount[playerid]);
	PlayerTextDrawHide(playerid, MpTxtCount[playerid]);
	PlayerTextDrawHide(playerid, MpBtn2Box[playerid]);
	PlayerTextDrawHide(playerid, MpBtn2[playerid]);

	PlayerTextDrawSetPreviewModel(playerid, MpItem[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, MpItem[playerid], 0, 0, 0);
	PlayerTextDrawBackgroundColor(playerid, MpItem[playerid], -1061109505);

	if(MarketSellingItem[playerid][ID] != -1)
	{
		new item[BaseItem];
		new string[128];
		item = GetItem(MarketSellingItem[playerid][ID]);

		PlayerTextDrawSetPreviewModel(playerid, MpItem[playerid], item[Model]);
		PlayerTextDrawSetPreviewRot(playerid, MpItem[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
		PlayerTextDrawBackgroundColor(playerid, MpItem[playerid], HexGradeColors[item[Grade]-1][0]);

		if(!IsEquip(MarketSellingItem[playerid][ID]))
		{
			format(string, sizeof(string), "%d", MarketSellingItem[playerid][Count]);
			PlayerTextDrawSetStringRus(playerid, MpItemCount[playerid], string);
			PlayerTextDrawShow(playerid, MpItemCount[playerid]);

			format(string, sizeof(string), "Кол-во: %d", MarketSellingItem[playerid][Count]);
			PlayerTextDrawSetStringRus(playerid, MpTxtCount[playerid], string);
			PlayerTextDrawShow(playerid, MpTxtCount[playerid]);

			PlayerTextDrawShow(playerid, MpBtn2Box[playerid]);
			PlayerTextDrawShow(playerid, MpBtn2[playerid]);
		}

		format(string, sizeof(string), "Цена: %s$", FormatMoney(MarketSellingItem[playerid][Price]));
		PlayerTextDrawSetStringRus(playerid, MpTxtPrice[playerid], string);
		PlayerTextDrawShow(playerid, MpTxtPrice[playerid]);

		PlayerTextDrawShow(playerid, MpBtn1Box[playerid]);
		PlayerTextDrawShow(playerid, MpBtn1[playerid]);
		PlayerTextDrawShow(playerid, MpBtnBox[playerid]);

		PlayerTextDrawShow(playerid, MpBtn[playerid]);
	}
	else
	{
		PlayerTextDrawHide(playerid, MpTxtPrice[playerid]);
		PlayerTextDrawHide(playerid, MpTxtCount[playerid]);
		PlayerTextDrawHide(playerid, MpBtn1Box[playerid]);
		PlayerTextDrawHide(playerid, MpBtn2Box[playerid]);
		PlayerTextDrawHide(playerid, MpBtn1[playerid]);
		PlayerTextDrawHide(playerid, MpBtn2[playerid]);
		PlayerTextDrawHide(playerid, MpBtnBox[playerid]);
		PlayerTextDrawHide(playerid, MpBtn[playerid]);
	}

	PlayerTextDrawShow(playerid, MpItem[playerid]);
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
		format(string, sizeof(string), "%d модификация", mod_level+1);
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
		format(string, sizeof(string), "%d модификация", mod_level+1);
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

stock CmbItemExist(playerid, item)
{
	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		if(CmbItem[playerid][i] == item)
			return true;
	}
	
	return false;
}

stock SetCmbItem(playerid, slot, invslot, item, count)
{
	if(slot > MAX_CMB_ITEMS || slot < 1)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинации", "Недопустимый предмет.", "Закрыть", "");
		return;
	}

	if(CmbItemExist(playerid, item))
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинации", "Предмет уже зарегистрирован.", "Закрыть", "");
		return;
	}
	
	CmbItem[playerid][slot-1] = item;
	CmbItemCount[playerid][slot-1] = count;
	CmbItemInvSlot[playerid][slot-1] = invslot;

	UpdateCmbWindow(playerid);

	SetSlotSelection(playerid, SelectedSlot[playerid], false);
	SelectedSlot[playerid] = -1;
}

stock UpdateCmbWindow(playerid)
{
	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		PlayerTextDrawHide(playerid, CmbItemSlot[playerid][i]);
		PlayerTextDrawHide(playerid, CmbItemSlotCount[playerid][i]);

		PlayerTextDrawSetPreviewModel(playerid, CmbItemSlot[playerid][i], -1);
		PlayerTextDrawSetPreviewRot(playerid, CmbItemSlot[playerid][i], 0, 0, 0);
		PlayerTextDrawBackgroundColor(playerid, CmbItemSlot[playerid][i], -1061109505);

		if(CmbItem[playerid][i] != -1)
		{
			new item[BaseItem];
			item = GetItem(CmbItem[playerid][i]);

			PlayerTextDrawSetPreviewModel(playerid, CmbItemSlot[playerid][i], item[Model]);
			PlayerTextDrawSetPreviewRot(playerid, CmbItemSlot[playerid][i], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
			PlayerTextDrawBackgroundColor(playerid, CmbItemSlot[playerid][i], HexGradeColors[item[Grade]-1][0]);

			if(!IsEquip(item[ID]))
			{
			    new string[64];
				format(string, sizeof(string), "%d", CmbItemCount[playerid][i]);
				PlayerTextDrawSetStringRus(playerid, CmbItemSlotCount[playerid][i], string);
				PlayerTextDrawShow(playerid, CmbItemSlotCount[playerid][i]);
			}
		}

		PlayerTextDrawShow(playerid, CmbItemSlot[playerid][i]);
	}
}

stock GetAvModLvlByModifierID(id)
{
	new levels[2];

	switch(id)
	{
		case 321, 327, 333: { levels[0] = 1; levels[1] = 2; }
		case 322, 328, 334: { levels[0] = 1; levels[1] = 3; }
		case 323, 329, 335: { levels[0] = 2; levels[1] = 3; }
		case 324, 330, 336: { levels[0] = 2; levels[1] = 4; }
		case 325, 331, 337: { levels[0] = 2; levels[1] = 5; }
		case 326, 332, 338: { levels[0] = 2; levels[1] = 6; }

		case 339, 344, 349: { levels[0] = 3; levels[1] = 4; }
		case 340, 345, 350: { levels[0] = 3; levels[1] = 5; }
		case 341, 346, 351: { levels[0] = 3; levels[1] = 6; }
		case 342, 347, 352: { levels[0] = 4; levels[1] = 5; }
		case 343, 348, 353: { levels[0] = 4; levels[1] = 6; }

		case 354, 358, 362: { levels[0] = 4; levels[1] = 7; }
		case 355, 359, 363: { levels[0] = 5; levels[1] = 6; }
		case 356, 360, 364: { levels[0] = 5; levels[1] = 7; }
		case 357, 361, 365: { levels[0] = 6; levels[1] = 7; }

		default: { levels[0] = 0; levels[1] = 0; }
	}

	return levels;
}

stock GetModifierModLevel(levels[])
{
	new level = levels[0];
	new rnd = random(100);

	switch(levels[0])
	{
		case 1:
		{
			switch(levels[1])
			{
				case 2:
				{
					if(rnd < 60) level = 1;
					else level = 2;
				}
				case 3:
				{
					if(rnd < 50) level = 1;
					else if(rnd < 85) level = 2;
					else level = 3;
				}
			}
		}
		case 2:
		{
			switch(levels[1])
			{
				case 3:
				{
					if(rnd < 60) level = 2;
					else level = 3;
				}
				case 4:
				{
					if(rnd < 50) level = 2;
					else if(rnd < 85) level = 3;
					else level = 4;
				}
				case 5:
				{
					if(rnd < 40) level = 2;
					else if(rnd < 60) level = 3;
					else if(rnd < 90) level = 4;
					else level = 5;
				}
				case 6:
				{
					if(rnd < 35) level = 2;
					else if(rnd < 55) level = 3;
					else if(rnd < 85) level = 4;
					else if(rnd < 95) level = 5;
					else level = 6;
				}
			}
		}
		case 3:
		{
			switch(levels[1])
			{
				case 4:
				{
					if(rnd < 60) level = 3;
					else level = 4;
				}
				case 5:
				{
					if(rnd < 50) level = 3;
					else if(rnd < 85) level = 4;
					else level = 5;
				}
				case 6:
				{
					if(rnd < 50) level = 3;
					else if(rnd < 77) level = 4;
					else if(rnd < 93) level = 5;
					else level = 6;
				}
			}
		}
		case 4:
		{
			switch(levels[1])
			{
				case 5:
				{
					if(rnd < 60) level = 4;
					else level = 5;
				}
				case 6:
				{
					if(rnd < 70) level = 4;
					else if(rnd < 92) level = 5;
					else level = 6;
				}
				case 7:
				{
					if(rnd < 60) level = 4;
					else if(rnd < 90) level = 5;
					else if(rnd < 97) level = 6;
					else level = 7;
				}
			}
		}
		case 5:
		{
			switch(levels[1])
			{
				case 6:
				{
					if(rnd < 80) level = 5;
					else level = 6;
				}
				case 7:
				{
					if(rnd < 80) level = 5;
					else if(rnd < 95) level = 6;
					else level = 7;
				}
			}
		}
		case 6:
		{
			switch(levels[1])
			{
				case 7:
				{
					if(rnd < 85) level = 6;
					else level = 7;
				}
			}
		}
	}

	return level;
}

stock SetModLevel(playerid, slotid, stoneid, level, reset_mod = true)
{
	new modifier = GetModifierByStone(stoneid);

	if(reset_mod)
	{
		for(new i = 0; i < MAX_MOD; i++)
			PlayerInventory[playerid][slotid][Mod][i] = 0;
		for(new i = 0; i < level; i++)
			PlayerInventory[playerid][slotid][Mod][i] = modifier;
	}
	else
	{
		for(new i = 0; i < level; i++)
		{
			if(PlayerInventory[playerid][slotid][Mod][i] != 0) continue;
			PlayerInventory[playerid][slotid][Mod][i] = modifier;
		}
	}
}

stock CombineWithModifier(playerid)
{
	new price = 1000;
	if(PlayerInfo[playerid][Cash] < price)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "Недостаточно средств.", "Закрыть", "");
		return;
	}
	
	new equip[BaseItem];
	new itemid = CmbItem[playerid][2];
	equip = GetItem(CmbItem[playerid][0]);
	if( ((itemid == 283 || itemid == 285) && equip[Type] == ITEMTYPE_WEAPON) ||
		((itemid == 282 || itemid == 284) && equip[Type] == ITEMTYPE_ARMOR) ||
		((itemid == 282 || itemid == 284) && equip[Type] == ITEMTYPE_HAT) ||
		(itemid == 282 && equip[Type] == ITEMTYPE_GLASSES) || 
		(itemid == 282 && equip[Type] == ITEMTYPE_WATCH) )
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "Нельзя использовать этот камень.", "Закрыть", "");
		return;
	}

	new modifierid = CmbItem[playerid][1];
	new mdf[BaseItem];
	mdf = GetItem(modifierid);
	if(mdf[Grade] != equip[Grade])
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "Данную экипировку нельзя комбинировать с этим модификатором.", "Закрыть", "");
		return;
	}

	new available_mod_levels[2];
	available_mod_levels = GetAvModLvlByModifierID(CmbItem[playerid][1]);
	new mod_level = GetModifierModLevel(available_mod_levels);
	SetModLevel(playerid, CmbItemInvSlot[playerid][0], CmbItem[playerid][2], mod_level);
	DeleteItem(playerid, CmbItemInvSlot[playerid][1], 1);

	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		CmbItem[playerid][i] = -1;
		CmbItemCount[playerid][i] = 0;
		CmbItemInvSlot[playerid][i] = -1;
	}

	UpdateCmbWindow(playerid);

	if(mod_level >= 5)
	{
		new cng_string[255];
		new name[255];
		GetPlayerName(playerid, name, sizeof(name));
		format(cng_string, sizeof(cng_string), "{%s}%s{FF6347} успешно модернизирован %d на стадии {%s}%s.", 
			GetColorByRate(PlayerInfo[playerid][Rate]), name, mod_level, GetGradeColor(equip[Grade]), equip[Name]
		);
		SendClientMessageToAll(COLOR_LIGHTRED, cng_string);
	}
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "{33CC00}Успешная комбинация.", "Закрыть", "");
}

stock CombineItems(playerid)
{
	if(IsModifiableEquip(CmbItem[playerid][0]))
	{
		new s_item[BaseItem];
		s_item = GetItem(CmbItem[playerid][1]);
		if(s_item[Type] == ITEMTYPE_MODIFIER && CmbItemCount[playerid][1] == 1 && IsModStone(CmbItem[playerid][2]) && CmbItemCount[playerid][2] == 1)
		{
			CombineWithModifier(playerid);
			return;
		}
	}

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `combinations` WHERE \
	`Item1_ID` = '%d' AND \
	`Item1_Count` = '%d' AND \
	`Item2_ID` = '%d' AND \
	`Item2_Count` = '%d' AND \
	`Item3_ID` = '%d' AND \
	`Item3_Count` = '%d' LIMIT 1",
		CmbItem[playerid][0], CmbItemCount[playerid][0],
		CmbItem[playerid][1], CmbItemCount[playerid][1],
		CmbItem[playerid][2], CmbItemCount[playerid][2]
	);

	new Cache:q_result = mysql_query(sql_handle, query);
	new rows = 0;
	cache_get_row_count(rows);
	if(rows <= 0)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "Комбинация не существует.", "Закрыть", "");
		cache_delete(q_result);
		return;
	}

	new chance;
	new price;
	new result_id;
	new result_count;

	cache_get_value_name_int(0, "Chance", chance);
	cache_get_value_name_int(0, "Price", price);
	cache_get_value_name_int(0, "ResultID", result_id);
	cache_get_value_name_int(0, "ResultCount", result_count);

	cache_delete(q_result);

	if(PlayerInfo[playerid][Cash] < price)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "Недостаточно средств.", "Закрыть", "");
		return;
	}

	if(IsInventoryFull(playerid))
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "Инвентарь полон.", "Закрыть", "");
		return;
	}

	new bool:success = CheckChance(chance);

	PlayerInfo[playerid][Cash] -= price;
	GivePlayerMoney(playerid, -price);

	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		if(!success && IsEquip(CmbItem[playerid][i]))
			continue;
		
		if(!success && CmbItem[playerid][i] >= 308 && CmbItem[playerid][i] <= 311)
			continue;
		
		if(!success && CmbItem[playerid][i] >= 297 && CmbItem[playerid][i] <= 304)
			continue;

		DeleteItem(playerid, CmbItemInvSlot[playerid][i], CmbItemCount[playerid][i]);
	}

	if(success)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "{33CC00}Успешная комбинация.", "Закрыть", "");
		if(IsEquip(result_id))
		{
			if(result_id >= 245 && result_id <= 266)
			{
				if(CheckChance(5))
					result_id += 2;
				else if(CheckChance(25))
					result_id += 1;
			}

			new eq_item[BaseItem];
			eq_item = GetItem(result_id);

			AddEquip(playerid, result_id, MOD_CLEAR);

			if(eq_item[Grade] >= GRADE_C)
			{
				new string[255];
				format(string, sizeof(string), "{%s}%s {ffffff}приобрел {%s}[%s]{ffffff}.", 
					GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name], GetGradeColor(eq_item[Grade]), eq_item[Name]
				);
				SendClientMessageToAll(0xFFFFFFFF, string);
			}
		}
		else
			AddItem(playerid, result_id, result_count);
	}
	else
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "{CC3300}Комбинация неудачна.", "Закрыть", "");

	new bool:items_exists = true;
	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		if(CmbItem[playerid][i] == -1)
			continue;
		if(!HasItem(playerid, CmbItem[playerid][i], CmbItemCount[playerid][i]))
		{
			items_exists = false;
			break;
		}
	}

	if(success || (!success && !items_exists))
	{
		for(new i = 0; i < MAX_CMB_ITEMS; i++)
		{
			CmbItem[playerid][i] = -1;
			CmbItemCount[playerid][i] = 0;
			CmbItemInvSlot[playerid][i] = -1;
		}
	}

	UpdateCmbWindow(playerid);
}

stock UpgradeItem(playerid, itemslot, stoneid, potionid = -1)
{
	new itemid = PlayerInventory[playerid][itemslot][ID];
	new level = GetModLevel(PlayerInventory[playerid][itemslot][Mod]) + 1;
	if(level > MAX_MOD || itemid == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка модификации.");
		return;
	}

	new item[BaseItem];
	item = GetItem(itemid);

	new grade = item[Grade];
	if(grade > GRADE_R)
		grade = GRADE_R;

	new chances[4];
	chances = GetModChances(level, grade, potionid);

	new stoneslot = FindItem(playerid, stoneid);
	if(stoneslot == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка модификации.");
		return;
	}

	DeleteItem(playerid, stoneslot, 1);

	if(potionid != -1)
	{
		new potionslot = FindItem(playerid, potionid);
		if(potionslot == -1)
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка модификации.");
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
			format(cng_string, sizeof(cng_string), "{%s}%s{FF6347} успешно модернизирован %d на стадии {%s}%s.", 
				GetColorByRate(PlayerInfo[playerid][Rate]), name, level, GetGradeColor(item[Grade]), item[Name]
			);
			SendClientMessageToAll(COLOR_LIGHTRED, cng_string);
		}

        UpdatePlayerEffects(playerid);
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "{66CC00}Модификация завершена успешно.", "Закрыть", "");
	}
	//fail
	else if(roll <= chances[0] + chances[1])
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "{FFCC00}Модификация предмета неудачна.", "Закрыть", "");
	}
	//reset
	else if(roll <= chances[0] + chances[1] + chances[2])
	{
		for(new i = 0; i < MAX_MOD; i++)
			PlayerInventory[playerid][itemslot][Mod][i] = 0;

		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "{CC0000}Модификация неудачна: камни уничтожены.", "Закрыть", "");
	}
	//destroy
	else
	{
		DeleteItem(playerid, itemslot, 1);
		ModItemSlot[playerid] = -1;
		ModStone[playerid] = -1;
		ModPotion[playerid] = -1;

		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "{CC0000}Модификация неудачна: предмет уничтожен.", "Закрыть", "");
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
		case 282: return MOD_DAMAGE;
		case 283: return MOD_DEFENSE;
		case 284: return MOD_ACCURACY;
		case 285: return MOD_DODGE;
	}
	return 0;
}

stock GetWeaponBaseDamage(weaponid)
{
	new damage[2];
	switch(weaponid)
	{
		case 1: { damage[0] = 19; damage[1] = 24; }
		case 2..8: { damage[0] = 25; damage[1] = 31; }
		case 9: { damage[0] = 101; damage[1] = 149; }
		case 10..16: { damage[0] = 135; damage[1] = 186; }
		case 17: { damage[0] = 9; damage[1] = 18; }
		case 18..24: { damage[0] = 12; damage[1] = 24; }
		case 25: { damage[0] = 12; damage[1] = 26; }
		case 26..32: { damage[0] = 16; damage[1] = 34; }
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
		case 73: { damage[0] = 151; damage[1] = 464; }
		case 74..80: { damage[0] = 196; damage[1] = 559; }

		case 245..247: { damage[0] = 22; damage[1] = 56; }
		case 248..250: { damage[0] = 132; damage[1] = 361; }
		case 251..253: { damage[0] = 16; damage[1] = 79; }
		case 254..256: { damage[0] = 24; damage[1] = 92; }
		case 257..259: { damage[0] = 46; damage[1] = 124; }
		case 260..262: { damage[0] = 338; damage[1] = 721; }
		case 263..265: { damage[0] = 160; damage[1] = 596; }
		case 266..268: { damage[0] = 173; damage[1] = 720; }

		case 269: { damage[0] = 135; damage[1] = 196; }
		case 270: { damage[0] = 895; damage[1] = 1406; }
		case 271: { damage[0] = 431; damage[1] = 1186; }
		case 272: { damage[0] = 545; damage[1] = 1486; }

		case 275: { damage[0] = 310; damage[1] = 544; }
		case 276: { damage[0] = 69; damage[1] = 92; }

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
		case 82: defense = 120;
		case 83..87: defense = 180;
		case 88: defense = 210;
		case 89..93: defense = 275;
        case 94: defense = 290;
		case 95..99: defense = 346;
        case 100: defense = 361;
		case 101..105: defense = 422;
        case 106: defense = 440;
		case 107..111: defense = 509;
        case 112: defense = 533;
		case 113..117: defense = 600;
        case 118: defense = 618;
		case 119..123: defense = 711;
        case 124: defense = 738;
		case 125..129: defense = 846;
        case 130: defense = 877;
		case 131..135: defense = 1003;

        case 137: defense = 30;
		case 138..142: defense = 45;
        case 143: defense = 48;
		case 144..148: defense = 66;
        case 149: defense = 70;
		case 150..154: defense = 102;
        case 155: defense = 110;
		case 156..160: defense = 138;
        case 161: defense = 150;
		case 162..166: defense = 203;
        case 167: defense = 235;
		case 168..172: defense = 295;
        case 173: defense = 349;
		case 174..178: defense = 448;
        case 179: defense = 502;
		case 180..184: defense = 619;
        case 185: defense = 686;
		case 186..190: defense = 871;

        case 191: defense = 50;
        case 192: defense = 70;
        case 193: defense = 95;
        case 194: defense = 130;
        case 195: defense = 180;
        case 196: defense = 255;
        case 197: defense = 345;
        case 198: defense = 460;
        case 199: defense = 600;

		case 375: defense = 540;
        case 376: defense = 735;
        case 377: defense = 980;
        case 378: defense = 1450;

        case 200: defense = 25;
        case 201: defense = 35;
        case 202: defense = 47;
        case 203: defense = 65;
        case 204: defense = 90;
        case 205: defense = 127;
        case 206: defense = 178;
        case 207: defense = 230;
        case 208: defense = 300;

		case 379: defense = 275;
        case 380: defense = 364;
        case 381: defense = 541;
        case 382: defense = 810;

        case 273: defense = 846;
        case 274: defense = 1003;

		default: defense = 0;
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
	new descs[2][255];
	new string[255];
	for(new i = 0; i < count; i++)
	{
		new modifier = modifiers[i];
		new modifier_level = GetModifierLevel(mod, modifier);
		if(modifier == MOD_DAMAGE || modifier == MOD_DEFENSE)
			format(string, sizeof(string), "%s на %d%%", GetModifierName(modifier), GetModifierStatByLevel(modifier, modifier_level));
		else if(modifier == MOD_DODGE || modifier == MOD_ACCURACY)
			format(string, sizeof(string), "%s на %d", GetModifierName(modifier), GetModifierStatByLevel(modifier, modifier_level));
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
		case MOD_DAMAGE: string = "Увеличение атаки";
		case MOD_DEFENSE: string = "Увеличение защиты";
		case MOD_ACCURACY: string = "Увеличение точности";
		case MOD_DODGE: string = "Увеличение уклонения";
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
	new modifiers[2];
	for (new i = 0; i < MAX_MOD; i++)
	{
		if(mod[i] == 0) continue;
		if(ArrayValueExist(modifiers, 2, mod[i])) continue;

		for (new j = 0; j < 2; j++)
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
	for (new i = 0; i < 2; i++)
		if(modfs[i] != 0) count++;
	
	return count;
}

stock ArraySetDefaultValue(arr[], size, value)
{
	for(new i = 0; i < size; i++)
		arr[i] = value;
}

stock ArrayValueExist(arr[], size, value)
{
	for(new i = 0; i < size; i++)
	{
		if(arr[i] == value)
			return true;
	}
	return false;
}

stock ShuffleArray(data[], size_s = sizeof(data))
{
    new j = 0, temp = 0;
    for(new i = size_s-1; i > 0; i--)
    {
        j = random(i + 1);
        temp = data[i];
        data[i] = data[j];
        data[j] = temp;
    }
    return 1;
}

stock GetItemEffectString(effect, value)
{
	new string[128];
	switch(effect) 
	{
		case 1: format(string, sizeof(string), "Урон +%d%%", value);
		case 2: format(string, sizeof(string), "Защита +%d%%", value);
		case 3: format(string, sizeof(string), "Уклонение +%d", value);
		case 4: format(string, sizeof(string), "Точность +%d", value);
		case 5: format(string, sizeof(string), "HP +%d%%", value);
		case 6: format(string, sizeof(string), "Шанс крита +%d%%", value);
		case 7: format(string, sizeof(string), "Лут с боссов X%d", value);
		case 8: string = "Исцеление";
		case 9: string = "Неуязвимость";
		case 10: format(string, sizeof(string), "HP +%d", value);
		case 11: format(string, sizeof(string), "Урон в HP +%d%%", value);
		case 12: string = "Восстановление";
		default: string = "";
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
	    case GRADE_B: color = "FFCC00";
	    case GRADE_C: color = "CC6600";
		case GRADE_L: color = "6AA84F";
		case GRADE_R: color = "1C4587";
		case GRADE_S: color = "9900FF";
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
	    case 500..999: interval = "Камень";
	    case 1000..1199: interval = "Железо";
	    case 1200..1399: interval = "Бронза";
	    case 1400..1599: interval = "Серебро";
	    case 1600..1999: interval = "Золото";
	    case 2000..2299: interval = "Платина";
	    case 2300..2699: interval = "Алмаз";
	    case 2700..3000: interval = "Бриллиант";
	    default: interval = "Дерево";
	}
	return interval;
}

stock GetRankInterval(rank)
{
	new interval[32];
	switch(rank) 
	{
	    case 2: interval = "Камень";
	    case 3: interval = "Железо";
	    case 4: interval = "Бронза";
	    case 5: interval = "Серебро";
	    case 6: interval = "Золото";
	    case 7: interval = "Платина";
	    case 8: interval = "Алмаз";
	    case 9: interval = "Бриллиант";
	    default: interval = "Дерево";
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
	format(tmp, sizeof(tmp), "`Status` = '%d', `Simulations` = '%d', `IsWatcher` = '%d', `Cash` = '%d', ", PlayerInfo[playerid][Status], PlayerInfo[playerid][Simulations], PlayerInfo[playerid][IsWatcher], PlayerInfo[playerid][Cash]);
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
	format(tmp, sizeof(tmp), "`Crit` = '%d', `GlobalTopPos` = '%d', `LocalTopPos` = '%d', `WalkersLimit` = '%d', ", PlayerInfo[playerid][Crit], PlayerInfo[playerid][GlobalTopPosition], PlayerInfo[playerid][LocalTopPosition], PlayerInfo[playerid][WalkersLimit]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`WeaponSlotID` = '%d', `ArmorSlotID` = '%d', `HatSlotID` = '%d', `GlassesSlotID` = '%d', `WatchSlotID` = '%d', ", PlayerInfo[playerid][WeaponSlotID], 
    PlayerInfo[playerid][ArmorSlotID], PlayerInfo[playerid][HatSlotID], PlayerInfo[playerid][GlassesSlotID], PlayerInfo[playerid][WatchSlotID]);
	strcat(query, tmp);
    format(tmp, sizeof(tmp), "`RingSlot1ID` = '%d', `RingSlot2ID` = '%d', `AmuletteSlot1ID` = '%d', `AmuletteSlot2ID` = '%d', ", PlayerInfo[playerid][RingSlot1ID], PlayerInfo[playerid][RingSlot2ID], PlayerInfo[playerid][AmuletteSlot1ID], PlayerInfo[playerid][AmuletteSlot2ID]);
	strcat(query, tmp);
    format(tmp, sizeof(tmp), "`WeaponMod` = '%s', `ArmorMod` = '%s', ", ArrayToString(PlayerInfo[playerid][WeaponMod], MAX_MOD), ArrayToString(PlayerInfo[playerid][ArmorMod], MAX_MOD));
	strcat(query, tmp);
    format(tmp, sizeof(tmp), "`HatMod` = '%s', `GlassesMod` = '%s', `WatchMod` = '%s' ", ArrayToString(PlayerInfo[playerid][HatMod], MAX_MOD), ArrayToString(PlayerInfo[playerid][GlassesMod], MAX_MOD), ArrayToString(PlayerInfo[playerid][WatchMod], MAX_MOD));
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
    if(PlayerInfo[playerid][IsWatcher] != 0) return;

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
    cache_get_value_name_int(0, "Status", PlayerInfo[playerid][Status]);
    cache_get_value_name_int(0, "Simulations", PlayerInfo[playerid][Simulations]);
    cache_get_value_name_int(0, "IsWatcher", PlayerInfo[playerid][IsWatcher]);
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
	cache_get_value_name_int(0, "WalkersLimit", PlayerInfo[playerid][WalkersLimit]);
	cache_get_value_name_int(0, "WeaponSlotID", PlayerInfo[playerid][WeaponSlotID]);
	cache_get_value_name_int(0, "ArmorSlotID", PlayerInfo[playerid][ArmorSlotID]);
    cache_get_value_name_int(0, "HatSlotID", PlayerInfo[playerid][HatSlotID]);
    cache_get_value_name_int(0, "GlassesSlotID", PlayerInfo[playerid][GlassesSlotID]);
    cache_get_value_name_int(0, "WatchSlotID", PlayerInfo[playerid][WatchSlotID]);
	cache_get_value_name_int(0, "RingSlot1ID", PlayerInfo[playerid][RingSlot1ID]);
	cache_get_value_name_int(0, "RingSlot2ID", PlayerInfo[playerid][RingSlot2ID]);
    cache_get_value_name_int(0, "AmuletteSlot1ID", PlayerInfo[playerid][AmuletteSlot1ID]);
	cache_get_value_name_int(0, "AmuletteSlot2ID", PlayerInfo[playerid][AmuletteSlot2ID]);

	new owner[255];
	cache_get_value_name(0, "Owner", owner);
	sscanf(owner, "s[255]", PlayerInfo[playerid][Owner]);

	new string[255];
	cache_get_value_name(0, "WeaponMod", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][WeaponMod]);
	cache_get_value_name(0, "ArmorMod", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][ArmorMod]);
    cache_get_value_name(0, "HatMod", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][HatMod]);
    cache_get_value_name(0, "GlassesMod", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][GlassesMod]);
    cache_get_value_name(0, "WatchMod", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][WatchMod]);

	cache_delete(q_result);

	LoadInventory(playerid);
	UpdatePlayerRank(playerid);
 	return 1;
}

stock CreatePlayer(playerid, name[], owner[], sex)
{
	new query[2048] = "INSERT INTO `players`( \
		`ID`, `Name`, `Owner`, `Sex`, `Rate`, `Rank`, `Status`, `Simulations`, `IsWatcher`, `Cash`, \
		`PosX`, `PosY`, `PosZ`, `Angle`, `Interior`, `Skin`, `Kills`, `Deaths`, `DamageMin`, `DamageMax`, `Defense`, ";
	new query2[512] = "`Dodge`, `Accuracy`, `Crit`, `GlobalTopPos`, `LocalTopPos`, `WalkersLimit`, `WeaponSlotID`, `WeaponMod`, \
		`ArmorSlotID`, `ArmorMod`, `HatSlotID`, `HatMod`, `GlassesSlotID`, `GlassesMod`, `WatchSlotID`, `WatchMod`, \
		`RingSlot1ID`, `RingSlot2ID`, `AmuletteSlot1ID`, `AmuletteSlot2ID`) VALUES (";
	strcat(query, query2);

	new tmp[1024];

	new sub_query[255] = "SELECT MAX(`ID`) AS `ID` FROM `players`";
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

	format(tmp, sizeof(tmp), "'%d','%s','%s','%d','%d','%d','%d','%d','%d','%d','%f','%f','%f','%f','%d','%d','%d', \
        '%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%s','%d','%s','%d','%s','%d','%s','%d','%s','%d','%d','%d','%d')",
		id, name, owner, sex, 0, 1, 0, 0, 0, 0, DEFAULT_POS_X, DEFAULT_POS_Y, DEFAULT_POS_Z, 180, 1, 78, 0, 0, 13, 15, 5, 0, 5, 5, 20, 10, MAX_WALKERS, 
        0, "0 0 0 0 0 0 0", 81, "0 0 0 0 0 0 0", 136, "0 0 0 0 0 0 0", -1, "0 0 0 0 0 0 0", -1, "0 0 0 0 0 0 0", -1, -1, -1, -1
	);
	strcat(query, tmp);

	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	CreateInventory(name);

	SendClientMessage(playerid, COLOR_GREEN, "Player created succesfully.");
}

stock CreateWatcher(login[])
{
	new name[255] = "";
	strcat(name, login);
	strcat(name, "_Watcher");

    new query[2048] = "INSERT INTO `players`( \
		`ID`, `Name`, `Owner`, `Sex`, `Rate`, `Rank`, `Status`, `Simulations`, `IsWatcher`, `Cash`, \
		`PosX`, `PosY`, `PosZ`, `Angle`, `Interior`, `Skin`, `Kills`, `Deaths`, `DamageMin`, `DamageMax`, `Defense`, ";
	new query2[512] = "`Dodge`, `Accuracy`, `Crit`, `GlobalTopPos`, `LocalTopPos`, `WalkersLimit`, `WeaponSlotID`, `WeaponMod`, \
		`ArmorSlotID`, `ArmorMod`, `HatSlotID`, `HatMod`, `GlassesSlotID`, `GlassesMod`, `WatchSlotID`, `WatchMod`, \
		`RingSlot1ID`, `RingSlot2ID`, `AmuletteSlot1ID`, `AmuletteSlot2ID`) VALUES (";
	strcat(query, query2);
	
	new tmp[1024];

	new sub_query[255] = "SELECT MAX(`ID`) AS `ID` FROM `players`";
	new Cache:sq_result = mysql_query(sql_handle, sub_query);
	new id = -1;
	cache_get_value_name_int(0, "ID", id);
	cache_delete(sq_result);

	if(id == -1)
	{
		printf("Cannot generate pID.");
		return false;
	}

	id++;

    format(tmp, sizeof(tmp), "'%d','%s','%s','%d','%d','%d','%d','%d','%d','%d','%f','%f','%f','%f','%d','%d','%d', \
        '%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%s','%d','%s','%d','%s','%d','%s','%d','%s','%d','%d','%d','%d')",
		id, name, login, 0, 0, 1, 0, 0, 1, 0, DEFAULT_POS_X, DEFAULT_POS_Y, DEFAULT_POS_Z, 180, 1, 78, 0, 0, 13, 15, 5, 0, 5, 5, 20, 10, MAX_WALKERS, 
        0, "0 0 0 0 0 0 0", 81, "0 0 0 0 0 0 0", 136, "0 0 0 0 0 0 0", -1, "0 0 0 0 0 0 0", -1, "0 0 0 0 0 0 0", -1, -1, -1, -1
	);
	strcat(query, tmp);

	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	new s_query[512];
	format(s_query, sizeof(s_query), "SELECT * FROM `players` WHERE `Owner` = '%s' AND `IsWatcher` > 0 LIMIT 1", login);
	q_result = mysql_query(sql_handle, s_query);

	new row_count = 0;
	cache_get_row_count(row_count);
	cache_delete(q_result);

	return row_count > 0;
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
	switch(rate) 
	{
		case 500..999: color = RateColors[1];
		case 1000..1199: color = RateColors[2];
		case 1200..1399: color = RateColors[3];
		case 1400..1599: color = RateColors[4];
		case 1600..1999: color = RateColors[5];
		case 2000..2299: color = RateColors[6];
		case 2300..2699: color = RateColors[7];
		case 2700..3000: color = RateColors[8];
		default: color = RateColors[0];
	}
	return color;
}

stock GetColorByRank(rank) 
{
	new color[16];
	switch(rank) 
	{
		case 2: color = RateColors[1];
		case 3: color = RateColors[2];
		case 4: color = RateColors[3];
		case 5: color = RateColors[4];
		case 6: color = RateColors[5];
		case 7: color = RateColors[6];
		case 8: color = RateColors[7];
		case 9: color = RateColors[8];
		default: color = RateColors[0];
	}
	return color;
}

stock ResetHierarchy()
{
	new query[255] = "UPDATE `players` SET `Status` = 0 WHERE 1";
	new Cache:temp_result = mysql_query(sql_handle, query);
	cache_delete(temp_result);

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i) || FCNPC_IsValid(i))
			continue;
		
		PlayerInfo[i][Status] = HIERARCHY_NONE;
		UpdatePlayerStats(i);
		UpdatePlayerEffects(i);
	}
}

stock PatriarchPayday()
{
	new query[255] = "SELECT * FROM `hierarchy` LIMIT 1";
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("PatriarchPayday error.");
		cache_delete(q_result);
		return;
	}

	new money;
	new name[255];
	cache_get_value_name_int(0, "Money", money);
	cache_get_value_name(0, "LeaderName", name);
	cache_delete(q_result);

	if(money <= 0)
		return;

	new msg[255];
	format(msg, sizeof(msg), "{00CC00}Накопленная комиссия с рынка составила: %s$", FormatMoney(money));
	PendingMessage(name, msg);
	
	new playerid = GetPlayerID(name);
	if(playerid != -1)
		GivePlayerMoney(playerid, money);
	else
		GivePlayerMoneyOffline(name, money);
}

stock UpdateHierarchy()
{
	PatriarchPayday();
	UpdateTempHierarchyItems();

	UpdateGlobalRatingTop();
	ResetHierarchy();

	new pretendets[HIERARCHY_STATUSES_COUNT];
	for(new i = 0; i < HIERARCHY_STATUSES_COUNT; i++)
	{
		new query[255];
		format(query, sizeof(query), "SELECT * FROM `players` WHERE `Name` = '%s' LIMIT 1", GlobalRatingTop[i][Name]);
		new Cache:q_result = mysql_query(sql_handle, query);

		new row_count = 0;
		cache_get_row_count(row_count);
		if(row_count <= 0)
		{
			print("Hierarchy update error.");
			cache_delete(q_result);
			return;
		}

		new pid;
		cache_get_value_name_int(0, "ID", pid);
		cache_delete(q_result);

		pretendets[i] = pid;
	}

	ShuffleArray(pretendets);

	SendClientMessageToAll(COLOR_WHITE, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	SendClientMessageToAll(COLOR_WHITE, "Выборы в иерархию завершились!");
	SendClientMessageToAll(COLOR_YELLOW, "Новые лидеры:");
	SendClientMessageToAll(COLOR_WHITE, "");

	for(new i = 0; i < HIERARCHY_STATUSES_COUNT; i++)
	{
		new query[255];
		format(query, sizeof(query), "UPDATE `players` SET `Status` = '%d' WHERE `ID` = '%d' LIMIT 1", i+1, pretendets[i]);
		new Cache:temp_result = mysql_query(sql_handle, query);
		cache_delete(temp_result);

		format(query, sizeof(query), "SELECT * FROM `players` WHERE `ID` = '%d' LIMIT 1", pretendets[i]);
		new Cache:q_result = mysql_query(sql_handle, query);

		new row_count = 0;
		cache_get_row_count(row_count);
		if(row_count <= 0)
		{
			print("Hierarchy update error.");
			cache_delete(q_result);
			return;
		}

		new name[255];
		cache_get_value_name(0, "Name", name);
		cache_delete(q_result);

		if(i+1 == HIERARCHY_LEADER)
		{
			PendingItem(name, 274, MOD_CLEAR, 1, "Награда Патриарха");
			PendingItem(name, 276, MOD_CLEAR, 1, "Награда Патриарха");

			new p_query[255];
			format(p_query, sizeof(p_query), "UPDATE `hierarchy` SET `LeaderName` = '%s', `Money` = '0' LIMIT 1", name);
			new Cache:p_result = mysql_query(sql_handle, p_query);
			cache_delete(p_result);
		}
		else
		{
			PendingItem(name, 273, MOD_CLEAR, 1, "Награда основателя");
			PendingItem(name, 275, MOD_CLEAR, 1, "Награда основателя");
		}

		new playerid = GetPlayerInGameID(pretendets[i]);
		if(playerid != -1)
		{
			PlayerInfo[playerid][Status] = i+1;
			UpdatePlayerEffects(playerid);
			UpdatePlayerStats(playerid);
		}

		new text[255];
		format(text, sizeof(text), "%s - {FFFFFF}%s", GetHierarchyStatusString(i+1), name);
		SendClientMessageToAll(COLOR_WHITE, text);
	}

	SendClientMessageToAll(COLOR_WHITE, "");
	SendClientMessageToAll(COLOR_WHITE, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
}

stock UpdateGlobalRatingTop()
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` <> 'Admin' AND `IsWatcher`=0 ORDER BY `Rate` DESC LIMIT %d", MAX_PARTICIPANTS);
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

    format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` = '%s' AND `IsWatcher`=0 ORDER BY `Rate` DESC LIMIT %d", owner, MAX_PARTICIPANTS / 2);
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

stock GetHierarchyStatusString(status)
{
	new string[64] = "";
	switch(status)
	{
		case HIERARCHY_LEADER: string = "{cc0000}Патриарх";
		case HIERARCHY_ARCHONT: string = "{674ea7}Архонт";
		case HIERARCHY_ATTACK: string = "{0000ff}Атакующий";
		case HIERARCHY_DEFENSE: string = "{b45f06}Защитник";
		case HIERARCHY_SUPPORT: string = "{c27ba0}Поддержка";
	}

	return string;
}

stock ShowHierarchy(playerid)
{
	new info[2048] = "Статус\tИмя\tРейтинг";
	new string[455];

	for(new i = 1; i <= HIERARCHY_STATUSES_COUNT; i++)
	{
		new query[255];
		format(query, sizeof(query), "SELECT * FROM `players` WHERE `Status` = %d LIMIT 1", i);
		new Cache:q_result = mysql_query(sql_handle, query);

		new row_count = 0;
		cache_get_row_count(row_count);
		if(row_count <= 0)
		{
			format(string, sizeof(string), "\n%s\t{ffffff}Нет\t-", GetHierarchyStatusString(i));
			strcat(info, string);
			cache_delete(q_result);
			continue;
		}

		new name[255];
		new rate;

		cache_get_value_name(0, "Name", name);
		cache_get_value_name_int(0, "Rate", rate);

		format(string, sizeof(string), "\n%s\t{%s}%s\t{ffffff}%d", GetHierarchyStatusString(i), GetColorByRate(rate), name, rate);
		strcat(info, string);

		cache_delete(q_result);
	}

	new money = 0;
	new query[255] = "SELECT * FROM `hierarchy` LIMIT 1";
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count > 0)
		cache_get_value_name_int(0, "Money", money);

    cache_delete(q_result);
	
	format(string, sizeof(string), "\n{ffffff}Накопленная сумма комиссий рынка: {00CC00}%s$", FormatMoney(money));
	strcat(info, string);

	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST_HEADERS, "Иерархия", info, "Закрыть", "");
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

stock IsTourParticipant(id)
{
	for (new i = 0; i < TourParticipantsCount; i++)
		if(Tournament[ParticipantsIDs][i] == id) return true;
	return false;
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
		new kills = 0;
		new deaths = 0;
		new r_diff = 0;
		cache_get_value_name_int(i, "ID", id);
		cache_get_value_name_int(i, "Score", score);
		cache_get_value_name_int(i, "Kills", kills);
		cache_get_value_name_int(i, "Deaths", deaths);
		cache_get_value_name_int(i, "RateDiff", r_diff);
		if(id == -1) continue;

		new player[pInfo];
		player = GetPlayer(id);

		format(TournamentTab[i][Name], 255, "%s", player[Name]);
		TournamentTab[i][Rate] = player[Rate];
		TournamentTab[i][RateDiff] = r_diff;
		TournamentTab[i][Score] = score;
		TournamentTab[i][Kills] = kills;
		TournamentTab[i][Deaths] = deaths;
		TournamentTab[i][Pos] = i+1;
	}

	cache_delete(q_result);

	new top[4000] = "№ п\\п\tИмя\tРезультат\tОчки (рейтинг)";
	new string[255];
	for (new i = 0; i < row_count; i++) 
	{
		new rate_color[255];
		new rate_str[32];
		new rate_diff = TournamentTab[i][RateDiff];
		if(rate_diff >= 0)
		{
		    rate_color = "33CC00";
			format(rate_str, sizeof(rate_str), "+%d", rate_diff);
		}
		else
		{
		    rate_color = "CC0000";
			format(rate_str, sizeof(rate_str), "%d", rate_diff);
		}

		format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t{00CC00}%d {ffffff}- {CC0000}%d\t{9900CC}%d {ffffff}({%s}%s{ffffff})", 
			GetPlaceColor(i+1), i+1, GetColorByRate(TournamentTab[i][Rate]), TournamentTab[i][Name],
			TournamentTab[i][Kills], TournamentTab[i][Deaths], TournamentTab[i][Score], rate_color, rate_str
		);
		strcat(top, string);
	}

	new tt_str[64];
	format(tt_str, sizeof(tt_str), "Турнирная таблица. Тур %d.", Tournament[Tour] - 1);
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST_HEADERS, tt_str, top, "Закрыть", "");
}

stock GetPlayerByName(name[])
{
	new player[pInfo];
	
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Name` = '%s' LIMIT 1", name);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("GetPlayerByName() error. Player with this name not found.");
		return player;
	}

	cache_get_value_name_int(0, "Rate", player[Rate]);
	new owner[255];
	cache_get_value_name_int(0, "ID", player[ID]);
	cache_get_value_name(0, "Owner", owner);
	format(player[Owner], 255, "%s", owner);
	format(player[Name], 255, "%s", name);

	cache_delete(q_result);
	return player;
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

stock GetWalker(rank)
{
	new walker[wInfo];

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `walkers` WHERE `Rank` = '%d' LIMIT 1", rank);
	new Cache:q_result = mysql_query(sql_handle, query);
	new row_count;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("GetWalker() error.");
		return walker;
	}

	walker[Rank] = rank;

	cache_get_value_name_int(0, "Skin", walker[Skin]);
	cache_get_value_name_int(0, "MaxHP", walker[HP]);
	cache_get_value_name_int(0, "DamageMin", walker[DamageMin]);
	cache_get_value_name_int(0, "DamageMax", walker[DamageMax]);
	cache_get_value_name_int(0, "Defense", walker[Defense]);
	cache_get_value_name_int(0, "Dodge", walker[Dodge]);
	cache_get_value_name_int(0, "Accuracy", walker[Accuracy]);
	cache_get_value_name_int(0, "Crit", walker[Crit]);
	cache_get_value_name_int(0, "WeaponID", walker[WeaponID]);

	new name[255];
	cache_get_value_name(0, "Name", name);
	format(walker[Name], 255, "%s", name);

	cache_delete(q_result);
	return walker;
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

stock GetWalkerRespawnTime(rank)
{
	new time = 30000;
	switch(rank)
	{
		case 1: time = 10000;
		case 2:	time = 25000;
		case 3:	time = 20000;
		case 4:	time = 25000;
		case 5:	time = 30000;
		case 6:	time = 35000;
		case 7:	time = 40000;
		case 8:	time = 45000;
		case 9:	time = 50000;
	}

	return time;
}

stock SetWalkerDestPoint(walkerid)
{
	new Float:x, Float:y, Float:z;
	FCNPC_GetPosition(walkerid, x, y, z);

	x = 200 + random(99);
	y = -1868 + random(27);

	FCNPC_GoTo(walkerid, x, y, z, FCNPC_MOVE_TYPE_WALK, FCNPC_MOVE_SPEED_WALK);
}

stock SetRandomWalkerPos(walkerid)
{
	new Float:x, Float:y, Float:z;
	x = 200 + random(99);
	y = -1868 + random(27);
	z = 3.2866;

	FCNPC_SetPosition(walkerid, x, y, z);
}

stock SetMobDestPoint(mobid)
{
	new Float:x, Float:y, Float:z;
	FCNPC_GetPosition(mobid, x, y, z);

	x = -50 + random(104);
	y = 1476 + random(92);

	FCNPC_GoTo(mobid, x, y, z, FCNPC_MOVE_TYPE_WALK, FCNPC_MOVE_SPEED_WALK);
}

stock SetRandomMobPos(mobid)
{
	new Float:x, Float:y, Float:z;
	x = -50 + random(104);
	y = 1476 + random(92);
	z = 12.7500;

	FCNPC_SetPosition(mobid, x, y, z);
}

stock ResetWalkerDamagersInfo(walkerid)
{
	new idx = GetWalkerIdx(walkerid);
	if(idx == -1) return;

	for(new i = 0; i < MAX_PLAYERS; i++)
		WalkersDamagers[idx][i] = 0;
}

stock InitWalkers()
{
	for(new i = 0; i < MAX_WALKERS; i++)
	{
		new rank = random(MAX_RANK) + 1;
		Walkers[i] = GetWalker(rank);

		new npc_name[255];
		format(npc_name, sizeof(npc_name), "Walker_%d", i);
		Walkers[i][ID] = FCNPC_Create(npc_name);

		IsWalker[Walkers[i][ID]] = true;
		ResetWalkerDamagersInfo(Walkers[i][ID]);

		MaxHP[Walkers[i][ID]] = Walkers[i][HP];
		SetPlayerMaxHP(Walkers[i][ID], Walkers[i][HP], false);

		PlayerInfo[Walkers[i][ID]][Rank] = rank;
		PlayerInfo[Walkers[i][ID]][DamageMin] = Walkers[i][DamageMin];
		PlayerInfo[Walkers[i][ID]][DamageMax] = Walkers[i][DamageMax];
		PlayerInfo[Walkers[i][ID]][Defense] = Walkers[i][Defense];
		PlayerInfo[Walkers[i][ID]][Dodge] = Walkers[i][Dodge];
		PlayerInfo[Walkers[i][ID]][Accuracy] = Walkers[i][Accuracy];
		PlayerInfo[Walkers[i][ID]][Crit] = Walkers[i][Crit];
		PlayerInfo[Walkers[i][ID]][Sex] = 0;
		PlayerInfo[Walkers[i][ID]][Skin] = Walkers[i][Skin];
		PlayerInfo[Walkers[i][ID]][WeaponSlotID] = Walkers[i][WeaponID];

		FCNPC_Spawn(Walkers[i][ID], Walkers[i][Skin], 0, 0, 0);
		SetRandomWalkerPos(Walkers[i][ID]);
		FCNPC_SetInvulnerable(Walkers[i][ID], false);
		FCNPC_SetInterior(Walkers[i][ID], 0);
		UpdatePlayerWeapon(Walkers[i][ID]);

		new name[255];
		format(name, sizeof(name), "[LV%d] %s", Walkers[i][Rank], Walkers[i][Name]);
		Walkers[i][LabelID] = CreateDynamic3DTextLabel(name, HexRateColors[Walkers[i][Rank]-1][0], 0, 0, 0.15, 40, Walkers[i][ID]);

		SetWalkerDestPoint(Walkers[i][ID]);
	}
}

stock ResetPlayerVariables(playerid)
{
	PlayerInfo[playerid][ID] = 0;
	PlayerInfo[playerid][Rate] = 0;
	PlayerInfo[playerid][Rank] = 0;
	PlayerInfo[playerid][Status] = 0;
	PlayerInfo[playerid][IsWatcher] = 0;
	PlayerInfo[playerid][Cash] = 0;
	PlayerInfo[playerid][Sex] = 0;
	PlayerInfo[playerid][WeaponSlotID] = 0;
	PlayerInfo[playerid][ArmorSlotID] = 81;
    PlayerInfo[playerid][HatSlotID] = 161;
    PlayerInfo[playerid][GlassesSlotID] = -1;
    PlayerInfo[playerid][WatchSlotID] = -1;
	PlayerInfo[playerid][RingSlot1ID] = -1;
	PlayerInfo[playerid][RingSlot2ID] = -1;
    PlayerInfo[playerid][AmuletteSlot1ID] = -1;
	PlayerInfo[playerid][AmuletteSlot2ID] = -1;
	PlayerInfo[playerid][WeaponMod] = MOD_CLEAR;
	PlayerInfo[playerid][ArmorMod] = MOD_CLEAR;
    PlayerInfo[playerid][HatMod] = MOD_CLEAR;
    PlayerInfo[playerid][GlassesMod] = MOD_CLEAR;
    PlayerInfo[playerid][WatchMod] = MOD_CLEAR;
	DisableEffects(playerid);
}

stock DestroyWalkers()
{
	for(new i = 0; i < MAX_WALKERS; i++)
	{
		DestroyDynamic3DTextLabel(Walkers[i][LabelID]);
		if(IsValidTimer(WalkerRespawnTimer[Walkers[i][ID]]))
			KillTimer(WalkerRespawnTimer[Walkers[i][ID]]);
		FCNPC_Destroy(Walkers[i][ID]);
		IsWalker[Walkers[i][ID]] = false;
		ResetPlayerVariables(Walkers[i][ID]);
	}
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

	ChrInfoBox[playerid] = CreatePlayerTextDraw(playerid, 477.000122, 103.129661, "mainbox");
	PlayerTextDrawLetterSize(playerid, ChrInfoBox[playerid], 0.000000, 31.112138);
	PlayerTextDrawTextSize(playerid, ChrInfoBox[playerid], 625.667053, 0.000000);
	PlayerTextDrawAlignment(playerid, ChrInfoBox[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfoBox[playerid], 0x000000DD);
	PlayerTextDrawSetShadow(playerid, ChrInfoBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfoBox[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfoBox[playerid], 0);

	ChrInfoHeader[playerid] = CreatePlayerTextDraw(playerid, 555.733703, 103.454742, "Персонаж");
	PlayerTextDrawLetterSize(playerid, ChrInfoHeader[playerid], 0.271333, 0.973630);
	PlayerTextDrawAlignment(playerid, ChrInfoHeader[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfoHeader[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfoHeader[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfoHeader[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoHeader[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfoHeader[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoHeader[playerid], 1);

	ChrInfDelim1[playerid] = CreatePlayerTextDraw(playerid, 498.299621, 116.480003, "chrinfo_delim1");
	PlayerTextDrawLetterSize(playerid, ChrInfDelim1[playerid], 0.005665, 1.837852);
	PlayerTextDrawTextSize(playerid, ChrInfDelim1[playerid], 108.999992, 2.074074);
	PlayerTextDrawAlignment(playerid, ChrInfDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDelim1[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, ChrInfDelim1[playerid], false);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim1[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDelim1[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfMaxHP[playerid] = CreatePlayerTextDraw(playerid, 479.733489, 121.876953, "HP: 99999/99999");
	PlayerTextDrawLetterSize(playerid, ChrInfMaxHP[playerid], 0.219999, 0.803556);
	PlayerTextDrawAlignment(playerid, ChrInfMaxHP[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfMaxHP[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfMaxHP[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfMaxHP[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfMaxHP[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfMaxHP[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfMaxHP[playerid], 1);

	ChrInfDamage[playerid] = CreatePlayerTextDraw(playerid, 479.800109, 128.850326, "Damage: 9999-9999");
	PlayerTextDrawLetterSize(playerid, ChrInfDamage[playerid], 0.219999, 0.803556);
	PlayerTextDrawAlignment(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDamage[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDamage[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDamage[playerid], 1);

	ChrInfDefense[playerid] = CreatePlayerTextDraw(playerid, 479.733428, 135.450424, "Defense: 99999");
	PlayerTextDrawLetterSize(playerid, ChrInfDefense[playerid], 0.219999, 0.803556);
	PlayerTextDrawAlignment(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDefense[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDefense[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDefense[playerid], 1);

	ChrInfAccuracy[playerid] = CreatePlayerTextDraw(playerid, 479.800292, 142.050582, "Accuracy: 9999");
	PlayerTextDrawLetterSize(playerid, ChrInfAccuracy[playerid], 0.219999, 0.803556);
	PlayerTextDrawAlignment(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAccuracy[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccuracy[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfAccuracy[playerid], 1);

	ChrInfDodge[playerid] = CreatePlayerTextDraw(playerid, 479.867034, 148.692001, "Dodge: 9999");
	PlayerTextDrawLetterSize(playerid, ChrInfDodge[playerid], 0.219999, 0.803556);
	PlayerTextDrawAlignment(playerid, ChrInfDodge[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDodge[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfDodge[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDodge[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDodge[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfDodge[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfDodge[playerid], 1);

	ChrInfCrit[playerid] = CreatePlayerTextDraw(playerid, 479.933746, 155.209106, "Crit: 999");
	PlayerTextDrawLetterSize(playerid, ChrInfCrit[playerid], 0.219999, 0.803556);
	PlayerTextDrawAlignment(playerid, ChrInfCrit[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfCrit[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfCrit[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfCrit[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfCrit[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfCrit[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfCrit[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfCrit[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfCrit[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	ChrInfHatSlot[playerid] = CreatePlayerTextDraw(playerid, 580.833801, 120.959968, "hat_slot");
	PlayerTextDrawLetterSize(playerid, ChrInfHatSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfHatSlot[playerid], 20.000000, 19.911109);
	PlayerTextDrawAlignment(playerid, ChrInfHatSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfHatSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfHatSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfHatSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfHatSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfHatSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfHatSlot[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfHatSlot[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfHatSlot[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfHatSlot[playerid], 18954);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfHatSlot[playerid], 0.000000, -45.000000, 0.000000, 1.000000);

	ChrInfArmorSlot[playerid] = CreatePlayerTextDraw(playerid, 580.833740, 142.202850, "armor_slot");
	PlayerTextDrawLetterSize(playerid, ChrInfArmorSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfArmorSlot[playerid], 20.000000, 19.911109);
	PlayerTextDrawAlignment(playerid, ChrInfArmorSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfArmorSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfArmorSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfArmorSlot[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfArmorSlot[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfArmorSlot[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfArmorSlot[playerid], 1275);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfArmorSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfWatchSlot[playerid] = CreatePlayerTextDraw(playerid, 601.833557, 142.207229, "watch_slot");
	PlayerTextDrawLetterSize(playerid, ChrInfWatchSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfWatchSlot[playerid], 20.000000, 19.911109);
	PlayerTextDrawAlignment(playerid, ChrInfWatchSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfWatchSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfWatchSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfWatchSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfWatchSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfWatchSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfWatchSlot[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfWatchSlot[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfWatchSlot[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfWatchSlot[playerid], 19046);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfWatchSlot[playerid], 0.000000, -45.000000, 0.000000, 1.000000);

	ChrInfGlassesSlot[playerid] = CreatePlayerTextDraw(playerid, 559.766662, 142.294647, "glasses_slot");
	PlayerTextDrawLetterSize(playerid, ChrInfGlassesSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfGlassesSlot[playerid], 20.000000, 19.911109);
	PlayerTextDrawAlignment(playerid, ChrInfGlassesSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfGlassesSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfGlassesSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfGlassesSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfGlassesSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfGlassesSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfGlassesSlot[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfGlassesSlot[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfGlassesSlot[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfGlassesSlot[playerid], 19034);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfGlassesSlot[playerid], 0.000000, -45.000000, 135.000000, 1.000000);

	ChrInfAmuletteSlot1[playerid] = CreatePlayerTextDraw(playerid, 601.633666, 120.663269, "amulette_slot_1");
	PlayerTextDrawLetterSize(playerid, ChrInfAmuletteSlot1[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfAmuletteSlot1[playerid], 9.899995, 9.899995);
	PlayerTextDrawAlignment(playerid, ChrInfAmuletteSlot1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAmuletteSlot1[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfAmuletteSlot1[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfAmuletteSlot1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfAmuletteSlot1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAmuletteSlot1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAmuletteSlot1[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfAmuletteSlot1[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfAmuletteSlot1[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfAmuletteSlot1[playerid], 954);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfAmuletteSlot1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfAmuletteSlot2[playerid] = CreatePlayerTextDraw(playerid, 612.200378, 120.667755, "amulette_slot_2");
	PlayerTextDrawLetterSize(playerid, ChrInfAmuletteSlot2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfAmuletteSlot2[playerid], 9.899995, 9.899995);
	PlayerTextDrawAlignment(playerid, ChrInfAmuletteSlot2[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAmuletteSlot2[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfAmuletteSlot2[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfAmuletteSlot2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfAmuletteSlot2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAmuletteSlot2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAmuletteSlot2[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfAmuletteSlot2[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfAmuletteSlot2[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfAmuletteSlot2[playerid], 954);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfAmuletteSlot2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfRingSlot2[playerid] = CreatePlayerTextDraw(playerid, 612.133728, 131.167098, "ring_slot_2");
	PlayerTextDrawLetterSize(playerid, ChrInfRingSlot2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfRingSlot2[playerid], 9.899995, 9.899995);
	PlayerTextDrawAlignment(playerid, ChrInfRingSlot2[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfRingSlot2[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfRingSlot2[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfRingSlot2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfRingSlot2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfRingSlot2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRingSlot2[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfRingSlot2[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfRingSlot2[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfRingSlot2[playerid], 954);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfRingSlot2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfRingSlot1[playerid] = CreatePlayerTextDraw(playerid, 601.700317, 131.070693, "ring_slot_1");
	PlayerTextDrawLetterSize(playerid, ChrInfRingSlot1[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfRingSlot1[playerid], 9.899995, 9.899995);
	PlayerTextDrawAlignment(playerid, ChrInfRingSlot1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfRingSlot1[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfRingSlot1[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfRingSlot1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfRingSlot1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfRingSlot1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRingSlot1[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfRingSlot1[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfRingSlot1[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfRingSlot1[playerid], 954);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfRingSlot1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfWeaponSlot[playerid] = CreatePlayerTextDraw(playerid, 559.866638, 121.350975, "weapon_slot");
	PlayerTextDrawLetterSize(playerid, ChrInfWeaponSlot[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfWeaponSlot[playerid], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, ChrInfWeaponSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfWeaponSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfWeaponSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfWeaponSlot[playerid], -1);
	PlayerTextDrawFont(playerid, ChrInfWeaponSlot[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfWeaponSlot[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfWeaponSlot[playerid], 346);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfWeaponSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfDelim1[playerid] = CreatePlayerTextDraw(playerid, 475.766632, 115.069625, "delim1");
	PlayerTextDrawLetterSize(playerid, ChrInfDelim1[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfDelim1[playerid], 150.766723, 2.488883);
	PlayerTextDrawAlignment(playerid, ChrInfDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDelim1[playerid], -65281);
	PlayerTextDrawUseBox(playerid, ChrInfDelim1[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim1[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDelim1[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfDelim2[playerid] = CreatePlayerTextDraw(playerid, 476.099945, 165.640029, "delim2");
	PlayerTextDrawLetterSize(playerid, ChrInfDelim2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfDelim2[playerid], 150.100067, 2.488883);
	PlayerTextDrawAlignment(playerid, ChrInfDelim2[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDelim2[playerid], -65281);
	PlayerTextDrawUseBox(playerid, ChrInfDelim2[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim2[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim2[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDelim2[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim2[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfDelim3[playerid] = CreatePlayerTextDraw(playerid, 476.833190, 188.832504, "delim3");
	PlayerTextDrawLetterSize(playerid, ChrInfDelim3[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfDelim3[playerid], 149.833511, 2.488883);
	PlayerTextDrawAlignment(playerid, ChrInfDelim3[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDelim3[playerid], -65281);
	PlayerTextDrawUseBox(playerid, ChrInfDelim3[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim3[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim3[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim3[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDelim3[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim3[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfDelim4[playerid] = CreatePlayerTextDraw(playerid, 477.499877, 202.525741, "delim4");
	PlayerTextDrawLetterSize(playerid, ChrInfDelim4[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfDelim4[playerid], 149.500167, 2.488883);
	PlayerTextDrawAlignment(playerid, ChrInfDelim4[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDelim4[playerid], -65281);
	PlayerTextDrawUseBox(playerid, ChrInfDelim4[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim4[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim4[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim4[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDelim4[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim4[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim4[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfDelim5[playerid] = CreatePlayerTextDraw(playerid, 477.233154, 353.108734, "delim5");
	PlayerTextDrawLetterSize(playerid, ChrInfDelim5[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfDelim5[playerid], 148.233749, 2.488883);
	PlayerTextDrawAlignment(playerid, ChrInfDelim5[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDelim5[playerid], -65281);
	PlayerTextDrawUseBox(playerid, ChrInfDelim5[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfDelim5[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDelim5[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfDelim5[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfDelim5[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDelim5[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfDelim5[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfDelim5[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	ChrInfClose[playerid] = CreatePlayerTextDraw(playerid, 620.699951, 103.288909, "X");
	PlayerTextDrawLetterSize(playerid, ChrInfClose[playerid], 0.357333, 1.044147);
	PlayerTextDrawTextSize(playerid, ChrInfClose[playerid], 15.000000, 11.199998);
	PlayerTextDrawAlignment(playerid, ChrInfClose[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfClose[playerid], -2147483393);
	PlayerTextDrawUseBox(playerid, ChrInfClose[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfClose[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfClose[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfClose[playerid], 1);
	PlayerTextDrawFont(playerid, ChrInfClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfClose[playerid], true);
	PlayerTextDrawBackgroundColor(playerid, ChrInfClose[playerid], 0x00000000);

	ChrInfRate[playerid] = CreatePlayerTextDraw(playerid, 555.466735, 170.239990, "3000");
	PlayerTextDrawLetterSize(playerid, ChrInfRate[playerid], 0.398665, 1.570963);
	PlayerTextDrawAlignment(playerid, ChrInfRate[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfRate[playerid], -1378294017);
	PlayerTextDrawSetShadow(playerid, ChrInfRate[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfRate[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRate[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfRate[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfRate[playerid], 1);

	ChrInfText2[playerid] = CreatePlayerTextDraw(playerid, 508.366851, 168.000061, "Личный");
	PlayerTextDrawLetterSize(playerid, ChrInfText2[playerid], 0.183999, 0.699850);
	PlayerTextDrawAlignment(playerid, ChrInfText2[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfText2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfText2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfText2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfText2[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfText2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfText2[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfText2[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfText2[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	ChrInfText1[playerid] = CreatePlayerTextDraw(playerid, 600.733764, 168.211761, "Общий");
	PlayerTextDrawLetterSize(playerid, ChrInfText1[playerid], 0.183999, 0.699850);
	PlayerTextDrawAlignment(playerid, ChrInfText1[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfText1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfText1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfText1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfText1[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfText1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfText1[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfText1[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfText1[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	ChrInfPersonalRate[playerid] = CreatePlayerTextDraw(playerid, 508.333251, 173.682800, "99");
	PlayerTextDrawLetterSize(playerid, ChrInfPersonalRate[playerid], 0.307666, 1.172741);
	PlayerTextDrawAlignment(playerid, ChrInfPersonalRate[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfPersonalRate[playerid], -65281);
	PlayerTextDrawSetShadow(playerid, ChrInfPersonalRate[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfPersonalRate[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfPersonalRate[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfPersonalRate[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfPersonalRate[playerid], 1);

	ChrInfAllRate[playerid] = CreatePlayerTextDraw(playerid, 601.132873, 173.148025, "98");
	PlayerTextDrawLetterSize(playerid, ChrInfAllRate[playerid], 0.307666, 1.172741);
	PlayerTextDrawAlignment(playerid, ChrInfAllRate[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfAllRate[playerid], -65281);
	PlayerTextDrawSetShadow(playerid, ChrInfAllRate[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfAllRate[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAllRate[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfAllRate[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfAllRate[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfAllRate[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfAllRate[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	ChrInfNextInvBtn[playerid] = CreatePlayerTextDraw(playerid, 602.532958, 188.948074, ">");
	PlayerTextDrawLetterSize(playerid, ChrInfNextInvBtn[playerid], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, ChrInfNextInvBtn[playerid], 15.666666, 8.711110);
	PlayerTextDrawAlignment(playerid, ChrInfNextInvBtn[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfNextInvBtn[playerid], -5963521);
	PlayerTextDrawUseBox(playerid, ChrInfNextInvBtn[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfNextInvBtn[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfNextInvBtn[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfNextInvBtn[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfNextInvBtn[playerid], 0x00000000);
	PlayerTextDrawFont(playerid, ChrInfNextInvBtn[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfNextInvBtn[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfNextInvBtn[playerid], true);

	ChrInfPrevInvBtn[playerid] = CreatePlayerTextDraw(playerid, 508.366394, 188.994018, "<");
	PlayerTextDrawLetterSize(playerid, ChrInfPrevInvBtn[playerid], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, ChrInfPrevInvBtn[playerid], 15.666666, 8.711110);
	PlayerTextDrawAlignment(playerid, ChrInfPrevInvBtn[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfPrevInvBtn[playerid], -5963521);
	PlayerTextDrawUseBox(playerid, ChrInfPrevInvBtn[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfPrevInvBtn[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfPrevInvBtn[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfPrevInvBtn[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfPrevInvBtn[playerid], 0x00000000);
	PlayerTextDrawFont(playerid, ChrInfPrevInvBtn[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfPrevInvBtn[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfPrevInvBtn[playerid], true);

	ChrInfCurInv[playerid] = CreatePlayerTextDraw(playerid, 555.599914, 191.727478, "1/5");
	PlayerTextDrawLetterSize(playerid, ChrInfCurInv[playerid], 0.322665, 1.031702);
	PlayerTextDrawAlignment(playerid, ChrInfCurInv[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfCurInv[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ChrInfCurInv[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfCurInv[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, ChrInfCurInv[playerid], 51);
	PlayerTextDrawFont(playerid, ChrInfCurInv[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfCurInv[playerid], 1);

	ChrInfButUse[playerid] = CreatePlayerTextDraw(playerid, 486.000000, 358.000000, "but_use");
	PlayerTextDrawLetterSize(playerid, ChrInfButUse[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButUse[playerid], 21.000000, 21.000000);
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

	ChrInfButMod[playerid] = CreatePlayerTextDraw(playerid, 567.000000, 358.000000, "but_upg");
	PlayerTextDrawLetterSize(playerid, ChrInfButMod[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButMod[playerid], 21.000000, 21.000000);
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

	ChrInfButDel[playerid] = CreatePlayerTextDraw(playerid, 540.000000, 358.000000, "but_delete");
	PlayerTextDrawLetterSize(playerid, ChrInfButDel[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButDel[playerid], 21.000000, 21.000000);
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

	ChrInfButInfo[playerid] = CreatePlayerTextDraw(playerid, 513.000000, 358.000000, "but_info");
	PlayerTextDrawLetterSize(playerid, ChrInfButInfo[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButInfo[playerid], 21.000000, 21.000000);
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

	ChrInfButSort[playerid] = CreatePlayerTextDraw(playerid, 594.000000, 358.000000, "but_sort");
	PlayerTextDrawLetterSize(playerid, ChrInfButSort[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButSort[playerid], 21.000000, 21.000000);
	PlayerTextDrawAlignment(playerid, ChrInfButSort[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButSort[playerid], -1);
	PlayerTextDrawUseBox(playerid, ChrInfButSort[playerid], true);
	PlayerTextDrawBoxColor(playerid, ChrInfButSort[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButSort[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ChrInfButSort[playerid], 0);
	PlayerTextDrawFont(playerid, ChrInfButSort[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, ChrInfButSort[playerid], true);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButSort[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButSort[playerid], 1247);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButSort[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	new inv_slot_x = 479;
	new inv_slot_y = 207;
	new inv_slot_count_x = 507;
	new inv_slot_count_y = 227;
	new inv_slot_offset = 29;
	new idx = 0;
	for(new i = 1; i <= MAX_SLOTS_X; i++)
	{
		for(new j = 1; j <= MAX_SLOTS_Y; j++)
		{
			ChrInfInvSlot[playerid][idx] = CreatePlayerTextDraw(playerid, inv_slot_x, inv_slot_y, "inv_slot");
			PlayerTextDrawLetterSize(playerid, ChrInfInvSlot[playerid][idx], 0.000000, 0.000000);
			PlayerTextDrawTextSize(playerid, ChrInfInvSlot[playerid][idx], 28.000000, 28.000000);
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
			PlayerTextDrawLetterSize(playerid, ChrInfInvSlotCount[playerid][idx], 0.202665, 0.965331);
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
		inv_slot_x = 479;
		inv_slot_count_x = 507;
		inv_slot_y += inv_slot_offset;
		inv_slot_count_y += inv_slot_offset;
	}

	EqInfBox[playerid] = CreatePlayerTextDraw(playerid, 397.433563, 164.522216, "main_box");
	PlayerTextDrawLetterSize(playerid, EqInfBox[playerid], 0.000000, 18.778308);
	PlayerTextDrawTextSize(playerid, EqInfBox[playerid], 236.666671, 0.000000);
	PlayerTextDrawAlignment(playerid, EqInfBox[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, EqInfBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfBox[playerid], 0x000000DD);
	PlayerTextDrawSetShadow(playerid, EqInfBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfBox[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfBox[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, EqInfBox[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfBox[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfTxt1[playerid] = CreatePlayerTextDraw(playerid, 320.000061, 163.934707, "Информация");
	PlayerTextDrawLetterSize(playerid, EqInfTxt1[playerid], 0.256333, 1.102222);
	PlayerTextDrawAlignment(playerid, EqInfTxt1[playerid], 2);
	PlayerTextDrawColor(playerid, EqInfTxt1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfTxt1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfTxt1[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, EqInfTxt1[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfTxt1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfTxt1[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfTxt1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfTxt1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfClose[playerid] = CreatePlayerTextDraw(playerid, 390.666809, 164.557006, "X");
	PlayerTextDrawLetterSize(playerid, EqInfClose[playerid], 0.336333, 0.998518);
	PlayerTextDrawTextSize(playerid, EqInfClose[playerid], 14.333320, 12.029618);
	PlayerTextDrawAlignment(playerid, EqInfClose[playerid], 2);
	PlayerTextDrawColor(playerid, EqInfClose[playerid], -2147483393);
	PlayerTextDrawUseBox(playerid, EqInfClose[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfClose[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfClose[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawFont(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfClose[playerid], true);
	PlayerTextDrawBackgroundColor(playerid, EqInfClose[playerid], 0x00000000);

	EqInfDelim1[playerid] = CreatePlayerTextDraw(playerid, 238.366622, 175.508224, "delim1");
	PlayerTextDrawLetterSize(playerid, EqInfDelim1[playerid], 0.020666, -0.671704);
	PlayerTextDrawTextSize(playerid, EqInfDelim1[playerid], 157.466659, 1.576301);
	PlayerTextDrawAlignment(playerid, EqInfDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim1[playerid], -65281);
	PlayerTextDrawUseBox(playerid, EqInfDelim1[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim1[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim1[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfItemName[playerid] = CreatePlayerTextDraw(playerid, 317.733489, 179.116989, "[Type C-Damage Legendary Shazok bourgeois destroyer]");
	PlayerTextDrawLetterSize(playerid, EqInfItemName[playerid], 0.155999, 0.745481);
	PlayerTextDrawAlignment(playerid, EqInfItemName[playerid], 2);
	PlayerTextDrawColor(playerid, EqInfItemName[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, EqInfItemName[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfItemName[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemName[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfItemName[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfItemName[playerid], 1);

	EqInfItemIcon[playerid] = CreatePlayerTextDraw(playerid, 360.366760, 190.690612, "item_icon");
	PlayerTextDrawLetterSize(playerid, EqInfItemIcon[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, EqInfItemIcon[playerid], 30.000000, 30.000000);
	PlayerTextDrawAlignment(playerid, EqInfItemIcon[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfItemIcon[playerid], -1);
	PlayerTextDrawUseBox(playerid, EqInfItemIcon[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemIcon[playerid], -5963521);
	PlayerTextDrawFont(playerid, EqInfItemIcon[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, EqInfItemIcon[playerid], 266);
	PlayerTextDrawSetPreviewRot(playerid, EqInfItemIcon[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfItemType[playerid] = CreatePlayerTextDraw(playerid, 241.666809, 188.781875, "Type: Weapon");
	PlayerTextDrawLetterSize(playerid, EqInfItemType[playerid], 0.200333, 0.882371);
	PlayerTextDrawAlignment(playerid, EqInfItemType[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfItemType[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfItemType[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfItemType[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemType[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfItemType[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfItemType[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfItemType[playerid], 19134);
	PlayerTextDrawSetPreviewRot(playerid, EqInfItemType[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	EqInfItemMinRank[playerid] = CreatePlayerTextDraw(playerid, 241.466613, 199.571945, "Min rank: Gold");
	PlayerTextDrawLetterSize(playerid, EqInfItemMinRank[playerid], 0.200333, 0.882371);
	PlayerTextDrawAlignment(playerid, EqInfItemMinRank[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfItemMinRank[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfItemMinRank[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfItemMinRank[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemMinRank[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfItemMinRank[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfItemMinRank[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfItemMinRank[playerid], 19134);
	PlayerTextDrawSetPreviewRot(playerid, EqInfItemMinRank[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	EqInfItemGrade[playerid] = CreatePlayerTextDraw(playerid, 241.699935, 209.988754, "Grade: C");
	PlayerTextDrawLetterSize(playerid, EqInfItemGrade[playerid], 0.200333, 0.882371);
	PlayerTextDrawAlignment(playerid, EqInfItemGrade[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfItemGrade[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfItemGrade[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfItemGrade[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemGrade[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfItemGrade[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfItemGrade[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfItemGrade[playerid], 19134);
	PlayerTextDrawSetPreviewRot(playerid, EqInfItemGrade[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	EqInfDelim2[playerid] = CreatePlayerTextDraw(playerid, 238.666839, 223.174713, "delim2");
	PlayerTextDrawLetterSize(playerid, EqInfDelim2[playerid], 0.020666, -0.671704);
	PlayerTextDrawTextSize(playerid, EqInfDelim2[playerid], 157.466659, 1.576301);
	PlayerTextDrawAlignment(playerid, EqInfDelim2[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim2[playerid], -65281);
	PlayerTextDrawUseBox(playerid, EqInfDelim2[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim2[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim2[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim2[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfMainStat[playerid] = CreatePlayerTextDraw(playerid, 241.633270, 228.535751, "Attack: 9999-9999");
	PlayerTextDrawLetterSize(playerid, EqInfMainStat[playerid], 0.246666, 1.006815);
	PlayerTextDrawAlignment(playerid, EqInfMainStat[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfMainStat[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfMainStat[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfMainStat[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfMainStat[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfMainStat[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfMainStat[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfMainStat[playerid], 19134);
	PlayerTextDrawSetPreviewRot(playerid, EqInfMainStat[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	EqInfBonusStat[playerid][0] = CreatePlayerTextDraw(playerid, 241.933212, 237.481231, "Unknown property 1 +999%");
	PlayerTextDrawLetterSize(playerid, EqInfBonusStat[playerid][0], 0.161666, 0.712295);
	PlayerTextDrawAlignment(playerid, EqInfBonusStat[playerid][0], 1);
	PlayerTextDrawColor(playerid, EqInfBonusStat[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, EqInfBonusStat[playerid][0], 1);
	PlayerTextDrawSetOutline(playerid, EqInfBonusStat[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfBonusStat[playerid][0], 51);
	PlayerTextDrawFont(playerid, EqInfBonusStat[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, EqInfBonusStat[playerid][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfBonusStat[playerid][0], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfBonusStat[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfBonusStat[playerid][1] = CreatePlayerTextDraw(playerid, 241.933151, 243.210311, "Unknown property 2 +999%");
	PlayerTextDrawLetterSize(playerid, EqInfBonusStat[playerid][1], 0.161666, 0.712295);
	PlayerTextDrawAlignment(playerid, EqInfBonusStat[playerid][1], 1);
	PlayerTextDrawColor(playerid, EqInfBonusStat[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, EqInfBonusStat[playerid][1], 1);
	PlayerTextDrawSetOutline(playerid, EqInfBonusStat[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfBonusStat[playerid][1], 51);
	PlayerTextDrawFont(playerid, EqInfBonusStat[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, EqInfBonusStat[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfBonusStat[playerid][1], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfBonusStat[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfBonusStat[playerid][2] = CreatePlayerTextDraw(playerid, 241.933029, 248.856277, "Unknown property 3 +999%");
	PlayerTextDrawLetterSize(playerid, EqInfBonusStat[playerid][2], 0.161666, 0.712295);
	PlayerTextDrawAlignment(playerid, EqInfBonusStat[playerid][2], 1);
	PlayerTextDrawColor(playerid, EqInfBonusStat[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, EqInfBonusStat[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, EqInfBonusStat[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfBonusStat[playerid][2], 51);
	PlayerTextDrawFont(playerid, EqInfBonusStat[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, EqInfBonusStat[playerid][2], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfBonusStat[playerid][2], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfBonusStat[playerid][2], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfDelim3[playerid] = CreatePlayerTextDraw(playerid, 238.366729, 259.060455, "delim3");
	PlayerTextDrawLetterSize(playerid, EqInfDelim3[playerid], 0.020666, -0.671704);
	PlayerTextDrawTextSize(playerid, EqInfDelim3[playerid], 157.466659, 1.576301);
	PlayerTextDrawAlignment(playerid, EqInfDelim3[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim3[playerid], -65281);
	PlayerTextDrawUseBox(playerid, EqInfDelim3[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim3[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim2[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim3[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfTxt2[playerid] = CreatePlayerTextDraw(playerid, 242.133316, 264.278350, "Улучшения:");
	PlayerTextDrawLetterSize(playerid, EqInfTxt2[playerid], 0.247000, 0.932148);
	PlayerTextDrawAlignment(playerid, EqInfTxt2[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfTxt2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfTxt2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfTxt2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfTxt2[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfTxt2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfTxt2[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfTxt2[playerid], 19134);
	PlayerTextDrawSetPreviewRot(playerid, EqInfTxt2[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	new mod_x = 285;
	new mod_offset = 10;
	idx = 0;
	for(new i = 1; i <= MAX_MOD; i++)
	{
		EqInfMod[playerid][idx] = CreatePlayerTextDraw(playerid, mod_x, 262, "mod");
		PlayerTextDrawLetterSize(playerid, EqInfMod[playerid][idx], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, EqInfMod[playerid][idx], 15.000000, 15.000000);
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

	EqInfModStat[playerid][0] = CreatePlayerTextDraw(playerid, 242.066635, 275.187835, "Updrade effect 1 +999%");
	PlayerTextDrawLetterSize(playerid, EqInfModStat[playerid][0], 0.188333, 0.724740);
	PlayerTextDrawAlignment(playerid, EqInfModStat[playerid][0], 1);
	PlayerTextDrawColor(playerid, EqInfModStat[playerid][0], 16711935);
	PlayerTextDrawSetShadow(playerid, EqInfModStat[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, EqInfModStat[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfModStat[playerid][0], 51);
	PlayerTextDrawFont(playerid, EqInfModStat[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, EqInfModStat[playerid][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfModStat[playerid][0], 0);
	PlayerTextDrawSetPreviewRot(playerid, EqInfModStat[playerid][0], 0.000000, 0.000000, 0.000000, 0.000000);

	EqInfModStat[playerid][1] = CreatePlayerTextDraw(playerid, 242.099853, 281.497528, "Updrade effect 2 +999%");
	PlayerTextDrawLetterSize(playerid, EqInfModStat[playerid][1], 0.188333, 0.724740);
	PlayerTextDrawAlignment(playerid, EqInfModStat[playerid][1], 1);
	PlayerTextDrawColor(playerid, EqInfModStat[playerid][1], 16711935);
	PlayerTextDrawSetShadow(playerid, EqInfModStat[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, EqInfModStat[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfModStat[playerid][1], 51);
	PlayerTextDrawFont(playerid, EqInfModStat[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, EqInfModStat[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfModStat[playerid][1], 0);
	PlayerTextDrawSetPreviewRot(playerid, EqInfModStat[playerid][1], 0.000000, 0.000000, 0.000000, 0.000000);

	EqInfDelim4[playerid] = CreatePlayerTextDraw(playerid, 238.300079, 291.420501, "delim4");
	PlayerTextDrawLetterSize(playerid, EqInfDelim4[playerid], 0.020666, -0.671704);
	PlayerTextDrawTextSize(playerid, EqInfDelim4[playerid], 157.466659, 1.576301);
	PlayerTextDrawAlignment(playerid, EqInfDelim4[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim4[playerid], -65281);
	PlayerTextDrawUseBox(playerid, EqInfDelim4[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim4[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim2[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim4[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim4[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfDescriptionStr[playerid][0] = CreatePlayerTextDraw(playerid, 318.700103, 294.228118, "Description string 1");
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][0], 0.206999, 0.815999);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][0], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][0], 51);
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDescriptionStr[playerid][0], 0.000000, 0.000000, 0.000000, 0.000000);

	EqInfDescriptionStr[playerid][1] = CreatePlayerTextDraw(playerid, 318.700286, 300.662231, "Description string 2");
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][1], 0.206999, 0.815999);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][1], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][1], 51);
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDescriptionStr[playerid][1], 0.000000, 0.000000, 0.000000, 0.000000);

	EqInfDescriptionStr[playerid][2] = CreatePlayerTextDraw(playerid, 318.766998, 306.888824, "Description string 3");
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][2], 0.206999, 0.815999);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][2], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][2], 51);
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][2], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDescriptionStr[playerid][2], 0);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDescriptionStr[playerid][2], 0.000000, 0.000000, 0.000000, 0.000000);

	EqInfDelim5[playerid] = CreatePlayerTextDraw(playerid, 238.233367, 316.106506, "delim5");
	PlayerTextDrawLetterSize(playerid, EqInfDelim5[playerid], 0.020666, -0.671704);
	PlayerTextDrawTextSize(playerid, EqInfDelim5[playerid], 157.466659, 1.576301);
	PlayerTextDrawAlignment(playerid, EqInfDelim5[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim5[playerid], -65281);
	PlayerTextDrawUseBox(playerid, EqInfDelim5[playerid], true);
	PlayerTextDrawBoxColor(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawFont(playerid, EqInfDelim5[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim2[playerid], 0x00000000);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim5[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim5[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	EqInfPrice[playerid] = CreatePlayerTextDraw(playerid, 240.967208, 318.259307, "Cost: 99999999$");
	PlayerTextDrawLetterSize(playerid, EqInfPrice[playerid], 0.206999, 0.815999);
	PlayerTextDrawAlignment(playerid, EqInfPrice[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfPrice[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfPrice[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfPrice[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfPrice[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfPrice[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfPrice[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfPrice[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, EqInfPrice[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	EqInfTrading[playerid] = CreatePlayerTextDraw(playerid, 241.000549, 325.274322, "Trade: Allowed");
	PlayerTextDrawLetterSize(playerid, EqInfTrading[playerid], 0.206999, 0.815999);
	PlayerTextDrawAlignment(playerid, EqInfTrading[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfTrading[playerid], -1);
	PlayerTextDrawSetShadow(playerid, EqInfTrading[playerid], 0);
	PlayerTextDrawSetOutline(playerid, EqInfTrading[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, EqInfTrading[playerid], 51);
	PlayerTextDrawFont(playerid, EqInfTrading[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfTrading[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, EqInfTrading[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, EqInfTrading[playerid], 0.000000, 0.000000, 0.000000, 0.000000);

	InfBox[playerid] = CreatePlayerTextDraw(playerid, 389.000030, 151.248153, "inf_box");
	PlayerTextDrawLetterSize(playerid, InfBox[playerid], 0.000000, 10.677566);
	PlayerTextDrawTextSize(playerid, InfBox[playerid], 249.333328, 0.000000);
	PlayerTextDrawAlignment(playerid, InfBox[playerid], 1);
	PlayerTextDrawColor(playerid, InfBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, InfBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, InfBox[playerid], 0x000000DD);
	PlayerTextDrawSetShadow(playerid, InfBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfBox[playerid], 0);
	PlayerTextDrawFont(playerid, InfBox[playerid], 0);

	InfTxt1[playerid] = CreatePlayerTextDraw(playerid, 319.833190, 150.702148, "Информация");
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

	InfItemType[playerid] = CreatePlayerTextDraw(playerid, 282.899749, 173.093154, "Passive item");
	PlayerTextDrawLetterSize(playerid, InfItemType[playerid], 0.221333, 0.865777);
	PlayerTextDrawAlignment(playerid, InfItemType[playerid], 1);
	PlayerTextDrawColor(playerid, InfItemType[playerid], -1);
	PlayerTextDrawSetShadow(playerid, InfItemType[playerid], 0);
	PlayerTextDrawSetOutline(playerid, InfItemType[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemType[playerid], 51);
	PlayerTextDrawFont(playerid, InfItemType[playerid], 1);
	PlayerTextDrawSetProportional(playerid, InfItemType[playerid], 1);

	InfItemEffect[playerid][0] = CreatePlayerTextDraw(playerid, 282.666503, 182.970153, "Decreases required rank for equip by 1");
	PlayerTextDrawLetterSize(playerid, InfItemEffect[playerid][0], 0.147665, 0.674962);
	PlayerTextDrawAlignment(playerid, InfItemEffect[playerid][0], 1);
	PlayerTextDrawColor(playerid, InfItemEffect[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, InfItemEffect[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, InfItemEffect[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemEffect[playerid][0], 51);
	PlayerTextDrawFont(playerid, InfItemEffect[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, InfItemEffect[playerid][0], 1);

	InfItemEffect[playerid][1] = CreatePlayerTextDraw(playerid, 282.666625, 189.072463, "Damage +25%");
	PlayerTextDrawLetterSize(playerid, InfItemEffect[playerid][1], 0.147665, 0.674962);
	PlayerTextDrawAlignment(playerid, InfItemEffect[playerid][1], 1);
	PlayerTextDrawColor(playerid, InfItemEffect[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, InfItemEffect[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, InfItemEffect[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemEffect[playerid][1], 51);
	PlayerTextDrawFont(playerid, InfItemEffect[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InfItemEffect[playerid][1], 1);

	InfItemEffect[playerid][2] = CreatePlayerTextDraw(playerid, 282.633270, 195.257675, "Defense +25%");
	PlayerTextDrawLetterSize(playerid, InfItemEffect[playerid][2], 0.147665, 0.674962);
	PlayerTextDrawAlignment(playerid, InfItemEffect[playerid][2], 1);
	PlayerTextDrawColor(playerid, InfItemEffect[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, InfItemEffect[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, InfItemEffect[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, InfItemEffect[playerid][2], 51);
	PlayerTextDrawFont(playerid, InfItemEffect[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, InfItemEffect[playerid][2], 1);

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
	PlayerTextDrawBoxColor(playerid, UpgBox[playerid], 0x000000DD);
	PlayerTextDrawSetShadow(playerid, UpgBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgBox[playerid], 0);
	PlayerTextDrawFont(playerid, UpgBox[playerid], 0);

	UpgTxt1[playerid] = CreatePlayerTextDraw(playerid, 320.166687, 153.481506, "Модификация");
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

	UpgTxt2[playerid] = CreatePlayerTextDraw(playerid, 320.500091, 225.543746, "Предмет");
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

	UpgTxt3[playerid] = CreatePlayerTextDraw(playerid, 282.066864, 224.967407, "Камень");
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

	UpgTxt4[playerid] = CreatePlayerTextDraw(playerid, 358.533477, 225.677017, "Эликсир");
	PlayerTextDrawLetterSize(playerid, UpgTxt4[playerid], 0.189999, 0.766222);
	PlayerTextDrawAlignment(playerid, UpgTxt4[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt4[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgTxt4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt4[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt4[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt4[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt4[playerid], 1);

	UpgBtn[playerid] = CreatePlayerTextDraw(playerid, 320.200012, 235.905120, "Улучшить");
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
	PlayerTextDrawBoxColor(playerid, PvpPanelBox[playerid], 0x000000DD);
	PlayerTextDrawSetShadow(playerid, PvpPanelBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PvpPanelBox[playerid], 0);
	PlayerTextDrawFont(playerid, PvpPanelBox[playerid], 0);

	PvpPanelHeader[playerid] = CreatePlayerTextDraw(playerid, 42.099964, 296.136383, "Текущий топ");
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

	CmbBox[playerid] = CreatePlayerTextDraw(playerid, 378.966583, 156.640747, "cmb_box");
	PlayerTextDrawLetterSize(playerid, CmbBox[playerid], 0.000000, 10.401419);
	PlayerTextDrawTextSize(playerid, CmbBox[playerid], 258.333312, 0.000000);
	PlayerTextDrawAlignment(playerid, CmbBox[playerid], 1);
	PlayerTextDrawColor(playerid, CmbBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, CmbBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, CmbBox[playerid], 0x000000DD);
	PlayerTextDrawSetShadow(playerid, CmbBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CmbBox[playerid], 0);
	PlayerTextDrawFont(playerid, CmbBox[playerid], 0);

	CmbDelim1[playerid] = CreatePlayerTextDraw(playerid, 259.699981, 166.880035, "cmb_delim");
	PlayerTextDrawLetterSize(playerid, CmbDelim1[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, CmbDelim1[playerid], 117.399993, 2.074081);
	PlayerTextDrawAlignment(playerid, CmbDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, CmbDelim1[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, CmbDelim1[playerid], true);
	PlayerTextDrawBoxColor(playerid, CmbDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, CmbDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CmbDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, CmbDelim1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, CmbDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, CmbDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	CmbClose[playerid] = CreatePlayerTextDraw(playerid, 371.966674, 156.385162, "X");
	PlayerTextDrawLetterSize(playerid, CmbClose[playerid], 0.320666, 1.015110);
	PlayerTextDrawTextSize(playerid, CmbClose[playerid], 6.366667, 7.051848);
	PlayerTextDrawAlignment(playerid, CmbClose[playerid], 2);
	PlayerTextDrawColor(playerid, CmbClose[playerid], -2147483393);
	PlayerTextDrawUseBox(playerid, CmbClose[playerid], true);
	PlayerTextDrawBoxColor(playerid, CmbClose[playerid], 0);
	PlayerTextDrawSetShadow(playerid, CmbClose[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CmbClose[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, CmbClose[playerid], 34);
	PlayerTextDrawFont(playerid, CmbClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CmbClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, CmbClose[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, CmbClose[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, CmbClose[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	CmbTxt1[playerid] = CreatePlayerTextDraw(playerid, 320.699768, 155.887298, "Комбинирование");
	PlayerTextDrawLetterSize(playerid, CmbTxt1[playerid], 0.237333, 1.052444);
	PlayerTextDrawAlignment(playerid, CmbTxt1[playerid], 2);
	PlayerTextDrawColor(playerid, CmbTxt1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, CmbTxt1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CmbTxt1[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, CmbTxt1[playerid], 51);
	PlayerTextDrawFont(playerid, CmbTxt1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CmbTxt1[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, CmbTxt1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, CmbTxt1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	CmbItemSlot[playerid][0] = CreatePlayerTextDraw(playerid, 309.000000, 175.000000, "item1");
	PlayerTextDrawLetterSize(playerid, CmbItemSlot[playerid][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, CmbItemSlot[playerid][0], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, CmbItemSlot[playerid][0], 1);
	PlayerTextDrawColor(playerid, CmbItemSlot[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, CmbItemSlot[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, CmbItemSlot[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, CmbItemSlot[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, CmbItemSlot[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbItemSlot[playerid][0], -1378294017);
	PlayerTextDrawFont(playerid, CmbItemSlot[playerid][0], 5);
	PlayerTextDrawSetSelectable(playerid, CmbItemSlot[playerid][0], true);
	PlayerTextDrawSetPreviewModel(playerid, CmbItemSlot[playerid][0], -1);
	PlayerTextDrawSetPreviewRot(playerid, CmbItemSlot[playerid][0], 0.000000, 0.000000, 90.000000, 1.000000);

	CmbItemSlot[playerid][1] = CreatePlayerTextDraw(playerid, 270.000000, 210.000000, "item2");
	PlayerTextDrawLetterSize(playerid, CmbItemSlot[playerid][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, CmbItemSlot[playerid][1], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, CmbItemSlot[playerid][1], 1);
	PlayerTextDrawColor(playerid, CmbItemSlot[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, CmbItemSlot[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, CmbItemSlot[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, CmbItemSlot[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, CmbItemSlot[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbItemSlot[playerid][1], -1378294017);
	PlayerTextDrawFont(playerid, CmbItemSlot[playerid][1], 5);
	PlayerTextDrawSetSelectable(playerid, CmbItemSlot[playerid][1], true);
	PlayerTextDrawSetPreviewModel(playerid, CmbItemSlot[playerid][1], -1);
	PlayerTextDrawSetPreviewRot(playerid, CmbItemSlot[playerid][1], 0.000000, 0.000000, 90.000000, 1.000000);

	CmbItemSlot[playerid][2] = CreatePlayerTextDraw(playerid, 348.000000, 210.000000, "item3");
	PlayerTextDrawLetterSize(playerid, CmbItemSlot[playerid][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, CmbItemSlot[playerid][2], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, CmbItemSlot[playerid][2], 1);
	PlayerTextDrawColor(playerid, CmbItemSlot[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, CmbItemSlot[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, CmbItemSlot[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, CmbItemSlot[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, CmbItemSlot[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbItemSlot[playerid][2], -1378294017);
	PlayerTextDrawFont(playerid, CmbItemSlot[playerid][2], 5);
	PlayerTextDrawSetSelectable(playerid, CmbItemSlot[playerid][2], true);
	PlayerTextDrawSetPreviewModel(playerid, CmbItemSlot[playerid][2], -1);
	PlayerTextDrawSetPreviewRot(playerid, CmbItemSlot[playerid][2], 0.000000, 0.000000, 90.000000, 1.000000);

	CmbItemSlotCount[playerid][0] = CreatePlayerTextDraw(playerid, 329.066284, 188.035690, "99");
	PlayerTextDrawLetterSize(playerid, CmbItemSlotCount[playerid][0], 0.205666, 0.811851);
	PlayerTextDrawAlignment(playerid, CmbItemSlotCount[playerid][0], 3);
	PlayerTextDrawColor(playerid, CmbItemSlotCount[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, CmbItemSlotCount[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, CmbItemSlotCount[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbItemSlotCount[playerid][0], 51);
	PlayerTextDrawFont(playerid, CmbItemSlotCount[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, CmbItemSlotCount[playerid][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, CmbItemSlotCount[playerid][0], 18656);
	PlayerTextDrawSetPreviewRot(playerid, CmbItemSlotCount[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);

	CmbItemSlotCount[playerid][1] = CreatePlayerTextDraw(playerid, 290.033050, 222.843261, "99");
	PlayerTextDrawLetterSize(playerid, CmbItemSlotCount[playerid][1], 0.205666, 0.811851);
	PlayerTextDrawAlignment(playerid, CmbItemSlotCount[playerid][1], 3);
	PlayerTextDrawColor(playerid, CmbItemSlotCount[playerid][1], 255);
	PlayerTextDrawSetShadow(playerid, CmbItemSlotCount[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, CmbItemSlotCount[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbItemSlotCount[playerid][1], 51);
	PlayerTextDrawFont(playerid, CmbItemSlotCount[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, CmbItemSlotCount[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, CmbItemSlotCount[playerid][1], 18656);
	PlayerTextDrawSetPreviewRot(playerid, CmbItemSlotCount[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);

	CmbItemSlotCount[playerid][2] = CreatePlayerTextDraw(playerid, 368.066253, 223.055007, "99");
	PlayerTextDrawLetterSize(playerid, CmbItemSlotCount[playerid][2], 0.205666, 0.811851);
	PlayerTextDrawAlignment(playerid, CmbItemSlotCount[playerid][2], 3);
	PlayerTextDrawColor(playerid, CmbItemSlotCount[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, CmbItemSlotCount[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, CmbItemSlotCount[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbItemSlotCount[playerid][2], 51);
	PlayerTextDrawFont(playerid, CmbItemSlotCount[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, CmbItemSlotCount[playerid][2], 1);
	PlayerTextDrawSetPreviewModel(playerid, CmbItemSlotCount[playerid][2], 18656);
	PlayerTextDrawSetPreviewRot(playerid, CmbItemSlotCount[playerid][2], 0.000000, 0.000000, 0.000000, 1.000000);

	CmbTxt2[playerid] = CreatePlayerTextDraw(playerid, 319.766418, 196.705307, "Предмет 1");
	PlayerTextDrawLetterSize(playerid, CmbTxt2[playerid], 0.142999, 0.699852);
	PlayerTextDrawAlignment(playerid, CmbTxt2[playerid], 2);
	PlayerTextDrawColor(playerid, CmbTxt2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, CmbTxt2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CmbTxt2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbTxt2[playerid], 51);
	PlayerTextDrawFont(playerid, CmbTxt2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CmbTxt2[playerid], 1);

	CmbTxt3[playerid] = CreatePlayerTextDraw(playerid, 280.732910, 230.724548, "Предмет 2");
	PlayerTextDrawLetterSize(playerid, CmbTxt3[playerid], 0.142999, 0.699852);
	PlayerTextDrawAlignment(playerid, CmbTxt3[playerid], 2);
	PlayerTextDrawColor(playerid, CmbTxt3[playerid], -1);
	PlayerTextDrawSetShadow(playerid, CmbTxt3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CmbTxt3[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbTxt3[playerid], 51);
	PlayerTextDrawFont(playerid, CmbTxt3[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CmbTxt3[playerid], 1);

	CmbTxt4[playerid] = CreatePlayerTextDraw(playerid, 359.299499, 230.853332, "Предмет 3");
	PlayerTextDrawLetterSize(playerid, CmbTxt4[playerid], 0.142999, 0.699852);
	PlayerTextDrawAlignment(playerid, CmbTxt4[playerid], 2);
	PlayerTextDrawColor(playerid, CmbTxt4[playerid], -1);
	PlayerTextDrawSetShadow(playerid, CmbTxt4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CmbTxt4[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbTxt4[playerid], 51);
	PlayerTextDrawFont(playerid, CmbTxt4[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CmbTxt4[playerid], 1);

	CmbBtnBox[playerid] = CreatePlayerTextDraw(playerid, 377.666656, 240.433349, "btn_box");
	PlayerTextDrawLetterSize(playerid, CmbBtnBox[playerid], 0.000000, 0.835595);
	PlayerTextDrawTextSize(playerid, CmbBtnBox[playerid], 259.666656, 0.000000);
	PlayerTextDrawAlignment(playerid, CmbBtnBox[playerid], 1);
	PlayerTextDrawColor(playerid, CmbBtnBox[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, CmbBtnBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, CmbBtnBox[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, CmbBtnBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CmbBtnBox[playerid], 0);
	PlayerTextDrawFont(playerid, CmbBtnBox[playerid], 0);

	CmbBtn[playerid] = CreatePlayerTextDraw(playerid, 319.033325, 237.730407, "Комбинировать");
	PlayerTextDrawLetterSize(playerid, CmbBtn[playerid], 0.270666, 1.293036);
	PlayerTextDrawTextSize(playerid, CmbBtn[playerid], 7.333358, 113.659248);
	PlayerTextDrawAlignment(playerid, CmbBtn[playerid], 2);
	PlayerTextDrawColor(playerid, CmbBtn[playerid], 255);
	PlayerTextDrawUseBox(playerid, CmbBtn[playerid], true);
	PlayerTextDrawBoxColor(playerid, CmbBtn[playerid], 0);
	PlayerTextDrawSetShadow(playerid, CmbBtn[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CmbBtn[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, CmbBtn[playerid], 51);
	PlayerTextDrawFont(playerid, CmbBtn[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CmbBtn[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, CmbBtn[playerid], true);

	MpBox[playerid] = CreatePlayerTextDraw(playerid, 360.733398, 174.062957, "mp_box");
	PlayerTextDrawLetterSize(playerid, MpBox[playerid], 0.000000, 9.138888);
	PlayerTextDrawTextSize(playerid, MpBox[playerid], 274.666656, 0.000000);
	PlayerTextDrawAlignment(playerid, MpBox[playerid], 1);
	PlayerTextDrawColor(playerid, MpBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, MpBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpBox[playerid], 102);
	PlayerTextDrawSetShadow(playerid, MpBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpBox[playerid], 0);
	PlayerTextDrawFont(playerid, MpBox[playerid], 0);

	MpDelim1[playerid] = CreatePlayerTextDraw(playerid, 276.333343, 182.933334, "mp_delim1");
	PlayerTextDrawLetterSize(playerid, MpDelim1[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, MpDelim1[playerid], 82.666656, 1.659255);
	PlayerTextDrawAlignment(playerid, MpDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, MpDelim1[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, MpDelim1[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, MpDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, MpDelim1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, MpDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, MpDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	MpClose[playerid] = CreatePlayerTextDraw(playerid, 354.099884, 173.019180, "X");
	PlayerTextDrawLetterSize(playerid, MpClose[playerid], 0.358333, 1.048296);
	PlayerTextDrawTextSize(playerid, MpClose[playerid], 6.266666, 5.807407);
	PlayerTextDrawAlignment(playerid, MpClose[playerid], 2);
	PlayerTextDrawColor(playerid, MpClose[playerid], -2147483393);
	PlayerTextDrawUseBox(playerid, MpClose[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpClose[playerid], 0);
	PlayerTextDrawSetShadow(playerid, MpClose[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpClose[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, MpClose[playerid], 51);
	PlayerTextDrawFont(playerid, MpClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, MpClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, MpClose[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, MpClose[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, MpClose[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	MpTxt1[playerid] = CreatePlayerTextDraw(playerid, 319.333343, 173.102203, "Рынок");
	PlayerTextDrawLetterSize(playerid, MpTxt1[playerid], 0.267666, 0.952889);
	PlayerTextDrawAlignment(playerid, MpTxt1[playerid], 2);
	PlayerTextDrawColor(playerid, MpTxt1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, MpTxt1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpTxt1[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, MpTxt1[playerid], 51);
	PlayerTextDrawFont(playerid, MpTxt1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, MpTxt1[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, MpTxt1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, MpTxt1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	MpItem[playerid] = CreatePlayerTextDraw(playerid, 307.899932, 188.616241, "mp_item");
	PlayerTextDrawLetterSize(playerid, MpItem[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, MpItem[playerid], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, MpItem[playerid], 1);
	PlayerTextDrawColor(playerid, MpItem[playerid], -1);
	PlayerTextDrawUseBox(playerid, MpItem[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpItem[playerid], 0);
	PlayerTextDrawSetShadow(playerid, MpItem[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpItem[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, MpItem[playerid], -1378294017);
	PlayerTextDrawFont(playerid, MpItem[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, MpItem[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, MpItem[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, MpItem[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	MpItemCount[playerid] = CreatePlayerTextDraw(playerid, 327.999847, 202.139282, "99");
	PlayerTextDrawLetterSize(playerid, MpItemCount[playerid], 0.200999, 0.786963);
	PlayerTextDrawAlignment(playerid, MpItemCount[playerid], 3);
	PlayerTextDrawColor(playerid, MpItemCount[playerid], 255);
	PlayerTextDrawSetShadow(playerid, MpItemCount[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpItemCount[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, MpItemCount[playerid], 51);
	PlayerTextDrawFont(playerid, MpItemCount[playerid], 1);
	PlayerTextDrawSetProportional(playerid, MpItemCount[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, MpItemCount[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, MpItemCount[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	MpTxt2[playerid] = CreatePlayerTextDraw(playerid, 319.599914, 211.555633, "Поместите предмет сюда");
	PlayerTextDrawLetterSize(playerid, MpTxt2[playerid], 0.198999, 0.757925);
	PlayerTextDrawAlignment(playerid, MpTxt2[playerid], 2);
	PlayerTextDrawColor(playerid, MpTxt2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, MpTxt2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpTxt2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, MpTxt2[playerid], 51);
	PlayerTextDrawFont(playerid, MpTxt2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, MpTxt2[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, MpTxt2[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, MpTxt2[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	MpDelim2[playerid] = CreatePlayerTextDraw(playerid, 276.733245, 219.648941, "mp_delim2");
	PlayerTextDrawLetterSize(playerid, MpDelim2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, MpDelim2[playerid], 82.066635, 1.659255);
	PlayerTextDrawAlignment(playerid, MpDelim2[playerid], 1);
	PlayerTextDrawColor(playerid, MpDelim2[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, MpDelim2[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpDelim2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, MpDelim2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpDelim2[playerid], 0);
	PlayerTextDrawFont(playerid, MpDelim2[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, MpDelim2[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, MpDelim2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	MpTxtPrice[playerid] = CreatePlayerTextDraw(playerid, 279.166687, 223.751083, "Price: 99999999$");
	PlayerTextDrawLetterSize(playerid, MpTxtPrice[playerid], 0.172666, 0.811851);
	PlayerTextDrawAlignment(playerid, MpTxtPrice[playerid], 1);
	PlayerTextDrawColor(playerid, MpTxtPrice[playerid], -1);
	PlayerTextDrawSetShadow(playerid, MpTxtPrice[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpTxtPrice[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, MpTxtPrice[playerid], 51);
	PlayerTextDrawFont(playerid, MpTxtPrice[playerid], 1);
	PlayerTextDrawSetProportional(playerid, MpTxtPrice[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, MpTxtPrice[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, MpTxtPrice[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	MpTxtCount[playerid] = CreatePlayerTextDraw(playerid, 279.066833, 234.250686, "Count: 999");
	PlayerTextDrawLetterSize(playerid, MpTxtCount[playerid], 0.172666, 0.811851);
	PlayerTextDrawAlignment(playerid, MpTxtCount[playerid], 1);
	PlayerTextDrawColor(playerid, MpTxtCount[playerid], -1);
	PlayerTextDrawSetShadow(playerid, MpTxtCount[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpTxtCount[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, MpTxtCount[playerid], 51);
	PlayerTextDrawFont(playerid, MpTxtCount[playerid], 1);
	PlayerTextDrawSetProportional(playerid, MpTxtCount[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, MpTxtCount[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, MpTxtCount[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	MpBtn1Box[playerid] = CreatePlayerTextDraw(playerid, 359.100067, 225.002212, "btn1_box");
	PlayerTextDrawLetterSize(playerid, MpBtn1Box[playerid], 0.000000, 0.651233);
	PlayerTextDrawTextSize(playerid, MpBtn1Box[playerid], 326.766723, 0.000000);
	PlayerTextDrawAlignment(playerid, MpBtn1Box[playerid], 1);
	PlayerTextDrawColor(playerid, MpBtn1Box[playerid], 0);
	PlayerTextDrawUseBox(playerid, MpBtn1Box[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpBtn1Box[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, MpBtn1Box[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpBtn1Box[playerid], 0);
	PlayerTextDrawFont(playerid, MpBtn1Box[playerid], 0);

	MpBtn2Box[playerid] = CreatePlayerTextDraw(playerid, 359.200164, 235.584411, "btn2_box");
	PlayerTextDrawLetterSize(playerid, MpBtn2Box[playerid], 0.000000, 0.654567);
	PlayerTextDrawTextSize(playerid, MpBtn2Box[playerid], 326.633422, 0.000000);
	PlayerTextDrawAlignment(playerid, MpBtn2Box[playerid], 1);
	PlayerTextDrawColor(playerid, MpBtn2Box[playerid], 0);
	PlayerTextDrawUseBox(playerid, MpBtn2Box[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpBtn2Box[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, MpBtn2Box[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpBtn2Box[playerid], 0);
	PlayerTextDrawFont(playerid, MpBtn2Box[playerid], 0);

	MpBtn1[playerid] = CreatePlayerTextDraw(playerid, 343.266662, 223.751190, "Изменить");
	PlayerTextDrawLetterSize(playerid, MpBtn1[playerid], 0.170200, 0.834666);
	PlayerTextDrawTextSize(playerid, MpBtn1[playerid], 3.866662, 27.377767);
	PlayerTextDrawAlignment(playerid, MpBtn1[playerid], 2);
	PlayerTextDrawColor(playerid, MpBtn1[playerid], 255);
	PlayerTextDrawUseBox(playerid, MpBtn1[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpBtn1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, MpBtn1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpBtn1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, MpBtn1[playerid], 51);
	PlayerTextDrawFont(playerid, MpBtn1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, MpBtn1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, MpBtn1[playerid], true);

	MpBtn2[playerid] = CreatePlayerTextDraw(playerid, 343.333374, 234.167495, "Изменить");
	PlayerTextDrawLetterSize(playerid, MpBtn2[playerid], 0.170200, 0.834666);
	PlayerTextDrawTextSize(playerid, MpBtn2[playerid], 3.866662, 27.377767);
	PlayerTextDrawAlignment(playerid, MpBtn2[playerid], 2);
	PlayerTextDrawColor(playerid, MpBtn2[playerid], 255);
	PlayerTextDrawUseBox(playerid, MpBtn2[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpBtn2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, MpBtn2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpBtn2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, MpBtn2[playerid], 51);
	PlayerTextDrawFont(playerid, MpBtn2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, MpBtn2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, MpBtn2[playerid], true);

	MpBtnBox[playerid] = CreatePlayerTextDraw(playerid, 359.266723, 246.406494, "btn3_box");
	PlayerTextDrawLetterSize(playerid, MpBtnBox[playerid], 0.000000, 0.782840);
	PlayerTextDrawTextSize(playerid, MpBtnBox[playerid], 276.266662, 0.000000);
	PlayerTextDrawAlignment(playerid, MpBtnBox[playerid], 1);
	PlayerTextDrawColor(playerid, MpBtnBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, MpBtnBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpBtnBox[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, MpBtnBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpBtnBox[playerid], 0);
	PlayerTextDrawFont(playerid, MpBtnBox[playerid], 0);

	MpBtn[playerid] = CreatePlayerTextDraw(playerid, 317.866638, 244.874221, "Зарегистрировать");
	PlayerTextDrawLetterSize(playerid, MpBtn[playerid], 0.213533, 0.988148);
	PlayerTextDrawTextSize(playerid, MpBtn[playerid], 7.833320, 77.985191);
	PlayerTextDrawAlignment(playerid, MpBtn[playerid], 2);
	PlayerTextDrawColor(playerid, MpBtn[playerid], 255);
	PlayerTextDrawUseBox(playerid, MpBtn[playerid], true);
	PlayerTextDrawBoxColor(playerid, MpBtn[playerid], 0);
	PlayerTextDrawSetShadow(playerid, MpBtn[playerid], 0);
	PlayerTextDrawSetOutline(playerid, MpBtn[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, MpBtn[playerid], 51);
	PlayerTextDrawFont(playerid, MpBtn[playerid], 1);
	PlayerTextDrawSetProportional(playerid, MpBtn[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, MpBtn[playerid], true);
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
	PlayerTextDrawDestroy(playerid, ChrInfDelim1[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDelim2[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDelim3[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDelim4[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDelim5[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfButMod[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfButDel[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfButInfo[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfButSort[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfButUse[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfPersonalRate[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfText1[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfText2[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfRate[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfAllRate[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfClose[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfHatSlot[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfWatchSlot[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfGlassesSlot[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfAmuletteSlot1[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfAmuletteSlot2[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfRingSlot1[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfRingSlot2[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDodge[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfAccuracy[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDefense[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDamage[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfMaxHP[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfCrit[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoHeader[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoBox[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfCrit[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfNextInvBtn[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfPrevInvBtn[playerid]);
	PlayerTextDrawDestroy(playerid, HPBar[playerid]);
	for(new i = 0; i < MAX_PAGE_SLOTS; i++)
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
	PlayerTextDrawDestroy(playerid, EqInfItemType[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfItemMinRank[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfItemGrade[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfTrading[playerid]);
	for(new i = 0; i < 3; i++)
	{
		PlayerTextDrawDestroy(playerid, EqInfBonusStat[playerid][i]);
	}
	for(new i = 0; i < 3; i++)
	{
		PlayerTextDrawDestroy(playerid, EqInfDescriptionStr[playerid][i]);
	}
	for(new i = 0; i < 2; i++)
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
	PlayerTextDrawDestroy(playerid, InfItemEffect[playerid][2]);
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

	PlayerTextDrawDestroy(playerid, CmbBox[playerid]);
	PlayerTextDrawDestroy(playerid, CmbTxt1[playerid]);
	PlayerTextDrawDestroy(playerid, CmbDelim1[playerid]);
	PlayerTextDrawDestroy(playerid, CmbTxt2[playerid]);
	PlayerTextDrawDestroy(playerid, CmbTxt3[playerid]);
	PlayerTextDrawDestroy(playerid, CmbTxt4[playerid]);
	PlayerTextDrawDestroy(playerid, CmbBtn[playerid]);
	PlayerTextDrawDestroy(playerid, CmbBtnBox[playerid]);
	PlayerTextDrawDestroy(playerid, CmbClose[playerid]);

	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		PlayerTextDrawDestroy(playerid, CmbItemSlot[playerid][i]);
		PlayerTextDrawDestroy(playerid, CmbItemSlotCount[playerid][i]);
	}

	PlayerTextDrawDestroy(playerid, MpBox[playerid]);
	PlayerTextDrawDestroy(playerid, MpDelim1[playerid]);
	PlayerTextDrawDestroy(playerid, MpClose[playerid]);
	PlayerTextDrawDestroy(playerid, MpTxt1[playerid]);
	PlayerTextDrawDestroy(playerid, MpItem[playerid]);
	PlayerTextDrawDestroy(playerid, MpItemCount[playerid]);
	PlayerTextDrawDestroy(playerid, MpTxt2[playerid]);
	PlayerTextDrawDestroy(playerid, MpDelim2[playerid]);
	PlayerTextDrawDestroy(playerid, MpTxtPrice[playerid]);
	PlayerTextDrawDestroy(playerid, MpTxtCount[playerid]);
	PlayerTextDrawDestroy(playerid, MpBtn1Box[playerid]);
	PlayerTextDrawDestroy(playerid, MpBtn2Box[playerid]);
	PlayerTextDrawDestroy(playerid, MpBtn1[playerid]);
	PlayerTextDrawDestroy(playerid, MpBtn2[playerid]);
	PlayerTextDrawDestroy(playerid, MpBtnBox[playerid]);
	PlayerTextDrawDestroy(playerid, MpBtn[playerid]);

	PlayerTextDrawDestroy(playerid, PvpPanelBox[playerid]);
	PlayerTextDrawDestroy(playerid, PvpPanelHeader[playerid]);
	PlayerTextDrawDestroy(playerid, PvpPanelTimer[playerid]);
	PlayerTextDrawDestroy(playerid, PvpPanelDelim[playerid]);
	PlayerTextDrawDestroy(playerid, PvpPanelMyName[playerid]);
	PlayerTextDrawDestroy(playerid, PvpPanelMyScore[playerid]);

	for(new i = 0; i < MAX_PVP_PANEL_ITEMS; i++)
	{
		PlayerTextDrawDestroy(playerid, PvpPanelNameLabels[playerid][i]);
		PlayerTextDrawDestroy(playerid, PvpPanelScoreLabels[playerid][i]);
	}
}

stock CreatePickups()
{
	home_enter = CreatePickup(1318,23,224.0201,-1837.3518,4.2787);
	home_quit = CreatePickup(1318,23,-2158.6240,642.8425,1052.3750);
	boss_tp = CreatePickup(19605,23,243.1539,-1831.6542,3.3772);
	arena_tp = CreatePickup(19607,23,204.7617,-1831.6539,3.3772);
	war_tp = CreatePickup(19607,23,243.0740,-1824.2559,3.5772);
	health_pickup = CreatePickup(1240,2,-2160.0583,638.8598,1057.5861);
    
	Create3DTextLabel("Дом клоунов",0xf2622bFF,224.0201,-1837.3518,4.2787,70.0,0,1);
	Create3DTextLabel("К боссам",0xeaeaeaFF,243.1539,-1831.6542,3.9772,70.0,0,1);
	Create3DTextLabel("Территория войны",0xeaeaeaFF,243.0740,-1824.2559,4.1772,70.0,0,1);
	Create3DTextLabel("На арену",0xeaeaeaFF,204.7617,-1831.6539,4.1772,70.0,0,1);
	Create3DTextLabel("Доска почета",0xFFCC00FF,-2171.3132,645.5896,1053.3817,10.0,0,1);
	Create3DTextLabel("Торговец расходниками",0xFFCC00FF,-2166.7527,646.0400,1052.3750,55.0,0,1);
	Create3DTextLabel("Оружейник",0xFFCC00FF,189.2644,-1825.4902,4.1411,55.0,0,1);
	Create3DTextLabel("Портной",0xFFCC00FF,262.6658,-1825.2792,3.9126,55.0,0,1);
	Create3DTextLabel("Буржуа",0x9933CCFF,221.0985,-1838.1259,3.6268,55.0,0,1);
	Create3DTextLabel("Коллекционер",0x99CC00FF,218.1786,-1835.7053,3.7114,55.0,0,1);
	Create3DTextLabel("Поставщик территории войны",0x993366FF,237.1899,-1827.0797,3.8839,55.0,0,1);
	//Create3DTextLabel("Новогодний Шажок",0xFF0000FF,198.3415,-1854.9188,3.2889,55.0,0,1);
	Create3DTextLabel("Заведующий турнирами",0x3366FFFF,226.7674,-1837.6835,3.6120,55.0,0,1);
	Create3DTextLabel("Почта",0x3366CCFF,212.3999,-1838.2000,3.0000,55.0,0,0);
	Create3DTextLabel("Рынок",0xFF9900FF,231.7,-1840.6,4.2,55.0,0,0);

	Actors[0] =	CreateActor(26,-2166.7527,646.0400,1052.3750,179.9041);
	Actors[1] =	CreateActor(6,189.2644,-1825.4902,4.1411,185.0134);
	Actors[2] =	CreateActor(60,262.6658,-1825.2792,3.9126,181.2770);
	Actors[3] =	CreateActor(249,221.0985,-1838.1259,3.6268,177.8066);
	Actors[4] =	CreateActor(61,226.7674,-1837.6835,3.6120,188.3151);
	Actors[5] =	CreateActor(1,218.1786,-1835.7053,3.7114,178.7002);
	Actors[6] =	CreateActor(33,237.1899,-1827.0797,3.8839,270.2349);
	//Actors[6] = CreateActor(5,198.3415,-1854.9188,3.2889,271.9724);
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
	CreateObject(3077,231.7000000,-1840.6000000,2.5000000,0.0000000,0.0000000,0.0000000); //object(nf_blackboard) (1)
	CreateObject(1344,218.9003900,-1834.4004000,3.6000000,0.0000000,0.0000000,0.0000000); //object(cj_dumpster2) (1)
	CreateObject(1343,217.2998000,-1834.2998000,3.5000000,0.0000000,0.0000000,0.0000000); //object(cj_dumpster3) (1)
	CreateObject(3524,1446.8000000,1496.1000000,12.7000000,0.0000000,0.0000000,0.0000000); //object(skullpillar01_lvs) (1)
	CreateObject(3524,1419.4000000,1495.5000000,12.7000000,0.0000000,0.0000000,0.0000000); //object(skullpillar01_lvs) (2)
	CreateObject(3524,1419.4000000,1514.5000000,12.7000000,0.0000000,0.0000000,180.0000000); //object(skullpillar01_lvs) (3)
	CreateObject(3524,1446.2000000,1514.8000000,12.7000000,0.0000000,0.0000000,179.9950000); //object(skullpillar01_lvs) (4)
	CreateObject(9833,1432.2000000,1504.6000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(fountain_sfw) (1)
	CreateObject(2745,1432.6000000,1504.9000000,10.9000000,0.0000000,0.0000000,0.0000000); //object(cj_stat_3) (1)
	CreateObject(8131,1432.1000000,1636.1000000,20.0500000,0.0000000,0.0000000,0.0000000); //object(vgschurch02_lvs) (1)
	CreateObject(8131,1433.2000000,1382.2000000,20.0500000,0.0000000,0.0000000,0.0000000); //object(vgschurch02_lvs) (2)
	CreateObject(3884,1442.5996000,1381.2002000,9.4000000,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (1)
	CreateObject(3884,1423.9000000,1380.9000000,9.4000000,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (2)
	CreateObject(3884,1444.1000000,1637.9000000,9.4000000,0.0000000,0.0000000,180.0000000); //object(samsite_sfxrf) (3)
	CreateObject(3884,1421.2000000,1638.2000000,9.4000000,0.0000000,0.0000000,179.9950000); //object(samsite_sfxrf) (4)
	CreateObject(2098,-66.8000000,1516.8000000,13.7000000,0.0000000,0.0000000,278.0000000); //object(cj_slotcover1) (1)
	CreateObject(2755,-66.7000000,1516.9000000,11.8000000,90.0000000,0.0000000,10.0000000); //object(dojo_wall) (1)
	CreateObject(2755,243.0000000,-1823.3000000,3.0000000,90.0000000,0.0000000,0.0000000); //object(dojo_wall) (2)
	CreateObject(2098,243.1000100,-1823.7000000,4.8900000,0.0000000,0.0000000,0.0000000); //object(cj_slotcover1) (2)

	//CreateObject(19076,195.8000000,-1854.9000000,2.3000000,0.0000000,0.0000000,0.0000000); //object(xmas) (1)
	//CreateObject(19054,195.6082,-1856.1352,2.7000000,0.0000000,0.0000000,20.0000000); //object(xmas) (1)
	//CreateObject(19056,195.5078,-1853.9680,2.7000000,0.0000000,0.0000000,30.0000000); //object(xmas) (1)
	//CreateObject(19057,197.0055,-1854.7861,2.7000000,0.0000000,0.0000000,40.0000000); //object(xmas) (1)

	//new cola_veh_id = CreateVehicle(515,183.7026,-1861.7371,3.9194,359.9408,39,47,3); //Roadtrain
	//new cola_trailer_veh_id = CreateVehicle(435,183.7002000,-1872.4004000,3.4000000,0.0000000,245,245,3); //Trailer 1

	//SetVehicleParamsEx(cola_veh_id, 0, 0, 0, 1, 0, 0, 0);
	//SetVehicleParamsEx(cola_trailer_veh_id, 0, 0, 0, 1, 0, 0, 0);
}
