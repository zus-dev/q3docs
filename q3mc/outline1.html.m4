<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
changequote([*,*])dnl
changecom([*<!--*],[*-->*])dnl
define(ENT_title,[*[*BASEQ3 Runthrough, Server-side*]*])dnl
define(TITLE,<h1>$1</h1>)dnl
define(SYNOPSIS,<h2>Synopsis</h2><p>$1</p>)dnl
define(XXX,[*<b class="xxx">[*XXX*]</b>*])dnl
define(ENT_q3w_mpf,<a href="http://www.quake3world.com/cgi-bin/forumdisplay.cgi?action=topics&amp;forum=Modifications+Programming&amp;number=4">Quake 3 World Modifications Programming Forum (MPF)</a>)dnl
define(ENT_mod,game module)dnl
define(ENT_angbra,[*&lt;*])dnl left angle bracket
define(ENT_angket,[*&gt;*])dnl right angle bracket
define(ENT_lt,[*&lt;*])dnl less-than
define(ENT_gt,[*&gt;*])dnl greater-than
define(ENT_amp,[*&amp;*])dnl ampersand
define(ENT_authornick,PhaethonH)dnl Author's nick
define(ENT_authormail,[*PhaethonH@gmail.com*])dnl Author's e-mail address
define(ENT_CS,ConfigString)dnl
define(QUOT,<q>$1</q>)dnl
define(_ELEM,ifelse([*$2*],,<[*$1*]>$3</[*$1*]>,<[*$1*] class="[*$2*]">$3</[*$1*]>))dnl
define(FILENAME,_ELEM(tt,filename,[*$1*]))dnl
define(FUNCNAME,_ELEM(var,funcname,[*$1*]))dnl
define(VARNAME,_ELEM(var,varname,[*$1*]))dnl
define(CVARNAME,QUOT(_ELEM(span,cvarname,[*$1*])))dnl
define(CONSTNAME,_ELEM(tt,constname,[*$1*]))dnl
define(TYPENAME,_ELEM(var,typename,[*$1*]))dnl
define(KEYNAME,QUOT(_ELEM(tt,keyname,[*$1*])))dnl
define(CSNAME,_ELEM(span,configstring,[*$1*]))dnl
define(REWARDNAME,QUOT(_ELEM(span,rewardname,[*$1*])))dnl
define(COMMAND,QUOT(_ELEM(kbd,command,[*$1*])))dnl
define(KEYB,_ELEM(kbd,,[*$1*]))dnl
define(HORIZRULEa,<hr id="codestart>)dnl
define(HORIZRULEb,<hr id="codestop">)dnl
define(HORIZRULEz,<hr id="footer" width="42%" align="left">)dnl
define(_INDENT,_ELEM(div,indented,[*$1*]))dnl
define(_P,<p>$1)dnl
define(_ST,<strong>$1</strong>)dnl
define(_EM,<em>$1</em>)dnl
define(VERBATIM,HORIZRULEa<pre>$1</pre>HORIZRULEb)dnl
define(SECT,<h2><a name="$1">$2</a></h2>[*undefine([*_SN*])define(_SN,$1)*])dnl
define(SECT1,<h3><a name="$1">$2</a></h3>)dnl
define(SECT2,<h4><a name="$1">$2</a></h4>)dnl
define(XREF,[*<a href="#$1">$2</a>*])dnl
define(QV,[*See also <a href="#$1">$1</a>*])dnl quod vide -> "see which"
define(LIST_ORDERED,<ol>$1</ol>)dnl
define(LIST_UNORDERED,<ul>$1</ul>)dnl
define(LIST_DICT,<dl>$1</dl>)dnl
define(LI,<li>$1</li>)dnl
define(DT,<dt>$1</dt>)dnl
define(DD,<dd>$1</dd>)dnl
define(DICT,[*DT(<a name="_SN().$1">[*$1*])DD([*$2*])*])dnl
define(ADDRESS,[*<address>$1</address>*])dnl
define(_LF,[*<br>*])dnl
define(OBLITERATE,[**])dnl
dnl
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="./outline1.css">
<title>ENT_title</title>
</head>
<body>
TITLE(ENT_title)

SYNOPSIS([*Illustration of an execution path through a Q3 game module (baseq3), from startup through gameplay though shutdown, for dedicated server mode, in outline form.*])

_INDENT([*
_P([*
_ST(Motivation):
Enhanced understanding of Q3A to assist in modding and total conversions.
*])
*])dnl _INDENT

_INDENT([*
_P([*
_ST(Caveats):
This document certainly is not a thorough understanding nor explanation of Q3.
Information was gleaned by poring through the game source text, with minimal testing.
Most of the statements made in this document are based on source comments and QUOT(gut feelings).
*])
*])dnl _INDENT

SECT(engineStart,Engine Start)
_P([*
Before the game (modification) even loads, Quake 3 on startup:
LIST_ORDERED([*
LI([*searches for/in pak (.pk3) files according to the server cvar CVARNAME(fs_game)*])
LI([*runs startup configuration (.cfg) files FILENAME(default.cfg) and FILENAME(q3config.cfg)*])
LI([*initializes the dynamic memory hunk (CVARNAME(com_hunkMegs), CVARNAME(com_soundMegs), CVARNAME(com_zoneMegs))*])
LI([*opens network sockets for listening*])
*])dnl LIST_ORDERED
*])dnl _P

SECT(gameStart,Game Start)
_P([*
The most straight-forward way to launch the game is to start a valid map, with the server command QUOT(map VARNAME(mapname)).
Quake 3 on game start:
LIST_ORDERED([*
LI([*loads the map/level (.bsp) file*])
LI([*looks through the pak (.pk3) files found on startup*])
LI([*loads the game qvm file (FILENAME(qagame.qvm))*])
LI([*compiles the qvm bytecode to native code if VARNAME(vm_game) is set to 2*])
LI([*jumps to the QVM procedure linked at code address 0 (i.e. FUNCNAME(vmMain()))*])
LI([*upon returning from the QVM procedure, does some other things (such as network tasks, reading in server commands, complaining with Hitch Warnings, etc.)*])
LI([*jumps to code address 0 again*])
LI([* rinse, lather, repeat.*])
*])dnl LIST_ORDERED
*])dnl _P

SECT(vmMain,vmMain)
_P([*
The QVM file lacks a symbol table, so the QVM interpreter/compiler subsystem must make a blind decision on a reasonable entry point into the QVM.
Currently, Q3 simply branches to QVM code address 0.
While Q3 (the engine) decides to jump to code address 0, the game (mod) expects Q3A to jump into the function named FUNCNAME(vmMain()).
To ensure these two expectations coincide, FUNCNAME(vmMain()) must be the first function compiled before any other function into QVM bytecode.
This means the function FUNCNAME(vmMain()) must be the first fully-defined function in the first assembled file.
In baseq3, this is FUNCNAME(vmMain()) in g_main.c, which gets assembled first as specified in the file game.q3asm, thus ensuring FUNCNAME(vmMain()) links as code address 0.
Note that other variables may be declared/defined before FUNCNAME(vmMain()), and other functions may be prototyped/declared before FUNCNAME(vmMain()), but the first function _EM(body) to be compiled must be FUNCNAME(vmMain()).
*])
_P([*
The function at code address 0 is the critical function.
The associated name can be anything, but for consistency I shall refer to code address 0 as QUOT(vmMain), as it is in baseq3.
*])
_P([*
On each server frame (time period determined by cvar CVARNAME(sv_fps)), the Q3 engine calls FUNCNAME(vmMain()) with a number of arguments.
The first argument (VARNAME(command) in baseq3) determines what QUOT(major action) to which the game should react.
These actions are enumerated in FILENAME(g_public.h), as enum type TYPENAME(gameExport_t).
Since the arguments to FUNCNAME(vmMain()) are specified by the Q3 engine, and merely reflected in TYPENAME(gameExport_t), modifying TYPENAME(gameExport_t) does not change anything in the game module, except possibly to confuse it badly.
*])


SECT1(vmMain.overview, Overview: vmMain command/major game function)
_P([*
A quick overview of the vmMain commands (major game functions) in baseq3:
LIST_UNORDERED([*
LI([*XREF(vmMain.GAME_INIT,CONSTNAME(GAME_INIT)) - called on game load/startup.*])
LI([*XREF(vmMain.GAME_SHUTDOWN,CONSTNAME(GAME_SHUTDOWN)) - called on end of map/level or server quitting, before actual exit.*])
LI([*XREF(vmMain.GAME_CLIENT_CONNECT,CONSTNAME(GAME_CLIENT_CONNECT)) - called when a new player connects to the server.*])
LI([*XREF(vmMain.GAME_CLIENT_THINK,CONSTNAME(GAME_CLIENT_THINK)) - called (frequency unknown) to handle player inputs and movements.*])
LI([*XREF(vmMain.GAME_CLIENT_USERINFO_CHANGED,CONSTNAME(GAME_CLIENT_USERINFO_CHANGED)) - called when a client userinfo record has changed (such as name or player model) and the new information needs to be relayed to all players.*])
LI([*XREF(vmMain.GAME_CLIENT_DISCONNECT,CONSTNAME(GAME_CLIENT_DISCONNECT)) - called when a client disconnect (voluntary disconnect, kicked, timed out), for selective cleanup.
Not called on map/level end (which is wholesale destruction of QVM memory, QV(GAME_SHUTDOWN,GAME_SHUTDOWN)).*])
LI([*XREF(vmMain.GAME_CLIENT_BEGIN,CONSTNAME(GAME_CLIENT_BEGIN)) - called when a client's connection is established, map loaded, and ready to start playing (i.e. supply user inputs).*])
LI([*XREF(vmMain.GAME_CLIENT_COMMAND,CONSTNAME(GAME_CLIENT_COMMAND)) - when a client sends a command to the server (such as COMMAND(say), COMMAND(say_team), or COMMAND(kill)).*])
LI([*XREF(vmMain.GAME_RUN_FRAME,CONSTNAME(GAME_RUN_FRAME)) - called once per server frame to animate and move all non-player entities that need movement or thinking.*])
LI([*XREF(vmMain.GAME_CONSOLE_COMMAND,CONSTNAME(GAME_CONSOLE_COMMAND)) - called to handle server-side commands (from admin), including rcon commands.*])
dnl LI([*CONSTNAME(BOTAI_START_FRAME) - called to initialize bot AI.  Afterwards, any AIs added to the game appears as a player to FUNCNAME(vmMain()).*])
dnl AI framerate is separate from game framerate.
LI([*CONSTNAME(BOTAI_START_FRAME) - Schedules and executes bot user command (framerate of AI is not synchronized with server framerate). <!--(cyrri)-->*])
*])dnl LIST_UNORDERED
*])dnl _P

_P([*
The call to FUNCNAME(vmMain()) is made by the Q3 engine.
The parameters passed to vmMain are marshalled by the Q3 engine.
Additions or changes to these major game functions must be implemented in the engine and reflected in the game module (mod).
Such ability (to add or change major functions) is limited to developers with access to the Q3 engine (not mod) source.
Currently (2002 Aug) this is Id Software itself and its direct licensees (proprietary license).
*])

SECT1(vmMain.GAME_INIT,[*vmMain(GAME_INIT, VARNAME(levelTime), VARNAME(randomSeed), VARNAME(restart))*])
_P([*
When the game module is first loaded on game start, Q3 calls vmMain with major function CONSTNAME(GAME_INIT), along with three additional arguments:
LIST_ORDERED([*
LI([*VARNAME(levelTime) - the number of milliseconds the game has been in progress, usually 0 (non-zero for restarts).*])
LI([*VARNAME(randomSeed) - a seed value for the random number generator (RNG).*])
LI([*VARNAME(restart) - ???, affects bot AI initialization only.*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
In FUNCNAME(vmMain()), the code immediately branches to FUNCNAME(G_InitGame()) when FUNCNAME(vmMain) recognizes CONSTNAME(GAME_INIT).
*])

SECT2(G_InitGame,[*G_InitGame(levelTime, randomSeed, restart)*])
_P([*
LIST_ORDERED([*
LI([*Initialize random number generator with VARNAME(randomSeed) -- KEYB(srand(randomSeed)).*])
LI([*Register cvars (associates cvars in the Q3 engine with cvar_t variables in game engine) -- FUNCNAME(G_RegisterCvars()).
 LIST_ORDERED([*
 LI([*Goes through all entries in array VARNAME(gameCvarTable[]), associating the cvar in the Q3 engine with the cvar_t variable in the game engine (QVM memory).*])
 *])dnl LIST_ORDERED
*])dnl LI
LI([*Initialize banlist -- FUNCNAME(G_ProcessIPBans()).
 LIST_ORDERED([*
 LI([*Reads list of space-separated IP addresses from cvar CVARNAME(g_banIPs).*])
 LI([*Adds each banned address to ban filter list -- FUNCNAME(AddIP()).
  LIST_ORDERED([*
  LI([*Maximum of 1024 banned addresses.*])
  LI([*Converts dotted-quad notation to an internal filter format -- FUNCNAME(StringToFilter()).*])
  LI([*Adds filter record to array VARNAME(ipFilters[]).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Initialize the in-QVM dynamic memory pool of 256KB (hey, 64KB sent us to the moon!) -- FUNCNAME(G_InitMemory()).*])
LI([*Start logging if so configured.*])
LI([*Initialize world session information -- FUNCNAME(G_InitWorldSession()).
 LIST_ORDERED([*
 LI([*Resets cvar CVARNAME(session)*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Initialize game entities.*])
LI([*Initialize game clients (players).*])
LI([*Tell the Q3 engine about g_entities, for network engine purposes -- FUNCNAME(trap_LocateGameData()).*])
LI([*Initialize body queue (for sinking corpses, etc.) -- FUNCNAME(InitBodyQue()).
 LIST_ORDERED([*
 LI([*Allocates 8 game entities and reserves them for the body queue.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Initialize item registration -- FUNCNAME(ClearRegisteredItems()).
 LIST_ORDERED([*
 LI([*Clears the array VARNAME(itemRegistered[]).*])
 LI([*Registers machine gun -- FUNCNAME(RegisterItem()).
  LIST_ORDERED([*
  LI([*Sets VARNAME(itemRegistered[10]) to true (offset for machine gun weapon item)*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Registers gauntlet -- FUNCNAME(RegisterItem()).
  LIST_ORDERED([*
  LI([*Sets VARNAME(itemRegistered[8]) to true (offset for gauntlet weapon item)*])
  *])dnl LIST_ORDERED
  *])dnl LI
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Spawn map entities -- FUNCNAME(SpawnEntitiesFromString()).
 LIST_ORDERED([*
 LI([*Enable entities spawning with KEYB(level.spawning = qtrue).*])
 LI([*Parse VARNAME(worldspawn) variable, which must be the first such entity in the map file -- FUNCNAME(SP_worldspawn()).
  LIST_ORDERED([*
  LI([*Read a spawn string -- FUNCNAME([*G_SpawnString("classname", "", ENT_amp()s)*]).
   LIST_ORDERED([*
   LI([*Retrieve the next spawn string, complain if the spawn string key doesn't match the first argument (i.e. "classname"), otherwise store the value into the third argument.  The second argument provides a default value if no value is specified in the map file.*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Complain if the string isn't the worldspawn variable, with a fatal error (game stops).*])
  LI([*Set ENT_CS CSNAME(CS_GAME_VERSION) according to mod.*])
  LI([*Set ENT_CS CSNAME(CS_LEVEL_START_TIME) according to the recorded start time.*])
  LI([*Set ENT_CS CSNAME(CS_MUSIC) (map-specific background music) according to spawn entity -- FUNCNAME([*G_SpawnString("music", "", ENT_amp()s)*]).*])
  LI([*Set ENT_CS CSNAME(CS_MESSAGE) (map-specific message) according to spawn entity -- FUNCNAME([*G_SpawnString("message", "", ENT_amp()s)*]).*])
  LI([*Set ENT_CS CSNAME(CS_MOTD) (server MOTD) according to server cvar CVARNAME(sv_motd).*])
  LI([*Set cvars CVARNAME(g_gravity), CVARNAME(g_enableDust), and CVARNAME(g_enableBreath) according to spawn entities.*])
  LI([*Record the existence of the worldspawn entity.*])
  LI([*Set warmup time as needed, based on cvar CVARNAME(g_doWarmup).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Parse spawn variables -- FUNCNAME(G_ParseSpawnVars()).
  LIST_ORDERED([*
  LI([*Expect an opening brace (QUOT([*{*])), fail miserably if not found -- FUNCNAME(trap_GetEntityToken()).*])
  LI([*Read all key/value pairs.
   LIST_ORDERED([*
   LI([*Read a token as a key -- FUNCNAME(trap_GetEntityToken()).*])
   LI([*Stop loop if this token is a closing brace (QUOT([*}*])).*])
   LI([*Read a token as a value -- FUNCNAME(trap_GetEntityToken()).*])
   LI([*Complain if this token is a closing brace (QUOT([*}*])).*])
   LI([*Complain if there are now more than 64 spawn variables.*])
   LI([*Record spawn variable key.*])
   LI([*Record spawn variable value.*])
   *])dnl LIST_ORDERED
   *])dnl LI
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Spawn entities from spawn variables -- FUNCNAME(G_SpawnGEntityFromSpawnVars()).
  LIST_ORDERED([*
  LI([*Allocate a game entity -- FUNCNAME(G_Spawn()).*])
  LI([*Parse the fields for each spawn variable -- FUNCNAME(G_ParseField()).
   LIST_ORDERED([*
   LI([*???!*])
   LI([*Takes key/value pairs and sets fields in game entity using arcane binary doohackery.*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Destroy entity according to game type and gametype spawnflags (CONSTNAME(notsingle), CONSTNAME(notteam), CONSTNAME(notfree)).*])
  LI([*Destroy entity according to spawn variable VARNAME(gametype) and active game type.*])
  LI([*Adjust origins(?)*])
  LI([*Call assocated game spawn function -- FUNCNAME(G_CallSpawn()).
   LIST_ORDERED([*
   LI([*Complain if entity classname is CONSTNAME(NULL).*])
   LI([*Attempt to spawn as an item -- FUNCNAME(G_SpawnItem()).
    LIST_ORDERED([*
    LI([*Set entity field VARNAME(random) according to spawn variable VARNAME(random).*])
    LI([*Set entity field VARNAME(wait) according to spawn variable VARNAME(wait).*])
    LI([*Register this item -- FUNCNAME(RegisterItem()).*])
    LI([*Check if item is disabled and don't spawn if so -- FUNCNAME(G_ItemDisabled()).
     LIST_ORDERED([*
     LI([*Returns the value of cvar CVARNAME(disable_[**]VARNAME(classname)).  So to disable quad damage would be COMMAND(/set disable_quaddamage 1).*])
     *])dnl LIST_ORDERED
     *])dnl LI
    LI([*Record global/master/templated item information.*])
    LI([*Set think time and function -- FUNCNAME(FinishSpawningItem()).
     LIST_ORDERED([*
     LI([*Makes items fall to floor.  Falling is disabled at spawn time to prevent items spawning within other entities.*])
     *])dnl LIST_ORDERED
     *])dnl LI
    LI([*Make entity bouncy.*])
    LI([*Set powerup fields for powerup items (in particular, VARNAME(speed) according to spawn variable VARNAME(noglobalsound)).*])
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*If the entity didn't spawn as an item, attempt to spawn as a normal entity by finding the classname and calling the associated spawn function -- FUNCNAME(s-ENT_gt()spawn()).
(XXX: VARNAME(spawn[]) and list of FUNCNAME(SP_*()) functions)
*])
   LI([*Failing that, complain about lack of spawn function.*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Destroy object if no such spawn function exists.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Initialize teams information -- FUNCNAME(G_FindTeams()).
 LIST_ORDERED([*
 LI([*Create a linked list for each team composed of all entities belonging to the team.  The team master is the lowest numbered entity that is not a slave.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Broadcast item registration information via ENT_CS -- FUNCNAME(SaveRegisteredItems()).
 LIST_ORDERED([*
 LI([*Sets ENT_CS CSNAME(CS_ITEMS) to a sequence of ASCII QUOT(1) and QUOT(0) according tot he content of array VARNAME(itemRegistered[]).  The information is transmitted to all clients for precaching purposes.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Initialize bot AI -- FUNCNAME(BotAISetup()), FUNCNAME(BotAILoadMap()), FUNCNAME(G_InitBots()).
 (XXX: Aieeee!)
*])
LI([*Various other server-side tweaks.*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
That was just for game initialization.
*])


SECT1(vmMain.GAME_SHUTDOWN,[*vmMain(GAME_SHUTDOWN, VARNAME(restart))*])
_P([*
When Q3 wants to shut down the game module, Q3 calls FUNCNAME(vmMain()) with major function CONSTNAME(GAME_SHUTDOWN), and one additional argument:
LIST_ORDERED([*
LI([*VARNAME(restart) - ???, affects bot AI initialization only.*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
In FUNCNAME(vmMain()), the code immediately branches to FUNCNAME(G_ShutdownGame()) when FUNCNAME(vmMain()) recognizes CONSTNAME(GAME_SHUTDOWN).
*])dnl _P

_P([*
For map changes (as after end of round), the game module is shut down then initialized again with the new map (partly to have a clean slate for the new map's entities).
Any data within QVM memory is irretrievably destroyed.
Any data that needs to survive across map changes, or even map restarts, must be committed to files (disk) or cvars (Q3 engine memory).
*])dnl _P

SECT2(G_ShutdownGame,G_ShutdownGame(restart))
_P([*
LIST_ORDERED([*
LI([*Closes any logs.*])
LI([*Save session data -- FUNCNAME(G_WriteSessionData()).
 LIST_ORDERED([*
 LI([*Save world session data to cvar CVARNAME(session), which is just current gametype.*])
 LI([*Save each client session data -- FUNCNAME(G_WriteClientSessionData()).
  LIST_ORDERED([*
  LI([*Save to cvar CVARNAME(session[**]VARNAME(clientnum)) the information pertaining to client's team, spectator time, spectator state, client being spectated, wins, losses, and teamLeader.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Shutdown bot AI -- FUNCNAME(BotAIShutdown()).
 LIST_ORDERED([*
 LI([*(XXX: yeah, right...)*])
 *])dnl LIST_ORDERED
 *])dnl LI
*])dnl LIST_ORDERED
*])dnl _P


SECT1(vmMain.GAME_CLIENT_CONNECT,[*vmMain(GAME_CLIENT_CONNECT, VARNAME(clientNum), VARNAME(firstTime), VARNAME(isBot))*])
_P([*
When a client connects to the server, Q3 calls FUNCNAME(vmMain()) with major function CONSTNAME(GAME_CLIENT_CONNECT), with arguments:
LIST_ORDERED([*
LI([*VARNAME(clientNum) - the assigned client number according to the Q3 engine.*])
LI([*VARNAME(firstTime) - zero if a persistent connection from a previous game on the same server, non-zero if a fresh connect to the server.*])
LI([*VARNAME(isBot) - non-zero if the connecting player is a bot AI.*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
In FUNCNAME(vmMain()), code immediated branches to FUNCNAME(ClientConnect()) when vmMain recognizes CONSTNAME(GAME_CLIENT_CONNECT).
*])

SECT2(ClientConnect,[*ClientConnect(clientNum, firstTime, isBot)*])
_P([*
LIST_ORDERED([*
LI([*Get userinfo string from client -- FUNCNAME(trap_GetUserinfo()).*])
LI([*Check if client's IP address is banned -- FUNCNAME(G_FilterPacket()).
 LIST_ORDERED([*
 LI([*Check client's IP address against each entry in array VARNAME(ipFilters[]).*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Check for password.*])
LI([*Read/initialize session data -- FUNCNAME(G_InitSessionData()).
 LIST_ORDERED([*
 LI([*Figure out a team to join; autojoin, spectator, predetermined join (same team as last game), waiting-in-line.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Set various flags if bot.*])
LI([*Enact effects of client userinfo -- FUNCNAME(ClientUserinfoChanged()).
 LIST_ORDERED([*
 LI([*Get userinfo from client (again).*])
 LI([*Enforce sanity-check on name -- FUNCNAME(Info_Validate()).
  LIST_ORDERED([*
  LI([**])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Check if local client (non-networked).*])
 LI([*Check if client wants item prediction.*])
 LI([*Set client name.*])
 LI([*Set client team.*])
 LI([*Announce any during-play name change (a client that just connected technically had a name-change from nothing to something, but this particular name change isn't announced).*])
 LI([*Set max health (influence by VARNAME(handicap) value).*])
 LI([*Set player model.*])
 LI([*Select skin according to team (if applicable).*])
 LI([*Set teamtask.*])
 LI([*Arrange a subset of userinfo into a ENT_CS, stored into a CSNAME(CS_*) slot based on client number.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Announce team joining -- FUNCNAME(BroadcastTeamChange()).
 LIST_ORDERED([*
 LI([*Tells everyone in the game about someone joining/changing teams.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Calculate client ranks -- FUNCNAME(CalculateRanks()).
 LIST_ORDERED([*
 LI([*(XXX: lotsa math and sorting...)*])
 *])dnl LIST_ORDERED
 *])dnl LI
*])dnl LIST_ORDERED
*])dnl _P


SECT(vmMain.GAME_CLIENT_THINK,[*vmMain(GAME_CLIENT_THINK, clientNum)*])
_P([*
Called (frequency unknown) to handle player input to the game and player movement within the game, with one additional argument:
LIST_ORDERED([*
LI([*VARNAME(clientNum) - the client number of which to handle input.*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
In FUNCNAME(vmMain()), the code immediately branches to FUNCNAME(ClientThink()) when vmMain recognizes CONSTNAME(GAME_CLIENT_THINK).
*])

SECT2(ClientThink,[*ClientThink(clientNum)*])
_P([*
LIST_ORDERED([*
LI([*Retrieve user input -- FUNCNAME(trap_GetUsercmd()).*])
LI([*Mark the time input was received.*])
LI([*If not a bot, do non-bot client think process -- FUNCNAME(ClientThink_real()).*])
*])dnl LIST_ORDERED
*])dnl _P

SECT2(ClientThink_real,[*ClientThink_real(clientNum)*])
_P([*
LIST_ORDERED([*
LI([*Check if client is still in QUOT(Connecting) phase.  Return from function if so.*])
LI([*Record time of retrieval of usercmd (user input).*])
LI([*Basic timestamp sanity check to squelch speedup cheats.*])
LI([*Sanity checks on cvar CVARNAME(pmove_msec).*])
LI([*Timestamp checks for cvar CVARNAME(pmove_fixed).*])
LI([*Check for intermission -- FUNCNAME(ClientIntermissionThink()).
 LIST_ORDERED([*
 LI([*Disable talk balloons and weapons.*])
 LI([*Toggle QUOT(READY) status each time attack button is pressed (changes from low to high).*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*If client is spectator, do spectator thinking and return -- FUNCNAME(SpectatorThink()).
 LIST_ORDERED([*
 LI([*If not following, do almost-normal movements and some triggering.*])
 LI([*Start following or cycle to next spectatee(?) if attack button is pressed.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Check for inactivity timer -- FUNCNAME(ClientInactivityTimer()).
 LIST_ORDERED([*
 LI([*If cvar CVARNAME(g_inactivity) is unset or 0, set inactivity timer to 1 minute, but don't do any actual inactivity kicking.  This gives some leeway to all players during the instant when admin decides to actually set inactivity timer during gameplay (otherwise the time since game start counts as inactivity at that instant).*])
 LI([*Otherwise check if client is moving or doing some action, and push forward the inactivity timestamp.*])
 LI([*Do not kick local player(s).*])
 LI([*Otherwise check if current time surpassed inactivity timestamp and kick.*])
 LI([*Otherwise see if time to send 10-second warning.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Clear overhead reward icons if time expired.*])
LI([*Check movement style (noclip, dead, normal).*])
LI([*Inherit gravity value.*])
LI([*Set client speed.*])
LI([*Increase client speed due to any powerups (haste, scout).*])
LI([*Prepare for pmove (predictable movement) calculation.*])
LI([*Check for gauntlet hit for the gauntlet-hit animation if attack button is held with gauntlet, store into VARNAME(pm.gauntletHit) -- FUNCNAME(CheckGauntletAttack()).
 LIST_ORDERED([*
 LI([*See if any damageable object is within 32 units of player.*])
 LI([*Create blood splatters.*])
 LI([*Increase damage due to powerups (Quad, Doubler).*])
 LI([*Apply damage to victim.*])
 LI([*Return true if gauntlet made a hit, otherwise return false.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Check for gesturing and set animation if needed.*])
LI([*Check for invulnerability powerup (Team Arena only).*])
LI([*Make pmove calculations -- FUNCNAME(Pmove()).*])
LI([*Save results of pmove into client structs.*])
LI([*Smooth out if cvar CVARNAME(g_smoothClients) is non-zero -- FUNCNAME(BG_PlayerStateToEntityState()).*])
LI([*Snap various vectors (round components to nearest integer).*])
LI([*Execute client events -- FUNCNAME(ClientEvents()).
 LIST_ORDERED([*
 LI([*Retrieve next client event.*])
 LI([*Check fall damages (CONSTNAME(EV_FALL_MEDIUM), CONSTNAME(EV_FALL_FAR)):
  LIST_ORDERED([*
  LI([*Check that fall damage is being applied to a player.*])
  LI([*Check if fall damage is disabled (cvar CVARNAME(g_dmflags) ENT_amp CONSTNAME(DF_NO_FALLING) (8)).*])
  LI([*Set damage amount, 10 for far, 5 for medium.*])
  LI([*Set pain debounce time (XXX: what??)*])
  LI([*Apply damage to player -- FUNCNAME(G_Damage()).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Check weapon firing (CONSTNAME(EV_FIRE_WEAPON)):
  LIST_ORDERED([*
  LI([*Fire weapon -- FUNCNAME(FireWeapon()).
   LIST_ORDERED([*
   LI([*(XXX: Aieee!)*])
   *])dnl LIST_ORDERED
   *])dnl LI
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Check using handheld teleporter (CONSTNAME(EV_USE_ITEM1)):
  LIST_ORDERED([*
  LI([*Drop CTF flag(s).*])
  LI([*Select a random spawn point -- FUNCNAME(SelectSpawnPoint()).*])
  LI([*Teleport the player to the new point -- FUNCNAME(TeleportPlayer()).
   LIST_ORDERED([*
   LI([*Create appropriate teleport effects at old and new points.*])
   LI([*Unlink player from game -- FUNCNAME(trap_UnlinkEntity()).*])
   LI([*Place player at new spawn point with some altered properties (speed, angle).*])
   LI([*Telefrag.*])
   LI([*Update from pmove calculations -- FUNCNAME(BG_PlayerStateToEntityState()).*])
   LI([*Link player back into game.*])
   *])dnl LIST_ORDERED
   *])dnl LI
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Check using medkit (CONSTNAME(EV_USE_ITEM2)):
  LIST_ORDERED([*
  LI([*Sets health to player's maximum health plus 25; the maximum health may vary according to handicap.  The medkit is QUOT(used up) (removed) elsewhere.<!--(cyrri-->*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Check using kamikaze (Team Arena only, CONSTNAME(EV_USE_ITEM3)):*])
 LI([*Check using portal(???) (Team Arena only, CONSTNAME(EV_USE_ITEM4)):*])
 LI([*Check using invulnerability (Team Arena only, CONSTNAME(EV_USE_ITEM5)):*])
 LI([*Ignore other event types.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Link entity into the world and PVS -- FUNCNAME(trap_LinkEntity()).*])
LI([*Trigger any... triggers -- FUNCNAME(G_TouchTriggers()).
 LIST_ORDERED([*
 LI([*Ensure the triggerer(?) is a living player.*])
 LI([*Find all entities reaching into player's space (bounding box), store list into array VARNAME(touch[]).*])
 LI([*For each touched entity:
  LIST_ORDERED([*
  LI([*Ignore if not a trigger.*])
  LI([*If spectating, ignore certain triggers.*])
  LI([*If an item, ignore (since item-touching is handled elsewhere) -- FUNCNAME(BG_PlayerTouchesItem())*])
  LI([*Otherwise check that the player really is in contact with this entity -- FUNCNAME(trap_EntityContact()).*])
  LI([*If this entity has a FUNCNAME(touch()) function, call it -- FUNCNAME(hit-ENT_gt()touch()).*])
  LI([*If client has a FUNCNAME(touch()) function, call it -- FUNCNAME(ent-ENT_gt()touch()).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Check for jumppad.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Some bot AI checks -- FUNCNAME(BotTestAAS()).
 LIST_ORDERED([*
 LI([*(XXX: foo)*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Interact with other objects/entities -- FUNCNAME(ClientImpacts()).
 LIST_ORDERED([*
 LI([*For each entity the player is touching (VARNAME(pm-ENT_gt()numtouch), VARNAME(pm-ENT_gt()touchents[])):
  LIST_ORDERED([*
  LI([*Run the player's FUNCNAME(touch()) function, if it exists.*])
  LI([*Run the other entity's FUNCNAME(touch()) function, if it exists.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Save results of triggers and events.*])
LI([*Swap/latch button actions, helps check for button press/release.*])
LI([*If player is dead, check for respawning, based on button press or cvar CVARNAME(g_forcerespawn) -- FUNCNAME(respawn()).
 LIST_ORDERED([*
 LI([*Create a corpse in body queue -- FUNCNAME(CopyToBodyQue()).
  LIST_ORDERED([*
  LI([*Selects next spot in queue, overwriting as it goes.*])
  LI([*Unlink the body queue entry -- FUNCNAME(trap_UnlinkEntity()).*])
  LI([*Copy properties of corpse, unset inapplicable properties (such as powerups).*])
  LI([*Set to last frame of death animation, to prevent looped animation.*])
  LI([*Set movement properties.*])
  LI([*Link corpse into game -- FUNCNAME(trap_LinkEntity()).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Spawn the player -- FUNCNAME(ClientSpawn()).
  LIST_ORDERED([*
  LI([*If a spectator, just set a spawn point for spectators -- FUNCNAME(SelectSpectatorSpawnPoint()).
   LIST_ORDERED([*
   LI([*Spawn at intermission location -- FUNCNAME(FindIntermissionPoint()).
    LIST_ORDERED([*
    LI([*Look for CONSTNAME(info_player_intermission) entity.*])
    LI([*Set viewing angles, towards a target if specified.*])
    LI([*If intermission entity does not exist, the map creator is a moron:
     LIST_ORDERED([*
     LI([*Select a single-player spawn point as if normally playing, to use as intermission entity -- FUNCNAME(SelectSpawnPoint()).*])
     *])dnl LIST_ORDERED
     *])dnl LI
    *])dnl LIST_ORDERED
    *])dnl LI
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*If a team game, choose spawn point for team games -- FUNCNAME(SelectCTFSpawnPoint()).
   LIST_ORDERED([*
   LI([*Choose a team spawn point -- FUNCNAME(SelectRandomTeamSpawnPoint()).
    LIST_ORDERED([*
    LI([*If just joining the team, look for spawn point named CONSTNAME(team_CTF_redplayer) or CONSTNAME(team_CTF_blueplayer) according to team.*])
    LI([*If not just joining (as in having been just fragged and respawned), look for spawn point named CONSTNAME(team_CTF_redspawn) or CONSTNAME(team_CTF_bluespawn).*])
    LI([*Look through each spawn point of the appropriate name:*])
    LI([*If the spot would cause a telefrag, choose next spawn point.  Otherwise record the location in array VARNAME(spots[]).*])
    LI([*If a telefrag-less spot doesn't exist, just use first spawn point.  Otherwise, choose a random spawn point from VARNAME(spots[]).*])
    LI([*Return the spawn point information.*])
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*If there is no team spawn point, choose a single-player (CONSTNAME(info_player_deathmatch)) spawnpoint -- FUNCNAME(SelectSpawnPoint()).*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Otherwise choose spawn point single-player style:
   LIST_ORDERED([*
   LI([*If spawned for the first time, choose a QUOT(good-looking) spot -- FUNCNAME(SelectInitialSpawnPoint()).
    LIST_ORDERED([*
    LI([*Look for a spawn point (CONSTNAME(info_player_deathmatch)) with the VARNAME(initial) flag set (0x01).*])
    LI([*If no such special spawn point exists, or if the initial spawn point would cause telefrag, choose spawn point the normal way with FUNCNAME(SelectSpawnPoint()).*])
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*If not spawned for first time, select a spawn point far from death point -- FUNCNAME(SelectSpawnPoint()).
    LIST_ORDERED([*
    LI([*Just calls FUNCNAME(SelectRandomFurthestSpawnPoint()).
     LIST_ORDERED([*
     LI([*Look through all CONSTNAME(info_player_deathmatch) entities:
      LIST_ORDERED([*
      LI([*Check if telefrag would occur, choose another spot if so -- FUNCNAME(SpotWouldTelefrag()).
       LIST_ORDERED([*
       LI([*Check if any players occupy some of the space the would-be-spawned player would occupy.*])
       *])dnl LIST_ORDERED
       *])dnl LI
      LI([*Record distance of this spawn point from the avoidPoint (i.e. where player's death occurred) into list_dist and list_spot using [reverse] insertion sort.*])
      LI([*If no spawn point can avoid telefrag, choose first spawn point (CONSTNAME(info_player_deathmatch)).*])
      LI([*Now that list_dist and list_spot are sorted in decreasing order of distances (furthest first), choose a random spot from the first half of the list.*])
      LI([*Return selected spawn point location.*])
      *])dnl LIST_ORDERED
      *])dnl LI
     *])dnl LIST_ORDERED
     *])dnl LI
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*Juggle spawn point according to CONSTNAME(nobot) or CONSTNAME(nohuman) flags for spawn points.*])
   LI([*Initialize various client flags, fields, and records.*])
   LI([*Provide client with gauntlet and machine gun, with some ammo.*])
   LI([*Set spawn-time health.*])
   LI([*Move client position to spawn point -- FUNCNAME(G_SetOrigin()).*])
   LI([*Set client view angle -- FUNCNAME(SetClientViewAngle()).
    LIST_ORDERED([*
    LI([*Sets angle vectors based on spawn point variables (XXX: which one?).*])
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*Telefrag as needed -- FUNCNAME(G_KillBox()).*])
   LI([*Link client into game -- FUNCNAME(trap_LinkEntity()).*])
   LI([*Bring up the base weapon, the machine gun.*])
   LI([*Prevent full-tilt running at spawn time.*])
   LI([*Reset inactivity timer.*])
   LI([*Set initial animation.*])
   LI([*If on intermission, do intermission stuff -- FUNCNAME(MoveClientToIntermission()).
    LIST_ORDERED([*
    LI([*If spectator, stop following -- FUNCNAME(StopFollowing()).
     LIST_ORDERED([*
     LI([*Clears spectator-following fields.*])
     *])dnl LIST_ORDERED
     *])dnl LI
    LI([*Move to intermission location (set by spawn variable CONSTNAME(info_player_intermission)).*])
    LI([*Set movement type to CONSTNAME(PM_INTERMISSION).*])
    LI([*Clear powerups, attributes, flags, sounds, events, etc.*])
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*Otherwise, trip triggers at spawn point, then select highest player weapon available (which may not be machine gun) -- FUNCNAME(G_UseTargets()).*])
   LI([*Drop player to the floor by gravity -- FUNCNAME(ClientThink()).  No loop as QUOT(needs to respawn) has been cleared by now.*])
   *])dnl LIST_ORDERED
   *])dnl LI
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Add teleportation effect at spawn point -- FUNCNAME(G_TempEntity()).*])
 LI([*Link client into game (again, just to be sure).*])
 LI([*Run end-of-frame stuff -- ClientEndFrame.*])
 LI([*Entity state stuff -- FUNCNAME(BG_PlayerStateToEntityState()).*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Run once-per-second client actions -- FUNCNAME(ClientTimerActions()).
 LIST_ORDERED([*
 LI([*Check if one-second period has passed.*])
 LI([*Increase health due to regeneration powerup, rate is influenced by any excessive health.*])
 LI([*Tick down excessive health (health greater than VARNAME(maxHealth)) if no regeneration powerup.*])
 LI([*Tick down excessive armor (armor greater than VARNAME(maxArmor)).*])
 LI([*Tick up ammo due to ammo-regen powerup (Team Arena only).*])
 *])dnl LIST_ORDERED
 *])dnl LI
*])dnl LIST_ORDERED
*])dnl _P

SECT2(FireWeapon,[*FireWeapon(*entity)*])
_P([*
LIST_ORDERED([*
LI([*Check for quad damage powerup.*])
LI([*Accumulate accuracy statistics.*])
LI([*Determine firing direction.*])
LI([*Fire according to weapon in use:
 LIST_UNORDERED([*
 LI([*gauntlet -- FUNCNAME(Weapon_Gauntlet())
  LIST_ORDERED([*
  LI([*(Non-operation.  Nothing.  Nada.  Zilch.)*])
  LI([*(Checking for gauntlet hit is done in FUNCNAME(CheckGauntletHit())).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*lightning gun -- FUNCNAME(Weapon_LightningFire())
  LIST_ORDERED([*
  LI([*Check for anything in front for 768 units (CONSTNAME(LIGHTNING_RANGE))*])
  LI([*Bounce off any invulerability spheres (Team Arena only)*])
  LI([*Apply damage to victim.*])
  LI([*Cause visual and audio effects.*])
  LI([*Record accuracy stats.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*shotgun -- FUNCNAME(weapon_supershotgun_fire())
  LIST_ORDERED([*
  LI([*Seed RNG for shotgun pattern.*])
  LI([*Fire shotgun pellets -- FUNCNAME(ShotgunPattern()).
   LIST_ORDERED([*
   LI([*For 11 (CONSTNAME(DEFAULT_SHOTGUN_COUNT)) pellets:
    LIST_ORDERED([*
    LI([*Fudge local up and right by random positive or negative values.*])
    LI([*Check for damage dealt by pellet.*])
    LI([*Record accuracy stats.*])
    *])dnl LIST_ORDERED
    *])dnl LI
   *])dnl LIST_ORDERED
   *])dnl LI
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*machine gun -- FUNCNAME(Bullet_Fire())
  LIST_ORDERED([*
  LI([*Fudge the aim direction by a bit (for random spread).*])
  LI([*Search along fudged direction for a victim (or wall).*])
  LI([*Bounce off invulnerability spheres (Team Arena only).*])
  LI([*Cause bullet-hit effect.*])
  LI([*Deal damage -- FUNCNAME(G_Damage()).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*grenade launcher -- FUNCNAME(weapon_grenadelauncher_fire())
  LIST_ORDERED([*
  LI([*Fudge the aim direction upwards a little bit for loft.*])
  LI([*Create and launch a grenade -- FUNCNAME(fire_grenade())
   LIST_ORDERED([*
   LI([*Allocate a game entity -- FUNCNAME(G_Spawn()).*])
   LI([*Set fields for a grenade entity.*])
   LI([*Snap velocity vectors (components rounded to integers).*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Increase grenade damage by any quad damage.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*rocket launcher -- FUNCNAME(Weapon_RocketLauncher_fire())
  LIST_ORDERED([*
  LI([*Create and launch a rocket -- FUNCNAME(fire_rocket())
   LIST_ORDERED([*
   LI([*Allocate a game entity -- FUNCNAME(G_Spawn()).*])
   LI([*Set fields for a rocket entity.*])
   LI([*Snap velocity vectors (components rounded to integers).*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Increase rocket damage by any quad damage.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*plasma gun -- FUNCNAME(Weapon_PlasmaGun_Fire())
  LIST_ORDERED([*
  LI([*Create and launch a plasma round -- FUNCNAME(fire_plasma())
   LIST_ORDERED([*
   LI([*Allocate a game entity -- FUNCNAME(G_Spawn()).*])
   LI([*Set fields for a plasma entity.*])
   LI([*Snap velocity vectors (components rounded to integers).*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Increase plasma damage by any quad damage.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*railgun -- FUNCNAME(weapon_railgun_fire())
  LIST_ORDERED([*
  LI([*Railgun range is 8192 units.*])
  LI([*Bounce off invulnerability (Team Arena only).*])
  LI([*Record accuracy stats.*])
  LI([*Damage up to 4 (CONSTNAME(MAX_RAIL_HITS)) players, passing through three.*])
  LI([*Rail slug stops at walls or other impenetrable obstacles.*])
  LI([*Create rail beam/trail effect.*])
  LI([*Fudge locations a bit for visual effect (so rail appears to start from gun location)*])
  LI([*Check for QUOT(Impressive) (two consecutive railgun hits without a miss) reward.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*BFG10K -- FUNCNAME(BFG_Fire())
  LIST_ORDERED([*
  LI([*Create and launch a BFG round -- FUNCNAME(fire_bfg())
   LIST_ORDERED([*
   LI([*Allocate a game entity -- FUNCNAME(G_Spawn()).*])
   LI([*Set fields for a BFG entity.*])
   LI([*Snap velocity vectors (components rounded to integers).*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Increase BFG damage by any quad damage.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*grappling hook -- FUNCNAME(Weapon_GrapplingHook_Fire())*])
 LI([*nailgun (Team Arena only) -- FUNCNAME(Weapon_Nailgun_Fire())*])
 LI([*proximity mine launcher (Team Arena only) -- FUNCNAME(weapon_proxlauncher_fire())*])
 LI([*chaingun (Team Arena only) -- FUNCNAME(Bullet_Fire())*])
 *])dnl LIST_UNORDERED
 *])dnl LI
*])dnl LIST_ORDERED
*])dnl _P

_P([*
TODO: FUNCNAME(Pmove())
*])


SECT1(vmMain.GAME_CLIENT_USERINFO_CHANGED,[*vmMain(GAME_CLIENT_USERINFO_CHANGED, clientNum)*])
_P([*
When a client user's info has changed (name, player model, handicap, etc.), the Q3 server is notified and reacts with a call to FUNCNAME(vmMain()) with major function CONSTNAME(GAME_CLIENT_USERINFO_CHANGED), with one argument:
LIST_ORDERED([*
LI([*VARNAME(clientNum) - the client number of the client that changed its info.*])
*])dnl LIST_ORDERED
*])dnl _P
_P([*
Immediate branch to FUNCNAME(ClientUserinfoChanged()).
*])

SECT2(ClientUserinfoChanged,[*ClientUserinfoChanged(clientNum)*])
_P([*
LIST_ORDERED([*
LI([*Note client number and client object/entity.*])
LI([*Retrieve client userinfo -- FUNCNAME(trap_GetUserinfo()).*])
LI([*Check for invalid string -- FUNCNAME(Info_Validate()).
 LIST_ORDERED([*
 LI([**])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Check if local client (key VARNAME(ip)) -- FUNCNAME(Info_ValueForKey()).
 LIST_ORDERED([*
 LI([**])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Check item prediction (key KEYNAME(cg_predictItems)).*])
LI([*Set name (key KEYNAME(name)).*])
LI([*Announce if in-game name change.*])
LI([*Set max health according to handicap (key KEYNAME(handicap)).*])
LI([*Set player model (keys KEYNAME(model) and KEYNAME(hmodel), or KEYNAME(team_model) and KEYNAME(team_hmodel)).*])
LI([*If a bot, join team a short time later.*])
LI([*Otherwise just set team (or spec).*])
LI([*Set model skin according to team.*])
LI([*Determine if client wants teamoverlay info (key KEYNAME(teamoverlay)).*])
LI([*Set team task (key KEYNAME(teamtask)) and leader.*])
LI([*Set colors (keys KEYNAME(color), KEYNAME(g_redteam), KEYNAME(g_blueteam)).*])
LI([*Construct a ENT_CS from a subset of userinfo, to broadcast to all clients.*])
*])dnl LIST_ORDERED
*])dnl _P


SECT1(vmMain.GAME_CLIENT_DISCONNECT,[*vmMain(GAME_CLIENT_DISCONNECT, clientNum)*])
_P([*
When client disconnects (voluntary COMMAND(disconnect), kicked, dropped, etc.).
Arguments:

LIST_ORDERED([*
LI([*VARNAME(clientNum) - the client number of the client just disconnected.*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
Immediate branch to FUNCNAME(ClientDisconnect()).
*])

SECT2(ClientDisconnect,[*ClientDisconnect(clientNum)*])
_P([*
LIST_ORDERED([*
LI([*Check if kicking a still-unspawned bot -- FUNCNAME(G_RemoveQueuedBotBegin()).
 LIST_ORDERED([*
 LI([**])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*If any spectator is following this client, stop their following -- FUNCNAME(StopFollowing()).*])
LI([*Create teleport-out effect.*])
LI([*Drop any powerups client had -- FUNCNAME(TossClientItems()).
 LIST_ORDERED([*
 LI([**])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*If a tournament game, award remaining player with a win.*])
LI([*Unlink the client -- FUNCNAME(trap_UnlinkEntity()).*])
LI([*Mark ex-client as being disconnected and mark its slot as unused.*])
LI([*Clear associated ENT_CS.*])
LI([*Recalculate ranks -- FUNCNAME(CalculateRanks()).*])
LI([*If a bot AI, shutdown AI -- FUNCNAME(BotAIShutdownClient()).
 LIST_ORDERED([*
 LI([**])
 *])dnl LIST_ORDERED
 *])dnl LI
*])dnl LIST_ORDERED
*])dnl _P


SECT1(vmMain.GAME_CLIENT_BEGIN,[*vmMain(GAME_CLIENT_BEGIN, clientNum)*])
_P([*
When client is ready to play.
This occurs when client has finished connecting and loading, or has switched teams, or has continued in from the previous map.
Does not occur on respawns (why should the Q3 engine know about respawns+teleport?  The game engine does, though).
Arguments:
LIST_ORDERED([*
LI([*VARNAME(clientNum) - client number.*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
Immediate branch to FUNCNAME(ClientBegin()).
*])

SECT2(ClientBegin,[*ClientBegin(clientNum)*])
_P([*
LIST_ORDERED([*
LI([*Note client number and client entity/record.*])
LI([*Unlink client entity -- FUNCNAME(trap_UnlinkEntity()).*])
LI([*Initialize client game entity -- FUNCNAME(G_InitGentity()).
 LIST_ORDERED([*
 LI([*Clear and initialize some critical game entity fields.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Initialize client fields.*])
LI([*Select a spawn point -- FUNCNAME(ClientSpawn()).*])
LI([*Announce the player joining the game, if not tournament mode.*])
LI([*Recalculate ranks -- FUNCNAME(CalculateRanks()).*])
*])dnl LIST_ORDERED
*])dnl _P


SECT1(vmMain.GAME_CLIENT_COMMAND,[*vmMain(GAME_CLIENT_COMMAND, clientNum)*])
_P([*
When client sends a command to the server.
This usually occurs when the client-end doesn't recognize a console command from the user, and so passes off the command to the server in hopes the server understands it.
Arguments:
LIST_ORDERED([*
LI([*VARNAME(clientNum) - client number*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
Immediate branch to FUNCNAME(ClientCommand()).
*])

SECT2(ClientCommand,[*ClientCommand(clientNum)*])
_P([*
LIST_ORDERED([*
LI([*Check client validity.*])
LI([*Retrieve command name from string -- FUNCNAME(trap_Argv()).*])
LI([*Check against known command names:
 LIST_UNORDERED([*
 LI([*COMMAND(say)*])
 LI([*COMMAND(say_team)*])
 LI([*COMMAND(tell)*])
 LI([*COMMAND(vsay)*])
 LI([*COMMAND(vsay_team)*])
 LI([*COMMAND(vtell)*])
 LI([*COMMAND(vosay)*])
 LI([*COMMAND(vosay_team)*])
 LI([*COMMAND(votell)*])
 LI([*COMMAND(vtaunt)*])
 LI([*COMMAND(score)*])
 LI([*_EM([*(At intermission, the following commands are ignored, and instead are transmitted as global chat)*])*])
 LI([*COMMAND(give)*])
 LI([*COMMAND(god)*])
 LI([*COMMAND(notarget)*])
 LI([*COMMAND(noclip)*])
 LI([*COMMAND(kill)*])
 LI([*COMMAND(teamtask)*])
 LI([*COMMAND(levelshot)*])
 LI([*COMMAND(follow)*])
 LI([*COMMAND(follownext)*])
 LI([*COMMAND(followprev)*])
 LI([*COMMAND(team)*])
 LI([*COMMAND(where)*])
 LI([*COMMAND(callvote)*])
 LI([*COMMAND(vote)*])
 LI([*COMMAND(callteamvote)*])
 LI([*COMMAND(teamvote)*])
 LI([*COMMAND(gc)*])
 LI([*COMMAND(setviewpos)*])
 LI([*COMMAND(stats)*])
 *])dnl LIST_UNORDERED
 *])dnl LIST
LI([*Unrecognized commands return an error message to the originating client.*])
*])dnl LIST_ORDERED
*])

SECT1(vmMain.GAME_RUN_FRAME,[*vmMain(GAME_RUN_FRAME, levelTime)*])
_P([*
Called by Q3 each server frame (period determined by cvar CVARNAME(sv_fps), default value of 20 fps (or 50 ms/frame)) to advance all non-player objects.
Arguments:
LIST_ORDERED([*
LI([*VARNAME(levelTime) - the elapsed time on the level as reported by Q3 engine (this is where VARNAME(level.time) comes from!).*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
Immediate branch to FUNCNAME(G_RunFrame()).
*])

SECT2(G_RunFrame,[*G_RunFrame(levelTime)*])
_P([*
LIST_ORDERED([*
LI([*Check if waiting for level to restart.*])
LI([*Remember previous levelTime.*])
LI([*Store current levelTime.*])
LI([*Calculate the time difference.*])
LI([*Update all cvar changes -- FUNCNAME(G_UpdateCvars()).*])
LI([*Record the current timestamp (not levelTime) -- FUNCNAME(trap_Milliseconds()).*])
LI([*For all allocated game entities:
 LIST_ORDERED([*
 LI([*Ignore unused entity.*])
 LI([*Clear out old events.*])
 LI([*Free entity slot if no longer needed -- FUNCNAME(G_FreeEntity()).*])
 LI([*Unlink entity if needed -- FUNCNAME(trap_UnlinkEntity()).*])
 LI([*Ignore temporary entity (they don't think).*])
 LI([*Ignore unlinked entity.*])
 LI([*If a missile type, run missile think -- FUNCNAME(G_RunMissile()).
  LIST_ORDERED([*
  LI([*Find missile's current position -- FUNCNAME(BG_EvaluateTrajectory()).*])
  LI([*Do checks for what the missile will or will not pass through.*])
  LI([*See if missile passed through anything noteworthy -- FUNCNAME(trap_Trace()).*])
  LI([*Check if missile is stuck in anything, otherwise just keep moving forward.*])
  LI([*Link missile into the game (XXX: when was it unlinked?) -- FUNCNAME(trap_LinkEntity()).*])
  LI([*If missile collided with something:
   LIST_ORDERED([*
   LI([*Just free up the entity if hit a CONSTNAME(SURF_NOIMPACT) surface (such as sky or a black hole).*])
   LI([*Otherwise do missile impact stuff -- FUNCNAME(G_MissileImpact()).
    LIST_ORDERED([*
    LI([*Check for bouncing -- FUNCNAME(G_BounceMissile())
     LIST_ORDERED([*
     LI([*(vector math for ricochet/bounce effect)*])
     *])dnl LIST_ORDERED
     *])dnl LI
    LI([*Deal impact damage, if applicable.*])
    LI([*Stick proximity mine to victim (Team Arena only)*])
    LI([*Latch grappling hook and start pulling, if applicable.*])
    LI([*Create any explosion effect -- FUNCNAME(G_AddEvent()).*])
    LI([*Snap vectors.*])
    LI([*Deal any splash damage -- FUNCNAME(G_RadiusDamage()).
     LIST_ORDERED([*
     LI([*Sanity check on damage radius, create a damage bounding box.*])
     LI([*Find entities within damage bounding box and save to array VARNAME(entityList[)] -- FUNCNAME(trap_EntitiesInBox()).*])
     LI([*For all the entities in VARNAME(entityList[]):
      LIST_ORDERED([*
      LI([*Ignore if entity marked for ignore.*])
      LI([*Ignore if entity cannot be damaged.*])
      LI([*See if entity is actually within damage radius.*])
      LI([*Get distance from explosion center to entity center.*])
      LI([*Calculate damage based on this distance.*])
      LI([*Deal damage and knockback, while recording accuracy stats.*])
      *])dnl LIST_ORDERED
      *])dnl LI
     *])dnl LIST_ORDERED
     *])dnl LI
    LI([*Link missile into the world (XXX: again?) -- FUNCNAME(trap_LinkEntity()).*])
    *])dnl LIST_ORDERED
    *])dnl LI
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*If missile hasn't exploded yet, run its think function -- FUNCNAME(G_RunThink()).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*If an item type that's bouncing, run item think -- FUNCNAME(G_RunItem()).
  LIST_ORDERED([*
  LI([*Check if item is in free fall.*])
  LI([*Check if item has CONSTNAME(stationary) trajectory, if so then just run FUNCNAME(G_RunThink()) and return.*])
  LI([*Get current position of item.*])
  LI([*See if it hit/landed on anything.*])
  LI([*Run think function -- FUNCNAME(G_RunThink()).*])
  LI([*If in a CONSTNAME(nodrop) brush, remove entity from game.*])
  LI([*Cause item to bounce -- FUNCNAME(G_BounceItem()).
   LIST_ORDERED([*
   LI([*(lots of vector math)*])
   *])dnl LIST_ORDERED
   *])dnl LI
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*If a mover, run mover think -- FUNCNAME(G_RunMover()).
  LIST_ORDERED([*
  LI([*Check if a team slave, return if so (team captain handles all activities).*])
  LI([*If not stationary, run mover -- FUNCNAME(G_MoverTeam()).
   LIST_ORDERED([*
   LI([*Make sure all team members (other movers in a chain) are able to move -- FUNCNAME(G_MoverPush()).
    LIST_ORDERED([*
    LI([*Establish boundaries of mover and entire movement area covered.*])
    LI([*Unlink mover temporarily -- FUNCNAME(trap_UnlinkEntity()).*])
    LI([*Find entities within mover's movement area and store into list VARNAME(listedEntities[]) -- FUNCNAME(trap_EntitiesInBox()).*])
    LI([*Move pusher to final position.*])
    LI([*Link mover back into the game -- FUNCNAME(trap_LinkEntity()).*])
    LI([*For each entity in VARNAME(listedEntities[]):
     LIST_ORDERED([*
     LI([*Try pushing proxmine (Team Arena only).*])
     LI([*Ignore entity if not an item nor a player.*])
     LI([*Move entities standing on mover, and ensure it doesn't try to occupy the same space as the mover -- FUNCNAME(G_TestEntityPosition()).
      LIST_ORDERED([*
      LI([**])
      *])dnl LIST_ORDERED
      *])dnl LI
     LI([*Push entity -- FUNCNAME(G_TryPushingEntity()).
      LIST_ORDERED([*
      LI([**])
      *])dnl LIST_ORDERED
      *])dnl LI
     LI([*Any entites that bob (such as items) get killed if stuck inside a mover position (such as between doors), move on to next pushed object.*])
     LI([*Otherwise move entities back, since this is an obstacle.*])
     *])dnl LIST_ORDERED
     *])dnl LI
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*Restore old position(s) if any mover member can't move.*])
   LI([*Run FUNCNAME(blocked()) function for any mover member that couldn't move -- FUNCNAME(part-ENT_gt()blocked()).*])
   LI([*Otherwise calculate and set new positions.*])
   LI([*If a mover member reachd one end of its movement, call its FUNCNAME(reached()) function -- FUNCNAME(part-ENT_gt()reached());.*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Run entity-specific think function -- FUNCNAME(G_RunThunk()).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*If a client, run client think -- FUNCNAME(G_RunClient()).
  LIST_ORDERED([*
  LI([*Check if a bot AI, return if so.*])
  LI([*Record VARNAME(levelTime)*])
  LI([*Call FUNCNAME(ClientThink_real()).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Otherwise, just run think -- FUNCNAME(G_RunThink()).
  LIST_ORDERED([*
  LI([*Check if there is any thinktime.*])
  LI([*Check if VARNAME(levelTime) exceeded thinktime, return if not.*])
  LI([*Disable nextthink and run entity's think -- FUNCNAME(ent-ENT_gt()think()).*])
  *])dnl LIST_ORDERED
  *])dnl LI
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Record current timestamp -- FUNCNAME(trap_Milliseconds()).*])
LI([*(Time elapsed during run cycle can be calculated (but isn't)).*])
LI([*Do final fixups on players -- FUNCNAME(ClientEndFrame()).*])
LI([*Check for tournament restart -- FUNCNAME(CheckTournament()).
 LIST_ORDERED([*
 LI([**])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Check for end of level -- FUNCNAME(CheckExitRules()).
 LIST_ORDERED([*
 LI([*If still intermission time, check that all non-bot clients are CONSTNAME(READY) to leave intermission, return if not ready to exit level/map -- FUNCNAME(CheckIntermissionExit()).*])
 LI([*Check for queued intermission (???)
  LIST_ORDERED([*
  LI([*Ignore if queue time not yet exceeded.*])
  LI([*Unqueue intermission.*])
  LI([*Begin intermission -- FUNCNAME(BeginIntermission()).
   LIST_ORDERED([*
   LI([*Return if intermission already in progress. *])
   LI([*For tournament mode, adjust tournament scores -- FUNCNAME(AdjustTournamentScores()).
    LIST_ORDERED([*
    LI([*Update number of wins or losses for the two competitors.*])
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*Record the current VARNAME(levelTime) as the intermission time.*])
   LI([*Find the intermission location -- FUNCNAME(FindIntermissionPoint()).*])
   LI([*If single-player game:
    LIST_ORDERED([*
    LI([*Update tournament information -- FUNCNAME(UpdateTournamentInfo())
     LIST_ORDERED([*
     LI([*Take note of (the only) player's record/slot/entity.*])
     LI([*Calculate ranks -- FUNCNAME(CalculateRanks()).*])
     LI([*Record postgame data?*])
     LI([*Calculate accuracy percentage.*])
     LI([*Check for QUOT(Perfect) reward.*])
     LI([*Record rewards information.*])
     *])dnl LIST_ORDERED
     *])dnl LI
    LI([*show the victory podium -- FUNCNAME(SpawnModelsOnVictoryPads())
     LIST_ORDERED([*
     LI([*Spawn the podium -- FUNCNAME(SpawnPodium()).
      LIST_ORDERED([*
      LI([*Create podium entity.*])
      LI([*Place podium in front of intermission view.*])
      *])dnl LIST_ORDERED
      *])dnl LI
     LI([*Place the top three players in their appropriate places -- FUNCNAME(SpawnModelOnVictoryPad()).
      LIST_ORDERED([*
      LI([*Copy entity properties of the player into a new game entity.*])
      LI([*Set entity location relative to podium and intermission viewpoint.*])
      *])dnl LIST_ORDERED
      *])dnl LI
     *])dnl LIST_ORDERED
     *])dnl LI
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*Move all clients to intermission point -- FUNCNAME(MoveClientToIntermission())*])
   LI([*Send current scores to all clients -- FUNCNAME(SendScoreboardMessageToAllClients()).
    LIST_ORDERED([*
    LI([*For each client:
     LIST_ORDERED([*
     LI([*Send scoreboard info -- FUNCNAME(DeathmatchScoreboardMessage())
      LIST_ORDERED([*
      LI([*For all clients:
       LIST_ORDERED([*
       LI([*Construct string based on client number, frags, ping time, play time, score flags, powerups, rewards, and captures.*])
       *])dnl LIST_ORDERED
       *])dnl LI
      LI([*Send this huge-ass string, along with blue team score and red team score, to client -- FUNCNAME(SendServerCommand()).*])
      *])dnl LIST_ORDERED
      *])dnl LI
     *])dnl LIST_ORDERED
     *])dnl LI
    *])dnl LIST_ORDERED
    *])dnl LI
   *])dnl LIST_ORDERED
   *])dnl LI
  *])dnl LIST_ORDERED
  *])dnl LI
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Update team status -- FUNCNAME(CheckTeamStatus()).
 LIST_ORDERED([*
 LI([*Check if time to do team location update.*])
 LI([*For all clients:
  LIST_ORDERED([*
  LI([*Ignore clients still connecting.*])
  LI([*Determine team.*])
  LI([*Store team location information into client record.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*For all clients (again):
  LIST_ORDERED([*
  LI([*Ignore clients still connecting.*])
  LI([*Determine team.*])
  LI([*Transmit team location information to client -- FUNCNAME(TeamplayInfoMessage()).
   LIST_ORDERED([*
   LI([*Return if client has no (doesn't want?) teaminfo.*])
   LI([*Extract top eight teammates on player's team.*])
   LI([*Sort the eight teammates by client number.*])
   LI([*For all clients or the first 32 (CONSTNAME(TEAM_MAXOVERLAY)) (whichever is less):
    LIST_ORDERED([*
    LI([*Ignore if this client is not in use, or is not on the same team.*])
    LI([*Store client's health and armor.*])
    LI([*Construct a string based on the client's list location (cycle in this particular loop), location, health, armor, current weapon, and active powerup.*])
    LI([*Truncate constructed string if too long (8192 bytes).*])
    *])dnl LIST_ORDERED
    *])dnl LI
   LI([*Transmit the constructed string to the client -- FUNCNAME(trap_SendServerCommand()).*])
   *])dnl LIST_ORDERED
   *])dnl LI
  *])dnl LIST_ORDERED
  *])dnl LI
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Check global votes -- FUNCNAME(CheckVote()).
 LIST_ORDERED([*
 LI([*If vote string is to be executed and it's time to execute, execute the string as a command -- FUNCNAME(trap_SendConsoleCommand()).*])
 LI([*Return if no vote in progress.*])
 LI([*Check if vote time expired, report vote having failed if so.*])
 LI([*Otherwise check for votes:
  LIST_ORDERED([*
  LI([*If Yes has simple majority, report success and execute vote string within 3 seconds.*])
  LI([*If No has simple majority, report failure.*])
  LI([*Otherwise keep waiting for a majority one way or another.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Update ENT_CS CSNAME(CS_VOTE_TIME) accordingly.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Check team votes -- FUNCNAME(CheckTeamVote()).
 LIST_ORDERED([*
 LI([*Determine which team to check (blue or red).*])
 LI([*Return if no vote is in progress.*])
 LI([*If voting time limit is exceeded, report failure to... everyone(!).*])
 LI([*Otherwise:
  LIST_ORDERED([*
  LI([*Check if Yes votes has simple majority.
   LIST_ORDERED([*
   LI([*If the vote was to change leader, set new team leader -- FUNCNAME(SetLeader()).*])
   LI([*Otherwise execute vote string as a command -- FUNCNAME(trap_SendConsoleCommand()).*])
   *])dnl LIST_ORDERED
   *])dnl LI
  LI([*Check if No votes has simple majority; cause vote to fail if so.*])
  LI([*Otherwise keep waiting for a majority vote.*])
  *])dnl LIST_ORDERED
  *])dnl LI
 LI([*Set CS_TEAMVOTE_TIME (+1 for blue) accordingly.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Check on changes in cvars -- FUNCNAME(CheckCvars()).
 LIST_ORDERED([*
 LI([*Do nothing (return) if cvar CVARNAME(g_password) has not changed.*])
 LI([*If cvar CVARNAME(g_password) is set, and is not QUOT(none), set CVARNAME(g_needpass) to 1.*])
 LI([*Otherwise, set cvar CVARNAME(g_needpass) to 0.*])
 *])dnl LIST_ORDERED
 *])dnl LI
LI([*Dump entities list if cvar CVARNAME(g_listEntity) is non-zero.*])
*])dnl LIST_ORDERED
*])dnl _P


SECT1(vmMain.GAME_CONSOLE_COMMAND,[*vmMain(GAME_CONSOLE_COMMAND)*])
_P([*
When a console command is entered directly to the server from the server console (admin commands).
No arguments.
Immediate branch to FUNCNAME(ConsoleCommand()).
*])

SECT2(ConsoleCommand,[*ConsoleCommand()*])
_P([*
LIST_ORDERED([*
LI([*Retrieve command name -- FUNCNAME(trap_Argv()).*])
LI([*Check command:
 LIST_ORDERED([*
 LI([*COMMAND(entitylist)*])
 LI([*COMMAND(forceteam)*])
 LI([*COMMAND(game_memory)*])
 LI([*COMMAND(addbot)*])
 LI([*COMMAND(botlist)*])
 LI([*COMMAND(abort_podium)*])
 LI([*COMMAND(addip)*])
 LI([*COMMAND(removeip)*])
 LI([*COMMAND(listip)*])
 *])dnl LIST_UNORDERED
 *])dnl LI
LI([*If command is not found and server is running in dedicated mode (cvar CVARNAME(dedicated) is 1 or 2), repeat the command line as global chat text from console.*])
*])dnl LIST_ORDERED
*])dnl _P


<!--
SECT1(vmMain.GAME_FOO,[*vmMain(GAME_FOO, ...)*])
_P([*
When Q3 wants to ... Q3 calls vmMain with major function CONSTNAME(GAME_FOO), and ... arguments:
LIST_ORDERED([*
LI([*...*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
In FUNCNAME(vmMain()), the code immediately branches to ... when vmMain recognizes CONSTNAME(GAME_FOO)
*])

SECT1(G_Foo,[*G_Foo(...)*])
_P([*
...
*])
-->

HORIZRULEz
_P([*
Created 2002.08.26 _LF()
Updated 2002.09.16 - re-wordings suggested by members of ENT_q3w_mpf(). _LF()
Updated 2003.11.10 - corrections sent in by cyrri. _LF()
Updated 2011.07.11 - change of contact e-mail. _LF()
ADDRESS([*
ENT_authornick
ENT_angbra ENT_authormail ENT_angket
*])dnl ADDRESS
*])dnl _P

</BODY>
</HTML>
