# Interactive Panel

File: `cg_ents.c`

This is for collision-checks used by ray-tracers and the like. This function
is part of the library [OpenGL Mathematics (glm) for C](https://github.com/recp/cglm)

See details [here](https://cglm.readthedocs.io/en/latest/ray.html)
```c
/*!
 * @brief Möller–Trumbore ray-triangle intersection algorithm
 * 
 * @param[in] origin         origin of ray
 * @param[in] direction      direction of ray
 * @param[in] v0             first vertex of triangle
 * @param[in] v1             second vertex of triangle
 * @param[in] v2             third vertex of triangle
 * @param[in, out] d         distance to intersection
 * @return whether there is intersection
 */
qboolean
glm_ray_triangle(vec3_t   origin,
                 vec3_t   direction,
                 vec3_t   v0,
                 vec3_t   v1,
                 vec3_t   v2,
                 float *d) {
  vec3_t        edge1, edge2, p, t, q;
  float       det, inv_det, u, v, dist;
  const float epsilon = 0.000001f;

  VectorSubtract(v1, v0, edge1);
  VectorSubtract(v2, v0, edge2);
  CrossProduct(direction, edge2, p);

  det = DotProduct(edge1, p);
  if (det > -epsilon && det < epsilon)
    return qfalse;

  inv_det = 1.0f / det;
  
  VectorSubtract(origin, v0, t);

  u = inv_det * DotProduct(t, p);
  if (u < 0.0f || u > 1.0f)
    return qfalse;

  CrossProduct(t, edge1, q);

  v = inv_det * DotProduct(direction, q);
  if (v < 0.0f || u + v > 1.0f)
    return qfalse;

  dist = inv_det * DotProduct(edge2, q);

  if (d)
    *d = dist;

  return dist > epsilon;
}
```

The function below draws an interactive panel using the origin and angles of the
passed `cent`.  The function assumes that `cent` is a cube with 16 units side.
Note that function is not optimized and serves only as a raw concept.

Using a 4x4 matrix it's possible to offset and rotate the poly positions for
any plane origin and direction. `CG_AdjustPositionForMover()` in ioq3 / Spearmint
is the most direct example of vec3 offset + 3x3 rotation matrix in Q3 I can
think of, though it's very convoluted. 
Also see [The Matrix and Quaternions FAQ](https://www.flipcode.com/documents/matrfaq.html)

```c
static void CG_Panel( centity_t *cent) {
    qhandle_t panelShader;
	polyVert_t verts[4];
    // half-size actually
    int size = 8;
    // initial offset of the polygon
    int offsetX = -16;

	panelShader  = trap_R_RegisterShader( "gfx/misc/tracer" );
    if (!panelShader) {
        // TODO: Show warning!
        return;
    }

    // Create polygon
    VectorSet(verts[0].xyz, offsetX, -size, -size);  
    VectorSet(verts[1].xyz, offsetX, size, -size);  
    VectorSet(verts[2].xyz, offsetX, size, size);  
    VectorSet(verts[3].xyz, offsetX, -size, size);  

    // Move polygon to the specified origin
    vec3_t origin;
    //e.g.: VectorSet(origin, 64, -160, 64);
    VectorCopy(cent->lerpOrigin, origin);
    
    // Rotate and move polygon
	vec3_t	matrix[3], transpose[3];
	vec3_t	deltaAngles;
    // e.g.: VectorSet(deltaAngles, 45, 0, 0);
    VectorCopy(cent->currentState.angles, deltaAngles);

	// origin change when on a rotating object
	CG_CreateRotationMatrix( deltaAngles, transpose );
	CG_TransposeMatrix( transpose, matrix );
  
    int i;
    for (i = 0; i < 4; i++) {
        CG_RotatePoint( verts[i].xyz, matrix );
        VectorAdd(verts[i].xyz, origin, verts[i].xyz);
    }

    // Find intersection with player look
    vec3_t cursorOrigin;
    qboolean drawCursor = qfalse;
    {
        float d;
        vec3_t origin, direction, v0, v1, v2;
        VectorCopy(cg.predictedPlayerState.origin, origin);

        // Get player view direction
        VectorCopy(cg.predictedPlayerState.viewangles, direction);
        vec3_t forward, right, up;
        AngleVectors (direction, forward, right, up);
        VectorCopy(forward, direction);
        VectorNormalize(direction);

        // Ajust origin to muzzle point 
        // the code from CalcMuzzlePointOrigin
        vec3_t muzzlePoint;
        VectorCopy( origin, muzzlePoint );
        muzzlePoint[2] += cg.predictedPlayerState.viewheight;
        VectorMA( muzzlePoint, 14, forward, muzzlePoint );
        // NOTE: Do not snap to integer coordinates otherwise cursor movement is choppy
        // also rendering is client only so no network bandwidth issues with floats
        // SnapVector( muzzlePoint );
        VectorCopy( muzzlePoint, origin);

        VectorCopy(verts[0].xyz, v0);
        VectorCopy(verts[1].xyz, v1);
        VectorCopy(verts[2].xyz, v2);

        // Check one half (triangle) of the pannel
        if (glm_ray_triangle(origin, direction, v0, v1, v2, &d) == qtrue) {
            drawCursor = qtrue;
            VectorMA( origin, d, direction, cursorOrigin );
        } else {
            // Check second half (triangle) of the panel
            VectorCopy(verts[0].xyz, v0);
            VectorCopy(verts[3].xyz, v1);
            VectorCopy(verts[2].xyz, v2);
            if (glm_ray_triangle(origin, direction, v0, v1, v2, &d) == qtrue) {
                drawCursor = qtrue;
                VectorMA( origin, d, direction, cursorOrigin );
            }
        }
    }

	// set the polygon's texture coordinates
	verts[0].st[0] = 0;
	verts[0].st[1] = 0;
	verts[1].st[0] = 0;
	verts[1].st[1] = 1;
	verts[2].st[0] = 1;
	verts[2].st[1] = 1;
	verts[3].st[0] = 1;
	verts[3].st[1] = 0;

	trap_R_AddPolyToScene( panelShader, 4, verts );

    if (drawCursor) {
        int cursorSize = 1;
        qhandle_t cursorShader;
        cursorShader = trap_R_RegisterShader("menuback");
        VectorSet(verts[0].xyz, -0.1, -cursorSize, -cursorSize);  
        VectorSet(verts[1].xyz, -0.1, cursorSize, -cursorSize);  
        VectorSet(verts[2].xyz, -0.1, cursorSize, cursorSize);  
        VectorSet(verts[3].xyz, -0.1, -cursorSize, cursorSize);  

        // Rotate and move 
        for (i = 0; i < 4; i++) {
            CG_RotatePoint( verts[i].xyz, matrix );
            VectorAdd(verts[i].xyz, cursorOrigin, verts[i].xyz);
        }

        trap_R_AddPolyToScene( cursorShader, 4, verts );
    }
}
```

TODO: Clip rectangle polygons to the edge of the plane. clamp vertex
position to virtual screen bounds and linear interpolate texcoords at that
point so it's correct.

