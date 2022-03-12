#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

ConVar gcv_bEnable;
ConVar gcv_bEnforceNoAutokick;
ConVar gcv_bAutoKick;
int ga_iChickenValues[MAXPLAYERS + 1] = { 0, ... };

public Plugin myinfo = 
{
	name = "Chicken Game", 
	author = "blank_dvth", 
	description = "Every player gets a chicken, if your chicken dies,  you die.", 
	version = "1.0.0", 
	url = "blankdvth.com"
};

public void OnPluginStart()
{
	gcv_bEnable = CreateConVar("chickengame_enable", "0", "Whether chicken game is enabled", FCVAR_NOTIFY);
	gcv_bEnable.AddChangeHook(OnEnableChanged);
	gcv_bEnforceNoAutokick = CreateConVar("chickengame_no_autokick", "1", "Whether chicken game will force mp_autokick to be off, dependant on chickengame_enable.");
	gcv_bAutoKick = FindConVar("mp_autokick");
	gcv_bAutoKick.AddChangeHook(EnforceAutokick);
	HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
	HookEvent("other_death", Event_OtherDeath, EventHookMode_Post);
}

public void OnEnableChanged(ConVar convar, const char[] oldvalue, const char[] newvalue) {
	if (StrEqual(newvalue, "1") && StrEqual(oldvalue, "0")) {
		CreateAllChickens();
		gcv_bAutoKick.BoolValue = false;
	} else if (StrEqual(newvalue, "0") && StrEqual(oldvalue, "1")) {
		ResetAllVariables();
	}
}

public void EnforceAutokick(ConVar convar, const char[] oldvalue, const char[] newvalue) {
	if (gcv_bEnable.BoolValue && gcv_bEnforceNoAutokick.BoolValue) {
		convar.BoolValue = false;
	}
}

public void OnClientConnected(int client) {
	ResetVariables(client);
	if (gcv_bEnable.BoolValue) {
		ga_iChickenValues[client] = SpawnChicken(client);
	}
}

public void OnClientDisconnect(int client) {
	ResetVariables(client);
}

public void Event_OtherDeath(Event event, const char[] name, bool dontBroadcast) {
	int entity = event.GetInt("otherid");
	char classname[32];
	GetEntityClassname(entity, classname, sizeof(classname));
	if (StrEqual(classname, "chicken") && gcv_bEnable.BoolValue) {
		int client = FindClientByIntValue(EntIndexToEntRef(entity));
		if (client == -1) {
			return;
		}
		PrintToChat(client, "[SM] Your chicken was killed! You'll now see it in heaven...");
		ForcePlayerSuicide(client);
		ga_iChickenValues[client] = 0;
	}
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) {
	if (gcv_bEnable.BoolValue) {
		ResetAllVariables();
		CreateAllChickens();
	}
}

void ResetVariables(int client) {
	ga_iChickenValues[client] = 0;
}

void CreateAllChickens() {
	for (int i = 1; i < sizeof(ga_iChickenValues) - 1; i++) {
		if (IsClientInGame(i) && (!IsFakeClient(i)) && IsPlayerAlive(i)) {
			ga_iChickenValues[i] = SpawnChicken(i);
		}
	}
}

void ResetAllVariables() {
	for (int i = 0; i < sizeof(ga_iChickenValues); i++) {
		int chicken = EntRefToEntIndex(ga_iChickenValues[i]);
		if (chicken != 0 && chicken != INVALID_ENT_REFERENCE) {
			RemoveEntity(chicken);
		}
		ResetVariables(i);
	}
}

int SpawnChicken(int client) {
	if (!IsPlayerAlive(client)) {
		return 0;
	}
	int chicken = CreateEntityByName("chicken");
	float origin[3];
	GetClientAbsOrigin(client, origin);
	TeleportEntity(chicken, origin, NULL_VECTOR, NULL_VECTOR);
	bool result = DispatchSpawn(chicken);
	if (!result) {
		SetFailState("Unable to spawn chicken");
		return 0;
	}
	PrintToChat(client, "[SM] Your chicken has been created! Don't let it die, or you'll die with it. (HINT: Press E on the chicken for it to follow you around)");
	return EntIndexToEntRef(chicken);
}

int FindClientByIntValue(int value) {
	for (int i = 0; i < sizeof(ga_iChickenValues); i++) {
		if (ga_iChickenValues[i] != 0) {
			int chicken = ga_iChickenValues[i];
			if (chicken == value) {
				return i;
			}
		}
	}
	return -1;
}
