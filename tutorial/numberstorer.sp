#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

int ga_iNumber[MAXPLAYERS + 1] =  { 0, ... };

public Plugin myinfo = 
{
	name = "Number Storer",
	author = "blank_dvth",
	description = "Allow users to store 1 number while online",
	version = "1.0.0",
	url = "blankdvth.com"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_setnumber", Command_Set, "Sets your number");
	RegConsoleCmd("sm_getnumber", Command_Get, "Gets your number");
}

public Action Command_Set(int client, int args) {
	if (args != 1) {
		ReplyToCommand(client, "[SM] Usage: sm_setnumber <number>");
		return Plugin_Handled;
	}
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	int num = StringToInt(arg1);
	ga_iNumber[client] = num;
	
	ReplyToCommand(client, "[SM] Number %d was successfully set!", num);
	return Plugin_Handled;
}

public Action Command_Get(int client, int args) {
	if (args > 0) {
		ReplyToCommand(client, "[SM] Usage: sm_getnumber");
		return Plugin_Handled;
	}
	
	ReplyToCommand(client, "[SM] Your number is: %d", ga_iNumber[client]);
	return Plugin_Handled;
}

public void OnClientConnected(int client) {
	ResetVariables(client);
}

public void OnClientDisconnect(int client) {
	ResetVariables(client);
}

void ResetVariables(int client) {
	ga_iNumber[client] = 0;
}
