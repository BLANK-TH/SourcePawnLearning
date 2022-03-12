#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

ConVar gcv_bAmStupid = null;

public Plugin myinfo = 
{
	name = "Am I Stupid?",
	author = "blank_dvth",
	description = "See if you're stupid or not (convar)'",
	version = "1.0.0",
	url = "blankdvth.com"
};

public void OnPluginStart()
{
	gcv_bAmStupid = CreateConVar("amistupid_everyone_stupid", "0", "Whether everyone is stupid or not (sm_amstupid)", FCVAR_NOTIFY);
	RegConsoleCmd("sm_amstupid", Command_AmStupid, "See if you're stupid or not");
}

public Action Command_AmStupid(int client, int args) {
	if (args > 0) {
		ReplyToCommand(client, "[SM] Usage: sm_amstupid");
		return Plugin_Handled;
	}
	ReplyToCommand(client, "[SM] After careful consideration, you %s stupid", (gcv_bAmStupid.BoolValue) ? "are":"are not");
	return Plugin_Handled;
}
