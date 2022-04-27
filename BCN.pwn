//Bourgeois Circus 6.0

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
#include <progress2>
#include <sampp>

#pragma dynamic 31294

#define VERSION 6.001

//Mysql settings
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
#define DEFAULT_ARMOR_ID 35
#define DEFAULT_HAT_ID 70
#define DEFAULT_DAMAGE_MIN 13
#define DEFAULT_DAMAGE_MAX 15
#define DEFAULT_DEFENSE 100
#define DEFAULT_CRIT 10
#define DEFAULT_DODGE 0
#define DEFAULT_ACCURACY 20
#define DEFAULT_CRIT_MULT 120
#define DEFAULT_CRIT_MULT_REDUCTION 0
#define DEFAULT_CRIT_REDUCTION 0
#define DEFAULT_VAMP 0
#define DEFAULT_DAMAGE_REFLECTION 0
#define DEFAULT_REGENERATION 2
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
#define MAX_SLOTS 294
#define MAX_PAGE_SLOTS 42
#define MAX_SLOTS_X 6
#define MAX_SLOTS_Y 7
#define MAX_INV_PAGES 7
#define MAX_RANK 14
#define MAX_MOD 13
#define MAX_STAGE 10
#define MAX_PROPERTIES 3
#define MAX_STATS 7
#define MAX_DESCRIPTION_SIZE 40
#define MAX_GRADES 6
#define MAX_BOSSES 18
#define MAX_ITEM_ID 1100
#define MAX_ITEM_TYPES 10
#define MAX_DUNGEON_TYPES 9

#define MAX_LOOT 24
#define MAX_WALKER_LOOT 6
#define MAX_DUNGEON_LOOT 18

#define MAX_LOOT_VARIANTS 60
#define MAX_STAT_VARIANTS 60

#define MAX_PVP_PANEL_ITEMS 5
#define MAX_RELIABLE_TARGETS 5
#define MAX_RATE 9000
#define MAX_DEATH_MESSAGES 5
#define MAX_NPC_MOVING_TICKS 60
#define MAX_NPC_IDLE_TICKS 30
#define MAX_NPC_SHOT_TICKS 60
#define MAX_CMB_ITEMS 3
#define MAX_MARKET_CATEGORIES 4
#define MAX_MARKET_ITEMS 25
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
#define PARAM_CRITICAL_MULT 6
#define PARAM_CRITICAL_REDUCTION 7
#define PARAM_CRITICAL_MULT_REDUCTION 8
#define PARAM_VAMP 9

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

//Item grades
#define GRADE_N 1
#define GRADE_B 2
#define GRADE_C 3
#define GRADE_R 4
#define GRADE_S	5
#define GRADE_F 6

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
#define PROPERTY_PARADOX 13

//Stats
#define STAT_NONE 0
#define STAT_DAMAGE 1
#define STAT_DODGE 2
#define STAT_ACCURACY 3
#define STAT_HP_PERCENTAGE 4
#define STAT_CRIT_CHANCE 5
#define STAT_DAMAGE_PERCENTAGE 6
#define STAT_DEFENSE_PERCENTAGE 7
#define STAT_CRIT_MULT 8
#define STAT_CRIT_REDUCTION 9
#define STAT_CRIT_MULT_REDUCTION 10
#define STAT_VAMP 11
#define STAT_DAMAGE_REFLECTION 12
#define STAT_REGENERATION 13

//Mod results
#define MOD_RESULT_SUCCESS 0
#define MOD_RESULT_FAIL 1
#define MOD_RESULT_DESTROY 2

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
#define COLT_SHOOT_DELAY 			190
#define DEAGLE_SHOOT_DELAY 		240
#define MP5_SHOOT_DELAY 			130
#define TEC_SHOOT_DELAY 			70
#define AK_SHOOT_DELAY 				185
#define M4_SHOOT_DELAY 				175
#define SHOTGUN_SHOOT_DELAY 	410
#define SAWNOFF_SHOOT_DELAY 	380
#define COMBAT_SHOOT_DELAY 		350
#define RIFLE_SHOOT_DELAY			420

//Special abilites
#define SPECIAL_AB_EFFECT_NONE 					0
#define SPECIAL_AB_EFFECT_CONFUSION 		1
#define SPECIAL_AB_EFFECT_SHAZOK_FORCE 	2

//Special activites
#define SPECIAL_ACTIVITY_NONE 			0
#define SPECIAL_ACTIVITY_S_DELIVERY 1
#define SPECIAL_ACTIVITY_COOLDOWN 	10

//Special effects
#define SPECIAL_EFFECT_NONE								0
#define SPECIAL_EFFECT_VICTORY_FLAG_I 		1
#define SPECIAL_EFFECT_VICTORY_FLAG_II 		2
#define SPECIAL_EFFECT_VICTORY_FLAG_III 	3
#define SPECIAL_EFFECT_SCAR_OF_DEFEAT_I 	4
#define SPECIAL_EFFECT_SCAR_OF_DEFEAT_II 	5
#define SPECIAL_EFFECT_SCAR_OF_DEFEAT_III 6

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
enum StatItem
{
  Stat,
	Text[255],
	StatType,
	StatEnum,
  Value
};
enum TopItem
{
	Pos,
	Name[255],
	Kills,
	Deaths,
  Assists,
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
	Mod,
	Stage,
  Stats[MAX_STATS]
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
  Assists,
  KillStreak,
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
	Mod,
	Stage,
  Stats[MAX_STATS],
	Count
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
  CritMult,
	CritReduction,
	CritMultReduction,
	Vamp,
	Regeneration,
	DamageReflection,
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
	WeaponMod,
	ArmorMod,
	HatMod,
	GlassesMod,
	WatchMod,
	WeaponStage,
	ArmorStage,
	HatStage,
	GlassesStage,
	WatchStage,
  WeaponStats[MAX_STATS],
  ArmorStats[MAX_STATS],
  HatStats[MAX_STATS],
  GlassesStats[MAX_STATS],
  WatchStats[MAX_STATS],
  Ring1Stats[MAX_STATS],
  Ring2Stats[MAX_STATS],
  Amulette1Stats[MAX_STATS],
  Amulette2Stats[MAX_STATS]
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

new ItemsDatabase[MAX_ITEM_ID][BaseItem];
new bool:items_database_loaded = false;

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
new bool:IsBossHelpRequred = false;
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
new bool:PlayerInventorySelectionList[MAX_PLAYERS][MAX_SLOTS];
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

new CandidateNameBuffer[MAX_PLAYERS][255];
new bool:IsControllable[MAX_PLAYERS] = true;

//Arrays
new DungeonsKeysID[MAX_DUNGEON_TYPES] = {
  1057,
  1058,
  1059,
  1060,
  1061,
  1062,
  1063,
  1064,
  1086
};
new EmptyInvItem[iInfo] = {
	-1,
  0,
  0,
	{-1,-1,-1,-1,-1,-1,-1},
	0
};
new STATS_CLEAR[MAX_STATS] = {-1,-1,-1,-1,-1,-1,-1};
new EmptyMarketSellingItem[MarketItem] = {
	-1,
	-1,
	0,
	0,
	0,
	"None",
	0,
	0,
  {-1,-1,-1,-1,-1,-1,-1}
};
new BossesNames[MAX_BOSSES][128] = {
	{"BOSS_Edemsky"},
	{"BOSS_FactoryWorker"},
	{"BOSS_Maximus"},
	{"BOSS_ShazokVsemog"},
	{"BOSS_Bourgeois"},
	{"BOSS_Priest"},
	{"BOSS_MadGrandfather"},
	{"BOSS_CJ"},
  {"BOSS_ZapTsar"},
  {"BOSS_TimeKing"},
  {"BOSS_RageMaximus"},
	{"BOSS_RageShazokVsemog"},
	{"BOSS_RageBourgeois"},
	{"BOSS_RagePriest"},
	{"BOSS_RageMadGrandfather"},
	{"BOSS_RageCJ"},
  {"BOSS_RageZapTsar"},
  {"BOSS_RageTimeKing"}
};
new BossesSkins[MAX_BOSSES][1] = {
	{78},
	{8},
	{119},
	{149},
	{249},
	{1},
	{161},
	{0},
  {3},
  {299},
  {119},
	{149},
	{249},
	{1},
	{161},
	{0},
  {3},
  {299}
};
new BossesWeapons[MAX_BOSSES][1] = {
	{22},
	{32},
	{30},
	{25},
	{26},
	{25},
	{25},
	{30},
  {26},
  {26},
  {30},
	{25},
	{26},
	{25},
	{25},
	{30},
  {26},
  {26}
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
	{"6d9eeb"},
	{"d520d5"},
	{"9900ff"},
	{"0aa73b"},
	{"cc0000"},
	{"f37e00"}
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
	{0x6d9eebff},
	{0xd520d5ff},
	{0x9900ffff},
	{0x0aa73bff},
	{0xcc0000ff},
	{0xf37e00ff}
};
new HexGradeColors[MAX_GRADES][1] = {
	{0xCCCCCCFF},
	{0x42a517FF},
	{0x1155ccFF},
	{0x9900ffFF},
	{0xe69138FF},
  {0xd53333FF}
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
new Text:Version;

//Player
new PlayerText:PvpPanelBox[MAX_PLAYERS];
new PlayerText:PvpPanelHeader[MAX_PLAYERS];
new PlayerText:PvpPanelTimer[MAX_PLAYERS];
new PlayerText:PvpPanelNameLabels[MAX_PLAYERS][MAX_PVP_PANEL_ITEMS];
new PlayerText:PvpPanelScoreLabels[MAX_PLAYERS][MAX_PVP_PANEL_ITEMS];
new PlayerText:PvpPanelDelim[MAX_PLAYERS];
new PlayerText:PvpPanelMyName[MAX_PLAYERS];
new PlayerText:PvpPanelMyScore[MAX_PLAYERS];

new PlayerText:RankRing[MAX_PLAYERS];
new PlayerText:RankText[MAX_PLAYERS];
new PlayerText:PlayerNameText[MAX_PLAYERS];
new PlayerText:PlayerHPBarNumbers[MAX_PLAYERS];
new PlayerText:CashIcon[MAX_PLAYERS];
new PlayerText:PlayerCashText[MAX_PLAYERS];

new PlayerBar:PlayerHPBar[MAX_PLAYERS];

new PlayerText:ChrInfInvSlot[MAX_PLAYERS][MAX_PAGE_SLOTS];
new PlayerText:ChrInfInvSlotCount[MAX_PLAYERS][MAX_PAGE_SLOTS];
new PlayerText:ChrInfButUse[MAX_PLAYERS];
new PlayerText:ChrInfButMod[MAX_PLAYERS];
new PlayerText:ChrInfButDel[MAX_PLAYERS];
new PlayerText:ChrInfButInfo[MAX_PLAYERS];
new PlayerText:ChrInfButSort[MAX_PLAYERS];
new PlayerText:ChrInfoBox[MAX_PLAYERS];
new PlayerText:ChrInfoHeader[MAX_PLAYERS];
new PlayerText:ChrInfoClose[MAX_PLAYERS];
new PlayerText:ChrInfoDelim1[MAX_PLAYERS];
new PlayerText:ChrInfoSkin[MAX_PLAYERS];
new PlayerText:ChrInfAmuletteSlot1[MAX_PLAYERS];
new PlayerText:ChrInfAmuletteSlot2[MAX_PLAYERS];
new PlayerText:ChrInfRingSlot1[MAX_PLAYERS];
new PlayerText:ChrInfRingSlot2[MAX_PLAYERS];
new PlayerText:ChrInfGlassesSlot[MAX_PLAYERS];
new PlayerText:ChrInfWatchSlot[MAX_PLAYERS];
new PlayerText:ChrInfHatSlot[MAX_PLAYERS];
new PlayerText:ChrInfWeaponSlot[MAX_PLAYERS];
new PlayerText:ChrInfArmorSlot[MAX_PLAYERS];
new PlayerText:ChrInfoDelim2[MAX_PLAYERS];
new PlayerText:ChrInfoDelim3[MAX_PLAYERS];
new PlayerText:ChrInfDamage[MAX_PLAYERS];
new PlayerText:ChrInfDefense[MAX_PLAYERS];
new PlayerText:ChrInfAccuracy[MAX_PLAYERS];
new PlayerText:ChrInfDodge[MAX_PLAYERS];
new PlayerText:ChrInfCritChance[MAX_PLAYERS];
new PlayerText:ChrInfCritMult[MAX_PLAYERS];
new PlayerText:ChrInfCritMultReduction[MAX_PLAYERS];
new PlayerText:ChrInfCritReduction[MAX_PLAYERS];
new PlayerText:ChrInfVamp[MAX_PLAYERS];
new PlayerText:ChrInfRegeneration[MAX_PLAYERS];
new PlayerText:ChrInfDamageReflection[MAX_PLAYERS];
new PlayerText:ChrInfRateIcon[MAX_PLAYERS];
new PlayerText:ChrInfRate[MAX_PLAYERS];
new PlayerText:ChrInfText1[MAX_PLAYERS];
new PlayerText:ChrInfText2[MAX_PLAYERS];
new PlayerText:ChrInfAllRate[MAX_PLAYERS];
new PlayerText:ChrInfPersonalRate[MAX_PLAYERS];
new PlayerText:ChrInfoDelim4[MAX_PLAYERS];
new PlayerText:ChrInfCurInv[MAX_PLAYERS];
new PlayerText:ChrInfPrevInvBtn[MAX_PLAYERS];
new PlayerText:ChrInfNextInvBtn[MAX_PLAYERS];
new PlayerText:ChrInfoDelim5[MAX_PLAYERS];
new PlayerText:ChrInfoDelim6[MAX_PLAYERS];

new PlayerText:EqInfBox[MAX_PLAYERS];
new PlayerText:EqInfTxt1[MAX_PLAYERS];
new PlayerText:EqInfClose[MAX_PLAYERS];
new PlayerText:EqInfDelim1[MAX_PLAYERS];
new PlayerText:EqInfItemName[MAX_PLAYERS];
new PlayerText:EqInfItemType[MAX_PLAYERS];
new PlayerText:EqInfMinRank[MAX_PLAYERS];
new PlayerText:EqInfGrade[MAX_PLAYERS];
new PlayerText:EqInfStage[MAX_PLAYERS];
new PlayerText:EqInfItemIcon[MAX_PLAYERS];
new PlayerText:EqInfDelim2[MAX_PLAYERS];
new PlayerText:EqInfDelim3[MAX_PLAYERS];
new PlayerText:EqInfDelim4[MAX_PLAYERS];
new PlayerText:EqInfDelim5[MAX_PLAYERS];
new PlayerText:EqInfPrice[MAX_PLAYERS];
new PlayerText:EqInfTrading[MAX_PLAYERS];
new PlayerText:EqInfSpecialParamsText[MAX_PLAYERS];
new PlayerText:EqInfSpecialStats[MAX_PLAYERS][MAX_STATS];
new PlayerText:EqInfMainStats[MAX_PLAYERS][4];
new PlayerText:EqInfDescriptionStr[MAX_PLAYERS][3];

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
new Text:MpBtn[MAX_PLAYERS];

new PlayerText:UpgBox[MAX_PLAYERS];
new PlayerText:UpgTxt1[MAX_PLAYERS];
new PlayerText:UpgDelim1[MAX_PLAYERS];
new PlayerText:UpgItemSlot[MAX_PLAYERS];
new PlayerText:UpgTxt2[MAX_PLAYERS];
new PlayerText:UpgTxt3[MAX_PLAYERS];
new PlayerText:UpgPotionSlot[MAX_PLAYERS];
new PlayerText:UpgPotionCount[MAX_PLAYERS];
new PlayerText:UpgDefSlot[MAX_PLAYERS];
new PlayerText:UpgDefCount[MAX_PLAYERS];
new PlayerText:UpgBtn[MAX_PLAYERS];
new PlayerText:UpgSafeBtn[MAX_PLAYERS];
new PlayerText:UpgClose[MAX_PLAYERS];
new PlayerText:UpgOldItemTxt[MAX_PLAYERS];
new PlayerText:UpgNewItemTxt[MAX_PLAYERS];
new PlayerText:UpgArrow[MAX_PLAYERS];
new PlayerText:UpgMainTxt[MAX_PLAYERS];
new PlayerText:UpgCongrTxt[MAX_PLAYERS];

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
	if(rate < 0 || rate > 9000)
		return SendClientMessage(playerid, COLOR_GREY, "Value should be between 0 and 9000.");
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
	GivePlayerCash(playerid, money);
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
	if(itemid <= 0 || itemid == DEFAULT_ARMOR_ID || itemid == DEFAULT_HAT_ID || itemid > MAX_ITEM_ID || !DbItemExists(itemid))
		return SendClientMessage(playerid, COLOR_GREY, "Invalid item id.");
	if(count <= 0)
		return SendClientMessage(playerid, COLOR_GREY, "Invalid count.");
	if(IsInventoryFull(playerid))
		return SendClientMessage(playerid, COLOR_GREY, "Inventory is full.");
	
	new ok = false;
	if(IsEquip(itemid))
		ok = AddEquip(playerid, itemid, STATS_CLEAR);
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

cmd:lottery(playerid, params[])
{
	if(PlayerInfo[playerid][Admin] == 0)
		return 0;
		
	MakeLottery();
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

  LoadItemsDatabase();

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

  if(!items_database_loaded)
  {
    SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка сервера: items database is not loaded.");
    SendClientMessage(playerid, COLOR_GREY, "При текущем статусе сервера вход невозможен. Повторите попытку позднее.");
    SendClientMessage(playerid, COLOR_GREEN, "Введите /q для выхода.");
    return 1;
  }

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
  SetPlayerScore(playerid, 0);

	if(!FCNPC_IsValid(playerid))
	{
		InitPlayerTextDraws(playerid);
		HideAllWindows(playerid);
		ResetPlayerMoney(playerid);
		GivePlayerCash(playerid, PlayerInfo[playerid][Cash]);
		UpdatePlayerPost(playerid);
		SetPVarInt(playerid, "InvPage", 1);
    DisableInvSelectionMode(playerid);
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

	ShowHUD(playerid);
	
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

  if(Tournament[Number] % 5 == 0)
  {
    UpdateVoteStatus(1);
    SendClientMessageToAll(COLOR_LIGHTRED, "Выборы Патриарха начались.");
  }

	if(Tournament[Number] % 10 == 0)
  {
		UpdateHierarchy();
    MakeLottery();
  }

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

stock GetInvSelectedItemsCount(playerid)
{
  if(!IsInvSelectionModeEnabled(playerid))
  {
    if(SelectedSlot[playerid] == -1)
      return 0;
    
    return 1;
  }

  new count = 0;
  for(new i = 0; i < MAX_SLOTS; i++)
  {
    if(PlayerInventorySelectionList[playerid][i])
      count++;
  }

  return count;
}

stock IsInvSelectionModeEnabled(playerid)
{
  new enabled = GetPVarInt(playerid, "InvSelectionMode");
  if(enabled > 0)
    return true;

  return false;
}

stock DisableInvSelectionMode(playerid)
{
  SetPVarInt(playerid, "InvSelectionMode", 0);
  ResetInvSelectionData(playerid);
}

stock EnableInvSelectionMode(playerid)
{
  SetPVarInt(playerid, "InvSelectionMode", 1);
  ResetInvSelectionData(playerid);
}

stock ResetInvSelectionData(playerid)
{
  for(new i = 0; i < MAX_SLOTS; i++)
    PlayerInventorySelectionList[playerid][i] = false;

  if(IsInventoryOpen[playerid])
  {
    for(new i = 0; i < MAX_SLOTS; i++)
      SetSlotSelection(playerid, i, false);
  }

  SelectedSlot[playerid] = -1;
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

  for(new i = 0; i < MAX_PARTICIPANTS; i++)
    SetPlayerScore(PvpInfo[i][ID], i+1);
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
	else
		damage = PlayerInfo[playerid][DamageMin] + random(PlayerInfo[playerid][DamageMax]-PlayerInfo[playerid][DamageMin]+1);

  if(is_crit)
  {
    new Float:mult;
		mult = floatsub(floatdiv(PlayerInfo[playerid][CritMult], 100), floatdiv(PlayerInfo[damagedid][CritMultReduction], 100));
		if(mult <= 0)
			mult = 0.01;

		damage = floatround(floatmul(floatmul(damage, mult), floatsub(1.0, floatdiv(PlayerInfo[damagedid][CritReduction], 100))));
		if(damage <= 0)
			damage = 1;
  }
	
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

	if(PlayerInfo[damagedid][DamageReflection] > 0 && real_damage > 0)
	{
		new Float:refl_hp = floatmul(floatdiv(PlayerInfo[damagedid][DamageReflection], 100), real_damage);
		GivePlayerHP(playerid, -refl_hp);
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
	HideHUD(playerid);

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
  SetPVarInt(playerid, "Stun", 0);

  IsControllable[playerid] = true;
	TogglePlayerControllable(playerid, 1);

	TogglePlayerInfiniteRun(playerid, true);
	SetPlayerNoReload(playerid, true);

	HideNativeHUD(playerid);

	if(IsDeath[playerid]) 
	{
    IsDeath[playerid] = false;
		if(IsTourStarted && IsTourParticipant(PlayerInfo[playerid][ID]))
		{
			ResetDamagersInfo(playerid);
			TeleportToRandomArenaPos(playerid);
			SetPlayerInvulnearable(playerid, TOUR_INVULNEARABLE_TIME);
			if(SpecialAbilityEffect == SPECIAL_AB_EFFECT_CONFUSION && GetPlayerTourTeam(playerid) != SpecialAbilityEffectTeam)
				TogglePlayerControllableEx(playerid, 0);
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

stock TogglePlayerControllableEx(playerid, controllable)
{
  if(controllable == 0 && IsControllable[playerid] || controllable > 0 && !IsControllable[playerid])
  {
    TogglePlayerControllable(playerid, controllable);
    IsControllable[playerid] = controllable > 0 ? true : false;
  }
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
  new mod_level = PlayerInfo[playerid][WeaponMod];
	switch(mod_level)
	{
    case 0..6:
    {
      RemovePlayerAttachedObject(playerid, 0);
      RemovePlayerAttachedObject(playerid, 1);
    }
    case 7..9:
    {
      SetPlayerAttachedObject(playerid, 0, 18700, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
      SetPlayerAttachedObject(playerid, 1, 18700, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
    }
    case 10..12:
    {
      SetPlayerAttachedObject(playerid, 0, 18699, 5, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
      SetPlayerAttachedObject(playerid, 1, 18699, 6, 1.983503, 1.558882, -0.129482, 86.705787, 308.978118, 268.198822, 1.500000, 1.500000, 1.500000);
    }
    case 13:
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

	SetPVarFloat(playerid, "HP", 0);
	UpdateHPBar(playerid);

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
    PvpInfo[killer_idx][KillStreak]++;
    ShowKillStreakMessage(_killerid, PvpInfo[killer_idx][KillStreak]);

		PvpInfo[player_idx][Deaths]++;
    PvpInfo[player_idx][KillStreak] = 0;
		
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
		if(IsBossAttacker[playerid] && killerid == BossNPC)
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
  SetPVarInt(npcid, "Stun", 0);
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
  {
    new idx = GetPvpIndex(npcid);
    new time = floatround(floatmul(floatadd(3, floatmul(1.15, PvpInfo[idx][Kills])), 1000));
		DeadCheckTimer[npcid] = SetTimerEx("CheckDead", time, false, "i", npcid);
  }
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
  PlayerInfo[walkerid][CritMult] = 120;
  PlayerInfo[walkerid][CritReduction] = 0;
  PlayerInfo[walkerid][CritMultReduction] = 0;
  PlayerInfo[walkerid][Vamp] = 0;

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
				AddEquip(playerid, BossLootItems[i][ItemID], STATS_CLEAR);
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
					AddEquip(playerid, WalkerLootItems[j][i][ItemID], STATS_CLEAR);
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
				AddEquip(playerid, DungeonLootItems[j][i][ItemID], STATS_CLEAR);
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

			new listitems[] = "Комбинирование\nДобавление характеристик\nПовышение стадии";
			ShowPlayerDialog(playerid, 1300, DIALOG_STYLE_LIST, "Буржуа", listitems, "Далее", "Закрыть");
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
		//командующий
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 229.6244,-1834.8005,3.6818))
		{
			ShowCommandoMenu(playerid);
		}
		//доска почета
		else if(IsPlayerInRangeOfPoint(playerid,1.2,-2171.3132,645.5896,1052.3817)) 
		{
			new listitems[] = "Общий рейтинг участников\nРейтинг моих участников";
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
			if(AttackedBoss != -1 && !IsBossHelpRequred)
			{
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Боссы", "Телепорт занят или сражение уже идет.", "Закрыть", "");
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
										PendingItem(PlayerInfo[playerid][Name], w_loot[ItemID], "Награда симуляции", STATS_CLEAR, w_loot[Count]);
									continue;
								}

								if(IsEquip(w_loot[ItemID]))
									AddEquip(playerid, w_loot[ItemID], STATS_CLEAR);
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
					if(ok > 0)
					{
						new item[BaseItem];
						item = GetItem(itemid);
						new price = item[Price] / 7;
						price -= price / 95;
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

				new price = SellItem(playerid, SelectedSlot[playerid], count);
				
				new string[255];
				format(string, sizeof(string), "{ffffff}Вы продали: [{%s}%s{ffffff}] (x%d).\n{66CC00}Получено: %s$.", GetGradeColor(item[Grade]), item[Name], count, FormatMoney(price));
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", string, "Закрыть", "");
			}
			return 1;
		}
		case 404:
		{
			if(response)
			{
				if(SelectedSlot[playerid] == -1)
					return 0;
				
				new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
				if(itemid == -1)
					return 0;
				
				if(!IsModifiableEquip(itemid))
					return 0;

				DisassembleEquip(playerid, SelectedSlot[playerid]);
			}
			return 1;
		}
    case 405:
    {
      if(response)
			{
        new sel_count = GetInvSelectedItemsCount(playerid);
				if(sel_count <= 0)
					return 0;

        new cash_amount = 0;
        for(new i = 0; i < MAX_SLOTS; i++)
        {
          if(!PlayerInventorySelectionList[playerid][i])
            continue;

          new itemid = PlayerInventory[playerid][i][ID];
          if(itemid == -1)
            continue;
          
          if(IsPlayerBesideNPC(playerid))
          {
            new cash = SellItem(playerid, i, PlayerInventory[playerid][i][Count]);
            cash_amount += cash;
          }
          else
          {
            if(!IsModifiableEquip(itemid))
              DeleteItem(playerid, i, PlayerInventory[playerid][i][Count]);

            DisassembleEquip(playerid, i);
          }
        }

        DisableInvSelectionMode(playerid);

        new string[255];
        if(cash_amount > 0)
        {
          format(string, sizeof(string), "{66CC00}Получено: %s$.", FormatMoney(cash_amount));
				  ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", string, "Закрыть", "");
        }
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
				GivePlayerCash(playerid, -item[Price]);
				AddEquip(playerid, itemid, STATS_CLEAR);
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
				GivePlayerCash(playerid, -item[Price]);
				AddEquip(playerid, itemid, STATS_CLEAR);
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

        new price = item[Price];
        if(itemid == 1068)
        {
          new med_rank = GetMedianPlayersRank();
          if(med_rank < 1)
            med_rank = 1;

          price = item[Price] * med_rank;
        }

				SetPVarInt(playerid, "BuyedItemID", itemid);
        SetPVarInt(playerid, "BuyedItemPrice", price);

				new available_count = PlayerInfo[playerid][Cash] / price;
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

        new price = GetPVarInt(playerid, "BuyedItemPrice");
				if(PlayerInfo[playerid][Cash] < price * count)
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

        new price = GetPVarInt(playerid, "BuyedItemPrice");
				new final_price = price * count;

				PlayerInfo[playerid][Cash] -= final_price;
				GivePlayerCash(playerid, -final_price);

				AddItem(playerid, itemid, count);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Покупка", "{66CC00}Предмет куплен.", "Закрыть", "");

				if(item[Type] == ITEMTYPE_PASSIVE)
					UpdatePlayerStats(playerid);
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
					ShowPlayerDialog(playerid, 802, DIALOG_STYLE_MSGBOX, "Боссы", "На одного из боссов уже идет атака. Отменить?", "Да", "Нет");
					return 0;
				}

				if(AttackedBoss != -1 && listitem == AttackedBoss && !IsBossHelpRequred)
				{
					ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Боссы", "Сражение с этим боссом уже идет, ваша помощь не требуется.", "Закрыть", "");
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
				}
				else
					ShowPlayerDialog(playerid, 801, DIALOG_STYLE_MSGBOX, "Боссы", "Запросить поддержку?", "Да", "Нет");
			}
			return 1;
		}
		case 801:
		{
			new msg[255];
			new bossid = AttackedBoss;

			if(bossid == -1)
				return 0;

			new boss[BossInfo];
			boss = GetBoss(bossid);

			if(response)
			{
				PrepareBossAttackTimer = SetTimer("CancelBossAttack", 120000, false);
				new name[255];
				GetPlayerName(playerid, name, sizeof(name));
				format(msg, sizeof(msg), "%s начал атаку на %s!", name, boss[Name]);
				SendClientMessageToAll(0x990099FF, msg);
				IsBossHelpRequred = true;
			}
			else
			{
				format(msg, sizeof(msg), "Появляется %s!", boss[Name]);
				SendClientMessageToAll(0x990099FF, msg);
				if(IsValidTimer(PrepareBossAttackTimer))
					KillTimer(PrepareBossAttackTimer);
				PrepareBossAttackTimer = -1;
				StartBossAttack();
			}
		}
		case 802:
		{
			if(response)
				CancelBossAttack();

			new listitems[1024];
			listitems = GetBossesList();
			ShowPlayerDialog(playerid, 800, DIALOG_STYLE_TABLIST_HEADERS, "Боссы", listitems, "Атака", "Закрыть");
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
					
					SetPVarInt(playerid, "MarketBuyItemListID", listitem);
					new iinfo[2048];
					iinfo = GetMarketItemDesc(listitem, category);
					ShowPlayerDialog(playerid, 1107, DIALOG_STYLE_MSGBOX, "Рынок", iinfo, "Купить", "Отмена");
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
		case 1107:
		{
			if(response)
			{
				new category = GetPVarInt(playerid, "MarketBuyCategory");
				new _listitem = GetPVarInt(playerid, "MarketBuyItemListID");

				new item[MarketItem];
				item = GetMarketItem(_listitem, category);

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
			else
				ShowPlayerDialog(playerid, 1103, DIALOG_STYLE_TABLIST, "Рынок", "Оружие\nДоспехи\nГоловные уборы\nОчки\nЧасы\nБижутерия\nРасходные материалы", "Далее", "Назад");
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
		//буржуа TODO
		case 1300:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						SetPVarInt(playerid, "CmbMode", 0);
						ShowCmbWindow(playerid);
					}
					case 1:
					{
						new listitems[] = "Оружие\nДоспехи\nШапка\nОчки\nЧасы";
						ShowPlayerDialog(playerid, 1301, DIALOG_STYLE_LIST, "Буржуа", listitems, "Далее", "Закрыть");
					}
					case 2:
					{
						SetPVarInt(playerid, "CmbMode", 1);
						ShowCmbWindow(playerid);
					}
				}
			}
		}
		case 1301:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						if(PlayerInfo[playerid][WeaponMod] < 7)
						{
							SendClientMessage(playerid, COLOR_GREY, "Предмет должен быть уровня модификации +7 или выше.");
							return 1;
						}

						new desc[2048];
						desc = GetEquipDesc(PlayerInfo[playerid][WeaponSlotID], PlayerInfo[playerid][WeaponMod], PlayerInfo[playerid][WeaponStats]);
						
						new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][WeaponMod]);
						new sub_desc[512];
						format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
						strcat(desc, sub_desc);

						ShowPlayerDialog(playerid, 1302, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
					}
					case 1:
					{
						if(PlayerInfo[playerid][ArmorMod] < 7)
						{
							SendClientMessage(playerid, COLOR_GREY, "Предмет должен быть уровня модификации +7 или выше.");
							return 1;
						}

						new desc[2048];
						desc = GetEquipDesc(PlayerInfo[playerid][ArmorSlotID], PlayerInfo[playerid][ArmorMod], PlayerInfo[playerid][ArmorStats]);
						
						new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][ArmorMod]);
						new sub_desc[512];
						format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
						strcat(desc, sub_desc);

						ShowPlayerDialog(playerid, 1303, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
					}
					case 2:
					{
						if(PlayerInfo[playerid][HatMod] < 7)
						{
							SendClientMessage(playerid, COLOR_GREY, "Предмет должен быть уровня модификации +7 или выше.");
							return 1;
						}

						new desc[2048];
						desc = GetEquipDesc(PlayerInfo[playerid][HatSlotID], PlayerInfo[playerid][HatMod], PlayerInfo[playerid][HatStats]);
						
						new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][HatMod]);
						new sub_desc[512];
						format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
						strcat(desc, sub_desc);

						ShowPlayerDialog(playerid, 1304, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
					}
					case 3:
					{
						if(PlayerInfo[playerid][GlassesMod] < 7)
						{
							SendClientMessage(playerid, COLOR_GREY, "Предмет должен быть уровня модификации +7 или выше.");
							return 1;
						}

						new desc[2048];
						desc = GetEquipDesc(PlayerInfo[playerid][GlassesSlotID], PlayerInfo[playerid][GlassesMod], PlayerInfo[playerid][GlassesStats]);
						
						new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][GlassesMod]);
						new sub_desc[512];
						format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
						strcat(desc, sub_desc);

						ShowPlayerDialog(playerid, 1305, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
					}
					case 4:
					{
						if(PlayerInfo[playerid][WatchMod] < 7)
						{
							SendClientMessage(playerid, COLOR_GREY, "Предмет должен быть уровня модификации +7 или выше.");
							return 1;
						}

						new desc[2048];
						desc = GetEquipDesc(PlayerInfo[playerid][WatchSlotID], PlayerInfo[playerid][WatchMod], PlayerInfo[playerid][WatchStats]);
						
						new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][WatchMod]);
						new sub_desc[512];
						format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
						strcat(desc, sub_desc);

						ShowPlayerDialog(playerid, 1306, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
					}
				}
			}
			else 
				return 1;
		}
		case 1302:
		{
			if(response)
			{
				new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][WeaponMod]);
				if(!HasItem(playerid, 1034, req_noses))
				{
					SendClientMessage(playerid, COLOR_GREY, "Недостаточно красных носов.");
					return 1;
				}

				new slot = FindItem(playerid, 1034);
				DeleteItem(playerid, slot, req_noses);
				AddWeaponProps(playerid);
				UpdatePlayerStats(playerid);
				SendClientMessage(playerid, COLOR_GREEN, "Характеристики добавлены.");

				new desc[2048];
				desc = GetEquipDesc(PlayerInfo[playerid][WeaponSlotID], PlayerInfo[playerid][WeaponMod], PlayerInfo[playerid][WeaponStats]);
				
				new sub_desc[512];
				format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
				strcat(desc, sub_desc);

				ShowPlayerDialog(playerid, 1302, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
			}
			else
			{
				new listitems[] = "Оружие\nДоспехи\nШапка\nОчки\nЧасы";
				ShowPlayerDialog(playerid, 1301, DIALOG_STYLE_LIST, "Буржуа", listitems, "Далее", "Закрыть");
			}
		}
		case 1303:
		{
			if(response)
			{
				new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][ArmorMod]);
				if(!HasItem(playerid, 1034, req_noses))
				{
					SendClientMessage(playerid, COLOR_GREY, "Недостаточно красных носов.");
					return 1;
				}

				new slot = FindItem(playerid, 1034);
				DeleteItem(playerid, slot, req_noses);
				AddArmorProps(playerid);
				UpdatePlayerStats(playerid);
				SendClientMessage(playerid, COLOR_GREEN, "Характеристики добавлены.");

				new desc[2048];
				desc = GetEquipDesc(PlayerInfo[playerid][ArmorSlotID], PlayerInfo[playerid][ArmorMod], PlayerInfo[playerid][ArmorStats]);
				
				new sub_desc[512];
				format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
				strcat(desc, sub_desc);

				ShowPlayerDialog(playerid, 1303, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
			}
			else
			{
				new listitems[] = "Оружие\nДоспехи\nШапка\nОчки\nЧасы";
				ShowPlayerDialog(playerid, 1301, DIALOG_STYLE_LIST, "Буржуа", listitems, "Далее", "Закрыть");
			}
		}
		case 1304:
		{
			if(response)
			{
				new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][HatMod]);
				if(!HasItem(playerid, 1034, req_noses))
				{
					SendClientMessage(playerid, COLOR_GREY, "Недостаточно красных носов.");
					return 1;
				}

				new slot = FindItem(playerid, 1034);
				DeleteItem(playerid, slot, req_noses);
				AddHatProps(playerid);
				UpdatePlayerStats(playerid);
				SendClientMessage(playerid, COLOR_GREEN, "Характеристики добавлены.");

				new desc[2048];
				desc = GetEquipDesc(PlayerInfo[playerid][HatSlotID], PlayerInfo[playerid][HatMod], PlayerInfo[playerid][HatStats]);
				
				new sub_desc[512];
				format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
				strcat(desc, sub_desc);

				ShowPlayerDialog(playerid, 1304, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
			}
			else
			{
				new listitems[] = "Оружие\nДоспехи\nШапка\nОчки\nЧасы";
				ShowPlayerDialog(playerid, 1301, DIALOG_STYLE_LIST, "Буржуа", listitems, "Далее", "Закрыть");
			}
		}
		case 1305:
		{
			if(response)
			{
				new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][GlassesMod]);
				if(!HasItem(playerid, 1034, req_noses))
				{
					SendClientMessage(playerid, COLOR_GREY, "Недостаточно красных носов.");
					return 1;
				}

				new slot = FindItem(playerid, 1034);
				DeleteItem(playerid, slot, req_noses);
				AddGlassesProps(playerid);
				UpdatePlayerStats(playerid);
				SendClientMessage(playerid, COLOR_GREEN, "Характеристики добавлены.");

				new desc[2048];
				desc = GetEquipDesc(PlayerInfo[playerid][GlassesSlotID], PlayerInfo[playerid][GlassesMod], PlayerInfo[playerid][GlassesStats]);
				
				new sub_desc[512];
				format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
				strcat(desc, sub_desc);

				ShowPlayerDialog(playerid, 1305, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
			}
			else
			{
				new listitems[] = "Оружие\nДоспехи\nШапка\nОчки\nЧасы";
				ShowPlayerDialog(playerid, 1301, DIALOG_STYLE_LIST, "Буржуа", listitems, "Далее", "Закрыть");
			}
		}
		case 1306:
		{
			if(response)
			{
				new req_noses = GetMaxStatsByMod(PlayerInfo[playerid][WatchMod]);
				if(!HasItem(playerid, 1034, req_noses))
				{
					SendClientMessage(playerid, COLOR_GREY, "Недостаточно красных носов.");
					return 1;
				}

				new slot = FindItem(playerid, 1034);
				DeleteItem(playerid, slot, req_noses);
				AddWatchProps(playerid);
				UpdatePlayerStats(playerid);
				SendClientMessage(playerid, COLOR_GREEN, "Характеристики добавлены.");

				new desc[2048];
				desc = GetEquipDesc(PlayerInfo[playerid][WatchSlotID], PlayerInfo[playerid][WatchMod], PlayerInfo[playerid][WatchStats]);

				new sub_desc[512];
				format(sub_desc, sizeof(sub_desc), "\n\n{ffffff}Требуется носов: %d\nИмеется носов: %d", req_noses, GetItemsCount(playerid, 1034));
				strcat(desc, sub_desc);

				ShowPlayerDialog(playerid, 1306, DIALOG_STYLE_MSGBOX, "Буржуа", desc, "Добавить", "Назад");
			}
			else
			{
				new listitems[] = "Оружие\nДоспехи\nШапка\nОчки\nЧасы";
				ShowPlayerDialog(playerid, 1301, DIALOG_STYLE_LIST, "Буржуа", listitems, "Далее", "Закрыть");
			}
		}
    //особые действия
    case 1400:
    {
      if(response)
      {
        switch(listitem)
        {
          case 0:
          {
            SortInventory(playerid);
          }
          case 1:
          {
            SortInventory(playerid, true);
          }
          case 2:
          {
            SendClientMessage(playerid, COLOR_WHITE, "Режим выбора: укажите предметы для массовых действий");
            EnableInvSelectionMode(playerid);
          }
        }
      }
    }
    //массовое открытие кейсов
    case 1500:
    {
      if(response)
      {
        new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];

        switch(listitem)
        {
          case 0:
          {
            DeleteItem(playerid, SelectedSlot[playerid], 1);
			      OpenLockbox(playerid, itemid);
          }
          case 1:
          {
            new count = PlayerInventory[playerid][SelectedSlot[playerid]][Count];
            for(new i = 0; i < count; i++)
            {
              DeleteItem(playerid, SelectedSlot[playerid], 1);
			        OpenLockbox(playerid, itemid);
            }
          }
        }
      }
    }
    //командующий
    case 1600:
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
            ShowVoteStatus(playerid);
          }
          case 2:
          {
            VoteSignUp(playerid);
          }
          case 3:
          {
            ShowVoteList(playerid);
          }
        }
      }
    }
    case 1601:
    {
      if(response)
        ShowCommandoMenu(playerid);
    }
    case 1602:
    {
      if(response)
        TryVoteTo(playerid, listitem);
      else
        ShowCommandoMenu(playerid);
    }
    case 1603:
    {
      if(response)
      {
        new count = strval(inputtext);
        if(!HasItem(playerid, 1071, count))
        {
          SendClientMessage(playerid, COLOR_GREY, "Недостаточно бюллетеней для голосования");
          ShowVoteList(playerid);
          return 1;
        }

        DoVote(playerid, CandidateNameBuffer[playerid], count);
      }
      else
        ShowVoteList(playerid);
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

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == MpBtn[playerid])
	{
		new category = GetMarketCategoryByItem(MarketSellingItem[playerid][ID]);
		RegisterMarketItem(playerid, category);
	}
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid == ChrInfoClose[playerid])
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
		new mode = GetPVarInt(playerid, "CmbMode");
		if(mode == 0)
			CombineItems(playerid);
		else if(mode == 1)
			UpStage(playerid);
	}
	else if(playertextid == MpClose[playerid])
	{
		HideMarketSellWindow(playerid);
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
		MarketSellingItem[playerid][Stage] = PlayerInventory[playerid][SelectedSlot[playerid]][Stage];
		MarketSellingItem[playerid][Mod] = PlayerInventory[playerid][SelectedSlot[playerid]][Mod];
		for(new i = 0; i < MAX_STATS; i++)
			MarketSellingItem[playerid][Stats][i] = PlayerInventory[playerid][SelectedSlot[playerid]][Stats][i];
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
    if(IsInvSelectionModeEnabled(playerid)) return 0;
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
    if(IsInvSelectionModeEnabled(playerid)) return 0;
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
    if(IsInvSelectionModeEnabled(playerid)) return 0;
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
    if(IsInvSelectionModeEnabled(playerid)) return 0;
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
    if(IsInvSelectionModeEnabled(playerid)) return 0;
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
    if(IsInvSelectionModeEnabled(playerid)) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][RingSlot1ID], PlayerInfo[playerid][Ring1Stats]);
		PlayerInfo[playerid][RingSlot1ID] = -1;
		PlayerInfo[playerid][Ring1Stats] = STATS_CLEAR;
		UpdatePlayerStats(playerid);

		if(IsInventoryOpen[playerid])
			UpdateEquipSlots(playerid);
	}
	else if(playertextid == ChrInfRingSlot2[playerid])
	{
		if(PlayerInfo[playerid][RingSlot2ID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
    if(IsInvSelectionModeEnabled(playerid)) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][RingSlot2ID], PlayerInfo[playerid][Ring2Stats]);
		PlayerInfo[playerid][RingSlot2ID] = -1;
		PlayerInfo[playerid][Ring2Stats] = STATS_CLEAR;
		UpdatePlayerStats(playerid);

		if(IsInventoryOpen[playerid])
			UpdateEquipSlots(playerid);
	}
	else if(playertextid == ChrInfAmuletteSlot1[playerid])
	{
		if(PlayerInfo[playerid][AmuletteSlot1ID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
    if(IsInvSelectionModeEnabled(playerid)) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][AmuletteSlot1ID], PlayerInfo[playerid][Amulette1Stats]);
		PlayerInfo[playerid][AmuletteSlot1ID] = -1;
		PlayerInfo[playerid][Amulette1Stats] = STATS_CLEAR;
		UpdatePlayerStats(playerid);

		if(IsInventoryOpen[playerid])
			UpdateEquipSlots(playerid);
	}
	else if(playertextid == ChrInfAmuletteSlot2[playerid])
	{
		if(PlayerInfo[playerid][AmuletteSlot2ID] == -1) return 0;
		if(IsSlotsBlocked[playerid]) return 0;
    if(IsInvSelectionModeEnabled(playerid)) return 0;
		if(IsInventoryFull(playerid))
		{
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Ошибка", "Инвентарь полон.", "Закрыть", "");
			return 0;
		}

		AddEquip(playerid, PlayerInfo[playerid][AmuletteSlot2ID], PlayerInfo[playerid][Amulette2Stats]);
		PlayerInfo[playerid][AmuletteSlot2ID] = -1;
		PlayerInfo[playerid][Amulette2Stats] = STATS_CLEAR;
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
    if(IsInvSelectionModeEnabled(playerid)) return 0;

		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(itemid == -1)
			return 0;

		if(IsEquip(itemid))
		{
			new equip[BaseItem];
			equip = GetItem(itemid);
			if(PlayerInfo[playerid][Rank] < equip[MinRank])
			{
				new string[255];
				format(string, sizeof(string), "{ffffff}Ваш ранг не соответствует минимальному для этого предмета.\nМинимальный ранг - {%s}%s", 
					RateColors[equip[MinRank]-1], GetRankInterval(equip[MinRank])
				);
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Инвентарь", string, "Закрыть", "");
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

      ShowPlayerDialog(playerid, 1500, DIALOG_STYLE_LIST, "Инвентарь", "Открыть один\nОткрыть все", "Выбрать", "Закрыть");
		}
	}
	else if(playertextid == ChrInfButSort[playerid])
	{
		if(IsSlotsBlocked[playerid]) return 0;
    if(IsInvSelectionModeEnabled(playerid))
      DisableInvSelectionMode(playerid);

    ShowPlayerDialog(playerid, 1400, DIALOG_STYLE_LIST, "Инвентарь", "Сортировать всё\nСортировать текущую страницу\nРежим выбора", "Выбрать", "Закрыть");
	}
	else if(playertextid == ChrInfButInfo[playerid])
	{
		if(IsSlotsBlocked[playerid]) return 0;
    if(IsInvSelectionModeEnabled(playerid)) return 0;
		if(SelectedSlot[playerid] == -1)
			return 0;
		if(PlayerInventory[playerid][SelectedSlot[playerid]][ID] == -1)
			return 0;

		new itemid = PlayerInventory[playerid][SelectedSlot[playerid]][ID];
		if(IsEquip(itemid))
			ShowEquipInfo(playerid, SelectedSlot[playerid]);
		else
			ShowItemInfo(playerid, itemid);
	}
	else if(playertextid == ChrInfButDel[playerid])
	{
		if(IsSlotsBlocked[playerid]) return 0;

    new desc[255];
    if(IsInvSelectionModeEnabled(playerid))
    {
      new selected_count = GetInvSelectedItemsCount(playerid);
      if(IsPlayerBesideNPC(playerid))
      {
        format(desc, sizeof(desc), "{ffffff}Продать предметы [%d]?", selected_count);
        ShowPlayerDialog(playerid, 405, DIALOG_STYLE_MSGBOX, "Инвентарь", desc, "Далее", "Закрыть");
      }
      else
      {
        format(desc, sizeof(desc), "{ffffff}Выбросить/разобрать предметы [%d]?", selected_count);
        ShowPlayerDialog(playerid, 405, DIALOG_STYLE_MSGBOX, "Инвентарь", desc, "Далее", "Закрыть");
      }
    }
    else
    {
      if(SelectedSlot[playerid] == -1)
        return 0;
      if(PlayerInventory[playerid][SelectedSlot[playerid]][ID] == -1)
        return 0;

      new item[BaseItem];
      item = GetItem(PlayerInventory[playerid][SelectedSlot[playerid]][ID]);
      if(IsPlayerBesideNPC(playerid))
      {
        format(desc, sizeof(desc), "{ffffff}[{%s}%s{ffffff}] - продать?", GetGradeColor(item[Grade]), item[Name]);
        ShowPlayerDialog(playerid, 401, DIALOG_STYLE_MSGBOX, "Инвентарь", desc, "Далее", "Закрыть");
      }
      else if(IsModifiableEquip(item[ID]))
      {
        format(desc, sizeof(desc), "{ffffff}[{%s}%s{ffffff}] - разобрать?", GetGradeColor(item[Grade]), item[Name]);
        ShowPlayerDialog(playerid, 404, DIALOG_STYLE_MSGBOX, "Инвентарь", desc, "Далее", "Закрыть");
      }
      else
      {
        format(desc, sizeof(desc), "{ffffff}[{%s}%s{ffffff}] - выбросить?", GetGradeColor(item[Grade]), item[Name]);
        ShowPlayerDialog(playerid, 400, DIALOG_STYLE_MSGBOX, "Инвентарь", desc, "Далее", "Закрыть");
      }
    }
		return 1;
	}
	else if(playertextid == ChrInfButMod[playerid])
	{
    if(IsInvSelectionModeEnabled(playerid)) return 0;

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
				if(PlayerInventory[playerid][SelectedSlot[playerid]][Mod] >= MAX_MOD)
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
	else if(playertextid == UpgPotionSlot[playerid])
	{
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
		UpgradeItem(playerid, ModItemSlot[playerid], ModPotion[playerid]);
		UpdateModWindow(playerid);
	}
	else if(playertextid == UpgSafeBtn[playerid])
	{
		if(ModItemSlot[playerid] == -1) return 0;
		new def_count = GetDefCount(PlayerInventory[playerid][ModItemSlot[playerid]][Mod]+1);
		if(def_count > 0 && !HasItem(playerid, 1006, def_count))
			return ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "Недостаточно печатей.", "Закрыть", "");

		UpgradeItem(playerid, ModItemSlot[playerid], ModPotion[playerid], true);
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
				if(SelectedSlot[playerid] != -1 && !IsInvSelectionModeEnabled(playerid)) 
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

        if(IsInvSelectionModeEnabled(playerid))
        {
          PlayerInventorySelectionList[playerid][inv_slotid] = !PlayerInventorySelectionList[playerid][inv_slotid];
          SetSlotSelection(playerid, inv_slotid, PlayerInventorySelectionList[playerid][inv_slotid]);
        }
        else
        {
          SelectedSlot[playerid] = inv_slotid;
          SetSlotSelection(playerid, inv_slotid, true);
        }
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
	gettime(hour, minute, second);

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
	
	if(!CheckChance(5 + prop * 3))
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
	
	if(!CheckChance(5 + prop * 3))
		return;
	
	new Float:hp = GetPlayerMaxHP(playerid);
	GivePlayerHP(playerid, hp);
}

stock TryUseInvulProp(playerid)
{
	if(IsDeath[playerid]) return;
	if(FCNPC_IsValid(playerid) && FCNPC_IsDead(playerid)) return;
	if(GetPVarInt(playerid, "Invulnearable") > 0) return;

	new prop = GetPlayerPropValue(playerid, PROPERTY_INVUL);
	if(prop <= 0)
		return;
	
	if(!CheckChance(3 + prop * 3))
		return;
	
	SetPlayerInvulnearable(playerid, 2 * prop);
}

stock TryUseParadoxProp(playerid)
{
  if(IsDeath[playerid]) return;
	if(FCNPC_IsValid(playerid) && FCNPC_IsDead(playerid)) return;

	new prop = GetPlayerPropValue(playerid, PROPERTY_PARADOX);
	if(prop <= 0)
		return;
	
	if(!CheckChance(1 + prop))
		return;
	
	for(new i = 0; i < MAX_PLAYERS; i++)
  {
    if(!IsPlayerConnected(i) || i == playerid)
      continue;
    
    if(GetDistanceBetweenPlayers(playerid, i) > 5)
      continue;

    SetPlayerChatBubble(i, "Оглушение", 0x0033FFFF, 80.0, 1200);
    SetPlayerStun(i, 3 + prop);
  }
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
			SpecialAbilityEffectTime = 6;
			SpecialAbilityEffectTeam = team;
			ResetAllTeamTargets(team);

			SetPVarInt(playerid, "SpecialAbilityCooldown", 45);

			new string[255];
			format(string, sizeof(string), "{cc0000}[Патриарх] {ffffff}%s использует {cc0000}<Растерянность>", PlayerInfo[playerid][Name]);
			SendClientMessageToAll(COLOR_WHITE, string);
		}
		case HIERARCHY_ARCHONT:
		{
			//ядерная бомба
			new team = GetPlayerTourTeam(playerid);
			ExplodeNuclearBomb(team);
			SetPVarInt(playerid, "SpecialAbilityCooldown", 60);

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
			SpecialAbilityEffectTime = 7;
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
			SetPVarInt(playerid, "SpecialAbilityCooldown", 35);

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

    new stun_time = GetPVarInt(i, "Stun");
    if(stun_time > 0)
      continue;

		TogglePlayerControllableEx(i, 1);
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

  new stun_time = GetPVarInt(playerid, "Stun");
	if(stun_time > 0)
	{
		stun_time--;
		SetPVarInt(playerid, "Stun", stun_time);
	}

  new controllable = 1;
  if(stun_time > 0)
  {
    SetPlayerChatBubble(playerid, "Оглушение", 0x0033FFFF, 80.0, 1200);
    controllable = 0;
  }

  if(!FCNPC_IsValid(playerid))
    TogglePlayerControllableEx(playerid, controllable);

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
	IsBossHelpRequred = false;
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
	IsBossHelpRequred = false;

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

	AttackedBoss = -1;
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
	max_hp = floatadd(max_hp, floatmul(750.0, PlayerInfo[playerid][Rank] - 1));
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
		hp = floatmul(GetPlayerMaxHP(playerid), floatdiv(PlayerInfo[playerid][Regeneration], 100));
	else
	{
		new reg = PlayerInfo[playerid][Regeneration];
		if(HasItem(playerid, 1000, 1))
			reg += 2;

		hp = floatmul(GetPlayerMaxHP(playerid), floatdiv(reg, 100));
	}
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
	new tax = floatround(floatmul(money, 0.05));
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
    PvpInfo[i][Assists] = 0;
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
      SetPlayerScore(playerid, 0);
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

//TODO: make special formula
stock GetScoreDiff(rate1, rate2, bool:is_killer)
{
	new diff = rate1 - rate2;
  if(diff > 6000)
		diff = floatround(floatmul(diff, 0.95));
  else if(diff > 5000)
		diff = floatround(floatmul(diff, 0.9));
  else if(diff > 4000)
		diff = floatround(floatmul(diff, 0.85));
  else if(diff > 3500)
		diff = floatround(floatmul(diff, 0.8));
  else if(diff > 3000)
		diff = floatround(floatmul(diff, 0.75));
	else if(diff > 2500)
		diff = floatround(floatmul(diff, 0.7));
	else if(diff > 2000)
		diff = floatround(floatmul(diff, 0.65));
	else if(diff > 1500)
		diff = floatround(floatmul(diff, 0.6));
	else if(diff > 1000)
		diff = floatround(floatmul(diff, 0.5));
	else if(diff > 500)
		diff = floatround(floatmul(diff, 0.4));
	else if(diff > 0)
		diff = floatround(floatmul(diff, 0.25));
	else
		diff = floatround(floatabs(floatmul(MAX_RATE + 1 - floatabs(diff), 0.007)));

	if(is_killer)
		diff += 30;
	else
		diff = floatround(floatmul(diff, 0.75));
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

stock SetPlayerStun(playerid, time)
{
	new stun_time = GetPVarInt(playerid, "Stun");
	if(stun_time < 0)
		stun_time = 0;

	SetPVarInt(playerid, "Stun", stun_time + time);
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

  new stun_time = GetPVarInt(id, "Stun");
  if(stun_time > 0)
  {
    if(FCNPC_IsMoving(id))
      FCNPC_Stop(id);

    if(FCNPC_IsShooting(id) || FCNPC_IsAiming(id))
		  FCNPC_StopAim(id);

    return 1;
  }

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
    if(target != -1 && target != INVALID_PLAYER_ID && FCNPC_IsShooting(id) && GetPlayerHPPercent(target) < 30)
      return 1;

		MoveAround(id, true);
		return 1;
	}

	//If NPC has a lot of aimers - run away
	if(GetAimingPlayersCount(id) > 3 && GetPlayerHPPercent(id) < 30 && !FCNPC_IsMoving(id))
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

	//If current target's HP > 50%, trying to find common target
	new common_finded = -1;
	if(fix_target == -1 && GetPlayerHPPercent(target) > 50 && GetAimingPlayersCount(target) < 2)
		common_finded = TryFindCommonTarget(id, target);

	//If there are targets with less HP beside player - change target
	if(common_finded == -1 && fix_target == -1 && GetPlayerHPPercent(target) > 30)
	{
		new potential_target = FindPlayerTarget(id, true);
		if(potential_target != -1 && potential_target != target)
		{
      new Float:p_dist = GetDistanceBetweenPlayers(id, potential_target);
			if(p_dist < 10.0 && GetPlayerHPPercent(potential_target) < 20)
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
	if(dist <= 10.0)
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

  new stun_time = GetPVarInt(id, "Stun");
  if(stun_time > 0)
  {
    if(FCNPC_IsMoving(id))
      FCNPC_Stop(id);

    if(FCNPC_IsShooting(id) || FCNPC_IsAiming(id))
		  FCNPC_StopAim(id);

    return;
  }

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

  new stun_time = GetPVarInt(id, "Stun");
  if(stun_time > 0)
  {
    if(FCNPC_IsMoving(id))
      FCNPC_Stop(id);

    if(FCNPC_IsShooting(id) || FCNPC_IsAiming(id))
		  FCNPC_StopAim(id);

    return;
  }

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
				reward[ItemID] = 1036;
				reward[ItemsCount] = 20;
				money = 14000;
			}
			case 2:
			{
				reward[ItemID] = 1036;
				reward[ItemsCount] = 17;
				money = 13000;
			}
			case 3:
			{
				reward[ItemID] = 1036;
				reward[ItemsCount] = 15;
				money = 12000;
			}
			case 4..5:
			{
				reward[ItemID] = 1036;
				reward[ItemsCount] = 12;
				money = 10500;
			}
			case 6..8:
			{
				reward[ItemID] = 1035;
				reward[ItemsCount] = 20;
				money = 9000;
			}
			case 9..12:
			{
				reward[ItemID] = 1035;
				reward[ItemsCount] = 16;
				money = 8000;
			}
			case 13..16:
			{
				reward[ItemID] = 1035;
				reward[ItemsCount] = 12;
				money = 7000;
			}
			default:
			{
				reward[ItemID] = 1035;
				reward[ItemsCount] = 8;
				money = 5000;
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
				PendingItem(name, reward[ItemID], string, STATS_CLEAR, reward[ItemsCount]);
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
					PendingItem(name, reward[ItemID], string, STATS_CLEAR, reward[ItemsCount]);
					continue;
				}
				if(IsEquip(reward[ItemID]))
					AddEquip(id, reward[ItemID], STATS_CLEAR);
				else
					AddItem(id, reward[ItemID], reward[ItemsCount]);
			}
			if(reward[Money] > 0)
				AddPlayerMoney(id, reward[Money]);
		}
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
		if(PlayerInventory[playerid][i][ID] == 1065)
		{
			money += PlayerInventory[playerid][i][Count] * (item[Price] / 7);
			items++;
			DeleteItem(playerid, i, PlayerInventory[playerid][i][Count]);
			continue;
		}
		if(item[Grade] == GRADE_N && IsModifiableEquip(itemid) && PlayerInventory[playerid][i][Mod] == 0 && PlayerInventory[playerid][i][Stage] == 0)
		{
			money += item[Price] / 7;
			items++;
			DeleteItem(playerid, i);
			continue;
		}
	}
	
	new tax = floatround(floatmul(money, 0.05));
	money -= tax;
	PlayerInfo[playerid][Cash] += money;
	GivePlayerCash(playerid, money);
	GivePatriarchMoney(tax);

	new string[255];
	format(string, sizeof(string), "Продано предметов: %d", items);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "Получено: %s$", FormatMoney(money));
	SendClientMessage(playerid, COLOR_GREEN, string);
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

stock UpdateTempItems()
{
	new query[255] = "UPDATE `inventories` SET `ItemID` = '-1', `Count` = '0' WHERE `ItemID` >= '1000' AND `ItemID` <= '1004' OR `ItemID` = '1067'";
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		for(new j = 0; j < MAX_SLOTS; j++)
		{
			if(PlayerInventory[i][j][ID] >= 1000 && PlayerInventory[i][j][ID] <= 1004)
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
			new stage = 0;
			new owner[255];
			new mod;
      new stats[MAX_STATS];
			new string[255];

			cache_get_value_name_int(i, "ItemID", itemid);
			cache_get_value_name_int(i, "ItemCount", count);
			cache_get_value_name_int(i, "Stage", stage);
			cache_get_value_name(i, "Owner", owner);
			cache_get_value_name_int(i, "ItemMod", mod);
      cache_get_value_name(i, "ItemStats", string);
			sscanf(string, "a<i>[7]", stats);

			cache_unset_active();

			PendingItem(owner, itemid, "Срок регистрации предмета истек", stats, count, mod, stage);

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

stock GetModString(mod)
{
	new string[8] = "";
	if(mod <= 0)
		return string;
	
	format(string, sizeof(string), "+%d ", mod);
	return string;
}

stock GetEquipDesc(id, mod, stats[])
{
	new eq_item[BaseItem];
	eq_item = GetItem(id);

	new desc[2048];
	format(desc, sizeof(desc), "{%s}[%s%s]\n", GetGradeColor(eq_item[Grade]), GetModString(mod), eq_item[Name]);

	new props_str[1024] = " {00FF00}Особые характеристики:\n";
	new props_count = 0;
	for(new i = 0; i < MAX_STATS; i++)
	{
		if(stats[i] == -1)
			break;

		new prop_str[255];
		prop_str = GetSpecialStatString(stats[i]);
		new color[16] = "FFFFFF";
		if(mod >= 7)
		{
			switch(eq_item[Grade])
			{
				case GRADE_N: color = "FFCC00";
				case GRADE_B: if(i > 0) color = "FFCC00";
				case GRADE_C: if(i > 1) color = "FFCC00";
				case GRADE_R: if(i > 2) color = "FFCC00";
				case GRADE_S,GRADE_F: if(i > 3) color = "FFCC00";
				default: color = "FFFFFF";
			}
		}
		
		new str[255];
		format(str, sizeof(str), " {%s}%s\n", color, prop_str);
		strcat(props_str, str);
		props_count++;
	}

	if(props_count > 0)
		strcat(desc, props_str);

	return desc;
}

stock GetMarketItemDesc(listitem, category)
{
	new item[MarketItem];
	item = GetMarketItem(listitem, category);

	new desc[2048];
	desc = GetEquipDesc(item[ID], item[Mod], item[Stats]);
	return desc;
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
  cache_get_value_name_int(id, "ItemMod", item[Mod]);
	cache_get_value_name_int(id, "Stage", item[Stage]);
	cache_get_value_name(id, "Owner", string);
	sscanf(string, "s[255]", item[Owner]);
	cache_get_value_name(id, "ItemStats", string);
	sscanf(string, "a<i>[7]", item[Stats]);

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
  cache_get_value_name_int(0, "ItemMod", item[Mod]);
	cache_get_value_name_int(0, "Stage", item[Stage]);
	cache_get_value_name(0, "Owner", string);
	sscanf(string, "s[255]", item[Owner]);
	cache_get_value_name(0, "ItemStats", string);
	sscanf(string, "a<i>[7]", item[Stats]);

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

	format(query, sizeof(query), "INSERT INTO `marketplace`(`ID`, `Owner`, `ItemID`, `Category`, `ItemCount`, `ItemMod`, `ItemStats`, `Stage`, `Price`, `Time`) VALUES ('%d','%s','%d','%d','%d','%d','%s','%d','%d','%d')",
		id, item[Owner], item[ID], category, item[Count], item[Mod], ArrayToString(item[Stats]), item[Stage], item[Price], time
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
	format(query, sizeof(query), "INSERT INTO `marketplace`(`ID`, `Owner`, `ItemID`, `Category`, `ItemCount`, `ItemMod`, `ItemStats`, `Stage`, `Price`, `Time`) VALUES ('%d','%s','%d','%d','%d','%d','%s','%d','%d','%d')",
		MarketSellingItem[playerid][LotID], MarketSellingItem[playerid][Owner], MarketSellingItem[playerid][ID], category, MarketSellingItem[playerid][Count],
		MarketSellingItem[playerid][Mod], ArrayToString(MarketSellingItem[playerid][Stats], MAX_STATS), MarketSellingItem[playerid][Stage], MarketSellingItem[playerid][Price], MarketSellingItem[playerid][rTime]
	);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	new slotid = GetPVarInt(playerid, "MarketSellingItemInvSlot");
	DeleteItem(playerid, slotid, MarketSellingItem[playerid][Count]);

  new item[BaseItem];
  item = GetItem(MarketSellingItem[playerid][ID]);

  new buf[255];
  if(category == MARKET_CATEGORY_MATERIAL)
    format(buf, sizeof(buf), "{%s}[%s]{ffffff}[x%d]", GetGradeColor(item[Grade]), item[Name], MarketSellingItem[playerid][Count]);
  else
  {
    if(category == MARKET_CATEGORY_ACCESSORY)
      format(buf, sizeof(buf), "{%s}[%s]\t{ffffff}[{%s}%s{ffffff}]", GetGradeColor(item[Grade]), item[Name], GetColorByRank(item[MinRank]), GetRankInterval(item[MinRank]));
    else if(MarketSellingItem[playerid][Mod] == 0)
      format(buf, sizeof(buf), "{%s}[S%d][%s]\t{ffffff}[{%s}%s{ffffff}]", GetGradeColor(item[Grade]), MarketSellingItem[playerid][Stage], item[Name], GetColorByRank(item[MinRank]), GetRankInterval(item[MinRank]));
    else
      format(buf, sizeof(buf), "{%s}[S%d][+%d %s]\t{ffffff}[{%s}%s{ffffff}]", GetGradeColor(item[Grade]), MarketSellingItem[playerid][Stage], MarketSellingItem[playerid][Mod], item[Name], GetColorByRank(item[MinRank]), GetRankInterval(item[MinRank]));
  }

  new item_str[255];
  format(item_str, sizeof(item_str), "[Рынок]: Зарегистрирован новый предмет: %s", buf);
	SendClientMessageToAll(0xFFCC66FF, item_str);

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
	GivePlayerCash(playerid, -amount);

	amount -= comission;

	if(IsEquip(item[ID]))
		AddEquip(playerid, item[ID], item[Stats], item[Stage], item[Mod]);
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
		GivePlayerCash(owner_id, amount);
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
	PendingItem(item[Owner], item[ID], "Предмет возвращен", item[Stats], item[Count], item[Mod], item[Stage]);

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
			if(category == MARKET_CATEGORY_ACCESSORY)
			{
				format(buf, sizeof(buf), "\n{%s}[%s]\t{ffffff}[{%s}%s{ffffff}] {00CC00}%s$\t{ffffff}%s\t{ffffff}%d",
					GetGradeColor(item[Grade]), item[Name], GetColorByRank(item[MinRank]), GetRankInterval(item[MinRank]), FormatMoney(m_item[Price]), m_item[Owner], m_item[rTime]
				);
			}
			else if(m_item[Mod] == 0)
			{
				format(buf, sizeof(buf), "\n{%s}[S%d][%s]\t{ffffff}[{%s}%s{ffffff}] {00CC00}%s$\t{ffffff}%s\t{ffffff}%d",
					GetGradeColor(item[Grade]), m_item[Stage], item[Name], GetColorByRank(item[MinRank]), GetRankInterval(item[MinRank]), FormatMoney(m_item[Price]), m_item[Owner], m_item[rTime]
				);
			}
			else
			{
				format(buf, sizeof(buf), "\n{%s}[S%d][+%d %s]\t{ffffff}[{%s}%s{ffffff}] {00CC00}%s$\t{ffffff}%s\t{ffffff}%d",
					GetGradeColor(item[Grade]), m_item[Stage], m_item[Mod], item[Name], GetColorByRank(item[MinRank]), GetRankInterval(item[MinRank]), FormatMoney(m_item[Price]), m_item[Owner], m_item[rTime]
				);
			}
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
		case 1: money = 1900;
		case 2: money = 1740; 
		case 3: money = 1580;
		case 4..5: money = 1080;
		case 6..8: money = 840;
		case 9..12: money = 560;
		case 13..16: money = 480;
		case 17..20: money = 340;
	}

	money = money * floatround(floatpower(rank + tour, 2));
	reward[Money] = money;

  if(tour == 5)
  {
    switch(place)
    {
      case 1: { reward[ItemID] = 1069; reward[ItemsCount] = 3; }
      case 2: { reward[ItemID] = 1069; reward[ItemsCount] = 2; }
      case 3: { reward[ItemID] = 1069; reward[ItemsCount] = 1; }
    }
  }

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
					PendingItem(PvpInfo[i][Name], reward[ItemID], "Награда за тур", STATS_CLEAR, reward[ItemsCount]);
					continue;
				}
				if(IsEquip(reward[ItemID]))
					AddEquip(id, reward[ItemID], STATS_CLEAR);
				else
					AddItem(id, reward[ItemID], reward[ItemsCount]);
			}
			if(reward[Money] > 0)
				AddPlayerMoney(id, reward[Money]);
		}
		else
		{
			if(reward[ItemID] != -1 && reward[ItemsCount] > 0)
				PendingItem(PvpInfo[i][Name], reward[ItemID], "Награда за тур", STATS_CLEAR, reward[ItemsCount]);
			if(reward[Money] > 0)
				GivePlayerMoneyOffline(PvpInfo[i][Name], reward[Money]);
		}
	}
}

stock AddPlayerMoney(playerid, money)
{
	new tax = floatround(floatmul(money, 0.05));
	money -= tax;

	new string[255];
	format(string, sizeof(string), "Получено %s$.", FormatMoney(money));
	SendClientMessage(playerid, 0x00CC00FF, string);

	PlayerInfo[playerid][Cash] += money;
	GivePlayerCash(playerid, money);
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
	new stage;
	new mod;
	new p_id = -1;
	cache_get_value_name_int(num, "ItemID", reward[ItemID]);
	cache_get_value_name_int(num, "Count", reward[ItemsCount]);
	cache_get_value_name_int(num, "PendingID", p_id);
	cache_get_value_name_int(num, "Stage", stage);
	cache_get_value_name_int(num, "ItemMod", mod);

	new string[255];
	new stats[MAX_STATS];
	cache_get_value_name(num, "ItemStats", string);
	sscanf(string, "a<i>[7]", stats);

	cache_delete(q_result);

	if(reward[ItemID] != -1 && IsInventoryFull(playerid))
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Почта", "Инвентарь полон.", "Закрыть", "");
		return;
	}

	if(reward[ItemID] != -1)
	{
		if(IsEquip(reward[ItemID]))
			AddEquip(playerid, reward[ItemID], stats, stage, mod);
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
    if(is_bns_mode > 0 && Tournament[Tour] == 5)
    {
      p_count = ejected_count;
      ejected_count = 0;
    }

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
		
		format(query, sizeof(query), "INSERT INTO `tournament_tab`(`ID`, `Name`, `Score`, `Kills`, `Deaths`, `Assists`, `Owner`, `RateDiff`) VALUES ('%d','%s','%d','%d','%d','%d','%s','%d')",
			PlayerInfo[id][ID], PlayerInfo[id][Name], PvpInfo[i][Score], PvpInfo[i][Kills], PvpInfo[i][Deaths], PvpInfo[i][Assists], PlayerInfo[id][Owner], PvpInfo[i][RateDiff]
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
				case 1: rate = 15;
				case 2: rate = 13;
				case 3: rate = 12;
				case 4: rate = 10;
				case 5: rate = 7;
				case 6: rate = 6;
				case 7: rate = 5;
				case 8: rate = 4;
				case 9: rate = 3;
				case 10: rate = 1;
				case 11: rate = -1;
				case 12: rate = -2;
				case 13: rate = -4;
				case 14: rate = -5;
				case 15: rate = -7;
				case 16: rate = -9;
				case 17: rate = -11;
				case 18: rate = -13;
				case 19: rate = -14;
				case 20: rate = -15;
			}
		}
		case 2:
		{
			switch(pos)
			{
				case 1: rate = 18;
				case 2: rate = 17;
				case 3: rate = 15;
				case 4: rate = 13;
				case 5: rate = 11;
				case 6: rate = 8;
				case 7: rate = 6;
				case 8: rate = 3;
				case 9: rate = 1;
				case 10: rate = -1;
				case 11: rate = -2;
				case 12: rate = -5;
				case 13: rate = -7;
				case 14: rate = -9;
				case 15: rate = -11;
				case 16: rate = -14;
			}
		}
		case 3:
		{
			switch(pos)
			{
				case 1: rate = 24;
				case 2: rate = 22;
				case 3: rate = 20;
				case 4: rate = 17;
				case 5: rate = 14;
				case 6: rate = 10;
				case 7: rate = 6;
				case 8: rate = 1;
				case 9: rate = -2;
				case 10: rate = -4;
				case 11: rate = -7;
				case 12: rate = -12;
			}
		}
		case 4:
		{
			switch(pos)
			{
				case 1: rate = 28;
				case 2: rate = 26;
				case 3: rate = 23;
				case 4: rate = 19;
				case 5: rate = 13;
				case 6: rate = 4;
				case 7: rate = -3;
				case 8: rate = -7;
			}
		}
		case 5:
		{
			switch(pos)
			{
				case 1: rate = 35;
				case 2: rate = 30;
				case 3: rate = 20;
				case 4: rate = 5;
			}
		}
	}

	new up_rate_diff = up_mid_rate - PlayerInfo[playerid][Rate];
	new down_rate_diff = down_mid_rate - PlayerInfo[playerid][Rate];
	if(down_rate_diff > 0)
		rate += down_rate_diff / 25;
	if(up_rate_diff < 0)
		rate += up_rate_diff / 30;

	if(rate > 50) rate = 50;
	if(rate < -70) rate = -70;

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

stock GenerateLoot(playerid, lockboxid)
{
	new chance = random(1001);
	new loot_variants_count = 0;
	new loot_variants[MAX_LOOT_VARIANTS][LootInfo];
	new loot[LootInfo];
	loot[ItemID] = -1;

	new rank = 1;
	if(playerid != INVALID_PLAYER_ID)
		rank = PlayerInfo[playerid][Rank];

	switch(lockboxid)
	{
		case 1041:
		{
			switch(rank)
			{
				case 1: loot[ItemID] = 1;
				case 2: loot[ItemID] = 3;
				case 3: loot[ItemID] = 5;
				case 4: loot[ItemID] = 8;
				case 5: loot[ItemID] = 11;
				case 6: loot[ItemID] = 14;
				case 7: loot[ItemID] = 18;
				case 8: loot[ItemID] = 22;
				default: loot[ItemID] = 26;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1042:
		{
			switch(rank)
			{
				case 1: loot[ItemID] = 2;
				case 2: loot[ItemID] = 4;
				case 3: loot[ItemID] = 6;
				case 4: loot[ItemID] = 9;
				case 5: loot[ItemID] = 12;
				case 6: loot[ItemID] = 15;
				case 7: loot[ItemID] = 19;
				case 8: loot[ItemID] = 23;
				default: loot[ItemID] = 27;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1043:
		{
			switch(rank)
			{
				case 1..3: loot[ItemID] = 7;
				case 4: loot[ItemID] = 10;
				case 5: loot[ItemID] = 13;
				case 6: loot[ItemID] = 16;
				case 7: loot[ItemID] = 20;
				case 8: loot[ItemID] = 24;
				default: loot[ItemID] = 28;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1044:
		{
			switch(rank)
			{
				case 1: loot[ItemID] = 36;
				case 2: loot[ItemID] = 38;
				case 3: loot[ItemID] = 40;
				case 4: loot[ItemID] = 43;
				case 5: loot[ItemID] = 46;
				case 6: loot[ItemID] = 49;
				case 7: loot[ItemID] = 53;
				case 8: loot[ItemID] = 57;
				default: loot[ItemID] = 61;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1045:
		{
			switch(rank)
			{
				case 1: loot[ItemID] = 37;
				case 2: loot[ItemID] = 39;
				case 3: loot[ItemID] = 41;
				case 4: loot[ItemID] = 44;
				case 5: loot[ItemID] = 47;
				case 6: loot[ItemID] = 50;
				case 7: loot[ItemID] = 54;
				case 8: loot[ItemID] = 58;
				default: loot[ItemID] = 62;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1046:
		{
			switch(rank)
			{
				case 1..3: loot[ItemID] = 42;
				case 4: loot[ItemID] = 45;
				case 5: loot[ItemID] = 48;
				case 6: loot[ItemID] = 51;
				case 7: loot[ItemID] = 55;
				case 8: loot[ItemID] = 59;
				default: loot[ItemID] = 63;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1047:
		{
			switch(rank)
			{
				case 1: loot[ItemID] = 71;
				case 2: loot[ItemID] = 73;
				case 3: loot[ItemID] = 75;
				case 4: loot[ItemID] = 78;
				case 5: loot[ItemID] = 81;
				case 6: loot[ItemID] = 84;
				case 7: loot[ItemID] = 88;
				case 8: loot[ItemID] = 92;
				default: loot[ItemID] = 96;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1048:
		{
			switch(rank)
			{
				case 1: loot[ItemID] = 72;
				case 2: loot[ItemID] = 74;
				case 3: loot[ItemID] = 76;
				case 4: loot[ItemID] = 79;
				case 5: loot[ItemID] = 82;
				case 6: loot[ItemID] = 85;
				case 7: loot[ItemID] = 89;
				case 8: loot[ItemID] = 93;
				default: loot[ItemID] = 97;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1049:
		{
			switch(rank)
			{
				case 1..3: loot[ItemID] = 77;
				case 4: loot[ItemID] = 80;
				case 5: loot[ItemID] = 83;
				case 6: loot[ItemID] = 86;
				case 7: loot[ItemID] = 90;
				case 8: loot[ItemID] = 94;
				default: loot[ItemID] = 98;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1050:
		{
			switch(rank)
			{
				case 2: loot[ItemID] = 129;
				case 3: loot[ItemID] = 130;
				case 4: loot[ItemID] = 131;
				case 5: loot[ItemID] = 132;
				case 6: loot[ItemID] = 133;
				case 7: loot[ItemID] = 134;
				case 8: loot[ItemID] = 135;
				case 9: loot[ItemID] = 136;
				case 10: loot[ItemID] = 137;
				case 11: loot[ItemID] = 138;
				case 12: loot[ItemID] = 139;
				case 13: loot[ItemID] = 140;
				case 14: loot[ItemID] = 141;
				default: loot[ItemID] = 128;
			}
			loot[Count] = 1;
			return loot;
		}
		case 1051:
		{
			switch(rank)
			{
				case 2: loot[ItemID] = 106;
				case 3: loot[ItemID] = 107;
				case 4: loot[ItemID] = 108;
				case 5: loot[ItemID] = 109;
				case 6: loot[ItemID] = 110;
				case 7: loot[ItemID] = 111;
				case 8: loot[ItemID] = 112;
				case 9: loot[ItemID] = 113;
				case 10: loot[ItemID] = 114;
				case 11: loot[ItemID] = 115;
				case 12: loot[ItemID] = 116;
				case 13: loot[ItemID] = 117;
				case 14: loot[ItemID] = 118;
				default: loot[ItemID] = 105;
			}
			loot[Count] = 1;
			return loot;
		}
		default:
		{
			new query[255];
			format(query, sizeof(query), "SELECT * FROM `lootboxes` WHERE `BoxID` = '%d'", lockboxid);
			new Cache:result = mysql_query(sql_handle, query);
					
			new rows = 0;
			cache_get_row_count(rows);
			if(rows <= 0)
			{
				cache_delete(result);
				return loot;
			}

			result = cache_save();
			cache_unset_active();

			for(new i = 0; i < rows; i++)
			{
				new tmp_chance;
				new tmp_loot[LootInfo];
				cache_set_active(result);
				cache_get_value_name_int(i, "Chance", tmp_chance);
				cache_get_value_name_int(i, "ItemID", tmp_loot[ItemID]);
				cache_get_value_name_int(i, "ItemsCount", tmp_loot[Count]);
				cache_unset_active();
				if(chance > tmp_chance) continue;

				loot_variants[loot_variants_count] = tmp_loot;
				loot_variants_count++;
			}
			
			cache_delete(result);

			if(loot_variants_count == 0)
				return loot;

			new idx = random(loot_variants_count);
			new result_loot[LootInfo];
			result_loot = loot_variants[idx];
			return result_loot;
		}
	}
}

stock OpenLockbox(playerid, lockboxid)
{
	new loot[LootInfo];
	loot = GenerateLoot(playerid, lockboxid);

	if(loot[ItemID] == -1)
		return;

  if(lockboxid == 1068 && loot[ItemID] == 1057)
  {
    switch(PlayerInfo[playerid][Rank])
    {
      case 3..5: loot[ItemID] = 1058;
      case 6..7: loot[ItemID] = 1059;
      case 8..9: loot[ItemID] = 1060;
      case 10..11: loot[ItemID] = 1061;
      case 12..15: loot[ItemID] = 1062;
    }
  }

	if(IsEquip(loot[ItemID]))
		AddEquip(playerid, loot[ItemID], STATS_CLEAR);
	else
		AddItem(playerid, loot[ItemID], loot[Count]);

	new item[BaseItem];
	item = GetItem(loot[ItemID]);
	new string[255];
	format(string, sizeof(string), "Получено: {%s}[%s] {ffffff}x%d.", 
		GetGradeColor(item[Grade]), item[Name], loot[Count]
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
				TogglePlayerControllableEx(id, 0);
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
  else
  {
    new Float:min_dist = 1000.0;
    for(new i = 0; i < MAX_RELIABLE_TARGETS; i++)
    {
      if(nearest_targets[i] == -1)
			  break;

      new Float:n_dist = GetDistanceBetweenPlayers(nearest_targets[i], npcid);
      if(n_dist < min_dist)
      {
        targetid = nearest_targets[i];
        min_dist = n_dist;
      }
    }
  }

	if(!by_minhp)
		return targetid;

  new Float:min_hp = 150001;
	for(new i = 0; i < MAX_RELIABLE_TARGETS; i++)
	{
		if(nearest_targets[i] == -1)
			break;
		
		new Float:hp = FCNPC_GetHealth(nearest_targets[i]);
		if(hp < min_hp)
    {
			targetid = nearest_targets[i];
      min_hp = hp;
    }
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
		
		if(GetDistanceBetweenPlayers(playerid, part_id) > 20.0)
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
	IsBossHelpRequred = false;
	print("Boss destroyed.");
}

stock GetAvailableDungeonsList(playerid)
{
	new listitems[2048] = "";

	new query[255];
	new Cache:q_result;
	new itemid = 0;
	new string[64];

	for(new i = 0; i < MAX_DUNGEONS; i++)
		AvailableDungeons[playerid][i] = -1;

	for(new i = 0; i < MAX_DUNGEON_TYPES; i++)
	{
    new cur_id = DungeonsKeysID[i];
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
    new mob_type = 1;
    new mobid = -1;
    if(dungeon[MobsTypesCount] == 0)
      mobid = random(MAX_RANK) + 1;
    else
    {
		  mob_type = random(dungeon[MobsTypesCount]);
      mobid = dungeon[Mobs][mob_type];
    }

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
    new boss_type = 1;
    new bossid = -1;
    if(dungeon[BossesTypesCount] == 0)
      bossid = random(9);
    else
    {
      boss_type = random(dungeon[BossesTypesCount]);
      bossid = dungeon[Bosses][boss_type];
    }
		
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
	new loot[LootInfo];
	loot = GenerateLoot(playerid, 12000 + dungeonid);

	if(loot[ItemID] == -1) return;

	new item[BaseItem];
	item = GetItem(loot[ItemID]);

	new string[255];
	if(IsEquip(loot[ItemID]))
	{
		AddEquip(playerid, loot[ItemID], STATS_CLEAR);
		if(item[Grade] >= GRADE_C)
		{
			format(string, sizeof(string), "{%s}%s {ffffff}приобрел {%s}[%s]{ffffff}.", 
				GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name], GetGradeColor(item[Grade]), item[Name]
			);
			SendClientMessageToAll(0xFFFFFFFF, string);
		}
	}
	else
		AddItem(playerid, loot[ItemID], loot[Count]);

	format(string, sizeof(string), "Получено: {%s}[%s] {ffffff}x%d.", 
		GetGradeColor(item[Grade]), item[Name], loot[Count]
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
		case 10: name = "Mob_Mafia";
		case 11: name = "Mob_Don";
		case 12: name = "Mob_ShazokHenchman";
		case 13: name = "Mob_Zap";
		case 14: name = "Mob_ShazokFantom";
		default: name = "Mob";
	}

	return name;
}

stock ShowKillStreakMessage(playerid, count)
{
  new msg[128];
  switch(count)
  {
    case 3: format(msg, sizeof(msg), "{%s}%s {ffffff}раскладывает!", GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name]);
    case 7: format(msg, sizeof(msg), "{%s}%s {ffffff}обретает могущество Шажка!", GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name]);
    case 10: format(msg, sizeof(msg), "{%s}%s {ffffff}сильнее Буржуев!", GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name]);
    case 15: format(msg, sizeof(msg), "{%s}%s {ffffff}ЦАРЬ!!!", GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name]);
    default: return;
  }

  SendClientMessageToAll(COLOR_WHITE, msg);
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
		if(bossid == AttackedBoss && IsBossHelpRequred)
			format(bossinfo, sizeof(bossinfo), "\n{%s}%s\t{FFCC00}Идет сбор", GetGradeColor(boss[Grade]), boss[Name]);
		else if(bossid == AttackedBoss && !IsBossHelpRequred)
			format(bossinfo, sizeof(bossinfo), "\n{%s}%s\t{FFCC00}Идет атака", GetGradeColor(boss[Grade]), boss[Name]);
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
		case 1: resp_time = 6;
		case 2: resp_time = 9;
		case 3: resp_time = 12;
		case 4: resp_time = 15;
		case 5: resp_time = 18;
		case 6: resp_time = 21;
		case 7: resp_time = 24;
		case 8: resp_time = 27;
    case 9: resp_time = 30;
    case 10: resp_time = 15;
    case 11: resp_time = 18;
    case 12: resp_time = 21;
    case 13: resp_time = 24;
    case 14: resp_time = 27;
    case 15: resp_time = 30;
    case 16: resp_time = 33;
    case 17: resp_time = 37;
		default: resp_time = 3;
	}

	new query[255];
	format(query, sizeof(query), "UPDATE `bosses` SET `RespawnTime` = '%d' WHERE `ID` = '%d' LIMIT 1", resp_time, bossid);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);
}

stock GetMedianPlayersRank()
{
  new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` <> 'Admin' AND `IsWatcher`=0 LIMIT %d", MAX_PARTICIPANTS);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
		print("GetMedianPlayersRank() error.");
		cache_delete(q_result);
		return 1;
	}

  new rank_sum = 0;

	q_result = cache_save();
	cache_unset_active();

	for(new i = 0; i < row_count; i++)
	{
		new name[255];
		new rank;

		cache_set_active(q_result);
		cache_get_value_name(i, "Name", name);
		cache_get_value_name_int(i, "Rank", rank);
		cache_unset_active();

		rank_sum += rank;
	}

	cache_delete(q_result);

  new med_rank = rank_sum / row_count;
  return med_rank;
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

    new price = item[Price];

    if(itemid == 1068)
    {
      new med_rank = GetMedianPlayersRank();
      if(med_rank < 1)
        med_rank = 1;

      price = item[Price] * med_rank;
    }

		format(iteminfo, sizeof(iteminfo), "\n{%s}%s\t{66CC00}%s$", GetGradeColor(item[Grade]), item[Name], FormatMoney(price));
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
  new player_idx = GetPvpIndex(playerid);

	new kills_diff = PvpInfo[killer_idx][Kills] - PvpInfo[killer_idx][Deaths];
	if(kills_diff > 1)
		base_score = floatround(floatmul(base_score, floatpower(0.97, kills_diff)));

  if(PvpInfo[player_idx][KillStreak] > 1)
  {
    new streak_score = floatround(floatmul(25, floatpower(PvpInfo[player_idx][KillStreak], 2)));
    base_score += streak_score;
  }

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
    PvpInfo[damagers_ids[i]][Assists]++;
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

	new loot_mult = 2;
	
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
		DungeonLootPickups[npcid][i] = CreatePickup(GetLootPickupID(loot[ItemID]), 1, x + random(6), y + random(6), z, 1001 + playerid);
	}
}

stock RollWalkerLoot(walkerid, killerid)
{
	if(killerid == -1 || killerid == INVALID_PLAYER_ID) return;

	new loot_mult = 2;

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
		WalkerLootPickups[walkerid][i] = CreatePickup(GetLootPickupID(loot[ItemID]), 1, x + random(6), y + random(6), z, 0);
	}
}

stock RollBossLoot()
{
	if(AttackedBoss == -1 || !FCNPC_IsValid(BossNPC)) return;
	new loot_mult = 2;

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
		BossLootPickups[i] = CreatePickup(GetLootPickupID(loot[ItemID]), 4, x + random(10), y + random(10), z, 0);
	}
}

stock RollWalkerLootItem(rank, ownerid)
{
	new loot[LootInfo];
	loot = GenerateLoot(ownerid, 10000 + rank);
	loot[OwnerID] = ownerid;
	return loot;
}

stock RollBossLootItem(bossid)
{
	new loot[LootInfo];
	loot = GenerateLoot(INVALID_PLAYER_ID, 11000 + bossid + 1);
	loot[OwnerID] = -1;
	return loot;
}

stock GetLootPickupID(itemid)
{
  new pickupid = 19054;

  new item[BaseItem];
  item = GetItem(itemid);

  switch(item[Grade])
  {
    case GRADE_C: pickupid = 19057;
    case GRADE_R: pickupid = 19058;
    case GRADE_S: pickupid = 19055;
    case GRADE_F: pickupid = 19056;
  }

  return pickupid;
}

stock GetEquipByRank(rank, type, grade)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `items` WHERE `MinRank` = '%d' AND `Type` = '%d' AND `Grade` = '%d' LIMIT 1", rank, type, grade);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count == 0)
	{
		print("Cannot get equip by rank.");
		return -1;
	}

	new id;
	cache_get_value_name_int(num, "ID", id);

	cache_delete(q_result);

	return id;
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
	new Float:percents;
	hp = GetPlayerHP(playerid);
	max_hp = GetPlayerMaxHP(playerid);
	percents = floatmul(floatdiv(hp, max_hp), 100);

	new string[64];
	format(string, sizeof(string), "%d/%d", floatround(hp), floatround(max_hp));
	PlayerTextDrawSetStringRus(playerid, PlayerHPBarNumbers[playerid], string);
	SetPlayerProgressBarValue(playerid, PlayerHPBar[playerid], percents);
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
	UpdateHUDRank(playerid);
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
		case 35: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 78 : 131;
		case 36,37: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 22 : 13;
		case 38,39: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 6 : 41;
		case 40..42: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 167 : 205;
		case 43..45: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 70 : 219;
		case 46..48: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 310 : 309;
		case 49..52: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 147 : 141;
		case 53..56: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 127 : 150;
		case 57..60: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 126 : 93;
		case 61..64: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 294 : 214;
		case 65: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 46 : 224;
		case 66: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 111 : 298;
		case 67: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 164 : 169;
		case 68: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 84 : 12;
		case 69: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 83 : 216;
		default: PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? DEFAULT_SKIN_MALE : DEFAULT_SKIN_FEMALE;
	}

  if(PlayerInfo[playerid][Status] == HIERARCHY_LEADER)
    PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 165 : 141;
  else if(PlayerInfo[playerid][Status] != HIERARCHY_NONE)
    PlayerInfo[playerid][Skin] = PlayerInfo[playerid][Sex] == 0 ? 113 : 91;

	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
}

stock GetWeaponIDByItemID(itemid)
{
	/*new weaponid;
	switch(itemid)
	{
		case 3,4,212..214: weaponid = 24;
		case 5..7: weaponid = 28;
		case 8..10,31,215..217,234,243: weaponid = 32;
		case 11..13,32,218..220,235,244: weaponid = 29;
		case 14..17,33,221..223,236,238,245: weaponid = 31;
		case 18..21,224..226,239: weaponid = 25;
		case 22..25,34,227..229,237,240,246: weaponid = 27;
		case 26..29,230..232,241: weaponid = 26;
		default: weaponid = 22;
	}*/

	return 31;
}

stock UpdatePlayerWeapon(playerid)
{
	if(IsBoss[playerid] || IsWalker[playerid] || IsDungeonBoss[playerid] || IsDungeonMob[playerid])
	{
		FCNPC_SetWeapon(playerid, PlayerInfo[playerid][WeaponSlotID]);
		FCNPC_SetAmmo(playerid, 999999);
		return;
	}

	if(PlayerInfo[playerid][IsWatcher] != 0)
	{
		ResetPlayerWeapons(playerid);
		return;
	}

	new weaponid = GetWeaponIDByItemID(PlayerInfo[playerid][WeaponSlotID]);

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
	new default_weapon_damage[2];
	default_weapon_damage = GetWeaponBaseDamage(PlayerInfo[playerid][WeaponSlotID], PlayerInfo[playerid][WeaponStage]);

  new weapon_damage[2];
	weapon_damage[0] = GetEquipModifiedValue(default_weapon_damage[0], PlayerInfo[playerid][WeaponMod]);
	weapon_damage[1] = GetEquipModifiedValue(default_weapon_damage[1], PlayerInfo[playerid][WeaponMod]);

  new default_glasses_damage = GetGlassesBaseDamage(PlayerInfo[playerid][GlassesSlotID], PlayerInfo[playerid][GlassesStage]);

  new glasses_damage = GetEquipModifiedValue(default_glasses_damage, PlayerInfo[playerid][GlassesMod]);

	new damage_stat = GetPlayerStatValue(playerid, STAT_DAMAGE);

	PlayerInfo[playerid][DamageMin] = default_weapon_damage[0] + default_glasses_damage + damage_stat;
	PlayerInfo[playerid][DamageMax] = default_weapon_damage[1] + default_glasses_damage + damage_stat;
	
	new default_armor_defense = GetArmorBaseDefense(PlayerInfo[playerid][ArmorSlotID], PlayerInfo[playerid][ArmorStage]);
  new armor_defense = GetEquipModifiedValue(default_armor_defense, PlayerInfo[playerid][ArmorMod]);
	if(armor_defense == 0)
		armor_defense = DEFAULT_DEFENSE;

	new default_hat_defense = GetArmorBaseDefense(PlayerInfo[playerid][HatSlotID], PlayerInfo[playerid][HatStage]);
  new hat_defense = GetEquipModifiedValue(default_hat_defense, PlayerInfo[playerid][HatMod]);
	
	new watch_defense = 0;
  new default_watch_defense = 0;
	if(PlayerInfo[playerid][WatchSlotID] != -1)
	{
		default_watch_defense = GetArmorBaseDefense(PlayerInfo[playerid][WatchSlotID], PlayerInfo[playerid][WatchStage]);
		watch_defense = GetEquipModifiedValue(default_watch_defense, PlayerInfo[playerid][WatchMod]);
	}

	PlayerInfo[playerid][Defense] = default_armor_defense + default_hat_defense + default_watch_defense;
	PlayerInfo[playerid][Accuracy] = DEFAULT_ACCURACY + GetPlayerPropValue(playerid, PROPERTY_ACCURACY) + PlayerInfo[playerid][Rank] * 5 + GetPlayerStatValue(playerid, STAT_ACCURACY);
	PlayerInfo[playerid][Dodge] = DEFAULT_DODGE + GetPlayerPropValue(playerid, PROPERTY_DODGE) + PlayerInfo[playerid][Rank] * 5 + GetPlayerStatValue(playerid, STAT_DODGE);
	PlayerInfo[playerid][Crit] = DEFAULT_CRIT + GetPlayerPropValue(playerid, PROPERTY_CRIT) + PlayerInfo[playerid][Rank] * 2 + GetPlayerStatValue(playerid, STAT_CRIT_CHANCE);
	PlayerInfo[playerid][Vamp] = GetPlayerPropValue(playerid, PROPERTY_VAMP) + GetPlayerStatValue(playerid, STAT_VAMP);
	PlayerInfo[playerid][CritMult] = DEFAULT_CRIT_MULT + GetPlayerStatValue(playerid, STAT_CRIT_MULT);
	PlayerInfo[playerid][CritMultReduction] = DEFAULT_CRIT_MULT_REDUCTION + GetPlayerStatValue(playerid, STAT_CRIT_MULT_REDUCTION);
	PlayerInfo[playerid][CritReduction] = DEFAULT_CRIT_REDUCTION + GetPlayerStatValue(playerid, STAT_CRIT_REDUCTION);
	PlayerInfo[playerid][DamageReflection] = DEFAULT_DAMAGE_REFLECTION + GetPlayerStatValue(playerid, STAT_DAMAGE_REFLECTION);
	PlayerInfo[playerid][Regeneration] = DEFAULT_REGENERATION + GetPlayerStatValue(playerid, STAT_REGENERATION);

	new damage_multiplier = 100 + GetPlayerPropValue(playerid, PROPERTY_DAMAGE) + GetPlayerStatValue(playerid, STAT_DAMAGE_PERCENTAGE);
	new defense_multiplier = 100 + GetPlayerPropValue(playerid, PROPERTY_DEFENSE) + GetPlayerStatValue(playerid, STAT_DEFENSE_PERCENTAGE);
	new hp_multiplier = 100 + GetPlayerPropValue(playerid, PROPERTY_HP) + GetPlayerStatValue(playerid, STAT_HP_PERCENTAGE);

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
			defense_multiplier += 30;
		}
		case HIERARCHY_SUPPORT:
		{
			damage_multiplier += 20;
			defense_multiplier += 20;
			hp_multiplier += 15;
		}
	}

	PlayerInfo[playerid][DamageMin] = ((PlayerInfo[playerid][DamageMin] * damage_multiplier) / 100) + weapon_damage[0] - default_weapon_damage[0] + glasses_damage - default_glasses_damage;
	PlayerInfo[playerid][DamageMax] = ((PlayerInfo[playerid][DamageMax] * damage_multiplier) / 100) + weapon_damage[1] - default_weapon_damage[1] + glasses_damage - default_glasses_damage;
	PlayerInfo[playerid][Defense] = ((PlayerInfo[playerid][Defense] * defense_multiplier) / 100) + armor_defense - default_armor_defense + hat_defense - default_hat_defense + watch_defense - default_watch_defense;

	UpdatePlayerMaxHP(playerid);
	new Float:new_max_hp = floatmul(MaxHP[playerid], floatdiv(hp_multiplier, 100));
	SetPlayerMaxHP(playerid, new_max_hp, true);

	if(IsInventoryOpen[playerid] && !FCNPC_IsValid(playerid))
		UpdatePlayerStatsVisual(playerid);
}

stock GetPlayerPropValue(playerid, prop)
{
	new value = 0;

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

	if(prop == PROPERTY_DAMAGE && HasItem(playerid, 1001, 1))
		value += 5;
	if(prop == PROPERTY_DEFENSE && HasItem(playerid, 1002, 1))
		value += 5;
	if(prop == PROPERTY_HEAL && HasItem(playerid, 1003, 1))
		value += 1;
	if(prop == PROPERTY_INVUL && HasItem(playerid, 1004, 1))
		value += 1;
	
	return value;
}

stock GetPlayerStatValue(playerid, stat)
{
	new value = 0;

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `stats_info` WHERE `StatEnum` = '%d'", stat);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count;
	cache_get_row_count(count);
	if(count <= 0)
		return value;

	new current_stat;
	new current_stat_value;

	for(new i = 0; i < count; i++)
	{
		cache_get_value_name_int(i, "Stat", current_stat);
		cache_get_value_name_int(i, "Value", current_stat_value);

		for(new j = 0; j < MAX_STATS; j++)
		{
			if(PlayerInfo[playerid][WeaponStats][j] == current_stat) value += current_stat_value;
			if(PlayerInfo[playerid][ArmorStats][j] == current_stat) value += current_stat_value;
			if(PlayerInfo[playerid][HatStats][j] == current_stat) value += current_stat_value;
			if(PlayerInfo[playerid][GlassesStats][j] == current_stat) value += current_stat_value;
			if(PlayerInfo[playerid][WatchStats][j] == current_stat) value += current_stat_value;
			if(PlayerInfo[playerid][Ring1Stats][j] == current_stat) value += current_stat_value;
			if(PlayerInfo[playerid][Ring2Stats][j] == current_stat) value += current_stat_value;
			if(PlayerInfo[playerid][Amulette1Stats][j] == current_stat) value += current_stat_value;
			if(PlayerInfo[playerid][Amulette2Stats][j] == current_stat) value += current_stat_value;
		}
	}

	cache_delete(q_result);

	return value;
}

stock UndressEquip(playerid, type)
{
	switch(type)
	{
		case ITEMTYPE_WEAPON:
		{
			if(PlayerInfo[playerid][WeaponSlotID] == DEFAULT_WEAPON_ID) return;
			AddEquip(playerid, PlayerInfo[playerid][WeaponSlotID], PlayerInfo[playerid][WeaponStats], PlayerInfo[playerid][WeaponStage], PlayerInfo[playerid][WeaponMod]);
			PlayerInfo[playerid][WeaponSlotID] = 0;
			PlayerInfo[playerid][WeaponMod] = 0;
			PlayerInfo[playerid][WeaponStage] = 0;
			PlayerInfo[playerid][WeaponStats] = STATS_CLEAR;
			UpdatePlayerWeapon(playerid);
		}
		case ITEMTYPE_ARMOR:
		{
			if(PlayerInfo[playerid][ArmorSlotID] == DEFAULT_ARMOR_ID) return;
			AddEquip(playerid, PlayerInfo[playerid][ArmorSlotID], PlayerInfo[playerid][ArmorStats], PlayerInfo[playerid][ArmorStage], PlayerInfo[playerid][ArmorMod]);
			PlayerInfo[playerid][ArmorSlotID] = DEFAULT_ARMOR_ID;
			PlayerInfo[playerid][ArmorMod] = 0;
			PlayerInfo[playerid][ArmorStage] = 0;
			PlayerInfo[playerid][ArmorStats] = STATS_CLEAR;
			UpdatePlayerSkin(playerid);
		}
		case ITEMTYPE_HAT:
		{
			if(PlayerInfo[playerid][HatSlotID] == DEFAULT_HAT_ID) return;
			AddEquip(playerid, PlayerInfo[playerid][HatSlotID], PlayerInfo[playerid][HatStats], PlayerInfo[playerid][HatStage], PlayerInfo[playerid][HatMod]);
			PlayerInfo[playerid][HatSlotID] = DEFAULT_HAT_ID;
			PlayerInfo[playerid][HatMod] = 0;
			PlayerInfo[playerid][HatStage] = 0;
			PlayerInfo[playerid][HatStats] = STATS_CLEAR;
			UpdatePlayerHat(playerid);
		}
		case ITEMTYPE_GLASSES:
		{
			if(PlayerInfo[playerid][GlassesSlotID] == -1) return;
			AddEquip(playerid, PlayerInfo[playerid][GlassesSlotID], PlayerInfo[playerid][GlassesStats], PlayerInfo[playerid][GlassesStage], PlayerInfo[playerid][GlassesMod]);
			PlayerInfo[playerid][GlassesSlotID] = -1;
			PlayerInfo[playerid][GlassesMod] = 0;
			PlayerInfo[playerid][GlassesStage] = 0;
			PlayerInfo[playerid][GlassesStats] = STATS_CLEAR;
			UpdatePlayerGlasses(playerid);
		}
		case ITEMTYPE_WATCH:
		{
			if(PlayerInfo[playerid][WatchSlotID] == -1) return;
			AddEquip(playerid, PlayerInfo[playerid][WatchSlotID], PlayerInfo[playerid][WatchStats], PlayerInfo[playerid][WatchStage], PlayerInfo[playerid][WatchMod]);
			PlayerInfo[playerid][WatchSlotID] = -1;
			PlayerInfo[playerid][WatchMod] = 0;
			PlayerInfo[playerid][WatchStage] = 0;
			PlayerInfo[playerid][WatchStats] = STATS_CLEAR;
			UpdatePlayerWatch(playerid);
		}
		case ITEMTYPE_RING:
		{
			if(PlayerInfo[playerid][RingSlot1ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][RingSlot1ID], PlayerInfo[playerid][Ring1Stats]);
				PlayerInfo[playerid][RingSlot1ID] = -1;
				PlayerInfo[playerid][Ring1Stats] = STATS_CLEAR;
			}
			else if(PlayerInfo[playerid][RingSlot2ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][RingSlot2ID], PlayerInfo[playerid][Ring2Stats]);
				PlayerInfo[playerid][RingSlot2ID] = -1;
				PlayerInfo[playerid][Ring2Stats] = STATS_CLEAR;
			}
			else return;
		}
		case ITEMTYPE_AMULETTE:
		{
			if(PlayerInfo[playerid][AmuletteSlot1ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][AmuletteSlot1ID], PlayerInfo[playerid][Amulette1Stats]);
				PlayerInfo[playerid][AmuletteSlot1ID] = -1;
				PlayerInfo[playerid][Amulette1Stats] = STATS_CLEAR;
			}
			else if(PlayerInfo[playerid][AmuletteSlot2ID] != -1)
			{
				AddEquip(playerid, PlayerInfo[playerid][AmuletteSlot2ID], PlayerInfo[playerid][Amulette2Stats]);
				PlayerInfo[playerid][AmuletteSlot2ID] = -1;
				PlayerInfo[playerid][Amulette2Stats] = STATS_CLEAR;
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

	new mod;
	new stage;
	new stats[MAX_STATS];

	mod = PlayerInventory[playerid][slot][Mod];
	stage = PlayerInventory[playerid][slot][Stage];
	for(new i = 0; i < MAX_STATS; i++)
		stats[i] = PlayerInventory[playerid][slot][Stats][i];

	DeleteItem(playerid, slot);

	switch(type)
	{
		case ITEMTYPE_WEAPON:
		{
			if(PlayerInfo[playerid][WeaponSlotID] != DEFAULT_WEAPON_ID)
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
			}
			PlayerInfo[playerid][WeaponSlotID] = itemid;
			PlayerInfo[playerid][WeaponMod] = mod;
			PlayerInfo[playerid][WeaponStage] = stage;
			PlayerInfo[playerid][WeaponStats] = stats;
			UpdatePlayerWeapon(playerid);
		}
		case ITEMTYPE_ARMOR:
		{
			if(PlayerInfo[playerid][ArmorSlotID] != DEFAULT_ARMOR_ID)
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
			}
			PlayerInfo[playerid][ArmorSlotID] = itemid;
			PlayerInfo[playerid][ArmorMod] = mod;
			PlayerInfo[playerid][ArmorStage] = stage;
			PlayerInfo[playerid][ArmorStats] = stats;
			UpdatePlayerSkin(playerid);
		}
		case ITEMTYPE_HAT:
		{
			if(PlayerInfo[playerid][HatSlotID] != DEFAULT_HAT_ID)
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
			}
			PlayerInfo[playerid][HatSlotID] = itemid;
			PlayerInfo[playerid][HatMod] = mod;
			PlayerInfo[playerid][HatStage] = stage;
			PlayerInfo[playerid][HatStats] = stats;
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
			PlayerInfo[playerid][GlassesStage] = stage;
			PlayerInfo[playerid][GlassesStats] = stats;
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
			PlayerInfo[playerid][WatchStage] = stage;
			PlayerInfo[playerid][WatchStats] = stats;
			UpdatePlayerWatch(playerid);
		}
		case ITEMTYPE_RING:
		{
			if(PlayerInfo[playerid][RingSlot1ID] == -1)
			{
				PlayerInfo[playerid][RingSlot1ID] = itemid;
				PlayerInfo[playerid][Ring1Stats] = stats;
			}
			else if(PlayerInfo[playerid][RingSlot2ID] == -1)
			{
				PlayerInfo[playerid][RingSlot2ID] = itemid;
				PlayerInfo[playerid][Ring2Stats] = stats;
			}
			else
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
				PlayerInfo[playerid][RingSlot1ID] = itemid;
				PlayerInfo[playerid][Ring1Stats] = stats;
			}
		}
		case ITEMTYPE_AMULETTE:
		{
			if(PlayerInfo[playerid][AmuletteSlot1ID] == -1)
			{
				PlayerInfo[playerid][AmuletteSlot1ID] = itemid;
				PlayerInfo[playerid][Amulette1Stats] = stats;
			}
			else if(PlayerInfo[playerid][AmuletteSlot2ID] == -1)
			{
				PlayerInfo[playerid][AmuletteSlot2ID] = itemid;
				PlayerInfo[playerid][Amulette2Stats] = stats;
			}
			else
			{
				if(IsInventoryFull(playerid)) return;
				UndressEquip(playerid, type);
				PlayerInfo[playerid][AmuletteSlot1ID] = itemid;
				PlayerInfo[playerid][Amulette1Stats] = stats;
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

	if(PlayerInfo[playerid][WeaponSlotID] == DEFAULT_WEAPON_ID)
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

	if(PlayerInfo[playerid][ArmorSlotID] == DEFAULT_ARMOR_ID)
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
	
	if(PlayerInfo[playerid][HatSlotID] == DEFAULT_HAT_ID)
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

stock SortInventory(playerid, bool:current_page = false)
{
	if(!IsInventoryOpen[playerid]) return;

	IsSlotsBlocked[playerid] = true;
	SendClientMessage(playerid, COLOR_WHITE, "Идет сортировка инвентаря...");

	new tmpitem1[BaseItem];
	new tmpitem2[BaseItem];

  new max_slots = MAX_SLOTS;
  if(current_page)
    max_slots = MAX_PAGE_SLOTS;

	for(new i = 0; i < max_slots; i++)
	{
		for(new j = max_slots-1; j > i; j--)
		{
      new slotid = j;
      new prev_slotid = j - 1;
      if(current_page)
      {
        slotid = GetSlotIdByPage(playerid, j);
        prev_slotid = GetSlotIdByPage(playerid, j-1);
      }

			if(IsInvSlotEmpty(playerid, slotid) && IsInvSlotEmpty(playerid, prev_slotid)) continue;
			if(IsInvSlotEmpty(playerid, slotid)) continue;
			if(IsInvSlotEmpty(playerid, prev_slotid))
			{
				SwapInventoryItems(playerid, slotid, prev_slotid);
				continue;
			}

			tmpitem1 = GetItem(PlayerInventory[playerid][slotid][ID]);
			tmpitem2 = GetItem(PlayerInventory[playerid][prev_slotid][ID]);

      new value_1 = (100000 * (MAX_ITEM_TYPES + 1 - tmpitem1[Type])) + (1000 * tmpitem1[MinRank]) + (100 * tmpitem1[Grade]) + tmpitem1[ID] + tmpitem1[Mod];
      new value_2 = (100000 * (MAX_ITEM_TYPES + 1 - tmpitem2[Type])) + (1000 * tmpitem2[MinRank]) + (100 * tmpitem2[Grade]) + tmpitem2[ID] + tmpitem2[Mod];
			if(value_1 > value_2)
				SwapInventoryItems(playerid, slotid, prev_slotid);
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

		new bool:selection = inv_slot == SelectedSlot[playerid] || (IsInvSelectionModeEnabled(playerid) && PlayerInventorySelectionList[playerid][inv_slot]);
    SetSlotSelection(playerid, inv_slot, selection);

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
	format(query, sizeof(query), "UPDATE `inventories` SET `ItemID` = '%d', `Count` = '%d', `Stage` = '%d', `SlotMod` = '%d', `SlotStats` = '%s' WHERE `PlayerName` = '%s' AND `SlotID` = '%d' LIMIT 1", 
		PlayerInventory[playerid][slot][ID], PlayerInventory[playerid][slot][Count], PlayerInventory[playerid][slot][Stage], PlayerInventory[playerid][slot][Mod], ArrayToString(PlayerInventory[playerid][slot][Stats], MAX_STATS), name, slot
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
	format(query, sizeof(query), "INSERT INTO `pendings`(`PendingID`, `PlayerName`, `ItemID`, `Count`, `ItemMod`, `ItemStats`, `Stage`, `Text`) VALUES ('%d','%s','%d','%d','%d','%s','%d','%s')",
		p_id, name, -1, 0, 0, "-1 -1 -1 -1 -1 -1 -1", 0, text
	);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	new id = GetPlayerID(name);
	if(id != -1 && IsPlayerConnected(id) && !FCNPC_IsValid(id))
		UpdatePlayerPost(id);
}

stock PendingItem(name[], id, text[], stats[], count = 1, mod = 0, stage = 0)
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
	format(query, sizeof(query), "INSERT INTO `pendings`(`PendingID`, `PlayerName`, `ItemID`, `Count`, `ItemMod`, `ItemStats`, `Stage`, `Text`) VALUES ('%d','%s','%d','%d','%d','%s','%d','%s')",
		p_id, name, id, count, mod, ArrayToString(stats, MAX_STATS), stage, text
	);
	new Cache:q_result = mysql_query(sql_handle, query);
	cache_delete(q_result);

	new playerid = GetPlayerID(name);
	if(playerid != -1 && IsPlayerConnected(playerid) && !FCNPC_IsValid(playerid))
		UpdatePlayerPost(playerid);
}

stock AddEquip(playerid, id, stats[], stage = 0, mod = 0)
{
	if(IsInventoryFull(playerid))
		return false;
	
	new slot = GetInvEmptySlotID(playerid);
	PlayerInventory[playerid][slot][ID] = id;
	PlayerInventory[playerid][slot][Stage] = stage;
	PlayerInventory[playerid][slot][Mod] = mod;
	PlayerInventory[playerid][slot][Count] = 1;

	new bool:is_clear = true;
	for(new i = 0; i < MAX_STATS; i++)
	{
		if(stats[i] != STATS_CLEAR[i])
		{
			is_clear = false;
			break;
		}
	}

	if(is_clear)
	{
		new n_stats[MAX_STATS];
		n_stats = GenerateStaticStats(id);

		for(new i = 0; i < MAX_STATS; i++)
			PlayerInventory[playerid][slot][Stats][i] = n_stats[i];
	}
	else
	{
		for(new i = 0; i < MAX_STATS; i++)
			PlayerInventory[playerid][slot][Stats][i] = stats[i];
	}

	SaveInventorySlot(playerid, slot);

	if(IsInventoryOpen[playerid])
		UpdateSlot(playerid, slot);

	return true;
}

stock DisassembleEquip(playerid, slotid)
{
	if(slotid == -1) return false;

	if(!IsInventoryFull(playerid))
	{
		new item[BaseItem];
		item = GetItem(PlayerInventory[playerid][slotid][ID]);

		new chance;
		switch(item[Grade])
		{
			case GRADE_B: chance = 50;
			case GRADE_C: chance = 60;
			case GRADE_R: chance = 70;
			case GRADE_S: chance = 80;
      case GRADE_F: chance = 90;
			default: chance = 40;
		}

		new string[255];
		new bool:success = CheckChance(chance);
		if(success)
		{
			new count = item[MinRank];
			if(PlayerInventory[playerid][slotid][Mod] >= 4)
				count += (PlayerInventory[playerid][slotid][Mod] * PlayerInventory[playerid][slotid][Mod]) / 4;

			new itemid = 1008 + item[Grade] - 1;
			if(item[Grade] == GRADE_F)
				itemid = 1070;

			AddItem(playerid, itemid, count);

			format(string, sizeof(string), "Получено: {%s}[Цирковая эссенция] {ffffff}x%d.", 
				GetGradeColor(item[Grade]), count
			);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
		else
			SendClientMessage(playerid, COLOR_GREY, "Не удалось разобрать предмет.");
	}
	
	for(new i = 0; i < MAX_STATS; i++)
		PlayerInventory[playerid][slotid][Stats][i] = -1;

	PlayerInventory[playerid][slotid][ID] = -1;
	PlayerInventory[playerid][slotid][Count] = 0;
	PlayerInventory[playerid][slotid][Stage] = 0;
	PlayerInventory[playerid][slotid][Mod] = 0;

	if(IsInventoryOpen[playerid])
		UpdateSlot(playerid, slotid);

	SaveInventorySlot(playerid, slotid);
}

stock DeleteItem(playerid, slotid, count = 1)
{
	if(slotid == -1) return false;

	PlayerInventory[playerid][slotid][Count] -= count;
	if(PlayerInventory[playerid][slotid][Count] <= 0)
	{
		for(new i = 0; i < MAX_STATS; i++)
			PlayerInventory[playerid][slotid][Stats][i] = -1;

		PlayerInventory[playerid][slotid][ID] = -1;
		PlayerInventory[playerid][slotid][Count] = 0;
		PlayerInventory[playerid][slotid][Stage] = 0;
		PlayerInventory[playerid][slotid][Mod] = 0;
	}

	if(IsInventoryOpen[playerid])
		UpdateSlot(playerid, slotid);

	SaveInventorySlot(playerid, slotid);
	return true;
}

stock GenerateStat(type)
{
	new chance = random(101);
	new stats_variants_count = 0;
	new stats_variants[MAX_STAT_VARIANTS];
	new stat = -1;

	new query[255];
	format(query, sizeof(query), "SELECT * FROM `stats_info` WHERE `StatType` = '%d'", type);
	new Cache:result = mysql_query(sql_handle, query);
			
	new rows = 0;
	cache_get_row_count(rows);
	if(rows <= 0)
	{
		cache_delete(result);
		print("GenerateStat() error.");
		return stat;
	}

	result = cache_save();
	cache_unset_active();

	for(new i = 0; i < rows; i++)
	{
		new tmp_chance;
		new tmp_stat;
		cache_set_active(result);
		cache_get_value_name_int(i, "Chance", tmp_chance);
		cache_get_value_name_int(i, "Stat", tmp_stat);
		cache_unset_active();
		if(chance > tmp_chance) continue;

		stats_variants[stats_variants_count] = tmp_stat;
		stats_variants_count++;
	}
	
	cache_delete(result);

	if(stats_variants_count == 0)
		return stat;

	new idx = random(stats_variants_count);
	new result_stat;
	result_stat = stats_variants[idx];
	return result_stat;
}

stock GenerateStaticStats(id)
{
	new stats[MAX_STATS];
	stats = STATS_CLEAR;
	
	new item[BaseItem];
	item = GetItem(id);

	new stats_count;
	stats_count = GetMaxStatsByGrade(item[Grade]);

	for(new i = 0; i < stats_count; i++)
	{
		new stat = GenerateStat(item[Type]);
		stats[i] = stat;
	}
	
	return stats;
}

stock GetMaxStatsByGrade(grade)
{
	new count;
	switch(grade)
	{
		case GRADE_B: count = 1;
		case GRADE_C: count = 2;
		case GRADE_R: count = 3;
		case GRADE_S, GRADE_F: count = 4;
		default: count = 0;
	}

	return count;
}

stock GetMaxStatsByMod(mod)
{
	new count;
	switch(mod)
	{
		case 7..9: count = 1;
		case 10..12: count = 2;
		case 13: count = 3;
		default: count = 0;
	}

	return count;
}

//TEMP
stock AddWeaponProps(playerid)
{
	new mod = PlayerInfo[playerid][WeaponMod];
	new item[BaseItem];
	item = GetItem(PlayerInfo[playerid][WeaponSlotID]);
	new grade = item[Grade];
	new default_stats_count = GetMaxStatsByGrade(grade);

	for(new i = default_stats_count; i < MAX_STATS; i++)
		PlayerInfo[playerid][WeaponStats][i] = -1;

	new new_stats_count = 1 + random(GetMaxStatsByMod(mod));
	for(new i = default_stats_count; i < default_stats_count + new_stats_count; i++)
		PlayerInfo[playerid][WeaponStats][i] = GenerateStat(item[Type]);
}

stock AddArmorProps(playerid)
{
	new mod = PlayerInfo[playerid][ArmorMod];
	new item[BaseItem];
	item = GetItem(PlayerInfo[playerid][ArmorSlotID]);
	new grade = item[Grade];
	new default_stats_count = GetMaxStatsByGrade(grade);

	for(new i = default_stats_count; i < MAX_STATS; i++)
		PlayerInfo[playerid][ArmorStats][i] = -1;

	new new_stats_count = 1 + random(GetMaxStatsByMod(mod));
	for(new i = default_stats_count; i < default_stats_count + new_stats_count; i++)
		PlayerInfo[playerid][ArmorStats][i] = GenerateStat(item[Type]);
}

stock AddHatProps(playerid)
{
	new mod = PlayerInfo[playerid][HatMod];
	new item[BaseItem];
	item = GetItem(PlayerInfo[playerid][HatSlotID]);
	new grade = item[Grade];
	new default_stats_count = GetMaxStatsByGrade(grade);

	for(new i = default_stats_count; i < MAX_STATS; i++)
		PlayerInfo[playerid][HatStats][i] = -1;

	new new_stats_count = 1 + random(GetMaxStatsByMod(mod));
	for(new i = default_stats_count; i < default_stats_count + new_stats_count; i++)
		PlayerInfo[playerid][HatStats][i] = GenerateStat(item[Type]);
}

stock AddGlassesProps(playerid)
{
	new mod = PlayerInfo[playerid][GlassesMod];
	new item[BaseItem];
	item = GetItem(PlayerInfo[playerid][GlassesSlotID]);
	new grade = item[Grade];
	new default_stats_count = GetMaxStatsByGrade(grade);

	for(new i = default_stats_count; i < MAX_STATS; i++)
		PlayerInfo[playerid][GlassesStats][i] = -1;

	new new_stats_count = 1 + random(GetMaxStatsByMod(mod));
	for(new i = default_stats_count; i < default_stats_count + new_stats_count; i++)
		PlayerInfo[playerid][GlassesStats][i] = GenerateStat(item[Type]);
}

stock AddWatchProps(playerid)
{
	new mod = PlayerInfo[playerid][WatchMod];
	new item[BaseItem];
	item = GetItem(PlayerInfo[playerid][WatchSlotID]);
	new grade = item[Grade];
	new default_stats_count = GetMaxStatsByGrade(grade);

	for(new i = default_stats_count; i < MAX_STATS; i++)
		PlayerInfo[playerid][WatchStats][i] = -1;

	new new_stats_count = 1 + random(GetMaxStatsByMod(mod));
	for(new i = default_stats_count; i < default_stats_count + new_stats_count; i++)
		PlayerInfo[playerid][WatchStats][i] = GenerateStat(item[Type]);
}
// 

stock AddEquipStats(playerid, slotid)
{
	new mod = PlayerInventory[playerid][slotid][Mod];
	new item[BaseItem];
	item = GetItem(PlayerInventory[playerid][slotid][ID]);
	new grade = item[Grade];
	new default_stats_count = GetMaxStatsByGrade(grade);

	for(new i = default_stats_count; i < MAX_STATS; i++)
		PlayerInventory[playerid][slotid][Stats][i] = -1;

	if(mod < 7)
		return;

	new new_stats_count = 1 + random(GetMaxStatsByMod(mod));
	for(new i = default_stats_count; i < default_stats_count + new_stats_count; i++)
		PlayerInventory[playerid][slotid][Stats][i] = GenerateStat(item[Type]);
}

stock SellItem(playerid, slotid, count = 1)
{
	if(slotid == -1) return 0;

	new item[BaseItem];
	item = GetItem(PlayerInventory[playerid][slotid][ID]);
	new price = (item[Price] * count) / 7;
	new tax = floatround(floatmul(price, 0.05));
	price -= tax;

	PlayerInventory[playerid][slotid][Count] -= count;
	if(PlayerInventory[playerid][slotid][Count] <= 0)
	{
		for(new i = 0; i < MAX_STATS; i++)
			PlayerInventory[playerid][slotid][Stats][i] = -1;
		PlayerInventory[playerid][slotid][ID] = -1;
		PlayerInventory[playerid][slotid][Count] = 0;
		PlayerInventory[playerid][slotid][Mod] = 0;
		PlayerInventory[playerid][slotid][Stage] = 0;
	}

	if(IsInventoryOpen[playerid])
		UpdateSlot(playerid, slotid);

	SaveInventorySlot(playerid, slotid);

	PlayerInfo[playerid][Cash] += price;
	GivePlayerCash(playerid, price);
	GivePatriarchMoney(tax);

	return price;
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
  new item[BaseItem];
  new string[255];

  if(!items_database_loaded)
  {
    format(string, sizeof(string), "Cannot get item [ID = %d]. Items database is not loaded", id);
		print(string);
		return item;
  }

  if(id >= MAX_ITEM_ID)
  {
    format(string, sizeof(string), "Cannot get item [ID = %d].", id);
		print(string);
		return item;
  }

  item = ItemsDatabase[id];

  if(item[ID] != id)
  {
    format(string, sizeof(string), "Cannot get item [ID = %d]. Wrong data in database", id);
		print(string);
		return item;
  }

	return item;
}

stock GetStat(id)
{
	new string[255];
	new query[255];
	new stat[StatItem];
	format(query, sizeof(query), "SELECT * FROM `stats_info` WHERE `Stat` = '%d' LIMIT 1", id);
	new Cache:q_result = mysql_query(sql_handle, query);

	new count;
	cache_get_row_count(count);
	if(count <= 0)
	{
		format(string, sizeof(string), "Cannot get stat [ID = %d].", id);
		print(string);
		return stat;
	}

	stat[Stat] = id;
	cache_get_value_name_int(0, "StatType", stat[StatType]);
	cache_get_value_name(0, "Text", string);
	sscanf(string, "s[255]", stat[Text]);
	cache_get_value_name_int(0, "StatEnum", stat[StatEnum]);
	cache_get_value_name_int(0, "Value", stat[Value]);

	cache_delete(q_result);
	return stat;
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
		case 1007: return true;
		case 1067: return true;
    case 1072: return true;
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
		case GRADE_R: string = "R";
		case GRADE_S: string = "S";
    case GRADE_F: string = "F";
		default: string = "N";
	}
	return string;
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
		PlayerTextDrawSetStringRus(playerid, InfItemEffect[playerid][i], GetPropertyString(item[Property][i], item[PropertyVal][i]));
		if(item[Property][i] == PROPERTY_HEAL || item[Property][i] == PROPERTY_INVUL || item[Property][i] == PROPERTY_REGEN || item[Property][i] == PROPERTY_PARADOX)
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

stock ShowEquipInfo(playerid, slotid)
{
	new item[BaseItem];
	new string[255];
	item = GetItem(PlayerInventory[playerid][slotid][ID]);

	new itemid = item[ID];

	new mod = PlayerInventory[playerid][slotid][Mod];
	new stage = PlayerInventory[playerid][slotid][Stage];

	new stats[MAX_STATS];
	for(new i = 0; i < MAX_STATS; i++)
		stats[i] = PlayerInventory[playerid][slotid][Stats][i];

	new static_stats_count = GetMaxStatsByGrade(item[Grade]);

	HideOpenedInfoWindows(playerid);

	PlayerTextDrawSetPreviewModel(playerid, EqInfItemIcon[playerid], item[Model]);
	PlayerTextDrawSetPreviewRot(playerid, EqInfItemIcon[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemIcon[playerid], HexGradeColors[item[Grade]-1][0]);

	if(mod == 0)
		PlayerTextDrawSetStringRus(playerid, EqInfItemName[playerid], item[Name]);
	else
	{
		format(string, sizeof(string), "+%d %s", mod, item[Name]);
		PlayerTextDrawSetStringRus(playerid, EqInfItemName[playerid], string);
	}

	PlayerTextDrawColor(playerid, EqInfItemName[playerid], HexGradeColors[item[Grade]-1][0]);

	format(string, sizeof(string), "Тип: %s", ResolveItemType(item[Type]));
	PlayerTextDrawSetStringRus(playerid, EqInfItemType[playerid], string);

	format(string, sizeof(string), "Мин. ранг: %s", GetRankInterval(item[MinRank]));
	PlayerTextDrawSetStringRus(playerid, EqInfMinRank[playerid], string);
	new min_rank = item[MinRank];
	if(PlayerInfo[playerid][Rank] >= min_rank)
		PlayerTextDrawColor(playerid, EqInfMinRank[playerid], -1);
	else
		PlayerTextDrawColor(playerid, EqInfMinRank[playerid], 0xFF0000FF);

	format(string, sizeof(string), "Грейд: %s", ResolveItemGrade(item[Grade]));
	PlayerTextDrawSetStringRus(playerid, EqInfGrade[playerid], string);

	format(string, sizeof(string), "Стадия: %d", stage);
	PlayerTextDrawSetStringRus(playerid, EqInfStage[playerid], string);

	new start_idx = 1;
	if(item[Type] == ITEMTYPE_AMULETTE || item[Type] == ITEMTYPE_RING)
		start_idx = 0;
	
	new j = 0;
	
	for(new i = start_idx; i < MAX_PROPERTIES + 1; i++)
	{
		if(item[Property][j] == PROPERTY_HEAL || item[Property][j] == PROPERTY_INVUL || item[Property][j] == PROPERTY_REGEN || item[Property][j] == PROPERTY_PARADOX)
			PlayerTextDrawColor(playerid, EqInfMainStats[playerid][i], 16711935);
		else
			PlayerTextDrawColor(playerid, EqInfMainStats[playerid][i], -1);

		PlayerTextDrawSetStringRus(playerid, EqInfMainStats[playerid][i], GetPropertyString(item[Property][j], item[PropertyVal][j]));
		PlayerTextDrawShow(playerid, EqInfMainStats[playerid][i]);

		if(MAX_PROPERTIES > j + 1)
			j++;
		else
			break;
	}

	format(string, sizeof(string), "Цена: %s$", FormatMoney(item[Price]));
	PlayerTextDrawSetStringRus(playerid, EqInfPrice[playerid], string);

	if(item[IsTradeble] == 1)
		PlayerTextDrawSetStringRus(playerid, EqInfTrading[playerid], "Обмен: возможен");
	else
		PlayerTextDrawSetStringRus(playerid, EqInfTrading[playerid], "Обмен: невозможен");

	PlayerTextDrawShow(playerid, EqInfBox[playerid]);
	PlayerTextDrawShow(playerid, EqInfTxt1[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim1[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemIcon[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemName[playerid]);
	PlayerTextDrawShow(playerid, EqInfItemType[playerid]);
	PlayerTextDrawShow(playerid, EqInfMinRank[playerid]);
	PlayerTextDrawShow(playerid, EqInfGrade[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim2[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim3[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim4[playerid]);
	PlayerTextDrawShow(playerid, EqInfDelim5[playerid]);
	PlayerTextDrawShow(playerid, EqInfPrice[playerid]);
	PlayerTextDrawShow(playerid, EqInfTrading[playerid]);
	PlayerTextDrawShow(playerid, EqInfClose[playerid]);

	if(item[Type] != ITEMTYPE_AMULETTE && item[Type] != ITEMTYPE_RING)
		PlayerTextDrawShow(playerid, EqInfStage[playerid]);

	if(stats[0] != -1)
		PlayerTextDrawShow(playerid, EqInfSpecialParamsText[playerid]);

	for(new i = 0; i < MAX_STATS; i++)
	{
		if(stats[i] == -1)
			break;
		
		PlayerTextDrawColor(playerid, EqInfSpecialStats[playerid][i], i < static_stats_count ? -1 : -2686721);
		PlayerTextDrawSetStringRus(playerid, EqInfSpecialStats[playerid][i], GetSpecialStatString(stats[i]));
		PlayerTextDrawShow(playerid, EqInfSpecialStats[playerid][i]);
	}

	if(item[Type] != ITEMTYPE_RING && item[Type] != ITEMTYPE_AMULETTE)
	{
		if(item[Type] == ITEMTYPE_WEAPON)
		{
			new damage[2];
			damage = GetWeaponBaseDamage(itemid, stage);
			if(mod > 0)
			{
				damage[0] = GetEquipModifiedValue(damage[0], mod);
				damage[1] = GetEquipModifiedValue(damage[1], mod);
			}
			format(string, sizeof(string), "Атака: %d-%d", damage[0], damage[1]);
		}
		else if(item[Type] == ITEMTYPE_GLASSES)
		{
			new g_damage = GetGlassesBaseDamage(itemid, stage);
			if(mod > 0)
				g_damage = GetEquipModifiedValue(g_damage, mod);
			format(string, sizeof(string), "Атака: %d", g_damage);
		}
		else if(item[Type] == ITEMTYPE_ARMOR || item[Type] == ITEMTYPE_HAT || item[Type] == ITEMTYPE_WATCH)
		{
			new defense;
			defense = GetArmorBaseDefense(itemid, stage);
			if(mod > 0)
				defense = GetEquipModifiedValue(defense, mod);
			format(string, sizeof(string), "Защита: %d", defense);
		}
		PlayerTextDrawSetStringRus(playerid, EqInfMainStats[playerid][0], string);
		PlayerTextDrawShow(playerid, EqInfMainStats[playerid][0]);
	}

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

stock HideEquipInfo(playerid)
{
	PlayerTextDrawHide(playerid, EqInfBox[playerid]);
	PlayerTextDrawHide(playerid, EqInfTxt1[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim1[playerid]);
	PlayerTextDrawHide(playerid, EqInfItemIcon[playerid]);
	PlayerTextDrawHide(playerid, EqInfItemName[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim2[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim3[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim4[playerid]);
	PlayerTextDrawHide(playerid, EqInfDelim5[playerid]);
	PlayerTextDrawHide(playerid, EqInfPrice[playerid]);
	PlayerTextDrawHide(playerid, EqInfClose[playerid]);
	PlayerTextDrawHide(playerid, EqInfItemType[playerid]);
	PlayerTextDrawHide(playerid, EqInfMinRank[playerid]);
	PlayerTextDrawHide(playerid, EqInfGrade[playerid]);
	PlayerTextDrawHide(playerid, EqInfStage[playerid]);
	PlayerTextDrawHide(playerid, EqInfSpecialParamsText[playerid]);
	PlayerTextDrawHide(playerid, EqInfTrading[playerid]);
	for(new i = 0; i < 4; i++)
		PlayerTextDrawHide(playerid, EqInfMainStats[playerid][i]);
	for(new i = 0; i < MAX_STATS; i++)
		PlayerTextDrawHide(playerid, EqInfSpecialStats[playerid][i]);
	for(new i = 0; i < 3; i++)
		PlayerTextDrawHide(playerid, EqInfDescriptionStr[playerid][i]);

	Windows[playerid][EquipInfo] = false;
}

stock UpdatePlayerStatsVisual(playerid)
{
	new string[255];

	format(string, sizeof(string), "%s: %d-%d", "Атака", PlayerInfo[playerid][DamageMin], PlayerInfo[playerid][DamageMax]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDamage[playerid], string);
	format(string, sizeof(string), "%s: %d", "Защита", PlayerInfo[playerid][Defense]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDefense[playerid], string);
	format(string, sizeof(string), "%s: %d", "Точность", PlayerInfo[playerid][Accuracy]);
	PlayerTextDrawSetStringRus(playerid, ChrInfAccuracy[playerid], string);
	format(string, sizeof(string), "%s: %d", "Уклонение", PlayerInfo[playerid][Dodge]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDodge[playerid], string);
	format(string, sizeof(string), "%s: %d", "Шанс крита", PlayerInfo[playerid][Crit]);
	PlayerTextDrawSetStringRus(playerid, ChrInfCritChance[playerid], string);
	format(string, sizeof(string), "%s: %.2f", "Урон от крита", floatdiv(PlayerInfo[playerid][CritMult], 100));
	PlayerTextDrawSetStringRus(playerid, ChrInfCritMult[playerid], string);
	format(string, sizeof(string), "%s: %.2f", "Уменьшить силу крита", floatdiv(PlayerInfo[playerid][CritMultReduction], 100));
	PlayerTextDrawSetStringRus(playerid, ChrInfCritMultReduction[playerid], string);
	format(string, sizeof(string), "%s: %d%%", "Снижение крит. урона", PlayerInfo[playerid][CritReduction]);
	PlayerTextDrawSetStringRus(playerid, ChrInfCritReduction[playerid], string);
	format(string, sizeof(string), "%s: %d%%", "Поглощение ХП", PlayerInfo[playerid][Vamp]);
	PlayerTextDrawSetStringRus(playerid, ChrInfVamp[playerid], string);
	format(string, sizeof(string), "%s: %d%%", "Регенерация", PlayerInfo[playerid][Regeneration]);
	PlayerTextDrawSetStringRus(playerid, ChrInfRegeneration[playerid], string);
	format(string, sizeof(string), "%s: %d%%", "Отразить урон", PlayerInfo[playerid][DamageReflection]);
	PlayerTextDrawSetStringRus(playerid, ChrInfDamageReflection[playerid], string);
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

	PlayerTextDrawSetPreviewModel(playerid, ChrInfoSkin[playerid], PlayerInfo[playerid][Skin]);

	UpdatePlayerStatsVisual(playerid);

	PlayerTextDrawShow(playerid, ChrInfoBox[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoHeader[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoDelim1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoDelim2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoDelim3[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoDelim4[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoDelim5[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoDelim6[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDamage[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDefense[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAccuracy[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDodge[playerid]);
	PlayerTextDrawShow(playerid, ChrInfCritChance[playerid]);
	PlayerTextDrawShow(playerid, ChrInfCritMult[playerid]);
	PlayerTextDrawShow(playerid, ChrInfCritMultReduction[playerid]);
	PlayerTextDrawShow(playerid, ChrInfCritReduction[playerid]);
	PlayerTextDrawShow(playerid, ChrInfVamp[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRegeneration[playerid]);
	PlayerTextDrawShow(playerid, ChrInfDamageReflection[playerid]);
	PlayerTextDrawShow(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfHatSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfWatchSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfGlassesSlot[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRingSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRingSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAmuletteSlot1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfAmuletteSlot2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfoClose[playerid]);
	PlayerTextDrawShow(playerid, ChrInfText1[playerid]);
	PlayerTextDrawShow(playerid, ChrInfText2[playerid]);
	PlayerTextDrawShow(playerid, ChrInfRateIcon[playerid]);
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
	PlayerTextDrawShow(playerid, ChrInfoSkin[playerid]);

	UpdateEquipSlots(playerid);
  
	IsInventoryOpen[playerid] = true;
  DisableInvSelectionMode(playerid);
	UpdateInventory(playerid);

	Windows[playerid][CharInfo] = true;
	SelectTextDraw(playerid,0xCCCCFF65);
}

stock HideCharInfo(playerid)
{
	PlayerTextDrawHide(playerid, ChrInfRateIcon[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoSkin[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoBox[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoHeader[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoDelim1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoDelim2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoDelim3[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoDelim4[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoDelim5[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoDelim6[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDamage[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDefense[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAccuracy[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDodge[playerid]);
	PlayerTextDrawHide(playerid, ChrInfCritChance[playerid]);
	PlayerTextDrawHide(playerid, ChrInfCritMult[playerid]);
	PlayerTextDrawHide(playerid, ChrInfCritMultReduction[playerid]);
	PlayerTextDrawHide(playerid, ChrInfCritReduction[playerid]);
	PlayerTextDrawHide(playerid, ChrInfVamp[playerid]);
	PlayerTextDrawHide(playerid, ChrInfRegeneration[playerid]);
	PlayerTextDrawHide(playerid, ChrInfDamageReflection[playerid]);
	PlayerTextDrawHide(playerid, ChrInfArmorSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfWeaponSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfHatSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfWatchSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfGlassesSlot[playerid]);
	PlayerTextDrawHide(playerid, ChrInfRingSlot1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfRingSlot2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAmuletteSlot1[playerid]);
	PlayerTextDrawHide(playerid, ChrInfAmuletteSlot2[playerid]);
	PlayerTextDrawHide(playerid, ChrInfoClose[playerid]);
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

  DisableInvSelectionMode(playerid);
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
		CmbItemInvSlot[playerid][i] = -1;
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
	TextDrawHideForPlayer(playerid, MpBtn[playerid]);
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

		TextDrawShowForPlayer(playerid, MpBtn[playerid]);
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
		TextDrawHideForPlayer(playerid, MpBtn[playerid]);
	}

	PlayerTextDrawShow(playerid, MpItem[playerid]);
}

stock ShowModWindow(playerid, itemslot)
{
	if(itemslot == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка модификации.");
		return;
	}

	Windows[playerid][Mod] = true;
	IsSlotsBlocked[playerid] = true;

	HideOpenedInfoWindows(playerid);

	SetPVarInt(playerid, "ModMsgSuccess", 0);
	SetPVarInt(playerid, "ModMsgFail", 0);
	SetPVarInt(playerid, "ModMsgSafeFail", 0);
	SetPVarInt(playerid, "ModMsgDestroy", 0);

	PlayerTextDrawSetPreviewModel(playerid, UpgPotionSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgPotionSlot[playerid], 0, 0, 0);
	PlayerTextDrawSetPreviewModel(playerid, UpgDefSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgDefSlot[playerid], 0, 0, 0);
	PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], 0, 0, 0);
	PlayerTextDrawBackgroundColor(playerid, UpgPotionSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, UpgDefSlot[playerid], -1061109505);

	new item[BaseItem];
	item = GetItem(PlayerInventory[playerid][itemslot][ID]);

	new def_item[BaseItem];
	def_item = GetItem(1006);

	PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], item[Model]);
	PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
	PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], HexGradeColors[item[Grade]-1][0]);

	PlayerTextDrawSetPreviewModel(playerid, UpgDefSlot[playerid], def_item[Model]);
	PlayerTextDrawSetPreviewRot(playerid, UpgDefSlot[playerid], def_item[ModelRotX], def_item[ModelRotY], def_item[ModelRotZ]);
	PlayerTextDrawBackgroundColor(playerid, UpgDefSlot[playerid], HexGradeColors[def_item[Grade]-1][0]);

	new def_slot = FindItem(playerid, 1006);
	if(def_slot != -1)
	{
		new str[32];
		format(str, sizeof(str), "%d", PlayerInventory[playerid][def_slot][Count]);
		PlayerTextDrawSetStringRus(playerid, UpgDefCount[playerid], str);
		PlayerTextDrawShow(playerid, UpgDefCount[playerid]);
	}

	new old_mod_str[64];
	new new_mod_str[64];
	new mod_level = PlayerInventory[playerid][itemslot][Mod];

	if(mod_level == 0)
		format(old_mod_str, sizeof(old_mod_str), "%s", item[Name]);
	else
		format(old_mod_str, sizeof(old_mod_str), "+%d %s", mod_level, item[Name]);

	PlayerTextDrawSetStringRus(playerid, UpgOldItemTxt[playerid], old_mod_str);
	PlayerTextDrawColor(playerid, UpgOldItemTxt[playerid], HexGradeColors[item[Grade]-1][0]);
	PlayerTextDrawShow(playerid, UpgOldItemTxt[playerid]);

	format(new_mod_str, sizeof(new_mod_str), "+%d %s", mod_level+1, item[Name]);

	PlayerTextDrawSetStringRus(playerid, UpgNewItemTxt[playerid], new_mod_str);
	PlayerTextDrawColor(playerid, UpgNewItemTxt[playerid], HexGradeColors[item[Grade]-1][0]);
	PlayerTextDrawShow(playerid, UpgNewItemTxt[playerid]);

	ModItemSlot[playerid] = itemslot;

	PlayerTextDrawShow(playerid, UpgBox[playerid]);
	PlayerTextDrawShow(playerid, UpgTxt1[playerid]);
	PlayerTextDrawShow(playerid, UpgDelim1[playerid]);
	PlayerTextDrawShow(playerid, UpgTxt2[playerid]);
	PlayerTextDrawShow(playerid, UpgTxt3[playerid]);
	PlayerTextDrawShow(playerid, UpgDefSlot[playerid]);
	PlayerTextDrawShow(playerid, UpgPotionSlot[playerid]);
	PlayerTextDrawShow(playerid, UpgSafeBtn[playerid]);
	PlayerTextDrawShow(playerid, UpgBtn[playerid]);
	PlayerTextDrawShow(playerid, UpgClose[playerid]);
	PlayerTextDrawShow(playerid, UpgArrow[playerid]);
}

stock HideModWindow(playerid)
{
	Windows[playerid][Mod] = false;
	IsSlotsBlocked[playerid] = false;

	ModItemSlot[playerid] = -1;
	ModPotion[playerid] = -1;

	SetPVarInt(playerid, "ModMsgSuccess", 0);
	SetPVarInt(playerid, "ModMsgFail", 0);
	SetPVarInt(playerid, "ModMsgSafeFail", 0);
	SetPVarInt(playerid, "ModMsgDestroy", 0);

	PlayerTextDrawHide(playerid, UpgBox[playerid]);
	PlayerTextDrawHide(playerid, UpgTxt1[playerid]);
	PlayerTextDrawHide(playerid, UpgDelim1[playerid]);
	PlayerTextDrawHide(playerid, UpgItemSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgTxt2[playerid]);
	PlayerTextDrawHide(playerid, UpgTxt3[playerid]);
	PlayerTextDrawHide(playerid, UpgPotionSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgBtn[playerid]);
	PlayerTextDrawHide(playerid, UpgClose[playerid]);
	PlayerTextDrawHide(playerid, UpgPotionCount[playerid]);
	PlayerTextDrawHide(playerid, UpgDefSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgDefCount[playerid]);
	PlayerTextDrawHide(playerid, UpgSafeBtn[playerid]);
	PlayerTextDrawHide(playerid, UpgOldItemTxt[playerid]);
	PlayerTextDrawHide(playerid, UpgNewItemTxt[playerid]);
	PlayerTextDrawHide(playerid, UpgArrow[playerid]);
	PlayerTextDrawHide(playerid, UpgMainTxt[playerid]);
	PlayerTextDrawHide(playerid, UpgCongrTxt[playerid]);
}

stock UpdateModWindow(playerid)
{
	PlayerTextDrawHide(playerid, UpgItemSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgPotionSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgDefSlot[playerid]);
	PlayerTextDrawHide(playerid, UpgDefCount[playerid]);
	PlayerTextDrawHide(playerid, UpgPotionCount[playerid]);
	PlayerTextDrawHide(playerid, UpgOldItemTxt[playerid]);
	PlayerTextDrawHide(playerid, UpgNewItemTxt[playerid]);
	PlayerTextDrawHide(playerid, UpgMainTxt[playerid]);
	PlayerTextDrawHide(playerid, UpgCongrTxt[playerid]);

	PlayerTextDrawSetPreviewModel(playerid, UpgPotionSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgPotionSlot[playerid], 0, 0, 0);
	PlayerTextDrawSetPreviewModel(playerid, UpgDefSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgDefSlot[playerid], 0, 0, 0);
	PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], 0, 0, 0);
	PlayerTextDrawBackgroundColor(playerid, UpgPotionSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, UpgDefSlot[playerid], -1061109505);

	if(ModItemSlot[playerid] != -1)
	{
		if(!HasItem(playerid, 1005))
		{
			HideModWindow(playerid);
			ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Модификация", "Вы использовали все камни силы.", "Закрыть", "");
			return;
		}

		new item[BaseItem];
		new def_item[BaseItem];
		item = GetItem(PlayerInventory[playerid][ModItemSlot[playerid]][ID]);
		def_item = GetItem(1006);

		PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], item[Model]);
		PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], item[ModelRotX], item[ModelRotY], item[ModelRotZ]);
		PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], HexGradeColors[item[Grade]-1][0]);

		PlayerTextDrawSetPreviewModel(playerid, UpgDefSlot[playerid], def_item[Model]);
		PlayerTextDrawSetPreviewRot(playerid, UpgDefSlot[playerid], def_item[ModelRotX], def_item[ModelRotY], def_item[ModelRotZ]);
		PlayerTextDrawBackgroundColor(playerid, UpgDefSlot[playerid], HexGradeColors[def_item[Grade]-1][0]);

		new old_mod_str[64];
		new new_mod_str[64];
		new mod_level = PlayerInventory[playerid][ModItemSlot[playerid]][Mod];

		if(mod_level == 0)
			format(old_mod_str, sizeof(old_mod_str), "%s", item[Name]);
		else
			format(old_mod_str, sizeof(old_mod_str), "+%d %s", mod_level, item[Name]);

		PlayerTextDrawSetStringRus(playerid, UpgOldItemTxt[playerid], old_mod_str);
		PlayerTextDrawColor(playerid, UpgOldItemTxt[playerid], HexGradeColors[item[Grade]-1][0]);
		PlayerTextDrawShow(playerid, UpgOldItemTxt[playerid]);

		format(new_mod_str, sizeof(new_mod_str), "+%d %s", mod_level+1, item[Name]);

		PlayerTextDrawSetStringRus(playerid, UpgNewItemTxt[playerid], new_mod_str);
		PlayerTextDrawColor(playerid, UpgNewItemTxt[playerid], HexGradeColors[item[Grade]-1][0]);
		PlayerTextDrawShow(playerid, UpgNewItemTxt[playerid]);

		new def_slot = FindItem(playerid, 1006);
		if(def_slot != -1)
		{
			new str[32];
			format(str, sizeof(str), "%d", PlayerInventory[playerid][def_slot][Count]);
			PlayerTextDrawSetStringRus(playerid, UpgDefCount[playerid], str);
			PlayerTextDrawShow(playerid, UpgDefCount[playerid]);
		}

		if(GetPVarInt(playerid, "ModMsgSuccess") > 0)
		{
			new str[128];
			format(str, sizeof(str), "+%d %s", mod_level, item[Name]);
			PlayerTextDrawColor(playerid, UpgMainTxt[playerid], HexGradeColors[item[Grade]-1][0]);
			PlayerTextDrawSetStringRus(playerid, UpgMainTxt[playerid], str);
			PlayerTextDrawShow(playerid, UpgMainTxt[playerid]);

			PlayerTextDrawShow(playerid, UpgItemSlot[playerid]);
			PlayerTextDrawShow(playerid, UpgCongrTxt[playerid]);

			SetPVarInt(playerid, "ModMsgSuccess", 0);
		}
		else if(GetPVarInt(playerid, "ModMsgFail") > 0)
		{
			PlayerTextDrawColor(playerid, UpgMainTxt[playerid], 0xFFFFFFFF);
			PlayerTextDrawSetStringRus(playerid, UpgMainTxt[playerid], "Усиление не удалось");
			PlayerTextDrawShow(playerid, UpgMainTxt[playerid]);

			SetPVarInt(playerid, "ModMsgFail", 0);
		}
		else if(GetPVarInt(playerid, "ModMsgSafeFail") > 0)
		{
			PlayerTextDrawColor(playerid, UpgMainTxt[playerid], 0xFFFFFFFF);
			PlayerTextDrawSetStringRus(playerid, UpgMainTxt[playerid], "Усиление не удалось, но печать предотвратила уничтожение предмета");
			PlayerTextDrawShow(playerid, UpgMainTxt[playerid]);

			SetPVarInt(playerid, "ModMsgSafeFail", 0);
		}
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

			new potion_slot = FindItem(playerid, ModPotion[playerid]);
			if(potion_slot != -1)
			{
				new str[32];
				format(str, sizeof(str), "%d", PlayerInventory[playerid][potion_slot][Count]);
				PlayerTextDrawSetStringRus(playerid, UpgPotionCount[playerid], str);
				PlayerTextDrawShow(playerid, UpgPotionCount[playerid]);
			}
		}
		else
			ModPotion[playerid] = -1;
	}

	if(GetPVarInt(playerid, "ModMsgDestroy") > 0)
	{
		PlayerTextDrawColor(playerid, UpgMainTxt[playerid], 0xFFFFFFFF);
		PlayerTextDrawSetStringRus(playerid, UpgMainTxt[playerid], "Усиление не удалось и предмет был уничтожен");
		PlayerTextDrawShow(playerid, UpgMainTxt[playerid]);

		SetPVarInt(playerid, "ModMsgDestroy", 0);
	}

	PlayerTextDrawShow(playerid, UpgPotionSlot[playerid]);
	PlayerTextDrawShow(playerid, UpgDefSlot[playerid]);
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

stock CmbSlotExist(playerid, slotid)
{
	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		if(CmbItemInvSlot[playerid][i] == -1)
			continue;

		if(CmbItemInvSlot[playerid][i] == slotid)
			return true;
	}
	
	return false;
}

stock SetCmbItem(playerid, slot, invslot, item, count)
{
	new mode = GetPVarInt(playerid, "CmbMode");
	if(slot > MAX_CMB_ITEMS || slot < 1)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинации", "Недопустимый предмет.", "Закрыть", "");
		return;
	}

	if(mode == 0 && CmbItemExist(playerid, item))
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинации", "Предмет уже зарегистрирован.", "Закрыть", "");
		return;
	}

	if(CmbSlotExist(playerid, invslot))
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

stock UpStage(playerid)
{
	if(!IsModifiableEquip(CmbItem[playerid][0]))
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Повышение стадии", "Можно использовать только улучшаемую экипировку.", "Закрыть", "");
		return;
	}

	if(CmbItem[playerid][0] == -1 || CmbItem[playerid][1] == -1 || CmbItem[playerid][2] == -1)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Повышение стадии", "Поместите 3 одинаковых предмета.", "Закрыть", "");
		return;
	}

	if(CmbItem[playerid][0] != CmbItem[playerid][1] || 
		 CmbItem[playerid][0] != CmbItem[playerid][2] ||
		 CmbItem[playerid][1] != CmbItem[playerid][2])
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Повышение стадии", "Предметы не одинаковы.", "Закрыть", "");
		return;
	}

  new max_stage = MAX_STAGE;
  switch(PlayerInventory[playerid][CmbItemInvSlot[playerid][0]][Grade])
  {
    case GRADE_N: max_stage = 3;
    case GRADE_B: max_stage = 5;
    case GRADE_C: max_stage = 7;
    default: max_stage = MAX_STAGE;
  }

	if(PlayerInventory[playerid][CmbItemInvSlot[playerid][0]][Stage] >= max_stage)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Повышение стадии", "Данный предмет достиг максимальной стадии.", "Закрыть", "");
		return;
	}

	new item[BaseItem];
	item = GetItem(CmbItem[playerid][0]);

	new required_essence = item[MinRank] * 2;
	new required_boosters = item[MinRank] * 2 + item[Grade] * 2;

	new essence_id = 1008 + item[Grade] - 1;
  if(item[Grade] == GRADE_F)
    essence_id = 1070;

	new booster_id = 1013;

	new string[255];
	if(!HasItem(playerid, essence_id, required_essence))
	{
		format(string, sizeof(string), "Недостаточно эссенций. Требуется %d шт.", required_essence);
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Повышение стадии", string, "Закрыть", "");
		return;
	}
	if(!HasItem(playerid, booster_id, required_essence))
	{
		format(string, sizeof(string), "Недостаточно усилителей. Требуется %d шт.", required_boosters);
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Повышение стадии", string, "Закрыть", "");
		return;
	}

	new essence_slot = FindItem(playerid, essence_id);
	new booster_slot = FindItem(playerid, booster_id);

	DeleteItem(playerid, essence_slot, required_essence);
	DeleteItem(playerid, booster_slot, required_boosters);
	DeleteItem(playerid, CmbItemInvSlot[playerid][1]);
	DeleteItem(playerid, CmbItemInvSlot[playerid][2]);

	new chance;
	new current_stage = PlayerInventory[playerid][CmbItemInvSlot[playerid][0]][Stage];
	switch(current_stage)
	{
		case 1: chance = 95;
		case 2: chance = 85;
		case 3: chance = 70;
		case 4: chance = 60;
		case 5: chance = 50;
		case 6: chance = 35;
		case 7: chance = 20;
		case 8: chance = 15;
		case 9: chance = 8;
		default: chance = 90;
	}

	new bool:success = CheckChance(chance);
	if(success)
	{
		PlayerInventory[playerid][CmbItemInvSlot[playerid][0]][Stage] = current_stage + 1;
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "{33CC00}Повышение стадии успешно.", "Закрыть", "");

    if(current_stage + 1 >= 5)
    {
      format(string, sizeof(string), "{%s}%s {ffffff}приобрел {%s}[S%d][+%d %s]{ffffff}.", 
        GetColorByRate(PlayerInfo[playerid][Rate]), PlayerInfo[playerid][Name], GetGradeColor(item[Grade]), current_stage + 1, PlayerInventory[playerid][CmbItemInvSlot[playerid][0]][Mod], item[Name]
      );
      SendClientMessageToAll(0xFFFFFFFF, string);
    }
	}
	else
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "Повышение стадии неудачно.", "Закрыть", "");

	for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		CmbItem[playerid][i] = -1;
		CmbItemCount[playerid][i] = 0;
		CmbItemInvSlot[playerid][i] = -1;
	}

	UpdateCmbWindow(playerid);
}

stock CombineItems(playerid)
{
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
	GivePlayerCash(playerid, -price);

	if(success)
	{
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Комбинирование", "{33CC00}Успешная комбинация.", "Закрыть", "");
		if(IsEquip(result_id))
		{
			if(result_id >= 209 && result_id <= 230)
			{
				if(CheckChance(10))
					result_id += 2;
				else if(CheckChance(25))
					result_id += 1;
			}

			new eq_item[BaseItem];
			eq_item = GetItem(result_id);

      if(result_id >= 250 && result_id <= 256)
      {
        new dragon_eq_mod = PlayerInventory[playerid][CmbItemInvSlot[playerid][0]][Mod] - 2;
        new dragon_eq_stage = PlayerInventory[playerid][CmbItemInvSlot[playerid][0]][Stage] - 1;

        if(dragon_eq_mod < 0)
          dragon_eq_mod = 0;
        if(dragon_eq_stage < 0)
          dragon_eq_stage = 0;

        AddEquip(playerid, result_id, PlayerInventory[playerid][CmbItemInvSlot[playerid][0]][Stats], dragon_eq_stage, dragon_eq_mod);
      }
      else
			  AddEquip(playerid, result_id, STATS_CLEAR);

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

  for(new i = 0; i < MAX_CMB_ITEMS; i++)
	{
		if(!success && IsEquip(CmbItem[playerid][i]))
			continue;
		
		if(!success && CmbItem[playerid][i] >= 1014 && CmbItem[playerid][i] <= 1021)
			continue;
		
		if(!success && CmbItem[playerid][i] >= 1025 && CmbItem[playerid][i] <= 1033)
			continue;

    if(!success && CmbItem[playerid][i] >= 1076 && CmbItem[playerid][i] <= 1084)
			continue;

		DeleteItem(playerid, CmbItemInvSlot[playerid][i], CmbItemCount[playerid][i]);
	}

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

stock UpgradeItem(playerid, itemslot, potionid = -1, bool:is_safe = false)
{
	new itemid = PlayerInventory[playerid][itemslot][ID];
	new level = PlayerInventory[playerid][itemslot][Mod] + 1;
	if(level > MAX_MOD || itemid == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка модификации.");
		return;
	}

	new item[BaseItem];
	item = GetItem(itemid);

	new chances[4];
	chances = GetModChances(level, potionid);

	new encslot = FindItem(playerid, 1005);
	if(encslot == -1)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка модификации.");
		return;
	}

	DeleteItem(playerid, encslot, 1);

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
		PlayerInventory[playerid][itemslot][Mod]++;
		if(level == MAX_MOD)
		{
			ModItemSlot[playerid] = -1;
			ModPotion[playerid] = -1;
		}
		if(level >= 10)
		{
			new cng_string[255];
			new name[255];
			GetPlayerName(playerid, name, sizeof(name));
			format(cng_string, sizeof(cng_string), "{%s}%s{FF6347} приобрел {%s}[S%d][+%d %s]", 
				GetColorByRate(PlayerInfo[playerid][Rate]), name, GetGradeColor(item[Grade]), PlayerInventory[playerid][itemslot][Stage], level, item[Name]
			);
			SendClientMessageToAll(COLOR_LIGHTRED, cng_string);
		}
		SetPVarInt(playerid, "ModMsgSuccess", 1);
		UpdatePlayerEffects(playerid);
	}
	//fail
	else if(roll <= chances[0] + chances[1])
	{
		SetPVarInt(playerid, "ModMsgFail", 1);
	}
	//destroy
	else
	{
		if(!is_safe)
		{
			DeleteItem(playerid, itemslot, 1);
			ModItemSlot[playerid] = -1;
			ModPotion[playerid] = -1;

			SetPVarInt(playerid, "ModMsgDestroy", 1);
		}
		else
		{
			new def_slot = FindItem(playerid, 1006);
			if(def_slot == -1)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка модификации.");
				return;
			}

			DeleteItem(playerid, def_slot, GetDefCount(level));
			SetPVarInt(playerid, "ModMsgSafeFail", 1);
		}
	}
}

stock GetModChances(level, potionid = -1)
{
	new chances[3];
	new query[512];
	format(query, sizeof(query), "SELECT * FROM `mod_chances` WHERE `Level` = '%d' AND `Potion` = '%d' LIMIT 1", level, potionid);
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
	sscanf(string, "a<i>[3]", chances);
	cache_delete(q_result);

	return chances;
}

stock GetWeaponBaseDamage(weaponid, stage)
{
	new damage[2];
	switch(weaponid)
	{
		case 1: { damage[0] = 19; damage[1] = 24; }
		case 2: { damage[0] = 22; damage[1] = 28; }
		case 3: { damage[0] = 24; damage[1] = 31; }
		case 4: { damage[0] = 30; damage[1] = 38; }
		case 5: { damage[0] = 33; damage[1] = 42; }
		case 6: { damage[0] = 41; damage[1] = 51; }
		case 7: { damage[0] = 52; damage[1] = 63; }
		case 8: { damage[0] = 43; damage[1] = 54; }
		case 9: { damage[0] = 53; damage[1] = 65; }
		case 10: { damage[0] = 65; damage[1] = 78; }
		case 11: { damage[0] = 55; damage[1] = 68; }
		case 12: { damage[0] = 66; damage[1] = 79; }
		case 13: { damage[0] = 80; damage[1] = 94; }
		case 14: { damage[0] = 69; damage[1] = 83; }
		case 15: { damage[0] = 83; damage[1] = 98; }
		case 16: { damage[0] = 98; damage[1] = 114; }
		case 17: { damage[0] = 115; damage[1] = 133; }
		case 18: { damage[0] = 92; damage[1] = 108; }
		case 19: { damage[0] = 110; damage[1] = 129; }
		case 20: { damage[0] = 130; damage[1] = 151; }
		case 21: { damage[0] = 153; damage[1] = 176; }
		case 22: { damage[0] = 124; damage[1] = 146; }
		case 23: { damage[0] = 148; damage[1] = 172; }
		case 24: { damage[0] = 175; damage[1] = 203; }
		case 25: { damage[0] = 205; damage[1] = 234; }
		case 26: { damage[0] = 163; damage[1] = 192; }
		case 27: { damage[0] = 191; damage[1] = 222; }
		case 28: { damage[0] = 223; damage[1] = 256; }
		case 29: { damage[0] = 255; damage[1] = 289; }
		case 30: { damage[0] = 283; damage[1] = 322; }
		case 31: { damage[0] = 336; damage[1] = 380; }
		case 32: { damage[0] = 401; damage[1] = 449; }
		case 33: { damage[0] = 470; damage[1] = 532; }
		case 34: { damage[0] = 557; damage[1] = 631; }

		case 209: { damage[0] = 17; damage[1] = 28; }
		case 210: { damage[0] = 17; damage[1] = 28; }
		case 211: { damage[0] = 17; damage[1] = 28; }
		case 212: { damage[0] = 25; damage[1] = 39; }
		case 213: { damage[0] = 25; damage[1] = 39; }
		case 214: { damage[0] = 25; damage[1] = 39; }
		case 215: { damage[0] = 41; damage[1] = 71; }
		case 216: { damage[0] = 41; damage[1] = 71; }
		case 217: { damage[0] = 41; damage[1] = 71; }
		case 218: { damage[0] = 69; damage[1] = 109; }
		case 219: { damage[0] = 69; damage[1] = 109; }
		case 220: { damage[0] = 69; damage[1] = 109; }
		case 221: { damage[0] = 95; damage[1] = 143; }
		case 222: { damage[0] = 95; damage[1] = 143; }
		case 223: { damage[0] = 95; damage[1] = 143; }
		case 224: { damage[0] = 134; damage[1] = 188; }
		case 225: { damage[0] = 134; damage[1] = 188; }
		case 226: { damage[0] = 134; damage[1] = 188; }
		case 227: { damage[0] = 176; damage[1] = 224; }
		case 228: { damage[0] = 176; damage[1] = 224; }
		case 229: { damage[0] = 176; damage[1] = 224; }
		case 230: { damage[0] = 211; damage[1] = 298; }
		case 231: { damage[0] = 211; damage[1] = 298; }
		case 232: { damage[0] = 211; damage[1] = 298; }
		case 233: { damage[0] = 446; damage[1] = 515; }
		case 234: { damage[0] = 531; damage[1] = 609; }
		case 235: { damage[0] = 636; damage[1] = 724; }
		case 236: { damage[0] = 750; damage[1] = 844; }
		case 237: { damage[0] = 888; damage[1] = 1002; }
		case 238: { damage[0] = 157; damage[1] = 180; }
		case 239: { damage[0] = 210; damage[1] = 239; }
		case 240: { damage[0] = 259; damage[1] = 294; }
		case 241: { damage[0] = 288; damage[1] = 329; }
		case 242: { damage[0] = 341; damage[1] = 385; }
		case 243: { damage[0] = 408; damage[1] = 455; }
		case 244: { damage[0] = 479; damage[1] = 550; }
		case 245: { damage[0] = 567; damage[1] = 642; }
		case 246: { damage[0] = 673; damage[1] = 757; }

    case 249: { damage[0] = 378; damage[1] = 430; }
		case 250: { damage[0] = 471; damage[1] = 535; }
		case 251: { damage[0] = 527; damage[1] = 602; }
		case 252: { damage[0] = 624; damage[1] = 721; }
		case 253: { damage[0] = 743; damage[1] = 852; }
		case 254: { damage[0] = 890; damage[1] = 1013; }
		case 255: { damage[0] = 1050; damage[1] = 1181; }
		case 256: { damage[0] = 1243; damage[1] = 1402; }

    case 257: { damage[0] = 210; damage[1] = 239; }
		case 258: { damage[0] = 259; damage[1] = 294; }
		case 259: { damage[0] = 288; damage[1] = 329; }
		case 260: { damage[0] = 341; damage[1] = 385; }
		case 261: { damage[0] = 408; damage[1] = 455; }
		case 262: { damage[0] = 479; damage[1] = 550; }
		case 263: { damage[0] = 567; damage[1] = 642; }
		case 264: { damage[0] = 673; damage[1] = 757; }
    case 265: { damage[0] = 799; damage[1] = 884; }

		default: { damage[0] = 13; damage[1] = 15; }
	}

	if(stage > 0)
	{
		new Float:mul;
		mul = floatadd(1, floatdiv(stage, 10));
		damage[0] = floatround(floatmul(damage[0], mul));
		damage[1] = floatround(floatmul(damage[1], mul));
	}

	return damage;
}

stock GetGlassesBaseDamage(glassesid, stage)
{
	if(glassesid == -1)
		return 0;

	new damage = 0;
	switch(glassesid)
	{
		case 105: damage = 5;
		case 106: damage = 7;
		case 107: damage = 9;
		case 108: damage = 15;
		case 109: damage = 23;
		case 110: damage = 32;
		case 111: damage = 42;
		case 112: damage = 54;
		case 113: damage = 67;
		case 114: damage = 83;
		case 115: damage = 95;
		case 116: damage = 111;
		case 117: damage = 130;
		case 118: damage = 162;
		case 119: damage = 65;
		case 120: damage = 80;
		case 121: damage = 92;
		case 122: damage = 106;
		case 123: damage = 126;
		case 124: damage = 159;
		case 125: damage = 172;
		case 126: damage = 199;
		case 127: damage = 231;
	}

	if(stage > 0)
	{
		new Float:mul;
		mul = floatadd(1, floatdiv(stage, 10));
		damage = floatround(floatmul(damage, mul));
	}

	return damage;
}

stock GetArmorBaseDefense(armorid, stage)
{
	new defense = 100;
	switch(armorid)
	{
		case 35: defense = 50;
		case 36: defense = 100;
		case 37: defense = 130;
		case 38: defense = 140;
		case 39: defense = 180;
		case 40: defense = 220;
		case 41: defense = 265;
		case 42: defense = 330;
		case 43: defense = 285;
		case 44: defense = 350;
		case 45: defense = 410;
		case 46: defense = 385;
		case 47: defense = 450;
		case 48: defense = 495;
		case 49: defense = 480;
		case 50: defense = 565;
		case 51: defense = 620;
		case 52: defense = 700;
		case 53: defense = 590;
		case 54: defense = 675;
		case 55: defense = 760;
		case 56: defense = 850;
		case 57: defense = 740;
		case 58: defense = 825;
		case 59: defense = 910;
		case 60: defense = 1015;
		case 61: defense = 900;
		case 62: defense = 990;
		case 63: defense = 1105;
		case 64: defense = 1235;
		case 65: defense = 1490;
		case 66: defense = 1780;
		case 67: defense = 2115;
		case 68: defense = 2550;
		case 69: defense = 2990;

		case 70: defense = 33;
		case 71: defense = 67;
		case 72: defense = 87;
		case 73: defense = 93;
		case 74: defense = 120;
		case 75: defense = 147;
		case 76: defense = 177;
		case 77: defense = 220;
		case 78: defense = 190;
		case 79: defense = 233;
		case 80: defense = 273;
		case 81: defense = 257;
		case 82: defense = 300;
		case 83: defense = 330;
		case 84: defense = 320;
		case 85: defense = 377;
		case 86: defense = 413;
		case 87: defense = 467;
		case 88: defense = 393;
		case 89: defense = 450;
		case 90: defense = 507;
		case 91: defense = 567;
		case 92: defense = 493;
		case 93: defense = 550;
		case 94: defense = 607;
		case 95: defense = 677;
		case 96: defense = 600;
		case 97: defense = 660;
		case 98: defense = 737;
		case 99: defense = 823;
		case 100: defense = 993;
		case 101: defense = 1187;
		case 102: defense = 1410;
		case 103: defense = 1700;
		case 104: defense = 1993;

		case 128: defense = 25;
		case 129: defense = 35;
		case 130: defense = 70;
		case 131: defense = 110;
		case 132: defense = 150;
		case 133: defense = 240;
		case 134: defense = 355;
		case 135: defense = 490;
		case 136: defense = 670;
		case 137: defense = 810;
		case 138: defense = 1045;
		case 139: defense = 1320;
		case 140: defense = 1610;
		case 141: defense = 1865;
		case 142: defense = 620;
		case 143: defense = 795;
		case 144: defense = 1005;
		case 145: defense = 1290;
		case 146: defense = 1575;
		case 147: defense = 1830;
		case 148: defense = 2355;
		case 149: defense = 2710;
		case 150: defense = 3235;

    case 266: defense = 910;
		case 267: defense = 1105;
		case 268: defense = 1319;
		case 269: defense = 1606;
		case 270: defense = 1937;
		case 271: defense = 2314;
		case 272: defense = 2750;
		case 273: defense = 3315;
		case 274: defense = 3887;

    case 275: defense = 607;
		case 276: defense = 737;
		case 277: defense = 880;
		case 278: defense = 1070;
		case 279: defense = 1291;
		case 280: defense = 1543;
		case 281: defense = 1833;
		case 282: defense = 2210;
		case 283: defense = 2591;

		default: defense = 100;
	}

	if(stage > 0)
	{
		new Float:mul;
		mul = floatadd(1, floatdiv(stage, 10));
		defense = floatround(floatmul(defense, mul));
	}

	return defense;
}

stock GetEquipModifiedValue(base_value, mod_level)
{
	new Float:multiplicator;
	switch(mod_level)
	{
		case 1: multiplicator = 1.03;
		case 2: multiplicator = 1.06;
		case 3: multiplicator = 1.1;
		case 4: multiplicator = 1.15;
		case 5: multiplicator = 1.2;
		case 6: multiplicator = 1.27;
		case 7: multiplicator = 1.4;
		case 8: multiplicator = 1.55;
		case 9: multiplicator = 1.75;
		case 10: multiplicator = 2.05;
		case 11: multiplicator = 2.45;
		case 12: multiplicator = 2.9;
		case 13: multiplicator = 3.4;
		default: multiplicator = 1;
	}

	return floatround(floatmul(base_value, multiplicator));
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

stock GetDefCount(level)
{
	new count = 0;
	switch(level)
	{
		case 4: count = 1;
		case 5: count = 3;
		case 6: count = 6;
		case 7: count = 9;
		case 8: count = 12;
		case 9: count = 14;
		case 10: count = 16;
		case 11: count = 18;
		case 12: count = 21;
		case 13: count = 23;
		default: count = 0;
	}

	return count;
}

stock GetPropertyString(prop, value)
{
	new string[128];
	switch(prop) 
	{
		case PROPERTY_DAMAGE: format(string, sizeof(string), "Сила атаки +%d%%", value);
		case PROPERTY_DEFENSE: format(string, sizeof(string), "Защита +%d%%", value);
		case PROPERTY_DODGE: format(string, sizeof(string), "Уклонение +%d", value);
		case PROPERTY_ACCURACY: format(string, sizeof(string), "Точность +%d", value);
		case PROPERTY_HP: format(string, sizeof(string), "Макс ХП +%d%%", value);
		case PROPERTY_CRIT: format(string, sizeof(string), "Шанс крита +%d%%", value);
		case PROPERTY_LOOT: format(string, sizeof(string), "Лут с боссов X%d", value);
		case PROPERTY_HEAL: string = "Исцеление";
		case PROPERTY_INVUL: string = "Неуязвимость";
		case PROPERTY_MAXHP: format(string, sizeof(string), "HP +%d", value);
		case PROPERTY_VAMP: format(string, sizeof(string), "Поглощение ХП +%d%%", value);
		case PROPERTY_REGEN: string = "Восстановление";
    case PROPERTY_PARADOX: string = "Временной парадокс";
		default: string = "";
	}

	return string;
}

stock GetSpecialStatString(stat)
{
	new item[StatItem];
	item = GetStat(stat);

	new string[255];
	format(string, sizeof(string), "%s", item[Text]);
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
		case GRADE_B: color = "42a517";
		case GRADE_C: color = "1155cc";
		case GRADE_R: color = "9900ff";
		case GRADE_S: color = "e69138";
    case GRADE_F: color = "d53333";
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
	    case 300..699: interval = "Камень";
	    case 700..1199: interval = "Железо";
	    case 1200..1399: interval = "Бронза";
	    case 1400..1599: interval = "Серебро";
	    case 1600..1899: interval = "Золото";
	    case 1900..2299: interval = "Платина";
	    case 2300..2699: interval = "Алмаз";
	    case 2700..3099: interval = "Бриллиант";
			case 3100..3499: interval = "Мастер";
			case 3500..4199: interval = "Грандмастер";
			case 4200..4999: interval = "Претендент";
			case 5000..5999: interval = "Чемпион";
			case 6000..9000: interval = "Легенда";
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
			case 10: interval = "Мастер";
			case 11: interval = "Грандмастер";
			case 12: interval = "Претендент";
			case 13: interval = "Чемпион";
			case 14: interval = "Легенда";
	    default: interval = "Дерево";
	}
	return interval;
}

stock GetRankByRate(rate)
{
	new rank;
	switch(rate)
	{
		case 300..699: rank = 2;
		case 700..1199: rank = 3;
		case 1200..1399: rank = 4;
		case 1400..1599: rank = 5;
		case 1600..1899: rank = 6;
		case 1900..2299: rank = 7;
		case 2300..2699: rank = 8;
		case 2700..3099: rank = 9;
		case 3100..3499: rank = 10;
		case 3500..4199: rank = 11;
		case 4200..4999: rank = 12;
		case 5000..5999: rank = 13;
		case 6000..9000: rank = 14;
		default: rank = 1;
	}
	return rank;
}

stock LoadItemsDatabase()
{
  items_database_loaded = false;

	new query[255] = "SELECT * FROM `items` WHERE 1";
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
	cache_get_row_count(row_count);
	if(row_count <= 0)
	{
    print("LoadItemsDatabase error");
		cache_delete(q_result);
		return;
	}

	new id;
  new item[BaseItem];
  new string[255];
	for(new i = 0; i < row_count; i++)
	{
    cache_get_value_name_int(i, "ID", id);
    item[ID] = id;

    cache_get_value_name_int(i, "IsTradeble", item[IsTradeble]);
    cache_get_value_name(i, "Name", string);
    sscanf(string, "s[255]", item[Name]);
    cache_get_value_name_int(i, "Type", item[Type]);
    cache_get_value_name_int(i, "Grade", item[Grade]);
    cache_get_value_name_int(i, "MinRank", item[MinRank]);
    cache_get_value_name(i, "Description", string);
    sscanf(string, "s[255]", item[Description]);
    cache_get_value_name(i, "Property", string);
    sscanf(string, "a<i>[3]", item[Property]);
    cache_get_value_name(i, "PropertyVal", string);
    sscanf(string, "a<i>[3]", item[PropertyVal]);
    cache_get_value_name_int(i, "Price", item[Price]);
    cache_get_value_name_int(i, "Model", item[Model]);
    cache_get_value_name_int(i, "ModelRotX", item[ModelRotX]);
    cache_get_value_name_int(i, "ModelRotY", item[ModelRotY]);
    cache_get_value_name_int(i, "ModelRotZ", item[ModelRotZ]);

    if(id >= MAX_ITEM_ID)
    {
      print("LoadItemsDatabase error: MAX_ITEM_ID too low");
      cache_delete(q_result);
      return;
    }

    ItemsDatabase[id] = item;
	}

	cache_delete(q_result);

  print("LoadItemsDatabase OK");
  items_database_loaded = true;
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

	new query[4096] = "UPDATE `players` SET ";
	new tmp[384];

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
	format(tmp, sizeof(tmp), "`WeaponStage` = '%d', `ArmorStage` = '%d', `HatStage` = '%d', `GlassesStage` = '%d', `WatchStage` = '%d', ", PlayerInfo[playerid][WeaponStage], 
		PlayerInfo[playerid][ArmorStage], PlayerInfo[playerid][HatStage], PlayerInfo[playerid][GlassesStage], PlayerInfo[playerid][WatchStage]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`WeaponMod` = '%d', `ArmorMod` = '%d', ", PlayerInfo[playerid][WeaponMod], PlayerInfo[playerid][ArmorMod]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`HatMod` = '%d', `GlassesMod` = '%d', `WatchMod` = '%d', ", PlayerInfo[playerid][HatMod], PlayerInfo[playerid][GlassesMod], PlayerInfo[playerid][WatchMod]);
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`WeaponStats` = '%s', `ArmorStats` = '%s', ", ArrayToString(PlayerInfo[playerid][WeaponStats], MAX_STATS), ArrayToString(PlayerInfo[playerid][ArmorStats], MAX_STATS));
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`HatStats` = '%s', `GlassesStats` = '%s', `WatchStats` = '%s', ", ArrayToString(PlayerInfo[playerid][HatStats], MAX_STATS), ArrayToString(PlayerInfo[playerid][GlassesStats], MAX_STATS), ArrayToString(PlayerInfo[playerid][WatchStats], MAX_STATS));
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`Ring1Stats` = '%s', `Ring2Stats` = '%s', ", ArrayToString(PlayerInfo[playerid][Ring1Stats], MAX_STATS), ArrayToString(PlayerInfo[playerid][Ring2Stats], MAX_STATS));
	strcat(query, tmp);
	format(tmp, sizeof(tmp), "`Amulette1Stats` = '%s', `Amulette2Stats` = '%s' ", ArrayToString(PlayerInfo[playerid][Amulette1Stats], MAX_STATS), ArrayToString(PlayerInfo[playerid][Amulette2Stats], MAX_STATS));
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
		format(query, sizeof(query), "INSERT INTO `inventories`(`PlayerName`, `SlotID`, `ItemID`, `SlotMod`, `SlotStats`, `Stage`, `Count`) VALUES ('%s','%d','%d','%d','%s','%d','%d')",
			name, i, -1, 0, "-1 -1 -1 -1 -1 -1 -1", 0, 0
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
		format(query, sizeof(query), "UPDATE `inventories` SET `ItemID` = '%d', `SlotMod` = '%d', `SlotStats` = '%s', `Stage` = '%d', `Count` = '%d' WHERE `PlayerName` = '%s' AND `SlotID` = '%d' LIMIT 1", 
			PlayerInventory[playerid][i][ID], PlayerInventory[playerid][i][Mod], ArrayToString(PlayerInventory[playerid][i][Stats], MAX_STATS), PlayerInventory[playerid][i][Stage], PlayerInventory[playerid][i][Count], name, i
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
		cache_get_value_name_int(i, "SlotMod", PlayerInventory[playerid][slot_id][Mod]);
		cache_get_value_name_int(i, "Stage", PlayerInventory[playerid][slot_id][Stage]);
		cache_get_value_name_int(i, "Count", PlayerInventory[playerid][slot_id][Count]);

		new string[255];
		cache_get_value_name(i, "SlotStats", string);
		sscanf(string, "a<i>[7]", PlayerInventory[playerid][slot_id][Stats]);
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
	cache_get_value_name_int(0, "WeaponStage", PlayerInfo[playerid][WeaponStage]);
	cache_get_value_name_int(0, "ArmorStage", PlayerInfo[playerid][ArmorStage]);
	cache_get_value_name_int(0, "HatStage", PlayerInfo[playerid][HatStage]);
	cache_get_value_name_int(0, "GlassesStage", PlayerInfo[playerid][GlassesStage]);
	cache_get_value_name_int(0, "WatchStage", PlayerInfo[playerid][WatchStage]);
	cache_get_value_name_int(0, "WeaponMod", PlayerInfo[playerid][WeaponMod]);
	cache_get_value_name_int(0, "ArmorMod", PlayerInfo[playerid][ArmorMod]);
	cache_get_value_name_int(0, "HatMod", PlayerInfo[playerid][HatMod]);
	cache_get_value_name_int(0, "GlassesMod", PlayerInfo[playerid][GlassesMod]);
	cache_get_value_name_int(0, "WatchMod", PlayerInfo[playerid][WatchMod]);

	new owner[255];
	cache_get_value_name(0, "Owner", owner);
	sscanf(owner, "s[255]", PlayerInfo[playerid][Owner]);

	new string[255];
	cache_get_value_name(0, "WeaponStats", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][WeaponStats]);
	cache_get_value_name(0, "ArmorStats", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][ArmorStats]);
	cache_get_value_name(0, "HatStats", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][HatStats]);
	cache_get_value_name(0, "GlassesStats", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][GlassesStats]);
	cache_get_value_name(0, "WatchStats", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][WatchStats]);
	cache_get_value_name(0, "Ring1Stats", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][Ring1Stats]);
	cache_get_value_name(0, "Ring2Stats", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][Ring2Stats]);
	cache_get_value_name(0, "Amulette1Stats", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][Amulette1Stats]);
	cache_get_value_name(0, "Amulette2Stats", string);
	sscanf(string, "a<i>[7]", PlayerInfo[playerid][Amulette2Stats]);

	cache_delete(q_result);

	LoadInventory(playerid);
	UpdatePlayerRank(playerid);
 	return 1;
}

stock CreatePlayer(playerid, name[], owner[], sex)
{
	new query[4096] = "INSERT INTO `players`( \
		`ID`, `Name`, `Owner`, `Sex`, `Rate`, `Rank`, `Status`, `Simulations`, `IsWatcher`, `Cash`, \
		`PosX`, `PosY`, `PosZ`, `Angle`, `Interior`, `Skin`, `Kills`, `Deaths`, `DamageMin`, `DamageMax`, `Defense`, ";

	new query2[512] = "`Dodge`, `Accuracy`, `Crit`, `GlobalTopPos`, `LocalTopPos`, `WalkersLimit`, `WeaponSlotID`, `WeaponMod`, \
		`ArmorSlotID`, `ArmorMod`, `HatSlotID`, `HatMod`, `GlassesSlotID`, `GlassesMod`, `WatchSlotID`, `WatchMod`, \
		`RingSlot1ID`, `RingSlot2ID`, `AmuletteSlot1ID`, `AmuletteSlot2ID`, ";

	new query3[512] = "`WeaponStage`, `ArmorStage`, `HatStage`, `GlassesStage`, `WatchStage`, \
		`WeaponStats`, `ArmorStats`, `HatStats`, `GlassesStats`, `WatchStats`, `Ring1Stats`, `Ring2Stats`, `Amulette1Stats`, `Amulette2Stats`) VALUES (";

	strcat(query, query2);
	strcat(query, query3);

	new tmp[2048];

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
        '%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d', \
				'%d','%d','%d','%d','%d','%s','%s','%s','%s','%s','%s','%s','%s','%s')",
		id, name, owner, sex, 0, 1, 0, 0, 0, 0, DEFAULT_POS_X, DEFAULT_POS_Y, DEFAULT_POS_Z, 180, 1, 78, 0, 0, 13, 15, 5, 0, 5, 5, 20, 10, MAX_WALKERS, 
        DEFAULT_WEAPON_ID, 0, DEFAULT_ARMOR_ID, 0, DEFAULT_HAT_ID, 0, -1, 0, -1, 0, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0,
				"-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", 
				"-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1"
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

	new query[4096] = "INSERT INTO `players`( \
		`ID`, `Name`, `Owner`, `Sex`, `Rate`, `Rank`, `Status`, `Simulations`, `IsWatcher`, `Cash`, \
		`PosX`, `PosY`, `PosZ`, `Angle`, `Interior`, `Skin`, `Kills`, `Deaths`, `DamageMin`, `DamageMax`, `Defense`, ";

	new query2[512] = "`Dodge`, `Accuracy`, `Crit`, `GlobalTopPos`, `LocalTopPos`, `WalkersLimit`, `WeaponSlotID`, `WeaponMod`, \
		`ArmorSlotID`, `ArmorMod`, `HatSlotID`, `HatMod`, `GlassesSlotID`, `GlassesMod`, `WatchSlotID`, `WatchMod`, \
		`RingSlot1ID`, `RingSlot2ID`, `AmuletteSlot1ID`, `AmuletteSlot2ID`, ";

	new query3[512] = "`WeaponStage`, `ArmorStage`, `HatStage`, `GlassesStage`, `WatchStage`, \
		`WeaponStats`, `ArmorStats`, `HatStats`, `GlassesStats`, `WatchStats`, `Ring1Stats`, `Ring2Stats`, `Amulette1Stats`, `Amulette2Stats`) VALUES (";

	strcat(query, query2);
	strcat(query, query3);
	
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
        '%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d', \
				'%d','%d','%d','%d','%d','%s','%s','%s','%s','%s','%s','%s','%s','%s')",
		id, name, login, 0, 0, 1, 0, 0, 1, 0, DEFAULT_POS_X, DEFAULT_POS_Y, DEFAULT_POS_Z, 180, 1, 78, 0, 0, 13, 15, 5, 0, 5, 5, 20, 10, MAX_WALKERS, 
        DEFAULT_WEAPON_ID, 0, DEFAULT_ARMOR_ID, 0, DEFAULT_HAT_ID, 0, -1, 0, -1, 0, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0,
				"-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", 
				"-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1", "-1 -1 -1 -1 -1 -1 -1"
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
		case 300..699: color = RateColors[1];
		case 700..1199: color = RateColors[2];
		case 1200..1399: color = RateColors[3];
		case 1400..1599: color = RateColors[4];
		case 1600..1899: color = RateColors[5];
		case 1900..2299: color = RateColors[6];
		case 2300..2699: color = RateColors[7];
		case 2700..3099: color = RateColors[8];
		case 3100..3499: color = RateColors[9];
		case 3500..4199: color = RateColors[10];
		case 4200..4999: color = RateColors[11];
		case 5000..5999: color = RateColors[12];
		case 6000..9000: color = RateColors[13];
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
		case 10: color = RateColors[9];
		case 11: color = RateColors[10];
		case 12: color = RateColors[11];
		case 13: color = RateColors[12];
		case 14: color = RateColors[13];
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
		GivePlayerCash(playerid, money);
	else
		GivePlayerMoneyOffline(name, money);
}

stock MakeLottery()
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `players` WHERE `Owner` <> 'Admin' AND `IsWatcher`=0 LIMIT %d", MAX_PARTICIPANTS);
	new Cache:q_result = mysql_query(sql_handle, query);

	new row_count = 0;
  cache_get_row_count(row_count);
  if(row_count <= 0)
  {
    print("Lottery making error.");
    cache_delete(q_result);
    return;
  }

  new row = random(row_count);

  new name[255];
	cache_get_value_name(row, "Name", name);
  cache_delete(q_result);

  PendingItem(name, 1067, "Поздравляем! Вы выиграли в лотерее!", STATS_CLEAR, 1);

  SendClientMessageToAll(COLOR_WHITE, "");
	SendClientMessageToAll(COLOR_WHITE, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
  SendClientMessageToAll(COLOR_WHITE, "");

  new str[255];
  format(str, sizeof(str), "%s - поздравляем победителя!!!", name);
  SendClientMessageToAll(0xFFCC00FF, "Проведена всемогущая лотерея им. Шажка!");
  SendClientMessageToAll(COLOR_WHITE, str);

  SendClientMessageToAll(COLOR_WHITE, "");
  SendClientMessageToAll(COLOR_WHITE, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
  SendClientMessageToAll(COLOR_WHITE, "");
}

stock UpdateVoteStatus(status)
{
  new query[255];
  format(query, sizeof(query), "UPDATE `tournament` SET `VoteActive`= %d", status);
  new Cache:q_result = mysql_query(sql_handle, query);
  cache_delete(q_result);
}

stock ResetVotingResults()
{
  new query[255] = "DELETE FROM `vote` WHERE 1";
  new Cache:q_result = mysql_query(sql_handle, query);
  cache_delete(q_result);
}

stock UpdateHierarchy()
{
	PatriarchPayday();

	UpdateGlobalRatingTop();
	ResetHierarchy();
  UpdateVoteStatus(0);

  new query[255] = "SELECT `CandidateName`, SUM(`Count`) as `sum_count` FROM `vote` GROUP BY `CandidateName` ORDER BY `sum_count` DESC";
  new Cache:q_result = mysql_query(sql_handle, query);

  new row_count = 0;
  cache_get_row_count(row_count);
  if(row_count <= 0)
  {
    cache_delete(q_result);
    return;
  }

  q_result = cache_save();
	cache_unset_active();

	new pretendets[HIERARCHY_STATUSES_COUNT];
	for(new i = 0; i < HIERARCHY_STATUSES_COUNT; i++)
	{
    if(i >= row_count - 1)
    {
      pretendets[i] = -1;
      continue;
    }

    cache_set_active(q_result);

		new name[255];

    cache_get_value_name(i, "CandidateName", name);
      
    new player[pInfo];
		player = GetPlayerByName(name);

		pretendets[i] = player[ID];
	}

  cache_delete(q_result);

	SendClientMessageToAll(COLOR_WHITE, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	SendClientMessageToAll(COLOR_WHITE, "Выборы в Иерархию завершились!");
	SendClientMessageToAll(COLOR_YELLOW, "Новые лидеры:");
	SendClientMessageToAll(COLOR_WHITE, "");

	for(new i = 0; i < HIERARCHY_STATUSES_COUNT; i++)
	{
    if(pretendets[i] == -1)
      break;

		new squery[255];
		format(squery, sizeof(squery), "UPDATE `players` SET `Status` = '%d' WHERE `ID` = '%d' LIMIT 1", i+1, pretendets[i]);
		new Cache:temp_result = mysql_query(sql_handle, squery);
		cache_delete(temp_result);

		format(squery, sizeof(squery), "SELECT * FROM `players` WHERE `ID` = '%d' LIMIT 1", pretendets[i]);
		new Cache:sq_result = mysql_query(sql_handle, squery);

		new row_count = 0;
		cache_get_row_count(row_count);
		if(row_count <= 0)
		{
			print("Hierarchy update error.");
			cache_delete(sq_result);
			return;
		}

		new name[255];
		cache_get_value_name(0, "Name", name);
		cache_delete(sq_result);

		if(i+1 == HIERARCHY_LEADER)
		{
			PendingItem(name, 1036, "Награда Патриарха", STATS_CLEAR, 80);

			new p_query[255];
			format(p_query, sizeof(p_query), "UPDATE `hierarchy` SET `LeaderName` = '%s', `Money` = '0' LIMIT 1", name);
			new Cache:p_result = mysql_query(sql_handle, p_query);
			cache_delete(p_result);
		}
		else
		{
			PendingItem(name, 1036, "Награда основателя", STATS_CLEAR, 40);
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

  ResetVotingResults();
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

stock ShowCommandoMenu(playerid)
{
  new listitems[] = "Сведения об Иерархии\nСтатус голосования\nПодать заявку в Иерархию\nПроголосовать за кандидата";
  ShowPlayerDialog(playerid, 1600, DIALOG_STYLE_TABLIST, "Командующий", listitems, "Далее", "Закрыть");
}

stock IsVoteActive()
{
  new query[255] = "SELECT * FROM `tournament` LIMIT 1";
  new Cache:q_result = mysql_query(sql_handle, query);

  new row_count = 0;
  cache_get_row_count(row_count);
  if(row_count <= 0)
  {
    cache_delete(q_result);
    return false;
  }

  new active = 0;
  cache_get_value_name_int(0, "VoteActive", active);

  cache_delete(q_result);

  if(active > 0)
    return true;

  return false;
}

stock GetVotesSum()
{
  new query[255] = "SELECT SUM(`Count`) as `sum` FROM `vote`";
  new Cache:q_result = mysql_query(sql_handle, query);

  new row_count = 0;
  cache_get_row_count(row_count);
  if(row_count <= 0)
  {
    cache_delete(q_result);
    return 0;
  }

  new sum = 0;
  cache_get_value_name_int(0, "sum", sum);

  cache_delete(q_result);
  return sum;
}

stock ShowVoteStatus(playerid)
{
  if(!IsVoteActive())
  {
    SendClientMessage(playerid, COLOR_GREY, "Сейчас голосование не проводится");
    ShowCommandoMenu(playerid);
    return;
  }

  new query[255] = "SELECT `CandidateName`, SUM(`Count`) as `sum_count` FROM `vote` GROUP BY `CandidateName` ORDER BY `sum_count` DESC";
  new Cache:q_result = mysql_query(sql_handle, query);

  new row_count = 0;
  cache_get_row_count(row_count);
  if(row_count <= 0)
  {
    SendClientMessage(playerid, COLOR_GREY, "Не зарегистрировано ни одного кандидата");
    ShowCommandoMenu(playerid);
    cache_delete(q_result);
    return;
  }

  q_result = cache_save();
	cache_unset_active();

  new all_votes_count = GetVotesSum();

  new result[4000] = "№ п\\п\tИмя\tРейтинг\tГолосов";
	new string[455];

	for(new i = 0; i < row_count; i++)
	{
		cache_set_active(q_result);

		new name[255];
		new count = 0;

    cache_get_value_name(i, "CandidateName", name);
		cache_get_value_name_int(i, "sum_count", count);

		new player[pInfo];
		player = GetPlayerByName(name);

    format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t{ffffff}%d\t%d%%", 
			GetPlaceColor(i+1), i+1, GetColorByRate(player[Rate]), name, player[Rate], floatround(floatmul(100, floatdiv(count, all_votes_count)))
		);
		strcat(result, string);
	}

	cache_delete(q_result);

  ShowPlayerDialog(playerid, 1601, DIALOG_STYLE_TABLIST_HEADERS, "Статус голосования", result, "Назад", "Закрыть");
}

stock IsPlayerInVote(playerid)
{
  new query[255];
  format(query, sizeof(query), "SELECT * FROM `vote` WHERE `CandidateName` = '%s'", PlayerInfo[playerid][Name]);
  new Cache:q_result = mysql_query(sql_handle, query);

  new row_count = 0;
  cache_get_row_count(row_count);
  if(row_count <= 0)
  {
    cache_delete(q_result);
    return false;
  }

  return true;
}

stock VoteSignUp(playerid)
{
  if(IsVoteActive())
  {
    SendClientMessage(playerid, COLOR_GREY, "Сейчас регистрация не проводится");
    ShowCommandoMenu(playerid);
    return;
  }

  if(IsPlayerInVote(playerid))
  {
    SendClientMessage(playerid, COLOR_GREY, "Вы уже зарегистрированы");
    ShowCommandoMenu(playerid);
    return;
  }

  new reg_price = 100000;

  if(PlayerInfo[playerid][Cash] < reg_price)
  {
    SendClientMessage(playerid, COLOR_GREY, "Недостаточно средств");
    ShowCommandoMenu(playerid);
    return;
  }

  if(!HasItem(playerid, 1071, 1))
  {
    SendClientMessage(playerid, COLOR_GREY, "Требуется бюллетень для голосования");
    ShowCommandoMenu(playerid);
    return;
  }

  new bul_slot = FindItem(playerid, 1071);
  if(bul_slot == -1)
  {
    SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка регистрации.");
    return;
  }

  DeleteItem(playerid, bul_slot, 1);

  PlayerInfo[playerid][Cash] -= reg_price;
  GivePlayerCash(playerid, -reg_price);
  GivePatriarchMoney(reg_price);

  
  new votes_count = 1;
  if(PlayerInfo[playerid][GlobalTopPosition] > 0)
    votes_count = MAX_PARTICIPANTS - PlayerInfo[playerid][GlobalTopPosition] + 1;


  new query[255];
  format(query, sizeof(query), "INSERT INTO `vote`(`VoteName`, `CandidateName`, `Count`) VALUES ('%s', '%s', %d)", PlayerInfo[playerid][Name], PlayerInfo[playerid][Name], votes_count);
  new Cache:q_result = mysql_query(sql_handle, query);
  cache_delete(q_result);

  SendClientMessage(playerid, COLOR_GREEN, "Успешная регистрация");
}

stock ShowVoteList(playerid)
{
  if(!IsVoteActive())
  {
    SendClientMessage(playerid, COLOR_GREY, "Сейчас голосование не проводится");
    ShowCommandoMenu(playerid);
    return;
  }

  if(!HasItem(playerid, 1071, 1))
  {
    SendClientMessage(playerid, COLOR_GREY, "Нет бюллетеней для голосования");
    ShowCommandoMenu(playerid);
    return;
  }

  new query[255] = "SELECT `CandidateName`, SUM(`Count`) as `sum_count` FROM `vote` GROUP BY `CandidateName` ORDER BY `ID`";
  new Cache:q_result = mysql_query(sql_handle, query);

  new row_count = 0;
  cache_get_row_count(row_count);
  if(row_count <= 0)
  {
    SendClientMessage(playerid, COLOR_GREY, "Не зарегистрировано ни одного кандидата");
    ShowCommandoMenu(playerid);
    cache_delete(q_result);
    return;
  }

  q_result = cache_save();
	cache_unset_active();

  new all_votes_count = GetVotesSum();

  new result[4000] = "№ п\\п\tИмя\tРейтинг\tГолосов";
	new string[455];

	for(new i = 0; i < row_count; i++)
	{
		cache_set_active(q_result);

		new name[255];
		new count = 0;

    cache_get_value_name(i, "CandidateName", name);
		cache_get_value_name_int(i, "sum_count", count);

		new player[pInfo];
		player = GetPlayerByName(name);

    format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t{ffffff}%d\t%d%%", 
			GetPlaceColor(i+1), i+1, GetColorByRate(player[Rate]), name, player[Rate], floatround(floatmul(100, floatdiv(count, all_votes_count)))
		);
		strcat(result, string);
	}

	cache_delete(q_result);

  ShowPlayerDialog(playerid, 1602, DIALOG_STYLE_TABLIST_HEADERS, "Голосование", result, "Голосовать", "Назад");
}

stock TryVoteTo(playerid, listitem)
{
  new query[255] = "SELECT `CandidateName`, SUM(`Count`) as `sum_count` FROM `vote` GROUP BY `CandidateName` ORDER BY `ID`";
  new Cache:q_result = mysql_query(sql_handle, query);

  new row_count = 0;
  cache_get_row_count(row_count);
  if(row_count <= 0)
  {
    SendClientMessage(playerid, COLOR_GREY, "Не зарегистрировано ни одного кандидата");
    ShowCommandoMenu(playerid);
    cache_delete(q_result);
    return;
  }

  new name[255];
  cache_get_value_name(listitem, "CandidateName", name);
  sscanf(name, "s[255]", CandidateNameBuffer[playerid]);

  cache_delete(q_result);

  new bul_slot = FindItem(playerid, 1071);
  if(bul_slot == -1)
  {
    SendClientMessage(playerid, COLOR_GREY, "Нет бюллетеней для голосования");
    ShowCommandoMenu(playerid);
    return;
  }

  new popup_info[512];
  format(popup_info, sizeof(popup_info), "Укажите количество голосов\nДоступно голосов: %d", PlayerInventory[playerid][bul_slot][Count]);

  ShowPlayerDialog(playerid, 1603, DIALOG_STYLE_INPUT, "Голосование", popup_info, "Голосовать", "Назад");
}

stock DoVote(playerid, candidate_name[], count)
{
  new bul_slot = FindItem(playerid, 1071);
  if(bul_slot == -1)
  {
    SendClientMessage(playerid, COLOR_LIGHTRED, "Ошибка голосования.");
    return;
  }

  DeleteItem(playerid, bul_slot, count);

  new query[255];
  format(query, sizeof(query), "INSERT INTO `vote`(`VoteName`, `CandidateName`, `Count`) VALUES ('%s', '%s', %d)", PlayerInfo[playerid][Name], candidate_name, count);
  new Cache:q_result = mysql_query(sql_handle, query);
  cache_delete(q_result);

  SendClientMessage(playerid, COLOR_GREEN, "Ваши голоса учтены");
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
    new assists = 0;
		new r_diff = 0;
		cache_get_value_name_int(i, "ID", id);
		cache_get_value_name_int(i, "Score", score);
		cache_get_value_name_int(i, "Kills", kills);
		cache_get_value_name_int(i, "Deaths", deaths);
    cache_get_value_name_int(i, "Assists", assists);
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
    TournamentTab[i][Assists] = assists;
		TournamentTab[i][Pos] = i+1;
	}

	cache_delete(q_result);

	new top[4000] = "№ п\\п\tИмя\tK/D/A\tОчки (рейтинг)";
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

		format(string, sizeof(string), "\n{%s}%d\t{%s}%s\t{00CC00}%d{ffffff}/{CC0000}%d{ffffff}/{FFCC00}%d\t{9900CC}%d {ffffff}({%s}%s{ffffff})", 
			GetPlaceColor(i+1), i+1, GetColorByRate(TournamentTab[i][Rate]), TournamentTab[i][Name],
			TournamentTab[i][Kills], TournamentTab[i][Deaths], TournamentTab[i][Assists], TournamentTab[i][Score], rate_color, rate_str
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
		case 10: time = 55000;
		case 11: time = 60000;
		case 12: time = 65000;
		case 13: time = 70000;
		case 14: time = 75000;
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
	PlayerInfo[playerid][WeaponSlotID] = DEFAULT_WEAPON_ID;
	PlayerInfo[playerid][ArmorSlotID] = DEFAULT_ARMOR_ID;
	PlayerInfo[playerid][HatSlotID] = DEFAULT_HAT_ID;
	PlayerInfo[playerid][GlassesSlotID] = -1;
	PlayerInfo[playerid][WatchSlotID] = -1;
	PlayerInfo[playerid][RingSlot1ID] = -1;
	PlayerInfo[playerid][RingSlot2ID] = -1;
	PlayerInfo[playerid][AmuletteSlot1ID] = -1;
	PlayerInfo[playerid][AmuletteSlot2ID] = -1;
	PlayerInfo[playerid][WeaponMod] = 0;
	PlayerInfo[playerid][ArmorMod] = 0;
	PlayerInfo[playerid][HatMod] = 0;
	PlayerInfo[playerid][GlassesMod] = 0;
	PlayerInfo[playerid][WatchMod] = 0;
	PlayerInfo[playerid][WeaponStats] = STATS_CLEAR;
	PlayerInfo[playerid][ArmorStats] = STATS_CLEAR;
	PlayerInfo[playerid][HatStats] = STATS_CLEAR;
	PlayerInfo[playerid][GlassesStats] = STATS_CLEAR;
	PlayerInfo[playerid][WatchStats] = STATS_CLEAR;
	PlayerInfo[playerid][Ring1Stats] = STATS_CLEAR;
	PlayerInfo[playerid][Ring2Stats] = STATS_CLEAR;
	PlayerInfo[playerid][Amulette1Stats] = STATS_CLEAR;
	PlayerInfo[playerid][Amulette2Stats] = STATS_CLEAR;
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
	new ver_txt[64];
	format(ver_txt, sizeof(ver_txt), "ver %.2f", VERSION);
	Version = TextDrawCreate(2.000000, 436.000000, ver_txt);
	TextDrawFont(Version, 2);
	TextDrawLetterSize(Version, 0.183329, 0.949998);
	TextDrawTextSize(Version, 400.000000, 17.000000);
	TextDrawSetOutline(Version, 0);
	TextDrawSetShadow(Version, 0);
	TextDrawAlignment(Version, 1);
	TextDrawColor(Version, 255);
	TextDrawBackgroundColor(Version, 255);
	TextDrawBoxColor(Version, 50);
	TextDrawUseBox(Version, 0);
	TextDrawSetProportional(Version, 1);
	TextDrawSetSelectable(Version, 0);
}

stock InitPlayerTextDraws(playerid)
{
	PlayerHPBar[playerid] = CreatePlayerProgressBar(playerid, 547.000000, 39.000000, 67.500000, 5.500000, -16776961, 100.000000, 0);
	SetPlayerProgressBarValue(playerid, PlayerHPBar[playerid], 100.000000);

	RankRing[playerid] = CreatePlayerTextDraw(playerid, 610.000000, 20.000000, "ld_beat:cring");
	PlayerTextDrawFont(playerid, RankRing[playerid], 4);
	PlayerTextDrawLetterSize(playerid, RankRing[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, RankRing[playerid], 31.500000, 38.000000);
	PlayerTextDrawSetOutline(playerid, RankRing[playerid], 1);
	PlayerTextDrawSetShadow(playerid, RankRing[playerid], 0);
	PlayerTextDrawAlignment(playerid, RankRing[playerid], 3);
	PlayerTextDrawColor(playerid, RankRing[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, RankRing[playerid], 255);
	PlayerTextDrawBoxColor(playerid, RankRing[playerid], 50);
	PlayerTextDrawUseBox(playerid, RankRing[playerid], 1);
	PlayerTextDrawSetProportional(playerid, RankRing[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, RankRing[playerid], 0);

	RankText[playerid] = CreatePlayerTextDraw(playerid, 626.000000, 32.000000, "14");
	PlayerTextDrawFont(playerid, RankText[playerid], 1);
	PlayerTextDrawLetterSize(playerid, RankText[playerid], 0.270831, 1.299999);
	PlayerTextDrawTextSize(playerid, RankText[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, RankText[playerid], 1);
	PlayerTextDrawSetShadow(playerid, RankText[playerid], 0);
	PlayerTextDrawAlignment(playerid, RankText[playerid], 2);
	PlayerTextDrawColor(playerid, RankText[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, RankText[playerid], 255);
	PlayerTextDrawBoxColor(playerid, RankText[playerid], 50);
	PlayerTextDrawUseBox(playerid, RankText[playerid], 0);
	PlayerTextDrawSetProportional(playerid, RankText[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, RankText[playerid], 0);

	PlayerNameText[playerid] = CreatePlayerTextDraw(playerid, 612.000000, 27.000000, "ShazokVsemog");
	PlayerTextDrawFont(playerid, PlayerNameText[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerNameText[playerid], 0.224999, 0.850000);
	PlayerTextDrawTextSize(playerid, PlayerNameText[playerid], 400.000000, 15.000000);
	PlayerTextDrawSetOutline(playerid, PlayerNameText[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerNameText[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerNameText[playerid], 3);
	PlayerTextDrawColor(playerid, PlayerNameText[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerNameText[playerid], 220);
	PlayerTextDrawBoxColor(playerid, PlayerNameText[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerNameText[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerNameText[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerNameText[playerid], 0);

	PlayerHPBarNumbers[playerid] = CreatePlayerTextDraw(playerid, 579.000000, 46.000000, "30.000/30.000");
	PlayerTextDrawFont(playerid, PlayerHPBarNumbers[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerHPBarNumbers[playerid], 0.220833, 0.899999);
	PlayerTextDrawTextSize(playerid, PlayerHPBarNumbers[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerHPBarNumbers[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerHPBarNumbers[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerHPBarNumbers[playerid], 2);
	PlayerTextDrawColor(playerid, PlayerHPBarNumbers[playerid], -16776961);
	PlayerTextDrawBackgroundColor(playerid, PlayerHPBarNumbers[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerHPBarNumbers[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerHPBarNumbers[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerHPBarNumbers[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerHPBarNumbers[playerid], 0);

	CashIcon[playerid] = CreatePlayerTextDraw(playerid, 622.000000, 59.000000, "HUD:radar_cash");
	PlayerTextDrawFont(playerid, CashIcon[playerid], 4);
	PlayerTextDrawLetterSize(playerid, CashIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, CashIcon[playerid], 12.000000, 14.000000);
	PlayerTextDrawSetOutline(playerid, CashIcon[playerid], 1);
	PlayerTextDrawSetShadow(playerid, CashIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, CashIcon[playerid], 2);
	PlayerTextDrawColor(playerid, CashIcon[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, CashIcon[playerid], 255);
	PlayerTextDrawBoxColor(playerid, CashIcon[playerid], 50);
	PlayerTextDrawUseBox(playerid, CashIcon[playerid], 1);
	PlayerTextDrawSetProportional(playerid, CashIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, CashIcon[playerid], 0);

	PlayerCashText[playerid] = CreatePlayerTextDraw(playerid, 620.000000, 61.000000, "25.000.000");
	PlayerTextDrawFont(playerid, PlayerCashText[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerCashText[playerid], 0.308333, 1.100000);
	PlayerTextDrawTextSize(playerid, PlayerCashText[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerCashText[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PlayerCashText[playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerCashText[playerid], 3);
	PlayerTextDrawColor(playerid, PlayerCashText[playerid], 2094792959);
	PlayerTextDrawBackgroundColor(playerid, PlayerCashText[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerCashText[playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerCashText[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerCashText[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerCashText[playerid], 0);

	ChrInfoBox[playerid] = CreatePlayerTextDraw(playerid, 539.000000, 82.000000, "_");
	PlayerTextDrawFont(playerid, ChrInfoBox[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfoBox[playerid], 0.629166, 35.799724);
	PlayerTextDrawTextSize(playerid, ChrInfoBox[playerid], 357.000000, 187.500000);
	PlayerTextDrawSetOutline(playerid, ChrInfoBox[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfoBox[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoBox[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfoBox[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoBox[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfoBox[playerid], 220);
	PlayerTextDrawUseBox(playerid, ChrInfoBox[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoBox[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoBox[playerid], 0);

	ChrInfoHeader[playerid] = CreatePlayerTextDraw(playerid, 544.000000, 82.000000, "Персонаж");
	PlayerTextDrawFont(playerid, ChrInfoHeader[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfoHeader[playerid], 0.312500, 1.149999);
	PlayerTextDrawTextSize(playerid, ChrInfoHeader[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfoHeader[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfoHeader[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoHeader[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfoHeader[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoHeader[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfoHeader[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfoHeader[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfoHeader[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoHeader[playerid], 0);

	ChrInfoClose[playerid] = CreatePlayerTextDraw(playerid, 628.000000, 81.000000, "X");
	PlayerTextDrawFont(playerid, ChrInfoClose[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfoClose[playerid], 0.404166, 1.399999);
	PlayerTextDrawTextSize(playerid, ChrInfoClose[playerid], 18.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfoClose[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfoClose[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoClose[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfoClose[playerid], -1962934017);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoClose[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfoClose[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoClose[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoClose[playerid], 1);

	ChrInfoDelim1[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 95.000000, "TextDraw");
	PlayerTextDrawFont(playerid, ChrInfoDelim1[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfoDelim1[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfoDelim1[playerid], 190.000000, 1.500000);
	PlayerTextDrawSetOutline(playerid, ChrInfoDelim1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoDelim1[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawBoxColor(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoDelim1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoDelim1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoDelim1[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfoDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfoDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfoDelim1[playerid], 0, 1);

	ChrInfoSkin[playerid] = CreatePlayerTextDraw(playerid, 560.000000, 95.000000, "TextDraw");
	PlayerTextDrawFont(playerid, ChrInfoSkin[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfoSkin[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfoSkin[playerid], 58.500000, 74.500000);
	PlayerTextDrawSetOutline(playerid, ChrInfoSkin[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfoSkin[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoSkin[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoSkin[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoSkin[playerid], 0);
	PlayerTextDrawBoxColor(playerid, ChrInfoSkin[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoSkin[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoSkin[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoSkin[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfoSkin[playerid], 1);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfoSkin[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfoSkin[playerid], 1, 1);

	ChrInfAmuletteSlot1[playerid] = CreatePlayerTextDraw(playerid, 606.000000, 102.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfAmuletteSlot1[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfAmuletteSlot1[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfAmuletteSlot1[playerid], 12.000000, 12.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfAmuletteSlot1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfAmuletteSlot1[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfAmuletteSlot1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAmuletteSlot1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAmuletteSlot1[playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, ChrInfAmuletteSlot1[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfAmuletteSlot1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfAmuletteSlot1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfAmuletteSlot1[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfAmuletteSlot1[playerid], 1274);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfAmuletteSlot1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfAmuletteSlot1[playerid], 1, 1);

	ChrInfAmuletteSlot2[playerid] = CreatePlayerTextDraw(playerid, 619.000000, 102.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfAmuletteSlot2[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfAmuletteSlot2[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfAmuletteSlot2[playerid], 12.000000, 12.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfAmuletteSlot2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfAmuletteSlot2[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfAmuletteSlot2[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAmuletteSlot2[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAmuletteSlot2[playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, ChrInfAmuletteSlot2[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfAmuletteSlot2[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfAmuletteSlot2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfAmuletteSlot2[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfAmuletteSlot2[playerid], 1274);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfAmuletteSlot2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfAmuletteSlot2[playerid], 1, 1);

	ChrInfRingSlot1[playerid] = CreatePlayerTextDraw(playerid, 606.000000, 115.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfRingSlot1[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfRingSlot1[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfRingSlot1[playerid], 12.000000, 12.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfRingSlot1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfRingSlot1[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfRingSlot1[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfRingSlot1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRingSlot1[playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, ChrInfRingSlot1[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfRingSlot1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfRingSlot1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfRingSlot1[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfRingSlot1[playerid], 1274);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfRingSlot1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfRingSlot1[playerid], 1, 1);

	ChrInfRingSlot2[playerid] = CreatePlayerTextDraw(playerid, 619.000000, 115.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfRingSlot2[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfRingSlot2[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfRingSlot2[playerid], 12.000000, 12.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfRingSlot2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfRingSlot2[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfRingSlot2[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfRingSlot2[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRingSlot2[playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, ChrInfRingSlot2[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfRingSlot2[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfRingSlot2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfRingSlot2[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfRingSlot2[playerid], 1274);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfRingSlot2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfRingSlot2[playerid], 1, 1);

	ChrInfGlassesSlot[playerid] = CreatePlayerTextDraw(playerid, 610.000000, 129.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfGlassesSlot[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfGlassesSlot[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfGlassesSlot[playerid], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfGlassesSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfGlassesSlot[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfGlassesSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfGlassesSlot[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfGlassesSlot[playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, ChrInfGlassesSlot[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfGlassesSlot[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfGlassesSlot[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfGlassesSlot[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfGlassesSlot[playerid], 1274);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfGlassesSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfGlassesSlot[playerid], 1, 1);

	ChrInfWatchSlot[playerid] = CreatePlayerTextDraw(playerid, 610.000000, 148.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfWatchSlot[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfWatchSlot[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfWatchSlot[playerid], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfWatchSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfWatchSlot[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfWatchSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfWatchSlot[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfWatchSlot[playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, ChrInfWatchSlot[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfWatchSlot[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfWatchSlot[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfWatchSlot[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfWatchSlot[playerid], 1274);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfWatchSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfWatchSlot[playerid], 1, 1);

	ChrInfHatSlot[playerid] = CreatePlayerTextDraw(playerid, 556.000000, 102.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfHatSlot[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfHatSlot[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfHatSlot[playerid], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfHatSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfHatSlot[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfHatSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfHatSlot[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfHatSlot[playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, ChrInfHatSlot[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfHatSlot[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfHatSlot[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfHatSlot[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfHatSlot[playerid], 1274);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfHatSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfHatSlot[playerid], 1, 1);

	ChrInfWeaponSlot[playerid] = CreatePlayerTextDraw(playerid, 556.000000, 148.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfWeaponSlot[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfWeaponSlot[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfWeaponSlot[playerid], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfWeaponSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfWeaponSlot[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfWeaponSlot[playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfWeaponSlot[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfWeaponSlot[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfWeaponSlot[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfWeaponSlot[playerid], 1274);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfWeaponSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfWeaponSlot[playerid], 1, 1);

	ChrInfArmorSlot[playerid] = CreatePlayerTextDraw(playerid, 556.000000, 125.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfArmorSlot[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfArmorSlot[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfArmorSlot[playerid], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfArmorSlot[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfArmorSlot[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfArmorSlot[playerid], -741092353);
	PlayerTextDrawBoxColor(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfArmorSlot[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfArmorSlot[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfArmorSlot[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfArmorSlot[playerid], 1274);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfArmorSlot[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfArmorSlot[playerid], 1, 1);

	ChrInfoDelim2[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 172.000000, "TextDraw");
	PlayerTextDrawFont(playerid, ChrInfoDelim2[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfoDelim2[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfoDelim2[playerid], 190.000000, 1.500000);
	PlayerTextDrawSetOutline(playerid, ChrInfoDelim2[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfoDelim2[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoDelim2[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoDelim2[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoDelim2[playerid], 0);
	PlayerTextDrawBoxColor(playerid, ChrInfoDelim2[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoDelim2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoDelim2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoDelim2[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfoDelim2[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfoDelim2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfoDelim2[playerid], 0, 1);

	ChrInfoDelim3[playerid] = CreatePlayerTextDraw(playerid, 543.000000, 93.000000, "TextDraw");
	PlayerTextDrawFont(playerid, ChrInfoDelim3[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfoDelim3[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfoDelim3[playerid], 1.500000, 80.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfoDelim3[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfoDelim3[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoDelim3[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoDelim3[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoDelim3[playerid], 0);
	PlayerTextDrawBoxColor(playerid, ChrInfoDelim3[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoDelim3[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoDelim3[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoDelim3[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfoDelim3[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfoDelim3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfoDelim3[playerid], 0, 1);

	ChrInfDamage[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 98.000000, "Attack: 9999 - 9999");
	PlayerTextDrawFont(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfDamage[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfDamage[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDamage[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDamage[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfDamage[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfDamage[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfDamage[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfDamage[playerid], 0);

	ChrInfDefense[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 104.000000, "Defense: 99999");
	PlayerTextDrawFont(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfDefense[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfDefense[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDefense[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDefense[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfDefense[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfDefense[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfDefense[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfDefense[playerid], 0);

	ChrInfAccuracy[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 110.000000, "Accuracy: 999");
	PlayerTextDrawFont(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfAccuracy[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfAccuracy[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfAccuracy[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAccuracy[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfAccuracy[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfAccuracy[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfAccuracy[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfAccuracy[playerid], 0);

	ChrInfDodge[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 116.000000, "Dodge: 999");
	PlayerTextDrawFont(playerid, ChrInfDodge[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfDodge[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfDodge[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfDodge[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDodge[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfDodge[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDodge[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDodge[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfDodge[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfDodge[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfDodge[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfDodge[playerid], 0);

	ChrInfCritChance[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 122.000000, "Crit chance: 999");
	PlayerTextDrawFont(playerid, ChrInfCritChance[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfCritChance[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfCritChance[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfCritChance[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfCritChance[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfCritChance[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfCritChance[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfCritChance[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfCritChance[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfCritChance[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfCritChance[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfCritChance[playerid], 0);

	ChrInfCritMult[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 128.000000, "Crit mult: 1.2");
	PlayerTextDrawFont(playerid, ChrInfCritMult[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfCritMult[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfCritMult[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfCritMult[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfCritMult[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfCritMult[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfCritMult[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfCritMult[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfCritMult[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfCritMult[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfCritMult[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfCritMult[playerid], 0);

	ChrInfCritMultReduction[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 134.000000, "Crit mult reduction: 0.30");
	PlayerTextDrawFont(playerid, ChrInfCritMultReduction[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfCritMultReduction[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfCritMultReduction[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfCritMultReduction[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfCritMultReduction[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfCritMultReduction[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfCritMultReduction[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfCritMultReduction[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfCritMultReduction[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfCritMultReduction[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfCritMultReduction[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfCritMultReduction[playerid], 0);

	ChrInfCritReduction[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 140.000000, "Crit reduction: 10%");
	PlayerTextDrawFont(playerid, ChrInfCritReduction[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfCritReduction[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfCritReduction[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfCritReduction[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfCritReduction[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfCritReduction[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfCritReduction[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfCritReduction[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfCritReduction[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfCritReduction[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfCritReduction[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfCritReduction[playerid], 0);

	ChrInfVamp[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 146.000000, "Vamp HP: 5%");
	PlayerTextDrawFont(playerid, ChrInfVamp[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfVamp[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfVamp[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfVamp[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfVamp[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfVamp[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfVamp[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfVamp[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfVamp[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfVamp[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfVamp[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfVamp[playerid], 0);

	ChrInfRegeneration[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 152.000000, "Regeneration: 3.5%");
	PlayerTextDrawFont(playerid, ChrInfRegeneration[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfRegeneration[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfRegeneration[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfRegeneration[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfRegeneration[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfRegeneration[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfRegeneration[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRegeneration[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfRegeneration[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfRegeneration[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfRegeneration[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfRegeneration[playerid], 0);

	ChrInfDamageReflection[playerid] = CreatePlayerTextDraw(playerid, 446.000000, 158.000000, "Damage reflection: 3%");
	PlayerTextDrawFont(playerid, ChrInfDamageReflection[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfDamageReflection[playerid], 0.174998, 0.699998);
	PlayerTextDrawTextSize(playerid, ChrInfDamageReflection[playerid], 582.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfDamageReflection[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfDamageReflection[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfDamageReflection[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfDamageReflection[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfDamageReflection[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfDamageReflection[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfDamageReflection[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfDamageReflection[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfDamageReflection[playerid], 0);

	ChrInfRateIcon[playerid] = CreatePlayerTextDraw(playerid, 519.000000, 178.000000, "HUD:radar_race");
	PlayerTextDrawFont(playerid, ChrInfRateIcon[playerid], 4);
	PlayerTextDrawLetterSize(playerid, ChrInfRateIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfRateIcon[playerid], 11.500000, 11.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfRateIcon[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfRateIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfRateIcon[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfRateIcon[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRateIcon[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfRateIcon[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfRateIcon[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfRateIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfRateIcon[playerid], 0);

	ChrInfRate[playerid] = CreatePlayerTextDraw(playerid, 545.000000, 176.000000, "3000");
	PlayerTextDrawFont(playerid, ChrInfRate[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfRate[playerid], 0.358332, 1.600000);
	PlayerTextDrawTextSize(playerid, ChrInfRate[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfRate[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfRate[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfRate[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfRate[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfRate[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfRate[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfRate[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfRate[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfRate[playerid], 0);

	ChrInfText1[playerid] = CreatePlayerTextDraw(playerid, 484.000000, 174.000000, "Общий");
	PlayerTextDrawFont(playerid, ChrInfText1[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfText1[playerid], 0.170833, 0.800000);
	PlayerTextDrawTextSize(playerid, ChrInfText1[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfText1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfText1[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfText1[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfText1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfText1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfText1[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfText1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfText1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfText1[playerid], 0);

	ChrInfText2[playerid] = CreatePlayerTextDraw(playerid, 595.000000, 174.000000, "Личный");
	PlayerTextDrawFont(playerid, ChrInfText2[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfText2[playerid], 0.170833, 0.800000);
	PlayerTextDrawTextSize(playerid, ChrInfText2[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfText2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfText2[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfText2[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfText2[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfText2[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfText2[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfText2[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfText2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfText2[playerid], 0);

	ChrInfAllRate[playerid] = CreatePlayerTextDraw(playerid, 484.000000, 181.000000, "20");
	PlayerTextDrawFont(playerid, ChrInfAllRate[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfAllRate[playerid], 0.279166, 1.149999);
	PlayerTextDrawTextSize(playerid, ChrInfAllRate[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfAllRate[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfAllRate[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfAllRate[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfAllRate[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfAllRate[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfAllRate[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfAllRate[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfAllRate[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfAllRate[playerid], 0);

	ChrInfPersonalRate[playerid] = CreatePlayerTextDraw(playerid, 595.000000, 181.000000, "20");
	PlayerTextDrawFont(playerid, ChrInfPersonalRate[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfPersonalRate[playerid], 0.279166, 1.149999);
	PlayerTextDrawTextSize(playerid, ChrInfPersonalRate[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfPersonalRate[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfPersonalRate[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfPersonalRate[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfPersonalRate[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfPersonalRate[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfPersonalRate[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfPersonalRate[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfPersonalRate[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfPersonalRate[playerid], 0);

	ChrInfoDelim4[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 194.000000, "TextDraw");
	PlayerTextDrawFont(playerid, ChrInfoDelim4[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfoDelim4[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfoDelim4[playerid], 190.000000, 1.500000);
	PlayerTextDrawSetOutline(playerid, ChrInfoDelim4[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfoDelim4[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoDelim4[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoDelim4[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoDelim4[playerid], 0);
	PlayerTextDrawBoxColor(playerid, ChrInfoDelim4[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoDelim4[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoDelim4[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoDelim4[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfoDelim4[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfoDelim4[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfoDelim4[playerid], 0, 1);

	ChrInfCurInv[playerid] = CreatePlayerTextDraw(playerid, 542.000000, 197.000000, "1/7");
	PlayerTextDrawFont(playerid, ChrInfCurInv[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfCurInv[playerid], 0.270832, 1.049999);
	PlayerTextDrawTextSize(playerid, ChrInfCurInv[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfCurInv[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfCurInv[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfCurInv[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfCurInv[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfCurInv[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfCurInv[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfCurInv[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfCurInv[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfCurInv[playerid], 0);

	ChrInfPrevInvBtn[playerid] = CreatePlayerTextDraw(playerid, 484.000000, 196.000000, "<");
	PlayerTextDrawFont(playerid, ChrInfPrevInvBtn[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfPrevInvBtn[playerid], 0.354166, 1.399999);
	PlayerTextDrawTextSize(playerid, ChrInfPrevInvBtn[playerid], 15.666666, 8.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfPrevInvBtn[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfPrevInvBtn[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfPrevInvBtn[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfPrevInvBtn[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfPrevInvBtn[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfPrevInvBtn[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfPrevInvBtn[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfPrevInvBtn[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfPrevInvBtn[playerid], 1);

	ChrInfNextInvBtn[playerid] = CreatePlayerTextDraw(playerid, 596.000000, 196.000000, ">");
	PlayerTextDrawFont(playerid, ChrInfNextInvBtn[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ChrInfNextInvBtn[playerid], 0.354166, 1.399999);
	PlayerTextDrawTextSize(playerid, ChrInfNextInvBtn[playerid], 15.666666, 8.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfNextInvBtn[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfNextInvBtn[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfNextInvBtn[playerid], 2);
	PlayerTextDrawColor(playerid, ChrInfNextInvBtn[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfNextInvBtn[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ChrInfNextInvBtn[playerid], 50);
	PlayerTextDrawUseBox(playerid, ChrInfNextInvBtn[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfNextInvBtn[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfNextInvBtn[playerid], 1);

	ChrInfoDelim5[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 210.000000, "TextDraw");
	PlayerTextDrawFont(playerid, ChrInfoDelim5[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfoDelim5[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfoDelim5[playerid], 190.000000, 1.500000);
	PlayerTextDrawSetOutline(playerid, ChrInfoDelim5[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfoDelim5[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoDelim5[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoDelim5[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoDelim5[playerid], 0);
	PlayerTextDrawBoxColor(playerid, ChrInfoDelim5[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoDelim5[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoDelim5[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoDelim5[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfoDelim5[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfoDelim5[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfoDelim5[playerid], 0, 1);

	ChrInfoDelim6[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 372.000000, "TextDraw");
	PlayerTextDrawFont(playerid, ChrInfoDelim6[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfoDelim6[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfoDelim6[playerid], 190.000000, 1.500000);
	PlayerTextDrawSetOutline(playerid, ChrInfoDelim6[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ChrInfoDelim6[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfoDelim6[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfoDelim6[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, ChrInfoDelim6[playerid], 0);
	PlayerTextDrawBoxColor(playerid, ChrInfoDelim6[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfoDelim6[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ChrInfoDelim6[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfoDelim6[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfoDelim6[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfoDelim6[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfoDelim6[playerid], 0, 1);

	ChrInfButUse[playerid] = CreatePlayerTextDraw(playerid, 474.500000, 377.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfButUse[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfButUse[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButUse[playerid], 25.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfButUse[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButUse[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfButUse[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButUse[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButUse[playerid], 0x00000000);
	PlayerTextDrawBoxColor(playerid, ChrInfButUse[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfButUse[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfButUse[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfButUse[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButUse[playerid], 19131);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButUse[playerid], 0.000000, 90.000000, 90.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfButUse[playerid], 1, 1);

	ChrInfButInfo[playerid] = CreatePlayerTextDraw(playerid, 500.500000, 377.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfButInfo[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfButInfo[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButInfo[playerid], 25.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfButInfo[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButInfo[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfButInfo[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButInfo[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButInfo[playerid], 0x00000000);
	PlayerTextDrawBoxColor(playerid, ChrInfButInfo[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfButInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfButInfo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfButInfo[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButInfo[playerid], 1239);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButInfo[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfButInfo[playerid], 1, 1);

	ChrInfButDel[playerid] = CreatePlayerTextDraw(playerid, 526.500000, 377.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfButDel[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfButDel[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButDel[playerid], 25.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfButDel[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButDel[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfButDel[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButDel[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButDel[playerid], 0x00000000);
	PlayerTextDrawBoxColor(playerid, ChrInfButDel[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfButDel[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfButDel[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfButDel[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButDel[playerid], 1409);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButDel[playerid], 0.000000, 0.000000, 180.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfButDel[playerid], 1, 1);

	ChrInfButMod[playerid] = CreatePlayerTextDraw(playerid, 552.500000, 377.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfButMod[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfButMod[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButMod[playerid], 25.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfButMod[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButMod[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfButMod[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButMod[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButMod[playerid], 0x00000000);
	PlayerTextDrawBoxColor(playerid, ChrInfButMod[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfButMod[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfButMod[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfButMod[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButMod[playerid], 19132);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButMod[playerid], 180.000000, 0.000000, 90.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfButMod[playerid], 1, 1);

	ChrInfButSort[playerid] = CreatePlayerTextDraw(playerid, 578.500000, 377.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, ChrInfButSort[playerid], 5);
	PlayerTextDrawLetterSize(playerid, ChrInfButSort[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ChrInfButSort[playerid], 25.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, ChrInfButSort[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ChrInfButSort[playerid], 0);
	PlayerTextDrawAlignment(playerid, ChrInfButSort[playerid], 1);
	PlayerTextDrawColor(playerid, ChrInfButSort[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ChrInfButSort[playerid], 0x00000000);
	PlayerTextDrawBoxColor(playerid, ChrInfButSort[playerid], 0);
	PlayerTextDrawUseBox(playerid, ChrInfButSort[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ChrInfButSort[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ChrInfButSort[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, ChrInfButSort[playerid], 1247);
	PlayerTextDrawSetPreviewRot(playerid, ChrInfButSort[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, ChrInfButSort[playerid], 1, 1);

	new inv_slot_x = 448;
	new inv_slot_y = 214;
	new inv_slot_count_x = 473;
	new inv_slot_count_y = 232;
	new inv_slot_offset = 26;
	new idx = 0;
	for(new i = 1; i <= MAX_SLOTS_X; i++)
	{
		for(new j = 1; j <= MAX_SLOTS_Y; j++)
		{
			ChrInfInvSlot[playerid][idx] = CreatePlayerTextDraw(playerid, inv_slot_x, inv_slot_y, "Preview_Model");
			PlayerTextDrawFont(playerid, ChrInfInvSlot[playerid][idx], 5);
			PlayerTextDrawLetterSize(playerid, ChrInfInvSlot[playerid][idx], 0.600000, 2.000000);
			PlayerTextDrawTextSize(playerid, ChrInfInvSlot[playerid][idx], 25.000000, 25.000000);
			PlayerTextDrawSetOutline(playerid, ChrInfInvSlot[playerid][idx], 0);
			PlayerTextDrawSetShadow(playerid, ChrInfInvSlot[playerid][idx], 0);
			PlayerTextDrawAlignment(playerid, ChrInfInvSlot[playerid][idx], 1);
			PlayerTextDrawColor(playerid, ChrInfInvSlot[playerid][idx], -1);
			PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlot[playerid][idx], -741092353);
			PlayerTextDrawBoxColor(playerid, ChrInfInvSlot[playerid][idx], 0);
			PlayerTextDrawUseBox(playerid, ChrInfInvSlot[playerid][idx], 0);
			PlayerTextDrawSetProportional(playerid, ChrInfInvSlot[playerid][idx], 1);
			PlayerTextDrawSetSelectable(playerid, ChrInfInvSlot[playerid][idx], 1);
			PlayerTextDrawSetPreviewModel(playerid, ChrInfInvSlot[playerid][idx], -1);
			PlayerTextDrawSetPreviewRot(playerid, ChrInfInvSlot[playerid][idx], 0.000000, 0.000000, 0.000000, 1.000000);
			PlayerTextDrawSetPreviewVehCol(playerid, ChrInfInvSlot[playerid][idx], 1, 1);

			ChrInfInvSlotCount[playerid][idx] = CreatePlayerTextDraw(playerid, inv_slot_count_x, inv_slot_count_y, "9999");
			PlayerTextDrawFont(playerid, ChrInfInvSlotCount[playerid][idx], 1);
			PlayerTextDrawLetterSize(playerid, ChrInfInvSlotCount[playerid][idx], 0.158333, 0.850000);
			PlayerTextDrawTextSize(playerid, ChrInfInvSlotCount[playerid][idx], 400.000000, 17.000000);
			PlayerTextDrawSetOutline(playerid, ChrInfInvSlotCount[playerid][idx], 0);
			PlayerTextDrawSetShadow(playerid, ChrInfInvSlotCount[playerid][idx], 0);
			PlayerTextDrawAlignment(playerid, ChrInfInvSlotCount[playerid][idx], 3);
			PlayerTextDrawColor(playerid, ChrInfInvSlotCount[playerid][idx], 255);
			PlayerTextDrawBackgroundColor(playerid, ChrInfInvSlotCount[playerid][idx], 255);
			PlayerTextDrawBoxColor(playerid, ChrInfInvSlotCount[playerid][idx], 50);
			PlayerTextDrawUseBox(playerid, ChrInfInvSlotCount[playerid][idx], 0);
			PlayerTextDrawSetProportional(playerid, ChrInfInvSlotCount[playerid][idx], 1);
			PlayerTextDrawSetSelectable(playerid, ChrInfInvSlotCount[playerid][idx], 0);

			inv_slot_x += inv_slot_offset;
			inv_slot_count_x += inv_slot_offset;
			idx++;
		}
		inv_slot_x = 448;
		inv_slot_count_x = 473;
		inv_slot_y += inv_slot_offset;
		inv_slot_count_y += inv_slot_offset;
	}

	//EqInf
	EqInfBox[playerid] = CreatePlayerTextDraw(playerid, 317.000000, 119.000000, "_");
	PlayerTextDrawFont(playerid, EqInfBox[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfBox[playerid], 0.629166, 22.550031);
	PlayerTextDrawTextSize(playerid, EqInfBox[playerid], 298.500000, 149.000000);
	PlayerTextDrawSetOutline(playerid, EqInfBox[playerid], 1);
	PlayerTextDrawSetShadow(playerid, EqInfBox[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfBox[playerid], 2);
	PlayerTextDrawColor(playerid, EqInfBox[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfBox[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfBox[playerid], 220);
	PlayerTextDrawUseBox(playerid, EqInfBox[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfBox[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfBox[playerid], 0);

	EqInfTxt1[playerid] = CreatePlayerTextDraw(playerid, 317.000000, 120.000000, "Информация");
	PlayerTextDrawFont(playerid, EqInfTxt1[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfTxt1[playerid], 0.283333, 1.149999);
	PlayerTextDrawTextSize(playerid, EqInfTxt1[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, EqInfTxt1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfTxt1[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfTxt1[playerid], 2);
	PlayerTextDrawColor(playerid, EqInfTxt1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfTxt1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfTxt1[playerid], 50);
	PlayerTextDrawUseBox(playerid, EqInfTxt1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, EqInfTxt1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfTxt1[playerid], 0);

	EqInfClose[playerid] = CreatePlayerTextDraw(playerid, 391.000000, 119.000000, "X");
	PlayerTextDrawFont(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfClose[playerid], 0.370833, 1.200000);
	PlayerTextDrawTextSize(playerid, EqInfClose[playerid], 401.500000, 13.000000);
	PlayerTextDrawSetOutline(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawSetShadow(playerid, EqInfClose[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfClose[playerid], 3);
	PlayerTextDrawColor(playerid, EqInfClose[playerid], -1962934017);
	PlayerTextDrawBackgroundColor(playerid, EqInfClose[playerid], 175);
	PlayerTextDrawBoxColor(playerid, EqInfClose[playerid], 112);
	PlayerTextDrawUseBox(playerid, EqInfClose[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfClose[playerid], 1);

	EqInfDelim1[playerid] = CreatePlayerTextDraw(playerid, 242.000000, 132.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, EqInfDelim1[playerid], 5);
	PlayerTextDrawLetterSize(playerid, EqInfDelim1[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, EqInfDelim1[playerid], 151.500000, 1.000000);
	PlayerTextDrawSetOutline(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim1[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawBoxColor(playerid, EqInfDelim1[playerid], 255);
	PlayerTextDrawUseBox(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfDelim1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfDelim1[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, EqInfDelim1[playerid], 1, 1);

	EqInfItemName[playerid] = CreatePlayerTextDraw(playerid, 317.000000, 135.000000, "+13 Legengary Shazok destroyer");
	PlayerTextDrawFont(playerid, EqInfItemName[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfItemName[playerid], 0.162499, 0.750000);
	PlayerTextDrawTextSize(playerid, EqInfItemName[playerid], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfItemName[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfItemName[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfItemName[playerid], 2);
	PlayerTextDrawColor(playerid, EqInfItemName[playerid], -764862721);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemName[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfItemName[playerid], 50);
	PlayerTextDrawUseBox(playerid, EqInfItemName[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfItemName[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfItemName[playerid], 0);

	EqInfItemType[playerid] = CreatePlayerTextDraw(playerid, 244.000000, 145.000000, "Type: Weapon");
	PlayerTextDrawFont(playerid, EqInfItemType[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfItemType[playerid], 0.179167, 0.850000);
	PlayerTextDrawTextSize(playerid, EqInfItemType[playerid], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfItemType[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfItemType[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfItemType[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfItemType[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemType[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfItemType[playerid], 50);
	PlayerTextDrawUseBox(playerid, EqInfItemType[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfItemType[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfItemType[playerid], 0);

	EqInfMinRank[playerid] = CreatePlayerTextDraw(playerid, 244.000000, 153.000000, "Min rank: Brilliance");
	PlayerTextDrawFont(playerid, EqInfMinRank[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfMinRank[playerid], 0.179167, 0.850000);
	PlayerTextDrawTextSize(playerid, EqInfMinRank[playerid], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfMinRank[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfMinRank[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfMinRank[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfMinRank[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfMinRank[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfMinRank[playerid], 50);
	PlayerTextDrawUseBox(playerid, EqInfMinRank[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfMinRank[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfMinRank[playerid], 0);

	EqInfGrade[playerid] = CreatePlayerTextDraw(playerid, 244.000000, 160.000000, "Grade: C");
	PlayerTextDrawFont(playerid, EqInfGrade[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfGrade[playerid], 0.179167, 0.850000);
	PlayerTextDrawTextSize(playerid, EqInfGrade[playerid], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfGrade[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfGrade[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfGrade[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfGrade[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfGrade[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfGrade[playerid], 50);
	PlayerTextDrawUseBox(playerid, EqInfGrade[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfGrade[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfGrade[playerid], 0);

	EqInfStage[playerid] = CreatePlayerTextDraw(playerid, 244.000000, 167.000000, "Stage: 10");
	PlayerTextDrawFont(playerid, EqInfStage[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfStage[playerid], 0.179167, 0.850000);
	PlayerTextDrawTextSize(playerid, EqInfStage[playerid], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfStage[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfStage[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfStage[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfStage[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfStage[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfStage[playerid], 50);
	PlayerTextDrawUseBox(playerid, EqInfStage[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfStage[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfStage[playerid], 0);

	EqInfItemIcon[playerid] = CreatePlayerTextDraw(playerid, 358.000000, 147.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, EqInfItemIcon[playerid], 5);
	PlayerTextDrawLetterSize(playerid, EqInfItemIcon[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, EqInfItemIcon[playerid], 30.000000, 30.000000);
	PlayerTextDrawSetOutline(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfItemIcon[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfItemIcon[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfItemIcon[playerid], -764862721);
	PlayerTextDrawBoxColor(playerid, EqInfItemIcon[playerid], 255);
	PlayerTextDrawUseBox(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfItemIcon[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, EqInfItemIcon[playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, EqInfItemIcon[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, EqInfItemIcon[playerid], 1, 1);

	EqInfDelim2[playerid] = CreatePlayerTextDraw(playerid, 242.000000, 180.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, EqInfDelim2[playerid], 5);
	PlayerTextDrawLetterSize(playerid, EqInfDelim2[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, EqInfDelim2[playerid], 151.500000, 1.000000);
	PlayerTextDrawSetOutline(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfDelim2[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim2[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawBoxColor(playerid, EqInfDelim2[playerid], 255);
	PlayerTextDrawUseBox(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfDelim2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfDelim2[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim2[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim2[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, EqInfDelim2[playerid], 1, 1);

	EqInfMainStats[playerid][0] = CreatePlayerTextDraw(playerid, 244.000000, 182.000000, "Damage: 9999 - 9999");
	PlayerTextDrawFont(playerid, EqInfMainStats[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, EqInfMainStats[playerid][0], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfMainStats[playerid][0], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfMainStats[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, EqInfMainStats[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, EqInfMainStats[playerid][0], 1);
	PlayerTextDrawColor(playerid, EqInfMainStats[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfMainStats[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, EqInfMainStats[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, EqInfMainStats[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, EqInfMainStats[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfMainStats[playerid][0], 0);

	EqInfMainStats[playerid][1] = CreatePlayerTextDraw(playerid, 244.000000, 189.000000, "Attack +10%");
	PlayerTextDrawFont(playerid, EqInfMainStats[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, EqInfMainStats[playerid][1], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfMainStats[playerid][1], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfMainStats[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, EqInfMainStats[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, EqInfMainStats[playerid][1], 1);
	PlayerTextDrawColor(playerid, EqInfMainStats[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfMainStats[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, EqInfMainStats[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, EqInfMainStats[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, EqInfMainStats[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfMainStats[playerid][1], 0);

	EqInfMainStats[playerid][2] = CreatePlayerTextDraw(playerid, 244.000000, 196.000000, "Attack +10%");
	PlayerTextDrawFont(playerid, EqInfMainStats[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, EqInfMainStats[playerid][2], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfMainStats[playerid][2], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfMainStats[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, EqInfMainStats[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, EqInfMainStats[playerid][2], 1);
	PlayerTextDrawColor(playerid, EqInfMainStats[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfMainStats[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, EqInfMainStats[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, EqInfMainStats[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, EqInfMainStats[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfMainStats[playerid][2], 0);

	EqInfMainStats[playerid][3] = CreatePlayerTextDraw(playerid, 244.000000, 203.000000, "Attack +10%");
	PlayerTextDrawFont(playerid, EqInfMainStats[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, EqInfMainStats[playerid][3], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfMainStats[playerid][3], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfMainStats[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, EqInfMainStats[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, EqInfMainStats[playerid][3], 1);
	PlayerTextDrawColor(playerid, EqInfMainStats[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfMainStats[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, EqInfMainStats[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, EqInfMainStats[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, EqInfMainStats[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfMainStats[playerid][3], 0);

	EqInfDelim3[playerid] = CreatePlayerTextDraw(playerid, 242.000000, 213.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, EqInfDelim3[playerid], 5);
	PlayerTextDrawLetterSize(playerid, EqInfDelim3[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, EqInfDelim3[playerid], 151.500000, 1.000000);
	PlayerTextDrawSetOutline(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfDelim3[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim3[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawBoxColor(playerid, EqInfDelim3[playerid], 255);
	PlayerTextDrawUseBox(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfDelim3[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfDelim3[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim3[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, EqInfDelim3[playerid], 1, 1);

	EqInfSpecialParamsText[playerid] = CreatePlayerTextDraw(playerid, 244.000000, 215.000000, "Особые характеристики:");
	PlayerTextDrawFont(playerid, EqInfSpecialParamsText[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfSpecialParamsText[playerid], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfSpecialParamsText[playerid], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfSpecialParamsText[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfSpecialParamsText[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfSpecialParamsText[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfSpecialParamsText[playerid], 16711935);
	PlayerTextDrawBackgroundColor(playerid, EqInfSpecialParamsText[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfSpecialParamsText[playerid], 50);
	PlayerTextDrawUseBox(playerid, EqInfSpecialParamsText[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfSpecialParamsText[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfSpecialParamsText[playerid], 0);

	EqInfSpecialStats[playerid][0] = CreatePlayerTextDraw(playerid, 244.000000, 223.000000, "Crit multiplier +0.20");
	PlayerTextDrawFont(playerid, EqInfSpecialStats[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, EqInfSpecialStats[playerid][0], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfSpecialStats[playerid][0], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfSpecialStats[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, EqInfSpecialStats[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, EqInfSpecialStats[playerid][0], 1);
	PlayerTextDrawColor(playerid, EqInfSpecialStats[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfSpecialStats[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, EqInfSpecialStats[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, EqInfSpecialStats[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, EqInfSpecialStats[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfSpecialStats[playerid][0], 0);

	EqInfSpecialStats[playerid][1] = CreatePlayerTextDraw(playerid, 244.000000, 230.000000, "Crit multiplier +0.20");
	PlayerTextDrawFont(playerid, EqInfSpecialStats[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, EqInfSpecialStats[playerid][1], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfSpecialStats[playerid][1], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfSpecialStats[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, EqInfSpecialStats[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, EqInfSpecialStats[playerid][1], 1);
	PlayerTextDrawColor(playerid, EqInfSpecialStats[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfSpecialStats[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, EqInfSpecialStats[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, EqInfSpecialStats[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, EqInfSpecialStats[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfSpecialStats[playerid][1], 0);

	EqInfSpecialStats[playerid][2] = CreatePlayerTextDraw(playerid, 244.000000, 237.000000, "Crit multiplier +0.20");
	PlayerTextDrawFont(playerid, EqInfSpecialStats[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, EqInfSpecialStats[playerid][2], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfSpecialStats[playerid][2], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfSpecialStats[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, EqInfSpecialStats[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, EqInfSpecialStats[playerid][2], 1);
	PlayerTextDrawColor(playerid, EqInfSpecialStats[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfSpecialStats[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, EqInfSpecialStats[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, EqInfSpecialStats[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, EqInfSpecialStats[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfSpecialStats[playerid][2], 0);

	EqInfSpecialStats[playerid][3] = CreatePlayerTextDraw(playerid, 244.000000, 244.000000, "Crit multiplier +0.20");
	PlayerTextDrawFont(playerid, EqInfSpecialStats[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, EqInfSpecialStats[playerid][3], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfSpecialStats[playerid][3], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfSpecialStats[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, EqInfSpecialStats[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, EqInfSpecialStats[playerid][3], 1);
	PlayerTextDrawColor(playerid, EqInfSpecialStats[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfSpecialStats[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, EqInfSpecialStats[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, EqInfSpecialStats[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, EqInfSpecialStats[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfSpecialStats[playerid][3], 0);

	EqInfSpecialStats[playerid][4] = CreatePlayerTextDraw(playerid, 244.000000, 251.000000, "Crit multiplier +0.20");
	PlayerTextDrawFont(playerid, EqInfSpecialStats[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, EqInfSpecialStats[playerid][4], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfSpecialStats[playerid][4], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfSpecialStats[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, EqInfSpecialStats[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, EqInfSpecialStats[playerid][4], 1);
	PlayerTextDrawColor(playerid, EqInfSpecialStats[playerid][4], -2686721);
	PlayerTextDrawBackgroundColor(playerid, EqInfSpecialStats[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, EqInfSpecialStats[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, EqInfSpecialStats[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, EqInfSpecialStats[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfSpecialStats[playerid][4], 0);

	EqInfSpecialStats[playerid][5] = CreatePlayerTextDraw(playerid, 244.000000, 258.000000, "Crit multiplier +0.20");
	PlayerTextDrawFont(playerid, EqInfSpecialStats[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, EqInfSpecialStats[playerid][5], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfSpecialStats[playerid][5], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfSpecialStats[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, EqInfSpecialStats[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, EqInfSpecialStats[playerid][5], 1);
	PlayerTextDrawColor(playerid, EqInfSpecialStats[playerid][5], -2686721);
	PlayerTextDrawBackgroundColor(playerid, EqInfSpecialStats[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, EqInfSpecialStats[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, EqInfSpecialStats[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, EqInfSpecialStats[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfSpecialStats[playerid][5], 0);

	EqInfSpecialStats[playerid][6] = CreatePlayerTextDraw(playerid, 244.000000, 265.000000, "Crit multiplier +0.20");
	PlayerTextDrawFont(playerid, EqInfSpecialStats[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, EqInfSpecialStats[playerid][6], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfSpecialStats[playerid][6], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfSpecialStats[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, EqInfSpecialStats[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, EqInfSpecialStats[playerid][6], 1);
	PlayerTextDrawColor(playerid, EqInfSpecialStats[playerid][6], -2686721);
	PlayerTextDrawBackgroundColor(playerid, EqInfSpecialStats[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, EqInfSpecialStats[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, EqInfSpecialStats[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, EqInfSpecialStats[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfSpecialStats[playerid][6], 0);

	EqInfDelim4[playerid] = CreatePlayerTextDraw(playerid, 242.000000, 276.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, EqInfDelim4[playerid], 5);
	PlayerTextDrawLetterSize(playerid, EqInfDelim4[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, EqInfDelim4[playerid], 151.500000, 1.000000);
	PlayerTextDrawSetOutline(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfDelim4[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim4[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawBoxColor(playerid, EqInfDelim4[playerid], 255);
	PlayerTextDrawUseBox(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfDelim4[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfDelim4[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim4[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim4[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, EqInfDelim4[playerid], 1, 1);

	EqInfDescriptionStr[playerid][0] = CreatePlayerTextDraw(playerid, 317.000000, 278.000000, "1234567890123456789012345678901234567890");
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][0], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfDescriptionStr[playerid][0], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][0], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, EqInfDescriptionStr[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, EqInfDescriptionStr[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfDescriptionStr[playerid][0], 0);

	EqInfDescriptionStr[playerid][1] = CreatePlayerTextDraw(playerid, 317.000000, 285.000000, "1234567890123456789012345678901234567890");
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][1], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfDescriptionStr[playerid][1], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][1], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, EqInfDescriptionStr[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, EqInfDescriptionStr[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfDescriptionStr[playerid][1], 0);

	EqInfDescriptionStr[playerid][2] = CreatePlayerTextDraw(playerid, 317.000000, 292.000000, "1234567890123456789012345678901234567890");
	PlayerTextDrawFont(playerid, EqInfDescriptionStr[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, EqInfDescriptionStr[playerid][2], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfDescriptionStr[playerid][2], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfDescriptionStr[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDescriptionStr[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, EqInfDescriptionStr[playerid][2], 2);
	PlayerTextDrawColor(playerid, EqInfDescriptionStr[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfDescriptionStr[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, EqInfDescriptionStr[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, EqInfDescriptionStr[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, EqInfDescriptionStr[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfDescriptionStr[playerid][2], 0);

	EqInfDelim5[playerid] = CreatePlayerTextDraw(playerid, 242.000000, 302.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, EqInfDelim5[playerid], 5);
	PlayerTextDrawLetterSize(playerid, EqInfDelim5[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, EqInfDelim5[playerid], 151.500000, 1.000000);
	PlayerTextDrawSetOutline(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfDelim5[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfDelim5[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawBoxColor(playerid, EqInfDelim5[playerid], 255);
	PlayerTextDrawUseBox(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfDelim5[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfDelim5[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, EqInfDelim5[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, EqInfDelim5[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, EqInfDelim5[playerid], 1, 1);

	EqInfPrice[playerid] = CreatePlayerTextDraw(playerid, 244.000000, 304.000000, "Price: 999.999.999$");
	PlayerTextDrawFont(playerid, EqInfPrice[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfPrice[playerid], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfPrice[playerid], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfPrice[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfPrice[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfPrice[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfPrice[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfPrice[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfPrice[playerid], 50);
	PlayerTextDrawUseBox(playerid, EqInfPrice[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfPrice[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfPrice[playerid], 0);

	EqInfTrading[playerid] = CreatePlayerTextDraw(playerid, 244.000000, 311.000000, "Trade: allowed");
	PlayerTextDrawFont(playerid, EqInfTrading[playerid], 1);
	PlayerTextDrawLetterSize(playerid, EqInfTrading[playerid], 0.191667, 0.899999);
	PlayerTextDrawTextSize(playerid, EqInfTrading[playerid], 461.000000, 344.500000);
	PlayerTextDrawSetOutline(playerid, EqInfTrading[playerid], 0);
	PlayerTextDrawSetShadow(playerid, EqInfTrading[playerid], 0);
	PlayerTextDrawAlignment(playerid, EqInfTrading[playerid], 1);
	PlayerTextDrawColor(playerid, EqInfTrading[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, EqInfTrading[playerid], 255);
	PlayerTextDrawBoxColor(playerid, EqInfTrading[playerid], 50);
	PlayerTextDrawUseBox(playerid, EqInfTrading[playerid], 0);
	PlayerTextDrawSetProportional(playerid, EqInfTrading[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, EqInfTrading[playerid], 0);

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

	UpgBox[playerid] = CreatePlayerTextDraw(playerid, 415.533599, 154.566558, "upg_box");
	PlayerTextDrawLetterSize(playerid, UpgBox[playerid], 0.000000, 13.053355);
	PlayerTextDrawTextSize(playerid, UpgBox[playerid], 215.866714, 0.000000);
	PlayerTextDrawAlignment(playerid, UpgBox[playerid], 1);
	PlayerTextDrawColor(playerid, UpgBox[playerid], 0);
	PlayerTextDrawUseBox(playerid, UpgBox[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgBox[playerid], 220);
	PlayerTextDrawSetShadow(playerid, UpgBox[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgBox[playerid], 0);
	PlayerTextDrawFont(playerid, UpgBox[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, UpgBox[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, UpgBox[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	UpgTxt1[playerid] = CreatePlayerTextDraw(playerid, 320.166687, 153.481506, "Модификация");
	PlayerTextDrawLetterSize(playerid, UpgTxt1[playerid], 0.267666, 1.044147);
	PlayerTextDrawAlignment(playerid, UpgTxt1[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt1[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgTxt1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt1[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt1[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt1[playerid], 1);

	UpgDelim1[playerid] = CreatePlayerTextDraw(playerid, 217.666656, 163.229598, "upg_delim1");
	PlayerTextDrawLetterSize(playerid, UpgDelim1[playerid], 0.000000, -7.433332);
	PlayerTextDrawTextSize(playerid, UpgDelim1[playerid], 196.133361, 2.200000);
	PlayerTextDrawAlignment(playerid, UpgDelim1[playerid], 1);
	PlayerTextDrawColor(playerid, UpgDelim1[playerid], 16711935);
	PlayerTextDrawUseBox(playerid, UpgDelim1[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgDelim1[playerid], 0);
	PlayerTextDrawSetShadow(playerid, UpgDelim1[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgDelim1[playerid], 0);
	PlayerTextDrawFont(playerid, UpgDelim1[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, UpgDelim1[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, UpgDelim1[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	UpgOldItemTxt[playerid] = CreatePlayerTextDraw(playerid, 220.166717, 171.986801, "+12 Legendary bourgeois destroyer");
	PlayerTextDrawLetterSize(playerid, UpgOldItemTxt[playerid], 0.129999, 0.600000);
	PlayerTextDrawAlignment(playerid, UpgOldItemTxt[playerid], 1);
	PlayerTextDrawColor(playerid, UpgOldItemTxt[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, UpgOldItemTxt[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgOldItemTxt[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgOldItemTxt[playerid], 51);
	PlayerTextDrawFont(playerid, UpgOldItemTxt[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgOldItemTxt[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, UpgOldItemTxt[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, UpgOldItemTxt[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	UpgSafeBtn[playerid] = CreatePlayerTextDraw(playerid, 364.533264, 260.549591, "Защищенное");
	PlayerTextDrawLetterSize(playerid, UpgSafeBtn[playerid], 0.275332, 1.060739);
	PlayerTextDrawTextSize(playerid, UpgSafeBtn[playerid], 13.033336, 99.389656);
	PlayerTextDrawAlignment(playerid, UpgSafeBtn[playerid], 2);
	PlayerTextDrawColor(playerid, UpgSafeBtn[playerid], 255);
	PlayerTextDrawUseBox(playerid, UpgSafeBtn[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgSafeBtn[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, UpgSafeBtn[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgSafeBtn[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgSafeBtn[playerid], 0x00000000);
	PlayerTextDrawFont(playerid, UpgSafeBtn[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgSafeBtn[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, UpgSafeBtn[playerid], true);

	UpgPotionCount[playerid] = CreatePlayerTextDraw(playerid, 238.233551, 242.481414, "9999");
	PlayerTextDrawLetterSize(playerid, UpgPotionCount[playerid], 0.124664, 0.629333);
	PlayerTextDrawAlignment(playerid, UpgPotionCount[playerid], 3);
	PlayerTextDrawColor(playerid, UpgPotionCount[playerid], 255);
	PlayerTextDrawSetShadow(playerid, UpgPotionCount[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgPotionCount[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgPotionCount[playerid], 51);
	PlayerTextDrawFont(playerid, UpgPotionCount[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgPotionCount[playerid], 1);

	UpgDefSlot[playerid] = CreatePlayerTextDraw(playerid, 240.666656, 227.844406, "def_slot");
	PlayerTextDrawLetterSize(playerid, UpgDefSlot[playerid], 0.000000, -1.966668);
	PlayerTextDrawTextSize(playerid, UpgDefSlot[playerid], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, UpgDefSlot[playerid], 1);
	PlayerTextDrawColor(playerid, UpgDefSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, UpgDefSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgDefSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, UpgDefSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgDefSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgDefSlot[playerid], -1378294017);
	PlayerTextDrawFont(playerid, UpgDefSlot[playerid], 5);
	PlayerTextDrawSetSelectable(playerid, UpgDefSlot[playerid], true);
	PlayerTextDrawSetPreviewModel(playerid, UpgDefSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgDefSlot[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	UpgTxt2[playerid] = CreatePlayerTextDraw(playerid, 251.133499, 249.533401, "Печати");
	PlayerTextDrawLetterSize(playerid, UpgTxt2[playerid], 0.125997, 0.629333);
	PlayerTextDrawAlignment(playerid, UpgTxt2[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgTxt2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt2[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt2[playerid], 1);

	UpgPotionSlot[playerid] = CreatePlayerTextDraw(playerid, 218.433212, 227.844421, "potion_slot");
	PlayerTextDrawLetterSize(playerid, UpgPotionSlot[playerid], 0.000000, -2.066668);
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

	UpgTxt3[playerid] = CreatePlayerTextDraw(playerid, 229.000213, 248.408874, "Эликсиры");
	PlayerTextDrawLetterSize(playerid, UpgTxt3[playerid], 0.189998, 0.766222);
	PlayerTextDrawAlignment(playerid, UpgTxt3[playerid], 2);
	PlayerTextDrawColor(playerid, UpgTxt3[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgTxt3[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgTxt3[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgTxt3[playerid], 51);
	PlayerTextDrawFont(playerid, UpgTxt3[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgTxt3[playerid], 1);

	UpgBtn[playerid] = CreatePlayerTextDraw(playerid, 266.633209, 260.462097, "Обычное");
	PlayerTextDrawLetterSize(playerid, UpgBtn[playerid], 0.275332, 1.060739);
	PlayerTextDrawTextSize(playerid, UpgBtn[playerid], 13.033336, 99.389656);
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

	UpgClose[playerid] = CreatePlayerTextDraw(playerid, 408.933349, 151.200027, "x");
	PlayerTextDrawLetterSize(playerid, UpgClose[playerid], 0.347000, 1.243257);
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
	PlayerTextDrawSetPreviewModel(playerid, UpgClose[playerid], 19134);
	PlayerTextDrawSetPreviewRot(playerid, UpgClose[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

	UpgNewItemTxt[playerid] = CreatePlayerTextDraw(playerid, 412.566589, 171.783889, "+13 Legengary bourgeois destroyer");
	PlayerTextDrawLetterSize(playerid, UpgNewItemTxt[playerid], 0.129999, 0.600000);
	PlayerTextDrawAlignment(playerid, UpgNewItemTxt[playerid], 3);
	PlayerTextDrawColor(playerid, UpgNewItemTxt[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, UpgNewItemTxt[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgNewItemTxt[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgNewItemTxt[playerid], 51);
	PlayerTextDrawFont(playerid, UpgNewItemTxt[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgNewItemTxt[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, UpgNewItemTxt[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, UpgNewItemTxt[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	UpgArrow[playerid] = CreatePlayerTextDraw(playerid, 318.666748, 169.921630, "=>");
	PlayerTextDrawLetterSize(playerid, UpgArrow[playerid], 0.272330, 1.106369);
	PlayerTextDrawAlignment(playerid, UpgArrow[playerid], 2);
	PlayerTextDrawColor(playerid, UpgArrow[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgArrow[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgArrow[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgArrow[playerid], 51);
	PlayerTextDrawFont(playerid, UpgArrow[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgArrow[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, UpgArrow[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, UpgArrow[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	UpgDefCount[playerid] = CreatePlayerTextDraw(playerid, 260.366943, 242.319900, "9998");
	PlayerTextDrawLetterSize(playerid, UpgDefCount[playerid], 0.124664, 0.629333);
	PlayerTextDrawAlignment(playerid, UpgDefCount[playerid], 3);
	PlayerTextDrawColor(playerid, UpgDefCount[playerid], 255);
	PlayerTextDrawSetShadow(playerid, UpgDefCount[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgDefCount[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgDefCount[playerid], 51);
	PlayerTextDrawFont(playerid, UpgDefCount[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgDefCount[playerid], 1);

	UpgMainTxt[playerid] = CreatePlayerTextDraw(playerid, 320.666564, 209.287368, "+13 Legengary bourgeois destroyer");
	PlayerTextDrawLetterSize(playerid, UpgMainTxt[playerid], 0.134997, 0.591999);
	PlayerTextDrawAlignment(playerid, UpgMainTxt[playerid], 2);
	PlayerTextDrawColor(playerid, UpgMainTxt[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, UpgMainTxt[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgMainTxt[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgMainTxt[playerid], 51);
	PlayerTextDrawFont(playerid, UpgMainTxt[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgMainTxt[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, UpgMainTxt[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, UpgMainTxt[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	UpgCongrTxt[playerid] = CreatePlayerTextDraw(playerid, 321.233398, 197.013320, "Поздравляем! Предмет усилен.");
	PlayerTextDrawLetterSize(playerid, UpgCongrTxt[playerid], 0.165997, 0.795258);
	PlayerTextDrawAlignment(playerid, UpgCongrTxt[playerid], 2);
	PlayerTextDrawColor(playerid, UpgCongrTxt[playerid], -1);
	PlayerTextDrawSetShadow(playerid, UpgCongrTxt[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgCongrTxt[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgCongrTxt[playerid], 51);
	PlayerTextDrawFont(playerid, UpgCongrTxt[playerid], 1);
	PlayerTextDrawSetProportional(playerid, UpgCongrTxt[playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, UpgCongrTxt[playerid], 18656);
	PlayerTextDrawSetPreviewRot(playerid, UpgCongrTxt[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

	UpgItemSlot[playerid] = CreatePlayerTextDraw(playerid, 308.000000, 220.000000, "item_slot");
	PlayerTextDrawLetterSize(playerid, UpgItemSlot[playerid], 0.000000, -1.800002);
	PlayerTextDrawTextSize(playerid, UpgItemSlot[playerid], 20.000000, 20.000000);
	PlayerTextDrawAlignment(playerid, UpgItemSlot[playerid], 2);
	PlayerTextDrawColor(playerid, UpgItemSlot[playerid], -1);
	PlayerTextDrawUseBox(playerid, UpgItemSlot[playerid], true);
	PlayerTextDrawBoxColor(playerid, UpgItemSlot[playerid], 0);
	PlayerTextDrawSetShadow(playerid, UpgItemSlot[playerid], 0);
	PlayerTextDrawSetOutline(playerid, UpgItemSlot[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, UpgItemSlot[playerid], -1378294017);
	PlayerTextDrawFont(playerid, UpgItemSlot[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid, UpgItemSlot[playerid], -1);
	PlayerTextDrawSetPreviewRot(playerid, UpgItemSlot[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

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

	MpBtn[playerid] = TextDrawCreate(317.866638, 244.874221, "Зарегистрировать");
	TextDrawLetterSize(MpBtn[playerid], 0.213533, 0.988148);
	TextDrawTextSize(MpBtn[playerid], 7.833320, 77.985191);
	TextDrawAlignment(MpBtn[playerid], 2);
	TextDrawColor(MpBtn[playerid], 255);
	TextDrawUseBox(MpBtn[playerid], true);
	TextDrawBoxColor(MpBtn[playerid], 0);
	TextDrawSetShadow(MpBtn[playerid], 0);
	TextDrawSetOutline(MpBtn[playerid], 0);
	TextDrawBackgroundColor(playerid, MpBtn[playerid], 51);
	TextDrawFont(MpBtn[playerid], 1);
	TextDrawSetProportional(MpBtn[playerid], 1);
	TextDrawSetSelectable(MpBtn[playerid], true);
}

stock HideNativeHUD(playerid)
{
	ToggleHUDComponentForPlayer(playerid, HUD_COMPONENT_HEALTH, false);
	ToggleHUDComponentForPlayer(playerid, HUD_COMPONENT_BREATH, false);
	ToggleHUDComponentForPlayer(playerid, HUD_COMPONENT_ARMOUR, false);
	ToggleHUDComponentForPlayer(playerid, HUD_COMPONENT_MINIMAP, false);
	ToggleHUDComponentForPlayer(playerid, HUD_COMPONENT_MONEY, false);
}

stock ShowHUD(playerid)
{
	new string[128];

	format(string, sizeof(string), "%d", PlayerInfo[playerid][Rank]);
	PlayerTextDrawSetStringRus(playerid, RankText[playerid], string);
	PlayerTextDrawColor(playerid, RankText[playerid], HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
	PlayerTextDrawShow(playerid, RankText[playerid]);
	PlayerTextDrawShow(playerid, RankRing[playerid]);

	PlayerTextDrawSetStringRus(playerid, PlayerNameText[playerid], PlayerInfo[playerid][Name]);
	PlayerTextDrawColor(playerid, PlayerNameText[playerid], HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
	PlayerTextDrawShow(playerid, PlayerNameText[playerid]);

	PlayerTextDrawSetStringRus(playerid, PlayerCashText[playerid], FormatMoney(PlayerInfo[playerid][Cash]));
	PlayerTextDrawShow(playerid, PlayerCashText[playerid]);
	PlayerTextDrawShow(playerid, CashIcon[playerid]);

	ShowPlayerProgressBar(playerid, PlayerHPBar[playerid]);
	PlayerTextDrawShow(playerid, PlayerHPBarNumbers[playerid]);
}

stock UpdateHUDRank(playerid)
{
	new string[128];

	format(string, sizeof(string), "%d", PlayerInfo[playerid][Rank]);
	PlayerTextDrawHide(playerid, RankText[playerid]);
	PlayerTextDrawSetStringRus(playerid, RankText[playerid], string);
	PlayerTextDrawColor(playerid, RankText[playerid], HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
	PlayerTextDrawShow(playerid, RankText[playerid]);

	PlayerTextDrawHide(playerid, PlayerNameText[playerid]);
	PlayerTextDrawColor(playerid, PlayerNameText[playerid], HexRateColors[PlayerInfo[playerid][Rank]-1][0]);
	PlayerTextDrawShow(playerid, PlayerNameText[playerid]);
}

stock UpdateHUDMoney(playerid)
{
	PlayerTextDrawSetStringRus(playerid, PlayerCashText[playerid], FormatMoney(PlayerInfo[playerid][Cash]));
}

stock GivePlayerCash(playerid, money)
{
	GivePlayerMoney(playerid, money);
	UpdateHUDMoney(playerid);
}

stock HideHUD(playerid)
{
	HidePlayerProgressBar(playerid, PlayerHPBar[playerid]);
	PlayerTextDrawHide(playerid, PlayerHPBarNumbers[playerid]);
	PlayerTextDrawHide(playerid, RankText[playerid]);
	PlayerTextDrawHide(playerid, PlayerNameText[playerid]);
	PlayerTextDrawHide(playerid, PlayerCashText[playerid]);
	PlayerTextDrawHide(playerid, CashIcon[playerid]);
	PlayerTextDrawHide(playerid, RankRing[playerid]);
}

stock ShowTextDraws(playerid)
{
	TextDrawShowForPlayer(playerid, Version);
}

stock DeleteTextDraws()
{
	TextDrawDestroy(Version);
}

stock DeletePlayerTextDraws(playerid)
{
	DestroyPlayerProgressBar(playerid, PlayerHPBar[playerid]);

	PlayerTextDrawDestroy(playerid, RankRing[playerid]);
	PlayerTextDrawDestroy(playerid, RankText[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerNameText[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerHPBarNumbers[playerid]);
	PlayerTextDrawDestroy(playerid, CashIcon[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerCashText[playerid]);

	PlayerTextDrawDestroy(playerid, ChrInfoDelim1[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoDelim2[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoDelim3[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoDelim4[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoDelim5[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoDelim6[playerid]);
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
	PlayerTextDrawDestroy(playerid, ChrInfoClose[playerid]);
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
	PlayerTextDrawDestroy(playerid, ChrInfoSkin[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfCritMult[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfCritMultReduction[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfCritReduction[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfVamp[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfRegeneration[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfDamageReflection[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfRateIcon[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfCritChance[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoHeader[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfoBox[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfNextInvBtn[playerid]);
	PlayerTextDrawDestroy(playerid, ChrInfPrevInvBtn[playerid]);
	for(new i = 0; i < MAX_PAGE_SLOTS; i++)
	{
		PlayerTextDrawDestroy(playerid, ChrInfInvSlot[playerid][i]);
		PlayerTextDrawDestroy(playerid, ChrInfInvSlotCount[playerid][i]);
	}

	PlayerTextDrawDestroy(playerid, EqInfBox[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfTxt1[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfClose[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim1[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfItemName[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfItemType[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfMinRank[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfGrade[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfStage[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfItemIcon[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim2[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim3[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfSpecialParamsText[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim4[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfDelim5[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfPrice[playerid]);
	PlayerTextDrawDestroy(playerid, EqInfTrading[playerid]);
	for(new i = 0; i < 4; i++)
	{
		PlayerTextDrawDestroy(playerid, EqInfMainStats[playerid][i]);
	}
	for(new i = 0; i < MAX_STATS; i++)
	{
		PlayerTextDrawDestroy(playerid, EqInfSpecialStats[playerid][i]);
	}
	for(new i = 0; i < 3; i++)
	{
		PlayerTextDrawDestroy(playerid, EqInfDescriptionStr[playerid][i]);
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
	PlayerTextDrawDestroy(playerid, UpgBtn[playerid]);
	PlayerTextDrawDestroy(playerid, UpgSafeBtn[playerid]);
	PlayerTextDrawDestroy(playerid, UpgPotionSlot[playerid]);
	PlayerTextDrawDestroy(playerid, UpgItemSlot[playerid]);
	PlayerTextDrawDestroy(playerid, UpgDefSlot[playerid]);
	PlayerTextDrawDestroy(playerid, UpgDefCount[playerid]);
	PlayerTextDrawDestroy(playerid, UpgPotionCount[playerid]);
	PlayerTextDrawDestroy(playerid, UpgOldItemTxt[playerid]);
	PlayerTextDrawDestroy(playerid, UpgNewItemTxt[playerid]);
	PlayerTextDrawDestroy(playerid, UpgArrow[playerid]);
	PlayerTextDrawDestroy(playerid, UpgMainTxt[playerid]);
	PlayerTextDrawDestroy(playerid, UpgCongrTxt[playerid]);
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
	TextDrawDestroy(playerid, MpBtn[playerid]);

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
	Create3DTextLabel("Заведующий турнирами",0x3366FFFF,226.7674,-1837.6835,3.6120,55.0,0,1);
	Create3DTextLabel("Почта",0x3366CCFF,212.3999,-1838.2000,3.0000,55.0,0,0);
	Create3DTextLabel("Рынок",0xFF9900FF,231.7,-1840.6,4.2,55.0,0,0);
	Create3DTextLabel("Командующий",0xCC0000FF,229.6244,-1834.8005,3.6818,55.0,0,0);

	Actors[0] =	CreateActor(26,-2166.7527,646.0400,1052.3750,179.9041);
	Actors[1] =	CreateActor(6,189.2644,-1825.4902,4.1411,185.0134);
	Actors[2] =	CreateActor(60,262.6658,-1825.2792,3.9126,181.2770);
	Actors[3] =	CreateActor(249,221.0985,-1838.1259,3.6268,177.8066);
	Actors[4] =	CreateActor(61,226.7674,-1837.6835,3.6120,188.3151);
	Actors[5] =	CreateActor(1,218.1786,-1835.7053,3.7114,178.7002);
	Actors[6] =	CreateActor(165,229.6244,-1834.8005,3.6818,179.0444);
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

	/*CreateObject(19076,195.8000000,-1854.9000000,2.3000000,0.0000000,0.0000000,0.0000000); //object(xmas) (1)
	CreateObject(19054,195.6082,-1856.1352,2.7000000,0.0000000,0.0000000,20.0000000); //object(xmas) (1)
	CreateObject(19056,195.5078,-1853.9680,2.7000000,0.0000000,0.0000000,30.0000000); //object(xmas) (1)
	CreateObject(19057,197.0055,-1854.7861,2.7000000,0.0000000,0.0000000,40.0000000); //object(xmas) (1)

	new cola_veh_id = CreateVehicle(515,183.7026,-1861.7371,3.9194,359.9408,39,47,3); //Roadtrain
	new cola_trailer_veh_id = CreateVehicle(435,183.7002000,-1872.4004000,3.4000000,0.0000000,245,245,3); //Trailer 1

	SetVehicleParamsEx(cola_veh_id, 0, 0, 0, 1, 0, 0, 0);
	SetVehicleParamsEx(cola_trailer_veh_id, 0, 0, 0, 1, 0, 0, 0);*/
}
