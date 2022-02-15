# Gravity Well


```c
// list - an array of integers is used by the function to hold any entities
// that positively past the test for existence within the box’s boundaries
// maxcount - the maximum amount of entities that will be in the array
int trap_EntitiesInBox( const vec3_t mins, const vec3_t maxs, int *list, int maxcount )
```

```c
/*
===============
G_Vortex
===============
*/
#define GVORTEX_TIMING 10 // 0.1 seconds
#define GVORTEX_VELOCITY 1000
#define GVORTEX_RADIUS 500
static void G_Vortex(gentity_t *self) {
    qboolean explode = qfalse;
    float dist;
    gentity_t *target = NULL;
    vec3_t start, dir, end, kvel, mins, maxs, v;
    int touch[MAX_GENTITIES], num, i, j;

    for (i = 0; i < 3; i++) {
        mins[i] = self->r.currentOrigin[i] - GVORTEX_RADIUS;
        maxs[i] = self->r.currentOrigin[i] + GVORTEX_RADIUS;
    }

    num = trap_EntitiesInBox(mins, maxs, touch, MAX_GENTITIES);
    for (j = 0; j < num; j++) {
        target = &g_entities[touch[j]];

        if (target == self) {
            continue;
        }
        if (target == self->parent) {
            // target is the client that fired the gravity well, skip it
            continue;
        }
        if (!target->client) {
            continue;
        }
        if (!target->takedamage) {
            continue;
        }
        if (target->health < 1) {
            // target is dead
            continue;
        }

        // Find a distance to the entity by extents instead of origin
        // because origin might be out of radius when extent in
        for (i = 0; i < 3; i++) {
            if (self->r.currentOrigin[i] < target->r.absmin[i]) {
                v[i] = target->r.absmin[i] - self->r.currentOrigin[i];
            } else if (self->r.currentOrigin[i] > target->r.absmax[i]) {
                v[i] = self->r.currentOrigin[i] - target->r.absmax[i];
            } else {
                v[i] = 0;
            }
        }

        dist = VectorLength(v);
        if (dist > GVORTEX_RADIUS) {
            continue;
        }

        if (!explode && dist <= 5) {
            explode = qtrue;
        }

        VectorCopy(target->r.currentOrigin, start);
        VectorCopy(self->r.currentOrigin, end);
        VectorSubtract(end, start, dir);
        VectorNormalize(dir);
        VectorScale(dir, GVORTEX_VELOCITY / GVORTEX_TIMING, kvel);
        VectorAdd(target->client->ps.velocity, kvel, target->client->ps.velocity);

        if (!target->client->ps.pm_time) {
            target->client->ps.pm_time = GVORTEX_TIMING - 1;
            // pm_time is an air-accelerate only time
            // if the velocity of the target is somehow acted upon by another object
            // the target’s velocity is not suddenly negated, which
            // would cause a jerky movement.This same code is used
            // by id when G_Damage is used to move a target with knock
            // back, and in the TeleportPlayer function, which kicks a
            // player out of a new teleport destination.
            target->client->ps.pm_flags |= PMF_TIME_KNOCKBACK;
        }

        VectorCopy(dir, target->movedir);
    }

    self->nextthink = level.time + GVORTEX_TIMING;
    if (explode || level.time > self->wait) {
        G_ExplodeMissile(self);
    }
}
```


```c
gentity_t *fire_grenade (gentity_t *self, vec3_t start, vec3_t dir) {
    ...
    // override think
    bolt->think = G_Vortex;
    bolt->nextthink = level.time + 1000; // run in 1 sec after firing (give some time)
    bolt->wait = level.time + 20000; // 20 sec before explosion
    ...
}
```
