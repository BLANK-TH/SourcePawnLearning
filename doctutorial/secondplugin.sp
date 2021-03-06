#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "1.0"

public Plugin myinfo = 
{
	name = "Second Plugin",
	author = "blank_dvth",
	description = "Second plugin following the official AlliedMods tutorial",
	version = PLUGIN_VERSION,
	url = "blank_dvth"
};

ConVar g_cvarMySlapDamage = null;

public void OnPluginStart()
{
	CreateConVar("sm_secondplugin_version", PLUGIN_VERSION, "Standard plugin version ConVar.", FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	RegAdminCmd("sm_myslap", Command_MySlap, ADMFLAG_SLAY);
	LoadTranslations("common.phrases.txt");
	
	g_cvarMySlapDamage = CreateConVar("sm_myslap_damage", "5", "Default slap damage");
	AutoExecConfig(true, "plugin_myslap");
}

public Action Command_MySlap(int client, int args) {
	char arg1[32], arg2[32];
	int damage = g_cvarMySlapDamage.IntValue;
	GetCmdArg(1, arg1, sizeof(arg1));
	if (args == 2 && GetCmdArg(2, arg2, sizeof(arg2))) {
		damage = StringToInt(arg2);
	}
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;
	
	if ((target_count = ProcessTargetString(
		arg1,
		client,
		target_list,
		MAXPLAYERS,
		COMMAND_FILTER_ALIVE,
		target_name,
		sizeof(target_name),
		tn_is_ml
	)) <= 0) {
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++) {
		SlapPlayer(target_list[i], damage);
		LogAction(client, target_list[i], "\"%L\" slapped \"%L\" (damage %d)", client, target_list[i], damage);
	}

	if (tn_is_ml) {
		ShowActivity2(client, "[SM] ", "Slapped %t for %d damage!", target_name, damage);
	} else {
		ShowActivity2(client, "[SM] ", "Slapped %s for %d damage!", target_name, damage);
	}
	
	return Plugin_Handled;
}
