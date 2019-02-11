
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


Textdraw0[playerid] = CreatePlayerTextDraw(playerid, 224.000000, 247.644439, "empty");
PlayerTextDrawLetterSize(playerid, Textdraw0[playerid], 0.449999, 1.600000);
PlayerTextDrawAlignment(playerid, Textdraw0[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw0[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw0[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw0[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw0[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw0[playerid], 4);
PlayerTextDrawSetProportional(playerid, Textdraw0[playerid], 1);

Textdraw1[playerid] = CreatePlayerTextDraw(playerid, 383.666778, 153.737030, "upg_box");
PlayerTextDrawLetterSize(playerid, Textdraw1[playerid], 0.000000, 10.753333);
PlayerTextDrawTextSize(playerid, Textdraw1[playerid], 255.666656, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw1[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw1[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw1[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw1[playerid], 102);
PlayerTextDrawSetShadow(playerid, Textdraw1[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw1[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw1[playerid], 0);

Textdraw2[playerid] = CreatePlayerTextDraw(playerid, 320.166687, 153.481506, "Modification");
PlayerTextDrawLetterSize(playerid, Textdraw2[playerid], 0.267666, 1.044148);
PlayerTextDrawAlignment(playerid, Textdraw2[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw2[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw2[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw2[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw2[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw2[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw2[playerid], 1);

Textdraw3[playerid] = CreatePlayerTextDraw(playerid, 256.966674, 163.727508, "upg_delim1");
PlayerTextDrawLetterSize(playerid, Textdraw3[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw3[playerid], 124.566665, 2.200000);
PlayerTextDrawAlignment(playerid, Textdraw3[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw3[playerid], 16711935);
PlayerTextDrawUseBox(playerid, Textdraw3[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw3[playerid], 0);
PlayerTextDrawSetShadow(playerid, Textdraw3[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw3[playerid], 0);
PlayerTextDrawFont(playerid, Textdraw3[playerid], 5);
PlayerTextDrawSetPreviewModel(playerid, Textdraw3[playerid], 18656);
PlayerTextDrawSetPreviewRot(playerid, Textdraw3[playerid], 0.000000, 0.000000, 0.000000, 1.000000);

Textdraw4[playerid] = CreatePlayerTextDraw(playerid, 320.066711, 176.425201, "7th modification");
PlayerTextDrawLetterSize(playerid, Textdraw4[playerid], 0.245666, 0.919703);
PlayerTextDrawAlignment(playerid, Textdraw4[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw4[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw4[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw4[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw4[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw4[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw4[playerid], 1);

Textdraw5[playerid] = CreatePlayerTextDraw(playerid, 305.100158, 193.345382, "item_slot");
PlayerTextDrawLetterSize(playerid, Textdraw5[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw5[playerid], 30.000000, 30.000000);
PlayerTextDrawAlignment(playerid, Textdraw5[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw5[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw5[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw5[playerid], 0);
PlayerTextDrawSetShadow(playerid, Textdraw5[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw5[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw5[playerid], -1378294017);
PlayerTextDrawFont(playerid, Textdraw5[playerid], 5);
PlayerTextDrawSetSelectable(playerid, Textdraw5[playerid], true);
PlayerTextDrawSetPreviewModel(playerid, Textdraw5[playerid], -1);
PlayerTextDrawSetPreviewRot(playerid, Textdraw5[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

Textdraw6[playerid] = CreatePlayerTextDraw(playerid, 320.500091, 225.543746, "Item");
PlayerTextDrawLetterSize(playerid, Textdraw6[playerid], 0.189999, 0.766222);
PlayerTextDrawAlignment(playerid, Textdraw6[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw6[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw6[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw6[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw6[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw6[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw6[playerid], 1);

Textdraw7[playerid] = CreatePlayerTextDraw(playerid, 271.533660, 203.217758, "stone_slot");
PlayerTextDrawLetterSize(playerid, Textdraw7[playerid], 0.000000, 0.000000);
PlayerTextDrawTextSize(playerid, Textdraw7[playerid], 20.000000, 20.000000);
PlayerTextDrawAlignment(playerid, Textdraw7[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw7[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw7[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw7[playerid], 0);
PlayerTextDrawSetShadow(playerid, Textdraw7[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw7[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw7[playerid], -1378294017);
PlayerTextDrawFont(playerid, Textdraw7[playerid], 5);
PlayerTextDrawSetSelectable(playerid, Textdraw7[playerid], true);
PlayerTextDrawSetPreviewModel(playerid, Textdraw7[playerid], -1);
PlayerTextDrawSetPreviewRot(playerid, Textdraw7[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

Textdraw8[playerid] = CreatePlayerTextDraw(playerid, 282.066864, 224.967407, "Stone");
PlayerTextDrawLetterSize(playerid, Textdraw8[playerid], 0.189999, 0.766222);
PlayerTextDrawAlignment(playerid, Textdraw8[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw8[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw8[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw8[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw8[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw8[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw8[playerid], 1);

Textdraw9[playerid] = CreatePlayerTextDraw(playerid, 347.999938, 204.199996, "potion_slot");
PlayerTextDrawLetterSize(playerid, Textdraw9[playerid], 0.000000, 0.033333);
PlayerTextDrawTextSize(playerid, Textdraw9[playerid], 20.000000, 20.000000);
PlayerTextDrawAlignment(playerid, Textdraw9[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw9[playerid], -1);
PlayerTextDrawUseBox(playerid, Textdraw9[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw9[playerid], 0);
PlayerTextDrawSetShadow(playerid, Textdraw9[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw9[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw9[playerid], -1378294017);
PlayerTextDrawFont(playerid, Textdraw9[playerid], 5);
PlayerTextDrawSetSelectable(playerid, Textdraw9[playerid], true);
PlayerTextDrawSetPreviewModel(playerid, Textdraw9[playerid], -1);
PlayerTextDrawSetPreviewRot(playerid, Textdraw9[playerid], 0.000000, 0.000000, 90.000000, 1.000000);

Textdraw10[playerid] = CreatePlayerTextDraw(playerid, 358.533477, 225.677017, "Potion");
PlayerTextDrawLetterSize(playerid, Textdraw10[playerid], 0.189999, 0.766222);
PlayerTextDrawAlignment(playerid, Textdraw10[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw10[playerid], -1);
PlayerTextDrawSetShadow(playerid, Textdraw10[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw10[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw10[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw10[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw10[playerid], 1);

Textdraw11[playerid] = CreatePlayerTextDraw(playerid, 369.333312, 237.654083, "btn_upg");
PlayerTextDrawLetterSize(playerid, Textdraw11[playerid], 0.000000, 0.835599);
PlayerTextDrawTextSize(playerid, Textdraw11[playerid], 270.333312, 0.000000);
PlayerTextDrawAlignment(playerid, Textdraw11[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw11[playerid], 0);
PlayerTextDrawUseBox(playerid, Textdraw11[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw11[playerid], 8388863);
PlayerTextDrawSetShadow(playerid, Textdraw11[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw11[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw11[playerid], 8388863);
PlayerTextDrawFont(playerid, Textdraw11[playerid], 0);
PlayerTextDrawSetSelectable(playerid, Textdraw11[playerid], true);

Textdraw12[playerid] = CreatePlayerTextDraw(playerid, 320.200012, 235.905120, "Upgrade");
PlayerTextDrawLetterSize(playerid, Textdraw12[playerid], 0.275333, 1.060740);
PlayerTextDrawAlignment(playerid, Textdraw12[playerid], 2);
PlayerTextDrawColor(playerid, Textdraw12[playerid], 255);
PlayerTextDrawUseBox(playerid, Textdraw12[playerid], true);
PlayerTextDrawBoxColor(playerid, Textdraw12[playerid], 0);
PlayerTextDrawSetShadow(playerid, Textdraw12[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw12[playerid], 0);
PlayerTextDrawBackgroundColor(playerid, Textdraw12[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw12[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw12[playerid], 1);

Textdraw13[playerid] = CreatePlayerTextDraw(playerid, 373.333251, 151.614868, "x");
PlayerTextDrawLetterSize(playerid, Textdraw13[playerid], 0.347000, 1.243259);
PlayerTextDrawAlignment(playerid, Textdraw13[playerid], 1);
PlayerTextDrawColor(playerid, Textdraw13[playerid], -2147483393);
PlayerTextDrawSetShadow(playerid, Textdraw13[playerid], 0);
PlayerTextDrawSetOutline(playerid, Textdraw13[playerid], 1);
PlayerTextDrawBackgroundColor(playerid, Textdraw13[playerid], 51);
PlayerTextDrawFont(playerid, Textdraw13[playerid], 1);
PlayerTextDrawSetProportional(playerid, Textdraw13[playerid], 1);
PlayerTextDrawSetSelectable(playerid, Textdraw13[playerid], true);

