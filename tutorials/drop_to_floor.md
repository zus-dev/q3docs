# Drop To Floor

```c
// mappers like to put them exactly on the floor, but being coplanar
// will sometimes show up as starting in solid, so lif it up one pixel
ent->s.origin[2] += 1;

// drop to floor
trace_t tr;
vec3_t dest;
VectorSet( dest, ent->s.origin[0], ent->s.origin[1], ent->s.origin[2] - 4096 );
trap_Trace( &tr, ent->s.origin, ent->r.mins, ent->r.maxs, dest, ent->s.number, MASK_SOLID );
if ( tr.startsolid ) {
    ent->s.origin[2] -= 1;
    G_Printf( "entity: %s startsolid at %s\n", ent->classname, vtos(ent->s.origin) );

    ent->s.groundEntityNum = ENTITYNUM_NONE;
    G_SetOrigin( ent, ent->s.origin );
}
else {
    // allow to ride movers
    ent->s.groundEntityNum = tr.entityNum;
    G_SetOrigin( ent, tr.endpos );
}
```
