<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
changequote([*,*])dnl
changecom([*<!--*],[*-->*])dnl
define(ENT_title,[*[*BASEQ3 Runthrough, Client-side*]*])dnl
define(TITLE,<h1>$1</h1>)dnl
define(SYNOPSIS,<h2>Synopsis</h2><p>$1</p>)dnl
define(XXX,[*<b class="xxx">[*XXX*]</b>*])dnl
define(ENT_q3w_mpf,<a href="http://www.quake3world.com/cgi-bin/forumdisplay.cgi?action=topics&amp;forum=Modifications+Programming&amp;number=4">Quake 3 World Modifications Programming Forum (MPF)</a>)dnl
define(ENT_mod,game module)dnl
define(ENT_cgame,cgame module)dnl
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
define(CSNAME,ConfigString CS_[**]_ELEM(span,configstring,[*$1*]))dnl
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
define(DICT,[*DT(<a name="_SN().$1">[*$1*]</a>)DD([*$2*])*])dnl
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

SYNOPSIS([*Illustration of an execution path through a Q3 cgame module (baseq3), from startup through gameplay though shutdown, for client-side mode, in outline form.*])

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
Information was gleaned by poring through the cgame source text, with minimal testing.
Most of the statements made in this document are based on source comments and QUOT(gut feelings).
*])
*])dnl _INDENT

<!-- template ripped from outline1  :) -->

SECT(engineStart,Engine Start)
_P([*
*])dnl _P

SECT(vmMain,vmMain)
_P([*
See outline1.html regarding FUNCNAME(vmMain()).
Many descriptions of game's FUNCNAME(vmMain()) also applies to ENT_cgame.
*])


SECT1(vmMain.overview, Overview: vmMain command/major cgame function)
_P([*
A quick overview of the vmMain commands (major cgame functions) in baseq3:
LIST_DICT([*
DICT(CG_INIT,[*
When cgame starts (on a new map, level, connect, reconnect, etc.).
*])
DICT(CG_SHUTDOWN,[*
Upon cgame shutdown (disconnecting, kicked, crash).
*])
DICT(CG_CONSOLE_COMMAND,[*
A console command that the engine does not recognize.
*])
DICT(CG_DRAW_ACTIVE_FRAME,[*
To draw stuff on the screen.
*])
DICT(CG_CROSSHAIR_PLAYER,[*
XXX: ???
*])
DICT(CG_LAST_ATTACKER,[*
XXX: ???
*])
DICT(CG_KEY_EVENT,[*
When key-trapping is enabled, on a key event (press or release).
*])
DICT(CG_MOUSE_EVENT,[*
When mouse-trapping is enabled, on a mouse event (movement, button press/release).
*])
DICT(CG_EVENT_HANDLING,[*
XXX: ???
*])
*])dnl LIST_DICT
*])dnl _P

_P([*
The Q3 engine marshalls the necessary cgame function values and arguments, then makes the call to FUNCNAME(vmMain()).
Any additions or changes to these major cgame functions must be implemented in the engine and reflected in the ENT_cgame (client-side mod).
Only developers with access to the Q3 engine (not just mod) source may make such aditions or changes.
Currently (2002 Aug) this consists of Id Software itself and its direct licensees (proprietary license).
*])

SECT1(CGAME_INIT,[*vmMain(CGAME_INIT, VARNAME(serverMessageNum), VARNAME(serverCommandSequence), VARNAME(clientNum))*])
_P([*
Called when ENT_cgame is initialized, upon connecting to a server (single-player game is a special case of a local server).
The cgame is reloaded and reinitialized every time a new map is loaded.
Three arguments:
LIST_DICT([*
DICT(serverMessageNum,[*
XXX: ???
*])
DICT(serverCommandSequence,[*
XXX: ???
*])
DICT(clientNum,[*
The cgame's client number as assigned by the server.
*])
*])dnl LIST_DICT
*])dnl _P

_P([*
In baseq3, immediate branch to FUNCNAME(CG_Init()).
*])

SECT2(CG_Init,CG_Init(serverMesssageNum, serverCommandSequence, clientNum))
_P([*
LIST_ORDERED([*
LI([*Zero out (clear) the structures VARNAME(cgs), VARNAME(cg), VARNAME(cg_entities), VARNAME(cg_weapons), VARNAME(cg_items)*])
LI([*Record VARNAME(clientNum) to VARNAME(cg.clientNum)*])
LI([*Record VARNAME(serverMessageNum) to VARNAME(cgs.processedSnapshotNum)*])
LI([*Record VARNAME(serverCommandSequence) to VARNAME(cgs.serverCommandSequence)*])
LI([*Load some fonts and the plain-white shader*])
LI([*Register some cvars -- FUNCNAME(CG_RegisterCvars()).
 LIST_ORDERED([*
 LI([*For all elements of VARNAME(cvarTable[]), register the location of the TYPENAME(vmCvar_t) instance, the cvar name, the default value, and the cvar flags -- FUNCNAME(trap_Cvar_Register())*])
 LI([*If also running a local server (non-dedicated host, single-player), record the fact into VARNAME(cgs.localServer)*])
 LI([*Register cvar CVARNAME(modeL), CVARNAME(headmodel), CVARNAME(team_model), CVARNAME(team_headmodel)*])
 *])*])dnl LIST_ORDERED, LI
LI([*Initialize cgame console commands -- FUNCNAME(CG_InitConsoleCommands()).
 LIST_ORDERED([*
 LI([*For all elements of VARNAME(commands[]), register the command string/name with the Q3 client engine for tab-completion -- trap_AddCommand()*])
 LI([*Register a set of commands that can be tab-completed, but are interpreted on the server-side (e.g. COMMAND(kill) or COMMAND(say))*])
 *])*])dnl LIST_ORDERED, LI
LI([*Switch/set weapon to machine gun*])
LI([*CTF flags hackage for old-server compatibility (wtf?)*])
LI([*Retrieve rendering configuration into VARNAME(cgs.glconfig) -- FUNCNAME(trap_GetGlconfig())*])
LI([*Set screen scale factors from VARNAME(cgs.glconfig): VARNAME(cgs.screenXScale), VARNAME(cgs.screenYScale)*])
LI([*Retrieve gamestate from client system into VARNAME(cgs.gameState) -- FUNCNAME(trap_GetGameState())*])
LI([*Get game (mod) version and compare -- FUNCNAME(CG_ConfigString(CS_GAME_VERSIOn))*])
LI([*Retrieve level start time into cgs.levelStartTime -- FUNCNAME(CG_ConfigString(CS_LEVEL_START_TIME))*])
LI([*Parse server info -- FUNCNAME(CG_ParseServerinfo()).
 LIST_ORDERED([*
 LI([*Retrieve CSNAME(SERVERINFO) into VARNAME(info) -- FUNCNAME(CG_ConfigString(CS_SERVERINFO))*])
 LI([*Retrieve values for keys KEYNAME(g_gametype), KEYNAME(dmflags), KEYNAME(teamflags), KEYNAME(fraglimit), KEYNAME(capturelimit), KEYNAME(timelimit), KEYNAME(sv_maxclients), KEYNAME(mapname), KEYNAME(g_redTeam), KEYNAME(g_blueTeam)*])
 *])*])dnl LIST_ORDERED, LI
LI([*Indicate cgame is loading the map -- FUNCNAME(CG_LoadingString()).
 LIST_ORDERED([*
 LI([*Copy the message string to VARNAME(cg.infoScreenText)*])
 LI([*update screen -- FUNCNAME(trap_UpdateScreen())*])
 *])*])dnl LIST_ORDERED, LI
LI([*Load map collision (and models?) -- FUNCNAME(trap_CM_LoadMap())*])
LI([*Load sounds -- FUNCNAME(CG_RegisterSounds())
 LIST_ORDERED([*
 LI([*Register a whole gank of sound files with FUNCNAME(trap_S_RegisterSound()) and store the returned handle into various VARNAME(cgs.media.*) fields*])
 *])*])dnl LIST_ORDERED, LI
LI([*Load graphics -- FUNCNAME(CG_RegisterGraphics())
 LIST_ORDERED([*
 LI([*Clear references to any old media*])
 LI([*Display the mapname as the loading string*])
 LI([*Load map (models and textures?) -- FUNCNAME(trap_R_LoadWorldMap())*])
 LI([*Display QUOT(game media) as loading string*])
 LI([*Register numerals font faces*])
 LI([*Register a whole gank of media files, saving the returned handles into various VARNAME(cgs.media.*) fields: FUNCNAME(trap_R_RegisterShader()), FUNCNAME(trap_R_RegisterShaderNoMip()), FUNCNAME(trap_R_RegisterModel()), FUNCNAME(trap_R_RegisterSkin())*])
 LI([*Register inline models*])
 LI([*Register server-specified models*])
 LI([*Clear particles -- FUNCNAME(CG_ClearParticles())
  LIST_ORDERED([*
  LI([**])
  *])*])dnl LIST_ORDERED, LI
 *])*])dnl LIST_ORDERED, LI
LI([*Load clients and player models -- FUNCNAME(CG_RegisterClients())
 LIST_ORDERED([*
 LI([*Report loading client information (our own) -- FUNCNAME(CG_LoadingClient()).
  LIST_ORDERED([*
  LI([*Get indicated client ENT_CS -- FUNCNAME(CG_ConfigString())*])
  LI([*If displayed less than CONSTNAME(MAX_LOADING_PLAYER_ICONS) player icons, figure out the player icon to display, display it, save player icon into VARNAME(loadingPlayerIcons[]) increment the icons counter*])
  LI([*Get client name from ENT_CS*])
  LI([*Clean up the name, stripping out invalid, dangerous, or otherwise illicit characters -- FUNCNAME(Q_CleanStr())*])
  LI([*If single-player game, load the announcer voice saying the player's (bot's) name*])
  LI([*Display client name as loading string*])
  *])*])dnl LIST_ORDERED, LI
 LI([*Update clientinfo (VARNAME(cgs.clientinfo[...])) -- FUNCNAME(CG_NewClientInfo()).
  LIST_ORDERED([*
  LI([*Extract various fields from ENT_CS, populate VARNAME(newInfo), then copy into VARNAME(cgs.clientinfo[clientNum])*])
  LI([*XXX: CG_ScanForExistingClientInfo()*])
  *])*])dnl LIST_ORDERED, LI
 LI([*For all clients (0 through CONSTNAME(MAX_CLIENTS)):
  LIST_ORDERED([*
  LI([*Skip to next client if this is our client number*])
  LI([*Get clientinfo from ENT_CS -- FUNCNAME(CG_ConfigString(CS_PLAYERS+...))*])
  LI([*If clientinfo is empty, skip to next client*])

  LI([*Report on loading client information (others) -- FUNCNAME(CG_LoadingClient())*])
  LI([*Update clientinfo -- FUNCNAME(CG_NewClientInfo())*])
  *])*])dnl LIST_ORDERED, LI
 LI([*Build the list of names of spectators -- FUNCNAME(CG_BuildSpectatorString()).
  LIST_ORDERED([*
  LI([**])
  *])*])dnl LIST_ORDERED, LI
 *])*])dnl LIST_ORDERED, LI
LI([*Set deferred models loading (load up model on death, instead of during play)*])
LI([*Initialize local entities array -- FUNCNAME(CG_InitLocalEntities())
 LIST_ORDERED([*
 LI([*Zero out (clear) array VARNAME(cg_localEntities[])*])
 LI([*Set VARNAME(cg_activeLocalEntities.next) and VARNAME(cg_activeLocalEntities.prev) to VARNAME(cg_activeLocalEntities) (itself?)*])
 LI([*Set VARNAME(cg_freeLocalEntities) to the first element (offset 0) of VARNAME(cg_localEntities[])*])
 LI([*Chain up the elements of VARNAME(cg_localEntities[]) by setting VARNAME(cg_localEntities[i].next) to VARNAME(cg_localEntities[i+1]), except the last element, which points VARNAME(next) back to the first element (VARNAME(cg_localEntities[]) as a circular list)*])
 *])*])dnl LIST_ORDERED, LI
LI([*Initialized marked polygons -- FUNCNAME(CG_InitMarkPolys())
 LIST_ORDERED([*
 LI([*Zero out (clear) array VARNAME(cg_markPolys[])*])
 LI([*Set VARNAME(cg_activeMarkPolys.nextMark) and VARNAME(cg_activeMarkPolys.prevMark) to VARNAME(cg_activeMarkPolys) (itself?)*])
 LI([*Set VARNAME(cg_freeMarkPolys) to the first element of VARNAME(cg_markPolys[])*])
 LI([*Chain up elements of VARNAME(cg_markPolys) as a circular list*])
 *])*])dnl LIST_ORDERED, LI
LI([*Clear/erase the loading string/message*])
LI([*Update values -- FUNCNAME(CG_SetConfigValues())
 LIST_ORDERED([*
 LI([*Retrieve CSNAME(SCORES1) into VARNAME(cgs.scores1)*])
 LI([*Retrieve CSNAME(SCORES2) into VARNAME(cgs.scores2)*])
 LI([*Retrieve CSNAME(LEVEL_START_TIME) into VARNAME(cgs.levelStartTime)*])
 LI([*If a CTF gametype, retrieve CSNAME(FLAGSTATUS) for the status of CTF flags, and store into VARNAME(cgs.redflag) and VARNAME(cgs.blueflag)*])
 LI([*Retrieve CSNAME(WARMUP) into VARNAME(cg.warmup)*])
 *])*])dnl LIST_ORDERED, LI
LI([*Start background music -- FUNCNAME(CG_StartMusic()).
  LIST_ORDERED([*
  LI([*Retrieve CSNAME(MUSIC) into VARNAME(s)*])
  LI([*Parse into two words*])
  LI([*Start playing background music based on this parsing -- FUNCNAME(trap_S_StartBackgroundTrack())*])
  *])*])dnl LIST_ORDERED, LI
LI([*Clear QUOT("loading...") message*])
LI([*Change shader states as needed -- FUNCNAME(CG_ShaderStateChanged())
  LIST_ORDERED([*
  LI([**])
  *])*])dnl LIST_ORDERED, LI
LI([*Stop any looping sound -- FUNCNAME(trap_S_ClearLoopingSounds())*])
*])dnl LIST_ORDERED
*])dnl _P


SECT1(CG_SHUTDOWN,vmMain(CG_SHUTDOWN))
_P([*
Called when Q3 is shutting down the cgame module, as when ending a map or quitting entirely.
No arguments.
*])dnl _P

_P([*
Immediate branch to FUNCNAME(CG_Shutdown()).
*])dnl _P


SECT2(CG_Shutdown,CG_Shutdown())
_P([*
LIST_ORDERED([*
LI([*(nothing.  Space reserved for mods that may need some explicit cleaning up, such as closing files, special commands, last desperate attempt to write some file, etc.)*])
*])dnl LIST_ORDERED
*])dnl _P


SECT1(CG_CONSOLE_COMMAND,CG_ConsoleCommand())
_P([*
Console commands are any textual commands not recognized by the Q3 engine itself.
Such commands may be entered by the drop-down console, or by key bindings (e.g. KEYB(/bind k kill)).
No arguments.
*])dnl _P

_P([*
Immediate branch to FUNCNAME(CG_ConsoleCommand()).
*])


SECT2(CG_ConsoleCommand,CG_ConsoleCommand())
_P([*
LIST_ORDERED([*
LI([*Go through the array of cgame console commands VARNAME(commands[]), trying to match names (case-insensitive).*])
LI([*If a match is found, call the associated function [pointer].*])
*])dnl LIST_ORDERED
*])dnl _P


SECT(CG_DRAW_ACTIVE_FRAME,vmMain(CG_DRAW_ACTIVE_FRAME, serverTime, stereoView, demoPlayback))
_P([*
XXX: blahblah.
Three arguments:
LIST_DICT([*
DICT(serverTime,[*The timestamp of the packet (XXX: what packet?) from the server.*])
DICT(stereoView,[*Whether to render as stereo view.*])
DICT(demoPlayback,[*True if playing back a demo, false otherwise (online game).*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
Immediate branch to FUNCNAME(CG_DrawActiveFrame()).
*])

SECT2(CG_DrawActiveFrame,CG_DrawActiveFrame(serverTime, stereoView, demoPlayback))
_P([*
LIST_ORDERED([*
LI([*Record VARNAME(serverTime) into VARNAME(cg.time)*])
LI([*Record VARNAME(demoPlayback) into VARNAME(cg.demoPlayerback)*])
LI([*Update cvars -- FUNCNAME(CG_UpdateCvars())
 LIST_ORDERED([*
 LI([*For all entries in VARNAME(cvarTable[]), update the TYPENAME(vmCvar_t) member with FUNCNAME(trap_Cvar_Update()).*])
 LI([*Do any checking of changed cvars, and actions to such changes, as needed.*])
 LI([*Checking team overlay (cvar CVARNAME(teamoverlay)).*])
 LI([*Something about cvar CVARNAME(cg_forceModel) having changed... -- FUNCNAME(CG_ForceModelChange())*])
 *])*])dnl LIST_ORDERED, LI
LI([*Um... something about loading screen vs. playing? -- FUNCNAME(CG_DrawInformation())
 LIST_ORDERED([*
 LI([*Retrieve CSNAME(SERVERINFO) into VARNAME(info).*])
 LI([*Retrieve CSNAME(SYSTEMINFO) into VARNAME(sysInfo).*])
 LI([*Retrieve value for KEYNAME(mapinfo) from VARNAME(info), mangle to get a levelshot name, display on screen -- FUNCNAME(CG_DrawPic())
  LIST_ORDERED([*
  LI([*Figure out scaled positions and sizes -- FUNCNAME(CG_AdjustFrom640())
   LIST_ORDERED([*
   LI([*Multiply VARNAME(x) and VARNAME(w) by VARNAME(cgs.screenXScale)*])
   LI([*Multiply VARNAME(y) and VARNAME(h) by VARNAME(cgs.screenYScale)*])
   *])*])dnl LIST_ORDERED, LI
  LI([*Blt image with recalculated positions and sizes -- FUNCNAME(trap_R_DrawStretchPic())*])
  *])*])dnl LIST_ORDERED, LI
 LI([*Retrieve shader named QUOT(levelShotDetail), draw it on top of the levelshot image -- FUNCNAME(trap_R_DrawStretchPic())*])
 LI([*draw icons indicating the data loaded -- FUNCNAME(CG_DrawLoadingIcon())
  LIST_ORDERED([*
  LI([*Draw the player icons representing the player information already loaded so far*])
  LI([*Draw the item icons representing the item information already loaded thus far*])
  *])*])dnl LIST_ORDERED, LI
 *])*])dnl LIST_ORDERED, LI
LI([*Clear looping sounds -- FUNCNAME(trap_S_ClearLoopingSounds())*])
LI([*Clear render list -- FUNCNAME(trap_R_ClearScene())*])
LI([*Set up VARNAME(cg.snap) and VARNAME(cg.nextSnap) -- FUNCNAME(CG_ProcessSnapshot())
 LIST_ORDERED([*
 LI([*Retrieve latest snapshot time from Q3 client engine into VARNAME(n)*])
 LI([*If the latest snapshot number is less than what we had before, something very very bad happened.*])
 LI([*Update VARNAME(cg.latestSnapshotNum) accordingly.*])
 LI([*If VARNAME(cg.snap) is empty:
  LIST_ORDERED([*
  LI([*Retrieve next snapshot into VARNAME(snap) -- FUNCNAME(CG_ReadNextSnapshot())
   LIST_ORDERED([*
   LI([*If latest snapshot and processed snapshot are off by 1000, complain*])
   LI([*Loop while VARNAME(cg.processedSnapshotNum) is less than VARNAME(cg.latestSnapshotNum):
    LIST_ORDERED([*
    LI([*Figure which slot, VARNAME(cg.activeSnapshots[0]) or VARNAME(cg.activeSnapshots[1]) to use.*])
    LI([*Increment VARNAME(cg_processedSnapshotNum), retrieve snapshot into VARNAME(r) -- FUNCNAME(trap_GetSnapshot())*])
    LI([*um... something about snapshot server time?*])
    LI([*If retrieval succeeded, record in lagometer info and return -- FUNCNAME(CG_AddLagometerSnapshotInfo())
     LIST_ORDERED([*
     LI([*If snap is CONSTNAME(NULL), record -1 into VARNAME(lagometer.snapshotSamples[]) and increment VARNAME(lagometer.snapshotCount), and return*])
     LI([*Otherwise, record snap's ping into VARNAME(lagometer.snapshotSamples[]), record snap's flags into VARNAME(lagometer.snapshotFlags[]), and increment VARNAME(lagometer.snapshotCount), and return*])
     *])*])dnl LIST_ORDERED, LI
    *])*])dnl LIST_ORDERED, li
    LI([*Record as dropped packet in lagometer info -- FUNCNAME(CG_AddLagometerInfo())*])
    LI([*If nothing left to read, return CONSTNAME(NULL) (failure)*])
   *])*])dnl LIST_ORDERED, LI
  LI([*If no snap found, bad.*])
  LI([*??? -- FUNCNAME(CG_SetInitialSnapshot())
   LIST_ORDERED([*
   LI([*Record VARNAME(snap) into VARNAME(cg.snap) (initial snapshot).*])
   LI([*Retrieve TYPENAME(entityState_t) info from snap's TYPENAME(playerState_t) info.*])
   LI([*Build the list of solid and trigger entities -- FUNCNAME(CG_BuildSolidList())
    LIST_ORDERED([*
    LI([*If nextsnap is available and not currently teleporting, use VARNAME(cg.nextsnap), otherwise use VARNAME(cg.snap)*])
    LI([*For all entities in snap:
     LIST_ORDERED([*
     LI([*Get entity's state slot*])
     LI([*If an item, or a teleport trigger, or a push trigger, record in VARNAME(cg_triggerEntities[]) and update VARNAME(cg_numTriggerEntities)*])
     LI([*If a solid entity, record in VARNAME(cg_solidEntities[]) and update VARNAME(cg_numSolidEntities)*])
     *])*])dnl LIST_ORDERED, LI
    *])*])dnl LIST_ORDERED, LI
   LI([*um.... -- FUNCNAME(CG_ExecuteNewServerCommands())
    LIST_ORDERED([*
    LI([*Keep looping while VARNAME(cgs.serverCommandSequence) < VARNAME(latestSequence) (???):
     LIST_ORDERED([*
     LI([*Get server command -- FUNCNAME(trap_GetServerCommand())*])
     LI([*Process server command -- FUNCNAME(CG_ServerCommand())
      LIST_ORDERED([*
      LI([*(XXX: EEK!)*])
      *])*])dnl LIST_ORDERED, LI
     *])*])dnl LIST_ORDERED, LI
    *])*])dnl LIST_ORDERED, LI
   LI([*Change weapon to what the server says -- FUNCNAME(CG_Respawn())
    LIST_ORDERED([*
    LI([*Disable error decay (??)*])
    LI([*Set weapon time?*])
    LI([*Set weapon according to snap information (VARNAME(cg.snap->ps.weapon))*])
    *])*])dnl LIST_ORDERED, LI
   LI([*For all entities in snap:
    LIST_ORDERED([*
    LI([*Get entity's snap state information.*])
    LI([*Get appropriate cent pointer.*])
    LI([*Clear current state information.*])
    LI([*??? -- FUNCNAME(CG_ResetEntity())
     LIST_ORDERED([*
     LI([*Clear event.*])
     LI([*Record VARNAME(cg.snap->serverTime) into VARNAME(cent->trailTime) (XXX: what's this for?)*])
     LI([*Copy VARNAME(currentOrigin) and VARNAME(currentAngles) into VARNAME(lerpOrigin) and VARNAME(lerpAngles)*])
     LI([*If a player entity, call FUNCNAME(CG_ResetPlayerEntity())
      LIST_ORDERED([*
      LI([*Eliminate error decays (???)*])
      LI([*Reset a bunch of animation information.*])
      *])*])dnl LIST_ORDERED, LI
     *])*])dnl LIST_ORDERED, LI
    LI([*??? -- FUNCNAME(CG_CheckEvents())
     LIST_ORDERED([*
     LI([*If centity's eType is an event:
      LIST_ORDERED([*
      LI([*Do nothing (return) if event already fired (occured)*])
      LI([*Mark as already now being fired*])
      LI([*Record event type into VARNAME(cent->currentState.event)*])
      *])*])dnl LIST_ORDERED, LI
     LI([*otherwise:
      LIST_ORDERED([*
      LI([*Do nothing (return) if event is attached to (riding on) another entity*])
      LI([*Copy current event into VARNAME(cent->previousEvent)*])
      LI([*Do nothing if event is not supposed to occur (bitmask flag)?*])
      *])*])dnl LIST_ORDERED, LI
     LI([*Calculate new position -- FUNCNAME(BG_EvaluateTrajectory())*])
     LI([*??? -- FUNCNAME(CG_SetEntitySoundPosition())
      LIST_ORDERED([*
      LI([*If an inline model, place entity sound position at model's midpoint -- FUNCNAME(trap_S_UpdateEntityPosition())*])
      LI([*Otherwise, place entity sound position at calculated location -- FUNCNAME(trap_S_UpdateEntityPosition())*])
      *])*])dnl LIST_ORDERED, LI
     LI([*??? -- FUNCNAME(CG_EntityEvent())
      LIST_ORDERED([*
      LI([*(XXX: EEK!)*])
      *])*])dnl LIST_ORDERED, LI
     *])*])dnl LIST_ORDERED, LI
    *])*])dnl LIST_ORDERED, LI
   *])*])dnl LIST_ORDERED, LI
  *])*])dnl LIST_ORDERED, LI
 LI([*Loop ceaselessly:
  LIST_ORDERED([*
  LI([*If VARNAME(cg.nextSnap) is empty:
   LIST_ORDERED([*
   LI([*Retrieve next snapshot into VARNAME(snap) -- FUNCNAME(CG_ReadNextSnapshot())*])
   LI([*If no snap is available, break loop any (extrapolate)*])
   LI([*??? -- FUNCNAME(CG_SetNextSnap())
    LIST_ORDERED([*
    LI([*Set VARNAME(cg.nextSnap) to the new snap*])
    LI([*Extract TYPENAME(entityState_t) information from TYPENAME(playerState_t) information in snap*])
    LI([*Allow position interpolation*])
    LI([*For each entity listed in snap:
     LIST_ORDERED([*
     LI([*Clear VARNAME(cent->nextState)*])
     LI([*If teleporting, or otherwise doesn't have a prior position to sensibly interpolate from, turn off interpolation; otherwise turn it on.*])
     *])*])dnl LIST_ORDERED, LI
    LI([*If client number in current and next snap don't match, act as if teleporting (?)*])
    LI([*Something about server restart and not interpolating???*])
    LI([*Build the list of solid and trigger entities -- FUNCNAME(CG_BuildSolidList())*])
    *])*])dnl LIST_ORDERED, LI
   LI([*If server time jumped backwards, interpret as level restart.*])
   *])*])dnl LIST_ORDERED, LI
  LI([*If VARNAME(cg.time) is between VARNAME(cg.snap->serverTime) and VARNAME(cg.nextSnap->serverTime), end the loop (interpolate)*])
  LI([*Make the transition to the next snapshot -- FUNCNAME(CG_TransitionSnapshot())
   LIST_ORDERED([*
   LI([*Complain if VARNAME(cg.snap) or VARNAME(cg.nextSnap) is/are null*])
   LI([*??? -- FUNCNAME(CG_ExecuteNewServerCommands())
    LIST_ORDERED([*
    LI([**])
    *])*])dnl LIST_ORDERED, LI
   LI([*Invalidate all entities in existing snap*])
   LI([*Temporarily save VARNAME(cg.snap), move VARNAME(cg.nextSnap) into VARNAME(cg.snap)*])
   LI([*Update clients entity information*])
   LI([*For all entities in (new) snap:
    LIST_ORDERED([*
    LI([*??? -- FUNCNAME(CG_TransitionEntity())
     LIST_ORDERED([*
     LI([*If centity position is not to be interpolated (popped into view, teleported in, respawned), reset the entity -- FUNCNAME(CG_ResetEntity())*])
     LI([*Turn off interpolation (clear next state?)*])
     LI([*Check for events -- FUNCNAME(CG_CheckEvents())*])
     *])*])dnl LIST_ORDERED, LI
    LI([*Update recorded server time*])
    LI([*Check if client is teleporting*])
    LI([*If not doing client-side prediction, ??? -- FUNCNAME(CG_TransitionPlayerState())
     LIST_ORDERED([*
     LI([**])
     *])*])dnl LIST_ORDERED, LI
    *])*])dnl LIST_ORDERED, LI
   *])*])dnl LIST_ORDERED, LI
  *])*])dnl LIST_ORDERED, LI
 LI([*Assert various conditions (trigger fatal error if any check is false)*])
 *])*])dnl LIST_ORDERED, LI
LI([*Draw loading screen and return if no snapshots received?*])
LI([*Notify Q3 engine of weapon and zoom (mouse) sensitivity -- FUNCNAME(trap_SetUserCmdValue())*])
LI([*Keep track of how many frames have been rendered so far in VARNAME(cg.clientFrame)*])
LI([*Update VARNAME(cg.predictedPlayerState) -- FUNCNAME(CG_PredictPlayerState())
 LIST_ORDERED([*
 LI([*Set VARNAME(cg.hyperspace) to CONSTNAME(qfalse) (why???)*])
 LI([*If no valid predicted player state data yet, fill it in as needed*])
 LI([*If playing back a demo, interpolation movements and return -- FUNCNAME(CG_InterpolatePlayerState())
  LIST_ORDERED([*
  LI([*if allowing local input (disabled in spectating or demo playback), short-circuit the view angles (change it despite what server says) -- FUNCNAME(PM_UpdateViewAngles())
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*If teleporting, return (no point in interpolating)*])
  LI([*Check for inconsistencies(?)*])
  LI([*Into VARNAME(f) goes the fraction between VARNAME(prev->serverTime) and VARNAME(next->serverTime) that VARNAME(cg.time) resides*])
  LI([*Set bobbing accordingly.*])
  LI([*Move entity by the calculated fractional amount*])
  LI([*Change entity fractionally as well if local input allowed*])
  *])*])dnl LIST_ORDERED, LI
 LI([*Set up for call to FUNCNAME(Pmove())*])
 LI([*Saved old player state info.*])
 LI([*Retrieve current command number into VARNAME(current) -- FUNCNAME(trap_GetCurrentCmdNumber())*])
 LI([*If can't get a good command (?), just return (effect is freezing in place) -- FUNCNAME(trap_GetUserCmd())*])
 LI([*Get latest commands -- FUNCNAME(trap_GetUserCmd())*])
 LI([*Use VARNAME(cg.snap) or VARNAME(cg.nextSnap) depending on next snap being available and teleporting*])
 LI([*Retrict cvar CVARNAME(pmove_msec) within a certain range*])
 LI([*Set VARNAME(cg_pmove.pmove_fixed) to CVARNAME(pmove_fixed)*])
 LI([*Set VARNAME(cg_pmove.pmove_msec) to CVARNAME(pmove_msec)*])
 *])*])dnl LIST_ORDERED, LI
LI([*Go into third-person view (VARNAME(cg.renderingThirdPerson)) if cvar VARNAME(cg_thirdPerson) is non-zero, or if dead*])
LI([*Calculate the stuff related to the viewing camera (client's eye(s)) -- FUNCNAME(CG_CalcViewValues())
 LIST_ORDERED([*
 LI([*Clear VARNAME(cg.refdef)*])
 LI([*Calculate the portions of the screen to draw camera view within (view rectangle, how much black border around the screen edge) -- FUNCNAME(CG_CalcVrect())
  LIST_ORDERED([*
  LI([*If intermission, fill up the entire screen (size = 100)*])
  LI([*Otherwise, clip cvar CVARNAME(cg_viewsize) within 30 and 100.*])
  LI([*Ensure VARNAME(cg.refdef.width) and VARNAME(cg.refdef.height) are even numbers.*])
  LI([*Center the view rectangle.*])
  *])*])dnl LIST_ORDERED, LI
 LI([*If intermission view:
  LIST_ORDERED([*
  LI([*Copy server-reported location into refdef's view origin*])
  LI([*Copy server-reported view angles into redef's view angles*])
  LI([*Calculate FOV and return -- FUNCNAME(CG_CalcFov())*])
  *])*])
 LI([*Set bobbing.*])
 LI([*Something about speed on X-Y plane... *])
 LI([*Update camera orbiting data*])
 LI([*If errordecay:
  LIST_ORDERED([*
  LI([*Calculate decay fraction.*])
  LI([*Shift refdef's view origin accordingly.*])
  *])*])dnl LIST_ORDERED, LI
 LI([*Check if drawing in third-person view -- FUNCNAME(CG_OffsetThirdPersonView())*])
 LI([*Otherwise draw in first-person view -- FUNCNAME(CG_OffsetFirstPersonView())*])
 LI([*Position the eyes properly*])
 LI([*If not in hyperspace... XXX: ??? *])
 LI([*Calculate field of view/vision (FOV) -- FUNCNAME(CG_CalcFov())
  LIST_ORDERED([*
  LI([*If in intermission, fix FOV at 90 degrees*])
  LI([*Otherwise, calculate FOV based on CVARNAME(cg_fov), clipping within range as needed, and alter based on zoom state; or keep at 90 if server set CONSTNAME(DF_FIXED_FOV) bit in dmflags*])
  LI([*Convert FOV degrees to radians.*])
  LI([*If inside liquid:
   LIST_ORDERED([*
   LI([*Munge X and Y components of FOV by a sinusoidal function, each component phase-shifted by a half-cycle (widest when shortest, tallest when narrowest)*])
   *])*])dnl LIST_ORDERED, LI
  LI([*Set VARNAME(cg.refdef.fov_x) and VARNAME(cg.refdef.fov_y)*])
  LI([*Set VARNAME(cg.zoomSensitivity) according to zoomed state.*])
  *])*])dnl LIST_ORDERED, LI
 *])*])dnl LIST_ORDERED, LI
LI([*Show damage blob (the screen-reddening effect when damaged) -- FUNCNAME(CG_DamageBlendBlob())
 LIST_ORDERED([*
 LI([*If no damage received, return*])
 LI([*If detected RagePro vidcard, return*])
 LI([*If beyond display time, return*])
 LI([*Clear blob entity*])
 LI([*Set blob entity parameters (sprite, shown only in first-person view)*])
 LI([*Place blob entity right in front of camera*])
 LI([*Set full color, set transparency proportional to blob display time (fade away)*])
 LI([*Add blob entity to rendering scene -- FUNCNAME(trap_R_AddRefEntityToScene())*])
 *])*])dnl LIST_ORDERED, LI
LI([*If not in hyperspace, build render list:
 LIST_ORDERED([*
 LI([*Add entities specified in packet from server -- FUNCNAME(CG_AddPacketEntities())
  LIST_ORDERED([*
  LI([*Calculate interpolation amount*])
  LI([*Calculate (all) rotation phase*])
  LI([*Calculate (all) fast-rotation phase*])
  LI([*Extract TYPENAME(entityState_t) from TYPENAME(playerState_t) of VARNAME(cg.predictedPlayerState)*])
  LI([*Add player entity to rendering -- FUNCNAME(CG_AddCEntity())
   LIST_ORDERED([*
   LI([*(XXX: EEK!)*])
   *])*])dnl LIST_ORDERED, LI
  LI([*Lerp (linearly interpolate) lightning gun position -- FUNCNAME(CG_CalcEntityLerpPositions())
   LIST_ORDERED([*
   LI([*If cvar CVARNAME(cg_smoothClients) is 0, client doesn't want extrapolated positions, force TR_INTERPOLATE trajectory type on clients' positions*])
   LI([*If TR_INTERPOLATE trajectory type, lerp entity's position -- FUNCNAME(CG_InterpolateEntityPosition())
    LIST_ORDERED([*
    LI([*Complain if insufficient interpolation data (second position)*])
    LI([*Calculate the predicted entity position*])
    LI([*Lerp position according to interpolation fraction*])
    LI([*Calculate the predicted entity angles*])
    LI([*Lerp angles according to interpolation fraction -- FUNCNAME(Lerp_Angle())*])
    *])*])dnl LIST_ORDERED, LI
   LI([*Use current frame and extrapolate position and angle*])
   LI([*Adjust for mover's movement if necessary -- FUNCNAME(CG_AdjustPositionForMover())
    LIST_ORDERED([*
    LI([*Check that entity is valid*])
    LI([*Check entity is a mover*])
    LI([*Evaluate mover trajectory effect*])
    *])*])dnl LIST_ORDERED, LI
   *])*])dnl LIST_ORDERED, LI
  LI([*For each entities listed in the snapshot:
   LIST_ORDERED([*
   LI([*Add the entity to rendering -- FUNCNAME(CG_AddCEntity())*])
   *])*])dnl LIST_ORDERED, LI
  *])*])dnl LIST_ORDERED, LI
 LI([*Add various marks to surfaces (burn marks, blood splatters, etc.) -- FUNCNAME(CG_AddMarks())
  LIST_ORDERED([*
  LI([*If cvar CVARNAME(cg_addMarks) is 0, return*])
  LI([*For all recorded marks:
   LIST_ORDERED([*
   LI([*Some linked list doohickerymajiggy?*])
   LI([*If mark's time expired, free the mark, move on to next mark -- FUNCNAME(CG_FreeMarkPoly())
    LIST_ORDERED([*
    LI([*Remove from doubly-linked list of active marks*])
    LI([*Also update free list (a singly-linked list)*])
    *])*])dnl LIST_ORDERED, LI
   *])*])dnl LIST_ORDERED, LI
   LI([*For energy bursts (e.g. plasma-hit-wall, rail-hit-wall), fade out colors based on its age (VARNAME(mp->time))*])
   LI([*Fade out the mark based on age.*])
   LI([*Add mark entity to render scene -- FUNCNAME(trap_AddPolyToScene())*])
  *])*])dnl LIST_ORDERED, LI
 LI([*Add entities that are implied by game entities, or explicitly generated locally -- FUNCNAME(CG_AddLocalEntities())
  LIST_ORDERED([*
  LI([*Traverse through the list VARNAME(cg_activeLocalEntities) backwards:
   LIST_ORDERED([*
   LI([*grab pointer to VARNAME(next) in case of early freeing.*])
   LI([*if local entity lifespan exceeded, remove -- FUNCNAME(CG_FreeLocalEntity())*])
   LI([*Based on entity type, call approriate function:
    LIST_UNORDERED([*
    LI([*CONSTNAME(LE_MARK) -- (handled elsewhere)*])
    LI([*CONSTNAME(LE_SPRITE_EXPLOSION) -- FUNCNAME(CG_AddSpriteExplosion())*])
    LI([*CONSTNAME(LE_EXPLOSION) -- FUNCNAME(CG_AddExplosion())*])
    LI([*CONSTNAME(LE_FRAGMENT) (gibs, brass) -- FUNCNAME(CG_AddFragment())*])
    LI([*CONSTNAME(LE_MOVE_SCALE_FADE) (water bubble) -- FUNCNAME(CG_AddMoveScaleFade())*])
    LI([*CONSTNAME(LE_FADE_RGB) (teleporter, railtrail) -- FUNCNAME(CG_AddFadeRGB())*])
    LI([*CONSTNAME(LE_FALL_SCALE_FADE) (gibs blood trail) -- FUNCNAME(CG_AddFallScaleFade())*])
    LI([*CONSTNAME(LE_SCALE_FADE) (rocket trail) -- FUNCNAME(CG_AddScaleFade())*])
    LI([*CONSTNAME(LE_SCOREPLUM) (floating score) -- FUNCNAME(CG_AddScorePlum())*])
    *])*])dnl LIST_ORDERED, LI
   *])*])dnl LIST_ORDERED, LI
  LI([*(XXX: EEK!)*])
  *])*])dnl LIST_ORDERED, LI
 *])*])dnl LIST_ORDERED, LI
LI([*Draw the gun/weapon -- FUNCNAME(CG_AddViewWeapon())
 LIST_ORDERED([*
 LI([*If spectator, return*])
 LI([*If in intermission, return*])
 LI([*If in third person view, don't draw weapon view (it gets rendered in whole, anyway)*])
 LI([*If cvar CVARNAME(cg_drawGun) is 0, don't draw the gun, while doing some special position-shifting hack for lightning gun*])
 LI([*If testing a gun model, return*])
 LI([*Position the gun lower at higher FOV values*])
 LI([*??? -- FUNCNAME(CG_RegisterWeapon())
  LIST_ORDERED([*
  LI([**])
  *])*])dnl LIST_ORDERED, LI
 *])*])dnl LIST_ORDERED, LI
LI([*??? -- FUNCNAME(CG_PlayBufferedSounds())
 LIST_ORDERED([*
 LI([*(play next sound stored in sound ring buffer)*])
 *])*])dnl LIST_ORDERED, LI
LI([*Play voice chat sounds -- FUNCNAME(CG_PlayBufferedVoiceChats())
 LIST_ORDERED([*
 LI([*(Q3 Team Arena only, skipping)*])
 *])*])dnl LIST_ORDERED, LI
LI([*Add test model specified by "testmodel" client console command -- FUNCNAME(CG_AddTestModel())
 LIST_ORDERED([*
 LI([**])
 *])*])dnl LIST_ORDERED, LI
LI([*Record VARNAME(cg.time) into VARNAME(cg.refdef.time)*])
LI([*Copy VARNAME(cg.snap->areamask) into VARNAME(cg.refdef.areamask)*])
LI([*Play any sounds associated with powerups wearing out (expiring) -- FUNCNAME(CG_PowerupTimerSounds())
 LIST_ORDERED([*
 LI([**])
 *])*])dnl LIST_ORDERED, LI
LI([*update audio positions -- FUNCNAME(trap_S_Respatialize()).*])
LI([*Draw lag-o-meter, but make sure it isn't done twice in stereoscopic view -- FUNCNAME(CG_AddLagometerFrameInfo())
 LIST_ORDERED([*
 LI([*Record lagometer sample offset number info VARNAME(lagometer.frameSamples[]), update VARNAME(lagometer.frameCount)*])
 *])*])dnl LIST_ORDERED, LI
LI([*um... something about cvar CVARNAME(timescale)?...*])
LI([*Make rendering calls -- FUNCNAME(CG_DrawActive())
 LIST_ORDERED([*
 LI([*If no baseline snapshot (VARNAME(cg.snap)) still, draw the info/loading screen -- FUNCNAME(CG_DrawInformation())*])
 LI([*If a spectator and looking at scoreboard, display tournament scoreboard -- FUNCNAME(CG_DrawTourneyScoreboard())
  LIST_ORDERED([*
  LI([**])
  *])*])dnl LIST_ORDERED, LI
 LI([*Adjust separation based on stereoscopic view*])
 LI([*Add filler graphic around sized-down refresh window (sizeup/sizedown) -- FUNCNAME(CG_TileClear())
  LIST_ORDERED([*
  LI([*Get video dimensions.*])
  LI([*If full-screen rendering, don't bother (return).*])
  LI([*Get the edges of the refresh screen.*])
  LI([*Clear the top edge of view screen -- FUNCNAME(CG_TileClearBox())
   LIST_ORDERED([*
   LI([*Calculate how many repeats needed vertically and horizontally*])
   LI([*Tile the image -- FUNCNAME(trap_R_DrawStretchPic())*])
   *])*])dnl LIST_ORDERED, LI
  LI([*Clear the bottom edge of view screen -- FUNCNAME(CG_TileClearBox())*])
  LI([*Clear the left edge of view screen -- FUNCNAME(CG_TileClearBox())*])
  LI([*Clear the right edge of view screen -- FUNCNAME(CG_TileClearBox())*])
  *])*])dnl LIST_ORDERED, LI
 LI([*Shift VARNAME(cg.refdef.vieworg) based on stereoscopic seperation*])
 LI([*Render the scene -- FUNCNAME(trap_R_RenderScene())*])
 LI([*Restore original viewpoint as needed*])
 LI([*Draw HUD and other 2D elements -- FUNCNAME(CG_Draw2D())
  LIST_ORDERED([*
  LI([*If taking levelshot (CVARNAME(levelshot) is non-zero), don't bother (return)*])
  LI([*If CVARNAME(draw2D) is zero, don't bother (return)*])
  LI([*If at intermission, do intermission stuff -- FUNCNAME(CG_DrawIntermission())
   LIST_ORDERED([*
   LI([*If single player mode, draw something... -- FUNCNAME(CG_DrawCenterString())
    LIST_ORDERED([*
    LI([**])
    *])*])dnl LIST_ORDERED, LI
   LI([*otherwise, draw scoreboard -- FUNCNAME(CG_DrawScoreboard())
    LIST_ORDERED([*
    LI([**])
    *])*])dnl LIST_ORDERED, LI
   *])*])dnl LIST_ORDERED, LI
  LI([*If a spectator, do spectator things:
   LIST_ORDERED([*
   LI([*??? -- FUNCNAME(CG_DrawSpectator())
    LIST_ORDERED([*
    LI([**])
    *])*])dnl LIST_ORDERED, LI
   LI([*??? -- FUNCNAME(CG_DrawCrosshair())
    LIST_ORDERED([*
    LI([**])
    *])*])dnl LIST_ORDERED, LI
   LI([*??? -- FUNCNAME(CG_DrawCrosshairNames())
    LIST_ORDERED([*
    LI([**])
    *])*])dnl LIST_ORDERED, LI
   *])*])dnl LIST_ORDERED, LI
  LI([*Otherwise, non-spectator stuff:
   LIST_ORDERED([*
   LI([*if alive and not looking at scores:
    LIST_ORDERED([*
    LI([*Draw status bar -- FUNCNAME(CG_DrawStatusBar())
     LIST_ORDERED([*
     LI([**])
     *])*])dnl LIST_ORDERED, LI
    LI([*Draw any ammo warning -- FUNCNAME(CG_DrawAmmoWarning())
     LIST_ORDERED([*
     LI([**])
     *])*])dnl LIST_ORDERED, LI
    LI([*Draw crosshairs -- FUNCNAME(CG_DrawCrosshair())
     LIST_ORDERED([*
     LI([**])
     *])*])dnl LIST_ORDERED, LI
    LI([*Draw crosshair names -- FUNCNAME(CG_DrawCrosshairNames())
     LIST_ORDERED([*
     LI([**])
     *])*])dnl LIST_ORDERED, LI
    LI([*Draw weapon selection (the icons along bottom on weapon switch) -- FUNCNAME(CG_DrawWeaponSelect())
     LIST_ORDERED([*
     LI([**])
     *])*])dnl LIST_ORDERED, LI
    LI([*Draw reward icons -- FUNCNAME(CG_DrawReward())
     LIST_ORDERED([*
     LI([**])
     *])*])dnl LIST_ORDERED, LI
    *])*])dnl LIST_ORDERED, LI
   *])*])dnl LIST_ORDERED, LI
  LI([*in either case, then draw vote status -- FUNCNAME(CG_DrawVote())
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*and any team votes -- FUNCNAME(CG_DrawTeamVote())
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*Draw the lagometer -- FUNCNAME(CG_DrawLagometer())
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*Draw uppper right stuff (fps, time) -- FUNCNAME(CG_DrawUpperRight())
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*Draw lower right stuff (powerups, scores) -- FUNCNAME(CG_DrawLowerRight())
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*Draw lower left stuff -- FUNCNAME(CG_DrawLowerLeft())
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*Determine if spectating and following another client -- FUNCNAME(CG_DrawFollow)
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*Draw any warmup info if not following -- FUNCNAME(CG_DrawWarmup())
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*Try to draw scoreboard -- FUNCNAME(CG_DrawScoreboard))
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  LI([*If not showing scoreboard, try to draw any center strings -- FUNCNAME(CG_DrawCenterString())
   LIST_ORDERED([*
   LI([**])
   *])*])dnl LIST_ORDERED, LI
  *])*])dnl LIST_ORDERED, LI
 *])*])dnl LIST_ORDERED, LI
LI([*Print VARNAME(cg.clientFrame) (frame number) if cvar CVARNAME(cg_stats) is non-zero.*])
*])dnl LIST_ORDERED
*])dnl _P


SECT1(CG_CROSSHAIR_PLAYER,vmMain(CG_CROSSHAIR_PLAYER))
_P([*
WTF?
*])

_P([*
Immediate branch to FUNCNAME(CG_CrosshairPlayer()).
*])

SECT2(CG_CrosshairPlayer,CG_CrosshairPlayer())
_P([*
LIST_ORDERED([*
LI([*If still within 1 second of crosshair time (XXX: what's that?), return VARNAME(cg.crosshairClientNum), otherwise return -1.*])
*])dnl LIST_ORDERED
*])dnl _P


SECT1(CG_LAST_ATTACKER,vmMain(CG_LAST_ATTACKER))
_P([*
WTF?
*])

_P([*
Immediate branch to FUNCNAME(CG_LastAttacker()).
*])

SECT2(CG_LastAttacker,CG_LastAttacker())
_P([*
LIST_ORDERED([*
LI([*If client was ever attacked (damaged), return last attacker (VARNAME(cg.snap-ENT_gt()ps.persistant[PERS_ATTACKER]))*])
*])dnl LIST_ORDERED
*])dnl _P


SECT1(CG_KEY_EVENT,vmMain(CG_KEY_EVENT,key,down))
_P([*
Called when key-trapping is on (trap_Key_SetCatcher(KEYCATCH_CGAME)) and a key is pressed or released.
Two arguments:
LIST_DICT([*
DICT(key,[*
Keycode of the key event.
Every key generates a keycode (not necessarily unique).
For the alphanumeric keys, the keycode corresponds to the key's ASCII code.
For other keys, the values are something else... (XXX: list keycodes).
*])
DICT(down,[*
Whether the event is generated by a key being pressed (qtrue) or being released (qfalse).
*])
*])dnl LIST_DICT
*])dnl _P

_P([*
Immediate branch to FUNCNAME(CG_KeyEvent()).
*])

SECT2(CG_KeyEvent,CG_KeyEvent(key,down))
_P([*
LIST_ORDERED([*
LI([*(Empty in baseq3.
Mods may use this space for something useful.
Q3TA defines a FUNCNAME(CG_KeyEvent()) with real meat; not covered here.)
*])dnl LI
*])dnl LIST_ORDERED
*])dnl _P


SECT1(CG_MOUSE_EVENT,vmMain(CG_MOUSE_EVENT,x,y))
_P([*
Called when key-catching is enabled (trap_Set_KeyCatcher(KEYCATCH_CGAME)) and the mouse moves.
No mouse event if the mouse is not moving.
Button clicks count as key events (keycodes MOUSE1...MOUSE5, MWHEELUP, MWHEELDOWN).
Two arguments:
LIST_DICT([*
DICT(x,[*Relative x (horizontal, left/right) motion.
Positive values are towards the right, negative values towards the left.
*])
DICT(y,[*Relative y (vertical, up/down) motion.
Positive values are towards the bottom, negative values are towards the top.
*])
*])dnl LIST_DICT
*])dnl _P

_P([*
Immediate branch to FUNCNAME(CG_MouseEvent).
*])

SECT2(CG_MouseEvent,CG_MouseEvent(x,y))
_P([*
LIST_ORDERED([*
LI([*(Empty in baseq3.
Mods may use this space for something useful.
Q3TA defines a FUNCNAME(CG_MouseEvent()) with real meat; not covered here.)
*])dnl LI
*])dnl LIST_ORDERED
*])dnl _P


SECT1(CG_EVENT_HANDLING,vmMain(CG_EVENT_HANDLING,type))
_P([*
(I'd like to know!)
type - 0 = no event handling, 1 = team menu, 2 = hud editor (what hud editor???)
*])dnl _P

_P([*
Immediate branch to FUNCNAME(CG_EventHandling).
*])

SECT2(CG_EventHandling,CG_EventHandling(type))
_P([*
LIST_ORDERED([*
LI([*(Empty in baseq3.
Q3TA defines a FUNCNAME(CG_EventHandling()) with real meat; not covered here.)
*])dnl LI
*])dnl LIST_ORDERED
*])


<!--
SECT1(FOO,[*vmMain(FOO, ...)*])
_P([*
When Q3 wants to ... Q3 calls vmMain with major function CONSTNAME(GAME_FOO), and ... arguments:
LIST_ORDERED([*
LI([*...*])
*])dnl LIST_ORDERED
*])dnl _P

_P([*
Immediate branch to FUNCNAME(something()).
*])

SECT1(CG_Foo,[*CG_Foo(...)*])
_P([*
...
*])
-->

HORIZRULEz
_P([*
Created 2002.09.28 _LF()
Updated 2011.07.11 - change of contact e-mail _LF()
ADDRESS([*
ENT_authornick
ENT_angbra ENT_authormail ENT_angket
*])dnl ADDRESS
*])dnl _P

</BODY>
</HTML>
