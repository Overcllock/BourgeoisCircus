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

+Table 'warehouse':

varchar 'PlayerName' 
int 'SlotID'
int 'ItemID' = -1
varchar 'SlotMod' = '0 0 0 0 0 0 0' 
int 'Count' = 0