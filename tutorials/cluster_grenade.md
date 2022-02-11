# Cluster Grenade

See `game/g_missile.c`:
```c
gentity_t *fire_grenade (gentity_t *self, vec3_t start, vec3_t dir) {
    ...
    // G_MissileImpact will run if the grenade hits a target
    bolt->s.eType = ET_MISSILE;
    // G_ExplodeMissile will run if time runs out. And time will run out when:
    bolt->think = G_ExplodeMissile;
    // 2500 milliseconds (or 2.5 seconds) from when the grenade is launched.
    bolt->nextthink = level.time + 2500;
    ...
}
```

Add `game/g_missile.c`:
```c
/*
================
G_ExplodeCluster

Explode a cluster grenade into three shards
================
*/
void G_ExplodeCluster( gentity_t *ent ) {
    vec3_t dir;
    VectorSet(dir, 33, 33, 10);
    fire_cgrenade(ent->parent, ent->r.currentOrigin, dir);
    VectorSet(dir, -33, 33, 10);
    fire_cgrenade(ent->parent, ent->r.currentOrigin, dir);
    VectorSet(dir, 0, -33, 10);
    fire_cgrenade(ent->parent, ent->r.currentOrigin, dir);
}
```

Add `game/g_local.h`:
```c
gentity_t *fire_cgrenade (gentity_t *self, vec3_t start, vec3_t dir);
```

Add `game/g_missile.c`:
```c
/*
===============
fire_cgrenade
===============
*/
gentity_t *fire_cgrenade (gentity_t *self, vec3_t start, vec3_t dir) {
    gentity_t   *bolt;

    VectorNormalize (dir);

    bolt = G_Spawn();
    bolt->classname = "grenade";
    bolt->nextthink = level.time + 2500;
    bolt->think = G_ExplodeMissile;
    bolt->s.eType = ET_MISSILE;
    bolt->r.svFlags = SVF_USE_CURRENT_ORIGIN;
    bolt->s.weapon = WP_GRENADE_LAUNCHER;
    bolt->s.eFlags = EF_BOUNCE_HALF;
    bolt->r.ownerNum = self->s.number;
    bolt->parent = self;
    bolt->damage = 100;
    bolt->splashDamage = 100;
    bolt->splashRadius = 150;
    bolt->methodOfDeath = MOD_GRENADE;
    bolt->splashMethodOfDeath = MOD_GRENADE_SPLASH;
    bolt->clipmask = MASK_SHOT;
    bolt->target_ent = NULL;

    bolt->s.pos.trType = TR_GRAVITY;
    // move a bit on the very first frame
    bolt->s.pos.trTime = level.time - MISSILE_PRESTEP_TIME;
    VectorCopy( start, bolt->s.pos.trBase );
    VectorScale( dir, 300, bolt->s.pos.trDelta );
    // save net bandwidth
    SnapVector( bolt->s.pos.trDelta );

    VectorCopy (start, bolt->r.currentOrigin);

    return bolt;
}
```


Change function in `game/g_missile.c`:
```c
gentity_t *fire_grenade (gentity_t *self, vec3_t start, vec3_t dir) {
    ...
    // initially fire a cluster grenade
    bolt->classname = "cgrenade";
    // break apart faster than a normal grenade explodes
    bolt->nextthink = level.time + 1500;
    ...
```

Add at the end of the function in `game/g_missile.c`:
```c
void G_MissileImpact( gentity_t *ent, trace_t *trace ) {
    ...
    // cluster grenades will spawn 3 new grenades on explosion
    if (!strcmp(ent->classname,"cgrenade")) {
        G_ExplodeCluster( ent );
    }
    ...
}
```

Add at the end of the function in `game/g_missile.c`:
```c
void G_MissileImpact( gentity_t *ent, trace_t *trace ) {
    ...
    // cluster grenades will spawn 3 new grenades on explosion
    if (!strcmp(ent->classname,"cgrenade")) {
        G_ExplodeCluster( ent );
    }
    ...
}
```
