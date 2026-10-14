--[[ luxxs v4.6 | DrHub | MM2 | + Bunnyhop ]]
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local HttpService=game:GetService("HttpService")
local VU=game:GetService("VirtualUser")
local LP=Players.LocalPlayer

local FOLDER="luxxs"
local VALID_KEY="DRHUB_DRHUB_BEST"
local hasFS=type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function"
local function ensureFolder() if type(makefolder)=="function" and type(isfolder)=="function" and not isfolder(FOLDER) then pcall(makefolder,FOLDER) end end

-- THEME
local ACCENTS={Lime=Color3.fromRGB(196,255,61),Coral=Color3.fromRGB(255,104,84),Ice=Color3.fromRGB(110,214,255),Violet=Color3.fromRGB(158,110,255),Gold=Color3.fromRGB(255,196,70),Rose=Color3.fromRGB(255,96,160)}
local ACCENT_NAMES={"Lime","Coral","Ice","Violet","Gold","Rose"}
local ACC_NAME="Lime"
if hasFS then pcall(function() local p=FOLDER.."/accent.txt"; if isfile(p) then local n=readfile(p); if ACCENTS[n] then ACC_NAME=n end end end) end
local ACC=ACCENTS[ACC_NAME]

local C={bg=Color3.fromRGB(11,11,14),panel=Color3.fromRGB(16,16,20),row=Color3.fromRGB(24,24,30),line=Color3.fromRGB(40,40,48),off=Color3.fromRGB(58,58,68),text=Color3.fromRGB(232,232,226),dim=Color3.fromRGB(122,122,136)}
local WHITE=Color3.fromRGB(255,255,255)
local AIM_RED=Color3.fromRGB(255,64,64)
local BODY_GRAY=Color3.fromRGB(196,196,206)
local F_HEAD,F_BODY,F_MONO,F_SEC=Enum.Font.Michroma,Enum.Font.SourceSansSemibold,Enum.Font.RobotoMono,Enum.Font.Oswald

local themed={}
local function T(o,p,fn) themed[#themed+1]={o,p,fn}; o[p]=fn and fn(ACC) or ACC end
local function setAccent(c) ACC=c; for _,t in ipairs(themed) do pcall(function() t[1][t[2]]=t[3] and t[3](ACC) or ACC end) end end

local PALETTE={Lime=ACCENTS.Lime,Coral=ACCENTS.Coral,Ice=ACCENTS.Ice,Violet=ACCENTS.Violet,Gold=ACCENTS.Gold,Red=Color3.fromRGB(255,60,60),Green=Color3.fromRGB(70,230,110),Blue=Color3.fromRGB(70,110,255),Pink=Color3.fromRGB(255,110,200),White=Color3.fromRGB(255,255,255)}
local COLOR_NAMES={"Rainbow","Lime","Coral","Ice","Violet","Gold","Red","Green","Blue","Pink","White"}
local WING_COLORS={"White","Gold","Rainbow","Ice","Violet","Pink","Coral"}
local ROLE_COLORS={Murderer=Color3.fromRGB(255,60,60),Sheriff=Color3.fromRGB(70,130,255),Innocent=Color3.fromRGB(70,230,110)}
local ROLE_NAMES={"Murderer","Sheriff","Innocent"}
local HAT_COLORS={"Custom","Rainbow","Lime","Coral","Ice","Violet","Gold","Red","Green","Blue","Pink","White"}

_G.LUXXS_HAT_H=280; _G.LUXXS_HAT_S=0.7; _G.LUXXS_HAT_V=1

local function getColor(n,t,o)
    if n=="Rainbow" then return Color3.fromHSV((((t or 0)*0.2)+(o or 0))%1,0.85,1) end
    if n=="Custom" then return Color3.fromHSV(((_G.LUXXS_HAT_H%360)/360),math.clamp(_G.LUXXS_HAT_S,0,1),math.clamp(_G.LUXXS_HAT_V,0,1)) end
    return PALETTE[n] or ACC
end

local connections={} local function track(c) connections[#connections+1]=c; return c end
local function tween(o,ti,p,s,d) local tw=TweenService:Create(o,TweenInfo.new(ti,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),p); tw:Play(); return tw end
local function corner(o,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=o; return c end
local function stroke(o,col,th,tr) local s=Instance.new("UIStroke"); s.Color=col; s.Thickness=th or 1; s.Transparency=tr or 0; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=o; return s end
local function gradient(f,rot,seq,tseq)
    local g=Instance.new("UIGradient"); g.Rotation=rot or 0
    if seq then g.Color=seq end
    if tseq then g.Transparency=tseq end
    g.Parent=f; return g
end
local function cornerTick(parent,x,y,dx,dy,len,z)
    local h=Instance.new("Frame"); h.BorderSizePixel=0; h.Size=UDim2.new(0,len,0,1); h.Position=UDim2.new(0,dx>0 and x or x-len,0,dy>0 and y or y-1); h.ZIndex=z or 5; h.Parent=parent; T(h,"BackgroundColor3")
    local v=Instance.new("Frame"); v.BorderSizePixel=0; v.Size=UDim2.new(0,1,0,len); v.Position=UDim2.new(0,dx>0 and x or x-1,0,dy>0 and y or y-len); v.ZIndex=z or 5; v.Parent=parent; T(v,"BackgroundColor3")
end

local GradRefresh={}
local Flags,Setters,Defaults={},{},{} local function register(k,d,s) Flags[k]=d; Defaults[k]=d; Setters[k]=s end

local gui=Instance.new("ScreenGui")
gui.Name="luxxs"; gui.ResetOnSpawn=false; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.IgnoreGuiInset=true
local okP,parent=pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
if not okP or not parent then parent=LP:WaitForChild("PlayerGui") end
if parent:FindFirstChild("luxxs") then parent.luxxs:Destroy() end
if parent:FindFirstChild("luxxsKey") then parent.luxxsKey:Destroy() end
if parent:FindFirstChild("luxxsFPS") then parent.luxxsFPS:Destroy() end
gui.Parent=parent

print("[luxxs] v4.6 loaded, gui parent="..tostring(parent and parent:GetFullName()))

-- KEY SCREEN
do
    local sg=Instance.new("ScreenGui"); sg.Name="luxxsKey"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.DisplayOrder=999; sg.Parent=parent
    local root=Instance.new("CanvasGroup"); root.Size=UDim2.new(1,0,1,0); root.BackgroundColor3=WHITE; root.BorderSizePixel=0; root.Parent=sg
    gradient(root,90,ColorSequence.new(Color3.fromRGB(22,22,28),Color3.fromRGB(8,8,10)))
    local function hair(y) local f=Instance.new("Frame"); f.Position=UDim2.new(0,0,y,0); f.Size=UDim2.new(1,0,0,1); f.BorderSizePixel=0; f.BackgroundTransparency=0.85; f.Parent=root; T(f,"BackgroundColor3") end
    hair(0.1) hair(0.9)
    local function ctext(txt,ax,px)
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.AnchorPoint=Vector2.new(ax,0); l.Position=UDim2.new(px,ax==0 and 18 or -18,0.1,8); l.Size=UDim2.new(0,220,0,16); l.Font=F_MONO; l.TextSize=11; l.TextColor3=C.dim; l.TextXAlignment=ax==0 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right; l.Text=txt; l.Parent=root
    end
    ctext("LUXXS // ACCESS",0,0) ctext("DRHUB",1,1)

    local word="LUXXS"; local LW=62; local total=LW*#word
    local holder=Instance.new("Frame"); holder.AnchorPoint=Vector2.new(0.5,0.5); holder.Position=UDim2.new(0.5,0,0.36,0); holder.Size=UDim2.new(0,total,0,84); holder.BackgroundTransparency=1; holder.ClipsDescendants=true; holder.Parent=root
    local letters={}
    for i=1,#word do
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(0,LW,0,84); l.Position=UDim2.new(0,(i-1)*LW,0,98); l.Font=F_HEAD; l.TextSize=52; l.Text=word:sub(i,i); l.TextColor3=C.text; l.Parent=holder
        letters[i]=l
    end
    local ul=Instance.new("Frame"); ul.AnchorPoint=Vector2.new(0.5,0); ul.Position=UDim2.new(0.5,0,0.36,52); ul.Size=UDim2.new(0,0,0,2); ul.BorderSizePixel=0; ul.Parent=root; T(ul,"BackgroundColor3")
    local sub=Instance.new("TextLabel"); sub.BackgroundTransparency=1; sub.AnchorPoint=Vector2.new(0.5,0); sub.Position=UDim2.new(0.5,0,0.36,68); sub.Size=UDim2.new(0,300,0,18); sub.Font=F_MONO; sub.TextSize=12; sub.TextColor3=C.dim; sub.Text="ENTER ACCESS KEY"; sub.TextTransparency=1; sub.Parent=root

    local kp=Instance.new("Frame"); kp.AnchorPoint=Vector2.new(0.5,0.5); kp.Position=UDim2.new(0.5,0,0.58,0); kp.Size=UDim2.new(0,340,0,44); kp.BackgroundColor3=C.row; kp.BorderSizePixel=0; kp.Visible=false; kp.ClipsDescendants=true; kp.Parent=root; stroke(kp,C.line,1,0)
    local ki=Instance.new("TextBox"); ki.BackgroundTransparency=1; ki.Position=UDim2.new(0,14,0,0); ki.Size=UDim2.new(1,-112,1,0); ki.Font=F_MONO; ki.TextSize=14; ki.TextColor3=C.text; ki.PlaceholderText="KEY"; ki.PlaceholderColor3=C.dim; ki.Text=""; ki.TextXAlignment=Enum.TextXAlignment.Left; ki.ClearTextOnFocus=false; ki.Parent=kp
    local kb=Instance.new("TextButton"); kb.AnchorPoint=Vector2.new(1,0.5); kb.Position=UDim2.new(1,-6,0.5,0); kb.Size=UDim2.new(0,92,0,32); kb.BorderSizePixel=0; kb.Text="ENTER"; kb.Font=F_MONO; kb.TextSize=13; kb.TextColor3=C.bg; kb.AutoButtonColor=false; kb.Parent=kp; T(kb,"BackgroundColor3")
    local st=Instance.new("TextLabel"); st.BackgroundTransparency=1; st.AnchorPoint=Vector2.new(0.5,0); st.Position=UDim2.new(0.5,0,0.58,36); st.Size=UDim2.new(0,340,0,18); st.Font=F_MONO; st.TextSize=12; st.TextColor3=C.dim; st.Text=""; st.Parent=root

    task.spawn(function()
        task.wait(0.2)
        for i,l in ipairs(letters) do tween(l,0.7,{Position=UDim2.new(0,(i-1)*LW,0,0)}); task.wait(0.09) end
        task.wait(0.3); tween(ul,0.6,{Size=UDim2.new(0,total,0,2)})
        task.wait(0.3); tween(sub,0.4,{TextTransparency=0})
        kp.Visible=true; kp.Size=UDim2.new(0,0,0,44); tween(kp,0.5,{Size=UDim2.new(0,340,0,44)})
        pcall(function() ki:CaptureFocus() end)
    end)

    local done=false
    local function tryKey()
        if done then return end
        local txt=ki.Text:gsub("^%s+",""); txt=txt:gsub("%s+$","")
        local lk=string.lower(txt)
        if lk==string.lower(VALID_KEY) or lk=="hhh" or lk=="drhub" then
            done=true; st.Text="ACCESS GRANTED"; T(st,"TextColor3"); ki.TextEditable=false
            for _,l in ipairs(letters) do T(l,"TextColor3") end
            task.wait(0.8); tween(root,0.6,{GroupTransparency=1}); task.wait(0.65); sg:Destroy()
        else
            st.Text="INVALID KEY"; st.TextColor3=Color3.fromRGB(255,84,84)
            local op=kp.Position
            for _,dx in ipairs({-10,10,-6,6,0}) do tween(kp,0.05,{Position=UDim2.new(op.X.Scale,op.X.Offset+dx,op.Y.Scale,op.Y.Offset)}); task.wait(0.055) end
            ki.Text=""; task.wait(0.6); st.Text=""
        end
    end
    kb.MouseButton1Click:Connect(tryKey)
    ki.FocusLost:Connect(function(enter) if enter then tryKey() end end)
    repeat task.wait(0.1) until done
end

print("[luxxs] key accepted, building UI")

local function notify(text)
    local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(1,1); f.Size=UDim2.new(0,250,0,34); f.Position=UDim2.new(1,280,1,-20); f.BackgroundColor3=C.panel; f.BorderSizePixel=0; f.ZIndex=20; f.Parent=gui; stroke(f,C.line,1,0)
    local bar=Instance.new("Frame"); bar.Size=UDim2.new(0,3,1,0); bar.BorderSizePixel=0; bar.BackgroundColor3=ACC; bar.ZIndex=21; bar.Parent=f
    local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(1,-20,1,0); l.Position=UDim2.new(0,14,0,0); l.Font=F_MONO; l.TextSize=12; l.TextColor3=C.text; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=text; l.ZIndex=21; l.Parent=f
    tween(f,0.4,{Position=UDim2.new(1,-20,1,-20)})
    task.delay(2.6,function() tween(f,0.3,{Position=UDim2.new(1,280,1,-20)},Enum.EasingStyle.Quint,Enum.EasingDirection.In); task.delay(0.35,function() f:Destroy() end) end)
end

local function makeDraggable(handle,target,onClick)
    local dragging,startPos,startInput,moved=false,nil,nil,false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; moved=false; startInput=input.Position; startPos=target.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false; if not moved and onClick then onClick() end end end)
        end
    end)
    track(UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-startInput
            if delta.Magnitude>5 then moved=true end
            if moved then tween(target,0.08,{Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)},Enum.EasingStyle.Linear) end
        end
    end))
end

-- COSMETICS
local Cos={}
local function destroyCos(n) if Cos[n] then for _,o in ipairs(Cos[n].objs) do pcall(function() o:Destroy() end) end Cos[n]=nil end end
local function newPart(sz,p)
    local pt=Instance.new("Part")
    pt.Size=sz; pt.CanCollide=false; pt.CanQuery=false; pt.CanTouch=false
    pt.Massless=true; pt.Anchored=false; pt.Parent=p
    return pt
end

local function buildWings()
    destroyCos("wings")
    local char=LP.Character
    local torso=char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
    if not torso then return end
    local model=Instance.new("Model"); model.Name="luxxsWings"
    local feathers={}
    for _,side in ipairs({-1,1}) do
        for i=1,6 do
            local len=4.2-i*0.35
            local p=newPart(Vector3.new(len,0.5,0.08),model)
            p.Material=Enum.Material.Neon
            local w=Instance.new("Weld"); w.Part0=torso; w.Part1=p; w.Parent=p
            feathers[#feathers+1]={part=p,weld=w,side=side,i=i,len=len}
        end
    end
    model.Parent=char
    Cos.wings={objs={model},model=model,feathers=feathers}
end

local function buildHat()
    destroyCos("hat")
    local char=LP.Character; local head=char and char:FindFirstChild("Head"); if not head then return end
    local model=Instance.new("Model"); model.Name="luxxsHat"; local slices={}
    local N=30
    for i=1,N do
        local k=(i-1)/N
        local r=2.4*(1-k)^1.05+0.05
        local p=newPart(Vector3.new(0.07,r*2,r*2),model)
        p.Shape=Enum.PartType.Cylinder; p.Material=Enum.Material.SmoothPlastic; p.CastShadow=false
        local w=Instance.new("Weld"); w.Part0=head; w.Part1=p; w.C0=CFrame.new(0,0.52+(i-1)*0.036,0)*CFrame.Angles(0,0,math.pi/2); w.Parent=p; slices[i]=p
    end
    model.Parent=char; Cos.hat={objs={model},model=model,slices=slices}
end

local function buildTrail()
    destroyCos("trail")
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local a0=Instance.new("Attachment"); a0.Name="luxxsA0"; a0.Parent=hrp
    local a1=Instance.new("Attachment"); a1.Name="luxxsA1"; a1.Parent=hrp
    local tr=Instance.new("Trail"); tr.Attachment0=a0; tr.Attachment1=a1; tr.LightEmission=1; tr.FaceCamera=true
    tr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.1),NumberSequenceKeypoint.new(1,1)}); tr.Parent=hrp
    Cos.trail={objs={a0,a1,tr},a0=a0,a1=a1,trail=tr}
end

local function colorSeq(name,t)
    if name=="Rainbow" then local kp={} for k=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(k/6,getColor(name,t,-k/6*0.8)) end return ColorSequence.new(kp) end
    return ColorSequence.new(getColor(name))
end

track(RunService.Heartbeat:Connect(function()
    local t=os.clock()
    local w=Cos.wings
    if w and w.model.Parent then
        local flap=math.sin(t*(Flags["Visuals/Wing Speed"] or 3))*0.2
        for _,f in ipairs(w.feathers) do
            local a=math.rad(10+f.i*12)+flap*(0.5+f.i*0.12)
            local theta=(f.side==1) and a or (math.pi-a)
            f.weld.C0=CFrame.new(f.side*0.5,0.45,0.6)*CFrame.Angles(0,f.side*-0.35,0)*CFrame.Angles(0,0,theta)*CFrame.new(f.len/2,0,0)
            f.part.Color=getColor(Flags["Visuals/Wing Color"],t,f.i*0.05)
        end
    end
    local h=Cos.hat
    if h and h.model.Parent then local htr=(Flags["Visuals/Hat Transparency"] or 35)/100; for i,sl in ipairs(h.slices) do sl.Color=getColor(Flags["Visuals/Hat Color"],t,i*0.02); sl.Transparency=htr end end
    local tr=Cos.trail
    if tr and tr.trail.Parent then
        local width=(Flags["Visuals/Trail Width"] or 4)*0.4
        tr.a0.Position=Vector3.new(0,width/2,0); tr.a1.Position=Vector3.new(0,-width/2,0)
        tr.trail.Lifetime=math.max(0.1,(Flags["Visuals/Trail Length"] or 10)/10); tr.trail.Color=colorSeq(Flags["Visuals/Trail Color"],t)
    end
end))

local enableFlyMove
track(LP.CharacterAdded:Connect(function(c)
    c:WaitForChild("HumanoidRootPart",10); c:WaitForChild("Head",10); task.wait(0.3)
    if Flags["Visuals/Wings"] then buildWings() end
    if Flags["Visuals/Chinese Hat"] then buildHat() end
    if Flags["Visuals/Trail"] then buildTrail() end
    if Flags["Move/Fly"] and enableFlyMove then enableFlyMove() end
end))

-- SHADERS
local Shader={}
local PRESETS={
    ["Cinematic"]={b=0.02,c=0.25,s=-0.1,tint=Color3.fromRGB(255,238,220),bloom=0.5,bsize=28,bth=1,rays=0.08,dens=0.3,haze=1.2,acol=Color3.fromRGB(190,190,205)},
    ["Neon Night"]={b=-0.03,c=0.3,s=0.5,tint=Color3.fromRGB(215,190,255),bloom=1.3,bsize=42,bth=0.75,rays=0,dens=0.35,haze=1.5,acol=Color3.fromRGB(110,70,200)},
    ["Sunset"]={b=0.03,c=0.15,s=0.3,tint=Color3.fromRGB(255,205,160),bloom=0.6,bsize=30,bth=0.9,rays=0.25,dens=0.3,haze=1.8,acol=Color3.fromRGB(255,170,120)},
    ["Vivid"]={b=0.02,c=0.2,s=0.7,tint=Color3.fromRGB(255,255,255),bloom=0.4,bsize=24,bth=1,rays=0.1,dens=0.2,haze=0.5,acol=Color3.fromRGB(200,215,235)},
    ["Noir"]={b=-0.02,c=0.4,s=-1,tint=Color3.fromRGB(235,235,245),bloom=0.3,bsize=20,bth=1,rays=0,dens=0.35,haze=2.2,acol=Color3.fromRGB(160,160,170)},
    ["Dream"]={b=0.05,c=-0.05,s=0.3,tint=Color3.fromRGB(255,210,255),bloom=1,bsize=50,bth=0.7,rays=0.15,dens=0.4,haze=1,acol=Color3.fromRGB(255,190,240)},
}
local PRESET_NAMES={"Off","Cinematic","Neon Night","Sunset","Vivid","Noir","Dream"}
local NEUTRAL={b=0,c=0,s=0,tint=Color3.fromRGB(255,255,255),bloom=0,bsize=24,bth=1,rays=0}

local function ensureShader()
    if Shader.cc then return end
    local function mk(c) local i=Instance.new(c); i.Name="luxxs_"..c; i.Parent=Lighting; return i end
    Shader.cc=mk("ColorCorrectionEffect"); Shader.bloom=mk("BloomEffect"); Shader.rays=mk("SunRaysEffect")
    local atm=Lighting:FindFirstChildOfClass("Atmosphere")
    if atm then Shader.atm=atm; Shader.atmOrig={Density=atm.Density,Haze=atm.Haze,Color=atm.Color}
    else Shader.atm=mk("Atmosphere"); Shader.atm.Density=0; Shader.atmCreated=true end
end

local function disableShader(full)
    if not Shader.cc then return end
    Shader.cc.Enabled=false; Shader.bloom.Enabled=false; Shader.rays.Enabled=false
    if Shader.atmOrig then pcall(function() tween(Shader.atm,0.5,Shader.atmOrig) end) elseif Shader.atm then pcall(function() Shader.atm.Density=0 end) end
    if full then for _,k in ipairs({"cc","bloom","rays"}) do pcall(function() Shader[k]:Destroy() end) end; if Shader.atmCreated then pcall(function() Shader.atm:Destroy() end) end; Shader={} end
end

local function refreshShader(time)
    time=time or 0.9
    local preset=PRESETS[Flags["Shaders/Preset"] or "Off"]
    local ob=(Flags["Shaders/Brightness"] or 0)/100; local oc=(Flags["Shaders/Contrast"] or 0)/100
    local os_=(Flags["Shaders/Saturation"] or 0)/100; local obl=(Flags["Shaders/Bloom"] or 0)/50
    if not preset and ob==0 and oc==0 and os_==0 and obl==0 then disableShader(false); return end
    ensureShader(); local p=preset or NEUTRAL
    Shader.cc.Enabled=true; Shader.bloom.Enabled=true; Shader.rays.Enabled=true
    tween(Shader.cc,time,{Brightness=p.b+ob,Contrast=p.c+oc,Saturation=p.s+os_,TintColor=p.tint})
    tween(Shader.bloom,time,{Intensity=p.bloom+obl,Size=p.bsize,Threshold=p.bth})
    tween(Shader.rays,time,{Intensity=p.rays})
    if preset then tween(Shader.atm,time,{Density=preset.dens,Haze=preset.haze,Color=preset.acol})
    elseif Shader.atmOrig then tween(Shader.atm,time,Shader.atmOrig) else tween(Shader.atm,time,{Density=0}) end
end

-- WINDOW
local W,H=972,460
local main=Instance.new("CanvasGroup")
main.AnchorPoint=Vector2.new(0.5,0.5); main.Position=UDim2.new(0.5,0,0.5,0); main.Size=UDim2.new(0,W,0,H)
main.BackgroundColor3=C.bg; main.BorderSizePixel=0; main.GroupTransparency=1; main.Visible=false; main.Parent=gui
corner(main,16); T(stroke(main,ACC,1.5,0.35),"Color"); main.BackgroundColor3=Color3.fromRGB(12,11,17)
do local bgF=Instance.new("Frame"); bgF.Size=UDim2.new(1,0,1,0); bgF.BackgroundColor3=WHITE; bgF.BorderSizePixel=0; bgF.ZIndex=0; bgF.Parent=main; gradient(bgF,125,ColorSequence.new(Color3.fromRGB(24,19,36),Color3.fromRGB(10,10,14))) end
local scale=Instance.new("UIScale"); scale.Scale=0.9; scale.Parent=main


local top=Instance.new("Frame"); top.Size=UDim2.new(1,0,0,44); top.BackgroundColor3=WHITE; top.BorderSizePixel=0; top.Parent=main; gradient(top,0,ColorSequence.new(Color3.fromRGB(34,26,48),Color3.fromRGB(15,15,21)))
local topLine=Instance.new("Frame"); topLine.Position=UDim2.new(0,0,1,-1); topLine.Size=UDim2.new(1,0,0,1); topLine.BackgroundColor3=C.line; topLine.BorderSizePixel=0; topLine.Parent=top
local mark=Instance.new("Frame"); mark.Position=UDim2.new(0,16,0,18); mark.Size=UDim2.new(0,8,0,8); mark.Rotation=45; mark.BorderSizePixel=0; mark.Parent=top; T(mark,"BackgroundColor3")
local title=Instance.new("TextLabel"); title.BackgroundTransparency=1; title.Position=UDim2.new(0,34,0,0); title.Size=UDim2.new(0,90,1,0); title.Font=F_HEAD; title.TextSize=15; title.TextXAlignment=Enum.TextXAlignment.Left; title.TextColor3=C.text; title.Text="LUXXS"; title.Parent=top
local sub=Instance.new("TextLabel"); sub.BackgroundTransparency=1; sub.Position=UDim2.new(0,130,0,2); sub.Size=UDim2.new(0,120,1,0); sub.Font=F_MONO; sub.TextSize=11; sub.TextXAlignment=Enum.TextXAlignment.Left; sub.TextColor3=C.dim; sub.Text="by DrHub"; sub.Parent=top
local ver=Instance.new("TextLabel"); ver.BackgroundTransparency=1; ver.AnchorPoint=Vector2.new(1,0); ver.Position=UDim2.new(1,-52,0,0); ver.Size=UDim2.new(0,160,1,0); ver.Font=F_MONO; ver.TextSize=11; ver.TextXAlignment=Enum.TextXAlignment.Right; ver.TextColor3=C.dim; ver.Text="v4.6 // MM2"; ver.Parent=top
local closeBtn=Instance.new("TextButton"); closeBtn.AnchorPoint=Vector2.new(1,0.5); closeBtn.Position=UDim2.new(1,-10,0.5,0); closeBtn.Size=UDim2.new(0,28,0,28); closeBtn.BackgroundColor3=C.row; closeBtn.BorderSizePixel=0; closeBtn.Text="X"; closeBtn.Font=F_MONO; closeBtn.TextSize=13; closeBtn.TextColor3=C.dim; closeBtn.AutoButtonColor=false; closeBtn.Parent=top

local side=Instance.new("Frame"); side.Position=UDim2.new(0,0,0,44); side.Size=UDim2.new(0,150,0,H-44-24); side.BackgroundColor3=C.panel; side.BorderSizePixel=0; side.Parent=main
local sideLine=Instance.new("Frame"); sideLine.Position=UDim2.new(1,-1,0,0); sideLine.Size=UDim2.new(0,1,1,0); sideLine.BackgroundColor3=C.line; sideLine.BorderSizePixel=0; sideLine.Parent=side
local sideList=Instance.new("Frame"); sideList.BackgroundTransparency=1; sideList.Position=UDim2.new(0,0,0,12); sideList.Size=UDim2.new(1,-1,1,-12); sideList.Parent=side
local indicator=Instance.new("Frame"); indicator.Size=UDim2.new(0,2,0,22); indicator.Position=UDim2.new(0,0,0,18); indicator.BorderSizePixel=0; indicator.ZIndex=3; indicator.Parent=side; T(indicator,"BackgroundColor3")

local foot=Instance.new("Frame"); foot.Position=UDim2.new(0,0,1,-24); foot.Size=UDim2.new(1,0,0,24); foot.BackgroundColor3=C.panel; foot.BorderSizePixel=0; foot.Parent=main
local footLine=Instance.new("Frame"); footLine.Size=UDim2.new(1,0,0,1); footLine.BackgroundColor3=C.line; footLine.BorderSizePixel=0; footLine.Parent=foot
local footL=Instance.new("TextLabel"); footL.BackgroundTransparency=1; footL.Position=UDim2.new(0,14,0,0); footL.Size=UDim2.new(0.5,0,1,0); footL.Font=F_MONO; footL.TextSize=10; footL.TextXAlignment=Enum.TextXAlignment.Left; footL.TextColor3=C.dim; footL.Text="RIGHTSHIFT = TOGGLE"; footL.Parent=foot
local footR=Instance.new("TextLabel"); footR.BackgroundTransparency=1; footR.AnchorPoint=Vector2.new(1,0); footR.Position=UDim2.new(1,-14,0,0); footR.Size=UDim2.new(0.5,0,1,0); footR.Font=F_MONO; footR.TextSize=10; footR.TextXAlignment=Enum.TextXAlignment.Right; footR.TextColor3=C.dim; footR.Text="ROLE  INNOCENT"; footR.Parent=foot

local pages=Instance.new("Frame"); pages.BackgroundTransparency=1; pages.Position=UDim2.new(0,162,0,54); pages.Size=UDim2.new(0,542,0,H-24-54-10); pages.ClipsDescendants=true; pages.Parent=main
local previewPanel=Instance.new("Frame"); previewPanel.Position=UDim2.new(0,712,0,54); previewPanel.Size=UDim2.new(0,252,0,372); previewPanel.BorderSizePixel=0; previewPanel.Parent=main

local tabs,currentTab,switching={},nil,false

local function restyleTabs()
    for _,t in ipairs(tabs) do
        local on=(t==currentTab)
        t.nm.TextColor3=on and C.text or C.dim
        t.num.TextColor3=on and ACC or C.dim
        t.button.BackgroundColor3=on and ACC or C.row; t.button.BackgroundTransparency=on and 0.82 or 1
    end
end

local function selectTab(tab)
    if currentTab==tab or switching then return end
    switching=true; local old=currentTab; currentTab=tab
    tween(indicator,0.3,{Position=UDim2.new(0,0,0,18+tab.index*38)})
    restyleTabs()
    if old then tween(old.page,0.15,{GroupTransparency=1}); task.delay(0.15,function() old.page.Visible=false end) end
    task.delay(old and 0.12 or 0,function()
        tab.page.GroupTransparency=1; tab.page.Visible=true
        tween(tab.page,0.25,{GroupTransparency=0})
        task.delay(0.25,function() switching=false end)
    end)
end

local function hairline(parent,y)
    local f=Instance.new("Frame"); f.Position=UDim2.new(0,0,1,y or -1); f.Size=UDim2.new(1,0,0,1); f.BackgroundColor3=C.line; f.BackgroundTransparency=1; f.BorderSizePixel=0; f.Parent=parent; return f
end

local function createTab(name)
    local index=#tabs
    local button=Instance.new("TextButton"); button.Size=UDim2.new(1,-16,0,34); button.Position=UDim2.new(0,8,0,index*38+6); button.BackgroundColor3=C.row; button.BackgroundTransparency=1; button.BorderSizePixel=0; button.Text=""; button.AutoButtonColor=false; button.Parent=sideList; corner(button,8)
    local num=Instance.new("TextLabel"); num.BackgroundTransparency=1; num.Position=UDim2.new(0,16,0,0); num.Size=UDim2.new(0,24,1,0); num.Font=F_MONO; num.TextSize=11; num.TextXAlignment=Enum.TextXAlignment.Left; num.TextColor3=C.dim; num.Text="0"..(index+1); num.Parent=button
    local nm=Instance.new("TextLabel"); nm.BackgroundTransparency=1; nm.Position=UDim2.new(0,46,0,0); nm.Size=UDim2.new(1,-50,1,0); nm.Font=F_SEC; nm.TextSize=16; nm.TextXAlignment=Enum.TextXAlignment.Left; nm.TextColor3=C.dim; nm.Text=string.upper(name); nm.Parent=button

    local page=Instance.new("CanvasGroup"); page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1; page.Visible=false; page.GroupTransparency=1; page.Parent=pages
    local scroll=Instance.new("ScrollingFrame"); scroll.Size=UDim2.new(1,0,1,0); scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=2; scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.Parent=page
    T(scroll,"ScrollBarImageColor3")
    local function mkCol(xs,xo) local f=Instance.new("Frame"); f.BackgroundTransparency=1; f.Position=UDim2.new(xs,xo,0,0); f.Size=UDim2.new(0.5,-4,0,0); f.AutomaticSize=Enum.AutomaticSize.Y; f.Parent=scroll; local l=Instance.new("UIListLayout"); l.Padding=UDim.new(0,2); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=f; return f end
    local colL=mkCol(0,0); local colR=mkCol(0.5,4)
    local hL,hR=0,0
    local COLH=H-24-54-10-12
    local function slot(h)
        if hL+h<=COLH then hL=hL+h+2; return colL end
        if hR+h<=COLH then hR=hR+h+2; return colR end
        if hR<hL then hR=hR+h+2; return colR end
        hL=hL+h+2; return colL
    end
    local pad=Instance.new("UIPadding"); pad.PaddingRight=UDim.new(0,8); pad.PaddingTop=UDim.new(0,2); pad.PaddingBottom=UDim.new(0,10); pad.Parent=scroll

    local tab={button=button,page=page,scroll=scroll,index=index,name=name,num=num,nm=nm}; table.insert(tabs,tab)
    button.MouseButton1Click:Connect(function() selectTab(tab) end)
    button.MouseEnter:Connect(function() if currentTab~=tab then tween(nm,0.15,{TextColor3=C.text}) end end)
    button.MouseLeave:Connect(function() if currentTab~=tab then tween(nm,0.15,{TextColor3=C.dim}) end end)

    function tab:Label(text)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,30); f.BackgroundTransparency=1
        do local p=slot(30+36); if p==colL then hL=hL-38 else hR=hR-38 end; f.Parent=p end
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Position=UDim2.new(0,0,0,6); l.Size=UDim2.new(1,0,0,18); l.Font=F_SEC; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextColor3=C.dim; l.Text=string.upper(text); l.Parent=f
        hairline(f,-3)
        local ac=Instance.new("Frame"); ac.Position=UDim2.new(0,0,1,-3); ac.Size=UDim2.new(0,28,0,1); ac.BorderSizePixel=0; ac.Parent=f; T(ac,"BackgroundColor3")
    end

    function tab:Label2(text,font,size,color)
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,0,(#text>36) and 28 or 18); l.TextWrapped=true; l.BackgroundTransparency=1; l.Font=font or F_MONO; l.TextSize=size or 11; l.TextColor3=color or C.dim; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=text; l.Parent=slot(l.Size.Y.Offset)
        return l
    end

    function tab:Frame(h)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,h); f.BackgroundTransparency=1; f.Parent=slot(h); return f
    end

    function tab:Toggle(text,default,callback)
        local key=name.."/"..text; local state=default or false
        local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.BorderSizePixel=0; row.AutoButtonColor=false; row.Text=""; row.Parent=slot(34)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,0); lbl.Size=UDim2.new(1,-60,1,0); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local box=Instance.new("Frame"); box.AnchorPoint=Vector2.new(1,0.5); box.Position=UDim2.new(1,-10,0.5,0); box.Size=UDim2.new(0,36,0,18); box.BackgroundColor3=state and ACC or C.off; box.BorderSizePixel=0; box.Parent=row; corner(box,9)
        T(box,"BackgroundColor3",function(a) return state and a or C.off end)
        local inner=Instance.new("Frame"); inner.AnchorPoint=Vector2.new(0,0.5); inner.Position=UDim2.new(0,state and 20 or 2,0.5,0); inner.Size=UDim2.new(0,14,0,14); inner.BackgroundColor3=WHITE; inner.BorderSizePixel=0; inner.Parent=box; corner(inner,7)
        local function paint() tween(box,0.18,{BackgroundColor3=state and ACC or C.off}); tween(inner,0.18,{Position=UDim2.new(0,state and 20 or 2,0.5,0)}) end
        register(key,state,function(v)
            state=v and true or false; Flags[key]=state; paint()
            if callback then task.spawn(callback,state) end
        end)
        row.MouseButton1Click:Connect(function() Setters[key](not state) end)
        row.MouseEnter:Connect(function() tween(row,0.12,{BackgroundTransparency=0.3}) end)
        row.MouseLeave:Connect(function() tween(row,0.12,{BackgroundTransparency=0.55}) end)
    end

    function tab:Button(text,callback)
        local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,0,0,38); wrap.BackgroundTransparency=1; wrap.Parent=slot(38)
        local b=Instance.new("TextButton"); b.Position=UDim2.new(0,10,0,4); b.Size=UDim2.new(1,-20,0,30); b.BackgroundColor3=ACC; b.BackgroundTransparency=0.88; corner(b,8); b.BorderSizePixel=0; b.AutoButtonColor=false; b.Font=F_MONO; b.TextSize=12; b.Text=string.upper(text); b.Parent=wrap
        T(b,"TextColor3"); local bs=stroke(b,ACC,1,0.4); T(bs,"Color")
        b.MouseEnter:Connect(function() b.BackgroundColor3=ACC; tween(b,0.12,{BackgroundTransparency=0}); b.TextColor3=C.bg end)
        b.MouseLeave:Connect(function() tween(b,0.12,{BackgroundTransparency=0.88}); b.TextColor3=ACC end)
        b.MouseButton1Click:Connect(function() if callback then task.spawn(callback) end end)
    end

    function tab:Input(text,default,callback)
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,38); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.Parent=slot(38)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,0); lbl.Size=UDim2.new(0.5,-10,1,0); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local boxF=Instance.new("Frame"); boxF.AnchorPoint=Vector2.new(1,0.5); boxF.Position=UDim2.new(1,-10,0.5,0); boxF.Size=UDim2.new(0.5,-10,0,26); boxF.BackgroundColor3=C.bg; boxF.BorderSizePixel=0; boxF.Parent=row
        local bs=stroke(boxF,ACC,1,0.4); T(bs,"Color")
        local tb=Instance.new("TextBox"); tb.BackgroundTransparency=1; tb.Size=UDim2.new(1,-12,1,0); tb.Position=UDim2.new(0,6,0,0); tb.Font=F_MONO; tb.TextSize=13; tb.TextColor3=C.text; tb.PlaceholderColor3=C.dim; tb.PlaceholderText="value"; tb.Text=tostring(default or ""); tb.ClearTextOnFocus=false; tb.TextXAlignment=Enum.TextXAlignment.Center; tb.Parent=boxF
        tb.FocusLost:Connect(function(enter) if callback then task.spawn(callback,tb.Text,tb) end end)
        return tb
    end

    function tab:Slider(text,min,max,default,callback,gradFn)
        local key=name.."/"..text; local value=default or min
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,46); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.Parent=slot(46)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,4); lbl.Size=UDim2.new(0.6,0,0,20); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local val=Instance.new("TextLabel"); val.BackgroundTransparency=1; val.AnchorPoint=Vector2.new(1,0); val.Position=UDim2.new(1,-10,0,4); val.Size=UDim2.new(0,100,0,20); val.Font=F_MONO; val.TextSize=13; val.TextXAlignment=Enum.TextXAlignment.Right; val.Text=tostring(value); val.Parent=row; T(val,"TextColor3")
        local bar=Instance.new("Frame"); bar.Position=UDim2.new(0,10,0,33); bar.Size=UDim2.new(1,-20,0,5); bar.BackgroundColor3=C.off; bar.BorderSizePixel=0; bar.Parent=row
        local fill=Instance.new("Frame"); fill.Size=UDim2.new((value-min)/(max-min),0,1,0); fill.BorderSizePixel=0; fill.Parent=bar; T(fill,"BackgroundColor3")
        local gradObj
        if gradFn then
            bar.Size=UDim2.new(1,-20,0,8); bar.Position=UDim2.new(0,10,0,31); bar.BackgroundColor3=WHITE; fill.BackgroundTransparency=1
            gradObj=Instance.new("UIGradient"); gradObj.Color=gradFn(); gradObj.Parent=bar
            GradRefresh[key]=function() gradObj.Color=gradFn() end
        end
        local knob=Instance.new("Frame"); knob.AnchorPoint=Vector2.new(0.5,0.5); knob.Position=UDim2.new((value-min)/(max-min),0,0.5,0); knob.Size=UDim2.new(0,14,0,14); knob.BackgroundColor3=WHITE; knob.BorderSizePixel=0; knob.ZIndex=3; knob.Parent=bar; corner(bar,3); corner(fill,3); corner(knob,7); T(stroke(knob,ACC,2,0),"Color")
        register(key,value,function(v)
            v=math.clamp(math.floor((tonumber(v) or min)+0.5),min,max); value=v; Flags[key]=v
            val.Text=tostring(v)
            local r=(v-min)/(max-min)
            fill.Size=UDim2.new(r,0,1,0); knob.Position=UDim2.new(r,0,0.5,0)
            if callback then task.spawn(callback,v) end
        end)
        local hit=Instance.new("TextButton"); hit.BackgroundTransparency=1; hit.Text=""; hit.Position=UDim2.new(0,0,0,22); hit.Size=UDim2.new(1,0,0,24); hit.Parent=row
        local sliding=false
        local function update(x) local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1); Setters[key](min+(max-min)*rel) end
        hit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true; scroll.ScrollingEnabled=false; update(i.Position.X) end end)
        track(UIS.InputEnded:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then sliding=false; scroll.ScrollingEnabled=true end end))
        track(UIS.InputChanged:Connect(function(i) if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then update(i.Position.X) end end))
    end

    function tab:Choice(text,options,default,callback)
        local key=name.."/"..text; local idx=table.find(options,default) or 1
        local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=C.row; row.BackgroundTransparency=0.55; corner(row,8); row.BorderSizePixel=0; row.AutoButtonColor=false; row.Text=""; row.Parent=slot(34)
        hairline(row)
        local lbl=Instance.new("TextLabel"); lbl.BackgroundTransparency=1; lbl.Position=UDim2.new(0,10,0,0); lbl.Size=UDim2.new(0.5,-10,1,0); lbl.Font=F_BODY; lbl.TextSize=14; lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=text; lbl.Parent=row
        local val=Instance.new("TextLabel"); val.BackgroundTransparency=1; val.AnchorPoint=Vector2.new(1,0); val.Position=UDim2.new(1,-10,0,0); val.Size=UDim2.new(0.5,-10,1,0); val.Font=F_MONO; val.TextSize=13; val.TextXAlignment=Enum.TextXAlignment.Right; val.Text="< "..options[idx].." >"; val.Parent=row; T(val,"TextColor3")
        register(key,options[idx],function(v)
            local i=table.find(options,v); if not i then return end
            idx=i; Flags[key]=options[i]; val.Text="< "..options[i].." >"
            if callback then task.spawn(callback,options[i]) end
        end)
        row.MouseButton1Click:Connect(function() Setters[key](options[idx%#options+1]) end)
        row.MouseButton2Click:Connect(function() Setters[key](options[(idx-2)%#options+1]) end)
        row.MouseEnter:Connect(function() tween(row,0.12,{BackgroundTransparency=0.3}) end)
        row.MouseLeave:Connect(function() tween(row,0.12,{BackgroundTransparency=0.55}) end)
    end
    return tab
end

local function fitScale() local cam=workspace.CurrentCamera; local vp=cam and cam.ViewportSize or Vector2.new(1280,720); return math.min(1,(vp.X-20)/W,(vp.Y-20)/H) end
local isOpen,busy=false,false
local MenuAlpha=1
local MenuScale=1

local function openMenu()
    if busy or isOpen then return end
    busy=true; isOpen=true
    main.Visible=true
    local fit=fitScale(); scale.Scale=fit*0.94*MenuScale; main.GroupTransparency=1
    tween(scale,0.35,{Scale=fit*MenuScale}); tween(main,0.3,{GroupTransparency=1-MenuAlpha})
    task.delay(0.35,function() busy=false end)
end

local function closeMenu()
    if busy or not isOpen then return end
    busy=true; isOpen=false
    tween(scale,0.25,{Scale=fitScale()*0.94*MenuScale},Enum.EasingStyle.Quint,Enum.EasingDirection.In); tween(main,0.25,{GroupTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.In)
    task.delay(0.26,function() main.Visible=false; busy=false end)
end

local function toggleMenu() if isOpen then closeMenu() else openMenu() end end

closeBtn.MouseButton1Click:Connect(closeMenu)
closeBtn.MouseEnter:Connect(function() tween(closeBtn,0.12,{BackgroundColor3=Color3.fromRGB(190,56,56)}); closeBtn.TextColor3=WHITE end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn,0.12,{BackgroundColor3=C.row}); closeBtn.TextColor3=C.dim end)

local icon=Instance.new("TextButton"); icon.Size=UDim2.new(0,50,0,50); icon.Position=UDim2.new(0,24,0.5,-25); icon.BackgroundColor3=C.bg; icon.BorderSizePixel=0; icon.AutoButtonColor=false; icon.Text="LX"; icon.Font=F_HEAD; icon.TextSize=14; icon.TextColor3=C.text; icon.ZIndex=5; icon.Parent=gui
local iconStroke=stroke(icon,ACC,1.5,0); T(iconStroke,"Color")
corner(icon,25)
task.spawn(function() while gui.Parent do tween(iconStroke,1.3,{Transparency=0.65},Enum.EasingStyle.Sine,Enum.EasingDirection.InOut); task.wait(1.3); tween(iconStroke,1.3,{Transparency=0},Enum.EasingStyle.Sine,Enum.EasingDirection.InOut); task.wait(1.3) end end)
icon.MouseEnter:Connect(function() tween(icon,0.15,{TextColor3=ACC}) end)
icon.MouseLeave:Connect(function() tween(icon,0.15,{TextColor3=C.text}) end)
makeDraggable(icon,icon,toggleMenu)
makeDraggable(top,main)
track(UIS.InputBegan:Connect(function(input,processed) if not processed and input.KeyCode==Enum.KeyCode.RightShift then toggleMenu() end end))

-- ROLE DETECTION
local function scanName(name)
    local n=string.lower(name)
    if n=="knife" or n:find("knife") or n:find("murderknife") then return "Murderer" end
    if n=="gun" or n=="revolver" or n=="sheriff gun" or n:find("revolver") or (n:find("gun") and not n:find("shotgun") and not n:find("stun")) then return "Sheriff" end
    return nil
end
local function scanContainer(container,deep)
    if not container then return nil end
    local list=deep and container:GetDescendants() or container:GetChildren()
    for _,obj in ipairs(list) do
        if obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") then
            local r=scanName(obj.Name); if r then return r end
        end
    end
    return nil
end
local function getRole(plr)
    local char=plr.Character; if not char then return "Innocent" end
    if plr.Team then
        local tl=string.lower(plr.Team.Name)
        if tl=="murderer" then return "Murderer" end
        if tl=="sheriff" then return "Sheriff" end
        if tl=="innocent" then return "Innocent" end
    end
    for _,src in ipairs({plr,char}) do
        for _,attr in ipairs({"Role","MM2Role","MurderRole","PlayerRole","Team","role","mm2role"}) do
            local v=src:GetAttribute(attr)
            if v~=nil then
                local rl=string.lower(tostring(v))
                if rl=="murderer" or rl=="murder" then return "Murderer" end
                if rl=="sheriff" then return "Sheriff" end
                if rl=="innocent" then return "Innocent" end
            end
        end
    end
    for _,obj in ipairs(char:GetChildren()) do if obj:IsA("Tool") then local r=scanName(obj.Name); if r then return r end end end
    local r=scanContainer(char,true); if r then return r end
    local bp=plr:FindFirstChildOfClass("Backpack") or plr:FindFirstChild("Backpack")
    if bp then
        for _,obj in ipairs(bp:GetChildren()) do if obj:IsA("Tool") then local rr=scanName(obj.Name); if rr then return rr end end end
        r=scanContainer(bp,true); if r then return r end
    end
    return "Innocent"
end
local roleCache={}
local function getRoleCached(plr)
    local c=roleCache[plr]; local now=os.clock()
    if c and now-c.t<0.3 then return c.r end
    local r=getRole(plr); roleCache[plr]={r=r,t=now}; return r
end
Players.PlayerRemoving:Connect(function(p) roleCache[p]=nil end)

-- ESP
local ESPFolder=Instance.new("Folder"); ESPFolder.Name="luxxsESP"; ESPFolder.Parent=gui
local espData={}
local function setLine(f,p1,p2,thick)
    local dx,dy=p2.X-p1.X,p2.Y-p1.Y
    f.Position=UDim2.new(0,(p1.X+p2.X)*0.5,0,(p1.Y+p2.Y)*0.5)
    f.Size=UDim2.new(0,math.sqrt(dx*dx+dy*dy),0,thick)
    f.Rotation=math.deg(math.atan2(dy,dx))
end
local BONES={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}

local function createESP(plr)
    if espData[plr] or plr==LP then return end
    local d={}
    d.box=Instance.new("Frame"); d.box.BackgroundTransparency=1; d.box.BorderSizePixel=0; d.box.ZIndex=2; d.box.Parent=ESPFolder; d.boxStroke=stroke(d.box,ACC,1.2,0)
    local function mkLabel(size,font)
        local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Font=font or F_MONO; l.TextSize=size; l.TextColor3=WHITE; l.TextStrokeTransparency=0.4; l.TextStrokeColor3=Color3.new(0,0,0); l.Size=UDim2.new(0,260,0,size+2); l.TextXAlignment=Enum.TextXAlignment.Center; l.ZIndex=4; l.Parent=ESPFolder; return l
    end
    d.role=mkLabel(13,F_SEC); d.name=mkLabel(12); d.dist=mkLabel(11)
    d.tracer=Instance.new("Frame"); d.tracer.AnchorPoint=Vector2.new(0.5,0.5); d.tracer.BorderSizePixel=0; d.tracer.ZIndex=2; d.tracer.Parent=ESPFolder
    d.hpBg=Instance.new("Frame"); d.hpBg.BackgroundColor3=Color3.fromRGB(14,14,16); d.hpBg.BorderSizePixel=0; d.hpBg.ZIndex=3; d.hpBg.Parent=ESPFolder
    d.hpFill=Instance.new("Frame"); d.hpFill.AnchorPoint=Vector2.new(0,1); d.hpFill.BackgroundColor3=Color3.fromRGB(70,230,110); d.hpFill.BorderSizePixel=0; d.hpFill.Size=UDim2.new(1,0,1,0); d.hpFill.Position=UDim2.new(0,0,1,0); d.hpFill.ZIndex=4; d.hpFill.Parent=d.hpBg
    d.skeleton={}
    for i=1,#BONES do local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.BorderSizePixel=0; f.BackgroundColor3=WHITE; f.Visible=false; f.ZIndex=3; f.Parent=ESPFolder; d.skeleton[i]=f end
    d.highlight=Instance.new("Highlight"); d.highlight.FillTransparency=1; d.highlight.OutlineTransparency=1; d.highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; d.highlight.Parent=ESPFolder
    espData[plr]=d
end

local function removeESP(plr)
    local d=espData[plr]; if not d then return end
    for k,v in pairs(d) do
        if typeof(v)=="Instance" then pcall(function() v:Destroy() end)
        elseif type(v)=="table" then for _,o in pairs(v) do pcall(function() o:Destroy() end) end end
    end
    espData[plr]=nil
end

for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then createESP(plr) end end
Players.PlayerAdded:Connect(function(plr) task.wait(0.2); createESP(plr) end)
Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)

local function espAnyOn() return Flags["Visuals/ESP Box"] or Flags["Visuals/Role"] or Flags["Visuals/Name"] or Flags["Visuals/Health"] or Flags["Visuals/Distance"] or Flags["Visuals/Tracers"] or Flags["Visuals/Skeleton"] or Flags["Visuals/Chams"] or Flags["Visuals/Glow"] end

track(RunService.RenderStepped:Connect(function()
    local cam=workspace.CurrentCamera; if not cam then return end
    local vp=cam.ViewportSize; local t=os.clock()
    local anyOn=espAnyOn()
    for plr,d in pairs(espData) do
        local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local visible=false; local minX,minY,maxX,maxY=math.huge,math.huge,-math.huge,-math.huge
        if char and hum and hrp and hum.Health>0 and anyOn then
            for _,p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") then
                    local sp,onS=cam:WorldToViewportPoint(p.Position)
                    if onS and sp.Z>0 then visible=true; minX=math.min(minX,sp.X-10); maxX=math.max(maxX,sp.X+10); minY=math.min(minY,sp.Y-10); maxY=math.max(maxY,sp.Y+10) end
                end
            end
        end
        if visible then
            local role=getRoleCached(plr); local rcol=ROLE_COLORS[role] or WHITE
            local ecol=Flags["Visuals/Color by Role"] and rcol or getColor(Flags["Visuals/ESP Color"],t,0)
            local w,h=maxX-minX,maxY-minY; local cx=(minX+maxX)*0.5
            d.box.Visible=Flags["Visuals/ESP Box"]; d.box.Position=UDim2.new(0,minX,0,minY); d.box.Size=UDim2.new(0,w,0,h); d.boxStroke.Color=ecol
            d.role.Visible=Flags["Visuals/Role"]; d.role.Text=string.upper(role); d.role.TextColor3=rcol; d.role.Position=UDim2.new(0,cx-130,0,minY-48)
            d.name.Visible=Flags["Visuals/Name"]; d.name.Text=plr.Name; d.name.TextColor3=ecol; d.name.Position=UDim2.new(0,cx-130,0,minY-32)
            local dist=(hrp.Position-cam.CFrame.Position).Magnitude
            d.dist.Visible=Flags["Visuals/Distance"]; d.dist.Text="["..math.floor(dist).."m]"; d.dist.Position=UDim2.new(0,cx-130,0,minY+h+2)
            d.hpBg.Visible=Flags["Visuals/Health"]; d.hpBg.Position=UDim2.new(0,minX-6,0,minY); d.hpBg.Size=UDim2.new(0,3,0,h); d.hpFill.Size=UDim2.new(1,0,math.clamp(hum.Health/hum.MaxHealth,0,1),0)
            d.tracer.Visible=Flags["Visuals/Tracers"]
            if d.tracer.Visible then d.tracer.BackgroundColor3=ecol; setLine(d.tracer,Vector2.new(vp.X*0.5,vp.Y),Vector2.new(cx,minY+h),1) end
            local skelOn=Flags["Visuals/Skeleton"]
            for i,bone in ipairs(BONES) do
                local ln=d.skeleton[i]
                if skelOn then
                    local p1=char:FindFirstChild(bone[1]); local p2=char:FindFirstChild(bone[2])
                    if p1 and p2 then
                        local s1,o1=cam:WorldToViewportPoint(p1.Position); local s2,o2=cam:WorldToViewportPoint(p2.Position)
                        if o1 and o2 and s1.Z>0 and s2.Z>0 then ln.Visible=true; ln.BackgroundColor3=ecol; setLine(ln,Vector2.new(s1.X,s1.Y),Vector2.new(s2.X,s2.Y),1.5)
                        else ln.Visible=false end
                    else ln.Visible=false end
                else ln.Visible=false end
            end
        else
            d.box.Visible=false; d.role.Visible=false; d.name.Visible=false; d.dist.Visible=false; d.hpBg.Visible=false; d.tracer.Visible=false
            for _,ln in ipairs(d.skeleton) do ln.Visible=false end
        end
    end
end))

-- CHAMS / GLOW (own loop, highlight parented to the character so it always renders)
do
local chamsMap={}
local function dropCham(plr) local h=chamsMap[plr]; if h then pcall(function() h:Destroy() end); chamsMap[plr]=nil end end
Players.PlayerRemoving:Connect(dropCham)
track(RunService.Heartbeat:Connect(function()
    local chams,glow=Flags["Visuals/Chams"],Flags["Visuals/Glow"]
    local t=os.clock()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if (chams or glow) and char and hum and hum.Health>0 then
                local h=chamsMap[plr]
                if not h or not h.Parent or h.Adornee~=char then
                    if h then pcall(function() h:Destroy() end) end
                    h=Instance.new("Highlight"); h.Name="luxxsCham"; h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Adornee=char
                    local ok=pcall(function() h.Parent=char end)
                    if not ok or not h.Parent then h.Parent=ESPFolder end
                    chamsMap[plr]=h
                end
                local col
                if Flags["Visuals/Color by Role"] then col=ROLE_COLORS[getRoleCached(plr)] or WHITE else col=getColor(Flags["Visuals/ESP Color"],t,0) end
                h.FillColor=col; h.OutlineColor=col
                h.FillTransparency=chams and math.clamp((Flags["Visuals/Chams Fill"] or 50)/100,0,1) or 1
                h.OutlineTransparency=glow and 0.1 or (chams and 0.55 or 1)
                h.Enabled=true
            else
                dropCham(plr)
            end
        end
    end
end))
end

-- GUN ESP
local GunESP,GunFolder,dropGunVisual,teleportToGun
do
GunESP={set={},vis={}}
GunFolder=Instance.new("Folder"); GunFolder.Name="luxxsGun"; GunFolder.Parent=gui
local GUN_DROP_NAMES={GunDrop=true,["Gun Drop"]=true,DroppedGun=true,SheriffGun=true}

local function gunPartOf(o)
    if o:IsA("BasePart") and GUN_DROP_NAMES[o.Name] then return o end
    if o:IsA("Tool") and o.Parent==workspace and scanName(o.Name)=="Sheriff" then
        return o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end
local function gunStillValid(p)
    if not p or not p.Parent then return false end
    if GUN_DROP_NAMES[p.Name] then return p:IsDescendantOf(workspace) end
    local tool=p.Parent
    return tool:IsA("Tool") and tool.Parent==workspace
end
local function addGun(o) local p=gunPartOf(o); if p then GunESP.set[p]=true end end
function dropGunVisual(p)
    local v=GunESP.vis[p]; if not v then return end
    pcall(function() v.hl:Destroy() end); pcall(function() v.bb:Destroy() end)
    GunESP.vis[p]=nil
end
for _,o in ipairs(workspace:GetDescendants()) do addGun(o) end
track(workspace.DescendantAdded:Connect(addGun))
track(workspace.DescendantRemoving:Connect(function(o) if GunESP.set[o] then GunESP.set[o]=nil; dropGunVisual(o) end end))

local function nearestGun()
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local best,bd=nil,math.huge
    for p in pairs(GunESP.set) do
        if gunStillValid(p) then
            local d=(p.Position-hrp.Position).Magnitude
            if d<bd then best,bd=p,d end
        end
    end
    return best
end

track(RunService.RenderStepped:Connect(function()
    local on=Flags["Visuals/Gun ESP"]
    local cam=workspace.CurrentCamera
    local t=os.clock()
    for p in pairs(GunESP.set) do
        if not gunStillValid(p) then
            GunESP.set[p]=nil; dropGunVisual(p)
        elseif on then
            local v=GunESP.vis[p]
            if not v then
                local hl=Instance.new("Highlight"); hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.FillTransparency=0.35; hl.OutlineTransparency=0; hl.Adornee=p; hl.Parent=GunFolder
                local bb=Instance.new("BillboardGui"); bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,120,0,34); bb.StudsOffset=Vector3.new(0,2.5,0); bb.Adornee=p; bb.Parent=GunFolder
                local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(1,0,1,0); l.Font=F_MONO; l.TextSize=13; l.TextStrokeTransparency=0.3; l.TextStrokeColor3=Color3.new(0,0,0); l.Text="GUN"; l.Parent=bb
                v={hl=hl,bb=bb,lbl=l}; GunESP.vis[p]=v
            end
            local col=getColor(Flags["Visuals/Gun Color"] or "Gold",t,0)
            v.hl.FillColor=col; v.hl.OutlineColor=col; v.lbl.TextColor3=col
            local dist=cam and math.floor((p.Position-cam.CFrame.Position).Magnitude) or 0
            v.lbl.Text="GUN ["..dist.."m]"
        else
            dropGunVisual(p)
        end
    end
end))

function teleportToGun()
    local p=nearestGun()
    if not p then notify("Gun not found") return end
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame=CFrame.new(p.Position+Vector3.new(0,3,0))
    hrp.AssemblyLinearVelocity=Vector3.zero
    notify("Teleported to gun")
end
end

-- AIMBOT
local AIM_PARTS_DATA={
    {name="Head",x=33,y=12,w=24,h=24,r=12,dx=45,dy=24},
    {name="Chest",x=27,y=43,w=36,h=30,r=4,dx=45,dy=58},
    {name="Stomach",x=30,y=73,w=30,h=30,r=3,dx=45,dy=88},
    {name="Left Arm",x=12,y=45,w=13,h=60,r=5,dx=18,dy=75},
    {name="Right Arm",x=65,y=45,w=13,h=60,r=5,dx=72,dy=75},
    {name="Left Leg",x=25,y=104,w=18,h=62,r=5,dx=34,dy=135},
    {name="Right Leg",x=47,y=104,w=18,h=62,r=5,dx=56,dy=135}}
local AIM_NAMES={} for i,a in ipairs(AIM_PARTS_DATA) do AIM_NAMES[i]=a.name end

local function resolveBodyPart(char,name)
    if not char then return nil end
    if name=="Head" then return char:FindFirstChild("Head") end
    if name=="Chest" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
    if name=="Stomach" then return char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") end
    if name=="Left Arm" then return char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") end
    if name=="Right Arm" then return char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") end
    if name=="Left Leg" then return char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") end
    if name=="Right Leg" then return char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") end
    return char:FindFirstChild("Head")
end

local function hasWeapon()
    local char=LP.Character
    if not char then return false end
    for _,obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            local n=string.lower(obj.Name)
            if n:find("knife") or n:find("murder") or n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then return true end
        end
    end
    return false
end

local rayParams=RaycastParams.new()
do
    local ok=pcall(function() rayParams.FilterType=Enum.RaycastFilterType.Exclude end)
    if not ok then pcall(function() rayParams.FilterType=Enum.RaycastFilterType.Blacklist end) end
end
local function hasLineOfSight(fromPos,targetChar,targetPos)
    rayParams.FilterDescendantsInstances={LP.Character}
    local result=workspace:Raycast(fromPos,targetPos-fromPos,rayParams)
    if not result then return true end
    return result.Instance:IsDescendantOf(targetChar)
end

local fovCircle=Instance.new("Frame"); fovCircle.AnchorPoint=Vector2.new(0.5,0.5); fovCircle.Position=UDim2.new(0.5,0,0.5,0); fovCircle.BackgroundTransparency=1; fovCircle.BorderSizePixel=0; fovCircle.Visible=false; fovCircle.ZIndex=2; fovCircle.Parent=gui; corner(fovCircle,9999)
local fovStroke=stroke(fovCircle,ACC,2,0.1); T(fovStroke,"Color"); fovCircle.BackgroundColor3=ACC; fovCircle.BackgroundTransparency=0.93
local fovLbl=Instance.new("TextLabel"); fovLbl.BackgroundTransparency=1; fovLbl.AnchorPoint=Vector2.new(0.5,1); fovLbl.Position=UDim2.new(0.5,0,0,-4); fovLbl.Size=UDim2.new(0,180,0,14); fovLbl.Font=F_MONO; fovLbl.TextSize=11; fovLbl.TextColor3=WHITE; fovLbl.TextStrokeTransparency=0.4; fovLbl.Parent=fovCircle

local function getFovRadiusPx() local cam=workspace.CurrentCamera; if not cam then return 200 end; return ((Flags["Aimbot/FOV"] or 120)/180)*math.min(cam.ViewportSize.X,cam.ViewportSize.Y) end

local function findAimbotTarget()
    local cam=workspace.CurrentCamera; if not cam then return nil end
    local center=Vector2.new(cam.ViewportSize.X*0.5,cam.ViewportSize.Y*0.5); local radius=getFovRadiusPx()
    local partName=Flags["Aimbot/Body Part"] or "Head"; local best,bestDist=nil,math.huge
    local origin=cam.CFrame.Position
    local skipInno=Flags["Aimbot/Skip Innocents"]
    local wall=Flags["Aimbot/Wall Check"]
    local myRole=getRoleCached(LP)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health>0 then
                local ok=true
                if skipInno then
                    local r=getRoleCached(plr)
                    if r=="Innocent" or r==myRole then ok=false end
                end
                if ok then
                    local part=resolveBodyPart(char,partName)
                    if part then
                        local sp=cam:WorldToViewportPoint(part.Position)
                        if sp.Z>0 then
                            local dist=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                            if dist<=radius and dist<bestDist then
                                if (not wall) or hasLineOfSight(origin,char,part.Position) then best,bestDist={player=plr,part=part},dist end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

track(RunService.RenderStepped:Connect(function(dt)
    local cam=workspace.CurrentCamera; if not cam then return end
    local showFov=Flags["Aimbot/Enable"] and Flags["Aimbot/Show FOV"]
    fovCircle.Visible=showFov and true or false
    if showFov then local rr=getFovRadiusPx(); fovCircle.Size=UDim2.new(0,rr*2,0,rr*2); fovCircle.BackgroundColor3=ACC; fovLbl.Text="AIM FOV  r="..math.floor(rr).."px" end
    if not Flags["Aimbot/Enable"] then return end
    if Flags["Aimbot/Weapon Only"] and not hasWeapon() then return end
    local target=findAimbotTarget()
    if target then
        local smooth=math.clamp(Flags["Aimbot/Smoothness"] or 30,1,100)/100
        local alpha=math.clamp(1-smooth,0.03,1)*math.min(1,dt*60)
        cam.CFrame=cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position,target.part.Position),alpha)
    end
end))

local Shoot={}
-- SILENT AIM
do
local SA={Target=nil,Pos=Vector3.zero}
local scirc=Instance.new("Frame"); scirc.AnchorPoint=Vector2.new(0.5,0.5); scirc.BackgroundColor3=Color3.fromRGB(255,70,70); scirc.BackgroundTransparency=0.92; scirc.BorderSizePixel=0; scirc.Visible=false; scirc.ZIndex=2; scirc.Parent=gui; corner(scirc,9999)
stroke(scirc,Color3.fromRGB(255,80,80),2,0)
local slbl=Instance.new("TextLabel"); slbl.BackgroundTransparency=1; slbl.AnchorPoint=Vector2.new(0.5,1); slbl.Position=UDim2.new(0.5,0,0,-4); slbl.Size=UDim2.new(0,200,0,14); slbl.Font=F_MONO; slbl.TextSize=11; slbl.TextColor3=Color3.fromRGB(255,120,120); slbl.TextStrokeTransparency=0.4; slbl.Parent=scirc
local sdot=Instance.new("Frame"); sdot.AnchorPoint=Vector2.new(0.5,0.5); sdot.Size=UDim2.new(0,8,0,8); sdot.BackgroundColor3=Color3.fromRGB(255,70,70); sdot.BorderSizePixel=0; sdot.Visible=false; sdot.ZIndex=3; sdot.Parent=gui; corner(sdot,9999)

local function screenCenter()
    local cam=workspace.CurrentCamera
    if UIS.TouchEnabled and not UIS.MouseEnabled then return Vector2.new(cam.ViewportSize.X*0.5,cam.ViewportSize.Y*0.5) end
    return UIS:GetMouseLocation()
end

local function pickTarget()
    local cam=workspace.CurrentCamera; if not cam then return nil end
    local center=screenCenter(); local radius=Flags["Aimbot/Silent FOV"] or 150
    local partName=Flags["Aimbot/Silent Part"] or "Head"
    local mode=Flags["Aimbot/Silent Targets"] or "Auto"
    local myRole=getRoleCached(LP)
    local best,bd=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local char=plr.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health>0 then
                local ok=true
                if mode=="Murderer" or (mode=="Auto" and myRole=="Sheriff") then ok=(getRoleCached(plr)=="Murderer") end
                if ok then
                    local part=resolveBodyPart(char,partName)
                    if part then
                        local sp=cam:WorldToViewportPoint(part.Position)
                        if sp.Z>0 then
                            local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                            if d<=radius and d<bd then
                                if (not Flags["Aimbot/Silent Wall Check"]) or hasLineOfSight(cam.CFrame.Position,char,part.Position) then best,bd=part,d end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

track(RunService.RenderStepped:Connect(function()
    local on=Flags["Aimbot/Silent Aim"]
    local cam=workspace.CurrentCamera
    if not on or not cam then SA.Target=nil; scirc.Visible=false; sdot.Visible=false; return end
    local c=screenCenter(); local r=Flags["Aimbot/Silent FOV"] or 150
    local show=Flags["Aimbot/Silent Show FOV"]
    scirc.Visible=show and true or false
    if show then scirc.Position=UDim2.fromOffset(c.X,c.Y); scirc.Size=UDim2.fromOffset(r*2,r*2); slbl.Text="SILENT FOV  r="..math.floor(r).."px" end
    local t=pickTarget()
    if t and t.Parent then
        local hum=t.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then t=nil end
    end
    if t then
        SA.Target=t
        SA.Pos=t.Position+t.AssemblyLinearVelocity*0.05
        local sp,vis=cam:WorldToViewportPoint(t.Position)
        sdot.Visible=vis and show and true or false
        sdot.Position=UDim2.fromOffset(sp.X,sp.Y)
    else
        SA.Target=nil; sdot.Visible=false
    end
end))

local function chance() return math.random(1,100)<=(Flags["Aimbot/Silent Hit Chance"] or 100) end

-- shot anywhere = hit: when you use the weapon and an enemy is inside the silent FOV circle, the hit is sent to him
local function fireAtTarget(tool)
    if not (Flags["Aimbot/Silent Aim"] and Flags["Aimbot/Silent Kill"]) then return end
    local tgt=SA.Target; if not tgt or not tgt.Parent then return end
    local tchar=tgt.Parent
    local hum=tchar:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health<=0 then return end
    if not chance() then return end
    if Shoot.fireRemotes then Shoot.fireRemotes(tool,SA.Pos,tchar) end
    if Shoot.touchKill and string.find(string.lower(tool.Name),"knife") then Shoot.touchKill(tool,tchar) end
end
local watched=setmetatable({},{__mode="k"})
local function watchTool(o)
    if o:IsA("Tool") and not watched[o] then
        watched[o]=true
        track(o.Activated:Connect(function() fireAtTarget(o) end))
    end
end
local function watchChar(ch)
    for _,o in ipairs(ch:GetChildren()) do watchTool(o) end
    track(ch.ChildAdded:Connect(watchTool))
end
if LP.Character then watchChar(LP.Character) end
track(LP.CharacterAdded:Connect(watchChar))

-- Silent aim через 3 уровня хуков:
--  1) метатейбл Mouse (getrawmetatable)
--  2) game.__index — резервный перехват Mouse
--  3) game.__namecall — Raycast/FindPartOnRay*/FireServer+InvokeServer (ЛЮБОЙ remote с Vector3/CFrame)
local hooked=false
local function installHooks()
    if hooked then return true end
    if type(hookmetamethod)~="function" or type(getnamecallmethod)~="function" then return false end
    local ncc=newcclosure or function(f) return f end
    local chk=checkcaller or function() return false end
    local mouse=LP:GetMouse()

    -- 1) Мышь: hook метатейбла через getrawmetatable
    pcall(function()
        if type(getrawmetatable)=="function" and type(setreadonly)=="function" then
            local mt=getrawmetatable(mouse)
            if mt and mt.__index then
                local oldIdx=mt.__index
                pcall(function() setreadonly(mt,false) end)
                mt.__index=ncc(function(self,k)
                    if SA.Target and Flags["Aimbot/Silent Aim"] and not chk() then
                        if k=="Hit" then return CFrame.new(SA.Pos) end
                        if k=="Target" then return SA.Target end
                    end
                    return oldIdx(self,k)
                end)
                pcall(function() setreadonly(mt,true) end)
            end
        end
    end)

    -- 2) game.__index как резерв
    local oldIndex
    oldIndex=hookmetamethod(game,"__index",ncc(function(self,k)
        if SA.Target and Flags["Aimbot/Silent Aim"] and not chk() then
            local isMouse=false
            pcall(function() isMouse=(self==mouse) end)
            if isMouse then
                if k=="Hit" then return CFrame.new(SA.Pos) end
                if k=="Target" then return SA.Target end
            end
        end
        return oldIndex(self,k)
    end))

    -- 3) Агрессивный __namecall: любые FireServer/InvokeServer с Vector3/CFrame
    local oldNC
    oldNC=hookmetamethod(game,"__namecall",ncc(function(self,...)
        local m=getnamecallmethod()
        if SA.Target and Flags["Aimbot/Silent Aim"] and not chk() then
            if m=="Raycast" then
                local a={...}
                if typeof(a[1])=="Vector3" then
                    a[2]=(SA.Pos-a[1]).Unit*1000
                    return oldNC(self,table.unpack(a))
                end
            elseif m=="FindPartOnRay" or m=="FindPartOnRayWithIgnoreList" or m=="FindPartOnRayWithWhitelist" then
                local a={...}
                if typeof(a[1])=="Ray" then
                    a[1]=Ray.new(a[1].Origin,(SA.Pos-a[1].Origin).Unit*1000)
                    return oldNC(self,table.unpack(a))
                end
            elseif (m=="FireServer" or m=="InvokeServer") and typeof(self)=="Instance" then
                local a={...}; local changed=false
                for i=1,#a do
                    local v=a[i]
                    if typeof(v)=="CFrame" then a[i]=CFrame.new(SA.Pos); changed=true
                    elseif typeof(v)=="Vector3" then a[i]=SA.Pos; changed=true end
                end
                if changed and chance() then return oldNC(self,table.unpack(a)) end
            end
        end
        return oldNC(self,...)
    end))
    hooked=true
    return true
end

local okH=pcall(installHooks)
if not okH or not hooked then
    task.defer(function() notify("Silent Aim: executor lacks hookmetamethod") end)
end
end

-- FARM
local Farm={Enabled=false,Mode="Teleport",Speed=80,TeleportDelay=0.15,AntiAFK=false,ReturnOnFinish=false,ReturnPos=nil,LoopThread=nil,Collected=0,Status="idle"}
local setAntiAFK,disableFly,enableFly,setNoclip,startFarm,stopFarm
do
local antiAfkConn=nil
function setAntiAFK(on)
    if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn=nil end
    if not on then return end
    antiAfkConn=LP.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
end

local coinSet,coinConns={}, {}
local function isCoin(o) return o:IsA("BasePart") and (o.Name=="Coin" or o.Name:find("Coin") or o.Name:find("coin")) end
local function startCoinCache()
    for _,c in ipairs(coinConns) do c:Disconnect() end
    coinConns={}; coinSet={}
    for _,o in ipairs(workspace:GetDescendants()) do if isCoin(o) then coinSet[o]=true end end
    coinConns[1]=workspace.DescendantAdded:Connect(function(o) if isCoin(o) then coinSet[o]=true end end)
    coinConns[2]=workspace.DescendantRemoving:Connect(function(o)
        if coinSet[o] then
            coinSet[o]=nil
            local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if Farm.Enabled and hrp and (hrp.Position-o.Position).Magnitude<12 then Farm.Collected+=1 end
        end
    end)
end

local function getNearestCoin(pos,skip)
    local best,bestDist,now=nil,math.huge,os.clock()
    for p in pairs(coinSet) do
        if p.Parent and not (skip[p] and skip[p]>now) then
            local d=(p.Position-pos).Magnitude
            if d<bestDist then best,bestDist=p,d end
        end
    end
    return best
end

local flyConn,flyBodyVel,flyBodyGyro=nil,nil,nil
function disableFly()
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    local char=LP.Character
    if char then
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel=nil end
            if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro=nil end
        end
    end
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand=false end
end

function enableFly()
    disableFly()
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    flyBodyVel=Instance.new("BodyVelocity"); flyBodyVel.MaxForce=Vector3.new(9e9,9e9,9e9); flyBodyVel.Velocity=Vector3.zero; flyBodyVel.Parent=hrp
    flyBodyGyro=Instance.new("BodyGyro"); flyBodyGyro.MaxTorque=Vector3.new(9e9,9e9,9e9); flyBodyGyro.P=2000; flyBodyGyro.CFrame=hrp.CFrame; flyBodyGyro.Parent=hrp
    hum.PlatformStand=true
    local cam=workspace.CurrentCamera
    flyConn=RunService.RenderStepped:Connect(function()
        if not Farm.Enabled or not hrp or not hrp.Parent then return end
        local moveDir=Vector3.zero
        local look=cam.CFrame.LookVector; local right=cam.CFrame.RightVector
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir+=look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir-=look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir-=right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir+=right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir+=Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir-=Vector3.new(0,1,0) end
        if moveDir.Magnitude>0 then moveDir=moveDir.Unit end
        flyBodyVel.Velocity=moveDir*Farm.Speed
        flyBodyGyro.CFrame=cam.CFrame
    end)
end

local noclipConn=nil
function setNoclip(on)
    if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
    if not on then
        local char=LP.Character
        if char then for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.CanCollide=true end) end end end
        return
    end
    noclipConn=RunService.Stepped:Connect(function()
        if not Farm.Enabled then return end
        local char=LP.Character; if not char then return end
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then pcall(function() p.CanCollide=false end) end
        end
    end)
end

local function teleportTo(pos)
    local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame=CFrame.new(pos+Vector3.new(0,3,0)); return true
end

-- Anti-kick: телепорт не чаще 130мс между монетами
function startFarm()
    if Farm.LoopThread then return end
    local hrp0=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if Farm.ReturnOnFinish and hrp0 then Farm.ReturnPos=hrp0.CFrame end
    Farm.LoopThread=task.spawn(function()
        startCoinCache()
        local skip={}
        local lastCollect=0
        while Farm.Enabled do
            local dt=RunService.Heartbeat:Wait()
            local now=os.clock()
            local char=LP.Character
            local hrp=char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local tooFast = Farm.Mode=="Teleport" and (now-lastCollect)<0.13
                if tooFast then
                    Farm.Status="cooldown (anti-kick)"; task.wait(0.05)
                else
                    local coin=getNearestCoin(hrp.Position,skip)
                    if coin then
                        Farm.Status="to coin"
                        local target=coin.Position
                        if Farm.Mode=="Teleport" then
                            hrp.CFrame=CFrame.new(target)
                            hrp.AssemblyLinearVelocity=Vector3.zero
                            if Farm.TeleportDelay>0 then task.wait(Farm.TeleportDelay) end
                            lastCollect=os.clock()
                        else
                            local d=target-hrp.Position
                            local step=Farm.Speed*dt
                            if d.Magnitude<=step then
                                hrp.CFrame=CFrame.new(target)
                            else
                                hrp.CFrame=CFrame.new(hrp.Position+d.Unit*step)
                            end
                            hrp.AssemblyLinearVelocity=Vector3.zero
                        end
                        if (hrp.Position-target).Magnitude<3 then skip[coin]=os.clock()+0.4 end
                    else
                        Farm.Status="no coins"; task.wait(0.2)
                    end
                end
            end
        end
        if Farm.ReturnOnFinish and Farm.ReturnPos then teleportTo(Farm.ReturnPos.Position) end
        Farm.Status="idle"
    end)
end

function stopFarm()
    Farm.Enabled=false
    if Farm.LoopThread then pcall(function() task.cancel(Farm.LoopThread) end); Farm.LoopThread=nil end
    for _,c in ipairs(coinConns) do c:Disconnect() end
    coinConns={}
    disableFly(); setNoclip(false)
end
end

-- FLY + NOCLIP (move)
local Move={Fly=false,Speed=60,Noclip=false}
local flyUpBtn,flyDownBtn,disableFlyMove,setNoclipMove
do
local mvConn,mvVel,mvGyro,mvControls=nil,nil,nil,nil
local upHeld,downHeld=false,false

local function mkFlyBtn(txt,yOff)
    local b=Instance.new("TextButton"); b.AnchorPoint=Vector2.new(1,0.5); b.Position=UDim2.new(1,-24,0.5,yOff); b.Size=UDim2.new(0,54,0,44)
    b.BackgroundColor3=C.bg; b.BackgroundTransparency=0.1; b.BorderSizePixel=0; b.Text=txt; b.Font=F_MONO; b.TextSize=14; b.TextColor3=C.text
    b.AutoButtonColor=false; b.Visible=false; b.ZIndex=5; b.Parent=gui
    local s=stroke(b,ACC,1.5,0); T(s,"Color")
    return b
end
flyUpBtn,flyDownBtn=mkFlyBtn("UP",-28),mkFlyBtn("DN",28)
local function bindHold(b,setter)
    b.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then setter(true); b.BackgroundColor3=ACC; b.TextColor3=C.bg end end)
    b.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then setter(false); b.BackgroundColor3=C.bg; b.TextColor3=C.text end end)
end
bindHold(flyUpBtn,function(v) upHeld=v end)
bindHold(flyDownBtn,function(v) downHeld=v end)

local function getMoveVector()
    if mvControls then
        local ok,v=pcall(function() return mvControls:GetMoveVector() end)
        if ok and typeof(v)=="Vector3" then return v end
    end
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    local cam=workspace.CurrentCamera
    if hum and cam then return cam.CFrame:VectorToObjectSpace(hum.MoveDirection) end
    return Vector3.zero
end

function disableFlyMove()
    if mvConn then mvConn:Disconnect(); mvConn=nil end
    if mvVel then pcall(function() mvVel:Destroy() end); mvVel=nil end
    if mvGyro then pcall(function() mvGyro:Destroy() end); mvGyro=nil end
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand=false; pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
end

enableFlyMove=function()
    disableFlyMove()
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if not mvControls then
        pcall(function()
            local pm=LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
            if pm then mvControls=require(pm):GetControls() end
        end)
    end
    mvVel=Instance.new("BodyVelocity"); mvVel.MaxForce=Vector3.new(9e9,9e9,9e9); mvVel.Velocity=Vector3.zero; mvVel.Parent=hrp
    mvGyro=Instance.new("BodyGyro"); mvGyro.MaxTorque=Vector3.new(9e9,9e9,9e9); mvGyro.P=9e4; mvGyro.D=800; mvGyro.CFrame=hrp.CFrame; mvGyro.Parent=hrp
    hum.PlatformStand=true
    mvConn=RunService.RenderStepped:Connect(function()
        if not hrp.Parent then return end
        local cam=workspace.CurrentCamera; if not cam then return end
        local mv=getMoveVector()
        local dir=cam.CFrame:VectorToWorldSpace(Vector3.new(mv.X,0,mv.Z))
        if UIS:IsKeyDown(Enum.KeyCode.W) and mv.Magnitude==0 then dir+=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.E) or upHeld then dir+=Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.Q) or downHeld then dir-=Vector3.new(0,1,0) end
        if dir.Magnitude>1 then dir=dir.Unit end
        mvVel.Velocity=dir*Move.Speed
        local look=cam.CFrame.LookVector
        if Vector3.new(look.X,0,look.Z).Magnitude>0.01 then
            mvGyro.CFrame=CFrame.lookAt(hrp.Position,hrp.Position+Vector3.new(look.X,0,look.Z))
        end
    end)
end

local ncConn,ncTouched=nil,{}
function setNoclipMove(on)
    if ncConn then ncConn:Disconnect(); ncConn=nil end
    if on then
        ncConn=RunService.Stepped:Connect(function()
            local char=LP.Character; if not char then return end
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then ncTouched[p]=true; p.CanCollide=false end
            end
        end)
    else
        for p in pairs(ncTouched) do if p.Parent then pcall(function() p.CanCollide=true end) end end
        ncTouched={}
    end
end
end

-- AUTO WIN
local AutoWin={Enabled=false,Teleport=true,AutoEquip=true,Delay=0.2,Thread=nil,Status="idle"}

local startAutoWin,stopAutoWin
do
local VIM=nil
pcall(function() VIM=game:GetService("VirtualInputManager") end)

local function isWeaponTool(t)
    local n=string.lower(t.Name)
    return (n:find("knife")~=nil) or (n:find("gun")~=nil) or (n:find("revolver")~=nil) or (n:find("pistol")~=nil) or (n:find("sheriff")~=nil) or (n:find("murder")~=nil)
end

local function getEquippedWeapon()
    local char=LP.Character
    if not char then return nil end
    local t=char:FindFirstChildOfClass("Tool")
    if t and isWeaponTool(t) then return t end
    return nil
end

local function equipWeapon()
    local char=LP.Character
    if not char then return nil end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local current=getEquippedWeapon()
    if current then return current end
    local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not bp then return nil end
    for _,t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") and isWeaponTool(t) then
            pcall(function() hum:EquipTool(t) end)
            task.wait(0.2)
            return getEquippedWeapon() or t
        end
    end
    return nil
end

local function isAlive(plr)
    local c=plr and plr.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if c and h and r and h.Health>0 then return c,h,r end
    return nil
end

local function findTarget(myRole)
    local _,_,myRoot=isAlive(LP)
    if not myRoot then return nil end
    local best,bestScore=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local c,h,r=isAlive(plr)
            if c then
                local role=getRoleCached(plr)
                local score=nil
                if myRole=="Murderer" then
                    score=(role=="Sheriff") and 0 or 1
                elseif myRole=="Sheriff" then
                    if role=="Murderer" then score=0 end
                end
                if score then
                    local combined=score*100000+(r.Position-myRoot.Position).Magnitude
                    if combined<bestScore then bestScore=combined; best={plr=plr,char=c,hum=h,root=r,role=role} end
                end
            end
        end
    end
    return best
end

local function fireRemotes(tool,pos,targetChar)
    local cf=CFrame.new(pos)
    for _,d in ipairs(tool:GetDescendants()) do
        if d:IsA("RemoteEvent") then
            pcall(function() d:FireServer(cf) end)
            pcall(function() d:FireServer(pos) end)
            pcall(function() d:FireServer(1,cf,"AH2") end)
            pcall(function() d:FireServer(1,pos,"AH2") end)
            pcall(function() d:FireServer(targetChar) end)
            pcall(function() d:FireServer(tool.Handle.CFrame) end)
        elseif d:IsA("RemoteFunction") then
            task.spawn(function()
                pcall(function() d:InvokeServer(cf) end)
                pcall(function() d:InvokeServer(pos) end)
                pcall(function() d:InvokeServer(1,cf,"AH2") end)
            end)
        end
    end
end

local function touchKill(tool,targetChar)
    if type(firetouchinterest)~="function" then return end
    local handle=tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    if not handle then return end
    for _,p in ipairs(targetChar:GetChildren()) do
        if p:IsA("BasePart") then
            pcall(firetouchinterest,handle,p,0)
            pcall(firetouchinterest,handle,p,1)
        end
    end
end

local function clickAt(vec2)
    if not VIM then return end
    pcall(function() VIM:SendMouseButtonEvent(vec2.X,vec2.Y,0,true,game,0) end)
    pcall(function() VIM:SendMouseButtonEvent(vec2.X,vec2.Y,0,false,game,0) end)
end

local function step()
    local _,_,hrp=isAlive(LP)
    if not hrp then AutoWin.Status="waiting for character"; return end
    local myRole=getRoleCached(LP)
    if myRole~="Murderer" and myRole~="Sheriff" then AutoWin.Status="innocent: nothing to do"; return end
    local target=findTarget(myRole)
    if not target then AutoWin.Status=(myRole=="Sheriff") and "waiting for murderer" or "no targets left"; return end
    local tool=AutoWin.AutoEquip and equipWeapon() or getEquippedWeapon()
    if not tool then AutoWin.Status="no weapon found"; return end
    local cam=workspace.CurrentCamera
    local tRoot=target.root
    local tHead=target.char:FindFirstChild("Head") or tRoot
    AutoWin.Status=((myRole=="Sheriff") and "shooting " or "stabbing ")..target.plr.Name

    if myRole=="Sheriff" then
        -- ШЕРИФ: ждём реальную экипировку пушки
        local char=LP.Character
        local equippedTool=char and char:FindFirstChildOfClass("Tool")
        if not equippedTool then
            AutoWin.Status="equipping weapon..."
            return
        end
        -- встаём позади цели
        if AutoWin.Teleport then
            local back=tRoot.CFrame*CFrame.new(0,0.5,6)
            hrp.CFrame=CFrame.lookAt(back.Position,tHead.Position)
            hrp.AssemblyLinearVelocity=Vector3.zero
            task.wait(0.06)
        end
        if cam then cam.CFrame=CFrame.lookAt(cam.CFrame.Position,tHead.Position) end
        task.wait(0.03)
        -- 1) Activate
        pcall(function() tool:Activate() end)
        -- 2) FireServer вручную
        fireRemotes(tool,tHead.Position,target.char)
        -- 3) клик мышью в центр экрана
        if cam then
            local vp=cam.ViewportSize
            clickAt(Vector2.new(vp.X*0.5,vp.Y*0.5))
        end
        -- 4) ещё раз Activate
        task.wait(0.05)
        pcall(function() tool:Activate() end)
        -- 5) пауза на перезарядку
        task.wait(0.35)
    else
        -- УБИЙЦА
        if AutoWin.Teleport then
            hrp.CFrame=tRoot.CFrame*CFrame.new(0,0,1.8)
            hrp.AssemblyLinearVelocity=Vector3.zero
        end
        if cam then cam.CFrame=CFrame.lookAt(cam.CFrame.Position,tRoot.Position) end
        touchKill(tool,target.char)
        pcall(function() tool:Activate() end)
        fireRemotes(tool,tRoot.Position,target.char)
        task.wait(0.05)
    end
end

local function autoWinLoop()
    while AutoWin.Enabled do
        local ok,err=pcall(step)
        if not ok then AutoWin.Status="error: "..tostring(err) end
        task.wait(AutoWin.Delay)
    end
    AutoWin.Status="idle"
end

function startAutoWin()
    AutoWin.Enabled=true
    if not AutoWin.Thread then AutoWin.Thread=task.spawn(autoWinLoop) end
end

function stopAutoWin()
    AutoWin.Enabled=false
    if AutoWin.Thread then pcall(function() task.cancel(AutoWin.Thread) end); AutoWin.Thread=nil end
    AutoWin.Status="idle"
end
Shoot.fireRemotes=fireRemotes; Shoot.touchKill=touchKill
end

-- WALKSPEED + SPIN
local Move2={WalkSpeed=16,SpinSpeed=0,SpinEnabled=false}
local applyWalkSpeed,startSpin,stopSpin
do
local spinAngle=0
local spinThread=nil

function applyWalkSpeed(v)
    v=tonumber(v) or 16
    Move2.WalkSpeed=v
    local char=LP.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed=v end
end

track(LP.CharacterAdded:Connect(function(c)
    local hum=c:WaitForChild("Humanoid",10)
    if hum then task.wait(0.4); hum.WalkSpeed=Move2.WalkSpeed end
end))

local function spinLoop()
    while Move2.SpinEnabled do
        local dt=RunService.RenderStepped:Wait()
        local char=LP.Character
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            spinAngle=spinAngle+math.rad(Move2.SpinSpeed)*dt
            if spinAngle>math.pi*2 then spinAngle=spinAngle-math.pi*2 end
            hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(0,spinAngle,0)
        end
    end
end

function startSpin()
    if spinThread then return end
    Move2.SpinEnabled=true
    spinThread=task.spawn(spinLoop)
end

function stopSpin()
    Move2.SpinEnabled=false
    if spinThread then pcall(function() task.cancel(spinThread) end); spinThread=nil end
end
end

-- BUNNYHOP (CS2-style: speed is kept between hops, hold Space / jump button + move)
local BHop={Enabled=false,Accel=40,Max=120,Boost=4,lastJump=0,vel=nil}
do
    track(UIS.JumpRequest:Connect(function() BHop.lastJump=os.clock() end))
    track(RunService.Heartbeat:Connect(function(dt)
        if not BHop.Enabled or Move.Fly then BHop.vel=nil; return end
        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health<=0 then BHop.vel=nil; return end
        local held=UIS:IsKeyDown(Enum.KeyCode.Space) or (os.clock()-BHop.lastJump<0.25)
        local wish=hum.MoveDirection
        local grounded=hum.FloorMaterial~=Enum.Material.Air
        if not held or wish.Magnitude<0.1 then
            if grounded then BHop.vel=nil end
            return
        end
        wish=wish.Unit
        local v=hrp.AssemblyLinearVelocity
        local h=BHop.vel or Vector3.new(v.X,0,v.Z)
        if grounded then
            -- landing: keep the speed we had in the air (no friction), add boost, jump again
            local spd=math.min(math.max(h.Magnitude,hum.WalkSpeed)+BHop.Boost,BHop.Max)
            h=wish*spd
            local jy=hum.UseJumpPower and hum.JumpPower or math.sqrt(2*workspace.Gravity*hum.JumpHeight)
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            hrp.AssemblyLinearVelocity=Vector3.new(h.X,jy,h.Z)
        else
            -- in air: turn toward where you move (strafe) and gain speed
            local spd=h.Magnitude
            if spd>0.1 then
                local d=h.Unit:Lerp(wish,math.clamp(dt*4,0,1))
                if d.Magnitude>0.01 then h=d.Unit*spd end
            else
                h=wish*hum.WalkSpeed
            end
            h=h+wish*BHop.Accel*dt
            if h.Magnitude>BHop.Max then h=h.Unit*BHop.Max end
            hrp.AssemblyLinearVelocity=Vector3.new(h.X,v.Y,h.Z)
        end
        BHop.vel=h
    end))
end

-- FPS
local FPS={Enabled=false,Target=10000,Current=0}
local originalFpsCap=nil
local function applyFpsCap(cap) if type(setfpscap)=="function" then pcall(setfpscap,cap) end FPS.Current=cap end
local function enableFps()
    if type(getfpscap)=="function" then local ok,cur=pcall(getfpscap); if ok then originalFpsCap=cur end end
    applyFpsCap(FPS.Target); notify("FPS unlocked to "..FPS.Target)
end
local function disableFps()
    if originalFpsCap then applyFpsCap(originalFpsCap) else applyFpsCap(60) end
    notify("FPS restored")
end

local fpsGui=Instance.new("ScreenGui"); fpsGui.Name="luxxsFPS"; fpsGui.ResetOnSpawn=false; fpsGui.IgnoreGuiInset=true; fpsGui.DisplayOrder=100; fpsGui.Parent=parent
local fpsFrame=Instance.new("Frame"); fpsFrame.AnchorPoint=Vector2.new(1,0); fpsFrame.Position=UDim2.new(1,-12,0,12); fpsFrame.Size=UDim2.new(0,84,0,24); fpsFrame.BackgroundColor3=C.bg; fpsFrame.BackgroundTransparency=0.1; fpsFrame.BorderSizePixel=0; fpsFrame.Visible=true; fpsFrame.ZIndex=5; fpsFrame.Parent=fpsGui
stroke(fpsFrame,C.line,1,0)
local fpsBar=Instance.new("Frame"); fpsBar.Size=UDim2.new(0,2,1,0); fpsBar.BorderSizePixel=0; fpsBar.ZIndex=6; fpsBar.Parent=fpsFrame; T(fpsBar,"BackgroundColor3")
local fpsNum=Instance.new("TextLabel"); fpsNum.BackgroundTransparency=1; fpsNum.Position=UDim2.new(0,10,0,0); fpsNum.Size=UDim2.new(1,-12,1,0); fpsNum.Font=F_MONO; fpsNum.TextSize=12; fpsNum.TextColor3=C.text; fpsNum.TextXAlignment=Enum.TextXAlignment.Left; fpsNum.Text="0 FPS"; fpsNum.ZIndex=6; fpsNum.Parent=fpsFrame

local FpsCounter={Avg=0,Max=0,Frames=0,Last=tick()}
task.spawn(function()
    while fpsGui.Parent do
        RunService.RenderStepped:Wait()
        FpsCounter.Frames+=1
        local elapsed=tick()-FpsCounter.Last
        if elapsed>=0.25 then
            local fps=math.floor(FpsCounter.Frames/elapsed+0.5)
            FpsCounter.Frames=0; FpsCounter.Last=tick()
            FpsCounter.Avg=FpsCounter.Avg==0 and fps or (FpsCounter.Avg*0.9+fps*0.1)
            if fps>FpsCounter.Max then FpsCounter.Max=fps end
            fpsNum.Text=tostring(fps).." FPS"
            fpsNum.TextColor3=fps>=60 and C.text or (fps>=30 and Color3.fromRGB(255,190,70) or Color3.fromRGB(255,84,84))
        end
    end
end)
makeDraggable(fpsFrame,fpsFrame)

-- TABS
local visTab=createTab("Visuals")
visTab:Label("ESP")
visTab:Toggle("ESP Box",false)
visTab:Toggle("Role",false)
visTab:Choice("Role (Preview)",ROLE_NAMES,"Murderer")
visTab:Toggle("Color by Role",false)
visTab:Toggle("Name",false)
visTab:Toggle("Health",false)
visTab:Toggle("Distance",false)
visTab:Toggle("Tracers",false)
visTab:Toggle("Skeleton",false)
visTab:Toggle("Chams",false)
visTab:Toggle("Glow",false)
visTab:Slider("Chams Fill",0,100,50)
visTab:Choice("ESP Color",COLOR_NAMES,"Lime")
visTab:Label("Gun ESP")
visTab:Toggle("Gun ESP",false)
visTab:Choice("Gun Color",COLOR_NAMES,"Gold")
visTab:Button("Teleport to Gun",teleportToGun)
visTab:Label("Wings")
visTab:Toggle("Wings",false,function(s) if s then buildWings() else destroyCos("wings") end end)
visTab:Choice("Wing Color",WING_COLORS,"White")
visTab:Slider("Wing Speed",1,10,3)
visTab:Label("Chinese Hat")
visTab:Toggle("Chinese Hat",false,function(s) if s then buildHat() else destroyCos("hat") end end)
local function refreshHatGrads() for _,k in ipairs({"Visuals/Hat Saturation","Visuals/Hat Shade"}) do local f=GradRefresh[k]; if f then f() end end end
visTab:Choice("Hat Color",HAT_COLORS,"Custom")
visTab:Slider("Hat Hue",0,360,280,function(v) _G.LUXXS_HAT_H=v; refreshHatGrads() end,function()
    local kp={} for k=0,6 do kp[#kp+1]=ColorSequenceKeypoint.new(k/6,Color3.fromHSV(k/6,1,1)) end return ColorSequence.new(kp)
end)
visTab:Slider("Hat Saturation",0,100,70,function(v) _G.LUXXS_HAT_S=v/100; refreshHatGrads() end,function()
    local h=_G.LUXXS_HAT_H/360; return ColorSequence.new(Color3.fromHSV(h,0,_G.LUXXS_HAT_V),Color3.fromHSV(h,1,_G.LUXXS_HAT_V))
end)
visTab:Slider("Hat Shade",0,100,100,function(v) _G.LUXXS_HAT_V=v/100; refreshHatGrads() end,function()
    local h=_G.LUXXS_HAT_H/360; return ColorSequence.new(Color3.new(0,0,0),Color3.fromHSV(h,_G.LUXXS_HAT_S,1))
end)
visTab:Slider("Hat Transparency",0,100,35)
visTab:Label("Trail")
visTab:Toggle("Trail",false,function(s) if s then buildTrail() else destroyCos("trail") end end)
visTab:Choice("Trail Color",COLOR_NAMES,"Rainbow")
visTab:Slider("Trail Length",1,30,10)
visTab:Slider("Trail Width",1,10,4)

local aimTab=createTab("Aimbot")
aimTab:Label("Aim")
aimTab:Toggle("Enable",false)
aimTab:Toggle("Skip Innocents",true)
aimTab:Toggle("Weapon Only",true)
aimTab:Toggle("Wall Check",true)
aimTab:Choice("Body Part",AIM_NAMES,"Head")
aimTab:Slider("FOV",10,360,120)
aimTab:Slider("Smoothness",1,100,30)
aimTab:Toggle("Show FOV",true)
aimTab:Label("Silent Aim")
aimTab:Toggle("Silent Aim",false)
aimTab:Toggle("Silent Kill",true)
aimTab:Label2("Silent Kill: shot anywhere hits an enemy inside the red circle",F_MONO,10,C.dim)
aimTab:Choice("Silent Targets",{"Auto","Everyone","Murderer"},"Auto")
aimTab:Choice("Silent Part",AIM_NAMES,"Head")
aimTab:Slider("Silent FOV",20,600,150)
aimTab:Slider("Silent Hit Chance",1,100,100)
aimTab:Toggle("Silent Wall Check",true)
aimTab:Toggle("Silent Show FOV",true)
aimTab:Label2("Tip: tap a dot on the preview to pick body part",F_MONO,10,C.dim)
aimTab:Label("Auto Win")
aimTab:Toggle("Auto Win",false,function(s) if s then startAutoWin() else stopAutoWin() end end)
aimTab:Toggle("Auto Teleport",true,function(s) AutoWin.Teleport=s end)
aimTab:Toggle("Auto Equip Weapon",true,function(s) AutoWin.AutoEquip=s end)
aimTab:Slider("Auto Win Delay (ms)",50,600,200,function(v) AutoWin.Delay=(tonumber(v) or 200)/1000 end)
aimTab:Button("Show AutoWin Status",function() notify("AutoWin: "..AutoWin.Status) end)

local moveTab=createTab("Move")
moveTab:Label("Fly")
moveTab:Toggle("Fly",false,function(state)
    Move.Fly=state
    if state then enableFlyMove() else disableFlyMove() end
    local show=state and UIS.TouchEnabled
    flyUpBtn.Visible=show; flyDownBtn.Visible=show
    notify(state and "Fly ON" or "Fly OFF")
end)
moveTab:Slider("Fly Speed",10,300,60,function(v) Move.Speed=v end)
moveTab:Label2("PC: WASD + Space/E up, Shift/Q down",F_MONO,10,C.dim)
moveTab:Label2("Mobile: joystick + camera tilt, UP/DN buttons",F_MONO,10,C.dim)
moveTab:Label("Noclip")
moveTab:Toggle("Noclip",false,function(state)
    Move.Noclip=state
    setNoclipMove(state)
    notify(state and "Noclip ON" or "Noclip OFF")
end)
moveTab:Label("Teleport")
moveTab:Button("Teleport to Gun",teleportToGun)
moveTab:Label("Walkspeed & Spin")
moveTab:Slider("WalkSpeed",16,1000,16,function(v) applyWalkSpeed(v) end)
moveTab:Button("Reset WalkSpeed (16)",function() applyWalkSpeed(16); local s=Setters["Move/WalkSpeed"]; if s then s(16) end end)
moveTab:Toggle("Spin",false,function(s) if s then startSpin() else stopSpin() end end)
moveTab:Slider("Spin Speed",0,1000,0,function(v) Move2.SpinSpeed=v end)
moveTab:Button("Reset Spin (0)",function() Move2.SpinSpeed=0; local s=Setters["Move/Spin Speed"]; if s then s(0) end end)
moveTab:Label("Bunnyhop")
moveTab:Toggle("Bunnyhop",false,function(s) BHop.Enabled=s; notify(s and "Bhop ON" or "Bhop OFF") end)
moveTab:Slider("Bhop Accel",0,300,40,function(v) BHop.Accel=v end)
moveTab:Slider("Bhop Boost/hop",0,30,4,function(v) BHop.Boost=v end)
moveTab:Slider("Bhop Max Speed",20,400,120,function(v) BHop.Max=v end)
moveTab:Label2("Hold Space (or jump button) + move",F_MONO,10,C.dim)

local farmTab=createTab("Farm")
farmTab:Label("Coin auto-farm")
farmTab:Toggle("Enable Farm",false,function(state)
    Farm.Enabled=state
    if state then
        startFarm()
        if Farm.Mode=="Fly" or Farm.Mode=="Noclip" then setNoclip(true) end
        notify("Farm ON ("..Farm.Mode..")")
    else stopFarm(); notify("Farm OFF") end
end)
farmTab:Choice("Mode",{"Teleport","Fly","Noclip"},"Teleport",function(v)
    Farm.Mode=v
    if Farm.Enabled then
        disableFly()
        setNoclip(v=="Fly" or v=="Noclip")
    end
end)
farmTab:Slider("Speed (safe)",5,400,80,function(v) Farm.Speed=v end)
farmTab:Slider("Teleport Delay (ms)",0,500,150,function(v) Farm.TeleportDelay=(tonumber(v) or 0)/1000 end)
farmTab:Toggle("Anti-AFK",false,function(state) Farm.AntiAFK=state; setAntiAFK(state) end)
farmTab:Toggle("Return to Start",false,function(state) Farm.ReturnOnFinish=state end)
farmTab:Button("Reset Counter",function() Farm.Collected=0; notify("Counter reset") end)
farmTab:Button("Show Status",function() notify("Collected: "..Farm.Collected.." | "..Farm.Status) end)

-- MISC: teleport to roles, fling (player list), auto map select
do
local miscTab=createTab("Misc")

local function charOf(plr)
    local c=plr and plr.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if c and h and r and h.Health>0 then return c,h,r end
    return nil
end

-- scrollable pick-list widget
local function picker(h,onPick)
    local lf=miscTab:Frame(h)
    local sf=Instance.new("ScrollingFrame"); sf.Size=UDim2.new(1,0,1,0); sf.BackgroundColor3=C.row; sf.BackgroundTransparency=0.45; sf.BorderSizePixel=0
    sf.ScrollBarThickness=3; sf.AutomaticCanvasSize=Enum.AutomaticSize.Y; sf.CanvasSize=UDim2.new(0,0,0,0); sf.Parent=lf; corner(sf,8); T(sf,"ScrollBarImageColor3")
    local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,2); ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Parent=sf
    local pd=Instance.new("UIPadding"); pd.PaddingTop=UDim.new(0,4); pd.PaddingLeft=UDim.new(0,4); pd.PaddingRight=UDim.new(0,6); pd.PaddingBottom=UDim.new(0,4); pd.Parent=sf
    local obj={sel=nil,btns={},sig=""}
    function obj.paint()
        for n,b in pairs(obj.btns) do
            local on=(n==obj.sel)
            b.BackgroundColor3=on and ACC or C.bg
            b.BackgroundTransparency=on and 0.55 or 0.45
            b.TextColor3=on and C.text or C.dim
        end
    end
    function obj.set(items)
        for _,b in pairs(obj.btns) do b:Destroy() end
        obj.btns={}
        for i,it in ipairs(items) do
            local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,26); b.BorderSizePixel=0; b.AutoButtonColor=false; b.Font=F_BODY; b.TextSize=14
            b.TextXAlignment=Enum.TextXAlignment.Left; b.Text="  "..it.label; b.LayoutOrder=i; b.Parent=sf; corner(b,6)
            b.MouseButton1Click:Connect(function() obj.sel=it.name; obj.paint(); if onPick then onPick(it.name) end end)
            obj.btns[it.name]=b
        end
        obj.paint()
    end
    return obj
end

-- ===== TELEPORT =====
local function tpToRole(role)
    local _,_,me=charOf(LP)
    if not me then notify("No character") return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and getRoleCached(plr)==role then
            local _,_,r=charOf(plr)
            if r then
                me.CFrame=r.CFrame*CFrame.new(0,0,3); me.AssemblyLinearVelocity=Vector3.zero
                notify("Teleported to "..role.." ("..plr.Name..")"); return
            end
        end
    end
    notify(role.." not found")
end
miscTab:Label("Teleport")
miscTab:Button("Teleport to Murderer",function() tpToRole("Murderer") end)
miscTab:Button("Teleport to Sheriff",function() tpToRole("Sheriff") end)

-- ===== FLING =====
local flingSel=nil
local flingPick=picker(150,function(name) flingSel=Players:FindFirstChild(name) end)
local function refreshPlayers(force)
    local items,sig={},{}
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            local role=getRoleCached(p)
            items[#items+1]={name=p.Name,label=p.Name.."  ["..role.."]"}
            sig[#sig+1]=p.Name..role
        end
    end
    local s=table.concat(sig,"|")
    if force or s~=flingPick.sig then flingPick.sig=s; flingPick.set(items) end
    if flingSel and not flingSel.Parent then flingSel=nil; flingPick.sel=nil end
end
local flinging=false
local function flingTarget(plr)
    if flinging then notify("Fling already running") return end
    local _,_,tr=charOf(plr); local mc,mh,me=charOf(LP)
    if not tr or not me then notify("Fling: target or you are not alive") return end
    flinging=true
    local origin=me.CFrame
    local startPos=tr.Position
    notify("Flinging "..plr.Name)
    local bav=Instance.new("BodyAngularVelocity"); bav.MaxTorque=Vector3.new(9e9,9e9,9e9); bav.P=9e9; bav.AngularVelocity=Vector3.new(0,9e5,0); bav.Parent=me
    local t0=os.clock()
    local hb,rs
    local function finish()
        if hb then hb:Disconnect() end
        if rs then rs:Disconnect() end
        pcall(function() bav:Destroy() end)
        local _,_,m2=charOf(LP)
        if m2 then m2.AssemblyLinearVelocity=Vector3.zero; m2.AssemblyAngularVelocity=Vector3.zero; m2.CFrame=origin end
        flinging=false
        notify("Fling done")
    end
    hb=RunService.Heartbeat:Connect(function()
        local _,_,t2=charOf(plr); local _,_,m2=charOf(LP)
        if not t2 or not m2 or os.clock()-t0>3.5 or (t2.Position-startPos).Magnitude>600 then finish() return end
        m2.CFrame=t2.CFrame
        m2.AssemblyLinearVelocity=Vector3.new(9e4,9e4,9e4)
    end)
    rs=RunService.RenderStepped:Connect(function()
        local _,_,m2=charOf(LP)
        if m2 then m2.AssemblyLinearVelocity=Vector3.zero end
    end)
end
miscTab:Label("Fling")
miscTab:Label2("Pick a player in the list, then press Fling",F_MONO,10,C.dim)
miscTab:Button("Refresh Players",function() refreshPlayers(true) end)
miscTab:Button("Fling Selected",function()
    if flingSel and flingSel.Parent then flingTarget(flingSel) else notify("Select a player first") end
end)
refreshPlayers(true)
task.spawn(function() while gui.Parent do task.wait(2); pcall(refreshPlayers,false) end end)

-- ===== AUTO MAP SELECT =====
local AutoMap={Enabled=false,Map=nil,Rounds=10,Done=0,Status="idle",Thread=nil}
local MAPS={"Hotel","Mansion","House","Factory","Workshop","Lab","Bio Lab","Office","Milk Factory","Research Facility","Bank","Barn","Hospital","Mineshaft","Police Station","Yacht","Space Port","Ice Castle","Cottage","Wild West","Log Cabin","Pizzeria","Nebula"}
local mapPick=picker(150,function(name) AutoMap.Map=name; notify("Map selected: "..name) end)
local function refreshMaps()
    local seen,items={},{}
    local function add(n) if n and n~="" and not seen[n] then seen[n]=true; items[#items+1]={name=n,label=n} end end
    if AutoMap.Map then add(AutoMap.Map) end
    -- maps currently loaded in workspace (big models that are not characters)
    for _,o in ipairs(workspace:GetChildren()) do
        if (o:IsA("Model") or o:IsA("Folder")) and not Players:GetPlayerFromCharacter(o) and o.Name~="Camera" then
            local n=0
            for _,d in ipairs(o:GetDescendants()) do if d:IsA("BasePart") then n+=1; if n>40 then break end end end
            if n>40 then add(o.Name) end
        end
    end
    for _,n in ipairs(MAPS) do add(n) end
    mapPick.sel=AutoMap.Map
    mapPick.set(items)
end
local function findMap(name)
    local function scan(parent,depth)
        for _,o in ipairs(parent:GetChildren()) do
            if (o:IsA("Model") or o:IsA("Folder")) and o.Name==name then return o end
        end
        if depth>0 then
            for _,o in ipairs(parent:GetChildren()) do
                if (o:IsA("Model") or o:IsA("Folder")) and not Players:GetPlayerFromCharacter(o) then
                    local r=scan(o,depth-1); if r then return r end
                end
            end
        end
        return nil
    end
    return scan(workspace,2)
end
local function mapSpawnCF(m)
    for _,d in ipairs(m:GetDescendants()) do
        if d:IsA("BasePart") and string.find(string.lower(d.Name),"spawn") then return d.CFrame+Vector3.new(0,4,0) end
    end
    if m:IsA("Model") then
        local ok,cf,size=pcall(function() local a,b=m:GetBoundingBox(); return a,b end)
        if ok and cf then return CFrame.new(cf.Position+Vector3.new(0,size.Y/2+6,0)) end
    end
    for _,d in ipairs(m:GetDescendants()) do
        if d:IsA("BasePart") then return d.CFrame+Vector3.new(0,6,0) end
    end
    return nil
end
local function autoMapLoop()
    while AutoMap.Enabled and gui.Parent and AutoMap.Done<AutoMap.Rounds do
        if not AutoMap.Map then
            AutoMap.Status="pick a map first"; task.wait(1)
        else
            AutoMap.Status="waiting for map: "..AutoMap.Map
            local m
            repeat
                m=findMap(AutoMap.Map)
                if not m then task.wait(0.5) end
            until m or not AutoMap.Enabled or not gui.Parent
            if not AutoMap.Enabled then break end
            task.wait(0.5)
            local _,_,me=charOf(LP)
            if not me then
                AutoMap.Status="waiting for character"; task.wait(1)
            else
                local cf=mapSpawnCF(m)
                if cf then me.CFrame=cf; me.AssemblyLinearVelocity=Vector3.zero end
                AutoMap.Status="in "..AutoMap.Map.." (round "..(AutoMap.Done+1).."/"..AutoMap.Rounds..")"
                local t0=os.clock()
                repeat task.wait(0.5) until not AutoMap.Enabled or not m.Parent or os.clock()-t0>420
                if AutoMap.Enabled then
                    AutoMap.Done+=1
                    AutoMap.Status="round "..AutoMap.Done.." done, respawning"
                    local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if h then h.Health=0 end
                    task.wait(3)
                end
            end
        end
    end
    local finished=AutoMap.Done>=AutoMap.Rounds
    AutoMap.Status=finished and "finished all rounds" or "idle"
    AutoMap.Thread=nil
    if AutoMap.Enabled then AutoMap.Enabled=false; if Setters["Misc/Auto Map"] then Setters["Misc/Auto Map"](false) end end
    if finished then notify("Auto Map: "..AutoMap.Done.." rounds done") end
end
miscTab:Label("Auto Map Select")
miscTab:Label2("Pick a map, press Auto Map: it teleports there every round and respawns",F_MONO,10,C.dim)
refreshMaps()
miscTab:Toggle("Auto Map",false,function(s)
    AutoMap.Enabled=s
    if s then
        if not AutoMap.Thread then AutoMap.Done=0; AutoMap.Thread=task.spawn(autoMapLoop) end
        notify("Auto Map ON")
    else notify("Auto Map OFF") end
end)
miscTab:Slider("Rounds",1,50,10,function(v) AutoMap.Rounds=v end)
miscTab:Input("Custom map name","",function(txt)
    txt=tostring(txt or ""):gsub("^%s+",""):gsub("%s+$","")
    if txt~="" then AutoMap.Map=txt; refreshMaps(); notify("Map selected: "..txt) end
end)
miscTab:Button("Scan Maps",function() refreshMaps(); notify("Maps refreshed") end)
miscTab:Button("Reset Round Counter",function() AutoMap.Done=0; notify("Rounds reset") end)
miscTab:Button("Show Status",function() notify("AutoMap: "..AutoMap.Status.." | "..AutoMap.Done.."/"..AutoMap.Rounds) end)
end

local fpsTab=createTab("FPS")
fpsTab:Label("Unlocker")
fpsTab:Toggle("Enable Unlock",false,function(state) FPS.Enabled=state; if state then enableFps() else disableFps() end end)
fpsTab:Slider("Target FPS",60,10000,10000,function(v) FPS.Target=v; if FPS.Enabled then applyFpsCap(v) end end)
fpsTab:Button("60 FPS",function() Setters["FPS/Target FPS"](60) end)
fpsTab:Button("120 FPS",function() Setters["FPS/Target FPS"](120) end)
fpsTab:Button("240 FPS",function() Setters["FPS/Target FPS"](240) end)
fpsTab:Button("1000 FPS",function() Setters["FPS/Target FPS"](1000) end)
fpsTab:Label("Custom FPS")
fpsTab:Input("Custom FPS","240",function(txt,tb)
    local n=tonumber(txt)
    if not n or n<1 then notify("Invalid FPS value"); tb.Text=tostring(FPS.Target); return end
    n=math.floor(math.clamp(n,1,100000))
    FPS.Target=n
    if not FPS.Enabled then
        Setters["FPS/Enable Unlock"](true)
    else
        applyFpsCap(n); notify("FPS cap set to "..n)
    end
    pcall(function() Setters["FPS/Target FPS"](math.clamp(n,60,10000)); FPS.Target=n; if FPS.Enabled then applyFpsCap(n) end end)
    tb.Text=tostring(n)
end)
fpsTab:Label("Counter")
fpsTab:Toggle("Show Counter",true,function(state) fpsFrame.Visible=state end)
fpsTab:Button("Reset Stats",function() FpsCounter.Max=0; FpsCounter.Avg=0; notify("FPS stats reset") end)
fpsTab:Label("Optimization")
fpsTab:Toggle("Remove Shadows",false,function(state) Lighting.GlobalShadows=not state end)
fpsTab:Toggle("Remove Fog",false,function(state) Lighting.FogEnd=state and 1e6 or 100000 end)
fpsTab:Toggle("Remove Effects",false,function(state)
    for _,e in ipairs(Lighting:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=not state end
    end
end)

local shTab=createTab("Shaders")
shTab:Label("Look")
shTab:Choice("Preset",PRESET_NAMES,"Off",function() refreshShader(0.9) end)
shTab:Slider("Brightness",-50,50,0,function() refreshShader(0.15) end)
shTab:Slider("Contrast",-50,50,0,function() refreshShader(0.15) end)
shTab:Slider("Saturation",-100,100,0,function() refreshShader(0.15) end)
shTab:Slider("Bloom",0,100,0,function() refreshShader(0.15) end)
shTab:Button("Reset Shaders",function()
    Setters["Shaders/Preset"]("Off"); Setters["Shaders/Brightness"](0); Setters["Shaders/Contrast"](0); Setters["Shaders/Saturation"](0); Setters["Shaders/Bloom"](0)
end)

local profileTab=createTab("Profile")
profileTab:Label("Player")
do
local avF=profileTab:Frame(112)
local av=Instance.new("ImageLabel"); av.Size=UDim2.new(0,100,0,100); av.Position=UDim2.new(0,8,0,6); av.BackgroundColor3=C.row; av.BorderSizePixel=0; av.Image=""; av.ScaleType=Enum.ScaleType.Crop; av.Parent=avF; corner(av,10)
local avs=stroke(av,ACC,2,0); T(avs,"Color")
local avName=Instance.new("TextLabel"); avName.BackgroundTransparency=1; avName.Position=UDim2.new(0,118,0,14); avName.Size=UDim2.new(1,-124,0,24); avName.Font=F_HEAD; avName.TextSize=17; avName.TextXAlignment=Enum.TextXAlignment.Left; avName.TextColor3=C.text; avName.Text=LP.DisplayName; avName.TextTruncate=Enum.TextTruncate.AtEnd; avName.Parent=avF
local avUser=Instance.new("TextLabel"); avUser.BackgroundTransparency=1; avUser.Position=UDim2.new(0,118,0,42); avUser.Size=UDim2.new(1,-124,0,18); avUser.Font=F_MONO; avUser.TextSize=12; avUser.TextXAlignment=Enum.TextXAlignment.Left; avUser.TextColor3=C.dim; avUser.Text="@"..LP.Name; avUser.Parent=avF
local avId=Instance.new("TextLabel"); avId.BackgroundTransparency=1; avId.Position=UDim2.new(0,118,0,62); avId.Size=UDim2.new(1,-124,0,18); avId.Font=F_MONO; avId.TextSize=11; avId.TextXAlignment=Enum.TextXAlignment.Left; avId.TextColor3=C.dim; avId.Text="ID "..LP.UserId; avId.Parent=avF
local function loadAvatar(uid)
    task.spawn(function()
        local ok,img=pcall(function() return Players:GetUserThumbnailAsync(uid,Enum.ThumbnailType.AvatarBust,Enum.ThumbnailSize.Size150x150) end)
        if ok and img then av.Image=img end
    end)
end
loadAvatar(LP.UserId)
profileTab:Input("Show avatar of user",LP.Name,function(txt)
    local ok,uid=pcall(function() return Players:GetUserIdFromNameAsync(txt) end)
    if ok and uid then loadAvatar(uid); avName.Text=txt; avUser.Text="@"..txt; avId.Text="ID "..uid else notify("User not found") end
end)
end
local profUser=profileTab:Label2("USER      "..LP.Name,F_MONO,13,C.text)
local profRole=profileTab:Label2("ROLE      Innocent",F_MONO,13,C.text)
local profSession=profileTab:Label2("SESSION   00:00:00",F_MONO,12,C.dim)
local profCoins=profileTab:Label2("COINS     0",F_MONO,12,C.dim)
local profFps=profileTab:Label2("FPS       0 | avg 0 | max 0",F_MONO,12,C.dim)
local profStatus=profileTab:Label2("STATUS    idle",F_MONO,12,C.dim)
profileTab:Label("Actions")
profileTab:Button("Refresh Profile",function()
    profUser.Text="USER      "..LP.Name
    profRole.Text="ROLE      "..getRole(LP)
    profCoins.Text="COINS     "..Farm.Collected
    notify("Profile refreshed")
end)
profileTab:Button("Reset All Stats",function()
    FpsCounter.Max=0; FpsCounter.Avg=0; Farm.Collected=0
    notify("All stats reset")
end)

-- SETTINGS
local setTab=createTab("Settings")
local SLOTS={"1","2","3","4","5"}
local function cfgPath(s) return FOLDER.."/config_"..s..".json" end
local function isSettingsKey(k) return k:sub(1,9)=="Settings/" end
local function saveConfig(slot)
    if not hasFS then notify("File system not available") return end
    ensureFolder(); local data={}
    for k,v in pairs(Flags) do if not isSettingsKey(k) then data[k]=v end end
    local ok=pcall(function() writefile(cfgPath(slot),HttpService:JSONEncode(data)) end)
    notify(ok and ("Config saved: slot "..slot) or "Save error")
end
local function loadConfig(slot,silent)
    if not hasFS then if not silent then notify("File system not available") end return end
    local path=cfgPath(slot)
    if not isfile(path) then if not silent then notify("Slot "..slot.." empty") end return end
    local ok,data=pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not ok or type(data)~="table" then notify("Read error") return end
    for k,v in pairs(data) do if Setters[k] and not isSettingsKey(k) then Setters[k](v) end end
    notify("Config loaded: slot "..slot)
end
local function resetAll()
    for k,d in pairs(Defaults) do if not isSettingsKey(k) and Setters[k] then Setters[k](d) end end
    notify("Settings reset")
end
local function unload()
    for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    destroyCos("wings"); destroyCos("hat"); destroyCos("trail")
    for _,p in ipairs(Players:GetPlayers()) do local c=p.Character; local hh=c and c:FindFirstChild("luxxsCham"); if hh then pcall(function() hh:Destroy() end) end end
    for plr in pairs(espData) do removeESP(plr) end
    for p in pairs(GunESP.vis) do dropGunVisual(p) end
    pcall(function() GunFolder:Destroy() end)
    pcall(disableFlyMove); pcall(setNoclipMove,false)
    pcall(stopAutoWin); pcall(stopSpin)
    BHop.Enabled=false
    stopFarm(); disableShader(true); disableFps(); gui:Destroy(); fpsGui:Destroy()
end

setTab:Label("Interface")
setTab:Choice("Accent",ACCENT_NAMES,ACC_NAME,function(n)
    setAccent(ACCENTS[n]); restyleTabs()
    if hasFS then ensureFolder(); pcall(function() writefile(FOLDER.."/accent.txt",n) end) end
end)
setTab:Label("Appearance")
setTab:Slider("Menu Opacity %",20,100,100,function(v)
    MenuAlpha=math.clamp(v/100,0,1)
    if isOpen then main.GroupTransparency=1-MenuAlpha end
end)
setTab:Slider("Menu Scale %",70,130,100,function(v)
    MenuScale=math.clamp((tonumber(v) or 100)/100,0.5,2)
    if isOpen then scale.Scale=fitScale()*MenuScale end
end)
setTab:Label("Configs")
setTab:Choice("Config Slot",SLOTS,"1")
setTab:Button("Save Config",function() saveConfig(Flags["Settings/Config Slot"]) end)
setTab:Button("Load Config",function() loadConfig(Flags["Settings/Config Slot"]) end)
setTab:Toggle("Autoload",false,function(s)
    if not hasFS then return end
    ensureFolder(); pcall(function() writefile(FOLDER.."/autoload.txt",s and Flags["Settings/Config Slot"] or "") end)
    notify(s and "Autoload ON" or "Autoload OFF")
end)
setTab:Button("Reset All",resetAll)
setTab:Label("Menu")
setTab:Button("Close Menu",closeMenu)
setTab:Button("Unload luxxs",unload)

-- PREVIEW
local function solid(p,x,y,w,h,color,z,r)
    local f=Instance.new("Frame"); f.Position=UDim2.new(0,x,0,y); f.Size=UDim2.new(0,w,0,h); f.BackgroundColor3=color; f.BorderSizePixel=0; f.ZIndex=z or 1; f.Parent=p
    if r and r>0 then corner(f,r) end
    return f
end
local function line(p,x1,y1,x2,y2,thick,color,z)
    local dx,dy=x2-x1,y2-y1
    local f=Instance.new("Frame"); f.AnchorPoint=Vector2.new(0.5,0.5); f.Position=UDim2.new(0,(x1+x2)/2,0,(y1+y2)/2); f.Size=UDim2.new(0,math.sqrt(dx*dx+dy*dy),0,thick); f.Rotation=math.deg(math.atan2(dy,dx)); f.BackgroundColor3=color; f.BorderSizePixel=0; f.ZIndex=z or 1; f.Parent=p
    return f
end

local function buildPreview(panel)
    local PW,PH=252,372
    panel.BackgroundColor3=WHITE; panel.ClipsDescendants=true; corner(panel,14)
    gradient(panel,90,ColorSequence.new(Color3.fromRGB(34,24,50),Color3.fromRGB(8,8,12)))
    T(stroke(panel,ACC,1.5,0.4),"Color")

    for i,y in ipairs({308,318,331,348,370}) do
        local f=solid(panel,0,y,PW,1,WHITE,1); f.BackgroundTransparency=0.9-i*0.02; T(f,"BackgroundColor3")
    end
    for i=-5,5 do
        local l=line(panel,126+i*6,300,126+i*44,372,1,WHITE,1); l.BackgroundTransparency=0.9; T(l,"BackgroundColor3")
    end

    local scanBand=solid(panel,0,0,PW,38,WHITE,2); T(scanBand,"BackgroundColor3")
    gradient(scanBand,90,nil,NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.8)}))
    local scanLine=solid(panel,0,0,PW,1,WHITE,2); scanLine.BackgroundTransparency=0.3; T(scanLine,"BackgroundColor3")

    local beam=solid(panel,0,0,170,300,WHITE,1); beam.AnchorPoint=Vector2.new(0.5,0); beam.Position=UDim2.new(0.5,0,0,24); beam.BackgroundTransparency=0; T(beam,"BackgroundColor3")
    gradient(beam,90,nil,NumberSequence.new({NumberSequenceKeypoint.new(0,0.9),NumberSequenceKeypoint.new(1,1)}))
    local orbit=solid(panel,0,0,210,210,WHITE,1,9999); orbit.AnchorPoint=Vector2.new(0.5,0.5); orbit.Position=UDim2.new(0.5,0,0,205); orbit.BackgroundTransparency=1
    local orbitS=stroke(orbit,ACC,2,0); T(orbitS,"Color")
    local og=Instance.new("UIGradient"); og.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.3,0.9),NumberSequenceKeypoint.new(1,1)}); og.Parent=orbitS

    local dot=solid(panel,12,10,5,5,WHITE,9); T(dot,"BackgroundColor3")
    local cap=Instance.new("TextLabel"); cap.BackgroundTransparency=1; cap.Position=UDim2.new(0,24,0,3); cap.Size=UDim2.new(0,80,0,18); cap.Font=F_MONO; cap.TextSize=10; cap.TextColor3=C.dim; cap.TextXAlignment=Enum.TextXAlignment.Left; cap.Text="PREVIEW // LIVE"; cap.ZIndex=9; cap.Parent=panel
    local aimCap=Instance.new("TextLabel"); aimCap.BackgroundTransparency=1; aimCap.AnchorPoint=Vector2.new(1,0); aimCap.Position=UDim2.new(1,-12,0,3); aimCap.Size=UDim2.new(0,130,0,18); aimCap.Font=F_MONO; aimCap.TextSize=10; aimCap.TextXAlignment=Enum.TextXAlignment.Right; aimCap.ZIndex=9; aimCap.Parent=panel; T(aimCap,"TextColor3")
    local hdr=solid(panel,0,23,PW,1,C.line,3)

    local strip=solid(panel,0,PH-26,PW,26,Color3.fromRGB(12,12,15),8); strip.BackgroundTransparency=0.05
    solid(panel,0,PH-26,PW,1,C.line,9)
    local tagsL=Instance.new("TextLabel"); tagsL.BackgroundTransparency=1; tagsL.Position=UDim2.new(0,10,0,PH-26); tagsL.Size=UDim2.new(1,-20,0,26); tagsL.Font=F_MONO; tagsL.TextSize=10; tagsL.TextColor3=C.dim; tagsL.TextXAlignment=Enum.TextXAlignment.Left; tagsL.TextTruncate=Enum.TextTruncate.AtEnd; tagsL.Text="NO MODULES"; tagsL.ZIndex=10; tagsL.Parent=panel

    local glow={}
    for i=1,4 do
        local s=230-i*40
        local c=solid(panel,0,0,s,s,WHITE,1,9999); c.AnchorPoint=Vector2.new(0.5,0.5); c.Position=UDim2.new(0.5,0,0,200); c.BackgroundTransparency=0.95; glow[i]=c
    end

    local shadow=solid(panel,0,0,120,22,Color3.new(0,0,0),1,9999); shadow.AnchorPoint=Vector2.new(0.5,0.5); shadow.Position=UDim2.new(0.5,0,0,310); shadow.BackgroundTransparency=0.35
    local ring1=solid(panel,0,0,110,20,WHITE,1,9999); ring1.AnchorPoint=Vector2.new(0.5,0.5); ring1.Position=UDim2.new(0.5,0,0,310); ring1.BackgroundTransparency=1
    local ring1S=stroke(ring1,ACC,1.5,0.2)
    local ring2=solid(panel,0,0,110,20,WHITE,1,9999); ring2.AnchorPoint=Vector2.new(0.5,0.5); ring2.Position=UDim2.new(0.5,0,0,310); ring2.BackgroundTransparency=1
    local ring2S=stroke(ring2,ACC,1,0.6)

    local particles={}
    math.randomseed(os.time())
    for i=1,14 do
        local f=solid(panel,0,0,2,2,WHITE,2)
        particles[i]={f=f,x=math.random(12,238),y=math.random(40,330),sp=math.random(8,24),ph=math.random()*6}
    end

    local fovRing=solid(panel,0,0,100,100,WHITE,2,9999); fovRing.AnchorPoint=Vector2.new(0.5,0.5); fovRing.Position=UDim2.new(0.5,0,0,207); fovRing.BackgroundTransparency=1; fovRing.Visible=false
    local fovS=stroke(fovRing,ACC,1,0.45)
    local tracer=solid(panel,126,309,1,37,ACC,2); tracer.Visible=false

    local fig=Instance.new("Frame"); fig.AnchorPoint=Vector2.new(0.5,0.5); fig.Position=UDim2.new(0.5,0,0,207); fig.Size=UDim2.new(0,90,0,170); fig.BackgroundTransparency=1; fig.Parent=panel
    local figScale=Instance.new("UIScale"); figScale.Scale=1.2; figScale.Parent=fig
    local body=Instance.new("Frame"); body.Size=UDim2.new(1,0,1,0); body.BackgroundTransparency=1; body.Parent=fig

    local trailF={}
    for k=1,14 do local f=solid(body,0,0,12,10,WHITE,1,4); f.AnchorPoint=Vector2.new(0.5,0.5); f.Visible=false; trailF[k]=f end

    local wingF={}
    local lens={64,60,55,49,43,37}
    for _,side in ipairs({-1,1}) do for i=1,6 do
        local f=solid(body,0,0,lens[i],8,WHITE,1,4); f.AnchorPoint=Vector2.new(0.5,0.5); f.Visible=false
        gradient(f,0,nil,NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,0.65)}))
        wingF[#wingF+1]={f=f,side=side,i=i,len=lens[i]}
    end end

    local overlays={}
    for _,a in ipairs(AIM_PARTS_DATA) do local ov=solid(body,a.x,a.y,a.w,a.h,AIM_RED,4,a.r); ov.BackgroundTransparency=1; overlays[a.name]=ov end

    local bodyParts={}
    local function seg(x,y,w,h,r)
        local f=solid(body,x,y,w,h,BODY_GRAY,3,r)
        gradient(f,90,ColorSequence.new(WHITE,Color3.fromRGB(122,122,136)))
        local s=Instance.new("UIStroke"); s.Thickness=1; s.Color=WHITE; s.Transparency=0.78; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=f
        bodyParts[#bodyParts+1]={f=f,s=s}
        return f
    end
    seg(41,35,8,8,2)
    seg(33,12,24,24,12)
    seg(27,43,36,30,4)
    seg(30,73,30,18,3)
    seg(28,91,34,13,3)
    seg(13,45,12,31,5); seg(12,77,10,28,4); seg(11,105,8,8,4)
    seg(65,45,12,31,5); seg(68,77,10,28,4); seg(71,105,8,8,4)
    seg(26,104,17,35,5); seg(28,140,13,26,4); seg(25,165,18,5,2)
    seg(47,104,17,35,5); seg(49,140,13,26,4); seg(47,165,18,5,2)
    for _,j in ipairs({{27,48},{63,48},{19,77},{71,77},{35,104},{55,104},{34,140},{56,140}}) do seg(j[1]-3,j[2]-3,6,6,3) end
    local visor=solid(body,37,20,16,5,Color3.fromRGB(26,26,32),4,2); visor.BackgroundTransparency=0.15
    local visorGlint=solid(body,39,21,6,1,WHITE,5); T(visorGlint,"BackgroundColor3")
    local emblem=Instance.new("TextLabel"); emblem.BackgroundTransparency=1; emblem.Position=UDim2.new(0,27,0,52); emblem.Size=UDim2.new(0,36,0,14); emblem.Font=F_HEAD; emblem.TextSize=8; emblem.TextTransparency=0.2; emblem.Text="LX"; emblem.ZIndex=4; emblem.Parent=body; T(emblem,"TextColor3")
    local belt=solid(body,28,91,34,2,WHITE,4); belt.BackgroundTransparency=0.4; T(belt,"BackgroundColor3")

    local skel=Instance.new("Frame"); skel.Size=UDim2.new(1,0,1,0); skel.BackgroundTransparency=1; skel.ZIndex=6; skel.Visible=false; skel.Parent=body
    local J={head={45,24},neck={45,40},shL={27,48},shR={63,48},elL={18,78},elR={72,78},haL={15,108},haR={75,108},pel={45,98},hipL={35,104},hipR={55,104},knL={34,140},knR={56,140},ftL={34,166},ftR={56,166}}
    local BPREV={{"head","neck"},{"neck","pel"},{"neck","shL"},{"neck","shR"},{"shL","elL"},{"elL","haL"},{"shR","elR"},{"elR","haR"},{"pel","hipL"},{"pel","hipR"},{"hipL","knL"},{"knL","ftL"},{"hipR","knR"},{"knR","ftR"}}
    local skelParts={}
    for _,b in ipairs(BPREV) do local a,c=J[b[1]],J[b[2]]; skelParts[#skelParts+1]=line(skel,a[1],a[2],c[1],c[2],2,WHITE,6) end
    for _,p in pairs(J) do skelParts[#skelParts+1]=solid(skel,p[1]-2.5,p[2]-2.5,5,5,WHITE,7,3) end

    local hatS={}
    local brim=solid(body,3,11,84,4,WHITE,5,2)
    gradient(brim,0,ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(140,140,140)),ColorSequenceKeypoint.new(0.5,WHITE),ColorSequenceKeypoint.new(1,Color3.fromRGB(130,130,130))}))
    brim.Visible=false; hatS[1]=brim
    for i=1,22 do
        local t=(i-1)/21
        local w=56*(1-t)^1.3+3
        local hf=solid(body,45-w/2,13-i*2,w,2,WHITE,5,1)
        gradient(hf,0,ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(160,160,160)),ColorSequenceKeypoint.new(0.45,WHITE),ColorSequenceKeypoint.new(1,Color3.fromRGB(130,130,130))}))
        hf.Visible=false; hatS[#hatS+1]=hf
    end

    local aimUI={}
    for _,a in ipairs(AIM_PARTS_DATA) do
        local dotb=Instance.new("TextButton"); dotb.AnchorPoint=Vector2.new(0.5,0.5); dotb.Position=UDim2.new(0,a.dx,0,a.dy); dotb.Size=UDim2.new(0,11,0,11); dotb.BackgroundColor3=Color3.fromRGB(230,230,240); dotb.BackgroundTransparency=0.4; dotb.BorderSizePixel=0; dotb.Text=""; dotb.AutoButtonColor=false; dotb.ZIndex=12; dotb.Parent=body; corner(dotb,6)
        local ds=stroke(dotb,WHITE,1,0.5)
        local ui={a=a,dot=dotb,ds=ds,hover=false}
        dotb.MouseEnter:Connect(function() ui.hover=true end)
        dotb.MouseLeave:Connect(function() ui.hover=false end)
        dotb.MouseButton1Click:Connect(function() Setters["Aimbot/Body Part"](a.name) end)
        aimUI[#aimUI+1]=ui
    end
    local aimDot=solid(body,45,24,6,6,AIM_RED,13,3); aimDot.AnchorPoint=Vector2.new(0.5,0.5)
    local ret={}
    for i=1,4 do ret[i]=solid(body,0,0,(i<=2) and 6 or 1,(i<=2) and 1 or 6,AIM_RED,13) ; ret[i].AnchorPoint=Vector2.new(0.5,0.5) end

    local boxF=solid(fig,2,6,86,164,WHITE,7); boxF.BackgroundTransparency=1; boxF.Visible=false
    local br={}
    for i=1,8 do br[i]=solid(fig,0,0,2,2,WHITE,8); br[i].Visible=false end
    local function setBrackets(x,y,w,h,col,vis)
        local L=math.min(14,w*0.3,h*0.2)
        local specs={{x,y,L,2},{x,y,2,L},{x+w-L,y,L,2},{x+w-2,y,2,L},{x,y+h-2,L,2},{x,y+h-L,2,L},{x+w-L,y+h-2,L,2},{x+w-2,y+h-L,2,L}}
        for i,s in ipairs(specs) do local f=br[i]; f.Visible=vis; f.Position=UDim2.new(0,s[1],0,s[2]); f.Size=UDim2.new(0,s[3],0,s[4]); f.BackgroundColor3=col end
    end
    local function espLabel(font,size) local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Size=UDim2.new(0,130,0,13); l.Font=font; l.TextSize=size; l.ZIndex=8; l.Visible=false; l.TextStrokeTransparency=0.5; l.TextStrokeColor3=Color3.new(0,0,0); l.Parent=fig; return l end
    local roleL=espLabel(F_SEC,10)
    local nameL=espLabel(F_MONO,9); nameL.Text="PLAYER"
    local distL=espLabel(F_MONO,8); distL.TextColor3=WHITE; distL.Text="[42m]"
    local hpBar=solid(fig,-5,6,3,164,Color3.fromRGB(14,14,16),8); hpBar.Visible=false
    local hpFill=solid(hpBar,0,0,3,100,Color3.fromRGB(70,230,110),9); hpFill.AnchorPoint=Vector2.new(0,1); hpFill.Position=UDim2.new(0,0,1,0); hpFill.Size=UDim2.new(1,0,0.72,0)

    local gunPrev=Instance.new("TextLabel"); gunPrev.BackgroundTransparency=1; gunPrev.Size=UDim2.new(0,90,0,12); gunPrev.Position=UDim2.new(0,-100,0,150); gunPrev.Font=F_MONO; gunPrev.TextSize=9; gunPrev.Text="GUN [18m]"; gunPrev.Visible=false; gunPrev.ZIndex=8; gunPrev.TextStrokeTransparency=0.5; gunPrev.Parent=fig
    local gunBody=solid(fig,-90,164,22,5,WHITE,8,1); gunBody.Visible=false
    local gunGrip=solid(fig,-90,166,5,10,WHITE,8,1); gunGrip.Visible=false

    local boxTop=6
    local aimPosX,aimPosY=45,24
    local tagAcc=0.3
    track(RunService.RenderStepped:Connect(function(dt)
        if not isOpen then return end
        local t=os.clock()
        local role=Flags["Visuals/Role (Preview)"] or "Murderer"
        local rcol=ROLE_COLORS[role] or WHITE
        local ecol=Flags["Visuals/Color by Role"] and rcol or getColor(Flags["Visuals/ESP Color"],t,0)

        local pulse=(math.sin(t*1.4)+1)/2
        for i,c in ipairs(glow) do c.BackgroundColor3=ACC; c.BackgroundTransparency=0.955-i*0.006-pulse*0.01 end
        dot.BackgroundTransparency=pulse*0.7; og.Rotation=(t*80)%360
        local ys=34+((t*0.33)%1)*296
        scanLine.Position=UDim2.new(0,0,0,ys); scanBand.Position=UDim2.new(0,0,0,ys-38)
        local rp=(t*0.55)%1
        ring2.Size=UDim2.new(0,90+rp*100,0,16+rp*26); ring2S.Transparency=0.3+rp*0.7
        for _,p in ipairs(particles) do
            p.y=p.y-p.sp*dt
            if p.y<30 then p.y=338; p.x=math.random(12,238) end
            p.f.Position=UDim2.new(0,p.x+math.sin(t*0.8+p.ph)*6,0,p.y)
            p.f.BackgroundTransparency=1-((p.y-30)/308)*0.55
            p.f.BackgroundColor3=ACC
        end

        body.Position=UDim2.new(0,0,0,math.sin(t*2)*1.5)
        local hatOn=Flags["Visuals/Chinese Hat"]
        boxTop=boxTop+((hatOn and -36 or 6)-boxTop)*0.2
        local bh=170-boxTop
        local boxOn=Flags["Visuals/ESP Box"]
        boxF.Visible=boxOn; boxF.BackgroundColor3=ecol; boxF.BackgroundTransparency=0.95
        boxF.Position=UDim2.new(0,2,0,boxTop); boxF.Size=UDim2.new(0,86,0,bh)
        setBrackets(2,boxTop,86,bh,ecol,boxOn)
        roleL.Visible=Flags["Visuals/Role"]; roleL.Text=string.upper(role); roleL.TextColor3=rcol; roleL.Position=UDim2.new(0,-20,0,boxTop-26)
        nameL.Visible=Flags["Visuals/Name"]; nameL.TextColor3=ecol; nameL.Position=UDim2.new(0,-20,0,boxTop-14)
        distL.Visible=Flags["Visuals/Distance"]; distL.Position=UDim2.new(0,-20,0,170+3)
        hpBar.Visible=Flags["Visuals/Health"]; hpBar.Position=UDim2.new(0,-5,0,boxTop); hpBar.Size=UDim2.new(0,3,0,bh); hpFill.Size=UDim2.new(1,0,0.7+math.sin(t)*0.2,0)
        tracer.Visible=Flags["Visuals/Tracers"]; tracer.BackgroundColor3=ecol
        local skelOn=Flags["Visuals/Skeleton"]; skel.Visible=skelOn
        if skelOn then for _,s in ipairs(skelParts) do s.BackgroundColor3=ecol end end
        local chams,glowOn=Flags["Visuals/Chams"],Flags["Visuals/Glow"]
        for _,p in ipairs(bodyParts) do
            p.f.BackgroundColor3=chams and ecol or BODY_GRAY; p.f.BackgroundTransparency=chams and 0.25 or 0
            p.s.Color=glowOn and ecol or WHITE; p.s.Transparency=glowOn and 0.05 or 0.78; p.s.Thickness=glowOn and 2 or 1
        end
        visor.BackgroundColor3=chams and Color3.fromRGB(20,20,24) or Color3.fromRGB(26,26,32)
        for i,s in ipairs(hatS) do s.Visible=hatOn; if hatOn then s.BackgroundColor3=getColor(Flags["Visuals/Hat Color"],t,i*0.04); s.BackgroundTransparency=(Flags["Visuals/Hat Transparency"] or 35)/100 end end

        local gunOn=Flags["Visuals/Gun ESP"]
        local gcol=getColor(Flags["Visuals/Gun Color"] or "Gold",t,0)
        gunPrev.Visible=gunOn; gunBody.Visible=gunOn; gunGrip.Visible=gunOn
        if gunOn then gunPrev.TextColor3=gcol; gunBody.BackgroundColor3=gcol; gunGrip.BackgroundColor3=gcol end

        local wingsOn=Flags["Visuals/Wings"]
        local flap=math.sin(t*(Flags["Visuals/Wing Speed"] or 3))*0.2
        for _,w in ipairs(wingF) do
            w.f.Visible=wingsOn
            if wingsOn then
                local a=math.rad(8+(w.i-1)*14)+flap*(0.4+w.i*0.12); local dx,dy=w.side*math.cos(a),-math.sin(a); local sx=(w.side==-1) and 28 or 62
                w.f.Position=UDim2.new(0,sx+dx*w.len/2,0,50+dy*w.len/2); w.f.Rotation=math.deg(math.atan2(dy,dx)); w.f.BackgroundColor3=getColor(Flags["Visuals/Wing Color"],t,w.i*0.05)
            end
        end

        local trailOn=Flags["Visuals/Trail"]
        local tlen=math.clamp(Flags["Visuals/Trail Length"] or 10,1,30)
        local count=math.clamp(math.floor(tlen/30*14)+3,3,14)
        local twidth=Flags["Visuals/Trail Width"] or 4
        for k,f in ipairs(trailF) do
            local show=trailOn and k<=count; f.Visible=show
            if show then local fall=k/count; f.Position=UDim2.new(0,16-k*8,0,100+math.sin(t*4+k*0.6)*4*fall); f.Size=UDim2.new(0,12,0,math.max(2,twidth*2.4*(1-fall*0.85))); f.BackgroundTransparency=0.1+fall*0.85; f.BackgroundColor3=getColor(Flags["Visuals/Trail Color"],t,-k*0.04) end
        end

        local aimOn=Flags["Aimbot/Enable"]
        fovRing.Visible=aimOn and Flags["Aimbot/Show FOV"] or false
        if fovRing.Visible then local r=24+((Flags["Aimbot/FOV"] or 120)-10)/350*94; fovRing.Size=UDim2.new(0,r*2,0,r*2); fovS.Color=ACC end
        ring1S.Color=ACC; ring2S.Color=ACC; fovS.Color=ACC

        local sel=Flags["Aimbot/Body Part"]; local ap=(math.sin(t*5)+1)/2
        for pn,ov in pairs(overlays) do ov.BackgroundTransparency=(pn==sel) and (0.6-ap*0.2) or 1 end
        local selPart=nil
        for _,a in ipairs(AIM_PARTS_DATA) do if a.name==sel then selPart=a; break end end
        if selPart then
            local k=math.clamp(dt*12,0,1)
            aimPosX=aimPosX+(selPart.dx-aimPosX)*k; aimPosY=aimPosY+(selPart.dy-aimPosY)*k
        end
        aimDot.Position=UDim2.new(0,aimPosX,0,aimPosY)
        local g=7+ap*4
        ret[1].Position=UDim2.new(0,aimPosX-g-3,0,aimPosY); ret[2].Position=UDim2.new(0,aimPosX+g+3,0,aimPosY)
        ret[3].Position=UDim2.new(0,aimPosX,0,aimPosY-g-3); ret[4].Position=UDim2.new(0,aimPosX,0,aimPosY+g+3)
        for _,u in ipairs(aimUI) do
            if u.a.name==sel then u.dot.BackgroundColor3=AIM_RED; u.dot.BackgroundTransparency=0.2; u.dot.Size=UDim2.new(0,11,0,11); u.ds.Transparency=0.1
            elseif u.hover then u.dot.BackgroundColor3=Color3.fromRGB(255,170,170); u.dot.BackgroundTransparency=0.2; u.dot.Size=UDim2.new(0,13,0,13); u.ds.Transparency=0.2
            else u.dot.BackgroundColor3=Color3.fromRGB(230,230,240); u.dot.BackgroundTransparency=0.45; u.dot.Size=UDim2.new(0,11,0,11); u.ds.Transparency=0.55 end
        end
        aimCap.Text=aimOn and ("AIM / "..string.upper(tostring(sel))) or "AIM OFF"

        tagAcc+=dt
        if tagAcc>=0.25 then
            tagAcc=0
            local tg={}
            local function add(k,n) if Flags[k] then tg[#tg+1]=n end end
            add("Visuals/ESP Box","BOX") add("Visuals/Name","NAME") add("Visuals/Role","ROLE") add("Visuals/Health","HP") add("Visuals/Distance","DIST")
            add("Visuals/Tracers","TRC") add("Visuals/Skeleton","SKEL") add("Visuals/Chams","CHAMS") add("Visuals/Glow","GLOW") add("Visuals/Gun ESP","GUN")
            add("Visuals/Chinese Hat","HAT") add("Visuals/Wings","WINGS") add("Visuals/Trail","TRAIL")
            if aimOn then tg[#tg+1]="AIM"; if Flags["Aimbot/Skip Innocents"] then tg[#tg+1]="NO-INNO" end end
            if Flags["Aimbot/Auto Win"] then tg[#tg+1]="AUTOWIN" end
            if Flags["Move/Bunnyhop"] then tg[#tg+1]="BHOP" end
            tagsL.Text=#tg>0 and table.concat(tg," / ") or "NO MODULES"
        end
    end))
end

buildPreview(previewPanel)
selectTab(visTab)

print("[luxxs] UI built, ready")

-- PROFILE UPDATER
task.spawn(function()
    local startTick=tick()
    while gui.Parent do
        task.wait(1)
        local s=math.floor(tick()-startTick)
        local hh=math.floor(s/3600); local mm=math.floor((s%3600)/60); local ss=s%60
        local role=getRoleCached(LP)
        profSession.Text=string.format("SESSION   %02d:%02d:%02d",hh,mm,ss)
        profRole.Text="ROLE      "..role
        profCoins.Text="COINS     "..Farm.Collected
        profFps.Text="FPS       "..(FPS.Current or 0).." | avg "..math.floor(FpsCounter.Avg).." | max "..FpsCounter.Max
        profStatus.Text="STATUS    "..Farm.Status
        footR.Text="ROLE  "..string.upper(role)
        footR.TextColor3=(role~="Innocent") and (ROLE_COLORS[role] or C.dim) or C.dim
    end
end)

if hasFS then
    pcall(function()
        local p=FOLDER.."/autoload.txt"
        if isfile(p) then
            local slot=readfile(p)
            if slot~="" and table.find(SLOTS,slot) then
                Setters["Settings/Config Slot"](slot); loadConfig(slot,true); Setters["Settings/Autoload"](true)
            end
        end
    end)
end

notify("Key accepted // RightShift or LX icon")
