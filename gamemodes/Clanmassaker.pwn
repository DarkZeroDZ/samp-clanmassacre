/*
Notizen:
-/Start & /Pause entbuggen
-Timer bei 00:00 beenden lassen
-Sobeitcheck verbessern
-Banfunktion erweitern (mit timer)
-Adminchat hinzufuegen
-Admins im chat rot färben
-Cookie that man a give
*/

#if defined message
________________________________________________________________________________________________________
|   								DDDDDDDDDDDDD       ZZZZZZZZZZZZZZZZZZ                             |
|   								DDDD     DDDDD      ZZZZZZZZZZZZZZZZZZ                             |
|   								DDDD      DDDDD     ZZZZZZZZZZZZZZZZZZ                             |
|   								DDDD       DDDDD                ZZZZZZ                             |
|   								DDDD        DDDDD   ZZZZZZZZZZZZZZZZZZ                             |
|   								DDDD        DDDDD   ZZZZZZZZZZZZZZZZZZ                             |
|   								DDDD        DDDDD   ZZZZZZZZZZZZZZZZZZ                             |
|   								DDDD       DDDDD    ZZZZZ                                          |
|  									DDDD      DDDDD     ZZZZZZZZZZZZZZZZZZ                             |
|   								DDDD     DDDDD      ZZZZZZZZZZZZZZZZZZ                             |
|   								DDDDDDDDDDDDD       ZZZZZZZZZZZZZZZZZZ                             |
|                                                                                                      |
|                                   |                                    |                             |
|                                   |   DarkZero's SF Airport Massacre   |                             |
|									|   Scriptname: DZ_Massacre     v1.0 |                             |
|                                                                                                      |
|                                                                                                      |
|                                                                                                      |
|		INFOS ABOUT THIS GAMEMODE                                                                      |
|                                                                                                      |
| This Include was made by DarkZero, and                                                               |
| he called this Gamemode: DZ_Massacre.                                                                |
| DZ_Massacre is a Gamemode, with that                                                                 |
| you can organize your own Clanmassacre-                                                              |
| Event.                                                                                               |
|                                                                                                      |
|                FEATURES                      											               |
|                                                                                                      |
|   -Easy ways to change the clannames  												               |
|   -Sobeit check 				(Included from the DZ_Anticheat Include! (Advertisement ftw))          |
|   -Anti Aimbot				(Included from the DZ_Anticheat Include! (Same shit here))             |
|   -8 Spawns for 8 Clans 		(Unbelievable, right?)     											   |
|   -Admin Login with /Zuege	(That gay command name wasn't my idea)                                 |
|   -Low FPS check  	                      														   |
|   -High Ping check               														               |
|   -/Spec command for spectators  													                   |
|   -Some commands 				(WOW :O)												               |
|                                                                                                      |
| To set the clantags, change the already used	             							               |
| clantags in "OnGameModeInit". They will also                                                         |
| changed in the Event-Bar.					                                                           |
| To change the spawns, you just have to change            							                   |
| the coordinates from the teams in "OnPlayerSpawn".                       							   |
| To start the Massacre, use /Start ingame when                         							   |
| you are logged in as admin!	                             										   |
|                            																		   |
|                            																		   |
|                            																		   |
| You're allowed to change everything whatever you want, but it would be really cool, if               |
| you don't change the "#define SCRIPT_ERSTELLER" :)                                                   |
|                          																			   |
| Enjoy using this Gamemode.           																   |
| Greetz,	                                                 								           |
| DarkZero         																	                   |
________________________________________________________________________________________________________
#endif

#include <a_samp>
#include <sscanf>
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

//// MAX_... MIN_... ////
new MAXPING = 250;
#define MIN_FPS 30
#undef MAX_PLAYERS
#define MAX_PLAYERS 70

//// Konfiguationen ////
#define SCRIPT_ERSTELLER "DarkZero"
#define EVENT_ORGANISATOR "[$R]"
#define GAME_MODE_TEXT "SF Airport Clanmassacre"

#define MAP_NAME "Script by "#SCRIPT_ERSTELLER""
#define HOST_NAME ">> "#EVENT_ORGANISATOR"'s All vs. All Tournament [0.3x!!] <<"

//IF YOU DEFINE THIS, THE MASSACRE VERSION GETS LOADED
//WARNING: DON'T UNDEF MASSACRE, BECAUSE THE TOURNAMENT-VERSION IS ACTUALLY BUGGED!

#define MASSACRE

#define CLAN1 TFR
#define CLAN2 RsT
#define CLAN3 NSA
#define CLAN4 $R
#define CLAN5 0wN
#define CLAN6 NFoP
#define CLAN7 GSR
#define CLAN8 SAB

//// Farben ////
#define Gelb 0xFFFA00FF
#define Weiß 0x000000FF
#define Gruen 0x00FF1EFF
#define Rot 0xFF0005FF
#define weiss 0xFFFFFFFF
#define COLOR_ONE 0xFF444499
#define COLOR_TWO 0xFFFF22AA
#define COLOR_THREE 0xFFCC2299

//// Dialoge ////
#define DIALOG_TEAM 0

//// Anticheat ////
#define PUB:%1(%2) forward %1(%2); public %1(%2)
#define FREEZE_SECONDS 4

//// Clans ////
new Clan1[MAX_PLAYER_NAME];
new Clan2[MAX_PLAYER_NAME];
new Clan3[MAX_PLAYER_NAME];
new Clan4[MAX_PLAYER_NAME];
new Clan5[MAX_PLAYER_NAME];
new Clan6[MAX_PLAYER_NAME];
new Clan7[MAX_PLAYER_NAME];
new Clan8[MAX_PLAYER_NAME];

//// Position ////
new pPosition[MAX_PLAYERS];
new position[5];
new Text:Tposliste;

//// Autos ////
new Auto[43];
new Timer2[3];

//// Ping Kick ////
new Ping1[MAX_PLAYERS];
forward Ping2(playerid);
forward OnPlayerUpdate(playerid);

//// FPS unso ////
new DLlast[MAX_PLAYERS] = 0;
new FPS2[MAX_PLAYERS] = 0;
new shitsent;
new shitsent2;
forward FPSUP();
forward AUP(playerid);

//// Textdraws ////
new Text:werbung;
new Text:massaker;
new Text:FPS[MAX_PLAYERS];
new Text:Leiste;
new Text:Strich;
new Text:Scriptersteller;
forward PunkteleisteUpdate();

new Punkte[10];
new Pause;
new Penis;
new SpawnPoint[MAX_PLAYERS];
new stringtu[128];
new interpolate;

/////// Timer ///////
new Text:Uhr;
forward Sekundenupdate();
new Minuten;
new Sekunden;

/// Chat ///
new Chatlock[MAX_PLAYERS];
new chatopen;

new countdown = 30;
forward countmedown();
forward uhr();
forward Timer();
forward Pausentimer();
forward SendClientMessageToAdmins(color,string[]);

main()
{
	print("\n==============================");
	print(" Clan Massaker has been loaded ");
	print(" scripted by "#SCRIPT_ERSTELLER"®");
	print("==============================");
}

enum pinfo
{
    firstspawn,
    pname[MAX_PLAYER_NAME],
    hacker
};
new gpInfo[MAX_PLAYERS][pinfo];

public OnGameModeInit()
{
	////// Konfiguation //////
	#if defined MASSACRE
	Clan1=""#CLAN1"";
    Clan2=""#CLAN2"";
	Clan3=""#CLAN3"";
    Clan4=""#CLAN4"";
	Clan5=""#CLAN5"";
    Clan6=""#CLAN6"";
	Clan7=""#CLAN7"";
    Clan8=""#CLAN8"";
    #endif
	EnableStuntBonusForAll(false);
	SetGameModeText(""#GAME_MODE_TEXT"");
	SendRconCommand("hostname "#HOST_NAME"");
	SendRconCommand("mapname "#MAP_NAME"");

	////////// Map ///////////
	CreateObject(1339, -194.89999, 1880.80005, 114.4, 0, 0, 0);
	CreateObject(1339, -194.89999, 1880.59998, 115.6, 0, 0, 0);
	CreateObject(1339, -194.89999, 1880.40002, 116.9, 0, 0, 0);
	CreateObject(1339, -194.89999, 1880.30005, 118.2, 0, 0, 0);
	CreateObject(1339, -194.8, 1880.19995, 119.5, 0, 0, 0);
	CreateObject(1339, -194.8, 1880.09998, 120.8, 0, 0, 0);
	CreateObject(1339, -189.5, 1876.80005, 116, 0, 0, 0);
	CreateObject(1339, -194.8, 1879.90002, 122.1, 0, 0, 0);
	CreateObject(1339, -194.8, 1879.69995, 123.3, 0, 0, 0);
	CreateObject(1339, -194.89999, 1879.5, 124.6, 0, 0, 0);
	CreateObject(1339, -194.10001, 1880.59998, 114.5, 0, 0, 0);
	CreateObject(1339, -193.2, 1879.90002, 114.6, 0, 0, 0);
	CreateObject(1339, -193.7, 1880.30005, 114.5, 0, 0, 0);
	CreateObject(1339, -192.8, 1879.5, 114.6, 0, 0, 0);
	CreateObject(1339, -192.2, 1879.09998, 114.6, 0, 0, 0);
	CreateObject(1339, -191.7, 1878.69995, 114.7, 0, 0, 0);
	CreateObject(1339, -191.10001, 1878.19995, 114.7, 0, 0, 0);
	CreateObject(1339, -190.7, 1877.90002, 114.8, 0, 0, 0);
	CreateObject(1339, -190.10001, 1877.40002, 114.8, 0, 0, 0);
	CreateObject(1339, -189.7, 1877, 114.8, 0, 0, 0);
	CreateObject(1339, -184.8, 1874.69995, 113.8, 0, 0, 0);
	CreateObject(1339, -184.8, 1874.59998, 115.1, 0, 0, 0);
	CreateObject(1339, -184.89999, 1874.59998, 116.4, 0, 0, 0);
	CreateObject(1339, -185, 1874.59998, 117.7, 0, 0, 0);
	CreateObject(1339, -185.10001, 1874.5, 119, 0, 0, 0);
	CreateObject(1339, -185.3, 1874.40002, 120.3, 0, 0, 0);
	CreateObject(1339, -185.5, 1874.30005, 121.6, 0, 0, 0);
	CreateObject(1339, -185.60001, 1874.19995, 122.9, 0, 0, 0);
	CreateObject(1339, -185.60001, 1874.19995, 124.2, 0, 0, 0);
	CreateObject(1339, -185.7, 1874.09998, 125.5, 0, 0, 0);
	CreateObject(1339, -178.7, 1870.19995, 113, 0, 0, 0);
	CreateObject(1339, -178.60001, 1870.19995, 114.3, 0, 0, 0);
	CreateObject(1339, -178.60001, 1870.09998, 115.6, 0, 0, 0);
	CreateObject(1339, -178.60001, 1870.09998, 116.9, 0, 0, 0);
	CreateObject(1339, -178.7, 1870, 118.2, 0, 0, 0);
	CreateObject(1339, -178.89999, 1869.90002, 119.5, 0, 0, 0);
	CreateObject(1339, -179, 1869.80005, 120.8, 0, 0, 0);
	CreateObject(1339, -179.2, 1869.69995, 122, 0, 0, 0);
	CreateObject(1339, -179.3, 1869.59998, 123.3, 0, 0, 0);
	CreateObject(1339, -179.39999, 1869.5, 124.6, 0, 0, 0);
	CreateObject(1339, -185, 1874.40002, 120.3, 0, 0, 0);
	CreateObject(1339, -184.89999, 1874.40002, 120.2, 0, 0, 0);
	CreateObject(1339, -184.10001, 1874.30005, 120, 0, 0, 0);
	CreateObject(1339, -183.60001, 1873.80005, 120, 0, 0, 0);
	CreateObject(1339, -183.2, 1873.40002, 120, 0, 0, 0);
	CreateObject(1339, -182.5, 1873, 120, 0, 0, 0);
	CreateObject(1339, -182, 1872.59998, 120, 0, 0, 0);
	CreateObject(1339, -181.2, 1872.19995, 120, 0, 0, 0);
	CreateObject(1339, -180.7, 1871.69995, 120, 0, 0, 0);
	CreateObject(1339, -180.10001, 1871.19995, 120, 0, 0, 0);
	CreateObject(1339, -179.3, 1870.69995, 120, 0, 0, 0);
	CreateObject(1339, -181.60001, 1872.40002, 120, 0, 0, 0);
	CreateObject(1339, -189.39999, 1876.59998, 117.2, 0, 0, 0);
	CreateObject(1339, -189.3, 1876.40002, 118.4, 0, 0, 0);
	CreateObject(1339, -189.2, 1876.19995, 119.6, 0, 0, 0);
	CreateObject(1339, -189, 1876, 120.8, 0, 0, 0);
	CreateObject(1339, -189.2, 1876.19995, 122, 0, 0, 0);
	CreateObject(1339, -189.39999, 1876.30005, 123.2, 0, 0, 0);
	CreateObject(1339, -189.60001, 1876.5, 124.4, 0, 0, 0);
	CreateObject(1339, -194.5, 1880.59998, 114.5, 0, 0, 0);
	CreateObject(1339, -194.3, 1880.5, 125, 0, 0, 0);
	CreateObject(1339, -193.8, 1880.19995, 125, 0, 0, 0);
	CreateObject(1339, -193.3, 1879.80005, 125, 0, 0, 0);
	CreateObject(1339, -192.89999, 1879.40002, 125, 0, 0, 0);
	CreateObject(1339, -192.39999, 1879, 125, 0, 0, 0);
	CreateObject(1339, -191.89999, 1878.59998, 125, 0, 0, 0);
	CreateObject(1339, -191.3, 1878.09998, 125, 0, 0, 0);
	CreateObject(1339, -190.8, 1877.69995, 125, 0, 0, 0);
	CreateObject(1339, -190.3, 1877.40002, 125, 0, 0, 0);
	CreateObject(1339, -189.89999, 1877, 125, 0, 0, 0);
	CreateObject(5155, -218.60001, 1815.19995, 97, 0, 0, 240);
	CreateObject(3472, -196.8, 1892.80005, 113.5, 0, 0, 0);
	CreateObject(3472, -170.8, 1874.59998, 113.1, 0, 0, 0);
	CreateObject(3472, -174, 1897, 113.2, 0, 0, 0);
	CreateObject(3472, -220.39999, 1836, 93.9, 0, 0, 0);
	CreateObject(3472, -199.39999, 1824, 93.9, 0, 0, 0);
	CreateObject(3472, -235.5, 1806.80005, 107.2, 0, 0, 0);
	CreateObject(3472, -217.3, 1796.5, 107.2, 0, 0, 0);
	CreateObject(3472, -209.3, 1800, 103.6, 0, 0, 0);
	CreateObject(3472, -236.39999, 1815.59998, 103.7, 0, 0, 0);

	//// Skins /////
    AddPlayerClass(223,2642.9819,1774.8007,18.8092,90,0,0,0,0,0,0);
	AddPlayerClass(105,2531.6394,-1667.4774,15.1687,91.7106,0,0,0,0,0,0);
	AddPlayerClass(106,2531.6394,-1667.4774,15.1687,91.7106,0,0,0,0,0,0);
	AddPlayerClass(107,2531.6394,-1667.4774,15.1687,91.7106,0,0,0,0,0,0);
	AddPlayerClass(102,1909.5679,-1120.4241,25.8779,172.9802,0,0,0,0,0,0);
	AddPlayerClass(103,1909.5679,-1120.4241,25.8779,172.9802,0,0,0,0,0,0);
	AddPlayerClass(104,1909.5679,-1120.4241,25.8779,172.9802,0,0,0,0,0,0);
	AddPlayerClass(115,1761.6294,-1895.7822,13.5617,259.2283,0,0,0,0,0,0);
	AddPlayerClass(114,1761.6294,-1895.7822,13.5617,259.2283,0,0,0,0,0,0);
	AddPlayerClass(116,1761.6294,-1895.7822,13.5617,259.2283,0,0,0,0,0,0);
	AddPlayerClass(110,2142.2092,-1176.6504,23.9922,280.3629,0,0,0,0,0,0);
	AddPlayerClass(109,2142.2092,-1176.6504,23.9922,280.3629,0,0,0,0,0,0);
	AddPlayerClass(108,2142.2092,-1176.6504,23.9922,280.3629,0,0,0,0,0,0);
	AddPlayerClass(280,1551.9027,-1676.2671,16.0586,94.2343,0,0,0,0,0,0);
	AddPlayerClass(281,1551.9027,-1676.2671,16.0586,94.2343,0,0,0,0,0,0);
	AddPlayerClass(283,1551.9027,-1676.2671,16.0586,94.2343,0,0,0,0,0,0);
	AddPlayerClass(169,-2624.6086,1403.2001,7.1016,174.9866,0,0,0,0,0,0);
	AddPlayerClass(214,-2624.6086,1403.2001,7.1016,174.9866,0,0,0,0,0,0);
	AddPlayerClass(56,-2624.6086,1403.2001,7.1016,174.9866,0,0,0,0,0,0);
	AddPlayerClass(111,-2181.5559,641.4707,49.4375,94.4420,0,0,0,0,0,0);
	AddPlayerClass(112,-2181.5559,641.4707,49.4375,94.4420,0,0,0,0,0,0);
	AddPlayerClass(113,-2181.5559,641.4707,49.4375,94.4420,0,0,0,0,0,0);
	AddPlayerClass(29,2520.2239,-1281.5540,34.8516,81.8404,0,0,0,0,0,0);
	AddPlayerClass(28,2520.2239,-1281.5540,34.8516,81.8404,0,0,0,0,0,0);
	AddPlayerClass(21,2520.2239,-1281.5540,34.8516,81.8404,0,0,0,0,0,0);
	AddPlayerClass(274,1607.2864,1816.5037,10.8203,2.1774,0,0,0,0,0,0);
	AddPlayerClass(275,1607.2864,1816.5037,10.8203,2.1774,0,0,0,0,0,0);
	AddPlayerClass(276,1607.2864,1816.5037,10.8203,2.1774,0,0,0,0,0,0);
	AddPlayerClass(277,1769.8210,2079.8547,10.8203,181.9882,0,0,0,0,0,0);
	AddPlayerClass(278,1769.8210,2079.8547,10.8203,181.9882,0,0,0,0,0,0);
	AddPlayerClass(279,1769.8210,2079.8547,10.8203,181.9882,0,0,0,0,0,0);
	AddPlayerClass(260,2675.9167,829.1090,10.9545,181.4022,0,0,0,0,0,0);
	AddPlayerClass(16,2675.9167,829.1090,10.9545,181.4022,0,0,0,0,0,0);
	AddPlayerClass(27,2675.9167,829.1090,10.9545,181.4022,0,0,0,0,0,0);
	AddPlayerClass(205,2838.2488,2402.9072,11.0690,223.7740,0,0,0,0,0,0);
	AddPlayerClass(155,2838.2488,2402.9072,11.0690,223.7740,0,0,0,0,0,0);
	AddPlayerClass(167,2838.2488,2402.9072,11.0690,223.7740,0,0,0,0,0,0);

	//// Fahrzeuge ////
	AddStaticVehicle(411,2112.1999512,1439.1999512,10.3999996,0.0000000,98,68); //Infernus
	AddStaticVehicle(560,2107.8999023,1439.0999756,10.6000004,0.0000000,115,14); //Sultan
	AddStaticVehicle(560,2104.0000000,1439.0000000,10.6000004,0.0000000,77,98); //Sultan
	AddStaticVehicle(522,2101.6999512,1440.0999756,10.5000000,0.0000000,48,79); //NRG-500
	AddStaticVehicle(522,2100.3999023,1440.0999756,10.5000000,0.0000000,76,117); //NRG-500
	AddStaticVehicle(522,2099.1000977,1440.0999756,10.5000000,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,2097.8999023,1440.0000000,10.5000000,0.0000000,48,79); //NRG-500
	AddStaticVehicle(487,2132.3000488,1440.1999512,11.1000004,0.0000000,151,149); //Maverick
	AddStaticVehicle(487,2153.8999023,1678.9000244,11.0000000,0.0000000,93,126); //Maverick
	AddStaticVehicle(411,2150.0000000,1678.5000000,10.3999996,0.0000000,16,80); //Infernus
	AddStaticVehicle(560,2157.6000977,1694.8000488,10.5000000,0.0000000,111,103); //Sultan
	AddStaticVehicle(560,2160.1999512,1690.0999756,10.6000004,0.0000000,115,46); //Sultan
	AddStaticVehicle(522,2147.5000000,1678.6999512,10.5000000,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,2146.3999023,1678.6999512,10.5000000,0.0000000,189,190); //NRG-500
	AddStaticVehicle(522,2146.3999023,1675.4000244,10.5000000,0.0000000,132,4); //NRG-500
	AddStaticVehicle(522,2147.6000977,1675.0000000,10.5000000,0.0000000,48,79); //NRG-500
	AddStaticVehicle(487,2065.1000977,1881.9000244,11.8999996,0.0000000,165,169); //Maverick
	AddStaticVehicle(411,2068.8000488,1883.4000244,11.1999998,0.0000000,93,126); //Infernus
	AddStaticVehicle(560,2068.1999512,1875.5999756,11.1999998,0.0000000,94,112); //Sultan
	AddStaticVehicle(560,2072.8000488,1877.0000000,11.1999998,0.0000000,94,112); //Sultan
	AddStaticVehicle(522,2056.1999512,1895.1999512,11.6000004,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,2058.5000000,1894.3000488,11.6000004,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,2059.8999023,1893.9000244,11.6000004,0.0000000,132,4); //NRG-500
	AddStaticVehicle(522,2061.5000000,1893.3000488,11.5000000,0.0000000,132,4); //NRG-500
	AddStaticVehicle(411,2080.8999023,2164.1000977,10.3999996,0.0000000,89,110); //Infernus
	AddStaticVehicle(560,2085.6000977,2165.0000000,10.6000004,0.0000000,118,123); //Sultan
	AddStaticVehicle(560,2089.8000488,2165.6000977,10.6000004,0.0000000,94,112); //Sultan
	AddStaticVehicle(487,2076.1000977,2173.5000000,11.1000004,0.0000000,151,149); //Maverick
	AddStaticVehicle(522,2081.1999512,2176.3000488,10.5000000,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,2083.6000977,2176.5000000,10.5000000,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,2085.3000488,2176.6000977,10.5000000,0.0000000,189,190); //NRG-500
	AddStaticVehicle(522,2087.6999512,2176.8000488,10.5000000,0.0000000,109,122); //NRG-500
	AddStaticVehicle(522,1708.9000244,1451.1999512,10.5000000,0.0000000,215,142); //NRG-500
	AddStaticVehicle(522,1709.3000488,1454.1999512,10.5000000,0.0000000,132,4); //NRG-500
	AddStaticVehicle(522,1709.1999512,1456.9000244,10.5000000,0.0000000,109,122); //NRG-500
	AddStaticVehicle(522,1709.4000244,1459.5999756,10.5000000,0.0000000,132,4); //NRG-500
	AddStaticVehicle(411,1706.6999512,1442.0999756,10.3999996,0.0000000,34,52); //Infernus
	AddStaticVehicle(560,1706.9000244,1434.8000488,10.3999996,0.0000000,77,98); //Sultan
	AddStaticVehicle(560,1706.6999512,1427.5000000,10.3000002,0.0000000,45,58); //Sultan
	AddStaticVehicle(487,1717.6999512,1452.5000000,11.1000004,0.0000000,165,169); //Maverick
	AddStaticVehicle(487,2413.8999023,1651.6999512,11.1000004,0.0000000,165,169); //Maverick
	AddStaticVehicle(411,2408.3999023,1657.9000244,10.3999996,0.0000000,32,32); //Infernus
	AddStaticVehicle(560,2405.1999512,1657.8000488,10.6000004,0.0000000,118,123); //Sultan
	AddStaticVehicle(560,2402.1999512,1657.8000488,10.6000004,0.0000000,45,58); //Sultan
	AddStaticVehicle(522,2407.6999512,1667.6999512,10.5000000,0.0000000,132,4); //NRG-500
	AddStaticVehicle(522,2408.8999023,1667.5000000,10.5000000,0.0000000,189,190); //NRG-500
	AddStaticVehicle(522,2404.8000488,1667.5999756,10.5000000,0.0000000,132,4); //NRG-500
	AddStaticVehicle(522,2406.1000977,1667.5999756,10.5000000,0.0000000,76,117); //NRG-500
	AddStaticVehicle(522,2616.6999512,1826.4000244,10.5000000,0.0000000,132,4); //NRG-500
	AddStaticVehicle(522,2616.8999023,1823.3000488,10.5000000,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,2613.6000977,1826.1999512,10.5000000,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,2613.5000000,1823.1999512,10.5000000,0.0000000,132,4); //NRG-500
	AddStaticVehicle(411,2617.8999023,1817.5000000,10.3999996,0.0000000,32,32); //Infernus
	AddStaticVehicle(560,2618.1999512,1831.5999756,10.6000004,0.0000000,94,112); //Sultan
	AddStaticVehicle(560,2614.0000000,1831.1999512,10.6000004,0.0000000,118,123); //Sultan
	AddStaticVehicle(487,2606.3000488,1825.0000000,11.1000004,0.0000000,165,169); //Maverick
	AddStaticVehicle(487,996.9000244,1153.0000000,11.1000004,0.0000000,39,47); //Maverick
	AddStaticVehicle(560,1003.0000000,1153.5999756,10.6000004,0.0000000,45,58); //Sultan
	AddStaticVehicle(560,1008.7000122,1153.8000488,10.5000000,0.0000000,115,46); //Sultan
	AddStaticVehicle(411,1013.5000000,1154.0999756,10.3000002,0.0000000,34,52); //Infernus
	AddStaticVehicle(560,-1258.0999756,29.5000000,14.0000000,136.0000000,77,98); //Sultan
	AddStaticVehicle(522,-1259.5000000,31.3999996,13.8000002,136.0000000,48,79); //NRG-500
	AddStaticVehicle(522,-1260.3000488,32.5000000,13.8000002,136.0000000,215,142); //NRG-500
	AddStaticVehicle(522,-1162.9000244,-165.1999969,13.8000002,0.0000000,189,190); //NRG-500
	AddStaticVehicle(522,-1164.9000244,-165.3999939,13.8000002,0.0000000,37,37); //NRG-500
	AddStaticVehicle(560,-1165.3000488,-160.1999969,14.0000000,100.0000000,77,98); //Sultan
	AddStaticVehicle(560,-1316.1999512,-342.1000061,14.0000000,0.0000000,158,164); //Sultan
	AddStaticVehicle(522,-1314.1999512,-343.1000061,13.8000002,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,-1311.9000244,-343.3999939,13.8000002,0.0000000,189,190); //NRG-500
	AddStaticVehicle(522,-1422.9000244,-548.7999878,13.8000002,252.0000000,109,122); //NRG-500
	AddStaticVehicle(522,-1428.5000000,-551.5000000,13.8000002,155.9998779,189,190); //NRG-500
	AddStaticVehicle(560,-1425.4000244,-550.7000122,14.0000000,204.0000000,94,112); //Sultan
	AddStaticVehicle(560,-1590.8000488,-518.7999878,21.8999996,0.0000000,115,14); //Sultan
	AddStaticVehicle(522,-1588.1999512,-518.5000000,21.7999992,0.0000000,109,122); //NRG-500
	AddStaticVehicle(522,-1586.8000488,-518.2999878,21.7999992,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,-1461.8000488,-208.3999939,13.8000002,0.0000000,37,37); //NRG-500
	AddStaticVehicle(522,-1464.5000000,-207.6999969,13.8000002,0.0000000,37,37); //NRG-500
	AddStaticVehicle(560,-1468.8000488,-207.1999969,14.0000000,0.0000000,158,164); //Sultan
	AddStaticVehicle(560,-1462.0000000,29.0000000,13.8999996,0.0000000,77,98); //Sultan
	AddStaticVehicle(522,-1464.5999756,27.2000008,13.8000002,0.0000000,132,4); //NRG-500
	AddStaticVehicle(522,-1466.5999756,26.0000000,13.8000002,0.0000000,48,79); //NRG-500
	AddStaticVehicle(522,-1110.4000244,378.5000000,13.8000002,136.0000000,132,4); //NRG-500
	AddStaticVehicle(522,-1110.0999756,377.5000000,13.8000002,132.0000000,48,79); //NRG-500
	AddStaticVehicle(560,-1111.6999512,382.0000000,13.8999996,132.0000000,158,164); //Sultan

	////// Textdraws //////
	werbung = TextDrawCreate(486.000000,421.000000, "www.SR-Page.tk");
	TextDrawBackgroundColor(werbung, 255);
	TextDrawFont(werbung, 1);
	TextDrawLetterSize(werbung, 0.500000, 1.000000);
	TextDrawColor(werbung, -1);
	TextDrawSetOutline(werbung, 0);
	TextDrawSetProportional(werbung, 1);
	TextDrawSetShadow(werbung, 1);

	massaker = TextDrawCreate(36.000000, 324.000000, "SF Airport Clanmassacre");
	TextDrawBackgroundColor(massaker, 255);
	TextDrawFont(massaker, 1);
	TextDrawLetterSize(massaker, 0.280000, 1.000000);
	TextDrawColor(massaker, -1);
	TextDrawSetOutline(massaker, 0);
	TextDrawSetProportional(massaker, 1);
	TextDrawSetShadow(massaker, 1);

	Leiste = TextDrawCreate(-7.000000,435.000000, "Welcome to $R's  >> SF Airport Clanmassacre << Event! Have fun!");
	TextDrawBackgroundColor(Leiste, 255);
	TextDrawFont(Leiste, 1);
	TextDrawLetterSize(Leiste, 0.599999,1.200000);
	TextDrawColor(Leiste, -1);
	TextDrawSetOutline(Leiste, 1);
	TextDrawSetProportional(Leiste, 1);
	TextDrawSetShadow(Leiste, 1);
	TextDrawUseBox(Leiste, 1);
	TextDrawBoxColor(Leiste, 0x00000099);
	TextDrawTextSize(Leiste, 659.000000,0.000000);
	TextDrawBackgroundColor(Leiste,0xffffffff);
	
	Tposliste = TextDrawCreate(21.000000,122.000000," ");
	TextDrawAlignment(Tposliste,0);
	TextDrawBackgroundColor(Tposliste,0x000000ff);
	TextDrawFont(Tposliste,1);
	TextDrawLetterSize(Tposliste,0.199999,0.899999);
	TextDrawColor(Tposliste,0xffffffff);
	TextDrawSetOutline(Tposliste,1);
	TextDrawSetProportional(Tposliste,1);
	TextDrawSetShadow(Tposliste,1);

	Uhr = TextDrawCreate(547.000000, 23.000000, "60:00");
	TextDrawBackgroundColor(Uhr, 255);
	TextDrawFont(Uhr, 3);
	TextDrawLetterSize(Uhr, 0.55, 2.15);
	TextDrawColor(Uhr, -1);
	TextDrawSetOutline(Uhr, 2);
	TextDrawSetProportional(Uhr, 0);
	TextDrawSetShadow(Uhr, 0);

	Strich = TextDrawCreate(479.000000,411.000000,"-");
	Scriptersteller = TextDrawCreate(481.000000,391.000000,"By: "#SCRIPT_ERSTELLER"");
	TextDrawAlignment(Strich,0);
	TextDrawAlignment(Scriptersteller,0);
	TextDrawBackgroundColor(Strich,0x000000ff);
	TextDrawBackgroundColor(Scriptersteller,0x000000ff);
	TextDrawFont(Strich,3);
	TextDrawLetterSize(Strich,10.699998,1.000000);
	TextDrawFont(Scriptersteller,0);
	TextDrawLetterSize(Scriptersteller,0.699999,2.000000);
	TextDrawColor(Strich,0xffffffff);
	TextDrawColor(Scriptersteller,0xffffffff);
	TextDrawSetOutline(Strich,1);
	TextDrawSetOutline(Scriptersteller,1);
	TextDrawSetProportional(Strich,1);
	TextDrawSetProportional(Scriptersteller,1);
	TextDrawSetShadow(Strich,1);
	TextDrawSetShadow(Scriptersteller,1);

    SetTimer("FPSUP",50,true);
	ShowPlayerMarkers(1);
	UsePlayerPedAnims();
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SpawnPoint[playerid]=0;
	SetPlayerPos(playerid,2027.6360,1008.0895,10.8203);
	SetPlayerFacingAngle(playerid,272.3518);
	SetPlayerColor(playerid,weiss);
	if(interpolate == 0)
	{
		InterpolateCameraPos(playerid, 2037.831176, 1143.007812, 68.982063, 2035.511962, 1008.074523, 10.748481, 3000);
		InterpolateCameraLookAt(playerid, 2037.776123, 1138.436157, 66.957862, 2030.786865, 1007.970336, 12.380118, 3000);
		interpolate = 1;
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(chatopen == 0)
	{
		Chatlock[playerid] = 0;
	}
	else if(chatopen == 1)
	{
		Chatlock[playerid] = 1;
	}
	
	////////Anticheat/////////
	gpInfo[playerid][hacker] = 0;
    gpInfo[playerid][firstspawn] = 1;
    GetPlayerName(playerid, gpInfo[playerid][pname], MAX_PLAYER_NAME);
    
    SetPVarInt(playerid,"spect",-1);
    SetPVarInt(playerid,"spec",-1);
    Ping1[playerid] = 0;
	SetTimerEx("Ping2", 1000*10, false, "%d", playerid);
	TextDrawShowForPlayer(playerid, massaker);
	TextDrawShowForPlayer(playerid, werbung);
	TextDrawShowForPlayer(playerid, Leiste);
	TextDrawShowForPlayer(playerid, Uhr);
	TextDrawShowForPlayer(playerid, Strich);
	TextDrawShowForPlayer(playerid, Scriptersteller);
	PunkteleisteUpdate();
	SendClientMessage(playerid, -1,"");
	SendClientMessage(playerid, -1,"");
	SendClientMessage(playerid, -1,"");
	SendClientMessage(playerid,0x008CDBFF,"-------------------------------------------------------------------------------------");
	#if defined MASSACRE
	SendClientMessage(playerid, weiss,"Welcome to $R's San Fierro Clanmassacre Gamemode.");
	#else
	SendClientMessage(playerid, weiss,"Welcome to $R's Las Venturas All vs. All Tournament!");
	#endif
	SendClientMessage(playerid, weiss,"To see all commands, use {008CDB}/Help {FFFFFF} or {00FF00}/AHelp{FFFFFF}!"); // !!!!!!!!
	SendClientMessage(playerid, weiss,"Use {008CDB}/Report{FFFFFF}, to report some retarded faggots which are cheating!"); // !!!!!!!
	SendClientMessage(playerid, weiss,"");
	SendClientMessage(playerid, weiss," (C) by DarkZero @ 2014");
	SendClientMessage(playerid, 0x008CDBFF,"------------------------------------------------------------------------------------");
    new string[128];
    format(string, sizeof(string), "{008CDB}<{00FF00}+{008CDB}> {FFFFFF}%s has {00FF00}joined {FFFFFF}the server.", SpielerName(playerid));
	SendClientMessageToAll(weiss, string);
	new IP[16];
	GetPlayerIp(playerid, IP, sizeof(IP));
	format(string, sizeof(string), "*** IP: %s", IP);
	SendClientMessageToAdmins(weiss,string);
	FPS[playerid] = TextDrawCreate(560.000000,1.000000, "~y~FPS: 101");
	TextDrawBackgroundColor(FPS[playerid], 255);
	TextDrawFont(FPS[playerid], 2);
	TextDrawLetterSize(FPS[playerid], 0.399999,2.300000);
	TextDrawColor(FPS[playerid], -1);
	TextDrawSetOutline(FPS[playerid], 1);
	TextDrawSetProportional(FPS[playerid], 1);
	TextDrawSetShadow(FPS[playerid], 1);
	TextDrawShowForPlayer(playerid, FPS[playerid]);
	FPS2[playerid] = 201;
	interpolate = 0;
	TextDrawShowForPlayer(playerid, Tposliste);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new string[128];
    switch(reason)
    {
        case 0:
        {
             format(string, sizeof(string), "{008CDB}<{00FF00}+{008CDB}> {FFFFFF}%s has {FF0000}left {FFFFFF}the server. (Timeout)", SpielerName(playerid));
             SendClientMessageToAll(-1, string);
        }
        case 1:
        {
             format(string, sizeof(string), "{008CDB}<{00FF00}+{008CDB}> {FFFFFF}%s has {FF0000}left {FFFFFF}the server.", SpielerName(playerid));
             SendClientMessageToAll(-1, string);
        }
        case 2:
        {
             format(string, sizeof(string), "{008CDB}<{00FF00}+{008CDB}> {FFFFFF}%s has {FF0000}left {FFFFFF}the server. (Kicked/Banned)", SpielerName(playerid));
             SendClientMessageToAll(-1, string);
        }
    }
	if(GetPVarInt(playerid,"spect")!=-1)
 	{
        TogglePlayerSpectating(GetPVarInt(playerid,"spect"),0);
        SetCameraBehindPlayer(GetPVarInt(playerid,"spect"));
        SetPVarInt(GetPVarInt(playerid,"spect"),"spec",-1);
 	}
 	else if(GetPVarInt(playerid,"spec")!=-1)SetPVarInt(GetPVarInt(playerid,"spec"),"spec",-1);
 	#if defined MASSACRE
	TextDrawHideForPlayer(playerid, Tposliste);
	for(new i=0; i<sizeof(position); i++)
	{
	    if(position[i]==playerid) position[i]=-1;
	}
	UpdatePosListe();
	#endif
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	#if defined MASSACRE
	if(SpawnPoint[playerid]==0)
	{
		format(stringtu,sizeof(stringtu), "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\nSpectator",Clan1, Clan2,Clan3,Clan4,Clan5,Clan6,Clan7,Clan8);
		ShowPlayerDialog(playerid, DIALOG_TEAM, DIALOG_STYLE_LIST, "Please select a team",stringtu,"Choose","");
		return 0;
	}
	#else
	if(SpawnPoint[playerid]==0)
	{
		format(stringtu,sizeof(stringtu), "Fighter\nSpectator");
		ShowPlayerDialog(playerid, DIALOG_TEAM, DIALOG_STYLE_LIST, "Please select a team",stringtu,"Choose","");
		return 0;
	}
	#endif
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(gpInfo[playerid][firstspawn] == 1)
	{
        gpInfo[playerid][firstspawn] = 0;
        SetCameraBehindPlayer(playerid);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("HackCheck", FREEZE_SECONDS * 1000, 0, "i", playerid);
        SendClientMessage(playerid, -1, "[DZ-Anticheat] The Server is now checking your game for illegal programs...");
    }

	interpolate = 0;
    SpawnPoint[playerid]=0;
    SetPlayerVirtualWorld(playerid, 0);
	SetPlayerArmour(playerid, 100);
	GivePlayerWeapon(playerid, 26, 9000);
	GivePlayerWeapon(playerid, 28, 9000);
	GivePlayerWeapon(playerid, 34, 9000);
	GivePlayerWeapon(playerid, 31, 9000);
	if(GetPlayerTeam(playerid)==8) //SPECTATOR
	{
		SetPlayerPos(playerid,-1228.6090,-73.5443,27.2478), SetPlayerFacingAngle(playerid, 104);
		SetPlayerColor(playerid,weiss);
		SetPlayerHealth(playerid,100000);
		ResetPlayerWeapons(playerid);
	}
	if(GetPlayerTeam(playerid)==0) //FIGHTER
	{
		SetPlayerColor(playerid,0xEB0000FF);
		SetPlayerPos(playerid,-1259.3331,39.1276,13.8103), SetPlayerFacingAngle(playerid, 104);
		SetPlayerHealth(playerid,100);
	}
	if(GetPlayerTeam(playerid)==1) 
	{
		SetPlayerColor(playerid,0x0A00FFFF);
		SetPlayerPos(playerid,-1147.4347,-141.8193,13.8149), SetPlayerFacingAngle(playerid, 104);
		SetPlayerHealth(playerid,100);
	}
	if(GetPlayerTeam(playerid)==2) 
	{
		SetPlayerColor(playerid,0x009114FF);
		SetPlayerPos(playerid,-1316.1782,-338.0087,13.8200), SetPlayerFacingAngle(playerid, 104);
		SetPlayerHealth(playerid,100);
	}
	if(GetPlayerTeam(playerid)==3) 
	{
		SetPlayerColor(playerid,0xEBFF00FF);
		SetPlayerPos(playerid,-1437.6344,-532.2512,13.8107), SetPlayerFacingAngle(playerid, 104);
		SetPlayerHealth(playerid,100);
	}
	if(GetPlayerTeam(playerid)==4)
	{
		SetPlayerColor(playerid,0xFF00F5FF);
		SetPlayerPos(playerid,-1602.1313,-499.4893,21.7705), SetPlayerFacingAngle(playerid, 104);
		SetPlayerHealth(playerid,100);
	}
	if(GetPlayerTeam(playerid)==5) 
	{
		SetPlayerColor(playerid,0xFEFEFEFF);
		SetPlayerPos(playerid,-1450.7074,-205.5756,13.8210), SetPlayerFacingAngle(playerid, 104);
		SetPlayerHealth(playerid,100);
	}
	if(GetPlayerTeam(playerid)==6) 
	{
		SetPlayerColor(playerid,0x006E00FF);
		SetPlayerPos(playerid,-1453.4174,68.7298,14.1181), SetPlayerFacingAngle(playerid, 104);
		SetPlayerHealth(playerid,100);
	}
	if(GetPlayerTeam(playerid)==7) 
	{
		SetPlayerColor(playerid,0x9F00FFFC);
		SetPlayerPos(playerid,-1026.6875,460.7740,14.2168), SetPlayerFacingAngle(playerid, 104);
		SetPlayerHealth(playerid,100);
	}
	SetCameraBehindPlayer(playerid);
	if(Pause == 1 )
	{
   		TogglePlayerControllable(playerid,true);
	}
	else
	{
		TogglePlayerControllable(playerid,false);
	}
	return 1;
}


public OnPlayerDeath(playerid, killerid, reason)
{
	#if defined MASSACRE
	///////// Clan 1 /////////
 	if(GetPlayerTeam(killerid) == 0)
	{
 		Punkte[1] ++;
		if(IsPlayerInAnyVehicle(killerid))
		{
			Punkte[1] = Punkte[1]-3;
		}
	}
	///////// Clan 2 /////////
	if(GetPlayerTeam(killerid) == 1)
	{
 		Punkte[2] ++;
		if(IsPlayerInAnyVehicle(killerid))
		{
			Punkte[2] = Punkte[2]-3;
		}
	}
	///////// Clan 3 /////////
	if(GetPlayerTeam(killerid) == 2)
	{
 		Punkte[3] ++;
		if(IsPlayerInAnyVehicle(killerid))
		{
			Punkte[3] = Punkte[3]-3;
		}
	}
	///////// Clan 4 /////////
	if(GetPlayerTeam(killerid) == 3)
	{
 		Punkte[4] ++;
		if(IsPlayerInAnyVehicle(killerid))
		{
			Punkte[4] = Punkte[4]-3;
		}
	}
	///////// Clan 5 /////////
	if(GetPlayerTeam(killerid) == 4)
	{
 		Punkte[5] ++;
		if(IsPlayerInAnyVehicle(killerid))
		{
			Punkte[5] = Punkte[5]-3;
		}
	}
	///////// Clan 6 /////////
	if(GetPlayerTeam(killerid) == 5)
	{
 		Punkte[6] ++;
		if(IsPlayerInAnyVehicle(killerid))
		{
			Punkte[6] = Punkte[6]-3;
		}
	}
	///////// Clan 7 /////////
	if(GetPlayerTeam(killerid) == 6)
	{
 		Punkte[7] ++;
		if(IsPlayerInAnyVehicle(killerid))
		{
			Punkte[7] = Punkte[7]-3;
		}
	}
	///////// Clan 8 ////////
	if(GetPlayerTeam(killerid) == 7)
	{
 		Punkte[8] ++;
		if(IsPlayerInAnyVehicle(killerid))
		{
			Punkte[8] = Punkte[8]-3;
		}
	}
	PunkteleisteUpdate();
	#else
//	PlayerInfo[playerid][Kills]++;
	pPosition[playerid]=floatround(RaceCheckpoints[gPlayerProgress[playerid]][3],floatround_floor);
	SetRaceText(playerid, gRacePosition[playerid]);
	for(new i=0; i<sizeof(position); i++)
	{
	    if(position[i]==playerid) position[i]=-1;
	}
	position[gRacePosition[playerid]-1]=playerid;
	UpdatePosListe();
	#endif
	SetPlayerScore(killerid, GetPlayerScore(killerid)+1);
	SendDeathMessage(killerid,playerid,reason);
	return 1;
}


public OnPlayerText(playerid, text[])
{
	#if defined MASSACRE
	if(text[0]=='!')
	{
	    new string[128];
	    switch	(GetPlayerTeam(playerid))
		{
			case 0:
	  		{
				format(string,sizeof(string),"(Clanchat) %s: %s",SpielerName(playerid),text[1]);
				for(new i=0;i<MAX_PLAYERS;i++)
	   	    		if(IsPlayerConnected(i))
	   	    		    if(GetPlayerTeam(i)==0)
	   	    		        SendClientMessage(i,0x91FF00FF,string);
                return 0;
	   		}
	        case 1:
	        {
				format(string,sizeof(string),"(Clanchat) %s: %s",SpielerName(playerid),text[1]);
				for(new i=0;i<MAX_PLAYERS;i++)
	   	    		if(IsPlayerConnected(i))
	   	    		    if(GetPlayerTeam(i)==1)
	   	    		        SendClientMessage(i,0x91FF00FF,string);
                return 0;
			}
			case 2:
	  		{
				format(string,sizeof(string),"(Clanchat) %s: %s",SpielerName(playerid),text[1]);
				for(new i=0;i<MAX_PLAYERS;i++)
	   	    		if(IsPlayerConnected(i))
	   	    		    if(GetPlayerTeam(i)==2)
	   	    		        SendClientMessage(i,0x91FF00FF,string);
                return 0;
	   		}
	        case 3:
	        {
				format(string,sizeof(string),"(Clanchat) %s: %s",SpielerName(playerid),text[1]);
				for(new i=0;i<MAX_PLAYERS;i++)
	   	    		if(IsPlayerConnected(i))
	   	    		    if(GetPlayerTeam(i)==3)
	   	    		        SendClientMessage(i,0x91FF00FF,string);
                return 0;
			}
			case 4:
	  		{
				format(string,sizeof(string),"(Clanchat) %s: %s",SpielerName(playerid),text[1]);
				for(new i=0;i<MAX_PLAYERS;i++)
	   	    		if(IsPlayerConnected(i))
	   	    		    if(GetPlayerTeam(i)==4)
	   	    		        SendClientMessage(i,0x91FF00FF,string);
                return 0;
	   		}
	        case 5:
	        {
				format(string,sizeof(string),"(Clanchat) %s: %s",SpielerName(playerid),text[1]);
				for(new i=0;i<MAX_PLAYERS;i++)
	   	    		if(IsPlayerConnected(i))
	   	    		    if(GetPlayerTeam(i)==5)
	   	    		        SendClientMessage(i,0x91FF00FF,string);
                return 0;
			}
			case 6:
	  		{
				format(string,sizeof(string),"(Clanchat) %s: %s",SpielerName(playerid),text[1]);
				for(new i=0;i<MAX_PLAYERS;i++)
	   	    		if(IsPlayerConnected(i))
	   	    		    if(GetPlayerTeam(i)==6)
	   	    		        SendClientMessage(i,0x91FF00FF,string);
                return 0;
	   		}
	        case 7:
	        {
				format(string,sizeof(string),"(Clanchat) %s: %s",SpielerName(playerid),text[1]);
				for(new i=0;i<MAX_PLAYERS;i++)
	   	    		if(IsPlayerConnected(i))
	   	    		    if(GetPlayerTeam(i)==7)
	   	    		        SendClientMessage(i,0x91FF00FF,string);
                return 0;
			}
			case 8:
	  		{
				format(string,sizeof(string),"(Zuschauerchat) %s: %s",SpielerName(playerid),text[1]);
				for(new i=0;i<MAX_PLAYERS;i++)
	   	    		if(IsPlayerConnected(i))
	   	    		    if(GetPlayerTeam(i)==8)
	   	    		        SendClientMessage(i,0x91FF00FF,string);
				return 0;
	   		}
	   	}
	}
	#endif
	if(Chatlock[playerid] == 0)
	{
    	SendClientMessage(playerid, Rot, "The chat is locked.");
    	return 0;
    }

	new string[128];
	new color = GetPlayerColor(playerid);
	if(!IsPlayerAdmin(playerid))
	{
   		format(string,sizeof(string),"%s{AFAFAF} [%d]{FFFFFF}: %s",SpielerName(playerid),playerid, text);
    	SendClientMessageToAll(color, string);
    }
    else
    {
    	format(string,sizeof(string),"%s{AFAFAF} [%d]{FFFFFF}: {FF0000}%s",SpielerName(playerid),playerid, text);
    	SendClientMessageToAll(color, string);
	}
	return 0;
}

dcmd_report(playerid,params[])
{
	new pID, grund[128];
	if(sscanf(params,"us",pID,grund))return SendClientMessage(playerid,Rot,"Use: /report [ID] [Reason]");
 	new string[128];
	format(string,sizeof(string),"%s has reportet %s!(Reason: %s)",SpielerName(playerid),SpielerName(pID),grund);
	SendClientMessageToAdmins(Rot, string);
	SendClientMessage(playerid, 0x00FF28FF, "Thank you for your Report!");
	return 1;
}

dcmd_kick(playerid,params[])
{
	if(IsPlayerAdmin(playerid) == 1)
	{
		new pID, grund[128];
		if(sscanf(params,"us",pID,grund))return SendClientMessage(playerid,Rot,"Use: /kick [ID] [Reason]");
	 	new string[128];
		format(string,sizeof(string),"%s has kicked %s from the Server!(Reason: %s )",SpielerName(playerid),SpielerName(pID),grund);
		SendClientMessageToAll(Rot,string);
		Kick(pID);
	}
	else
	{
		SendClientMessage(playerid, Rot, "You are no Admin!");
	}
	return 1;
}

	dcmd_ban(playerid,params[])
	{
	if(IsPlayerAdmin(playerid) == 1){
	new pID, grund[128];
	if(sscanf(params,"us",pID,grund))return SendClientMessage(playerid,Rot,"Use: /ban [ID] [Reason]");
 	new string[128];
	format(string,sizeof(string),"%s has banned %s from the Server!(Reason: %s )",SpielerName(playerid),SpielerName(pID),grund);
	SendClientMessageToAll(Rot,string);
	Ban(pID);
	}
	else
	{
	SendClientMessage(playerid, Rot, "You are no Admin!");
	}
	return 1;
	}

	dcmd_pm(playerid,params[])
	{
	new pID, grund[128];
	if(sscanf(params,"us",pID,grund))return SendClientMessage(playerid,Rot,"Use: /pm [ID] [Text]");
	if(!IsPlayerConnected(pID)) return SendClientMessage(playerid,Rot,"This player is not Online!");
 	new string[128],string2[128];
	format(string,sizeof(string),"PM to %s: %s", SpielerName(pID),grund);
	format(string2,sizeof(string2),"PM from %s: %s",SpielerName(playerid),grund);
	SendClientMessage(playerid, Gelb, string);
	SendClientMessage(pID, Gelb, string2);
	return 1;
	}

dcmd_say(playerid,params[]) {
	if(IsPlayerAdmin(playerid) == 1){
	#pragma unused params
	if(!strlen(params)) return SendClientMessage(playerid, Rot, "USE: /say [text]");
	new string[128];
	format(string, 128, "[Admin]%s: %s", SpielerName(playerid), params[0] );
	SendClientMessageToAll(0xFF00C3FF,string);
	}
	else
	{
	SendClientMessage(playerid, Rot, "You are no Admin!");
	}
	return 1;
	}
	
public OnPlayerCommandText(playerid, cmdtext[])
{
    dcmd(report,6,cmdtext);
   	dcmd(kick,4,cmdtext);
   	dcmd(ban,3,cmdtext);
   	dcmd(pm,2,cmdtext);
   	dcmd(say,3,cmdtext);

   	if(strcmp(strget(cmdtext,0),"/fps",true)==0)
	{
		if(strlen(strget(cmdtext,1))==0) return SendClientMessage(playerid,Rot,"Use: /FPS [ID]");
		new pID;
		pID = strval(strget(cmdtext,1));
		if(!IsPlayerConnected(pID)) return SendClientMessage(playerid,Rot,"This player is not Online!");
		new Name1[24],String[128];
		GetPlayerName(pID, Name1, 24);
		format(String,128,"%s: %d FPS", Name1, FPS2[pID]-1);
		SendClientMessage(playerid, 0xA0A0A0FF, String);
		return 1;
	}

	if(strcmp(strget(cmdtext,0),"/voice",true)==0)
	{
		if(IsPlayerAdmin(playerid) == 1)
		{
			if(strlen(strget(cmdtext,1))==0) return SendClientMessage(playerid,Rot,"Use: /voice [ID]");
			new pID;
			pID = strval(strget(cmdtext,1));
			if(!IsPlayerConnected(pID)) return SendClientMessage(playerid,Rot,"This player is not Online!");
 			new String[200],String2[200],Name1[24],Name2[24];
			GetPlayerName(playerid, Name1,24);
			GetPlayerName(pID, Name2, 24);
			format(String, 200, "You have given %s Talkpower!", Name2);
			SendClientMessage(playerid,Gelb, String);
			format(String2, 200, "%s gave you Talkpower!", Name1);
			SendClientMessage(pID,Gelb, String2);
			Chatlock[pID] = 1;
		}
		else
		{
			SendClientMessage(playerid, Rot, "You are no Admin!");
		}
		return 1;
	}

	if(strcmp(strget(cmdtext,0),"/goto",true)==0)
	{
		if(IsPlayerAdmin(playerid) == 1)
		{
			if(strlen(strget(cmdtext,1))==0) return SendClientMessage(playerid,Rot,"Use: /goto [ID]");
			new pID;
			pID = strval(strget(cmdtext,1));
			if(!IsPlayerConnected(pID)) return SendClientMessage(playerid,Rot,"This player is not Online!");
 			new Float:PosX,Float:PosY,Float:PosZ,Name[24],String[200];
			GetPlayerName(pID, Name, 24);
			GetPlayerPos(pID, PosX, PosY, PosZ);
			SetPlayerPos(playerid, PosX+2, PosY+1, PosZ+1);
			format(String, 200, "{FEFEFE}You have been {05FF00}teleported{FEFEFE} to %s", Name);
			SendClientMessage(playerid, Rot, String);
		}
		else
		{
			SendClientMessage(playerid, Rot, "You are no Admin!");
		}
		return 1;
	}

	if (strcmp("/ahelp", cmdtext, true, 6) == 0)
	{
		if(IsPlayerAdmin(playerid) == 1)
		{
			SendClientMessage(playerid,0xFF5A00FF,"..::Admin Commands::..");
			SendClientMessage(playerid,0xFF5A00FF,"/kick, /goto, /Voice, /Chatopen, /chatlock, /pause, /start");
		}
		else
		{
			SendClientMessage(playerid, Rot, "You are no Admin!");
		}
		return 1;
	}


	if(strcmp(strget(cmdtext,0),"/spec",true)==0)
	{
		if(GetPlayerTeam(playerid) == 8)
		{
			if(strlen(strget(cmdtext,1))==0) return SendClientMessage(playerid,Rot,"Use: /spec[ID]");
			new pID;
			pID = strval(strget(cmdtext,1));
			if(!IsPlayerConnected(pID)) return SendClientMessage(playerid,Rot,"This player is not Online!");
	 		TogglePlayerSpectating(playerid,1);
	  		switch(GetPlayerState(pID))
	   		{
	    		case 2,3:PlayerSpectateVehicle(playerid,GetPlayerVehicleID(pID));
	    		case 0,1,7,8,4:PlayerSpectatePlayer(playerid,pID);
	    		case 9:return SendClientMessage(playerid,0x00CC00AA,"You can´t spectate this player!");
	    	}
	    	SendClientMessage(playerid,0x00CC00AA,"Use /specoff to exit the Spec Mode.");
	    	SetPVarInt(playerid,"spect",pID);
	    	SetPVarInt(pID,"spec",playerid);
		}
		else
		{
			SendClientMessage(playerid, Rot, "You are no Viewer!");
		}
		return 1;
	}

	if (strcmp("/specoff", cmdtext, true, 8) == 0)
	{
		if(GetPlayerTeam(playerid) == 8)
		{
    		TogglePlayerSpectating(playerid,0);
    		SetCameraBehindPlayer(playerid);
    		SpawnPlayer(playerid);
    		if(GetPVarInt(playerid,"spec")!=-1)
			SetPVarInt(GetPVarInt(playerid,"spec"),"spect",-1);
    		SetPVarInt(playerid,"spec",-1);
		}
		else
		{
			SendClientMessage(playerid, Rot, "You are no Viewer!");
		}
		return 1;
	}

	if (strcmp("/Chatopen", cmdtext, true, 9) == 0)
	{
		if(IsPlayerAdmin(playerid) == 1 )
		{
			chatopen = 1;
			new String[124],Name[24];
			GetPlayerName(playerid, Name, 24);
			format(String,124,"%s has opened the chat!", Name);
			SendClientMessageToAll(Rot, String);
			for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) Chatlock[i] = 1;
		}
		else
		{
			SendClientMessage(playerid, Rot, "You are no Admin!!");
		}
		return 1;
	}


	if (strcmp("/admins", cmdtext, true, 7) ==0)
	{
		SendClientMessage(playerid, 0x00FF0AFF, "..::Admins Online::..");
		for(new i = 0; i < MAX_PLAYERS; i++)
		if(IsPlayerAdmin(i) == 1)
		{
			new namen[24],string[128];
 			GetPlayerName(i, namen, 24);
 			format(string, 128, "%s", namen);
 			SendClientMessage(playerid, 0xFEFEFEFF, string);
 		}
		return 1;
	}


	if (strcmp("/Chatlock", cmdtext, true, 9) == 0)
	{
		if(IsPlayerAdmin(playerid) == 1 )
		{
			chatopen = 0;
			new String[124],Name[24];
			GetPlayerName(playerid, Name, 24);
			format(String,124,"%s has locked the chat!", Name);
			SendClientMessageToAll(Rot, String);
			for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) Chatlock[i] = 0;
		}
		else
		{
			SendClientMessage(playerid, Rot, "You are no Admin!!");
		}
		return 1;
	}

	if (strcmp("/kill", cmdtext, true, 5) == 0)
	{
		SetPlayerHealth(playerid, -100);
		return 1;
	}


	if(strcmp(cmdtext, "/jetpack", true, 6) == 0)
	{
		if(GetPlayerTeam(playerid) == 8)
		{
 			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
		}
		else SendClientMessage(playerid, Rot, "You are no Viewer!!");
		return 1;
	}

	if (strcmp("/pause", cmdtext, true, 6) == 0)
	{
		if(IsPlayerAdmin(playerid) == 1 )
		{
			new String[124],Name[24];
			GetPlayerName(playerid, Name, 24);
			#if defined MASSACRE
			format(String,124,"%s has paused the clan massacre!", Name);
			#else
			format(String,124,"%s has paused the tournament!", Name);
			#endif
			SendClientMessageToAll(Rot, String);
			new unterbrochen[100];
			#if defined MASSACRE
			format(unterbrochen,100,"~w~The clan massacre has been ~r~paused!");
			#else
			format(unterbrochen,100,"~w~The tournament has been ~r~paused!");
			#endif
			GameTextForAll(unterbrochen, 5000, 3 );
			Pause = 0;
			KillTimer(Timer2[1]);
			KillTimer(Timer2[1]);
			KillTimer(Timer2[1]);
			KillTimer(Timer2[1]);
			KillTimer(Timer2[1]);
			for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) TogglePlayerControllable(i,false);
 		}
		else
		{
 			SendClientMessage(playerid, Rot, "You are no Admin!!");
		}
		return 1;
	}
	
	if (strcmp("/resume", cmdtext, true, 6) == 0)
	{
		if(IsPlayerAdmin(playerid) == 1 )
		{
			new String[124],Name[24];
			GetPlayerName(playerid, Name, 24);
			#if defined MASSACRE
			format(String,124,"%s has continued the clan massacre!", Name);
			#else
			format(String,124,"%s has continued the tournament!", Name);
			#endif
			SendClientMessageToAll(Gruen, String);
			new unterbrochen[100];
			#if defined MASSACRE
			format(unterbrochen,100,"~w~The clan massacre has been ~g~continued!");
			#else
			format(unterbrochen,100,"~w~The tournament has been ~g~continued!");
			#endif
			GameTextForAll(unterbrochen, 5000, 3 );
			Pause = 1;
			Timer2[1] = SetTimer("uhr",1000,1);
			for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) TogglePlayerControllable(i,true);
 		}
		else
		{
 			SendClientMessage(playerid, Rot, "You are no Admin!!");
		}
		return 1;
	}

	if (strcmp("/start", cmdtext, true, 6) == 0)
 	{
 		if(Penis == 1) return SendClientMessage(playerid,Rot,"The Massacre has already been started");
 		if(IsPlayerAdmin(playerid) == 1 )
		{
 			new String[124],Name[24];
 			Penis = 1;
 			GetPlayerName(playerid, Name, 24);
 			#if defined MASSACRE
 			format(String,124,"{FEFEFE}%s has {05FF00}started the clan massacre!", Name);
 			#else
 			format(String,124,"{FEFEFE}%s has {05FF00}started the tournament!", Name);
 			#endif
 			SendClientMessageToAll(Gruen, String);
 			new start2[100];
 			#if defined MASSACRE
 			format(start2,100,"~w~The clan massacre starts in ~g~30 seconds!");
 			#else
 			format(start2,100,"~w~The tournament starts in ~g~30 seconds!");
 			#endif
 			GameTextForAll(start2, 5000, 3 );
 			SetTimer("countmedown",1000,0);
 		}
 		else
 		{
 			SendClientMessage(playerid, Rot, "You are no Admin!!");
 		}
 		return 1;
 	}

	return 0;
}


public countmedown()
{
	if(countdown > 1)
	{
		new string[128];
		format(string,sizeof(string),"%d",countdown);
		GameTextForAll(string,1000,3);
		SetTimer("countmedown",1000,0);
		countdown --;
	}
	else
	{
		GameTextForAll("1",1000,3);
		SetTimer("go",1000,0);
	}
}

forward go();
public go()
{
	print("Das Clan Massaker wurde gestartet!");
	Timer2[1] = SetTimer("uhr",1000,1);
	GameTextForAll("Fuck everyone who you see!",1000,3);
	countdown = 0;
	Sekunden = 60;
	Minuten = 59;
	for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) Chatlock[i] = 0;
	for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) TogglePlayerControllable(i,true);
 	Pause = 1;
}

public uhr()
{
    Sekundenupdate();
	Sekunden --;
 	if(Sekunden < 0)
 	{
    	Minuten --;
    	Sekunden = 59;
    	Sekundenupdate();
	}
	if(Minuten == 30 && Sekunden == 0)
	{
		KillTimer(Timer2[1]);
		KillTimer(Timer2[1]);
		KillTimer(Timer2[1]);
		KillTimer(Timer2[1]);
   		KillTimer(Timer2[1]);
		Timer2[2] = SetTimer("pause",300000,1);
 		Pause = 0;
		for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) TogglePlayerControllable(i,false);
 	}
 	if(Minuten == 0 && Sekunden == 1)
	{
		KillTimer(Timer2[1]);
		KillTimer(Timer2[1]);
		KillTimer(Timer2[1]);
		KillTimer(Timer2[1]);
		KillTimer(Timer2[1]);
   		KillTimer(Timer2[1]);
 		Pause = 0;
		for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) TogglePlayerControllable(i,false), GameTextForAll("the massacre has been ended!!", 3000, 3);
 	}
	return 1;
}

forward pause();
public pause()
{
    Pause = 1;
   	for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) TogglePlayerControllable(i,true);
    SetTimer("uhr",1000,1);
    KillTimer(Timer2[2]);
	KillTimer(Timer2[1]);
	KillTimer(Timer2[1]);
	KillTimer(Timer2[1]);
	KillTimer(Timer2[1]);
	KillTimer(Timer2[1]);
	return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	SetPlayerArmedWeapon(playerid,0);
	if(IsPlayerAdmin(playerid) == 0)
	{
		if(vehicleid == Auto[20])
		{
			return 0;
		}
	}
	SetPlayerArmedWeapon(playerid,0);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER) SetPlayerArmedWeapon(playerid,0);
    if(GetPVarInt(playerid,"spect")!=-1)
    {
        switch(newstate)
        {
            case 0,1,7,8: PlayerSpectatePlayer(GetPVarInt(playerid,"spect"),playerid);
            case 2,3:PlayerSpectateVehicle(GetPVarInt(playerid,"spect"),GetPlayerVehicleID(playerid));
            case 9:
            {
                SetPVarInt(GetPVarInt(playerid,"spect"),"spec",-1);
                TogglePlayerSpectating(GetPVarInt(playerid,"spect"),0);
                SetCameraBehindPlayer(GetPVarInt(playerid,"spect"));
            }
        }
    }
    return 1;
}

public OnPlayerUpdate(playerid)
{
	new string[128];
	new pName[16];
	GetPlayerName(playerid, pName, sizeof(pName));
	if(GetPlayerPing(playerid) >= MAXPING && Ping1[playerid] == 1)
	{
		format(string, sizeof(string), "* %s has been kicked!! (Max Ping %d)", pName, MAXPING);
		SendClientMessageToAll(Rot, string);
		SendClientMessage(playerid, Rot, "* You have been kicked! (Reason: Ping)");
		Kick(playerid);
	}
	if(FPS2[playerid] <= MIN_FPS && shitsent == 0)
	{
  		SendClientMessage(playerid, Rot, "WARNING: Your FPS are too low! You need min. "#MIN_FPS" FPS!");
  		SendClientMessage(playerid, Rot, "         If you can't increase your FPS in the next seconds/minutes, you'll get kicked.");
  		format(string, sizeof(string), "**Admininfo** %s's FPS are too low! Use /FPS [ID] to check his FPS!", SpielerName(playerid));
  		SendClientMessageToAdmins(Rot, string);
  		shitsent = 1;
	}
	
	new Waffen[13][2];
	for (new i = 0; i < 13; i++)
	{
	    GetPlayerWeaponData(playerid, i, Waffen[i][0], Waffen[i][1]);
		if(Waffen[i][0] == 0 && Waffen[i][1] == 1000)
		{
		    if(!shitsent2)
		    {
		        SendClientMessage(playerid, -1, "[DZ-Anticheat] The server has detected Aimbot in your game.");
       			SendClientMessage(playerid, -1, "[DZ-Anticheat] You have been kicked for using Aimbot.");
        		format(string, sizeof string, "[DZ-Anticheat] %s has been banned from the server for using Aimbot.",SpielerName(playerid));
        		SendClientMessageToAll(Rot, string);
        		Ban(playerid);
		    	shitsent2 = 1;
		    }
		}
	}


	new drunk2 = GetPlayerDrunkLevel(playerid);
	if(drunk2 < 100)
	{
		SetPlayerDrunkLevel(playerid,2000);
	}
	else
	{
		if(DLlast[playerid] != drunk2)
		{
			new fps = DLlast[playerid] - drunk2;
			if((fps > 0) && (fps < 200))
			FPS2[playerid] = fps;
			DLlast[playerid] = drunk2;
		}
	}
	return 1;
}

public PunkteleisteUpdate()
{
    new string[128];
    format(string,sizeof(string)," ~l~%s:~r~%d ~l~%s:~r~%d ~l~%s:~r~%d ~l~%s:~r~%d ~l~%s:~r~%d ~l~%s:~r~%d ~l~%s:~r~%d ~l~%s:~r~%d", Clan1,Punkte[1], Clan2,Punkte[2], Clan3,Punkte[3], Clan4,Punkte[4], Clan5,Punkte[5], Clan6,Punkte[6], Clan7,Punkte[7], Clan8,Punkte[8]);
    TextDrawSetString(Leiste,string);
	return 1;
}


public Sekundenupdate()
{
    new string[128];
    format(string,sizeof(string),"%02d:%02d", Minuten, Sekunden);
    TextDrawSetString(Uhr,string);
	return 1;
}

public Ping2(playerid)
{
	Ping1[playerid] = 1;
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#if defined MASSACRE
	if(dialogid==DIALOG_TEAM)
	{
	    if(listitem==0)
		{
		    SetPlayerTeam(playerid, 0);
			SpawnPlayer(playerid);
		}
	    if(listitem==1)
		{
		    SetPlayerTeam(playerid, 1);
			SpawnPlayer(playerid);
		}
	    if(listitem==2)
		{
		    SetPlayerTeam(playerid, 2);
			SpawnPlayer(playerid);
		}
	    if(listitem==3)
		{
		    SetPlayerTeam(playerid, 3);
			SpawnPlayer(playerid);
		}
	    if(listitem==4)
		{
		    SetPlayerTeam(playerid, 4);
			SpawnPlayer(playerid);
		}
	    if(listitem==5)
		{
		    SetPlayerTeam(playerid, 5);
			SpawnPlayer(playerid);
		}
	    if(listitem==6)
		{
		    SetPlayerTeam(playerid, 6);
			SpawnPlayer(playerid);
		}
	    if(listitem==7)
		{
		    SetPlayerTeam(playerid, 7);
			SpawnPlayer(playerid);
		}
	    if(listitem==8)
		{
		    SetPlayerTeam(playerid, 8);
			SpawnPlayer(playerid);
		}
	}
	#else
	if(dialogid==DIALOG_TEAM)
	{
	    if(listitem==0)
		{
		    SetPlayerTeam(playerid, 1);
			SpawnPlayer(playerid);
		}
	    if(listitem==1)
		{
		    SetPlayerTeam(playerid, 0);
			SpawnPlayer(playerid);
		}
	}
	#endif
	return 1;
}

public FPSUP()
{
	new tanga[30];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			format(tanga,sizeof(tanga),"~y~FPS: %d",FPS2[i]-1);
			TextDrawSetString(FPS[i],tanga);
		}
		continue;
	}
}

public SendClientMessageToAdmins(color,string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerAdmin(i))
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}

stock strget(strx[], pos, search = ' ')
{
	new arg, ret[128], idxx;
 	for (new i = 0; i < strlen(strx); i++)
	{
  		if(strx[i] == search || i == strlen(strx) || strx[i + 1] == 10)
  		{
   			arg++;
   			if (arg == pos + 1)
   			{
   				ret[i-idxx] = EOS;
   				return ret;
   			}
   			else if (arg == pos) idxx= i+1;
		}
  		else if (arg == pos)
   		ret[i - idxx] = strx[i];
 	}
 	return ret;
}

stock strrest(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[128];
	while ((index < length) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock SpielerName(playerid)
{
   new name[MAX_PLAYERS];
   GetPlayerName(playerid,name,sizeof(name));
   return name;
}

stock bigstrtok(const string[], &idx)
{
    new length = strlen(string);
	while ((idx < length) && (string[idx] <= ' '))
	{
	idx++;
	}
	new offset = idx;
	new result[128];
	while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
	{
	result[idx - offset] = string[idx];
	idx++;
	}
	result[idx - offset] = EOS;
	return result;
}

PUB:HackCheck(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerCameraFrontVector(playerid, x, y, z);
    #pragma unused x
    #pragma unused y
    if(z < -0.8)
	{
        SendClientMessage(playerid, -1, "[DZ-Anticheat] The server has detected s0beit in your game.");
        SendClientMessage(playerid, -1, "[DZ-Anticheat] You have been kicked for using s0beit.");
        gpInfo[playerid][hacker] = 1;
        new string[128];
        format(string, sizeof string, "[DZ-Anticheat] %s has been banned from the server for using s0beit.", gpInfo[playerid][pname]);
        SendClientMessageToAll(Rot, string);
        Ban(playerid);
    }
    else
	{
        SendClientMessage(playerid, -1, "[DZ-Anticheat] The server hasn't found any illegal programs in your game.");
        SendClientMessage(playerid, -1, "[DZ-Anticheat] You are allowed to play.");
        if(Penis == 0)
        {
            TogglePlayerControllable(playerid, 0);
		}
		else
		{
		    TogglePlayerControllable(playerid, 1);
		}
    }
    return 1;
}

UpdatePosListe()
{
	new temp[64],string[512];
	for(new i=0; i<sizeof(position); i++)
	{
		GetPlayerName(position[i], SpielerName(i), MAX_PLAYER_NAME);
	    if(position[i]<0)
		{
	    	format(temp, sizeof(temp), "~n~");
	    }
		else
		{
	    	format(temp, sizeof(temp), "~w~%s ~r~(%d)~w~~n~",pname,i+1);
	    }
		format(string, sizeof(string), "%s%s", string, temp);
	}
	TextDrawSetString(Tposliste, string);
}
