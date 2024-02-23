forward INV_GetWeaponMaterials(playerid);
forward INV_GetAmmoMaterials(playerid);
forward INV_GetFishWeight(playerid);
forward INV_GetPlayerStatistik(playerid);

public INV_GetWeaponMaterials(playerid)
{
	new number[MAX_MATERIAL_SLOTS],length=sizeof(GrandCacheString),product=GetPVarInt(playerid,"InventarProduct"); GetPVarString(playerid,"SpielerWeaponRohlinge",StockString,length);
	sscanf(StockString,"p<;>a<d>["#MAX_MATERIAL_SLOTS"]",number);
	for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,length,"%s\n\tWaffenrohlinge für %s: %d%s (%0.fkg)",GrandCacheString,GetMaterialSlotName(x),number[x],InventarInfo[product][invEinheit],floatmul(number[x],InventarInfo[product][invGewicht]));
	return true;
}
public INV_GetAmmoMaterials(playerid)
{
	new number[MAX_MATERIAL_SLOTS],length=sizeof(GrandCacheString),product=GetPVarInt(playerid,"InventarProduct"); GetPVarString(playerid,"SpielerAmmoMaterials",StockString,length);
	sscanf(StockString,"p<;>a<d>["#MAX_MATERIAL_SLOTS"]",number);
	for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,length,"%s\n\tWaffenmunition für %s: %d%s (%0.fkg)",GrandCacheString,GetMaterialSlotName(x),number[x],InventarInfo[product][invEinheit],floatmul(number[x],InventarInfo[product][invGewicht]));
	return true;
}
public INV_GetFishWeight(playerid)
{
	new Float:PlayerFish[sizeof(FischInfo)],length=sizeof(GrandCacheString),product=GetPVarInt(playerid,"InventarProduct");
	GetPVarString(playerid,"SpielerRohFisch",StockString,sizeof(StockString)); sscanf(StockString,"p<;>A<f>(0)["#MAX_FISCH"]",PlayerFish);
	for(new x;x!=sizeof(FischInfo);x++) format(GrandCacheString,length,"%s\n\t%s: %0.f%s",GrandCacheString,FischInfo[x][fscName],PlayerFish[x],InventarInfo[product][invEinheit]);
	return true;
}
public INV_GetPlayerStatistik(playerid)
{
	new fahrzeuge,length = sizeof(GrandCacheString),cost[2],x,PlayerKeys[MAX_PLAYER_KEYS],show=GetPVarInt(playerid,"InventarProduct")-gSlotBegin[GetPVarInt(playerid,"InventarSlot")];
	if(show>=0) //Personalien
	{
		format(GrandCacheString,length,"%s\n\nInGame Daten:",GrandCacheString);
		format(GrandCacheString,length,"%s\n\tNickName: %s\n\tLevel: %d\n\tRespektpunkte: %d",GrandCacheString,GetName(playerid),GetPVarInt(playerid,"SpielerLevel"),GetPVarInt(playerid,"SpielerRespekt"));
		if(GetPVarInt(playerid,"SpielerBranche")>0) format(GrandCacheString,length,"%s\n\tMitglied bei %s\n\tRang: %s",GrandCacheString,FInfo[GetPVarInt(playerid,"SpielerBranche")][fName],FInfoRang[GetPVarInt(playerid,"SpielerBranche")][GetPVarInt(playerid,"SpielerStufe")]);
		format(GrandCacheString,length,"%s\n\tAdminLevel: %d",GrandCacheString,GetPVarInt(playerid,"SpielerAdmin"));
	}
	if(show>=1) //Vermögen
	{
		format(GrandCacheString,length,"%s\n\nVermögen:",GrandCacheString);
		GetPVarString(playerid,"SpielerVehicleKeys",StockString,sizeof(StockString));
		sscanf(StockString,"p<,>a<i>["#MAX_PLAYER_KEYS"]",PlayerKeys);
		for(x=0;x!=MAX_PLAYER_KEYS;x++)
		{
			if(PlayerKeys[x]!=-1) {cost[0]+=GetVVarInt(PlayerKeys[x],"VehicleCost"); fahrzeuge++;}
		}
		if(GetPVarInt(playerid,"SpielerUnterkunft")>-1) cost[1]=HInfo[GetPVarInt(playerid,"SpielerUnterkunft")][hPreis]+HInfo[GetPVarInt(playerid,"SpielerUnterkunft")][hKassa];
		format(GrandCacheString,length,"%s\n\tBargeld: %d$\n\tQuick: %d$\n\tUnterkunftswert: %d$\n\tFahrzeugvermögen: %d$ (%d Fahrzeuge)",GrandCacheString,GetPlayerMoney(playerid),GetPVarInt(playerid,"SpielerQuick"),cost[1],cost[0],fahrzeuge);
	}
	return true;
}

//Zusatdefines
forward INV_OnGameModeInit();
forward INV_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);

public OnGameModeInit()
{
	print("-> Bereite Inventar vor...");
	new oldslot=-1,x;
	for(x=0;x!=sizeof(InventarInfo);x++)
	{
		if(InventarInfo[x][invKategorie]!=oldslot)
		{
			oldslot=InventarInfo[x][invKategorie]; gSlotBegin[oldslot]=x;
			printf("For Slot %d Found Product %d",oldslot,x);
		}
	}
	return CallLocalFunction("INV_OnGameModeInit","");
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	DeletePVar(playerid,"PlayerInDialog");
	if(dialogid==InventarDialog)
	{
		switch(GetPVarInt(playerid,"PlayerStep"))
		{
			case 1:
			{
				if(!response) return DeletePVar(playerid,"PlayerStep");
				switch(listitem)
				{
					case 0:
					{
						SetPVarInt(playerid,"PlayerStep",1);
						return ShowPlayerDialog(playerid,SchluesselDialog,DIALOG_STYLE_LIST,"Schlüssel",SchluesselText,"Fortfahren","Zurück");
					}
					default:
					{
						SetPVarInt(playerid,"InventarSlot",listitem); SetPVarInt(playerid,"PlayerStep",2);
						for(new x=gSlotBegin[listitem];x!=gSlotBegin[listitem+1];x++)
						{
							if(x==gSlotBegin[listitem]) format(GrandCacheString,sizeof(GrandCacheString),"%s",InventarInfo[x][invHeader]);
							else format(GrandCacheString,sizeof(GrandCacheString),"%s\n%s",GrandCacheString,InventarInfo[x][invHeader]);
						}
						return ShowPlayerDialog(playerid,InventarDialog,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
					}
				}
			}
			case 2:
			{				
				if(!response)
				{
					SetPVarInt(playerid,"PlayerStep",1); DeletePVar(playerid,"InventarSlot");
					return ShowPlayerDialog(playerid,InventarDialog,DIALOG_STYLE_LIST,"Inventar",InventarDialogText,"Fortfahren","Zurück");
				}
				new product = gSlotBegin[GetPVarInt(playerid,"InventarSlot")]+listitem,bool:check; SetPVarInt(playerid,"InventarProduct",product); SetPVarInt(playerid,"PlayerStep",3);
				check = (CallLocalFunction(InventarInfo[GetPVarInt(playerid,"InventarProduct")][invSlotName],"d",playerid)==1?true:false);
				return CreateProductInfoForPlayer(playerid,GetPVarInt(playerid,"InventarProduct"),check);
			}
			case 3:
			{
				new product = GetPVarInt(playerid,"InventarProduct");
				if(!response||InventarInfo[product][invEditTyp]==-1)
				{
					SetPVarInt(playerid,"PlayerStep",2); DeletePVar(playerid,"InventarProduct");
					for(new x=gSlotBegin[GetPVarInt(playerid,"InventarSlot")];x!=gSlotBegin[GetPVarInt(playerid,"InventarSlot")+1];x++)
					{
						if(x==gSlotBegin[GetPVarInt(playerid,"InventarSlot")]) format(GrandCacheString,sizeof(GrandCacheString),"%s",InventarInfo[x][invHeader]);
						else format(GrandCacheString,sizeof(GrandCacheString),"%s\n%s",GrandCacheString,InventarInfo[x][invHeader]);
					}
					return ShowPlayerDialog(playerid,InventarDialog,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
				}
				SetPVarInt(playerid,"PlayerStep",1); SetPVarInt(playerid,"InventarEdit",InventarInfo[product][invEditTyp]);
				return ShowInventarEditDialog(playerid);
			}
		}
		return 1;
	}
	if(dialogid==InventarDialogExt)
	{
		if(!response&&GetPVarInt(playerid,"PlayerStep")==1)
		{
			new bool:check = (CallLocalFunction(InventarInfo[GetPVarInt(playerid,"InventarProduct")][invSlotName],"d",playerid)==1?true:false); SetPVarInt(playerid,"PlayerStep",3);
			return CreateProductInfoForPlayer(playerid,GetPVarInt(playerid,"InventarProduct"),check);
		}
		switch(GetPVarInt(playerid,"InventarEdit"))
		{
			case 0:
			{
				switch(GetPVarInt(playerid,"PlayerStep"))
				{
					case 1:
					{
						switch(listitem)
						{
							case 0:
							{
								SetPVarInt(playerid,"PlayerStep",10);
								format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Rohlinge möchten Sie verkaufen?");
								for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
								ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
							}
							case 1:
							{
								SetPVarInt(playerid,"PlayerStep",20);
								format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Rohlinge möchten Sie wegwerfen?");
								for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
								ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
							}
						}
						return 1;
					}
					case 10:
					{
						if(!response)
						{
							SetPVarInt(playerid,"PlayerStep",1);
							return ShowInventarEditDialog(playerid);
						}
						if(listitem==0)
						{
							format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Rohlinge möchten Sie verkaufen?");
							for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
							return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						SetPVarInt(playerid,"ChosenRohlingSlot",listitem-1); SetPVarInt(playerid,"PlayerStep",11);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, an welchen Spieler wieviele Rohlinge um welchen Geldbetrag von %s geben möchten.\nDer Käufer muss für diesen Geschäftsfall in der Nähe sein.\n\nVERWENDUNG: [Spieler ID/Name] [Menge] [Verkaufspreis]",GetMaterialSlotName(listitem-1));
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Angebot","Zurück");
					}
					case 11:
					{
						if(!response)
						{
							DeletePVar(playerid,"ChosenRohlingSlot"); SetPVarInt(playerid,"PlayerStep",10);
							format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Rohlinge möchten Sie verkaufen?");
							for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
							return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						SetPVarInt(playerid,"PlayerStep",12);
						new giveplayerid,menge,geld,number[MAX_MATERIAL_SLOTS],Float:PlayerPos[3],slot=GetPVarInt(playerid,"ChosenRohlingSlot");
						GetPVarString(playerid,"SpielerWeaponRohlinge",StockString,sizeof(StockString)); GetPlayerPos(playerid,PlayerPos[0],PlayerPos[1],PlayerPos[2]);
						sscanf(StockString,"p<;>a<d>["#MAX_MATERIAL_SLOTS"]",number);
						if(sscanf(inputtext,"ud",giveplayerid,menge)) format(FormatString,sizeof(FormatString),"Überprüfen Sie Ihre Eingabe...\nINFO: Möglich ist es, dass der angegebene Spieler nicht am Server ist!");
						else if(!IsPlayerInRangeOfPoint(giveplayerid,5.0,PlayerPos[0],PlayerPos[1],PlayerPos[2])) format(FormatString,sizeof(FormatString),"Käufer %s ist nicht in Ihrer Nähe...",GetName(giveplayerid));
						else if(menge<1||menge>number[slot]) format(FormatString,sizeof(FormatString),"Sie haben keine %d Rohlinge der %s...",menge,GetMaterialSlotName(slot));
						else if(geld<0||geld>999999) format(FormatString,sizeof(FormatString),"Ihr Geldbetrag %d ist unzulässig...",geld);
						else
						{
							DeletePVar(playerid,"ChosenRohlingSlot"); SetPVarInt(playerid,"PlayerStep",1);
							SetPVarInt(playerid,"AngebotRohlingeSpieler",giveplayerid); SetPVarInt(playerid,"AngebotRohlingeSlot",slot);
							SetPVarInt(playerid,"AngebotRohlingeMenge",menge); SetPVarInt(playerid,"AngebotRohlingeWert",geld);
							format(FormatString,sizeof(FormatString),"*  Sie bieten %s %d Rohling(e) der %s für %d$ an.",GetName(giveplayerid),menge,GetMaterialSlotName(slot),geld);
							SendClientMessage(playerid,COLOR_YELLOW,FormatString);
							format(FormatString,sizeof(FormatString),"* %s bietet Ihnen %d Rohling(e) der %s für %d$ an. (/rohlinge munition %d)",GetName(playerid),menge,GetMaterialSlotName(slot),geld,playerid);
							SendClientMessage(giveplayerid,COLOR_YELLOW,FormatString);
							return ShowInventarEditDialog(playerid);
						}
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_MSGBOX,"Inventar",FormatString,"Zurück","");
					}
					case 12:
					{
						SetPVarInt(playerid,"PlayerStep",11);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, an welchen Spieler wieviele Rohlinge um welchen Geldbetrag von %s geben möchten.\nDer Käufer muss für diesen Geschäftsfall in der Nähe sein.\n\nVERWENDUNG: [Spieler ID/Name] [Menge] [Verkaufspreis]",GetMaterialSlotName(GetPVarInt(playerid,"ChosenRohlingSlot")));
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Angebot","Zurück");
					}
					case 20:
					{
						if(!response)
						{
							SetPVarInt(playerid,"PlayerStep",1);
							return ShowInventarEditDialog(playerid);
						}
						if(listitem==0)
						{
							format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Rohlinge möchten Sie wegwerfen?");
							for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
							ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						SetPVarInt(playerid,"ChosenRohlingSlot",listitem-1); SetPVarInt(playerid,"PlayerStep",21);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, wieviel Munition der %s Sie wegwerfen möchten.\n\nVERWENDUNG: [Menge]",GetMaterialSlotName(listitem-1));
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Wegwerfen","Zurück");
					}
					case 21:
					{
						if(!response)
						{
							SetPVarInt(playerid,"PlayerStep",20); DeletePVar(playerid,"ChosenRohlingSlot");
							format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Rohlinge möchten Sie wegwerfen?");
							for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
							return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						new number[MAX_MATERIAL_SLOTS],menge,slot=GetPVarInt(playerid,"ChosenRohlingSlot");
						GetPVarString(playerid,"SpielerWeaponRohlinge",StockString,sizeof(StockString));
						sscanf(StockString,"p<;>a<d>["#MAX_MATERIAL_SLOTS"]",number);
						SetPVarInt(playerid,"PlayerStep",22);
						if(sscanf(inputtext,"d",menge)) format(FormatString,sizeof(FormatString),"Ihre Eingabe darf nur die Zahl der Menge haben, jene Sie wegwerfen möchten...");
						else if(menge<1||menge>number[slot]) format(FormatString,sizeof(FormatString),"Sie haben keine %d Rohlinge der %s zum wegwerfen...",menge,GetMaterialSlotName(slot));
						else
						{
							EditWeaponMaterialsForPlayer(playerid,slot,-menge); SetPVarInt(playerid,"PlayerStep",1); DeletePVar(playerid,"ChosenRohlingSlot");
							format(FormatString,sizeof(FormatString),"* Sie haben %d Rohlinge der %s weggeworfen.",menge,GetMaterialSlotName(slot));
							SendClientMessage(playerid,COLOR_ORANGE,FormatString);
							return ShowInventarEditDialog(playerid);
						}
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_MSGBOX,"Inventar",FormatString,"Zurück","");
					}
					case 22:
					{
						SetPVarInt(playerid,"PlayerStep",21);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, wieviel Munition der %s Sie wegwerfen möchten.\n\nVERWENDUNG: [Menge]",GetMaterialSlotName(GetPVarInt(playerid,"ChosenRohlingSlot")));
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Wegwerfen","Zurück");
					}
				}
			}
			case 1:
			{
				switch(GetPVarInt(playerid,"PlayerStep"))
				{
					case 1:
					{
						switch(listitem)
						{
							case 0:
							{
								SetPVarInt(playerid,"PlayerStep",10);
								format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Munition möchten Sie verkaufen?");
								for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
								ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
							}
							case 1:
							{
								SetPVarInt(playerid,"PlayerStep",20);
								format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Munition möchten Sie wegwerfen?");
								for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
								ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
							}
						}
						return 1;
					}
					case 10:
					{
						if(!response)
						{
							SetPVarInt(playerid,"PlayerStep",1);
							return ShowInventarEditDialog(playerid);
						}
						if(listitem==0)
						{
							format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Munition möchten Sie verkaufen?");
							for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
							return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						SetPVarInt(playerid,"ChosenRohlingSlot",listitem-1); SetPVarInt(playerid,"PlayerStep",11);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, an welchen Spieler wieviele Munition um welchen Geldbetrag von %s geben möchten.\nDer Käufer muss für diesen Geschäftsfall in der Nähe sein.\n\nVERWENDUNG: [Spieler ID/Name] [Menge] [Verkaufspreis]",GetMaterialSlotName(listitem-1));
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Angebot","Zurück");
					}
					case 11:
					{
						if(!response)
						{
							DeletePVar(playerid,"ChosenRohlingSlot"); SetPVarInt(playerid,"PlayerStep",10);
							format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Munition möchten Sie verkaufen?");
							for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
							return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						SetPVarInt(playerid,"PlayerStep",12);
						new giveplayerid,menge,geld,number[MAX_MATERIAL_SLOTS],Float:PlayerPos[3],slot=GetPVarInt(playerid,"ChosenRohlingSlot");
						GetPVarString(playerid,"SpielerAmmoMaterials",StockString,sizeof(StockString)); GetPlayerPos(playerid,PlayerPos[0],PlayerPos[1],PlayerPos[2]);
						sscanf(StockString,"p<;>a<d>["#MAX_MATERIAL_SLOTS"]",number);
						if(sscanf(inputtext,"ud",giveplayerid,menge)) format(FormatString,sizeof(FormatString),"Überprüfen Sie Ihre Eingabe...\nINFO: Möglich ist es, dass der angegebene Spieler nicht am Server ist!");
						else if(!IsPlayerInRangeOfPoint(giveplayerid,5.0,PlayerPos[0],PlayerPos[1],PlayerPos[2])) format(FormatString,sizeof(FormatString),"Käufer %s ist nicht in Ihrer Nähe...",GetName(giveplayerid));
						else if(menge<1||menge>number[slot]) format(FormatString,sizeof(FormatString),"Sie haben keine %d Munition der %s...",menge,GetMaterialSlotName(slot));
						else if(geld<0||geld>999999) format(FormatString,sizeof(FormatString),"Ihr Geldbetrag %d ist unzulässig...",geld);
						else
						{
							DeletePVar(playerid,"ChosenRohlingSlot"); SetPVarInt(playerid,"PlayerStep",1);
							SetPVarInt(playerid,"AngebotMunitionSpieler",giveplayerid); SetPVarInt(playerid,"AngebotMunitionSlot",slot);
							SetPVarInt(playerid,"AngebotMunitionMenge",menge); SetPVarInt(playerid,"AngebotMunitionWert",geld);
							format(FormatString,sizeof(FormatString),"*  Sie bieten %s %d Munition(e) der %s für %d$ an.",GetName(giveplayerid),menge,GetMaterialSlotName(slot),geld);
							SendClientMessage(playerid,COLOR_YELLOW,FormatString);
							format(FormatString,sizeof(FormatString),"* %s bietet Ihnen %d Munition(e) der %s für %d$ an. (/munition annehmen %d)",GetName(playerid),menge,GetMaterialSlotName(slot),geld,playerid);
							SendClientMessage(giveplayerid,COLOR_YELLOW,FormatString);
							return ShowInventarEditDialog(playerid);
						}
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_MSGBOX,"Inventar",FormatString,"Zurück","");
					}
					case 12:
					{
						SetPVarInt(playerid,"PlayerStep",11);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, an welchen Spieler wieviel Munition um welchen Geldbetrag von %s geben möchten.\nDer Käufer muss für diesen Geschäftsfall in der Nähe sein.\n\nVERWENDUNG: [Spieler ID/Name] [Menge] [Verkaufspreis]",GetMaterialSlotName(GetPVarInt(playerid,"ChosenRohlingSlot")));
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Angebot","Zurück");
					}
					case 20:
					{
						if(!response)
						{
							SetPVarInt(playerid,"PlayerStep",1);
							return ShowInventarEditDialog(playerid);
						}
						if(listitem==0)
						{
							format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Munition möchten Sie wegwerfen?");
							for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
							ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						SetPVarInt(playerid,"ChosenRohlingSlot",listitem-1); SetPVarInt(playerid,"PlayerStep",21);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, wieviel Munition der %s Sie wegwerfen möchten.\n\nVERWENDUNG: [Menge]",GetMaterialSlotName(listitem-1));
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Wegwerfen","Zurück");
					}
					case 21:
					{
						if(!response)
						{
							SetPVarInt(playerid,"PlayerStep",20); DeletePVar(playerid,"ChosenRohlingSlot");
							format(GrandCacheString,sizeof(GrandCacheString),"Von welcher Art der Munition möchten Sie wegwerfen?");
							for(new x;x!=MAX_MATERIAL_SLOTS;x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,GetMaterialSlotName(x));
							return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						new number[MAX_MATERIAL_SLOTS],menge,slot=GetPVarInt(playerid,"ChosenRohlingSlot");
						GetPVarString(playerid,"SpielerAmmoMaterials",StockString,sizeof(StockString));
						sscanf(StockString,"p<;>a<d>["#MAX_MATERIAL_SLOTS"]",number);
						SetPVarInt(playerid,"PlayerStep",22);
						if(sscanf(inputtext,"d",menge)) format(FormatString,sizeof(FormatString),"Ihre Eingabe darf nur die Zahl der Menge haben, jene Sie wegwerfen möchten...");
						else if(menge<1||menge>number[slot]) format(FormatString,sizeof(FormatString),"Sie haben keine %d Munition der %s zum wegwerfen...",menge,GetMaterialSlotName(slot));
						else
						{
							EditAmmoMaterialsForPlayer(playerid,slot,-menge); SetPVarInt(playerid,"PlayerStep",1); DeletePVar(playerid,"ChosenRohlingSlot");
							format(FormatString,sizeof(FormatString),"* Sie haben %d Munition der %s weggeworfen.",menge,GetMaterialSlotName(slot));
							SendClientMessage(playerid,COLOR_ORANGE,FormatString);
							return ShowInventarEditDialog(playerid);
						}
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_MSGBOX,"Inventar",FormatString,"Zurück","");
					}
					case 22:
					{
						SetPVarInt(playerid,"PlayerStep",21);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, wieviel Munition der %s Sie wegwerfen möchten.\n\nVERWENDUNG: [Menge]",GetMaterialSlotName(GetPVarInt(playerid,"ChosenRohlingSlot")));
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_MSGBOX,"Inventar",GrandCacheString,"Wegwerfen","Zurück");
					}
				}
			}
			case 2:
			{
				switch(GetPVarInt(playerid,"PlayerStep"))
				{
					case 1:
					{
						switch(listitem)
						{
							case 0:
							{
								SetPVarInt(playerid,"PlayerStep",10);
								format(GrandCacheString,sizeof(GrandCacheString),"Welche Art von Fisch möchten Sie verkaufen?");
								for(new x;x!=sizeof(FischInfo);x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,FischInfo[x][fscName]);
								ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
							}
							case 1:
							{
								SetPVarInt(playerid,"PlayerStep",20);
								format(GrandCacheString,sizeof(GrandCacheString),"Welche Art von Fisch möchten Sie wegwerfen?");
								for(new x;x!=sizeof(FischInfo);x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,FischInfo[x][fscName]);
								ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
							}
						}
						return 1;
					}
					case 10:
					{
						if(!response)
						{
							SetPVarInt(playerid,"PlayerStep",1);
							return ShowInventarEditDialog(playerid);
						}
						if(listitem==0)
						{
							format(GrandCacheString,sizeof(GrandCacheString),"Welche Art von Fisch möchten Sie verkaufen?");
							for(new x;x!=sizeof(FischInfo);x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,FischInfo[x][fscName]);
							return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						SetPVarInt(playerid,"ChosenFischSlot",listitem-1); SetPVarInt(playerid,"PlayerStep",11);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, an welchen Spieler wieviele rohen Fisch um welchen Geldbetrag vom %s geben möchten.\nDer Käufer muss für diesen Geschäftsfall in der Nähe sein.\n\nVERWENDUNG: [Spieler ID/Name] [Menge] [Verkaufspreis]",FischInfo[listitem-1][fscName]);
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Angebot","Zurück");
					}
					case 11:
					{
						if(!response)
						{
							DeletePVar(playerid,"ChosenFischSlot"); SetPVarInt(playerid,"PlayerStep",10);
							format(GrandCacheString,sizeof(GrandCacheString),"Welche Art von Fisch möchten Sie verkaufen?");
							for(new x;x!=sizeof(FischInfo);x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,FischInfo[x][fscName]);
							return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						SetPVarInt(playerid,"PlayerStep",12);
						new giveplayerid,Float:menge,geld,Float:number[sizeof(FischInfo)],Float:PlayerPos[3],slot=GetPVarInt(playerid,"ChosenFischSlot");
						GetPVarString(playerid,"SpielerRohFisch",StockString,sizeof(StockString)); GetPlayerPos(playerid,PlayerPos[0],PlayerPos[1],PlayerPos[2]);
						sscanf(StockString,"p<;>A<f>(0)["#MAX_FISCH"]",number);
						if(sscanf(inputtext,"ud",giveplayerid,menge)) format(FormatString,sizeof(FormatString),"Überprüfen Sie Ihre Eingabe...\nINFO: Möglich ist es, dass der angegebene Spieler nicht am Server ist!");
						else if(!IsPlayerInRangeOfPoint(giveplayerid,5.0,PlayerPos[0],PlayerPos[1],PlayerPos[2])) format(FormatString,sizeof(FormatString),"Käufer %s ist nicht in Ihrer Nähe...",GetName(giveplayerid));
						else if(menge<1||menge>number[slot]) format(FormatString,sizeof(FormatString),"Sie haben keine %0.fkg rohen Fisch vom %s...",menge,FischInfo[slot][fscName]);
						else if(geld<0||geld>999999) format(FormatString,sizeof(FormatString),"Ihr Geldbetrag %d ist unzulässig...",geld);
						else
						{
							DeletePVar(playerid,"ChosenFischSlot"); SetPVarInt(playerid,"PlayerStep",1);
							SetPVarInt(playerid,"AngebotFischSpieler",giveplayerid); SetPVarInt(playerid,"AngebotFischSlot",slot);
							SetPVarFloat(playerid,"AngebotFischMenge",menge); SetPVarInt(playerid,"AngebotFischWert",geld);
							format(FormatString,sizeof(FormatString),"*  Sie bieten %s %0.fkg rohen Fisch vom %s für %d$ an.",GetName(giveplayerid),menge,FischInfo[slot][fscName],geld);
							SendClientMessage(playerid,COLOR_YELLOW,FormatString);
							format(FormatString,sizeof(FormatString),"* %s bietet Ihnen %0.f rohen Fisch vom %s für %d$ an. (/munition annehmen %d)",GetName(playerid),menge,FischInfo[slot][fscName],geld,playerid);
							SendClientMessage(playerid,COLOR_YELLOW,FormatString);
							return ShowInventarEditDialog(playerid);
						}
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_MSGBOX,"Inventar",FormatString,"Zurück","");
					}
					case 12:
					{
						SetPVarInt(playerid,"PlayerStep",11);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, an welchen Spieler wieviel rohen Fisch um welchen Geldbetrag vom %s geben möchten.\nDer Käufer muss für diesen Geschäftsfall in der Nähe sein.\n\nVERWENDUNG: [Spieler ID/Name] [Menge] [Verkaufspreis]",FischInfo[GetPVarInt(playerid,"ChosenFischSlot")][fscName]);
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Angebot","Zurück");
					}
					case 20:
					{
						if(!response)
						{
							SetPVarInt(playerid,"PlayerStep",1);
							return ShowInventarEditDialog(playerid);
						}
						if(listitem==0)
						{
							format(GrandCacheString,sizeof(GrandCacheString),"Welche Art von Fisch möchten Sie wegwerfen?");
							for(new x;x!=sizeof(FischInfo);x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,FischInfo[x][fscName]);
							ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						SetPVarInt(playerid,"ChosenFischSlot",listitem-1); SetPVarInt(playerid,"PlayerStep",21);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, wieviel rohen Fisch vom %s Sie wegwerfen möchten.\n\nVERWENDUNG: [Menge]",FischInfo[listitem-1][fscName]);
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_INPUT,"Inventar",GrandCacheString,"Wegwerfen","Zurück");
					}
					case 21:
					{
						if(!response)
						{
							SetPVarInt(playerid,"PlayerStep",20); DeletePVar(playerid,"ChosenFischSlot");
							format(GrandCacheString,sizeof(GrandCacheString),"Welche Art von Fisch möchten Sie wegwerfen?");
							for(new x;x!=sizeof(FischInfo);x++) format(GrandCacheString,sizeof(GrandCacheString),"%s\n-> %s",GrandCacheString,FischInfo[x][fscName]);
							return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar",GrandCacheString,"Fortfahren","Zurück");
						}
						new Float:number[sizeof(FischInfo)],Float:menge,slot=GetPVarInt(playerid,"ChosenFischSlot");
						GetPVarString(playerid,"SpielerRohFisch",StockString,sizeof(StockString));
						sscanf(StockString,"p<;>A<f>(0)["#MAX_FISCH"]",number);
						SetPVarInt(playerid,"PlayerStep",22);
						if(sscanf(inputtext,"f",menge)) format(FormatString,sizeof(FormatString),"Ihre Eingabe darf nur die Zahl der Menge haben, jene Sie wegwerfen möchten...");
						else if(menge<0|| menge>number[slot]) format(FormatString,sizeof(FormatString),"Sie haben keine %2.fkg rohen Fisch vom %s zum wegwerfen...",menge,FischInfo[slot][fscName]);
						else
						{
							EditRohFishForPlayer(playerid,slot,-menge); SetPVarInt(playerid,"PlayerStep",1); DeletePVar(playerid,"ChosenFischSlot");
							format(FormatString,sizeof(FormatString),"* Sie haben %2.fkg rohen Fisch vom %s weggeworfen.",menge,FischInfo[slot][fscName]);
							SendClientMessage(playerid,COLOR_ORANGE,FormatString);
							return ShowInventarEditDialog(playerid);
						}
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_MSGBOX,"Inventar",FormatString,"Zurück","");
					}
					case 22:
					{
						SetPVarInt(playerid,"PlayerStep",21);
						format(GrandCacheString,sizeof(GrandCacheString),"Geben Sie nun an, wieviel rohen Fisch vom %s Sie wegwerfen möchten.\n\nVERWENDUNG: [Menge]",FischInfo[GetPVarInt(playerid,"ChosenFischSlot")][fscName]);
						return ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_MSGBOX,"Inventar",GrandCacheString,"Wegwerfen","Zurück");
					}
				}
			}
		}
	}
	return CallLocalFunction("INV_OnDialogResponse","dddds",playerid, dialogid, response, listitem, inputtext);
}
ShowInventarEditDialog(playerid)
{
	switch(GetPVarInt(playerid,"InventarEdit"))
	{
		//Weapon Materials
		case 0: ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar","Rohlinge verkaufen\nRohlinge wegwerfen","Fortfahren","Zurück");
		//Ammo Materials
		case 1: ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar","Munition verkaufen\nMunition wegwerfen","Fortfahren","Zurück");
		//Roher Fisch
		case 2: ShowPlayerDialog(playerid,InventarDialogExt,DIALOG_STYLE_LIST,"Inventar","Rohen Fisch verkaufen\nRohen Fisch wegwerfen","Fortfahren","Zurück");
	}
	return true;
}
CreateProductInfoForPlayer(playerid,product,bool:function)
{
	new length = sizeof(GrandCacheString);
	format(GrandCacheString,length,"Sie haben folgende(n) %s:\n\n",InventarInfo[product][invHeader]);
	if(function) CallLocalFunction(InventarInfo[product][invSlotName],"d",playerid);
	else
	{
		switch(InventarInfo[product][invTyp])
		{
			case 0: format(GrandCacheString,length,"%s%d%s",GrandCacheString,GetPVarInt(playerid,InventarInfo[product][invVariable]),InventarInfo[product][invEinheit]);
			case 1: format(GrandCacheString,length,"%s%f%s",GrandCacheString,GetPVarFloat(playerid,InventarInfo[product][invVariable]),InventarInfo[product][invEinheit]);
		}
	}
	if(InventarInfo[product][invEditTyp]!=-1)
	{
		format(GrandCacheString,length,"%s\n\nINFO: Klicken Sie auf 'Eigenschaften' um die Produkteigenschaften einzusehen.",GrandCacheString);
		ShowPlayerDialog(playerid,InventarDialog,DIALOG_STYLE_MSGBOX,"Inventar",GrandCacheString,"Eigenschaften","Zurück");
	}
	else ShowPlayerDialog(playerid,InventarDialog,DIALOG_STYLE_MSGBOX,"Inventar",GrandCacheString,"Zurück","");
	return 1;
}
GetInventarIDByName(variable[])
{
	for(new x;x!=sizeof(InventarInfo);x++)
	{
		if(!strcmp(InventarInfo[x][invVariable],variable,false)) return x;
	}
	return -1;
}


#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit INV_OnGameModeInit

#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse INV_OnDialogResponse