<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.or
g/TR/html4/loose.dtd">
changequote([*,*])dnl
changecom([*<!--*],[*-->*])dnl
define(ENT_title,[*Main game structs*])dnl
define(TITLE,<h1>$1</h1>)dnl
define(SYNOPSIS,<h2>Synopsis</h2><p>$1</p>)dnl
define(ENT_is,immutable structs)dnl
define(ENT_mod,game module)dnl
define(ENT_angbra,[*&lt;*])dnl
define(ENT_angket,[*&gt;*])dnl
define(ENT_amp,[*&amp;*])dnl
define(ENT_authornick,PhaethonH)dnl
define(ENT_authormail,[*PhaethonH@gmail.com*])dnl
define(FILENAME,<tt>$1</tt>)dnl
define(FUNCNAME,<var>$1</var>)dnl
define(VARNAME,<var>$1</var>)dnl
define(CONSTNAME,<tt>$1</tt>)dnl
define(VERBATIM,<hr><pre>$1</pre><hr>)dnl
define(KEYB,<tt>$1</tt>)dnl
define(_P,<p>$1)dnl
define(SECT,<h3><a name="$1">$2</a></h3>[*undefine([*_SN*])define(_SN,$1)*])dnl
define(SECT1,<h4>$1</h4>)dnl
define(SECT2,<h5>$1</h5>)dnl
define(QUOT,&quot;$1&quot;)dnl
define(XREF,[*<a href="#$1">$2</a>*])dnl
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
define(TABLE,[*<table border=1 frame="border" rules="all">$1</table>*])dnl
define([*COLS*],0)dnl
define(T_HEADr,[*<th>$1</th>define([*COLS*],incr(COLS))
ifelse($#,1,,[*T_HEADr(shift($@))*])*])dnl
define(T_HEAD,[*<tr>T_HEADr($@)</tr>*])dnl
define(T_ROWr,[*TD_EXPAND($1)
ifelse($#,1,,[*T_ROWr(shift($@))*])*])dnl
define(T_ROW,[*<tr>T_ROWr($@)</tr>*])dnl
define(SPAN,[*!$1,*])dnl
dnl define(TD_EXPAND,[*ifelse($#,2,[*<td colspan=$1>$2</td>*],[*<td>$1</td>*])*])dnl
dnl define(TD_EXPAND,[*ifelse($#,2,[*<td colspan=$1>$2</td>*],[*<td>$1</td>*])*])dnl
dnl
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>ENT_title</title>
</head>
<body>
TITLE(ENT_title)

SYNOPSIS([*
Description of gentity_t and gclient_t, the ENT_mod structs for game entities and game clients.
*])


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



SECT(gentity_t,struct gentity_s)
_P([*
This struct describes the properties of an QUOT(entity) in the ENT_mod.
An entity may also be known as a QUOT(game object) in other contexts.
*])

_P([*
The Q3 engine knows nothing about the contents of a _SN, though it knows how large the struct is, via FUNCNAME(trap_LocateGameData()).
The fields are specific to the ENT_mod, and are utilized solely by the code in the ENT_mod.
The ENT_mod may still copy values into the members that the Q3 engine recognizes.
*])

_P([*
The trap FUNCNAME(trap_LocateGameData) notifies the Q3 engine of the location of the array of game entities.
The Q3 engine requires the beginning of each game entity struct to be a specific form, but the rest is left to the ENT_mod.
*])

_P([*
VERBATIM([*
typedef struct gentity_s gentity_t;

struct gentity_s {
    entityState_t   _F(s);              // communicated by server to clients
    entityShared_t  _F(r);              // shared by both the server system and game

    // DO NOT MODIFY ANYTHING ABOVE THIS, THE SERVER
    // EXPECTS THE FIELDS IN THAT ORDER!
    //================================

    XREF(gclient_t,struct gclient_s)    *_F(client);            // NULL if not a client

    qboolean    _F(inuse);

    char        *_F(classname);         // set in QuakeEd
    int         _F(spawnflags);         // set in QuakeEd

    qboolean    _F(neverFree);          // if true, FreeEntity will only unlink
                                    // bodyque uses this

    int         _F(flags);              // FL_* variables

    char        *_F(model);
    char        *_F(model2);
    int         _F(freetime);           // level.time when the object was freed

    int         _F(eventTime);          // events will be cleared EVENT_VALID_MSEC after set
    qboolean    _F(freeAfterEvent);
    qboolean    _F(unlinkAfterEvent);

    qboolean    _F(physicsObject);      // if true, it can be pushed by movers and fall off edges
                                    // all game items are physicsObjects,
    float       _F(physicsBounce);      // 1.0 = continuous bounce, 0.0 = no bounce
    int         _F(clipmask);           // brushes with this content value will be collided against
                                    // when moving.  items and corpses do not collide against
                                    // players, for instance

    // movers
    moverState_t _F(moverState);
    int         _F(soundPos1);
    int         _F(sound1to2);
    int         _F(sound2to1);
    int         _F(soundPos2);
    int         _F(soundLoop);
    _S(gentity_t)   *_F(parent);
    _S(gentity_t)   *_F(nextTrain);
    _S(gentity_t)   *_F(prevTrain);
    vec3_t      _F(pos1), _F(pos2);

    char        *_F(message);

    int         _F(timestamp);      // body queue sinking, etc

    float       _F(angle);          // set in editor, -1 = up, -2 = down
    char        *_F(target);
    char        *_F(targetname);
    char        *_F(team);
    char        *_F(targetShaderName);
    char        *_F(targetShaderNewName);
    gentity_t   *_F(target_ent);

    float       _F(speed);
    vec3_t      _F(movedir);

    int         _F(nextthink);
    void        (*_F(think))(gentity_t *self);
    void        (*_F(reached))(gentity_t *self);    // movers call this when hitting endpoint
    void        (*_F(blocked))(gentity_t *self, gentity_t *other);
    void        (*_F(touch))(gentity_t *self, gentity_t *other, trace_t *trace);
    void        (*_F(use))(gentity_t *self, gentity_t *other, gentity_t *activator);
    void        (*_F(pain))(gentity_t *self, gentity_t *attacker, int damage);
    void        (*_F(die))(gentity_t *self, gentity_t *inflictor, gentity_t *attacker, int damage, int mod);

    int         _F(pain_debounce_time);
    int         _F(fly_sound_debounce_time);    // wind tunnel
    int         _F(last_move_time);

    int         _F(health);

    qboolean    _F(takedamage);

    int         _F(damage);
    int         _F(splashDamage);   // quad will increase this without increasing radius
    int         _F(splashRadius);
    int         _F(methodOfDeath);
    int         _F(splashMethodOfDeath);

    int         _F(count);

    _S(gentity_t)   *_F(chain);
    _S(gentity_t)   *_F(enemy);
    _S(gentity_t)   *_F(activator);
    _S(gentity_t)   *_F(teamchain);     // next entity in team
    _S(gentity_t)   *_F(teammaster);    // master of the team

#ifdef MISSIONPACK
    int         kamikazeTime;
    int         kamikazeShockTime;
#endif

    int         _F(watertype);
    int         _F(waterlevel);

    int         _F(noise_index);

    // timing variables
    float       _F(wait);
    float       _F(random);

    gitem_t     *_F(item);          // for bonus items
};

*])dnl VERBATIM

LIST_DICT([*
DICT(s,[*
An instance of entityState_t.
The Q3 engine expects this struct in this location.
*])
DICT(r,[*
An instance of entityShared_t.
Q3 engine expects this struct in this location.
Yes, entityShared_t contains yet another entityState_t.  Don't ask.
*])
DICT(client,[*
Pointer to a gclient_t, if this entity is a client (first 64 entities).
CONSTNAME(NULL) if not a client.
*])
DICT(inuse,[*
Boolean, whether this entity slot is used or not.
*])
DICT(classname,[*
A name indicating this entity's type, or class, or category.
*])
DICT(spawnflags,[*
Spawn-time flags, for map entities (e.g. movers, triggers).
*])
DICT(neverFree,[*
This entity slot should never be freed, but just unlinked instead.
Used by body queue.
*])
DICT(flags,[*
???
*])
DICT(model,[*
???
*])
DICT(model2,[*
???
*])
DICT(freetime,[*
The VARNAME(level.time) when this entity is freed.
*])
DICT(eventTime,[**])
DICT(freeAfterEvent,[*
Whether this entity is automatically freed after its event finishes.
*])
DICT(unlinkAfterEvent,[*
Whether this entity is unlinked, but not freed, after its event finishes.
*])
DICT(physicsObject,[*
Whether this entity experiences physics-based motion (mainly fallling).
*])
DICT(physicsBounce,[*
Bounce factor.
Value of 1.0 is (an unrealistically) perfect reflection of kinetic energy.
A value of 0.0 (also unrealistically) stops this entity fully -- for CONSTNAME(TR_LINEAR) trajectory, the entity remains still midair; for CONSTNAME(TR_GRAVITY) trajectory, the entity falls straight down.
*])
DICT(clipmask,[*
Bitmask flags that indicate what brushes (XXX: correct word?)  against which this entity clips.
*])
DICT(moverState,[*
???
*])
DICT(soundPos1,[*
For movers, the sound to play when the mover reaches its first position.
*])
DICT(sound1to2,[*
For movers, the sound to play when the mover leaves its first position.
*])
DICT(sound2to1,[*
For movers, the sound to play when the mover leaves its second position.
*])
DICT(soundPos2,[*
For movers, the sound to play when the mover reaches its second position.
*])
DICT(soundLoop,[*
Sound the play in a loop while the mover is moving.
*])
DICT(parent,[*
Pointer to the head of a linked list of entities.
*])
DICT(nextTrain,[*
For train entities, the next train location after the current one.
*])
DICT(prevTrain,[*
For train entities, the previous train location before the current one.
*])
DICT(pos1,[*
For movers, its first position.
*])
DICT(pos2,[*
For movers, its second position.
*])
DICT(message,[*
For target_print entities, the message to print.
*])
DICT(timestamp,[*
For corpses (body queue), the VARNAME(level.time) when the corpse was made.
For players, the VARNAME(level.time) of last hurting from a hurt brush.
*])
DICT(angle,[*
Angle for map entities.
This is the direction the entity faces on map spawn.
Expressed as a rotation around around the z axis (XXX: what's 0? x?).
*])
DICT(target,[*
For map entities in general, name of some other entity to activate at an QUOT(appropriate time).
For portal entities, its camera object (the source of the portal's image).
For camera entities, the direction to view? (otherwise aims towards portal?)
For shooter entities, a target to actively target (moving aim as needed).
For train entities, the next target (location) in the train.
For give entities, a linked list of items to give to the activator?
For laser entities, the entity to aim at (if any).
For teleport entities, the teleport destination.
For relay entities, the entity to activate.
*])
DICT(targetname,[*
For door entities, the remote button or trigger to open the door, otherwise acts in the usual Star Trek style (opens when a player is near).
For plat entities (such as lifts), the remote button or trigger to activate the plat, otherwise activates if player is touching the plat.
*])
DICT(team,[*
Team name.
Something about linking up all entities on a particular team.
Movers that stay together are members of their own team?
*])
DICT(targetShaderName,[*
XXX: Um... change shader on de/activate?
*])
DICT(targetShaderNewName,[*
XXX: change shader on de/activate?
*])
DICT(target_ent,[*
For proximity mines, pointer to the player entity it bounced off due to invulnerability.
*])
DICT(speed,[*
For item entities, on respawn or pickup, zero for global sound, non-zero for local sound.
For movers, the moving speed.
For doors, the opening speed.
For plats, the moving speed.
For buttons, (XXX: ???).
For trains, the new speed to use.
For path corners, new speed to use.
For rotation, rotation speed (left-handed geometry = positive number rotates clockwise when viewed from positive axis (QUOT(overhead) for z)).
For bobbing, time in seconds to complete a full bob cycle.
For pendulum, maximum swinging angle in degrees (degrees from vertical).
For push targets, speed to push (as with jumppads).
*])
DICT(movedir,[*
For shooters, the direction to shoot if there's no target in particular.
For proximity mines, (XXX: ???).
For doors, the direction to move for opening/closing.
For buttons, the direction to move for pressing/releasing.
For lasers, the direction to shoot.
For kamikaze explosions, (XXX: ???).
*])
DICT(nextthink,[*
The VARNAME(level.time) when this entity's _F(think) function runs again.
*])
DICT(think,[*
A function pointer to the entity's think function.
This function is called when VARNAME(level.time) exceeds _F(nextthink).
This function may cause the entity to destroy itself (e.g. time-delay bombs), or induce basic AI (e.g. homing missiles).
In the latter case, the think function may again set _F(nextthink) to VARNAME(level.time)+CONSTNAME(some_delay) to re-run the think function shortly thereafter.
One argument: the entity that is thinking (player, mover, shooter, button, etc.).
*])
DICT(reached,[*
A function pointer to the entity's reach function.
Used primarily for movers, this function runs when the mover reaches one of its destinations.
One basic action is to send it right back to the other destination, although other actions are possible, such as killing someone randomly, activating a remote trigger, or jumping/teleporting back to another location (disappearing platforms).
One argument: the entity that reached its destination (mover).
*])
DICT(blocked,[*
A function pointer to the entity's block function.
Used primarily for movers, called when some other entity is blocking this entity.
The usual action is to cause damage to the other entity and keep moving (squashing), or to bounce back to this entity's (the mover's) previous position.
Two arguments: the entity being blocked (mover), the entity that caused the block (player, flag, item).
*])
DICT(touch,[*
A function pointer to the entity's touch function.
When this entity touches another entity, usually player-in-trigger (e.g. buttons, teleports).
Three arguments: the entity being touched (teleport, door, button), the entity doing the touching (player, missile), the trace result that determined the entities are touching.
*])
DICT(use,[*
Function pointer, runs when entity is activated (such as player hitting button, or standing near door).
Three arguments: the entity being used (item, button), ???, the entity that did the activating (player, target entity).
*])
DICT(pain,[*
Function pointer, runs when entity receives damage.
Three argument: entity receiving damage (player), the entity that dealt damage (player?), the damage amount.
(XXX: can regen?)
*])
DICT(die,[*
Function pointer, runs when entity runs out of health.
Five arguments: the entity that died (player, missile, door), the entity that delivered the damage (missile; NULL for hitscan?), the entity that attacked (player, shooter, world), damage amount, damage type.
*])
DICT(pain_debounce_time,[*
The VARNAME(level.time) when the pain sound event expires (new pain events do not generate a sound event during this time).
*])
DICT(fly_sound_debounce_time,[*
For push targets, the VARNAME(level.time) when the QUOT(push) sound event expires (new push events do not generate a sound event during this time).
*])
DICT(last_move_time,[*
not used?
*])
DICT(health,[*
For players, their health level;
this value is copied into playerState_t.stats[STAT_HEALTH].
For most game entities, some health value.
For doors, non-zero value means the door must be shot to open (otherwise can open by being near or being shot).
For buttons, non-zero value means the button must be shot to activate (otherwise can activate by being run into or being shot).
*])
DICT(takedamage,[*
Whether this entity can receive damage (e.g. god mode, missiles, shootable doors) and call FUNCNAME(pain()).
*])
DICT(damage,[*
For missiles (grenades, rockets, plasma, BFG10K), amount of damage for a direct hit.
*])
DICT(splashDamage,[*
For missiles, amount of damage by splash damage.
*])
DICT(splashRadius,[*
Radius of splash damage.
Entities beyond the radius are not damaged; entities within receive damage based on how close they are to the explosion.
*])
DICT(methodOfDeath,[*
A method-of-death (MOD) code number for a direct hit.
This number indicates the type of missile, or, more specifically, the type of damage, from a direct hit.
This number is used in obituaries to determine the obituary line (QUOT(JoeRandom ate JaneQ's rocket)).
*])
DICT(splashMethodOfDeath,[*
MOD code number for splash damage.
(QUOT(JoeRandom almost dodged JaneQ's rocket))
*])
DICT(count,[*
For score targets, the score to give to the activator.
For powerups, the amount of powerup time provided (uses item->_F(quantity) if zero).
For ammo items, the amount of ammunition provided (uses item->_F(quantity) if zero).
For armor items, the amount of armor provided (uses item->_F(quantity) if zero).
For health items, the amount of health provided (uses item->_F(quantity) if zero).
For weapon items, the amount of extra ammo provided (uses item->_F(quantity) if zero).
For single player victory podium, the entity's rank (1, 2, or 3).
For holdable portals, (XXX: ???).
For doors, (XXX: ???).
For proximity mines, whether it can currently attach to an player or not.
For location entities, its location code number?
For kamikaze explosion, the time counter?
*])
DICT(chain,[*
???
*])
DICT(enemy,[*
???
*])
DICT(activator,[*
For certain map entities, the entity (usually a player) that activated this entity.
For kamikaze explosion, the entity (usually player) that... err... did the kamikaze.
*])
DICT(teamchain,[*
Linked list of a team members.
Movers that group together go in their own teams?
*])
DICT(teammaster,[*
Pointer to the head of a team list.
For movers, (XXX:...).
*])
DICT(watertype,[*
The liquid type the player is within (water or slime).
*])
DICT(waterlevel,[*
XXX: how much of the player's body is underwater?
*])
DICT(noise_index,[*
For speaker entities, the sound index number (CONFIGSTRING) to play.
*])
DICT(wait,[*
For movers, the amount of time (in seconds) to wait upon reaching a destination.
For doors, amount of time (in seconds) to wait before closing again (or opening for start_open doors).
For plats, amount of time (in seconds) to wait before returning to rest position?
For buttons, amount of time (in seconds) to stay pressed before returning to rest position?
For trains, amount of time (in seconds) to wait at the train before moving towards the next?
For corners, amount of time (in seconds) to wait at the corner beofre moving to the next corner?
For multiple triggers, (XXX: ???).
For timer entities, amount of time (in seconds) to wait before triggering.
For delay targets, amount of time (in seconds) to delay before firing targets.
For speaker targets, amount of time (in seconds) to wait before auto-triggering.
For items, amount of (in seconds) time before respawning.
*])
DICT(random,[*
For items, a random variance on _F(wait).
For shooters, randomize the firing direction a little.
For delay targets, random variance on _F(wait).
For speaker targets, random variance on _F(wait).
For multiple triggers, random variance on _F(wait).
For timer entities, random variance on _F(wait).
*])
DICT(item,[*
For items (QUOT(item instances)), a pointer to an gitem_t item descriptor (QUOT(item class)).
*])
*])
*])dnl _P


SECT(gclient_t,struct gclient_s)
_P([*
This struct holds data particular to each client.
A client is a (usually human) player, requiring a QUOT(feedback) mechanism (remote control).
*])

_P([*
VERBATIM([*
typedef struct gclient_s gclient_t;

struct gclient_s {
    // ps MUST be the first element, because the server expects it
    playerState_t   _F(ps);             // communicated by server to clients

    // the rest of the structure is private to game
    _S(clientPersistant_t)  _F(pers);
    _S(clientSession_t)     _F(sess);

    qboolean    _F(readyToExit);        // wishes to leave the intermission

    qboolean    _F(noclip);

    int         _F(lastCmdTime);        // level.time of last usercmd_t, for EF_CONNECTION
                                    // we can't just use pers.lastCommand.time, because
                                    // of the g_sycronousclients case
    int         _F(buttons);
    int         _F(oldbuttons);
    int         _F(latched_buttons);

    vec3_t      _F(oldOrigin);

    // sum up damage over an entire frame, so
    // shotgun blasts give a single big kick
    int         _F(damage_armor);       // damage absorbed by armor
    int         _F(damage_blood);       // damage taken out of health
    int         _F(damage_knockback);   // impact damage
    vec3_t      _F(damage_from);        // origin for vector calculation
    qboolean    _F(damage_fromWorld);   // if true, don't use the damage_from vector

    int         _F(accurateCount);      // for "impressive" reward sound

    int         _F(accuracy_shots);     // total number of shots
    int         _F(accuracy_hits);      // total number of hits

    //
    int         _F(lastkilled_client);  // last client that this client killed
    int         _F(lasthurt_client);    // last client that damaged this client
    int         _F(lasthurt_mod);       // type of damage the client did

    // timers
    int         _F(respawnTime);        // can respawn when time > this, force after g_forcerespwan
    int         _F(inactivityTime);     // kick players when time > this
    qboolean    _F(inactivityWarning);  // qtrue if the five seoond warning has been given
    int         _F(rewardTime);         // clear the EF_AWARD_IMPRESSIVE, etc when time > this

    int         _F(airOutTime);

    int         _F(lastKillTime);       // for multiple kill rewards

    qboolean    _F(fireHeld);           // used for hook
    _S(gentity_t)   *_F(hook);              // grapple hook if out

    int         _F(switchTeamTime);     // time the player switched teams

    // timeResidual is used to handle events that happen every second
    // like health / armor countdowns and regeneration
    int         _F(timeResidual);

#ifdef MISSIONPACK
    gentity_t   *persistantPowerup;
    int         portalID;
    int         ammoTimes[WP_NUM_WEAPONS];
    int         invulnerabilityTime;
#endif

    char        *_F(areabits);

};
*])dnl VERBATIM

LIST_DICT([*
DICT(ps,[*
A playerState_t struct.
The Q3 engine expects this field at the beginning of the _SN struct.
*])
DICT(pers,[*Persistant data.
This is data that does not reset across multiple respawns, but does reset on level change or team change.
*])
DICT(sess,[*Client session data.
Data that remains with the client until disconnection or server shutdown.
Preserved across level change (by use of cvars).
*])
DICT(readyToExit,[*Whether client is QUOT(READY) to leave intermission (the QUOT(READY) mark on scoreboard).
*])
DICT(noclip,[*Whether client is in QUOT(noclip) mode or not.
*])
DICT(lastCmdTime,[*Time of the last command (usercmd_t) from the client.
Can help indicate an impending connection loss.
(XXX: what's this about pers.lastCommand.time?)
*])
DICT(buttons,[*
A bitmask of the currently pressed game buttons (+attack, +gesture, +button5).
*])
DICT(oldbuttons,[*
A bitmask of the game buttons from the prior command (usercmd_t).
Helps determine change of button state.
*])
DICT(latched_buttons,[*
Stores buttons still held down (as opposed having been just pressed or released).
*])
DICT(oldOrigin,[*
???
*])
DICT(damage_armor,[*
Amount of damage to armor.
*])
DICT(damage_blood,[*
Amount of damage to health.
*])
DICT(damage_knockback,[*
Cumulative knockback force.
*])
DICT(damage_from,[*
Direction of damage source.
*])
DICT(damage_fromWorld,[*Whether to ignore knockback or not (e.g. though lava is damage from the world, it doesn't knock the player back into the air).
*])
DICT(accurateCount,[*
Counter to keep track of railgun "Impressive" reward.
*])
DICT(accuracy_shots,[*
Number of shots fired.
*])
DICT(accuracy_hits,[*
Number of shots that hit someone.
*])
DICT(lastkilled_client,[*
Most recent client/player fragged by this one.
*])
DICT(lasthurt_client,[*
Most recent client/player to hurt this one (initialized 0).
*])
DICT(lasthurt_mod,[*
Type of damage (means of death/damage) from most recent damage.
*])
DICT(respawnTime,[*
The VARNAME(level.time) when the player is scheduled to respawn.
*])
DICT(inactivityTime,[*
Scheduled VARNAME(level.time) to kick player for inactivity.
This timer is updated on each "activity" action to be VARNAME(level.time) + some constant.
*])
DICT(inactivityWarning,[*
Whether or not inactivity warning has been given.
*])
DICT(rewardTime,[*
Scheduled VARNAME(level.time) the overhead reward sprite expires.
*])
DICT(airOutTime,[*
Scheduled VARNAME(level.time) for air expiration (drowning).
*])
DICT(lastKillTime,[*
The VARNAME(level.time) when player was most recently fragged.
*])
DICT(fireheld,[*
Boolean flag to indicate constant firing for lightning gun and grappling hook.
*])
DICT(hook,[*Pointer to the hook entity/missile.
This is the part that's flying.
The line between the player and hook is implied, rendered client side.
*])
DICT(switchTeamTime,[*
Schedule VARNAME(level.time) when the player may change teams.
Intended to prevent team-switch spams.
*])
DICT(timeResidual,[*
Number of milliseconds since most recent 1-second boundary, for once-per-second effects (e.g. regeneration).
This counter ensures once-per-second events happen after 1000 or more milliseconds passed.
The counter is reset to zero on each once-per-second event.
*])
DICT(areabits,[*
Something to do with the AI bot?
*])
*])dnl LIST_DICT
*])dnl _P


SECT(clientPersistant_t,struct clientPersistant_t)
Persistant data is data preserved across respawns, but not on level change or team change.
That sort of data is covered by _S(clientSession_t).
_P([*
VERBATIM([*
// client data that stays across multiple respawns, but is cleared
// on each level change or team change at ClientBegin()
typedef struct {
    _S(clientConnected_t)   _F(connected);
    usercmd_t   _F(cmd);                // we would lose angles if not persistant
    qboolean    _F(localClient);        // true if "ip" info key is "localhost"
    qboolean    _F(initialSpawn);       // the first spawn should be at a cool locat
ion
    qboolean    _F(predictItemPickup);  // based on cg_predictItems userinfo
    qboolean    _F(pmoveFixed);         //
    char        _F(netname[MAX_NETNAME]);
    int         _F(maxHealth);          // for handicapping
    int         _F(enterTime);          // level.time the client entered the game
    _S(playerTeamState_t) _F(teamState);    // status in teamplay games
    int         _F(voteCount);          // to prevent people from constantly calling
 votes
    int         _F(teamVoteCount);      // to prevent people from constantly calling
 votes
    qboolean    _F(teamInfo);           // send team overlay updates?
} clientPersistant_t;
*])
LIST_DICT([*
DICT(connected,[*
Connection state of client.  QV(clientConnected_t).
*])
DICT(cmd,[*
??? (why would it lose otherwise?)
*])
DICT(localClient,[*
Whether client is local (one same machine as server).
For example, single-player mode.
*])
DICT(initialSpawn,[*
True if client has not yet spawned in the game.
*])
DICT(predictedItemPickup,[*
Whether client wants item prediction?
*])
DICT(pmoveFixed,[*
(the QUOT(fixed) used here is the QUOT(not changing; not varying; no wiggle room) sense)
*])
DICT(netname[MAX_NETNAME],[*
Player's name.
CONSTNAME(MAX_NETNAME) is 36 (defined in g_local.h).
*])
DICT(maxHealth,[*
Handicap value (initial (re)spawn health).
Expert players can reduce their handicap (health) to give less-experienced players a more even playing field.
*])
DICT(enterTime,[*
The VARNAME(level.time) the client completely connected to the server (and able to chat, play, etc.).
*])
DICT(teamState,[*
team state information.  QV(playerTeamState_t).
*])
DICT(voteCount,[*
Counter for number of callvotes initiated by this client.
*])
DICT(teamVoteCount,[*
Counter for number of team callvotes initiated by this client.
*])
DICT(teamInfo,[*
Whether client wants to receive team info or not (in consideration of bandwidth).
*])
*])dnl LIST_DICT
*])dnl _P


SECT(clientSession_t,struct clientSession_t)
_P([*
A QUOT(session) for a client is the span of time and activity between the client's connect and the client's disconnect.
A reconnect creates a new session (disconnect + connect).
A session can span across multiple level (map) changes (connect, play, change map, play, change map, play, disconnect).
Since the Q3VM and all memory within a .qvm are reset on map changes,
the data in a clientSession_t (which is in the VM memory space) must be stored outside the VM to survive level changes.
The most common form is cvars, although files are also feasible.
VERBATIM([*
// client data that stays across multiple levels or tournament restarts
// this is achieved by writing all the data to cvar strings at game shutdown
// time and reading them back at connection time.  Anything added here
// MUST be dealt with in G_InitSessionData() / G_ReadSessionData() / G_WriteSessionData()
typedef struct {
    team_t      _F(sessionTeam);
    int         _F(spectatorTime);      // for determining next-in-line to play
    spectatorState_t    _F(spectatorState);
    int         _F(spectatorClient);    // for chasecam and follow mode
    int         _F(wins), _F(losses);       // tournament stats
    qboolean    _F(teamLeader);         // true when this client is a team leader
} clientSession_t;
*])
LIST_DICT([*
DICT(sessionTeam,[*
This client's team.
*])
DICT(spectatorTime,[*
The VARNAME(level.time) this client joined the tournmanet queue (lowest value goes next in tournament mode).
*])
DICT(spectatorState,[*
If spectator, spectating style. QV(spectatorState_t).
*])
DICT(spectatorClient,[*
If spectator, which client is being spectated (valid or not based on _F(spectatorState)).
*])
DICT(wins,[*
Total number of wins for this client.
*])
DICT(losses,[*
Total number of losses for this client.
*])
DICT(teamLeader,[*
Client is a team leader (XXX: only for MISSIONPACK?).
*])
*])dnl LIST_DICT
*])dnl _P


SECT(playerTeamState_t,struct playerTeamState_t)
_P([*
A player's team-related status in a team game.

VERBATIM([*
typedef struct {
    _S(playerTeamStateState_t)  _F(state);

    int         _F(location);

    int         _F(captures);
    int         _F(basedefense);
    int         _F(carrierdefense);
    int         _F(flagrecovery);
    int         _F(fragcarrier);
    int         _F(assists);

    float       _F(lasthurtcarrier);
    float       _F(lastreturnedflag);
    float       _F(flagsince);
    float       _F(lastfraggedcarrier);
} playerTeamState_t;
*])dnl _VERBATIM

LIST_DICT([*
DICT(state, [*
Player's relationship with a team.  QV(playerTeamStateState_t).
*])
DICT(location, [*
Index of the nearest target_location entity to this player (used in team overlay).
*])
DICT(captures, [*
Number of objective (flag, skull) captures.
*])
DICT(basedefense, [*
Number of times this player defended the base (Base Defense award).
*])
DICT(carrierdefense, [*
Number of times this player defended a friendly flag carrier (Carrier Defense award).
*])
DICT(flagrecovery, [*
Number of times this player recovered the flag (Flag Recovery award).
*])
DICT(fragcarrier, [*
Number of times this player fragged the enemy flag carrier (Frag Carrier award).
*])
DICT(assists, [*
Number of times this player assisted a flag capture(?) (Assist awards).
*])
DICT(lasthurtcarrier, [*
The VARNAME(level.time) the player hurt an enemy flag carrier (used for what?).
*])
DICT(lastreturnedflag, [*
The VARNAME(level.time) the player returned the flag, used for Flag Recovery and Assist awards.
*])
DICT(flagsince, [*
The VARNAME(level.time) the player stole the enemy flag.
*])
DICT(lastfraggedcarrier, [*
The VARNAME(level.time) when the client fragged an enemy flag carrier (used for Assist awards).
*])
*])dnl LIST_DICT

*])dnl _P



SECT(clientConnected_t,enum clientConnected_t)
_P([*
Constants describing the connection state of a client in _S(clientPersistant_t.connected).
*])

_P([*
VERBATIM([*
typedef enum {
    _F(CON_DISCONNECTED),
    _F(CON_CONNECTING),
    _F(CON_CONNECTED)
} clientConnected_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(CON_DISCONNECTED,[*Client is gone; client slot not in use.*])
DICT(CON_CONNECTED,[*Client is fully connected and able to do game stuff.*])
DICT(CON_CONNECTING,[*Client is negotiating connection handshake (existence acknowleged, but unable to interact yet).  Typically indicates the client is (still) loading game data/models/map.*])
*])dnl LIST_DICT
*])dnl _P



SECT(playerTeamStateState_t,enum playerTeamStateState_t)
_P([*
dnl For _S(clientPersistant_t.teamState).
For _S(playerTeamState_t).
These values indicate the player's relation to a team at (re)spawn time.
*])

_P([*
VERBATIM([*
typedef enum {
    _F(TEAM_BEGIN),     // Beginning a team game, spawn at base
    _F(TEAM_ACTIVE)     // Now actively playing
} playerTeamStateState_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(TEAM_BEGIN,[*
Player is spawning on this team for the first time.
*])
DICT(TEAM_ACTIVE,[*
Player has already been on this team.
*])
*])dnl LIST_DICT
*])dnl _P


SECT(spectatorState_t,enum spectatorState_t)
_P([*
Style of spectating for a spectator, _S(clientSession_t.spectatorState).
The field _S(clientSession_t.spectatorClient) may be used, depending on the particular handling of a spectator state.
*])

_P([*
VERBATIM([*
typedef enum {
    _F(SPECTATOR_NOT),
    _F(SPECTATOR_FREE),
    _F(SPECTATOR_FOLLOW),
    _F(SPECTATOR_SCOREBOARD)
} spectatorState_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(SPECTATOR_NOT,[*Not spectating/not a spectator.*])
DICT(SPECTATOR_FREE,[*Free movement.*])
DICT(SPECTATOR_FOLLOW,[*Follow a client.  The client to follow is specified in _S(clientSession_t.spectatorClient).*])
DICT(SPECTATOR_SCOREBOARD,[*Spectator at intermission (looking at scoreboad)*])
*])dnl LIST_DICT
*])dnl _P



SECT(level_locals_t,struct level_locals_t)
_P([*
Various level-wide variables.
*])

_P([*
VERBATIM([*
typedef struct {
    struct gclient_s    *clients;       // [maxclients]

    struct gentity_s    *gentities;
    int         gentitySize;
    int         num_entities;       // current number, <= MAX_GENTITIES

    int         warmupTime;         // restart match at this time

    fileHandle_t    logFile;

    // store latched cvars here that we want to get at often
    int         maxclients;

    int         framenum;
    int         time;                   // in msec
    int         previousTime;           // so movers can back up when blocked

    int         startTime;              // level.time the map was started

    int         teamScores[TEAM_NUM_TEAMS];
    int         lastTeamLocationTime;       // last time of client team location update

    qboolean    newSession;             // don't use any old session data, because
                                        // we changed gametype

    qboolean    restarted;              // waiting for a map_restart to fire

    int         numConnectedClients;
    int         numNonSpectatorClients; // includes connecting clients
    int         numPlayingClients;      // connected, non-spectators
    int         sortedClients[MAX_CLIENTS];     // sorted by score
    int         follow1, follow2;       // clientNums for auto-follow spectators

    int         snd_fry;                // sound index for standing in lava

    int         warmupModificationCount;    // for detecting if g_warmup is changed

    // voting state
    char        voteString[MAX_STRING_CHARS];
    char        voteDisplayString[MAX_STRING_CHARS];
    int         voteTime;               // level.time vote was called
    int         voteExecuteTime;        // time the vote is executed
    int         voteYes;
    int         voteNo;
    int         numVotingClients;       // set by CalculateRanks

    // team voting state
    char        teamVoteString[2][MAX_STRING_CHARS];
    int         teamVoteTime[2];        // level.time vote was called
    int         teamVoteYes[2];
    int         teamVoteNo[2];
    int         numteamVotingClients[2];// set by CalculateRanks

    // spawn variables
    qboolean    spawning;               // the G_Spawn*() functions are valid
    int         numSpawnVars;
    char        *spawnVars[MAX_SPAWN_VARS][2];  // key / value pairs
    int         numSpawnVarChars;
    char        spawnVarChars[MAX_SPAWN_VARS_CHARS];

    // intermission state
    int         intermissionQueued;     // intermission was qualified, but
                                        // wait INTERMISSION_DELAY_TIME before
                                        // actually going there so the last
                                        // frag can be watched.  Disable future
                                        // kills during this delay
    int         intermissiontime;       // time the intermission was started
    char        *changemap;
    qboolean    readyToExit;            // at least one client wants to exit
    int         exitTime;
    vec3_t      intermission_origin;    // also used for spectator spawns
    vec3_t      intermission_angle;

    qboolean    locationLinked;         // target_locations get linked
    gentity_t   *locationHead;          // head of the location list
    int         bodyQueIndex;           // dead bodies
    gentity_t   *bodyQue[BODY_QUEUE_SIZE];
#ifdef MISSIONPACK
    int         portalSequence;
#endif
} level_locals_t;
*])dnl VERBATIM

LIST_DICT([*
DICT(field,[*description*])
*])dnl LIST_DICT
*])dnl _P



<hr id="footer" width="42%" align="left">
<p>
Created 2002.09.21
<BR>Updated 2002.12.03
<BR>Updated 2003.11.10 - additions from cyrri.
<BR>Updated 2011.07.11 - change of contact e-mail.
ADDRESS([*
ENT_authornick
ENT_angbra ENT_authormail ENT_angket
*])
</body>
</html>
