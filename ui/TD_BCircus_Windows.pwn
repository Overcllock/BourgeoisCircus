
//Player Textdraws(Äëÿ èãðîêà):

new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:Textdraw1[MAX_PLAYERS];
new PlayerText:Textdraw2[MAX_PLAYERS];
new PlayerText:Textdraw3[MAX_PLAYERS];
new PlayerText:Textdraw4[MAX_PLAYERS];
new PlayerText:Textdraw5[MAX_PLAYERS];
new PlayerText:Textdraw6[MAX_PLAYERS];
new PlayerText:Textdraw7[MAX_PLAYERS];
new PlayerText:Textdraw8[MAX_PLAYERS];
new PlayerText:Textdraw9[MAX_PLAYERS];
new PlayerText:Textdraw10[MAX_PLAYERS];
new PlayerText:Textdraw11[MAX_PLAYERS];
new PlayerText:Textdraw12[MAX_PLAYERS];
new PlayerText:Textdraw13[MAX_PLAYERS];
new PlayerText:Textdraw14[MAX_PLAYERS];


Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 102.000000, 252.207397, "empty");
PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.449999, 1.600000);
PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw0[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw0[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw0[playerid], 4);
PlayerTextDrawSetProportional(playerid, Textdraw0[playerid], 1);

Textdraw1[playerid] = CreatePlayerTextDraw(playerid, 389.000030, 151.248153, "inf_box");
PlayerTextDrawLetterSize(playerid, Textdraw1[playerid], 0.000000, 10.677566);
PlayerTextDrawTextSize(playerid, Textdraw1[playerid], 249.333328, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw1[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw1[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw1[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw1[playerid], 102);
PlayerTextDrawSetShadow(playerid, Textdraw1[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw1[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw1[playerid], 0);

Textdraw2[playerid] = CreatePlayerTextDraw(playerid, 319.833190, 150.702148, "Information");
PlayerTextDrawLetterSize(playerid, Textdraw2[playerid], 0.251999, 0.903110);
PlayerTextDrawAlignment(playerid, Textdraw2[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw2[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw2[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw2[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw2[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw2[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw2[playerid], 1);

Textdraw3[playerid] = CreatePlayerTextDraw(playerid, 250.666656, 160.575088, "inf_delim1");
PlayerTextDrawLetterSize(playerid, Textdraw3[playerid], 0.000000, -0.233333);
PlayerTextDrawTextSize(playerid, Textdraw3[playerid], 136.326660, 2.200000);
PlayerTextDrawAlignment(playerid, Textdraw3[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw3[playerid], 16711935);
PlayerTextDrawUseBox(playerid, Textdraw3[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw3[playerid], 0);
PlayerTextDrawSetShadow(playerid, Textdraw3[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw3[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw3[playerid], 5);
PlayerTextDrawSetPreviewModel(playerid, Textdraw3[playerid], 18656);
PlayerTextDrawSetPreviewRot(playerid, Textdraw3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

Textdraw4[playerid] = CreatePlayerTextDraw(playerid, 255.000000, 175.000000, "inf_itemicon");
PlayerTextDrawLetterSize(playerid, Textdraw4[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw4[playerid], 24.000000, 24.888885);
PlayerTextDrawAlignment(playerid, Textdraw4[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw4[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw4[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw4[playerid], 0);
PlayerTextDrawSetShadow(playerid, Textdraw4[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw4[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw4[playerid], -1378294017);
PlayerTextDrawFont(playerid, Textdraw4[playerid], 5);
PlayerTextDrawSetPreviewModel(playerid, Textdraw4[playerid], -1);
PlayerTextDrawSetPreviewRot(playerid, Textdraw4[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

Textdraw5[playerid] = CreatePlayerTextDraw(playerid, 320.166534, 164.805816, "Shazok's document");
PlayerTextDrawLetterSize(playerid, Textdraw5[playerid], 0.221333, 0.865777);
PlayerTextDrawAlignment(playerid, Textdraw5[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw5[playerid], -5963521);
PlayerTextDrawSetShadow(playerid, Textdraw5[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw5[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw5[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw5[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw5[playerid], 1);

Textdraw6[playerid] = CreatePlayerTextDraw(playerid, 282.899749, 176.093154, "Passive item");
PlayerTextDrawLetterSize(playerid, Textdraw6[playerid], 0.221333, 0.865777);
PlayerTextDrawAlignment(playerid, Textdraw6[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw6[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw6[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw6[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw6[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw6[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw6[playerid], 1);

Textdraw7[playerid] = CreatePlayerTextDraw(playerid, 283.033142, 189.206115, "Decreases required rank for equip by 1");
PlayerTextDrawLetterSize(playerid, Textdraw7[playerid], 0.167666, 0.749629);
PlayerTextDrawAlignment(playerid, Textdraw7[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw7[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw7[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw7[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw7[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw7[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw7[playerid], 1);

Textdraw8[playerid] = CreatePlayerTextDraw(playerid, 251.033248, 204.010681, "inf_delim2");
PlayerTextDrawLetterSize(playerid, Textdraw8[playerid], 0.000000, -0.233333);
PlayerTextDrawTextSize(playerid, Textdraw8[playerid], 137.000000, 2.200000);
PlayerTextDrawAlignment(playerid, Textdraw8[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw8[playerid], 16711935);
PlayerTextDrawUseBox(playerid, Textdraw8[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw8[playerid], 0);
PlayerTextDrawSetShadow(playerid, Textdraw8[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw8[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw8[playerid], 5);
PlayerTextDrawSetPreviewModel(playerid, Textdraw8[playerid], 18656);
PlayerTextDrawSetPreviewRot(playerid, Textdraw8[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

Textdraw9[playerid] = CreatePlayerTextDraw(playerid, 320.033020, 209.909637, "Description string 1");
PlayerTextDrawLetterSize(playerid, Textdraw9[playerid], 0.167666, 0.749629);
PlayerTextDrawAlignment(playerid, Textdraw9[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw9[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw9[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw9[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw9[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw9[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw9[playerid], 1);

Textdraw10[playerid] = CreatePlayerTextDraw(playerid, 319.999633, 217.297683, "Description string 2");
PlayerTextDrawLetterSize(playerid, Textdraw10[playerid], 0.167666, 0.749629);
PlayerTextDrawAlignment(playerid, Textdraw10[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw10[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw10[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw10[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw10[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw10[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw10[playerid], 1);

Textdraw11[playerid] = CreatePlayerTextDraw(playerid, 320.032867, 224.644271, "Description string 3");
PlayerTextDrawLetterSize(playerid, Textdraw11[playerid], 0.167666, 0.749629);
PlayerTextDrawAlignment(playerid, Textdraw11[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw11[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw11[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw11[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw11[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw11[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw11[playerid], 1);

Textdraw12[playerid] = CreatePlayerTextDraw(playerid, 250.733505, 235.624023, "inf_delim3");
PlayerTextDrawLetterSize(playerid, Textdraw12[playerid], 0.000000, -0.116666);
PlayerTextDrawTextSize(playerid, Textdraw12[playerid], 137.000000, 2.200000);
PlayerTextDrawAlignment(playerid, Textdraw12[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw12[playerid], 16711935);
PlayerTextDrawUseBox(playerid, Textdraw12[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw12[playerid], 0);
PlayerTextDrawSetShadow(playerid, Textdraw12[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw12[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw12[playerid], 5);
PlayerTextDrawSetPreviewModel(playerid, Textdraw12[playerid], 18656);
PlayerTextDrawSetPreviewRot(playerid, Textdraw12[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

Textdraw13[playerid] = CreatePlayerTextDraw(playerid, 385.499847, 238.776184, "Price: 999999999$");
PlayerTextDrawLetterSize(playerid, Textdraw13[playerid], 0.221333, 0.865777);
PlayerTextDrawAlignment(playerid, Textdraw13[playerid], 3);
PlayerTextDrawColor(playerid, Textdraw13[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw13[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw13[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw13[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw13[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw13[playerid], 1);

Textdraw14[playerid] = CreatePlayerTextDraw(playerid, 382.366668, 148.586669, "x");
PlayerTextDrawLetterSize(playerid, Textdraw14[playerid], 0.354333, 1.272296);
PlayerTextDrawAlignment(playerid, Textdraw14[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw14[playerid], -2147483393);
PlayerTextDrawSetShadow(playerid, Textdraw14[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw14[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw14[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw14[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw14[playerid], 1);
PlayerTextDrawSetSelectable(playerid, Textdraw14[playerid], true);
PlayerTextDrawSetPreviewModel(playerid, Textdraw14[playerid], 18656);
PlayerTextDrawSetPreviewRot(playerid, Textdraw14[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

