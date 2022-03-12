#include <sourcemod>
#include <sdktools>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Test Menu",
	author = "blank_dvth",
	description = "Displays a simple menu test",
	version = "1.0.0",
	url = "blankdvth.com"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_testmenu", Command_Test, "Displays a test menu");
}

public Action Command_Test(int client, int args) {
	Menu menu = new Menu(Menu_Callback);
	menu.SetTitle("Test Menu :)");
	menu.AddItem("option1", "Option 1");
	menu.AddItem("option2", "Option 2");
	menu.AddItem("option3", "Option 3", ITEMDRAW_DISABLED);
	menu.AddItem("option4", "Option 4 (CT Only)", (GetClientTeam(client) == CS_TEAM_CT) ? ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
	menu.Display(client, 30);
	return Plugin_Handled;
}

public int Menu_Callback(Menu menu, MenuAction action, int param1, int param2) {
	switch (action) {
		case MenuAction_Select:
		{
			char item[32];
			menu.GetItem(param2, item, sizeof(item));
			
			if (StrEqual(item, "option1")) {
				
			} else if (StrEqual(item, "option2")) {
				
			} else if (StrEqual(item, "option3")) {
				
			} else if (StrEqual(item, "option4")) {
				
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}
