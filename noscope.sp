#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "1.0"

public Plugin myinfo = 
{
	name = "Noscope Only",
	author = "blank_dvth",
	description = "Allows you to force scoped weapons to be noscope, remixed from onet0uch's No Scope round to be simpler",
	version = PLUGIN_VERSION,
	url = "blankdvth.com"
};

ConVar gcv_bEnable;
ConVar gcv_bRifles;
ConVar gcv_bSnipers;
int m_flNextSecondaryAttack = -1;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	// No need for the old GetGameFolderName setup.
	EngineVersion g_engineversion = GetEngineVersion();
	if (g_engineversion != Engine_CSGO)
	{
		SetFailState("This plugin was made for use with Counter-Strike: Global Offensive only.");
	}
} 

public void OnPluginStart()
{
	CreateConVar("sm_noscopeonly_version", PLUGIN_VERSION, "Standard plugin version ConVar.", FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	gcv_bEnable = CreateConVar("noscopeonly_enable", "0", "Whether no scope only is enabled", FCVAR_NOTIFY);
	gcv_bRifles = CreateConVar("noscopeonly_rifles", "0", "Whether scoped rifles (AUG, SG) will be no scope only");
	gcv_bSnipers = CreateConVar("noscopeonly_snipers", "1", "Whether sniper rifles (AWP, SCAR, G3) will be no scope only");
	m_flNextSecondaryAttack = FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
	AutoExecConfig(true);
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast) {
	int client_id = GetEventInt(event, "userid");
	int client = GetClientOfUserId(client_id);
	if (gcv_bEnable.BoolValue) {
		PrintToChat(client, "[SM] Noscope only is enabled! You will be unable to scope on certain weapons.");
		SDKHook(client, SDKHook_PreThink, OnPreThink);
	} else {
		if (IsClientInGame(client)) {
			SDKUnhook(client, SDKHook_PreThink, OnPreThink);
		}
	}
}

public void OnPreThink(int client) {
	SetNoScope(GetPlayerWeaponSlot(client, 0));
}

void SetNoScope(int weapon) {
	if (IsValidEdict(weapon)) {
		char classname[32];
		GetEdictClassname(weapon, classname, sizeof(classname));
		if (gcv_bRifles.BoolValue) {
			if (
			StrEqual(classname[7], "aug") ||
			StrEqual(classname[7], "sg550") ||
			StrEqual(classname[7], "sg552") ||
			StrEqual(classname[7], "sg553") ||
			StrEqual(classname[7], "sg556")
			) {
				SetEntDataFloat(weapon, m_flNextSecondaryAttack, GetGameTime() + 1.0);
			}
		}
		if (gcv_bSnipers.BoolValue) {
			if (
			StrEqual(classname[7], "ssg08") ||
			StrEqual(classname[7], "awp") ||
			StrEqual(classname[7], "scar20") ||
			StrEqual(classname[7], "g3sg1")
			) {
				SetEntDataFloat(weapon, m_flNextSecondaryAttack, GetGameTime() + 1.0);
			}
		}
	}
}
