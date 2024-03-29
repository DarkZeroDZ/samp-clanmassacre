////////////////////////////////////////////////////////////////////////////////
#include <a_samp>
////////////////////////////////////////////////////////////////////////////////
#if defined _damage_included
  #endinput
#endif
#define _damage_included
#pragma library Damage
#if !defined HOLDING
	#define HOLDING(%0) \
		((newkeys & (%0)) == (%0))
#endif
#if !defined RELEASED
	#define RELEASED(%0) \
		(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#endif
#if !defined KEY_AIM 
	#define KEY_AIM 132
#endif
#define UPDATE_TIME 794 //Time to update vehicle health in miliseconds.
#define MIN_CAR_DAMAGE 50 //Minimun damage for the car.
#define MAX_CAR_DAMAGE 80 //Maximum damage for the car.
#define MAX_DISTANCE 200.0 //Maximim distance that a player is allowed to shot to a car(Must be float).
////////////////////////////////////////////////////////////////////////////////
forward OnPlayerShotVehicle(playerid, vehicleid);
forward OnPlayerUnShotVehicle(playerid, vehicleid);
forward RespawnVehicle(vehicleid);
////////////////////////////////////////////////////////////////////////////////
new Timer[MAX_PLAYERS];
new bool:Created[MAX_PLAYERS];
new bool:Sended[MAX_PLAYERS];
////////////////////////////////////////////////////////////////////////////////
D_OnPlayerConnect(playerid)
{
	KillTimer(Timer[playerid]);
	DeletePVar(playerid, "VehicleID");
   	Created[playerid] = false;
   	Sended[playerid] = false;
    return 1;
}
////////////////////////////////////////////////////////////////////////////////
D_OnPlayerDisconnect(playerid)
{
    KillTimer(Timer[playerid]);
	DeletePVar(playerid, "VehicleID");
   	Created[playerid] = false;
   	Sended[playerid] = false;
    return 1;
}
////////////////////////////////////////////////////////////////////////////////
D_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
 	if(HOLDING(KEY_FIRE))
	{
	    if(Created[playerid] != true)
	    {
	    	Timer[playerid] = SetTimerEx("C_Update", UPDATE_TIME, true, "d", playerid);
	    	Created[playerid] = true;
		}
	}
	else if(RELEASED(KEY_FIRE))
	{
	    if(Created[playerid] != false)
    	{
    	    if(GetPVarInt(playerid, "VehicleID") > 0)
    	    {
    	        new Float: Health, veh;
    	        veh = GetPVarInt(playerid, "VehicleID");
    	    	CallLocalFunction("OnPlayerUnShotVehicle", "ii", playerid, veh);
    	    	GetVehicleHealth(veh, Health);
    	    	if(Health < 250)
    	    	{
    	    	    SetTimerEx("RespawnVehicle", 10000, 0, "i", veh);
    	    	}
			}
		    KillTimer(Timer[playerid]);
		    DeletePVar(playerid, "VehicleID");
		    Created[playerid] = false;
		    Sended[playerid] = false;
		}
	}
	return 1;
}
////////////////////////////////////////////////////////////////////////////////
forward C_Update(playerid);
public C_Update(playerid)
{
	if(GetPlayerWeaponState(playerid) == 0 || GetPlayerWeaponState(playerid) == 3)
	{
		return 1;
	}
	else
	{
	    new veh = GetClosestVehicle(playerid, MAX_DISTANCE);
	    if(veh != 0xFFFF)
	   	{
			new Float: X, Float: Y, Float:Z;
	 		GetVehiclePos(veh, X, Y, Z);
	  		if(GetDistanceToCar(playerid, veh) < MAX_DISTANCE && !IsVehicleOccupied(veh) && InvalidWeapons(playerid) != 1)
		  	{
		  	    new Float: vHealth, rand = random(MAX_CAR_DAMAGE-MIN_CAR_DAMAGE)+MIN_CAR_DAMAGE;
		  	    GetVehicleHealth(veh, vHealth);
		  	    if(IsHeavyVehicle(veh) && IsPlayerAimingAt(playerid, X, Y, Z, 18))
		  	    {
		  	        SetVehicleHealth(veh, vHealth-rand);
		  	        if(Sended[playerid] != true)
		  	        {
		  	            CallLocalFunction("OnPlayerShotVehicle", "ii", playerid, veh);
		  	            SetPVarInt(playerid, "VehicleID", veh);
		  	            Sended[playerid] = true;
		  	            RandomDamage(veh);
		  	        }
				}
				else if(IsDumper(veh) && IsPlayerAimingAt(playerid, X, Y, Z, 22))
				{
					SetVehicleHealth(veh, vHealth-rand);
					if(Sended[playerid] != true)
		  	        {
		  	            CallLocalFunction("OnPlayerShotVehicle", "ii", playerid, veh);
		  	            SetPVarInt(playerid, "VehicleID", veh);
		  	            Sended[playerid] = true;
		  	            RandomDamage(veh);
		  	        }
				}
				else if(IsAirplane(veh) && IsPlayerAimingAt(playerid, X, Y, Z, 25))
				{
					SetVehicleHealth(veh, vHealth-rand);
					if(Sended[playerid] != true)
		  	        {
		  	            CallLocalFunction("OnPlayerShotVehicle", "ii", playerid, veh);
		  	            SetPVarInt(playerid, "VehicleID", veh);
		  	            Sended[playerid] = true;
		  	            RandomDamage(veh);
		  	        }
				}
				else if(IsHelicopter(veh) && IsPlayerAimingAt(playerid, X, Y, Z, 25))
				{
					SetVehicleHealth(veh, vHealth-rand);
 					if(Sended[playerid] != true)
		  	        {
		  	           	CallLocalFunction("OnPlayerShotVehicle", "ii", playerid, veh);
		  	            SetPVarInt(playerid, "VehicleID", veh);
		  	            Sended[playerid] = true;
		  	            RandomDamage(veh);
		  	        }
				}
				else if(IsPlayerAimingAt(playerid, X, Y, Z, 3))
				{
					SetVehicleHealth(veh, vHealth-rand);
					if(Sended[playerid] != true)
		  	        {
		  	            CallLocalFunction("OnPlayerShotVehicle", "ii", playerid, veh);
		  	            SetPVarInt(playerid, "VehicleID", veh);
		  	            Sended[playerid] = true;
		  	            RandomDamage(veh);
		  	        }
				}
			}
		}
	}
	return 1;
}
////////////////////////////////////////////////////////////////////////////////
public RespawnVehicle(vehicleid)
{
	SetVehicleToRespawn(vehicleid);
	return 1;
}
////////////////////////////////////////////////////////////////////////////////
Float:DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ,  Float:ObjX, Float:ObjY, Float:ObjZ,  Float:FrX, Float:FrY, Float:FrZ)
{
	new Float:TGTDistance;
	TGTDistance = floatsqroot((CamX - ObjX) * (CamX - ObjX) + (CamY - ObjY) * (CamY - ObjY) + (CamZ - ObjZ) * (CamZ - ObjZ));
	new Float:tmpX, Float:tmpY, Float:tmpZ;
	tmpX = FrX * TGTDistance + CamX;
	tmpY = FrY * TGTDistance + CamY;
	tmpZ = FrZ * TGTDistance + CamZ;
	return floatsqroot((tmpX - ObjX) * (tmpX - ObjX) + (tmpY - ObjY) * (tmpY - ObjY) + (tmpZ - ObjZ) * (tmpZ - ObjZ));
}
////////////////////////////////////////////////////////////////////////////////
stock IsPlayerAimingAt(playerid, Float:x, Float:y, Float:z, Float:radius)
{
	new Float:cx,Float:cy,Float:cz,Float:fx,Float:fy,Float:fz;
	GetPlayerCameraPos(playerid, cx, cy, cz);
	GetPlayerCameraFrontVector(playerid, fx, fy, fz);
	return (radius >= DistanceCameraTargetToLocation(cx, cy, cz, x, y, z, fx, fy, fz));
}
////////////////////////////////////////////////////////////////////////////////
stock IsPlayerShootingVehicle(playerid)
{
	return GetPVarInt(playerid, "VehicleID");
}
////////////////////////////////////////////////////////////////////////////////
stock GetDistanceToCar(playerid,carid)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2,Float:dis;
	if (!IsPlayerConnected(playerid))return -1;
	GetPlayerPos(playerid,x1,y1,z1);GetVehiclePos(carid,x2,y2,z2);
	dis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(dis);
}
////////////////////////////////////////////////////////////////////////////////
stock GetClosestVehicle(playerid, Float:dis)
{
	new Float:X, Float:Y, Float:Z;
	if(GetPlayerPos(playerid, X, Y, Z))
	{
		new vehicleid = INVALID_VEHICLE_ID;
		for(new v, Float:temp, Float:VX, Float:VY, Float:VZ; v != MAX_VEHICLES; v++)
		{
			if(GetVehiclePos(v, VX, VY, VZ))
			{
				VX -= X, VY -= Y, VZ -= Z;
				temp = VX * VX + VY * VY + VZ * VZ;
				if(temp < dis) dis = temp, vehicleid = v;
			}
		}
		dis = floatpower(dis, 0.5);
		return vehicleid;
	}
	return INVALID_VEHICLE_ID;
}
////////////////////////////////////////////////////////////////////////////////
stock IsHeavyVehicle(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	if(model == 403 || model == 407 || model == 408 || model == 414 || model == 416 || model == 423 || model == 427 || model == 428
	|| model == 431 || model == 432 || model == 437 || model == 443 || model == 444 || model == 455 || model == 456 || model == 498
	|| model == 499 || model == 408 || model == 514 || model == 515 || model == 524 || model == 524 || model == 544 || model == 556
 	|| model == 557 || model == 573 || model == 578 || model == 601 || model == 609)
 	{
 	    return 1;
 	}
	else
	{
	    return 0;
	}
}
////////////////////////////////////////////////////////////////////////////////
stock IsHelicopter(vehicleid)
{
    new model = GetVehicleModel(vehicleid);
	if(model == 548 || model == 425 || model == 417 || model == 487 || model == 488 || model == 497 || model == 563 || model == 447 || model == 469)
	{
	    return 1;
	}
	else
	{
	    return 0;
	}
}
////////////////////////////////////////////////////////////////////////////////
stock IsDumper(vehicleid)
{
    new model = GetVehicleModel(vehicleid);
	if(model == 406)
	{
	    return 1;
	}
	else
	{
	    return 0;
	}
}
////////////////////////////////////////////////////////////////////////////////
stock IsAirplane(vehicleid)
{
    new model = GetVehicleModel(vehicleid);
	if(model == 592 || model == 577 || model == 511 || model == 512 || model == 593 || model == 520 || model == 553 || model == 576 || model == 519 || model == 460 || model == 513)
	{
	    return 1;
	}
	else
	{
	    return 0;
	}
}
////////////////////////////////////////////////////////////////////////////////
stock IsVehicleOccupied(vehicleid)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	    	if(IsPlayerInVehicle(i, vehicleid))
			{
				return 1;
			}
		}
    }
    return 0;
}
////////////////////////////////////////////////////////////////////////////////
stock InvalidWeapons(playerid)
{
	new weap = GetPlayerWeapon(playerid);
	if(weap == 0 || weap == 1 || weap == 4 || weap == 15 || weap == 40 || weap == 46 || weap == 43 || weap == 45 || weap == 44
	|| weap == 42 || weap == 17 || weap == 3 || weap == 7 || weap == 8 || weap == 10 || weap == 11 || weap == 12 || weap == 13)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}
////////////////////////////////////////////////////////////////////////////////
encode_doors(bonnet, boot, driver_door, passenger_door, behind_driver_door, behind_passenger_door)
{
    #pragma unused behind_driver_door
    #pragma unused behind_passenger_door
    return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24);
}
////////////////////////////////////////////////////////////////////////////////
encode_panels(flp, frp, rlp, rrp, windshield, front_bumper, rear_bumper)
{
    return flp | (frp << 4) | (rlp << 8) | (rrp << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24);
}
////////////////////////////////////////////////////////////////////////////////
stock RandomDamage(vehicleid)
{
	new panels, doors, lights, tires;
 	GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
 	switch(random(3))
 	{
  		case 0: panels = encode_panels(1, 1, 1, 1, 3, 3, 3);
  		case 1: doors = encode_doors(4, 4, 4, 4, 0, 0);
  		case 2: lights = encode_lights(1, 1, 1, 1);
	}
  	UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    return 1;
}
////////////////////////////////////EOS/////////////////////////////////////////
