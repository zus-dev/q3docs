# Server and Client

We are looking at a client/server architecture. This means that we usually do
things server side and then inform the clients about the changes, for
example:
- New objects must be added serverside, so they are visible to all clients.
- But custom graphics effects can be added to the client *if* they do not change the flow of the game.
		
# Protocol

The packets sent from the client to the server are handled in `sv_main.c` in `SV_PacketEvent`
	
# Abbreviations
- `q_` Quake: Misc code (?)
- `g_*` Game: server code
- `cg_*` Client Game: client graphics code
- `bg_*` Both Games: Code that is used by client AND server
- `sv_*` SerVer: server management code (not game related)
- `r_*` Render: organize shaders, meshes, textures etc; render things to the screen
- `tr` TRajectory: contains movement information for characters and projectiles)
- `aas` Area Awareness System: Path-finding, collision detection etc
- `ai` Artificial Intelligence: server-side
- `ui` User Interface: client side
- `Com_*` Common: common function
- `svc_*` SerVer Command
- `clc_*` CLient Command
- `VectorMA` Vector Multiply-Add 
- `trap_CM` e.g. `trap_CM_BoxTrace` Collision Model? 
	
# Naming conventions

- entity = All dynamic objects, things or animations within a map (see `bg_public.h`: `entityType_t`)
- player = character = A moving character model, controlled by AI or Human
- item = Objects that lie on the ground and can be picked up/used (see `bg_public.h`: `itemType_t`)
- projectile = missile = bolt = flying object, shot out of a weapon
- trajectory = the path of a moving object
- bobbing = up & down hovering (animations of some items include bobbing)

# Commands

Commands are used to change the configuration of the client/server or make either of them do things

## Server-side commands

- You can find an overview over all server commands and how they are handled by the client in `cg_servercmds.c` (`CG_ServerCommand`)
- Use `trap_SendServerCommand` in code (-1 to call command on all clients, else use on a specific client).
  Example: 
```c
trap_SendServerCommand(-1, va("print \"%s" S_COLOR_WHITE " entered the game\n\"", client->pers.netname));
trap_SendServerCommand(-1, va("cp \"%s" S_COLOR_WHITE " entered the game\n\"", client->pers.netname));
```

## Client-side commands
- Client commands are defined in `sv_ccmds.c` in `SV_AddOperatorCommands()`
- Open the ingame console with the \` key and type the command that you want to use

# Code landmarks
Server:
    `g_client.c`:
        `ClientBegin(...)` -> Called on every new player object (bots or humans)
    `g_missile.c`: 
        `fire_plasma(...)` -> How to create a moving object
    `g_mover.c`:
        `Think_SpawnNewDoorTrigger(..)` -> How to add an ingame object that triggers a callback when touched
Client:
    `ui_players.c`:
        `UI_DrawPlayer(...)` -> Draws a player model on the client
    `cg_event.c`:
        `CG_EntityEvent` -> Handles almost all things that can happen in the game (except for movement apparently)
    `cg_ents.c`:
        `CG_Missile(...)` -> Deploys one projectile, such as a rocket, grenade or plama ball (from the plasma gun) etc
	
# How things work

- [BSP Collision Detection](./tutorials/bsp_collision_detection.md)

- Model display
```
-> CG_AddPacketEntities (iterates over all existing entities that the client knows of, every frame)
    -> CG_AddCEntity
        -> RE_AddRefEntityToScene
- Models are defined in: bg_misc.c -> gitem_t	bg_itemlist[] = 
    - Those items will be added in:
        -> CG_RegisterGraphics
            -> CG_RegisterItemVisuals
                -> trap_R_RegisterModel
                    -> RE_RegisterModel
                -> trap_R_RegisterShader
                    -> RE_RegisterShader
                (-> CG_RegisterWeapon: Defines graphical behavior and relation of a weapon and it's projectile (eg. Rocket Launcher & Rocket))
```

- Rendering:
```
	Preparation:
		-> RE_RenderScene
			-> R_RenderView
				-> ... -> R_AddDrawSurf
				(-> R_MirrorViewBySurface)
			
	Actual drawing:
		-> RB_ExecuteRenderCommands
			-> RB_DrawSurfs
				RB_DrawBuffer
					-> RB_BeginDrawingView
					-> 

				or: RB_DrawSurfs
					-> RB_RenderDrawSurfList
						-> RB_BeginDrawingView
						-> rb_surfaceTable callback to modify render commands
	
	Quake III Shaders are CPU-bound and have their own language (http://www.heppler.com/shader/)
		-> ParseShader
	
	Implementational Details:
		-> R_DrawElements
			-> qglDrawElements
		-> ComputeStageIteratorFunc
			- The stage iterator basically decides how to draw
			- There are optimized stage iterators for certain drawing stages
			- usually the following iterator is used:
				-> RB_StageIteratorGeneric
				
			
	Optional:
		r_showtris = 1
			-> DrawTris
		r_shownormals = 1
			-> DrawNormals
```
			
- Lighting
```
	Dynamic Lights
	-> are computed in ProjectDlightTexture
		-> ProjectDlightTexture_scalar
```

- Mirroring
```
	- R_MirrorViewBySurface
		-> First trivial clip rejection for mirrors through SurfIsOffscreen
```

- Lights:
```
	- All lights are statically rendered into textures
	- if r_mapOverBrightBits is set to -1, all background textures are black
	- check R_DlightBmodel for dynamic light effects
	- rb_surfaceTable
```
	
- Map parser
```
	- Quake 3 uses the BSP format
	- There is an explanation of the format at: http://www.mralligator.com/q3/
```
    
# Examples

- How to create and add an object (from `g_missile.c`):
```c
/**
 * For trajectory handling, see bg_misc.c: void BG_EvaluateTrajectory( const trajectory_t *tr, int atTime, vec3_t result )
 *
 * Params:
 * 	self = The shooter of the rocket to be fired
 */
gentity_t *fire_rocket (gentity_t *self, vec3_t start, vec3_t dir) {
  gentity_t	*bolt;
  
  // The time to wait until the thinkCallback is called
  int thinkDelayMillis = 15000;
  
  VectorNormalize (dir);

  // create the rocket
  bolt = G_Spawn(); 

  // name of the object -> has no effect on game mechanics
  bolt->classname = "rocket"; 

  // call think after this time
  bolt->nextthink = level.time + thinkDelayMillis; 

  // function to be called after thinkDelayMillis; for example: G_ExplodeMissile
  bolt->think = thinkCallback; 

  // the type of event to be triggered 
  // used in AI for determining threat level of object; 
  // and in the client to determine model, sounds etc
  bolt->s.eType = ET_MISSILE; 

  // "entity->r.currentOrigin instead of entity->s.origin" (see g_public.h)
  bolt->r.svFlags = SVF_USE_CURRENT_ORIGIN; 

  // the weapon info is needed to determine the cause of damage and maybe other things
  bolt->s.weapon = WP_ROCKET_LAUNCHER; 

  // the player who owns this projectile
  bolt->r.ownerNum = self->s.number; 

  // i think this is used for objects that consist of multiple entities
  bolt->parent = self; 

  // amount of damage to be dealt to a target when hit directly
  bolt->damage = 100; 

  // amount of splash damage to be dealt (to anyone in splashRadius)
  bolt->splashDamage = 100; 

  // radius to deliver damage upon impact or destruction of projectile
  bolt->splashRadius = 120; 

  // what happens if this projectile kills someone
  bolt->methodOfDeath = MOD_ROCKET; 

  // what happens if this projectile kills someone
  bolt->splashMethodOfDeath = MOD_ROCKET_SPLASH;				

  // seems to be used for collision detection
  bolt->clipmask = MASK_SHOT;

  // not sure what target_ent is, seems to be used for collision detection
  bolt->target_ent = NULL;

  // straight trajectory: Just keep going in the same direction
  bolt->s.pos.trType = TR_LINEAR;

  // move a bit on the very first frame (necessary, so the delta upon first interpolation is ensured to be != 0)
  bolt->s.pos.trTime = level.time - MISSILE_PRESTEP_TIME;		
  
  // bolt->s.pos.trBase = start		-> start of the trajectory
  VectorCopy( start, bolt->s.pos.trBase );

  // bolt->s.pos.trDelta = 900 * dir    -> velocity vector
  VectorScale( dir, 900, bolt->s.pos.trDelta );
  
  // bolt->r.currentOrigin = start    -> "currentOrigin will be used for all collision detection and world linking"
  VectorCopy (start, bolt->r.currentOrigin);

  // save net bandwidth (internal optimization - can be ignored)
  SnapVector( bolt->s.pos.trDelta );
  
  return bolt;
}
```
	
- Where are objects and object deltas sent to the client?

A normal server packet will look like:                             
```
4   sequence number (high bit set if an oversize fragment)         
<optional reliable commands>                                       
1   svc_snapshot                                                   
4   last client reliable command                                   
4   serverTime                                                     
1   lastframe for delta compression                                
1   snapFlags                                                      
1   areaBytes                                                      
<areabytes>                                                        
<playerstate>                                                      
<packetentities>                                                   
```

Server writes snapshot to client `server/sv_snapshot.c`:

```c
SV_WriteSnapshotToClient (client, msg) at code/server/sv_snapshot.c
SV_SendClientSnapshot (client) at code/server/sv_snapshot.c
SV_SendClientMessages () at code/server/sv_snapshot.c
SV_Frame () at code/server/sv_main.c
Com_Frame () at code/qcommon/common.c
SDL_main ()
```

```c
SV_WriteSnapshotToClient(client, msg)
{
    ...
    // delta encode the playerstate
    if ( oldframe ) {
        MSG_WriteDeltaPlayerstate( msg, &oldframe->ps, &frame->ps );
    } else {
        MSG_WriteDeltaPlayerstate( msg, NULL, &frame->ps );
    }

    // delta encode the entities
    SV_EmitPacketEntities (oldframe, frame, msg);
    ...
}
```

Client parses snapshot.

If the snapshot is parsed properly, it will be copied to cl.snap and saved in
cl.snapshots[].  If the snapshot is invalid for any reason, no changes to the
state will be made at all.

```c
CL_ParseSnapshot (msg) at code/client/cl_parse.c
CL_ParseServerMessage (msg) at code/client/cl_parse.c
CL_PacketEvent (from, msg) at code/client/cl_main.c
Com_EventLoop () at code/qcommon/common.c
Com_Frame () at code/qcommon/common.c
SDL_main ()
```

- How Client-Server messages (packets) are working?

Server to client commands:

```c
// the svc_strings[] array in cl_parse.c should mirror this
enum svc_ops_e {
    svc_bad,
    svc_nop,
    svc_gamestate,
    svc_configstring,           // [short] [string] only in gamestate messages
    svc_baseline,               // only in gamestate messages
    svc_serverCommand,          // [string] to be executed by client game module
    svc_download,               // [short] size [size bytes]
    svc_snapshot,
    svc_EOF,
};
```

Client to server commands:

```c
enum clc_ops_e {
    clc_bad,
    clc_nop,
    clc_move,               // [[usercmd_t]
    clc_moveNoDelta,        // [[usercmd_t]
    clc_clientCommand,      // [string] message
    clc_EOF,
};
```

Client parses server packet:

```c
void CL_ParseServerMessage( msg_t *msg ) {
    ...
    // One message can have multiple commands?
    while (1) {
        // Read command type from server message 
        cmd = MSG_ReadByte( msg );

        if (cmd == svc_EOF) {
            // The message has been read
            SHOWNET( msg, "END OF MESSAGE" );
            break;
        }

        switch ( cmd ) {
        default:
            Com_Error (ERR_DROP,"CL_ParseServerMessage: Illegible server message");
            break;
        case svc_nop:
            break;
        case svc_serverCommand:
            CL_ParseCommandString( msg );
            break;
        case svc_gamestate:
            CL_ParseGamestate( msg );
            break;
        case svc_snapshot:
            CL_ParseSnapshot( msg );
            break;
        case svc_download:
            CL_ParseDownload( msg );
            break;
        }
        ...
    }
    ...
}
```

Server parse client packet:

```c
void SV_ExecuteClientMessage( client_t *cl, msg_t *msg ) {
	...
    cl->messageAcknowledge = MSG_ReadLong( msg );
    cl->reliableAcknowledge = MSG_ReadLong( msg );

    // read optional clientCommand strings
    do {
        c = MSG_ReadByte( msg );

        if ( c == clc_EOF ) {
            break;
        }

        if ( c != clc_clientCommand ) {
            break;
        }
        if ( !SV_ClientCommand( cl, msg ) ) {
            return; // we couldn't execute it because of the flood protection
        }
        if (cl->state == CS_ZOMBIE) {
            return; // disconnect command
        }
    } while ( 1 );

    // read the usercmd_t
    // this will invoke: SV_ClientThink (cl, &cmds[ i ]) -> vmMain(GAME_CLIENT_THINK)
    if ( c == clc_move ) {
        SV_UserMove( cl, msg, qtrue );
    } else if ( c == clc_moveNoDelta ) {
        SV_UserMove( cl, msg, qfalse );
    } else if ( c != clc_EOF ) {
        Com_Printf( "WARNING: bad command byte for client %i\n", (int) (cl - svs.clients) );
    }
	...
}
```

- How does the client determine which model to display for which entity?

```c
    ent->model = "models/cube.md3"; 
    // TODO: How a model is being loaded?
    // looks like it adds a model to the config string and sends it to client
    // then client loads it.
    ent->s.modelindex = G_ModelIndex( ent->model );
```

- How client events are working (`game/g_active.c`)?

```c
// Events will be passed on to the clients for presentation,
// but any server game effects are handled here
void ClientEvents( gentity_t *ent, int oldEventSequence ) {
    ...
}
```

- How button binding works?

At `client/cl_input.c`:
```c
void IN_KeyDown( kbutton_t *b ) {
...
    b->active = qtrue;
    b->wasPressed = qtrue;
}
...
void IN_Button0Down(void) {IN_KeyDown(&in_buttons[0]);}
void IN_Button0Up(void) {IN_KeyUp(&in_buttons[0]);}
...
Cmd_AddCommand ("+attack", IN_Button0Down);
Cmd_AddCommand ("-attack", IN_Button0Up);

```

```c
// usercmd_t->button bits, many of which are generated by the client system,
// so they aren't game/cgame only definitions
#define BUTTON_ATTACK       1 // bind MOUSE1 "+attack"
#define BUTTON_TALK         2 // displays talk balloon and disables actions
#define BUTTON_USE_HOLDABLE 4 // bind ENTER "+button2"
#define BUTTON_GESTURE      8
#define BUTTON_WALKING      16 
...
```

```c
Com_EventLoop {
    ev = Com_GetEvent
    // case ev.evType == SE_KEY:
    // Called by the system for both key up and key down events
    CL_KeyEvent (int key, qboolean down, unsigned time) {
        // Called by CL_KeyEvent to handle a keypress
        CL_KeyDownEvent( int key, unsigned time ) {
            // send the bound action
            CL_ParseBinding( key, qtrue, time ) {
                // sets cmd_text for the key
                cmd_text = keys[key].binding
            }
        }
    }
}
```

- How command is executed based on `cmd_text`?

At the init state:

```c
Cbuf_Execute () at code/qcommon/cmd.c
Com_ExecuteCfg () at code/qcommon/common.c
Com_Init (commandLine) at code/qcommon/common.c
```

While event loop (frame):

```c
// 1. Read key and parse binding which will set cmd_text for the key
CL_KeyDownEvent (key, time) at code/client/cl_keys.c
CL_KeyEvent (key, down=qtrue, time) at code/client/cl_keys.c
Com_EventLoop () at code/qcommon/common.c
Com_Frame () at code/qcommon/common.c

// 2. Execute cmd_text
// A complete command line has been parsed, so try to execute it
Cmd_ExecuteString( text ) at code/qcommon/cmd.c 
Cbuf_Execute () at code/qcommon/cmd.c
Com_Frame () at code/qcommon/common.c
```

- How `cmd->buttons` is set?

```c
CL_CmdButtons (cmd) at code/client/cl_input.c
CL_CreateCmd () at code/client/cl_input.c
CL_CreateNewCommands () at code/client/cl_input.c
CL_SendCmd () at code/client/cl_input.c
CL_Frame () at code/client/cl_main.c
Com_Frame () at code/qcommon/common.c
```

```c
void CL_CmdButtons( usercmd_t *cmd ) {
    // figure button bits
    // send a button bit even if the key was pressed and released in
    // less than a frame
    for (i = 0 ; i < 15 ; i++) {
        if ( in_buttons[i].active || in_buttons[i].wasPressed ) {
            cmd->buttons |= 1 << i;
        }
        in_buttons[i].wasPressed = qfalse;
    }
    ... 
}
```

- How `pm->cmd` is set?

Server side:

```c
PM_Weapon () at code/game/bg_pmove.c
PmoveSingle (pmove) at code/game/bg_pmove.c
{
    // Update global pm variable now pm->cmd points to the latest usercmd_t
    pm = pmove;
}
Pmove (pmove) at code/game/bg_pmove.c
ClientThink_real (ent) at code/game/g_active.c
{
    // Local player move variable
    pmove_t     pm;
    usercmd_t   *ucmd;

    ucmd = &ent->client->pers.cmd;
    // Set player move properties
    pm.cmd = *ucmd;

    Pmove(&pm);

}
ClientThink (clientNum) at code/game/g_active.c
{
    // Get the usercmd for clientNum
    trap_GetUsercmd( clientNum, &ent->client->pers.cmd );
}
vmMain (command=7 [GAME_CLIENT_THINK], ...) at code/game/g_main.c
VM_Call (vm, callnum=7) at code/qcommon/vm.c
SV_ClientThink (cl, cmd) at code/server/sv_client.c
SV_UserMove (cl, msg, delta=qtrue) at code/server/sv_client.c
SV_ExecuteClientMessage (cl, msg) at code/server/sv_client.c
SV_PacketEvent (from=..., msg) at code/server/sv_main.c
Com_RunAndTimeServerPacket (evFrom, buf) at code/qcommon/common.c
Com_EventLoop () at code/qcommon/common.c
Com_Frame () at code/qcommon/common.c
```

Client side:

```c
PM_Weapon () at code/game/bg_pmove.c
PmoveSingle (pmove) at code/game/bg_pmove.c
{
    // Update global pm variable now pm->cmd points to the latest usercmd_t
    pm = pmove;
}
Pmove (pmove) at code/game/bg_pmove.c
CG_PredictPlayerState () at code/cgame/cg_predict.c
{
    // demo playback just copies the moves
    if ( cg.demoPlayback || (cg.snap->ps.pm_flags & PMF_FOLLOW) ) {
        CG_InterpolatePlayerState( qfalse );
        return;
    }

    // non-predicting local movement will grab the latest angles
    if ( cg_nopredict.integer || cg_synchronousClients.integer ) {
        CG_InterpolatePlayerState( qtrue );
        return;
    }

    // cg_pmove - global var
    trap_GetUserCmd( cmdNum, &cg_pmove.cmd );
    Pmove (&cg_pmove);
}
CG_DrawActiveFrame (serverTime, stereoView=STEREO_CENTER, demoPlayback=qfalse) at code/cgame/cg_view.c
vmMain (command=3 [CG_DRAW_ACTIVE_FRAME], ...) at code/cgame/cg_main.c
VM_Call (vm=, callnum=3) at code/qcommon/vm.c
CL_CGameRendering (stereo=STEREO_CENTER) at code/client/cl_cgame.c
SCR_DrawScreenField (stereoFrame=STEREO_CENTER) at code/client/cl_scrn.c
SCR_UpdateScreen () at code/client/cl_scrn.c
CL_Frame (msec) at code/client/cl_main.c
Com_Frame () at code/qcommon/common.c
```

Generate event from button pressed (e.g. for `+attack`):

```c
// Generates weapon events and modifes the weapon counter
static void PM_Weapon( void ) {
    ... 
    // check for fire
    if ( ! (pm->cmd.buttons & BUTTON_ATTACK) ) {
        return;
    }
    ...
    // fire weapon
    PM_AddEvent( EV_FIRE_WEAPON ) {
        BG_AddPredictableEventToPlayerstate( newEvent, 0, pm->ps );
        // client starts predicted animation immediately
        // server handles player state event EV_FIRE_WEAPON
    }
    ...
}
```

- How Animation works?

```c
TODO: check PM_StartTorsoAnim( TORSO_ATTACK2 );
```

- How Entity Events work?

```c
entity_event_t;

void BG_AddPredictableEventToPlayerstate( int newEvent, int eventParm, playerState_t *ps )
```

- How entities added and interpolated on the client?

Entities position and movers are interpolated here:
```c
CG_CalcEntityLerpPositions (cent) at code/cgame/cg_ents.c
CG_AddCEntity (cent) at code/cgame/cg_ents.c
CG_AddPacketEntities () at code/cgame/cg_ents.c
CG_DrawActiveFrame () at code/cgame/cg_view.c
vmMain (command=3) at code/cgame/cg_main.c
VM_Call (vm, callnum=3) at code/qcommon/vm.c
CL_CGameRendering (stereo=STEREO_CENTER) at code/client/cl_cgame.c
SCR_DrawScreenField (stereoFrame=STEREO_CENTER) at code/client/cl_scrn.c
SCR_UpdateScreen () at code/client/cl_scrn.c
CL_Frame () at code/client/cl_main.c
Com_Frame () at code/qcommon/common.c
```
