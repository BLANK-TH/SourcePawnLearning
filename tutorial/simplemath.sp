#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Simple Math",
	author = "blank_dvth",
	description = "Simple plugin with a command to add 2 numbers",
	version = "1.0.0",
	url = "blankdvth.com"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_add2num", Command_Add, "Add two numbers!");
}

public Action Command_Add(int client, int args)
{
	if (args != 2) {
		ReplyToCommand(client, "[SM] Usage: sm_add2num <number1> <number2>");
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	int num1 = StringToInt(arg1);
	int num2 = StringToInt(arg2);
	int sum = AddTwoNumbers(num1, num2);
	ReplyToCommand(client, "[SM] Your sum is: %d", sum);
	return Plugin_Handled;
}

int AddTwoNumbers(int a, int b) {
	int sum = a + b;
	return sum;
}
