/* MIGRATIONS */
Table 'players':

-'Rank'
-'MaxRank'
+int 'Level'
+int 'OC'
+int 'CP'
+int 'Status'
+boolean 'IsWatcher'
'Rate' => 'Exp'

Table 'items':
'MinRank' => 'MinLevel'

Table 'tournament_tab':
'RateDiff' => 'OC'

+Table 'warehouse':

varchar 'PlayerName' 
int 'SlotID'
int 'ItemID' = -1
varchar 'SlotMod' = '0 0 0 0 0 0 0' 
int 'Count' = 0

/* SQL */
/** Items **/
INSERT INTO `items`(`ID`, `Name`, `Type`, `Grade`, `MinLevel`, `Description`, `Property`, `PropertyVal`, `Price`, `Model`, `ModelRotX`, `ModelRotY`, `ModelRotZ`) 
VALUES (318, 'Генератор опыта', 4, 1, 1, 'Опыт х2. Действует 1 турнир', '0 0', '0 0', 80000, 19134, 0, 0, 0);