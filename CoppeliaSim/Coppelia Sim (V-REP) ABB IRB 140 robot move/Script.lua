function sysCall_init()
    corout=coroutine.create(coroutineMain)
end

function sysCall_actuation()
    if coroutine.status(corout)~='dead' then
        local ok,errorMsg=coroutine.resume(corout)
        if errorMsg then
            error(debug.traceback(corout,errorMsg),2)
        end
    end
end

function movCallback(config,vel,accel,handles)
    for i=1,#handles,1 do
        if sim.isDynamicallyEnabled(handles[i]) then
            sim.setJointTargetPosition(handles[i],config[i])
        else    
            sim.setJointPosition(handles[i],config[i])
        end
    end
end

function moveToConfig(handles,maxVel,maxAccel,maxJerk,targetConf)
    local currentConf={}
    for i=1,#handles,1 do
        currentConf[i]=sim.getJointPosition(handles[i])
    end
    sim.moveToConfig(-1,currentConf,nil,nil,maxVel,maxAccel,maxJerk,targetConf,nil,movCallback,handles)
end

function coroutineMain()
    sim.setThreadAutomaticSwitch(false)
    local jointHandles={}
    for i=1,6,1 do
        jointHandles[i]=sim.getObject('./joint',{index=i-1})
    end

    local vel=110  
    local accel=40
    local jerk=80
    local maxVel={vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180}
    local maxAccel={accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180}
    local maxJerk={jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180}

    local targetPos1={30*math.pi/180,49*math.pi/180,59*math.pi/180,-90*math.pi/180,90*math.pi/180,90*math.pi/180,0}
    moveToConfig(jointHandles,maxVel,maxAccel,maxJerk,targetPos1)

    local targetPos2={0,0,0,0,0,0,0}
    moveToConfig(jointHandles,maxVel,maxAccel,maxJerk,targetPos2)
    
    local targetPos3={30*math.pi/180,49*math.pi/180,59*math.pi/180,-90*math.pi/180,90*math.pi/180,90*math.pi/180,0}
    moveToConfig(jointHandles,maxVel,maxAccel,maxJerk,targetPos3)

    local targetPos4={0,0,0,0,0,0,0}
    moveToConfig(jointHandles,maxVel,maxAccel,maxJerk,targetPos4)

end
