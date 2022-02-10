# Hit Boxes 

[source](https://www.unknowncheats.me/forum/323682-post1.html)

In `cg_local.h` add this to your extern list
```c
extern  vmCvar_t        cg_drawBBox;
```

now in `cg_main.c` add this to your `vmCvar_t` list
```c
vmCvar_t    cg_drawBBox;
```

now add this to your static cvarTable which is located in the 
same place `cg_main.c`
```c
{ &cg_drawBBox, "cg_drawBBox", "0", CVAR_CHEAT },
```

Call this function, where your `refEntity` with weapons Head Torso Barel i.e
where // add the gun / barrel / flash is you find the correct place for it or
your bounding box just wont be displayed if called in the wrong location or at
the the wrong time.
```c
CG_AddBoundingBox( cent );
```

now for that main code, dont know where to put this then give up now, this is
your main function that draws and tells how the vectors and shader should be
placed around the entity.
```c
/*
=================
CG_AddBoundingBox
 
Draws a bounding box around a player.  Called from CG_Player.
=================
*/
void CG_AddBoundingBox( centity_t *cent ) {
	polyVert_t verts[4];
	clientInfo_t *ci;
	int i;
	vec3_t mins = {-15, -15, -24};
	vec3_t maxs = {15, 15, 32};
	float extx, exty, extz;
	vec3_t corners[8];
	qhandle_t bboxShader, bboxShader_nocull;
 
	if ( !cg_drawBBox.integer ) {
		return;
	}
 
	// don't draw it if it's us in first-person
	if ( cent->currentState.number == cg.predictedPlayerState.clientNum &&
			!cg.renderingThirdPerson ) {
		return;
	}
 
	// don't draw it for dead players
	if ( cent->currentState.eFlags & EF_DEAD ) {
		return;
	}
 
	// get the shader handles
	bboxShader = trap_R_RegisterShader( "bbox" );
	bboxShader_nocull = trap_R_RegisterShader( "bbox_nocull" );
 
	// if they don't exist, forget it
	if ( !bboxShader || !bboxShader_nocull ) {
		return;
	}
 
	// get the player's client info
	ci = &cgs.clientinfo[cent->currentState.clientNum];
 
	// if it's us
	if ( cent->currentState.number == cg.predictedPlayerState.clientNum ) {
		// use the view height
		maxs[2] = cg.predictedPlayerState.viewheight + 6;
	}
	else {
		int x, zd, zu;
 
		// otherwise grab the encoded bounding box
		x = (cent->currentState.solid & 255);
		zd = ((cent->currentState.solid>>8) & 255);
		zu = ((cent->currentState.solid>>16) & 255) - 32;
 
		mins[0] = mins[1] = -x;
		maxs[0] = maxs[1] = x;
		mins[2] = -zd;
		maxs[2] = zu;
	}
 
	// get the extents (size)
	extx = maxs[0] - mins[0];
	exty = maxs[1] - mins[1];
	extz = maxs[2] - mins[2];
 
	
	// set the polygon's texture coordinates
	verts[0].st[0] = 0;
	verts[0].st[1] = 0;
	verts[1].st[0] = 0;
	verts[1].st[1] = 1;
	verts[2].st[0] = 1;
	verts[2].st[1] = 1;
	verts[3].st[0] = 1;
	verts[3].st[1] = 0;
 
	// set the polygon's vertex colors
	if ( ci->team == TEAM_RED ) {
		for ( i = 0; i < 4; i++ ) {
			verts[i].modulate[0] = 160;
			verts[i].modulate[1] = 0;
			verts[i].modulate[2] = 0;
			verts[i].modulate[3] = 255;
		}
	}
	else if ( ci->team == TEAM_BLUE ) {
		for ( i = 0; i < 4; i++ ) {
			verts[i].modulate[0] = 0;
			verts[i].modulate[1] = 0;
			verts[i].modulate[2] = 192;
			verts[i].modulate[3] = 255;
		}
	}
	else {
		for ( i = 0; i < 4; i++ ) {
			verts[i].modulate[0] = 0;
			verts[i].modulate[1] = 128;
			verts[i].modulate[2] = 0;
			verts[i].modulate[3] = 255;
		}
	}
 
	VectorAdd( cent->lerpOrigin, maxs, corners[3] );
 
	VectorCopy( corners[3], corners[2] );
	corners[2][0] -= extx;
 
	VectorCopy( corners[2], corners[1] );
	corners[1][1] -= exty;
 
	VectorCopy( corners[1], corners[0] );
	corners[0][0] += extx;
 
	for ( i = 0; i < 4; i++ ) {
		VectorCopy( corners[i], corners[i + 4] );
		corners[i + 4][2] -= extz;
	}
 
	// top
	VectorCopy( corners[0], verts[0].xyz );
	VectorCopy( corners[1], verts[1].xyz );
	VectorCopy( corners[2], verts[2].xyz );
	VectorCopy( corners[3], verts[3].xyz );
	trap_R_AddPolyToScene( bboxShader, 4, verts );
 
	// bottom
	VectorCopy( corners[7], verts[0].xyz );
	VectorCopy( corners[6], verts[1].xyz );
	VectorCopy( corners[5], verts[2].xyz );
	VectorCopy( corners[4], verts[3].xyz );
	trap_R_AddPolyToScene( bboxShader, 4, verts );
 
	// top side
	VectorCopy( corners[3], verts[0].xyz );
	VectorCopy( corners[2], verts[1].xyz );
	VectorCopy( corners[6], verts[2].xyz );
	VectorCopy( corners[7], verts[3].xyz );
	trap_R_AddPolyToScene( bboxShader_nocull, 4, verts );
 
	// left side
	VectorCopy( corners[2], verts[0].xyz );
	VectorCopy( corners[1], verts[1].xyz );
	VectorCopy( corners[5], verts[2].xyz );
	VectorCopy( corners[6], verts[3].xyz );
	trap_R_AddPolyToScene( bboxShader_nocull, 4, verts );
 
	// right side
	VectorCopy( corners[0], verts[0].xyz );
	VectorCopy( corners[3], verts[1].xyz );
	VectorCopy( corners[7], verts[2].xyz );
	VectorCopy( corners[4], verts[3].xyz );
	trap_R_AddPolyToScene( bboxShader_nocull, 4, verts );
 
	// bottom side
	VectorCopy( corners[1], verts[0].xyz );
	VectorCopy( corners[0], verts[1].xyz );
	VectorCopy( corners[4], verts[2].xyz );
	VectorCopy( corners[5], verts[3].xyz );
	trap_R_AddPolyToScene( bboxShader_nocull, 4, verts );
}
```

