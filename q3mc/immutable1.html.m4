<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
changequote([*,*])dnl
changecom([*<!--*],[*-->*])dnl
define(ENT_title,Q3A Immutable Structs)dnl
define(TITLE,<h1>$1</h1>)dnl
define(SYNOPSIS,<h2>Synopsis</h2><p>$1</p>)dnl
define(ENT_is,immutable structs)dnl
define(ENT_mod,game module)dnl
define(ENT_client,cgame module)dnl
define(ENT_angbra,[*&lt;*])dnl
define(ENT_angket,[*&gt;*])dnl
define(ENT_amp,[*&amp;*])dnl
define(ENT_authornick,PhaethonH)dnl
define(ENT_authormail,[*PhaethonH@gmail.com*])dnl
define(FILENAME,<tt>$1</tt>)dnl
define(FUNCNAME,<var>$1</var>)dnl
define(VARNAME,<var>$1</var>)dnl
define(CVARNAME,[*VARNAME($1)*])
define(CONSTNAME,<tt>$1</tt>)dnl
define(VERBATIM,<hr><pre>$1</pre><hr>)dnl
define(KEYB,<tt>$1</tt>)dnl
define(_P,<p>$1)dnl
define(TOCLIST,[**])dnl
define(ADDTOC,[*define([*TOCLIST*],TOCLIST
LI(XREF($1,$2)))*])dnl
define(SECT,<h3><a name="$1">$2</a></h3>[*undefine([*_SN*])define(_SN,$1)ADDTOC($1,$2)*])dnl
define(SECT1,<h4>$1</h4>)dnl
define(SECT2,<h5>$1</h5>)dnl
define(QUOT,&quot;$1&quot;)dnl
define(XREF,[*ifelse($2,[**],<a href="#$1">$1</a>,<a href="#$1">$2</a>)*])dnl
define(QV,[*See also <a href="#$1">$1</a>*])dnl quod vide -> "see which"
define(_F,[*<a href="#_SN().$1">$1</a>*])dnl (struct) Field
define(_S,[*<a href="#$1">$1</a>*])dnl (described) Struct
define(LIST_ORDERED,<ol>$1</ol>)dnl
define(LIST_UNORDERED,<ul>$1</ul>)dnl
define(LIST_DICT,<dl>$1</dl>)dnl
define(LI,<li>$1</li>)dnl
define(DT,<dt>$1</dt>)dnl
define(DD,<dd>$1</dd>)dnl
define(DICT,[*DT(<a name="_SN().$1">[*$1*]</a>)DD([*$2*])*])dnl
define(ADDRESS,[*<address>$1</address>*])dnl
define(_LF,[*<br>*])dnl
define(XMIT,[*_LF()Network-transmitted: $1 bits*])dnl
dnl
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>ENT_title</title>
</head>
<body>
TITLE(ENT_title)

SYNOPSIS([*Description of the ENT_is, the structs in FILENAME(q_shared.h) that may not be changed by a ENT_mod, and some of its related constants.*])

SECT(template,Template)
_P([*
blurb
*])

_P([*
VERBATIM([*
/* paste source text here */
*])dnl VERBATIM

LIST_DICT([*
DICT(field,[*description*])
*])dnl LIST_DICT
*])dnl _P


divert(1)
SECT(cplane_t,struct cplane_t)
_P([*
This data type is included in _S(trace_t),
representing information about a collision against/into a surface (such as a wall).
Presumably the detection code is hand-written in assembly for maximum speed.
The prefixing QUOT(c) reflects the QUOT(C version) of this datatype, whereas the QUOT(assembly version) may not have a similar definition (perhaps offsets are all hand-coded?).
*])

_P([*
VERBATIM([*
// plane_t structure
// !!! if this is changed, it must be changed in asm code too !!!
typedef struct cplane_s {
    vec3_t  _F(normal);
    float   _F(dist);
    byte    _F(type);           // for fast side tests: 0,1,2 = axial, 3 = nonaxial
    byte    _F(signbits);       // signx + (signy<<1) + (signz<<2), used as lookup during collision
    byte    _F(pad[2]);
} cplane_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(normal,[*The normal vector of the plane.
One use is to calculate the bouncing vector (direction).
Another is to calculate how QUOT(straight-on) a collision against a wall is.
The spatial position of this vector is indicated by the XREF(trace_t.endpos,endpos) field of _S(trace_t).
*])
DICT(dist,[*
With the normal vector passing through the spatial origin (0, 0, 0), the distance of the plane from the origin along the normal vector.
This is the d component of the general plane equation ax + by + cz = d (or is it ax + by + cz + d = 0?).
Refer to mathematical textbooks on 3D geometry for further information about equations describing planes.
<!-- Thanks djbob -->
*])
DICT(type,[*
0 = plane('s normal vector) is axially aligned on X axis.
1 = plane('s normal vector) is axially aligned on Y axis.
2 = plane('s normal vector) is axially aligned on Z axis.
3 = not aligned with an axis.
This only makes sense for quick QUOT(level/even surface) tests (like walls and floors of a square room).
<!-- Thanks djbob -->
*])
DICT(signbits,[*
Bitmask indicating the signs (positive/negative) of the _F(normal) vector elements.
(XXX: what bit value means negative?)
*])
DICT(pad[2],[*padding space for word alignment purposes.  With this padding space, the size of this struct is the same in a QUOT(packed) and QUOT(unpacked) form.*])
*])dnl LIST_DICT
*])dnl _P()


SECT(trace_t,struct trace_t)
_P([*
This is the data type returned by FUNCNAME(trap_Trace()).
The contained information assists in determining collisions.
*])

_P([*
VERBATIM([*
// a trace is returned when a box is swept through the world
typedef struct {
    qboolean    _F(allsolid);   // if true, plane is not valid
    qboolean    _F(startsolid); // if true, the initial point was in a solid area
    float       _F(fraction);   // time completed, 1.0 = didn't hit anything
    vec3_t      _F(endpos);     // final position
    _S(cplane_t)    _F(plane);      // surface normal at impact, transformed to world space 
    int         _F(surfaceFlags);   // surface hit
    int         _F(contents);   // contents on other side of surface hit
    int         _F(entityNum);  // entity the contacted sirface is a part of
} trace_t;
*])

LIST_DICT([*
DICT(allsolid,[*If true, means both the start and end (and everything in between) of the trace reside within a solid region.  This situation essentially means the trace turned up nothing useful (no collision, or QUOT(collision with self)).*])
DICT(startsolid,[*(If true, means the start of the trace resides in a solid region, but the end of the trace does not... or that there is a spot in between that isn't solid... not sure.*])
DICT(fraction,[*Indicates what fraction of the trace line was consumed to reach this collision.
A value of 1.0 means the complete trace was consumed without turning up a collision.
Values less than 1.0 indicate a collision at a point proportional along the line of trace, with values towards 0.0 meaning near the start, values towards 0.5 meaning near the middle of the trace, and values towards 1.0 meaning near the end of the trace.
*])
DICT(endpos,[*The position of the collision point.
The desired/estimated start and end position of the trace are passed to trap_Trace(); this field indicates the exact point of collision.
*])
DICT(plane,[*(not expanding on comments).  QV(cplane_t).*])
DICT(surfaceFlags,[*Bit flags of CONSTNAME(_S(SURF_*)) constants.*])
DICT(contents,[*Bit flags of CONSTNAME(_S(CONTENTS_*)) constants.*])
DICT(entityNum,[*Value ranges from 0 through CONSTNAME(MAX_GENTITIES)-3 (1021) to indicate collision against a game entity.
The value may also be CONSTNAME(ENTITYNUM_NONE) (1023) to indicate collision against nothing, or CONSTNAME(ENTITYNUM_WORLD) (1022) to indicate collision against something that doesn't belong to a game entity (such as a door)*])
*])dnl LIST_DICT
*])dnl _P


SECT(SURF_*,SURF_* constants)
_P([*
These sets of values are bitmasks indicating a distinct game surface attribute.
Trace collisions detected by FUNCNAME(trap_Trace()) determine the surface attributes where the collision ends.
The ENT_mod may respond to each distinct surface type.
XXX: don't know about adding new SURF constants
*])

VERBATIM([*
#define _F(SURF_NODAMAGE)      0x1      // never give falling damage
#define _F(SURF_SLICK)         0x2      // effects game physics
#define _F(SURF_SKY)           0x4      // lighting from environment map
#define _F(SURF_LADDER)        0x8
#define _F(SURF_NOIMPACT)      0x10     // don't make missile explosions
#define _F(SURF_NOMARKS)       0x20     // don't leave missile marks
#define _F(SURF_FLESH)         0x40     // make flesh sounds and effects
#define _F(SURF_NODRAW)        0x80     // don't generate a drawsurface at all
#define _F(SURF_HINT)          0x100    // make a primary bsp splitter
#define _F(SURF_SKIP)          0x200    // completely ignore, allowing non-closed brushes
#define _F(SURF_NOLIGHTMAP)    0x400    // surface doesn't need a lightmap
#define _F(SURF_POINTLIGHT)    0x800    // generate lighting info at vertexes
#define _F(SURF_METALSTEPS)    0x1000   // clanking footsteps
#define _F(SURF_NOSTEPS)       0x2000   // no footstep sounds
#define _F(SURF_NONSOLID)      0x4000   // don't collide against curves with this set
#define _F(SURF_LIGHTFILTER)   0x8000   // act as a light filter during q3map -light
#define _F(SURF_ALPHASHADOW)   0x10000  // do per-pixel light shadow casting in q3map
#define _F(SURF_NODLIGHT)      0x20000  // don't dlight even if solid (solid lava, skies)
#define _F(SURF_DUST)          0x40000  // leave a dust trail when walking on this surface
*])dnl VERBATIM

dnl LIST_DICT([*
dnl *])dnl LIST_DICT


SECT(CONTENTS_*,CONTENTS_* constants)
_P([*
These constants indicate attributes for the QUOT(insides) or QUOT(volume) of a model (map, player, entity), such as a trigger.
In contrast, the CONSTNAME(SURF_*) constants describe the faces (surface) of a model.
XXX: significance in bounding boxes?
*])

VERBATIM([*
#define _F(CONTENTS_SOLID)          1       // an eye is never valid in a solid
#define _F(CONTENTS_LAVA)           8
#define _F(CONTENTS_SLIME)          16
#define _F(CONTENTS_WATER)          32
#define _F(CONTENTS_FOG)            64

#define _F(CONTENTS_AREAPORTAL)     0x8000

#define _F(CONTENTS_PLAYERCLIP)     0x10000
#define _F(CONTENTS_MONSTERCLIP)    0x20000
//bot specific contents types
#define _F(CONTENTS_TELEPORTER)     0x40000
#define _F(CONTENTS_JUMPPAD)        0x80000
#define _F(CONTENTS_CLUSTERPORTAL)  0x100000
#define _F(CONTENTS_DONOTENTER)     0x200000
#define _F(CONTENTS_BOTCLIP)        0x400000
#define _F(CONTENTS_MOVER)          0x800000

#define _F(CONTENTS_ORIGIN)         0x1000000   // removed before bsping an entity

#define _F(CONTENTS_BODY)           0x2000000   // should never be on a brush, only in game
#define _F(CONTENTS_CORPSE)         0x4000000
#define _F(CONTENTS_DETAIL)         0x8000000   // brushes not used for the bsp
#define _F(CONTENTS_STRUCTURAL)     0x10000000  // brushes used for the bsp
#define _F(CONTENTS_TRANSLUCENT)    0x20000000  // don't consume surface fragments inside
#define _F(CONTENTS_TRIGGER)        0x40000000
#define _F(CONTENTS_NODROP)         0x80000000  // don't leave bodies or items (death fog, lava)
*])dnl VERBATIM

dnl LIST_DICT([*
dnl *])dnl LIST_DICT


SECT(playerState_t,struct playerState_t)
_P([*
One copy of this data type resides on the client side for client purposes, and another copy resides on the server for the QUOT(true) data.
This data type is transmitted over network to a player describing his/her/its state according to the server, that is, the player's QUOT(actual state).
No other player receives the _SN of another player.
The server constantly sends these _SN packets to their respective players.
In a network multiplayer game, the nature of the network introduces delays (ping lag) in the packets.
As a result, the client side may utilize movement prediction upon its local copy of the _SN information to present a smoother view to the gamer, while waiting for the QUOT(true) server's information to arrive.
When the server's packet arrives, the client game then attempts to resolve the predicted _SN information with the received server's _SN information.
*])

_P([*
VERBATIM([*
typedef struct playerState_s {
    int         _F(commandTime);    // cmd->serverTime of last executed command
    int         _F(pm_type);
    int         _F(bobCycle);       // for view bobbing and footstep generation
    int         _F(pm_flags);       // ducked, jump_held, etc
    int         _F(pm_time);

    vec3_t      _F(origin);
    vec3_t      _F(velocity);
    int         _F(weaponTime);
    int         _F(gravity);
    int         _F(speed);
    int         _F(delta_angles[3]);    // add to command angles to get view direction
                                    // changed by spawns, rotating objects, and teleporters

    int         _F(groundEntityNum);// ENTITYNUM_NONE = in air

    int         _F(legsTimer);      // don't change low priority animations until this runs out
    int         _F(legsAnim);       // mask off ANIM_TOGGLEBIT

    int         _F(torsoTimer);     // don't change low priority animations until this runs out
    int         _F(torsoAnim);      // mask off ANIM_TOGGLEBIT

    int         _F(movementDir);    // a number 0 to 7 that represents the reletive angle
                                // of movement to the view angle (axial and diagonals)
                                // when at rest, the value will remain unchanged
                                // used to twist the legs during strafing

    vec3_t      _F(grapplePoint);   // location of grapple to pull towards if PMF_GRAPPLE_PULL

    int         _F(eFlags);         // copied to entityState_t->eFlags

    int         _F(eventSequence);  // pmove generated events
    int         _F(events[MAX_PS_EVENTS]);
    int         _F(eventParms[MAX_PS_EVENTS]);

    int         _F(externalEvent);  // events set on player from another source
    int         _F(externalEventParm);
    int         _F(externalEventTime);

    int         _F(clientNum);      // ranges from 0 to MAX_CLIENTS-1
    int         _F(weapon);         // copied to entityState_t->weapon
    int         _F(weaponstate);

    vec3_t      _F(viewangles);     // for fixed views
    int         _F(viewheight);

    // damage feedback
    int         _F(damageEvent);    // when it changes, latch the other parms
    int         _F(damageYaw);
    int         _F(damagePitch);
    int         _F(damageCount);

    int         _F(stats[MAX_STATS]);
    int         _F(persistant[MAX_PERSISTANT]); // stats that aren't cleared on deat
h
    int         _F(powerups[MAX_POWERUPS]); // level.time that the powerup runs out
    int         _F(ammo[MAX_WEAPONS]);

    int         _F(generic1);
    int         _F(loopSound);
    int         _F(jumppad_ent);    // jumppad entity hit this frame

    // not communicated over the net at all
    int         _F(ping);           // server to game info for scoreboard
    int         _F(pmove_framecount);   // FIXME: don't transmit over the network
    int         _F(jumppad_frame);
    int         _F(entityEventSequence);
} playerState_t;

*])dnl VERBATIM

LIST_DICT([*
DICT(commandTime,[*Server timestamp.
Due to the nature of UDP/IP (network protocol used by Q3A), packets may arrive out of order.
Timestamping assists in sorting out the packets.
Also, it gives the client a very good idea of how much game time has passed.
(XXX: what is the epoch?  Server start?  Game start?  OS time?)
*])
DICT(pm_type,[*
A predictable movement type.
This helps the client predict what kind of motions would be allowed;
on the server side, this dictates what kinds of motions are allowed.
QV(PM_*,PM_* constants).
*])
DICT(bobCycle,[*
Used for timing footsteps sounds.
*])
DICT(pm_flags,[*
Bitmask flags for movement calculations (predictions on client-side).
QV(PMF_*,PMF_* constants).
*])
DICT(pm_time,[*
An associated time value for movement calculations (predictions on client-side).
*])
DICT(origin,[*Vector describing the player's position in the game world.*])
DICT(velocity,[*Vector describing the player's instant velocity in the game world.*])
DICT(weaponTime,[*Number of milliseconds to pass before _F(weaponstate) may change.  Reduced per game frame, _F(weaponstate) changes when weaponTime reaches 0.  (XXX: mention the state-transitioning function)*])
DICT(gravity,[*
Gravity effect upon the player.
While the initial value is retrieved from cvar CVARNAME(g_gravity), this field can be assigned a different value for some kind of QUOT(individual gravity force) effect.
On the client side, this is used to predict gravity-induced acceleration.
*])
DICT(speed,[*
Player's running speed.
XXX: that was helpful...
*])
DICT(delta_angles[3],[*If the server had to force a change in viewing angle for some reason (teleporter, respawning, etc.), this field indicates the amount of adjustment to the client's reported viewangle.
This means, should the server not require adjusting the view angle, this field remains zeroed out as ENT_angbra 0, 0, 0 ENT_angket.*])
DICT(groundEntityNum,[*Entity number of whatever the player is standing upon.
CONSTNAME(ENTITY_NONE) if not standing (airborne, swimming).*])
DICT(legsTimer,[*
Time remaining in current leg animation frame.
*])
DICT(legsAnim,[*
Current leg animation frame number.
*])
DICT(torsoTimer,[*
Time remaining in current torso animation frame.
*])
DICT(torsoAnim,[*
Current torso animation frame number.
*])
DICT(movementDir,[*
Something about rotating the legs relative to the face for the strafe motions.
(PM_SetMovementDir())
*])
DICT(grapplePoint,[*Vector describing the position of the latched grappling hook pulling the player.*])
DICT(eFlags,[*Entity flags.
The _S(EF_*) constants.
*])
DICT(eventSequence,[*
Offset into _F(events[MAX_PS_EVENTS]) and _F(eventParms[MAX_PS_EVENTS])...
(XXX: next to be used, just used?)
*])
DICT(events[MAX_PS_EVENTS],[*
Array of CONSTNAME(MAX_PS_EVENTS) (2) elements to hold predictable events generated by the player (???).
*])
DICT(eventParms[MAX_PS_EVENTS],[*
Array of CONSTNAME(MAX_PS_EVENTS) (2) elements to hold parameters to the events in _F(events[MAX_PS_EVENTS]).
*])
DICT(externalEvent,[*???*])
DICT(externalEventParm,[*???*])
DICT(externalEventTime,[*???*])
DICT(clientNum,[*Client number of the player.  Ranges from 0 to CONSTNAME(MAX_CLIENTS) (63).*])
DICT(weapon,[*Currently wielded weapon.  Server uses this field to tell the client what weapon is actually in use.  The client requests a change of weapon with the VARNAME(weapon) field of a usercmd_t packet.*])
DICT(weaponstate,[*State of the weapon: CONSTNAME(WEAPON_READY), CONSTNAME(WEAPON_FIRING), CONSTNAME(WEAPON_RELOADING), CONSTNAME(WEAPON_DROPPING), CONSTNAME(WEAPON_RAISING).*])
DICT(viewangles,[*???*])
DICT(viewheight,[*???*])
DICT(damageEvent,[*
Incremented each time player takes damage.
(XXX: seems silly to track this.  Maybe more significance in cgame?)
*])
DICT(damageYaw,[*Viewing direction (left/right component) from which the player got hit.*])
DICT(damagePitch,[*Viewing direction (up/down component) from which the player got hit.*])
DICT(damageCount,[*
Damage amount (hitpoints).
*])
DICT(stats[MAX_STATS],[*Array of CONSTNAME(MAX_STATS) (16) elements of CONSTNAME(STAT_*) fields.
QV(STAT_*,STAT_* stats elements).
*])
DICT(persistant[MAX_PERSISTANT],[*Array of CONSTNAME(MAX_PERSISTANT) (16) elemets of CONSTNAME(PERS_*) fields.
QV(PERS_*,PERS_* persistant elements).
*])
DICT(powerups[MAX_POWERUPS],[*Array of CONSTNAME(MAX_POWERUPS) (16) elements of CONSTNAME(PW_*) fields.
QV(PW_*,PW_* powerup elements).
*])
DICT(ammo[MAX_WEAPONS],[*Array of CONSTNAME(MAX_WEAPONS) (16) elements of ammo counts.
Each element corresponds to one ammo type: (undefined), gauntlet, bullets, shells, grenades, rockets, lightning, railslugs, cells, bfg.
Each ammo type corresponds to one weapon type in baesq3.
QV(WP_*,WP_* weapons).
*])
DICT(generic1,[*
For Q3TA harvester game, number of thingies (cubes?) you're carrying?
*])
DICT(loopSound,[*Sound index into CONSTNAME(CS_SOUNDS) configstring to play in a loop. XXX*])
DICT(jumppad_ent,[*???*])
DICT(ping,[*ping value?  Is this even sent over the network?*])
DICT(pmove_framecount,[*???*])
DICT(jumppad_frame,[*???*])
DICT(entityEventSequence,[*???*])
*])dnl LIST_DICT
*])dnl _P


SECT(PM_*,PM_* constants)
_P([*
Predictable movement types.
Determines what types of movements are allowed and how to react to user movement input.
Constants listed for context for _S(playerState_t.pm_type).
*])

_P([*
VERBATIM([*
typedef enum {
    PM_NORMAL,      // can accelerate and turn
    PM_NOCLIP,      // noclip movement
    PM_SPECTATOR,   // still run into walls
    PM_DEAD,        // no acceleration or turning, but free falling
    PM_FREEZE,      // stuck in place with no control
    PM_INTERMISSION,    // no movement or status bar
    PM_SPINTERMISSION   // no movement or status bar
} pmtype_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(,[**])
*])dnl LIST_DICT
*])dnl _P


SECT(PMF_*,PMF_* constants)
_P([*
Predictable movement flags.
Various bitmasks to indicate additional movement prediction parameters.
Listed here for context for _S(playerState_t.pm_flags).
*])

_P([*
VERBATIM([*
// pmove->pm_flags
#define PMF_DUCKED          0x0001 //1
#define PMF_JUMP_HELD       0x0002 //2
//                            0x0004 //4
#define PMF_BACKWARDS_JUMP  0x0008 //8      // go into backwards land
#define PMF_BACKWARDS_RUN   0x0010 //16     // coast down to backwards run
#define PMF_TIME_LAND       0x0020 //32     // pm_time is time before rejump
#define PMF_TIME_KNOCKBACK  0x0040 //64     // pm_time is an air-accelerate only time
//                            0x0080 //128
#define PMF_TIME_WATERJUMP  0x0100 //256        // pm_time is waterjump
#define PMF_RESPAWNED       0x0200 //512        // clear after attack and jump buttons come up
#define PMF_USE_ITEM_HELD   0x0400 //1024
#define PMF_GRAPPLE_PULL    0x0800 //2048   // pull towards grapple location
#define PMF_FOLLOW          0x1000 //4096   // spectate following another player
#define PMF_SCOREBOARD      0x2000 //8192   // spectate as a scoreboard
#define PMF_INVULEXPAND     0x4000 //16384  // invulnerability sphere set to full size

#define PMF_ALL_TIMES   (PMF_TIME_WATERJUMP|PMF_TIME_LAND|PMF_TIME_KNOCKBACK)
*])dnl VERBATIM

LIST_DICT([*
DICT(,[**])
*])dnl LIST_DICT
*])dnl _P


SECT(STAT_*,STAT_* stats elements)
_P([*
Array of 16 elements.
Each array element has a unique ENT_mod-defined meaning.
Also, only the low 16 bits of each element is transmitted over network.
(XXX: expanded to 32 bits since 1.31?)
*])
_P([*
Elements typically hold values the pertain to one particular life (i.e. until player is fragged).
The ENT_mod zeroes out the entire stats[] array at each respawn (this action can be modified in the game module).
*])

_P([*
VERBATIM([*
// player_state->stats[] indexes
// NOTE: may not have more than 16
typedef enum {
    _F(STAT_HEALTH),
    _F(STAT_HOLDABLE_ITEM),
#ifdef MISSIONPACK
    STAT_PERSISTANT_POWERUP,
#endif
    _F(STAT_WEAPONS),                   // 16 bit fields
    _F(STAT_ARMOR),
    _F(STAT_DEAD_YAW),                  // look this direction when dead (FIXME: get
 rid of?)
    _F(STAT_CLIENTS_READY),             // bit mask of clients wishing to exit the i
ntermission (FIXME: configstring?)
    _F(STAT_MAX_HEALTH)                 // health / armor limit, changable by handic
ap
} statIndex_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(STAT_HEALTH,[*
0 - the player's health value.
*])
DICT(STAT_HOLDABLE_ITEM,[*
1 - the holdable item (if any) that the player possesses.
QV(HI_*,HI_* holdable items).
*])
DICT(STAT_WEAPONS,[*
2 - bitmask of weapons the player is carrying.
*])
DICT(STAT_ARMOR,[*
3 - player's armor value.
*])
DICT(STAT_DEAD_YAW,[*
4 - um.  this is kinda weird.
*])
DICT(STAT_CLIENTS_READY,[*
5 - Bitmask of clients that are QUOT(READY), at intermission. (XXX: obsoleted by a configstring?)
*])
DICT(STAT_MAX_HEALTH,[*
6 - Maximum health value.
*])
*])dnl LIST_DICT
*])dnl _P


SECT(HI_*,HI_* holdable items)
_P([*
Values for holdable items for XREF(STAT_*.STAT_HOLDABLE_ITEM,STAT_HOLDABLE_ITEM)
 element of _S(playerState_t.stats[MAX_STATS]) field of _S(playerState_t).
Holdable items are items a player may carry and optionally use (baseq3 uses +button2 to indicate item use).
*])

_P([*
VERBATIM([*
typedef enum {
    _F(HI_NONE),

    _F(HI_TELEPORTER),
    _F(HI_MEDKIT),
    _F(HI_KAMIKAZE),
    _F(HI_PORTAL),
    _F(HI_INVULNERABILITY),

    HI_NUM_HOLDABLE
} holdable_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(HI_NONE,[*
0 - Dummy item, indicates no item.
*])
DICT(HI_TELEPORTER,[*
1 - Personal teleporter; upon use, player is transported to a random spawn location.
*])
DICT(HI_MEDKIT,[*
2 - Medkit; upon use, player receives an instant health boost of 60, if at less than 100 health.
The actual boost value is determined by the QUOT(count) field of the medkit's item description in bg_itemlist[].
*])
DICT(HI_KAMIKAZE,[*
3 - Kamikaze; upon use, the item creates a huge explosion (not a huge wind, despite the name), killing the carrier and surrounding players.
If the player is fragged, the item automatically detonates of its own accord after 5 seconds, unless the player's body is gibbed.
*])
DICT(HI_PORTAL,[*
4 - ???
*])
DICT(HI_INVULNERABILITY,[*
5 - Invulnerability; upon use, an invulnerability sphere surrounds the player, protecting the player from all damages, while the player may continue shooting at everyone else, but unable to move in any direction at all.
The invulnerabilty is limited by a timer in the XREF(PW_*.PW_INVULNERABILITY,PW_INVULNERABILITY) field of _S(playerState_t.powerups[MAX_POWERUPS]).
*])
*])dnl LIST_DICT
*])dnl _P


SECT(PERS_*,PERS_* persistant elements)
_P([*
Array of 16 elements holding data that persists across deaths.
Of particular note, baseq3 already uses 15 elements, leaving only one unused element for a mod.
Still, the mod may change the purpose of any element except the first.
*])

_P([*
VERBATIM([*
// player_state->persistant[] indexes
// these fields are the only part of player_state that isn't
// cleared on respawn
// NOTE: may not have more than 16
typedef enum {
    _F(PERS_SCORE),                     // !!! MUST NOT CHANGE, SERVER AND GAME BOTH REFERENCE !!!
    _F(PERS_HITS),                      // total points damage inflicted so damage beeps can sound on change
    _F(PERS_RANK),                      // player rank or team rank
    _F(PERS_TEAM),                      // player team
    _F(PERS_SPAWN_COUNT),               // incremented every respawn
    _F(PERS_PLAYEREVENTS),              // 16 bits that can be flipped for events
    _F(PERS_ATTACKER),                  // clientnum of last damage inflicter
    _F(PERS_ATTACKEE_ARMOR),            // health/armor of last person we attacked
    _F(PERS_KILLED),                    // count of the number of times you died
    // player awards tracking
    _F(PERS_IMPRESSIVE_COUNT),          // two railgun hits in a row
    _F(PERS_EXCELLENT_COUNT),           // two successive kills in a short amount of time
    _F(PERS_DEFEND_COUNT),              // defend awards
    _F(PERS_ASSIST_COUNT),              // assist awards
    _F(PERS_GAUNTLET_FRAG_COUNT),       // kills with the guantlet
    _F(PERS_CAPTURES)                   // captures
} persEnum_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(PERS_SCORE,[*
0 - Player score.
The Q3 engine also expects the first element to be the player score,
thus the ENT_mod should not try to change the meaning of this element.
This field is transmitted in server queries, for the "score" fields of players.
*])
DICT(PERS_HITS,[*
1
*])
DICT(PERS_RANK,[*
2
*])
DICT(PERS_TEAM,[*
3
*])
DICT(PERS_SPAWN_COUNT,[*
4
*])
DICT(PERS_PLAYEREVENTS,[*
5
XXX: what are the bits?
*])
DICT(PERS_ATTACKER,[*
6
*])
DICT(PERS_ATTACKEE_ARMOR,[*
7
*])
DICT(PERS_KILLED,[*
8
*])
DICT(PERS_IMPRESSIVE_COUNT,[*
9
*])
DICT(PERS_EXCELLENT_COUNT,[*
10
*])
DICT(PERS_DEFEND_COUNT,[*
11
*])
DICT(PERS_ASSIST_COUNT,[*
12
*])
DICT(PERS_GAUNTLET_FRAG_COUNT,[*
13
*])
DICT(PERS_CAPTURES,[*
14
*])
*])dnl LIST_DICT
*])dnl _P


SECT(PW_*,PW_* powerups elements)
_P([*
Values for powerup items for _S(playerState_t.powerups[MAX_POWERUPS]) field of _S(playerState_t).
Powerups are effective for a limited time, and may be dropped (such as due to fragging) with a partial timer value left.
*])

_P([*
VERBATIM([*
// NOTE: may not have more than 16
typedef enum {
    _F(PW_NONE),

    _F(PW_QUAD),
    _F(PW_BATTLESUIT),
    _F(PW_HASTE),
    _F(PW_INVIS),
    _F(PW_REGEN),
    _F(PW_FLIGHT),

    _F(PW_REDFLAG),
    _F(PW_BLUEFLAG),
    _F(PW_NEUTRALFLAG),

    _F(PW_SCOUT),
    _F(PW_GUARD),
    _F(PW_DOUBLER),
    _F(PW_AMMOREGEN),
    _F(PW_INVULNERABILITY),

    PW_NUM_POWERUPS

} powerup_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(PW_NONE,[*
0 - Dummy powerup, indicating no powerup.
*])
DICT(PW_QUAD,[*
1 - Quad damage; player weapons do extra damage according to cvar CVARNAME(g_quaddamage) (default 3).
*])
DICT(PW_BATTLESUIT,[*
2 - Battle/Environment suit; protects player against splash and environment (lava, acid, drowning) damage.
*])
DICT(PW_HASTE,[*
3 - Haste; player moves and fires 30% faster.
If also Scout, Scout takes precedence (i.e. no speeding to 80%).
*])
DICT(PW_INVIS,[*
4 - Invisibility; player appears almost invisible.
*])
DICT(PW_REGEN,[*
5 - Regeneration; player continually regains health.
*])
DICT(PW_FLIGHT,[*
6 - Flight; gravity does not affect player, who can in fact freely move up or down.
*])
DICT(PW_REDFLAG,[*
7 - The red flag; player is carrying the red flag.
*])
DICT(PW_BLUEFLAG,[*
8 - The blue flag; player is carrying the blue flag.
*])
DICT(PW_NEUTRALFLAG,[*
9 - The white flag; player is carrying the white flag (one-flag CTF)
*])
DICT(PW_SCOUT,[*
10 - Scout (persistant powerup, Team Arena only); player moves and fires 50% faster.
If player also has Haste, Scout takes precedence (i.e. no speeding to +80%).
*])
DICT(PW_GUARD,[*
11 - Guard (non-expiring powerup, Team Arena only); player receives half damage.
*])
DICT(PW_DOUBLER,[*
12 - Doubler (non-expiring powerup, Team Arena only); player weapons do double damage.
*])
DICT(PW_AMMOREGEN,[*
13 - Ammo Regen (non-expiring powerup, Team Arena only); player ammo counts slowly increment.
*])
DICT(PW_INVULNERABILITY,[*
14 - Invulnerability (Team Arena only); expiration time for invulnerability sphere.
Invulnerability is a XREF([*HI_*.HI_INVULNERABILITY*],holdable item); using the item sets this field as the invulnerability timer.
*])
*])dnl LIST_DICT
*])dnl _P


SECT(WP_*,WP_* weapons)
_P([*
These values indicate a weapon.
The same values are also used as the index into _S(playerState_t.ammo[MAX_WEAPONS]) for the weapon's corresponding ammo count.
*])

_P([*
VERBATIM([*
typedef enum {
    _F(WP_NONE),

    _F(WP_GAUNTLET),
    _F(WP_MACHINEGUN),
    _F(WP_SHOTGUN),
    _F(WP_GRENADE_LAUNCHER),
    _F(WP_ROCKET_LAUNCHER),
    _F(WP_LIGHTNING),
    _F(WP_RAILGUN),
    _F(WP_PLASMAGUN),
    _F(WP_BFG),
    _F(WP_GRAPPLING_HOOK),
#ifdef MISSIONPACK
    _F(WP_NAILGUN),
    _F(WP_PROX_LAUNCHER),
    _F(WP_CHAINGUN),
#endif

    WP_NUM_WEAPONS
} weapon_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(WP_NONE,[*
0 - Dummy weapon, used to indicate no weapon.*])
DICT(WP_GAUNTLET,[*
1 - Gauntlet.*])
DICT(WP_MACHINEGUN,[*
2 - Machine gun.*])
DICT(WP_SHOTGUN,[*
3 - Shotgun.*])
DICT(WP_GRENADE_LAUNCHER,[*
4 - Grenade Launcher.*])
DICT(WP_ROCKET_LAUNCHER,[*
5 - Rocket Launcher.*])
DICT(WP_LIGHTNING,[*
6 - Lightning Gun.*])
DICT(WP_RAILGUN,[*
7 - Railgun.*])
DICT(WP_PLASMAGUN,[*
8 - Plasma Gun.*])
DICT(WP_BFG,[*
9 - BFG10000 (BFG10K).*])
DICT(WP_GRAPPLING_HOOK,[*
10 - Grappling hook.*])
DICT(WP_NAILGUN,[*
11 - Nail Gun (Team Arena only).*])
DICT(WP_PROX_LAUNCHER,[*
12 - Proximity Mine Launcher (Team Arena only).*])
DICT(WP_CHAINGUN,[*
13 - Chaingun (Team Arena only).*])
*])dnl LIST_DICT
*])dnl _P


SECT(usercmd_t,struct usercmd_t)
_P([*
If you can imagine trying to compress the gamer's input into a simplified arcade joystick interface, you would have a good idea what usercmd_t is about.
The usercmd_t packets travel only from client to server, and is the means by which the server determines the will of the player's avatar in the server's notion of the world.
The size of usercmd_t is notably small.
This helps to reduce the impact of ping lag, and also helps reduces the total amount of incoming network traffic for the server (all connected clients are sending a usercmd_t).
*])
_P([*
The construction and transmission of the usercmd_t data occurs inside the client-side Q3 engine, meaning the ENT_client cannot directly fabricate the data.
The ENT_client may still indirectly alter the usercmd_t data by using the various game commands (e.g. "+forward", "+attack", "-gesture"), via FUNCNAME(trap_SendConsoleCommand()).
*])

_P([*
VERBATIM([*
// usercmd_t is sent to the server each client frame
typedef struct usercmd_s {
    int             _F(serverTime);
    int             _F(angles[3]);
    int             _F(buttons);
    byte            _F(weapon);           // weapon
    signed char _F(forwardmove), _F(rightmove), _F(upmove);
} usercmd_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(serverTime,[*A timestamp.
The nature of UDP/IP (the network protocol used by Q3) may wind up sending QUOT(later) packets sooner than QUOT(earlier) packets.
Timestamping helps sort out this potential temporal mixup.
The value written here by the client is based on the timestamp value the client last received in a XREF(playerState_t,playerState_t) packet.
To prevent QUOT(time-shifting) cheats, the server-side runs some primitive sanity checking on the timestamp (+/-500ms).
XMIT(32).
*])
DICT(angles,[*The view (and thus aiming) direction of the client.
Since this value is reported as an absolute (rather than relative change with a rate cap, as with running), a client may snap towards any (other) direction instantly.
XMIT(32*3)?
*])
DICT(buttons,[*
Bitmask of 16 bits reflectiong the CONSTNAME(BUTTON_*) constants.
These correspond to KEYB(+button<i>N</i>) commands.
The lowest bit (bit 0) corresponds to "+button0" (alias "+attack").
With 16 bits, this relationship goes up to "+button15".
A bit value of 1 indicates button is held (+button), and 0 indicates button is released (-button).
XMIT(16).
*])
DICT(weapon,[*Indicates the weapon the client wishes to wield.
This is the method by which the client informs the server of a weapon switch.
If the new weapon choice is invalid for some reason (not in possession, value out of range, player is dead), the server can force a switch to another weapon (on the server side) and report back this change in a XREF(playerState_t) packet.
XMIT(8).
*])
DICT(forwardmove,[*
??? Related to KEYB(+forward) and KEYB(+back).
XMIT(8?).
*])
DICT(rightmove,[*??? Related to KEYB(+moveleft) and KEYB(+moveright).
XMIT(8?).
*])
DICT(upmove,[*??? Related to KEYB(+moveup) and KEYB(+movedown).
XMIT(8?).
*])
*])dnl LIST_DICT
*])dnl _P


SECT(trajectory_t,struct trajectory_t)
_P([*
This data type holds information related to recording the movement of an entity as well as calculating the near-future position (prediction) of the entity.
A QUOT(trajectory model) is selected, and the parameters to the model recorded in the struct.
*])

_P([*
VERBATIM([*
typedef struct {
    trType_t    _F(trType);
    int     _F(trTime);
    int     _F(trDuration);         // if non 0, trTime + trDuration = stop time
    vec3_t  _F(trBase);
    vec3_t  _F(trDelta);            // velocity, etc
} trajectory_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(trType,[*Trajectory path model.
QV(trType_t)
XMIT(8).
*])
DICT(trTime,[*Start time of this path model, in gametime milliseconds (ms).
(tip: on server side, gametime milliseconds is stored in level.time)
XMIT(32).
*])
DICT(trDuration,[*How much elapsed time to spend in this path model, in milliseconds.
Stop time is derived by adding trTime and trDuration.
XMIT(32).
*])
DICT(trBase,[*Initial position at start time.
XMIT(32*3).
*])
DICT(trDelta,[*Vector describing the next frame of movement.
XMIT(32*3).
*])
*])dnl LIST_DICT
*])dnl _P


SECT(trType_t,enum trType_t)
_P([*
Set of constants describing a trajectory model (predictable path).
Most entities follow a movement pattern that is mostly predictable, until it collides with another entity.
Even then, the effects of the collision tends to remain predictable (it explodes, it bounces, it stops, etc.).
The server tells the client what movement pattern, or QUOT(trajectory model), an entity is using, so that the client can make educated predictions.
*])

_P([*
VERBATIM([*
typedef enum {
    _F(TR_STATIONARY),
    _F(TR_INTERPOLATE),             // non-parametric, but interpolate between snapshots
    _F(TR_LINEAR),
    _F(TR_LINEAR_STOP),
    _F(TR_SINE),                    // value = base + sin( time / duration ) * delta
    _F(TR_GRAVITY)
} trType_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(TR_STATIONARY,[*No movement.
The entity does not move, client-side prediction does not change position.*])
DICT(TR_INTERPOLATE,[*
Interpolated movement.
Non-predictable, but client still figures out intermediate positions (interpolates) for smoother movement.
*])
DICT(TR_LINEAR,[*Linear movement, as with rockets, plasma gun, and BFG10K.
 LIST_UNORDERED([*
 LI(trBase - [*Starting position used to predict location.*])
 LI(trTime - [*Time spent in movement.*])
 LI(trDelta - [*Velocity vector.*])
 *])dnl LIST_UNORDERED
*])
DICT(TR_LINEAR_STOP,[*Linear movement with predictable stop time?*])
DICT(TR_SINE,[*Sinusoidal movement (sine wave).
Movement occurs along trDelta; scalar multiplication of vector trDelta with sine values.
 LIST_UNORDERED([*
 LI(trBase - [*Starting position used to predict location.*])
 LI(trDuration - [*Time of one cycle; frequency component*])
 LI(trTime - [*Phase offset.*])
 LI(trDelta - [*Amplitude.*])
 *])dnl LIST_UNORDERED
*])
DICT(TR_GRAVITY,[*Gravity-influenced movement, as with grenades.
Acceleration force is always straight down, with magnitude CONSTNAME(DEFAULT_GRAVITY) (800) (defined in bg_public.h).
 LIST_UNORDERED([*
 LI(trBase - [*Starting position used to predict location.*])
 LI(trTime - [*Time spent in movement.*])
 LI(trDelta - [*Initial velocity used to predict location.*])
 *])dnl LIST_UNORDERED
*])
*])dnl LIST_DICT
*])dnl _P


SECT(entityState_t,struct entityState_t)
_P([*
All entities in the game has an associated entityState_t data.
While the game may have up to CONSTNAME(MAX_GENTITIES) (1024) of such data records, each client only receives the entityState_t information of entities within its PVS (Potential Visibility Set), as determined by the Q3 engine.
Any client may receive the entityState_t information of any entity, including itself.
This receiving is in contrast to XREF(playerState_t) information, which is only sent to its respective client.
*])
_P([*
While the comments in the source say structure size does not matter, any changes to this struct in the ENT_mod source will have no effect unless the same changes are made in the Q3 engine source.
As of the time of this writing, only a select few in the world have such access.
*])

_P([*
VERBATIM([*
// entityState_t is the information conveyed from the server
// in an update message about entities that the client will
// need to render in some way
// Different eTypes may use the information in different ways
// The messages are delta compressed, so it doesn't really matter if
// the structure size is fairly large

typedef struct entityState_s {
    int     _F(number);         // entity index
    int     _F(eType);          // entityType_t
    int     _F(eFlags);

    _S(trajectory_t)    _F(pos);    // for calculating position
    _S(trajectory_t)    _F(apos);   // for calculating angles

    int     _F(time);
    int     _F(time2);

    vec3_t  _F(origin);
    vec3_t  _F(origin2);

    vec3_t  _F(angles);
    vec3_t  _F(angles2);

    int     _F(otherEntityNum); // shotgun sources, etc
    int     _F(otherEntityNum2);

    int     _F(groundEntityNum);    // -1 = in air

    int     _F(constantLight);  // r + (g<<8) + (b<<16) + (intensity<<24)
    int     _F(loopSound);      // constantly loop this sound

    int     _F(modelindex);
    int     _F(modelindex2);
    int     _F(clientNum);      // 0 to (MAX_CLIENTS - 1), for players and corpses
    int     _F(frame);

    int     _F(solid);          // for client side prediction, trap_linkentity sets this properly

    int     _F(event);          // impulse events -- muzzle flashes, footsteps, etc
    int     _F(eventParm);

    // for players
    int     _F(powerups);       // bit flags
    int     _F(weapon);         // determines weapon and flash model, etc
    int     _F(legsAnim);       // mask off ANIM_TOGGLEBIT
    int     _F(torsoAnim);      // mask off ANIM_TOGGLEBIT

    int     _F(generic1);
} entityState_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(number,[*Entity number.  Value ranges from 0 through CONSTNAME(MAX_GENTITIES)-1 (1023).
XMIT(10?).
*])
DICT(eType,[*Entity type.  QV(entityType_t)  XMIT(?).*])
DICT(eFlags,[*Entity flags, the _S(EF_*) constants.
XMIT(19).*])
DICT(pos,[*Entity positional trajectory.  Used to predict movement.
XMIT(See XREF(trajectory_t,trajectory_t)).
*])
DICT(apos,[*Entity angular trajectory.  Used to predict rotation.
XMIT(See XREF(trajectory_t,trajectory_t)).
*])
DICT(time,[*For score plums, the number (score) to display.
XMIT(32).
*])
DICT(time2,[*(unused?)
XMIT(32).
*])
DICT(origin,[*New calculated position?  Current location?
XMIT(32*3).
*])
DICT(origin2,[*
Used by jumppads (XXX: for what?).
For railtrail and laser(!), location of the gun-side of the beam (where the shooter was).
For movers, the push velocity (for pushing around players).
For shotgun blasts, used to create the scattered shots effect (deriving normal vector of impact).
XMIT(32*3).
*])
DICT(angles,[*Current orientation/angle/view direction.
XMIT(32*3).
*])
DICT(angles2,[*
For players, the movement direction.
XMIT(32*3).
*])
DICT(otherEntityNum,[*
For missile impacts, indicates the victim (XXX: what's it used for afterwards?).
For railtrails, whomever fired (XXX: what about clientNum?)
For grappling hook... indicates owner?
For some hit/explosion entities, the client that owns/caused the event (XXX: ???).
For obituary events/entities, entity number of the killer.
XMIT(10).
*])
DICT(otherEntityNum2,[*
For obituary events/entities, entity number of the the dead player.
The killer is recorded in otherEntityNum.
XMIT(10).
*])
DICT(groundEntityNum,[*Entity number that this entity is standing on.  CONSTNAME(ENTITY_NONE) (1023) if airborne or swimming.  CONSTNAME(ENITITY_WORLD) (1022) if standing on a map component (floor).
XMIT(10).
*])
DICT(constantLight,[*
For movers, a constantLight color, RGBA components encoded into 4 8-bit fields mashed into a 32-bit int.
XMIT(32).
*])
DICT(loopSound,[*
Sound index into CONSTNAME(CS_SOUNDS) configstring to play in a loop.
Used by movers (grinding or motor noise), missiles (rocket sound, BFG noise, proxmine ticking), speaker entities (which is supposed to play sound in a loop), and players unfortunate enough to have a very attached proxmine.
XMIT(8).
*])
DICT(modelindex,[*
For items, item type code.
Teleport-effect models, model index number.
Model (misc_model) entities, model index number.
Also used in single player to indicate the victory podium model at end of round.
XMIT(8).
*])dnl DICT
DICT(modelindex2,[*This field is a little whacky.
For CTF flags, a non-zero value means a flag that was dropped (after fragging), whereas zero means the flag sitting at its flagstand.
For items, non-zero value indicates an item dropped by a player (such as a hypothetical "drop" command), whereas zero means a world-spawned item (such as those placed by the mapper).
For movers, specifies the model (XXX: by index into configstrings?) to draw/render, but clip brushes are still preserved (XXX: is modelindex used?).
For obelisks (something to do with a Team Arena game mode, but wtf is it?), the obelisk's health value.
XMIT(8).
*])dnl DICT
DICT(clientNum,[*Associated client number. XXX: and if not cliented?
XMIT(8).
*])
DICT(frame,[*
For portals, rotating speed (???).
For obelisks, something about whether it's dying or something.
XMIT(16).
*])
DICT(solid,[*
Automagically set by Q3 engine upon a call to FUNCNAME(trap_LinkEntity()).
dnl Read: do mess with this field.   dnl huh???
Of special note: the special value SOLID_BMODEL (0xffffff) indicates a special inline model number (I have no idea what this means).
XMIT(24).
*])
DICT(event,[*For temporary-event entities, the event type code. XXX: describe/list events.
XMIT(10).
*])
DICT(eventParm,[*For temporary-event entities, a parameter for the event (such as type of explosion or a sound index number).
XMIT(8).
*])
DICT(powerups,[*Bitmask of powerups?
XMIT(16).
*])
DICT(weapon,[*Associated weapon.
For players, this is the weapon in hand.
For obituaries, this is the weapon that inflicted death.
XMIT(8).
*])
DICT(legsAnim,[*Animation frame counter for legs.  The high bit (ANIM_TOGGLEBIT) is toggled each time leg animation has changed, thus needs to be masked out (giving you 7 bits with which to play).
XMIT(8).
*])
DICT(torsoAnim,[*Animation frame counter for torso.  The high bit (ANIM_TOGGLEBIT) is toggled each time torso animation has changed, thus needs to be masked out (gives you 7 bits with which to play).
XMIT(8).
*])
DICT(generic1,[*
For persistant powerups, bitmask flag for teams allowed to pick up this item.
For proximity mines, something about not being triggered by teammates (same bitmasks as for persistant powerups?)?
For players, in harvester mode, the number of thingies (cubes?) the player is carrying;
while this is the same value as in _S(playerState_t.generic1),
a _S(playerState_t) is transmitted only to its associated client,
and an _S(entityState_t) is transmitted to anyone else;
this replication permits other players to see how many whatitcalleds any other player has harvested.
XMIT(8).
*])
*])dnl LIST_DICT
*])dnl _P


SECT(entityType_t,enum entityType_t)
_P([*
Entity type code.
By using such a code, the server assists the client to prepare for rendering.
Also, the various fields of XREF(entityState_t,entityState_t) may take on different meanings for each entity type, which allows for a very hackish form of inherited objects.
Or a very complicated union.
*])
_P([*
These constants are actually defined in FILENAME(bg_public.h), and so the ENT_mod may redefine these constants without restriction.
The values from baseq3 are presented here to provide a context to _S(entityState_t.eType).
*])

_P([*
VERBATIM([*
typedef enum {
    ET_GENERAL,
    ET_PLAYER,
    ET_ITEM,
    ET_MISSILE,
    ET_MOVER,
    ET_BEAM,
    ET_PORTAL,
    ET_SPEAKER,
    ET_PUSH_TRIGGER,
    ET_TELEPORT_TRIGGER,
    ET_INVISIBLE,
    ET_GRAPPLE,             // grapple hooked on wall
    ET_TEAM,

    ET_EVENTS               // any of the EV_* events can be added freestanding
                            // by setting eType to ET_EVENTS + eventNum
                            // this avoids having to set eFlags and eventNum
} entityType_t;
*])dnl VERBATIM

*])dnl _P


SECT(EF_*, EF_* constants)
_P([*
Entity Flags -- various bitmask flags for an entity.
As with _S(entityType_t), these constants are also defined in FILENAME(bg_public.h), and are as redefinable.
Placed here for contextual reference to _S(entityState_t.eFlags).
*])

_P([*
VERBATIM([*
#define EF_DEAD             0x00000001      // don't draw a foe marker over players with EF_DEAD
#ifdef MISSIONPACK
#define EF_TICKING          0x00000002      // used to make players play the prox mine ticking sound
#endif
#define EF_TELEPORT_BIT     0x00000004      // toggled every time the origin abruptly changes
#define EF_AWARD_EXCELLENT  0x00000008      // draw an excellent sprite
#define EF_BOUNCE           0x00000010      // for missiles
#define EF_BOUNCE_HALF      0x00000020      // for missiles
#define EF_AWARD_GAUNTLET   0x00000040      // draw a gauntlet sprite
#define EF_NODRAW           0x00000080      // may have an event, but no model (unspawned items)
#define EF_FIRING           0x00000100      // for lightning gun
#define EF_KAMIKAZE         0x00000200
#define EF_MOVER_STOP       0x00000400      // will push otherwise
#define EF_AWARD_CAP        0x00000800      // draw the capture sprite
#define EF_TALK             0x00001000      // draw a talk balloon
#define EF_CONNECTION       0x00002000      // draw a connection trouble sprite
#define EF_VOTED            0x00004000      // already cast a vote
#define EF_AWARD_IMPRESSIVE 0x00008000      // draw an impressive sprite
#define EF_AWARD_DEFEND     0x00010000      // draw a defend sprite
#define EF_AWARD_ASSIST     0x00020000      // draw a assist sprite
#define EF_AWARD_DENIED     0x00040000      // denied
#define EF_TEAMVOTED        0x00080000      // already cast a team vote
*])dnl VERBATIM

*])dnl _P


SECT(entityShared_t,struct entityShared_t)
_P([*
The _SN struct is not transmitted over network.
Still, it is memory space shared by the Q3 engine and ENT_mod for certain non-network activity that both the engine and the ENT_mod need simultaneous access.
One such example is collision detection with trap_Trace().
While the trap's code/contents/meat resides in the Q3 engine, information such as location and sizes of entities need to be available for reading and writing to both the Q3 engine (to detect collisions) and the ENT_mod (to move entities around).
The _SN struct fills this role of shared memory, while not being network-active.
*])
_P([*
Though the struct exists in VM memory, the Q3 engine has free reign of reading and writing these fields.
Put another way, the values of these fields may at times appear to change QUOT(magically).
A suitable analogy is I/O ports in systems programming.
*])

_P([*
VERBATIM([*
typedef struct {
    _S(entityState_t)   _F(s);              // communicated by server to clients

    qboolean    _F(linked);             // qfalse if not in any good cluster
    int         _F(linkcount);

    int         _F(svFlags);            // SVF_NOCLIENT, SVF_BROADCAST, etc
    int         _F(singleClient);       // only send to this client when SVF_SINGLECLIENT is set

    qboolean    _F(bmodel);             // if false, assume an explicit mins / maxs bounding box
                                    // only set by trap_SetBrushModel
    vec3_t      _F(mins), _F(maxs);
    int         _F(contents);           // CONTENTS_TRIGGER, CONTENTS_SOLID, CONTENTS_BODY, etc
                                    // a non-solid entity should set to 0

    vec3_t      _F(absmin), _F(absmax);     // derived from mins/maxs and origin + rotation

    // currentOrigin will be used for all collision detection and world linking.
    // it will not necessarily be the same as the trajectory evaluation for the current
    // time, because each entity must be moved one at a time after time is advanced
    // to avoid simultanious collision issues
    vec3_t      _F(currentOrigin);
    vec3_t      _F(currentAngles);

    // when a trace call is made and passEntityNum != ENTITYNUM_NONE,
    // an ent will be excluded from testing if:
    // ent->s.number == passEntityNum   (don't interact with self)
    // ent->s.ownerNum = passEntityNum  (don't interact with your own missiles)
    // entity[ent->s.ownerNum].ownerNum = passEntityNum (don't interact with other missiles from owner)
    int         _F(ownerNum);
} entityShared_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(s,[*Copy of _S(entityState_t) data?*])
DICT(linked,[*true or false, depending on whether entity is linked into the world or not (trap_LinkEntity()/trap_UnlinkEntity()).*])
DICT(linkcount,[*???*])
DICT(svFlags,[*Bitmask flags of special note to the Q3 engine server.
The Q3 engine does not (and should not!) know the purpose of the other structs used by the ENT_mod.
This field allows for the ENT_mod to specify special server/network actions on this entity.
QV(SVF_*).
*])
DICT(singleClient,[*
If svFlags has the XREF(SVF_*.SVF_SINGLECLIENT,CONSTNAME(SVF_SINGLECLIENT)) bit set, this field indicates the sole recipient of update information for this entity.
*])
DICT(bmodel,[*And if true, means the entity is part of the map (BSP Model).*])
DICT(mins,[*One corner of the QUOT(regular) bounding box.*])
DICT(maxs,[*The other corner of the QUOT(regular) bounding box.*])
DICT(contents,[*Bitmask flags of _S(CONTENTS_*) constants.*])
DICT(absmin,[*Adjusted bounding box to compensate for box rotations.*])
DICT(absmax,[*Adjusted bounding box to compensate for box rotations.*])
DICT(currentOrigin,[*The position used by trap_Trace() to calculate collisions.
Trajectory calculations are still based on _S(entityState_t.pos).
*])
DICT(currentAngles,[*The view/aim direction used by traps.
Trajectory still based on _S(entityState_t.apos).
*])
DICT(ownerNum,[*Owner number for this entity.*])
*])dnl LIST_DICT
*])dnl _P


SECT(SVF_*,SVF_* constants)
_P([*
The PVS (Potential Visibility Set) of a location can be thought of as the set of _S(entityState_t) updates to properly predict events and entities within view from that location.
The server flags fiddle with the set of _S(entityState_t) update information.
*])

_P([*
VERBATIM([*
/ entity->svFlags
// the server does not know how to interpret most of the values
// in entityStates (level eType), so the game must explicitly flag
// special server behaviors
#define SVF_NOCLIENT            0x00000001  // don't send entity to clients, even if it has effects
#define SVF_BOT                 0x00000008  // set if the entity is a bot
#define SVF_BROADCAST           0x00000020  // send to all connected clients
#define SVF_PORTAL              0x00000040  // merge a second pvs at origin2 into snapshots
#define SVF_USE_CURRENT_ORIGIN  0x00000080  // entity->r.currentOrigin instead of entity->s.origin
                                            // for link position (missiles and movers)
#define SVF_SINGLECLIENT        0x00000100  // only send to a single client
*])dnl VERBATIM

LIST_DICT([*
DICT(SVF_NOCLIENT,[*
The entity update information is not sent to anyone (_S(entityState_t) content remains network-inactive).
*])
DICT(SVF_BOT,[*
Marks this entity as a bot AI.
*])
DICT(SVF_BROADCAST,[*
Send entity update information to all clients; insert into PVS of all clients.
*])
DICT(SVF_PORTAL,[*
Takes the PVS calculated from _S(entityState_t.origin2) and send that PVS information to this client, along with the original PVS.
(I think.)
In other words, the client can also see what the portal is seeing (remote camera effect).
*])
DICT(SVF_USE_CURRENT_ORIGIN,[*
Normally the PVS is calculated from _S(entityState_t.origin), but this flag changes the PVS calculation to use _S(entityShared_t.currentOrigin) instead.
*])
DICT(SVF_SINGLECLIENT,[*
Send this entity's update information to only one client, removing from the PVS of all other clients.
The sole recipient of such information is indicated by _S(entityShared_t.singleClient).
*])
*])dnl LIST_DICT
*])dnl _P


_P([*
TODO: table of structs, their fields, and modability.
*])

divert(0)

_P([*
SECT(TOC,Table of Contents)
LIST_ORDERED(TOCLIST)
*])

undivert(1)

<hr width="42%" align="left">
_P([*Created 2002.09.14. _LF()
Updated 2002.09.20 - plane information (djbob). _LF()
Updated 2003.11.10 - massive inject from cyrri. _LF()
Updated 2004.07.24 - spelling corrections, fixed syntax errors, grammar adjustments, more cross-reference links, added TOC. _LF()
Updated 2011.07.11 - change of contact e-mail. _LF()
ADDRESS([*
ENT_authornick
ENT_angbra ENT_authormail ENT_angket
*])dnl ADDRESS
*])dnl _P

</body>
</html>
