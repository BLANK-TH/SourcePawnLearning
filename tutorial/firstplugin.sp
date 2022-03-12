#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "First Plugin (Tutorial)",
	author = "blank_dvth",
	description = "Testing plugin to learn SourcePawn",
	version = "1.0",
	url = "about.blankdvth.com"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_test", Command_Test, "Prints 'test' to chat");
}

public Action Command_Test(int client, int args)
{
	if (args > 0)
	{
		ReplyToCommand(client, "[SM] Usage: sm_test");
		return Plugin_Handled;
	}
	ReplyToCommand(client, "Test!");
	return Plugin_Handled;
}
