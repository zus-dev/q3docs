# How clinent and server time works?

How `snap->serverTime` is set?

Server runs simulation at `sv_fps` frequency (default 20) based on `sv.time`. 
Server sends snapshots to clients and sets `serverTime` to `sv.time`.

```c
server_t sv; // local server at server/sv_main.c

SV_WriteSnapshotToClient (client, msg) at code/server/sv_snapshot.c
{
    MSG_WriteLong (msg, sv.time);
}
SV_SendClientSnapshot (client) at code/server/sv_snapshot.c
SV_SendClientMessages () at code/server/sv_snapshot.c
SV_Frame () at code/server/sv_main.c
{
    // run the game simulation in chunks              
    while ( sv.timeResidual >= frameMsec ) {          
        sv.timeResidual -= frameMsec;                 
        svs.time += frameMsec;                        
        sv.time += frameMsec;                         
                                                      
        // let everything in the world think and move 
        // Advances the non-player objects in the world (sv.time => levelTime):
        VM_Call (gvm, GAME_RUN_FRAME, sv.time)
        {
            vmMain (command=8) at code/game/g_main.c
            {
                G_RunFrame () at code/game/g_main.c
                {
                    level.previousTime = level.time;
                    level.time = levelTime;
                }
            }
        }
    }                                                 
}
Com_Frame () at code/qcommon/common.c
```

Client renders entities from snapshot based on `cl.serverTime` => `cg.time`
which is slightly behind the real server time.
Below is how `cg.time` is set:

```c
{
    int frametime;  // cg.time - cg.oldTime
    int time;       // this is the time value that the client
                    // is rendering at.
    int oldTime;    // time at last frame, used for missile trails and prediction checking
    int physicsTime;// either cg.snap->time or cg.nextSnap->time
} cg_t;

cg_t cg; // client game at cgame/cg_main.c

...

// Generates and draws a game scene and status information at the given time.                  
CG_DrawActiveFrame(int serverTime) at code/cgame/cg_view.c
{
    cg.time = serverTime;
}
vmMain at code/cgame/cg_main.c
VM_Call at code/qcommon/vm.c
CL_CGameRendering at code/client/cl_cgame.c
{
    VM_Call(cgvm, CG_DRAW_ACTIVE_FRAME, cl.serverTime)
}
SCR_DrawScreenField at code/client/cl_scrn.c
SCR_UpdateScreen at code/client/cl_scrn.c
CL_Frame at code/client/cl_main.c
{ 
    // decide the simulation time
    cls.frametime = msec;
    cls.realtime += cls.frametime;

    ...

    // decide on the serverTime to render 
    CL_SetCGameTime at code/client/cl_cgame.c
    {
        // cl_timeNudge is a user adjustable cvar that allows more
        // or less latency to be added in the interest of better  
        // smoothness or better responsiveness.                   
        int tn = cl_timeNudge->integer;                               
        if (tn<-30) {                                             
            tn = -30;                                             
        } else if (tn>30) {                                       
            tn = 30;                                              
        }                                                         

        cl.serverTime = cls.realtime + cl.serverTimeDelta - tn;

        ...

        // if we have gotten new snapshots, drift serverTimeDelta      
        // don't do this every frame, or a period of packet loss would 
        // make a huge adjustment                                      
        if ( cl.newSnapshots ) {                                       

            // Adjust the clients view of server time.                                  
            //                                                                          
            // We attempt to have cl.serverTime exactly equal the server's view         
            // of time plus the timeNudge, but with variable latencies over             
            // the internet it will often need to drift a bit to match conditions.      
            //                                                                          
            // Our ideal time would be to have the adjusted time approach, but not pass,
            // the very latest snapshot.                                                
            //                                                                          
            // Adjustments are only made when a new snapshot arrives with a rational    
            // latency, which keeps the adjustment process framerate independent and    
            // prevents massive overadjustment during times of significant packet loss  
            // or bursted delayed packets.                                              
            CL_AdjustTimeDelta at code/client/cl_cgame.c
            {
                if ( deltaDelta > RESET_TIME ) {                                                   
                    cl.serverTimeDelta = newDelta;                                                 
                    cl.oldServerTime = cl.snap.serverTime;  // FIXME: is this a problem for cgame? 
                    cl.serverTime = cl.snap.serverTime;                                            
                }
            }

        }                                                              
    }

    ...

    SCR_UpdateScreen()
}
Com_Frame at code/qcommon/common.c
```

e.g.:
```c
// sv_fps 20
G_RunFrame: levelTime:8700
CG_DrawActiveFrame: serverTime:8660
CG_DrawActiveFrame: serverTime:8678
CG_DrawActiveFrame: serverTime:8695
G_RunFrame: levelTime:8750
CG_DrawActiveFrame: serverTime:8711
CG_DrawActiveFrame: serverTime:8725
CG_DrawActiveFrame: serverTime:8742
// sv_fps 5
G_RunFrame: levelTime:8800
CG_DrawActiveFrame: serverTime:8757
CG_DrawActiveFrame: serverTime:8775
CG_DrawActiveFrame: serverTime:8792
CG_DrawActiveFrame: serverTime:8809
CG_DrawActiveFrame: serverTime:8825
CG_DrawActiveFrame: serverTime:8842
CG_DrawActiveFrame: serverTime:8859
CG_DrawActiveFrame: serverTime:8877
CG_DrawActiveFrame: serverTime:8893
CG_DrawActiveFrame: serverTime:8910
CG_DrawActiveFrame: serverTime:8926
CG_DrawActiveFrame: serverTime:8943
G_RunFrame: levelTime:9000
CG_DrawActiveFrame: serverTime:8960
CG_DrawActiveFrame: serverTime:8975
CG_DrawActiveFrame: serverTime:8991
CG_DrawActiveFrame: serverTime:9008
CG_DrawActiveFrame: serverTime:9025
CG_DrawActiveFrame: serverTime:9042
CG_DrawActiveFrame: serverTime:9059
CG_DrawActiveFrame: serverTime:9075
CG_DrawActiveFrame: serverTime:9092
CG_DrawActiveFrame: serverTime:9108
CG_DrawActiveFrame: serverTime:9125
CG_DrawActiveFrame: serverTime:9142
```
