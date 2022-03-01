# Quake 3 BSP Collision Detection

## 1. Introduction

This document is written to be a tutorial to teach how to implement collision
detection for the BSP46 (Quake 3's) map format. It is written for people who
already understand how the Quake 3 BSP structure works (and, preferrably, have
written a renderer of at least a basic level for the map format).

All of the code in the document is written in pseudo-code. Anything you see
referenced with `BSP.*` means the properties shown of the BSP file itself, after
it has been parsed. I don't bother worrying about specific types for structures
or classes at this point - it would only be confusing without any frame of
reference. When I've written the other tutorials on the map format itself, I
will change this code to reflect the types I explain there.

As such, I will only be using the following types in my code:
- `int` Identical to an int variable in C/C++.
- `float` Identical to a float variable in C/C++.
- `boolean` Identical to a bool variable in C/C++.
- `vector` First of all, our vector, or point (these terms are used
  interchangably in this document, as they represent the same thing in the
  Quake 3 source code), type is defined as follows:
  `typedef float[3] vector`
  I use the equals operator to set this, when in reality with a type defined as
  I have above, you would need to set each index in the array individually. I
  only do this to make the code more readable.
- `object` This is a generic term I will use to refer to any variable which, in
  normal code, would be represented by a structure or a class. The type that it
  represents should be evident to you if you understand the Quake 3 map
  format's organization already, but if you have any questions about the
  properties of one of the object variables, feel free to ask me about it.

## 2. Overview

In a Quake 3 BSP, each leaf in the world has a set of brushes that are
associated with it. Each brush, in turn, has a set of brush planes which are
associated with it. When clipped together, these brush planes form a convex
volume which represents the brush that you are trying to perform collision
detection against.

So, the way that id Software approached an interface to this collision
detection, and the way I, too, decided to design it, was to provide a single
trace function for the game to call which will determine if there is a
collision with the world (among other uses). This trace function takes several
arguments. First, it takes the starting point for a line segment. Second, it
takes the point that you are trying to end up at. It also takes a bounding box
around this point. Just to clarify, this box represents the bounding area for
the object that you are trying to move through the world. It is not the
bounding box for the line segment.

The trace function moves along the line between this starting and ending point,
and checks each leaf it encounters. If it collides with something, it stores a
value representing how far along this line it got before it ran into something,
and then progresses on. Each time it runs into something, if the collision
point is closer than the last collision point, it stores the new one instead.
This will give you the closest point of collision along the line as an end
result.

Now for the more technical details.

As you know, a BSP tree is made up of many nodes, each with a dividing plane,
splitting and splitting until it results in a leaf with no children. To
progress through the BSP tree, you start at the root node and check your point
against each splitting plane, and progress down the front or back split of the
node, depending on where you are located in relation to the plane. The
knowledge of how this works is essential to understanding the collision
detection process, so if you do not understand this, let me know and I will
explain it in more detail.

## 3. The Variables

So, the pieces of data we have available to us are as follows:

*INPUTS*
This is the information that the game will be passing to the function: our parameters.

- `inputStart (vector)`
  The point in the world where the trace will begin.
- `inputEnd (vector)`
  The position we are trying to reach in the BSP.

*OUTPUTS*
Our trace function will return (at a minimum) these values to the game. They
represent the result of our attempt to perform a trace using the specified
inputs.

- `outputFraction (float)`
  How far along the line we got before we collided. 0.5 == 50%, 1.0 == 100%.
- `outputEnd (vector)`
  The point of collision, in world space.
- `outputStartsOut (boolean)`
  True if the line segment starts outside of a solid volume.
- `outputAllSolid (boolean)`
  True if the line segment is completely enclosed in a solid volume.

We'll declare them (outputs as globals, inputs as parameters to the function)
and the initial Trace function, as follows:

```c
float outputFraction;
vector outputEnd;
boolean outputStartsOut;
boolean outputAllSolid;

void Trace( vector inputStart, vector inputEnd )
{
    // ...
}
```

Don't worry about the Trace function just yet - we'll get into that later. Note
that I wouldn't normally lay out my code with global input and output variables
like this, but it just makes it a lot simpler for the purposes of the document.

## 4. Tracing with a Line

Let's look at how we would perform a trace using this data with a single ray
first, disregarding the bounding box data. This is a lot simpler, and will make
the rest of it easier to comprehend.

### 4A. Checking the Nodes

In the beginning, the process is very similar to the one you would use to walk
through a BSP tree for other purposes (such as rendering). We start at the root
node, and we check start and end against the node's splitting plane using the
plane equation, like we normally would:

```c
void CheckNode( int nodeIndex,
                float startFraction, float endFraction,
                vector start, vector end )
{
    object *node = &BSP.nodes;[nodeIndex];
    object *plane = &BSP.planes;[node->planeIndex];

    float startDistance = DotProduct( start, plane->normal ) - plane->distance;
    float endDistance = DotProduct( end, plane->normal ) - plane->distance;
}
```

This gives us two floats which represent the distances of each point from the
splitting plane. We can then use these values to determine which nodes to
check. The text in gray is the code we've already gone over, and anything else
is new.

```c
void CheckNode( int nodeIndex,
                float startFraction, float endFraction,
                vector start, vector end )
{
    object *node = &BSP.nodes;[nodeIndex];
    object *plane = &BSP.planes;[node->planeIndex];

    float startDistance = DotProduct( start, plane->normal ) - plane->distance;
    float endDistance = DotProduct( end, plane->normal ) - plane->distance;

    if (startDistance >= 0 && endDistance >= 0)     // A
    {   // both points are in front of the plane
        // so check the front child
        CheckNode( node->children[0], startFraction, endFraction, start, end );
    }
    else if (startDistance < 0 && endDistance < 0)  // B
    {   // both points are behind the plane
        // so check the back child
        CheckNode( node->children[1], startFraction, endFraction, start, end );
    }
    else                                            // C
    {   // the line spans the splitting plane
        /* ... (will fill in) ... */
    }
}
```

What does the code above do? Well, we have three situations in this case. Just
like when you walk the BSP tree for rendering, our point can either be in front
(*A*) or behind (*B*) the splitting plane (we treat points that are coplanar with
the plane as in front of it). But, since we're dealing with a line segment, we
have a third option: the line can span both sections of the node, or cross the
splitting plane (*C*).

In the case of *A*, we know the entire line segment is in front of the splitting
plane, so we only have to progress down the front child of the current node.

*B* is the same, but for the back child instead.

For *C*, we have to check both children of the node. As you've probably noticed
with distress, this section isn't filled in on the code listing above. That's
because it takes a little bit more code than the other two, so I've expanded it
below:

```c
void CheckNode( int nodeIndex,
                float startFraction, float endFraction,
                vector start, vector end )
{
    object *node = &BSP.nodes;[nodeIndex];
    object *plane = &BSP.planes;[node->planeIndex];

    float startDistance = DotProduct( start, plane->normal ) - plane->distance;
    float endDistance = DotProduct( end, plane->normal ) - plane->distance;

    if (startDistance >= 0 && endDistance >= 0)
    {   // both points are in front of the plane
        // so check the front child
        CheckNode( node->children[0], startFraction, endFraction, start, end );
    }
    else if (startDistance < 0 && endDistance < 0)
    {   // both points are behind the plane
        // so check the back child
        CheckNode( node->children[1], startFraction, endFraction, start, end );
    }
    else
    {   // the line spans the splitting plane
        int side;
        float fraction1, fraction2, middleFraction;
        vector middle;

        // STEP 1: split the segment into two
        if (startDistance < endDistance)
        {
            side = 1; // back
            float inverseDistance = 1.0f / (startDistance - endDistance);
            fraction1 = (startDistance + EPSILON) * inverseDistance;
            fraction2 = (startDistance + EPSILON) * inverseDistance;
        }
        else if (endDistance < startDistance)
        {
            side = 0; // front
            float inverseDistance = 1.0f / (startDistance - endDistance);
            fraction1 = (startDistance + EPSILON) * inverseDistance;
            fraction2 = (startDistance - EPSILON) * inverseDistance;
        }
        else
        {
            side = 0; // front
            fraction1 = 1.0f;
            fraction2 = 0.0f;
        }

        // STEP 2: make sure the numbers are valid
        if (fraction1 < 0.0f) fraction1 = 0.0f;
        else if (fraction1 > 1.0f) fraction1 = 1.0f;
        if (fraction2 < 0.0f) fraction2 = 0.0f;
        else if (fraction2 > 1.0f) fraction2 = 1.0f;

        // STEP 3: calculate the middle point for the first side
        middleFraction = startFraction +
                         (endFraction - startFraction) * fraction1;
        for (i = 0; i < 3; i++)
            middle[i] = start[i] + fraction1 * (end[i] - start[i]);

        // STEP 4: check the first side
        CheckNode( node->children[side], startFraction, middleFraction,
                   start, middle );

        // STEP 5: calculate the middle point for the second side
        middleFraction = startFraction +
                        (endFraction - startFraction) * fraction2;
        for (i = 0; i < 3; i++)
            middle[i] = start[i] + fraction2 * (end[i] - start[i]);

        // STEP 6: check the second side
        CheckNode( node->children[!side], middleFraction, endFraction,
                   middle, end );  
    }
}
```

At this point, you're probably a little confused. I've labeled each step in the
code with numbers, so let's go through them one by one.

- *STEP 1*
  This is probably the worst part of it. Here we are comparing each of the
  distances we calculated earlier, and deciding which of the node's two
  children we want to recurse down first. We choose the side that is furthest
  away from the plane.
  Once we know which side we're going to progress down, we have to split the
  line segment into two pieces: one for each side of the node. This code splits
  it not exactly in the middle, but EPSILON units away from the plane on the
  closer side. EPSILON is our "really, really ridiculously small" unit value.
  Quake 3 defines it as 0.03125f, or 1/32.
  I have to tell you, I'm not really sure why they subtract instead of add
  EPSILON on fraction2 in the second block. I figured it out once but I can't
  remember anymore, so if any of you know the answer to that, please e-mail me
  and tell me. This is just something that id does, so I do as well.
- *STEP 2*
  Here we're just making sure that the two fractional values are in a valid
  range.
- *STEP 3*
  This section uses the first fraction we generated to create the middle point
  for the first side of the node. It subtracts start from end, to find the
  length of the current ray, and multiplies that by our fractional value,
  then adds it to the start point. This gives us a point a percentage along
  the line.
- *STEP 4*
  Now we have to actually recurse down to the first side of this node. We use
  the side that we chose in step one, and pass it the values we've generated up
  to this point. What we're actually doing is checking for a collision from the
  start point to the new middle point we've just found.
- *STEP 5*
  This is just a repeat of step 3, but for fraction2, instead.
- *STEP 6*
  This is just a repeat of step 4, but for the second side. This is checking
  for a collision from the middle to the end point.

We're almost there! Right now we have the code to walk all the way down the
nodes to the leaves we might possibly collide with. But how do we know when
we've reached a leaf, and what do we do when we find one?

Quake 3's map format actually makes this very easy to detect. As you know, each
node has two values for its children (`node->children[0 and 1]`) which are
indexes into the node array. If the value is negative, it means that the next
child is a leaf. So how do we use this? Let's add something to the starting of
our function.

```c
void CheckNode( int nodeIndex,
                float startFraction, float endFraction,
                vector start, vector end )
{
    if (nodeIndex < 0)
    {   // this is a leaf
        object *leaf = &BSP.leaves;[-(nodeIndex + 1)];
        for (i = 0; i < leaf->numLeafBrushes; i++)
        {
            object *brush = &BSP.brushes;[BSP.leafBrushes[leaf->firstLeafBrush + i]];
            if (brush->numSides > 0 &&
                (BSP.shaders[brush->shaderIndex].contentFlags & 1))
                CheckBrush( brush );
        }

        // don't have to do anything else for leaves
        return;
    }

    // this is a node

    object *node = &BSP.nodes;[nodeIndex];
    object *plane = &BSP.planes;[node->planeIndex];

    float startDistance = DotProduct( start, plane->normal ) - plane->distance;
    float endDistance = DotProduct( end, plane->normal ) - plane->distance;

    ...
}
```

The code above does one thing: if the current node is a leaf, it goes through
each brush in that leaf, and, if needed, checks the brush for a collision. I
say if needed because some brushes should not be checked. Those include those
without any brush sides (or planes), and those that aren't solid.

*Very Important*: You can see that I underlined a section of the code above, and
it is relevant to this point. When I first implemented collision detection with
this BSP format, I was banging my head on the wall trying to figure out why it
wasn't working. It turns out I wasn't performing the check I do above, and
because of this, I was checking against brushes that weren't supposed to be
solid. This value we're doing the bitwise AND against should actually be
specified by the game itself, as the Quake games do, but I didn't want to
complicate it. The check here just makes sure that it is solid 
(`1 == CONTENTS_SOLID` in the Quake source code).


If the brush is supposed to be checked, we call the function `CheckBrush`.
`CheckBrush` is the next part of our collision detection solution.

### 4B. Checking the Brushes

Each brush in the BSP has a number of brush sides that are associated with it.
Each of these brush sides contains an index into the plane array for the plane
that represents it. In order for us to check for collisions against a brush, we
have to loop through this list of brushes, and check each individually.

```c
void CheckBrush( object *brush )
{
    for (int i = 0; i < brush->numSides; i++)
    {
        object *brushSide = &BSP.brushSides;[brush->firstSide + i];
        object *plane = &BSP.planes;[brushSide->planeIndex];
    }
}
```

As you can see, there isn't anything here except the loop itself, so let's fill
it out some more. Our first few steps, again, are much the same as always with
planes:

```c
void CheckBrush( object *brush )
{
    float startFraction = -1.0f;
    float endFraction = 1.0f;
    boolean startsOut = false;
    boolean endsOut = false;

    for (int i = 0; i < brush->numSides; i++)
    {
        object *brushSide = &BSP.brushSides;[brush->firstSide + i];
        object *plane = &BSP.planes;[brushSide->planeIndex];

        float startDistance = DotProduct( inputStart, plane->normal ) -
                              plane->distance;
        float endDistance = DotProduct( inputEnd, plane->normal ) -
                            plane->distance;

        if (startDistance > 0)
            startsOut = true;
        if (endDistance > 0)
            endsOut = true;

        // make sure the trace isn't completely on one side of the brush
        if (startDistance > 0 && endDistance > 0)
        {   // both are in front of the plane, its outside of this brush
            return;
        }
        if (startDistance <= 0 && endDistance <= 0)
        {   // both are behind this plane, it will get clipped by another one
            continue;
        }

        // MMM... BEEFY
        if (startDistance > endDistance)
        {   // line is entering into the brush
            float fraction = (startDistance - EPSILON) / (startDistance - endDistance);  // *
            if (fraction > startFraction)
                startFraction = fraction;
        }
        else
        {   // line is leaving the brush
            float fraction = (startDistance + EPSILON) / (startDistance - endDistance);  // *
            if (fraction < endFraction)
                endFraction = fraction;
        }
    }
}
```

The first 2 lines of this addition should look familiar: it's the plane
equation again. We use these two distances to find out if the line segment
actually intersects with each brush plane. Ignore the `startsOut` and `endsOut`
for now, we'll address that later. Look at the code below it.

We only want to test this line segment if it traverses one of the brush planes.
The first check verifies that its inside the brush at all; if a line segment is
completely in front of any of the planes in a brush, we can disregard that
brush. The second if statement confirms that it actually crosses the plane. If
both the points are behind the plane, we don't bother testing it - it will be
clipped by one of the other brush sides.

Now we get to the third part, labelled by the underlined comment. This is the
meat of the entire algorithm. At this point we know that the line crosses the
plane (and collides with the brush), we just have to find out which side
collides, and how much of it. The greater distance is the one that is in front
of the plane. Once we know which side is in front, we calculate the fractional
value with the code which have commented red articstik on the two lines above.
If this fractional value is less than the appropriate variable (`startFraction`
or `endFraction`), it means that its a closer collision than the last one, so
we set the variable to it.

We only have one more thing to add to this function.

```c
void CheckBrush( object *brush )
{
    float startFraction = -1.0f;
    float endFraction = 1.0f;
    boolean startsOut = false;
    boolean endsOut = false;

    for (int i = 0; i < brush->numSides; i++)
    {
        object *brushSide = &BSP.brushSides;[brush->firstSide + i];
        object *plane = &BSP.planes;[brushSide->planeIndex];

        float startDistance = DotProduct( inputStart, plane->normal ) -
                              plane->distance;
        float endDistance = DotProduct( inputEnd, plane->normal ) -
                            plane->distance;

        if (startDistance > 0)
            startsOut = true;
        if (endDistance > 0)
            endsOut = true;

        // make sure the trace isn't completely on one side of the brush
        if (startDistance > 0 && endDistance > 0)
        {   // both are in front of the plane, its outside of this brush
            return;
        }
        if (startDistance <= 0 && endDistance <= 0)
        {   // both are behind this plane, it will get clipped by another one
            continue;
        }

        if (startDistance > endDistance)
        {   // line is entering into the brush
            float fraction = (startDistance - EPSILON) / (startDistance - endDistance);
            if (fraction > startFraction)
                startFraction = fraction;
        }
        else
        {   // line is leaving the brush
            float fraction = (startDistance + EPSILON) / (startDistance - endDistance);
            if (fraction < endFraction)
                endFraction = fraction;
        }
    }

    if (startsOut == false)
    {
        outputStartOut = false;
        if (endsOut == false)
            outputAllSolid = true;
        return;
    }

    if (startFraction < endFraction)
    {
        if (startFraction > -1 && startFraction < outputFraction)
        {
            if (startFraction < 0)
                startFraction = 0;
            outputFraction = startFraction;
        }
    }
}
```

Now we can talk about the section I told you to ignore before. If either end's
distance is greater than zero, it means that end starts outside of the brush.
So, we check for this and set the `startsOut` and `endsOut` variables to true
if this is true for any of the brush sides. If, after checking all of the brush
sides, both of these variables are false, the trace is stuck inside of the
brush, so we set `outputAllSolid` to false, and return.

The last conditional block in this function is the one that will actually apply
the collision information to the output data. If the following conditions are
satisfied:

- `startFraction` is less than `endFraction` (this will be true because of the
  way that we set them at the starting of the function)
- `startFraction` is greater than -1 (the default value)
- `startFraction` is less than, or closer to the beginning of the trace, than
  the current `outputFraction`

Then we set the outputFraction equal to this fraction.

### 4C. Using the Check Functions

So now that we have these two functions that we can use to check for the
collision of a ray against the BSP, how do we actually use them? I've written
an example implementation of a general `Trace` function below. Just like the
other source listings, this is generic pseudo-code, and I'm just setting the
`output*` variables instead of actually returning data. You'd have to adjust it
for your own engine.

Refer to [SECTION4.TXT](./bsp_collision_detection/section4.txt) for a full source listing for this
section.

```c
void Trace( vector inputStart, vector inputEnd )
{
    outputStartsOut = true;
    outputAllSolid = false;
    outputFraction = 1.0f;

    // walk through the BSP tree
    CheckNode( 0, 0.0f, 1.0f, inputStart, inputEnd );

    if (outputFraction == 1.0f)
    {   // nothing blocked the trace
        outputEnd = inputEnd;
    }
    else
    {   // collided with something 
        for (i = 0; i < 3; i++)
        {
            outputEnd[i] = inputStart[i] +
                           outputFraction * (inputEnd[i] - inputStart[i]);
        }
    }
}
```

## 5. Tracing with a Sphere

The details in modifying our code to allow us to check against a sphere instead
of a ray aren't that complicated - but I'm going to add a bit of code to
provide an interface to the game for us to specify what type of trace we want
to do. Sometimes you may only want to trace by a ray (when finding the path of
a bullet, for example), and other times you may want to trace with a sphere, so
we'll provide a method for the game to easily to either or.

First, we're going to add some variables to our code. They keep track of the
type of trace we're performing, and what constraints we want to put on that
trace. Here are the variables:

```c
#define TT_RAY		0
#define TT_SPHERE	1

int traceType;
float traceRadius;
```

Our first variable is `traceType`. This is set to let our tracing functions
change how they work depending on what type of trace we want to perform. The
possible values of this variable are `#defined` above it. Like much that I do in
this document, I'm using `#defines` for simplicity - I would actually recommend
using an `enum` instead.

The second variable, represents the radius of the bounding sphere of the object
we are trying to trace through the world. This value should be positive.

Now let's create two functions for the game to call for the different types of
traces.

```c
void TraceRay( vector inputStart, vector inputEnd )
{
    traceType = TT_RAY;
    Trace( inputStart, inputEnd );
}

void TraceSphere( vector inputStart, vector inputEnd, float inputRadius )
{
    traceType = TT_SPHERE;
    traceRadius = inputRadius;
    Trace( inputStart, inputEnd );
}
```

Both of these functions just set the `trace*` variables appropriately, and then
pass off control to the `Trace` function for the rest of it. I don't set
`traceRadius` in `TraceRay` because it will never be used for a ray based
trace...  as you will soon see.

Now we must modify the `CheckNode` function to account for the extra padding we
have around our object in sphere tracing mode. The modifications are shown
below.

```c
void CheckNode( int nodeIndex,
                float startFraction, float endFraction,
                vector start, vector end )
{
    [ ... unchanged code ... ]

    // this is a node

    object *node = &BSP.nodes;[nodeIndex];
    object *plane = &BSP.planes;[node->planeIndex];

    float startDistance, endDistance, offset;
    startDistance = DotProduct( start, plane->normal ) - plane->distance;
    endDistance = DotProduct( end, plane->normal ) - plane->distance;

    if (traceType == TT_RAY)
    {
        offset = 0;
    }
    else if (traceType == TT_SPHERE)
    {
        offset = traceRadius;
    }

    if (startDistance >= offset && endDistance >= offset)
    {   // both points are in front of the plane
        // so check the front child
        CheckNode( node->children[0], startFraction, endFraction, start, end );
    }
    else if (startDistance < -offset && endDistance < -offset)
    {   // both points are behind the plane
        // so check the back child
        CheckNode( node->children[1], startFraction, endFraction, start, end );
    }
    else
    {   // the line spans the splitting plane
        int side;
        float fraction1, fraction2, middleFraction;
        vector middle;

        // split the segment into two
        if (startDistance < endDistance)
        {
            side = 1; // back
            float inverseDistance = 1.0f / (startDistance - endDistance);
            fraction1 = (startDistance - offset + EPSILON) * inverseDistance;
            fraction2 = (startDistance + offset + EPSILON) * inverseDistance;
        }
        else if (endDistance < startDistance)
        {
            side = 0; // front
            float inverseDistance = 1.0f / (startDistance - endDistance);
            fraction1 = (startDistance + offset + EPSILON) * inverseDistance;
            fraction2 = (startDistance - offset - EPSILON) * inverseDistance;
            }
        else
        {
            side = 0; // front
            fraction1 = 1.0f;
            fraction2 = 0.0f;
        }

        [ ... unchanged code ... ]
    }
}
```

We've made a simple but essential modification to this function. In the first
change, we've added a new variable: `offset`. This variable tells us how close
something has to be to a plane to be considered a collision. In the case of the
ray trace, it has to be directly against something to hit it, so we set `offset`
to zero. In the case of a sphere, we set it to the radius of the sphere.

Our second change pads the middle point by the amount we chose for the `offset`,
so that we're that much on either side of the split.

Now we need to modify the `CheckBrush` function.

```c
void CheckBrush( object *brush )
{
    float startFraction = -1.0f;
    float endFraction = 1.0f;
    boolean startsOut = false;
    boolean endsOut = false;

    for (int i = 0; i < brush->numSides; i++)
    {
        object *brushSide = &BSP.brushSides;[brush->firstSide + i];
        object *plane = &BSP.planes;[brushSide->planeIndex];

        float startDistance, endDistance;
        if (traceType == TT_RAY)
        {
            startDistance = DotProduct( inputStart, plane->normal ) -
                            plane->distance;
            endDistance = DotProduct( inputEnd, plane->normal ) -
                          plane->distance;
        }
        else if (traceType == TT_SPHERE)
        {
            startDistance = DotProduct( inputStart, plane->normal ) -
                            (plane->distance + traceRadius);
            endDistance = DotProduct( inputEnd, plane->normal ) -
                          (plane->distance + traceRadius);
        }

        if (startDistance > 0)
            startsOut = true;
        if (endDistance > 0)
            endsOut = true;

        [ ... unchanged code ... ]
}
```

The modification we have done here is very similar to the one we made to
`CheckNode`. We're just padding the distance with the radius of the sphere.

And that's it! As you can see the modifications are pretty simple once you
understand how the collision detection system works. If you call `TraceSphere`
with the parameters you want, it will keep your movement from getting right up
against things. Check out [SECTION5.TXT](./bsp_collision_detection/section5.txt) for a full source listing of this
section.

## 6. Tracing with a Box

Some situations call for the use of a bounding box instead of a bounding
sphere. Adding this functionality to our system isn't too hard. First, let's
add a new trace type and some trace variables:

```c
#define TT_RAY 0
#define TT_SPHERE 1
#define TT_BOX 2

int traceType;
float traceRadius;
vector traceMins;
vector traceMaxs;
vector traceExtents;
```

The first two variables represent two corners of the bounding box which
surrounds our object. These values are in object space, like the radius. For
example: for a box that is 20 units in size in all directions and is centered
around the origin of the object, `traceMins` would be `(-10,-10,-10)` and `traceMaxs`
would be `(10,10,10)`.

`traceExtents` stores the maximum of the absolute value of each axis in the
box. For example, if `traceMins` was `(-100,-3,-15)` and `traceMaxs` was
`(55,22,7)`, `traceExtents` would be `(100,22,15)`.

Now, let's add our new trace function:

```c
void TraceBox( vector inputStart, vector inputEnd,
               vector inputMins, vector inputMaxs )
{
    if (inputMins[0] == 0 && inputMins[1] == 0 && inputMins[2] == 0 &&
        inputMaxs[0] == 0 && inputMaxs[1] == 0 && inputMaxs[2] == 0)
    {   // the user called TraceBox, but this is actually a ray
        TraceRay( inputStart, inputEnd );
    }
    else
    {   // setup for a box
        traceType = TT_BOX;
        traceMins = inputMins;
        traceMaxs = inputMaxs;
        traceExtents[0] = -traceMins[0] > traceMaxs[0] ?
                          -traceMins[0] : traceMaxs[0];
        traceExtents[1] = -traceMins[1] > traceMaxs[1] ?
                          -traceMins[1] : traceMaxs[1];
        traceExtents[2] = -traceMins[2] > traceMaxs[2] ?
                          -traceMins[2] : traceMaxs[2];
        Trace( inputStart, inputEnd );
    }
}
```

After writing `TraceRay` and `TraceSphere`, this function shouldn't be too hard to
grasp. The first if statement just verifies that they actually gave us a
bounding box. If all of the values are zero, there is no point in using a box
test - it is just a ray, so we pass it off.

If it is indeed a box, we setup all of our `trace*` variables accordingly.
`traceMins` and `traceMaxs` are just copied over from the input variables, and
`traceExtents` is built from those to get the values that we described above.

We have to make some modifications to our other functions to do a box trace.
The modifications to the `CheckNode` function are as follows:

```c
void CheckNode( int nodeIndex,
                float startFraction, float endFraction,
                vector start, vector end )
{
    [ ... unchanged code ... ]

    if (traceType == TT_RAY)
    {
        offset = 0;
    }
    else if (traceType == TT_SPHERE)
    {
        offset = traceRadius;
    }
    else if (traceType == TT_BOX)
    {
        // this is just a dot product, but we want the absolute values
        offset = (float)(fabs( traceExtents[0] * plane->normal[0] ) +
                         fabs( traceExtents[1] * plane->normal[1] ) +
                         fabs( traceExtents[2] * plane->normal[2] ) );
    }

    [ ... unchanged code ... ]
}
```

What we're doing here is taking the absolute value of the extents for each
axis, and multiplying it by the plane normal, then adding them together to get
our offset. How does this give us our offset? If you remember back to your dot
product math (as this really is just a dot product, but we're using the
absolute values of the multiplication), the dot product of a point and the
normalized vector for a plane give us the distance of the point from the plane.
By doing what we do above, we're basically taking the bounding box, padding it
with the maximum size on any axis, and finding how far away that is from the
plane. We can use the value this results in to find out if they have a
possibility of colliding.

Here are the changes to the CheckBrush function:

```c
void CheckBrush( object *brush )
{
    [ ... unchanged code ... ]

        if (traceType == TT_RAY)
        {
            startDistance = DotProduct( inputStart, plane->normal ) -
                            plane->distance;
            endDistance = DotProduct( inputEnd, plane->normal ) -
                          plane->distance;
        }
        else if (traceType == TT_SPHERE)
        {
            startDistance = DotProduct( inputStart, plane->normal ) -
                            (plane->distance + traceRadius);
            endDistance = DotProduct( inputEnd, plane->normal ) -
                          (plane->distance + traceRadius);
        }
        else if (traceType == TT_BOX)
        {
            vector offset;
            for (int j = 0; j < 3; j++)
            {
                if (plane->normal[j] < 0)
                    offset[j] = traceMaxs[j];
                else
                    offset[j] = traceMins[j];
            }

            startDistance = (inputStart[0] + offset[0]) * plane->normal[0] +
                            (inputStart[1] + offset[1]) * plane->normal[1] +
                            (inputStart[2] + offset[2]) * plane->normal[2] -
                            plane->distance;
            endDistance = (inputEnd[0] + offset[0]) * plane->normal[0] +
                          (inputEnd[1] + offset[1]) * plane->normal[1] +
                          (inputEnd[2] + offset[2]) * plane->normal[2] -
                          plane->distance;
        }

    [ ... unchanged code ... ]
}
```

This works pretty much the same way that it does for the sphere tracing, except
we have to calculate a padding vector, since we're working with a bounding box
with the possibility of being a different size on each axis. So, we calculate
the offset and perform a dot product, adding the offset to the two input
points.

And you're all done! See the file [SECTION6.TXT](./bsp_collision_detection/section6.txt) for a full source listing.

## 7. Conclusion

fter reading this tutorial, you should have a good understanding of how you can
use the data stored in a Quake 3 BSP file to do collision detection in your
engine. If, for any reason, you don't and have some questions or comments, I
urge you to e-mail me at nostgard@lvcm.com. I eagerly await your messages.

Some informed readers may notice that I don't take advantage of some tricks the
Quake 3 engine uses (such as optimizations for axis aligned planes). The
document was long enough already, and I didn't want to get into this yet. I
will be creating a second document offering ways to optimize your code.

If you don't want to wait for that, you should take a look at the Quake 2
source code. My code is heavily based on it, and you should be able to see the
optimizations immediately. Here are some links you can look at:

- Quake 2: id Software was nice enough to release the Quake 2 source code under
  the GPL license. Much can be learned from it.
- QFusion: This is an engine that adds support for Quake 3 data types to the
  Quake 2 engine.

I hope you enjoyed the tutorial, and remember to send me your comments!
