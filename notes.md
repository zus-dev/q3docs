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
  `trap_SendServerCommand(-1, va("print \"%s" S_COLOR_WHITE " entered the game\n\"", client->pers.netname));`
  `trap_SendServerCommand(-1, va("cp \"%s" S_COLOR_WHITE " entered the game\n\"", client->pers.netname));`

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

  // the type of event to be triggered (used in AI for determining threat level of object; and in the client to determine model, sounds etc)
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
- How does the client determine which model to display for which entity?
