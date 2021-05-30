{"connections":[{"from":"shape","from_port":0,"to":"pxflib_2","to_port":0},{"from":"shape","from_port":0,"to":"pxflib_2","to_port":1},{"from":"shape","from_port":0,"to":"pxflib_2","to_port":2},{"from":"sdf3d_box","from_port":0,"to":"pxflib_2","to_port":3},{"from":"pxflib_2","from_port":0,"to":"pxflib_3","to_port":1},{"from":"sdf3d_box","from_port":0,"to":"pxflib_3","to_port":0},{"from":"pxflib_3","from_port":0,"to":"sdf3d_rotate_2","to_port":0},{"from":"tex3d_rotate","from_port":0,"to":"pxflib","to_port":1},{"from":"sdf3d_rotate_2","from_port":0,"to":"pxflib","to_port":0},{"from":"pxflib_2","from_port":0,"to":"tex3d_colorize_3","to_port":0},{"from":"tex3d_colorize_3","from_port":0,"to":"tex3d_rotate","to_port":0}],"nodes":[{"name":"shape","node_position":{"x":-584.888916,"y":-37.944443},"parameters":{"edge":0.34,"radius":0.35,"shape":2,"sides":5},"type":"shape"},{"export_paths":{},"minimized":true,"name":"Material","node_position":{"x":728.111084,"y":324.555542},"parameters":{"albedo_color":{"a":1,"b":1,"g":1,"r":1,"type":"Color"},"ao":1,"depth_scale":0.5,"emission_energy":1,"flags_transparent":false,"metallic":1,"normal":1,"roughness":1,"size":11,"sss":0},"seed_value":0,"type":"material"},{"name":"pxflib_2","node_position":{"x":-351.888885,"y":-38.944443},"parameters":{},"shader_model":{"code":"vec3 texx_$name_uv=$texx($uv.yz+0.5);\nvec3 texy_$name_uv=$texy($uv.xz+0.5);\nvec3 texz_$name_uv=$texz($uv.xy+0.5);","global":"","inputs":[{"default":"vec3(1.0,0.0,0.0)","function":true,"label":"TexX","name":"texx","type":"rgb"},{"default":"vec3(0.0,1.0,0.0)","function":true,"label":"TexY","name":"texy","type":"rgb"},{"default":"vec3(0.0,0.0,1.0)","function":true,"label":"TexZ","name":"texz","type":"rgb"},{"default":"length($uv)-0.4","function":true,"label":"SDF3D","name":"sdf","type":"sdf3d"}],"instance":"//tetrahedron normal by PauloFalcao\n//https://www.shadertoy.com/view/XstGDS\nvec3 normal_$name(vec3 p){  \n  const vec3 e=vec3(0.001,-0.001,0.0);\n  float v1=$sdf(p+e.xyy);\n  float v2=$sdf(p+e.yyx);\n  float v3=$sdf(p+e.yxy);\n  float v4=$sdf(p+e.xxx);\n  return normalize(vec3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));\n}","name":"Triplanar to TEX3D by SDF","outputs":[{"tex3d":"abs(normal_$name($uv.xyz))*mat3(vec3(texx_$name_uv.x,texy_$name_uv.x,texz_$name_uv.x),vec3(texx_$name_uv.y,texy_$name_uv.y,texz_$name_uv.y),vec3(texx_$name_uv.z,texy_$name_uv.z,texz_$name_uv.z))","type":"tex3d"}],"parameters":[]},"type":"shader"},{"name":"sdf3d_rotate_2","node_position":{"x":25.111115,"y":-237.944443},"parameters":{"ax":"$time*31.0","ay":"$time*23.0","az":"$time*27.0"},"type":"sdf3d_rotate"},{"name":"pxflib_3","node_position":{"x":-310.888885,"y":-234.944443},"parameters":{"Bound":0,"Correction":23.465,"Distort":0.168},"shader_model":{"code":"vec4 $(name_uv)_d = distortHeighByNormal_$name($uv.xyz);\n$(name_uv)_d.w = $(name_uv)_d.w/(1.0+$Distort*$Correction);","global":"","inputs":[{"default":"length($uv)-0.4","function":true,"label":"SDF3D","name":"sdf","shortdesc":"SDF3D Input","type":"sdf3d"},{"default":"vec3(0)","function":true,"label":"TEX3D Displace","name":"tex3d","shortdesc":"TEX3D Input","type":"tex3d"}],"instance":"//tetrahedron normal by PauloFalcao\n//https://www.shadertoy.com/view/XstGDS\nvec3 normal_$name(vec3 p){  \n  const vec3 e=vec3(0.01,-0.01,0.0);\n  float v1=$sdf(p+e.xyy);\n  float v2=$sdf(p+e.yyx);\n  float v3=$sdf(p+e.yxy);\n  float v4=$sdf(p+e.xxx);\n  return normalize(vec3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));\n}\n\n//By pauloFalcao\nvec4 distortHeighByNormal_$name(vec3 uv){\n    float d=$sdf(uv);\n\tif (d<=abs($Distort*($Bound+1.0))+0.01){\n\t\tvec3 n=normal_$name(uv);\n\t\tvec3 s=$tex3d(vec4(uv-d*n,0.0));\n\t    return vec4(s,$sdf(uv-n*s*$Distort));\n\t} else {\n\t\treturn vec4(vec3(0.0),d);\n\t}\n\n}","longdesc":"Type - SDF3D Operator\nCode - PauloFalcao\n\nDisplace the height of a 3DSDF based on a TEX3D","name":"Displace Height by Normal","outputs":[{"sdf3d":"$(name_uv)_d.w","shortdesc":"SDF3D Output","type":"sdf3d"},{"longdesc":"TEX3D at the original SDF3D surface before the displace","shortdesc":"TEX3D Output","tex3d":"$(name_uv)_d.xyz","type":"tex3d"}],"parameters":[{"control":"None","default":0,"label":"Displace","max":1,"min":0,"name":"Distort","shortdesc":"Displace amount","step":0.001,"type":"float"},{"control":"None","default":0,"label":"Correction","longdesc":"Keep this value as low as possible!\nIncrease this correction value if the resulting SDF is not perfect.\nA higher value will increase ray marching loop iterations and will result in higher render times.","max":50,"min":0,"name":"Correction","step":0.001,"type":"float"},{"control":"None","default":0,"label":"Bound","longdesc":"Keep this value as low as possible!\nOutside of the displacement the SDF is just the original SDF.\nThis value controls that bound.\nIncrease this correction value if the resulting SDF is not perfect on the edges.\nA higher value will increase ray marching loop iterations and will result in higher render times","max":1,"min":0,"name":"Bound","step":0.001,"type":"float"}],"shortdesc":"Displace Height by Normal"},"type":"shader"},{"name":"tex3d_colorize_3","node_position":{"x":-51.888885,"y":-35.944443},"parameters":{"g":{"interpolation":1,"points":[{"a":1,"b":0,"g":0,"pos":0,"r":0},{"a":1,"b":0.391571,"g":0.59367,"pos":0.045455,"r":0.710938}],"type":"Gradient"}},"type":"tex3d_colorize"},{"name":"tex3d_rotate","node_position":{"x":-21.888885,"y":53.055557},"parameters":{"ax":"$time*31.0","ay":"$time*23.0","az":"$time*27.0"},"type":"tex3d_rotate"},{"name":"sdf3d_box","node_position":{"x":-583.888916,"y":-236.944443},"parameters":{"r":0.15,"sx":0.7,"sy":0.7,"sz":0.7},"type":"sdf3d_box"},{"name":"pxflib","node_position":{"x":222.111115,"y":-192.944443},"parameters":{"AmbLight":0.25,"AmbOcclusion":0,"CamD":1.5,"CamX":2.5,"CamY":2,"CamZ":3,"CamZoom":1,"LookAtX":0,"LookAtY":0,"LookAtZ":0,"Pow":64,"Reflection":0.2,"Shadow":1,"Specular":0,"SunX":2.5,"SunY":2.5,"SunZ":1},"shader_model":{"code":"","global":"const float PI=3.14159265359;\n\nvec2 equirectangularMap(vec3 dir) {\n\tvec2 longlat = vec2(atan(dir.y,dir.x),acos(dir.z));\n \treturn longlat/vec2(2.0*PI,PI);\n}\n\n\n//Simple HDRI START\n\n//Hash without Sine Dave_Hoskins\n//https://www.shadertoy.com/view/4djSRW \nfloat Simple360HDR_hash12(vec2 p)\n{\n\tvec3 p3  = fract(vec3(p.xyx) * .1031);\n    p3 += dot(p3, p3.yzx + 33.33);\n    return fract((p3.x + p3.y) * p3.z);\n}\n\nfloat Simple360HDR_noise(vec2 v){\n  vec2 v1=floor(v);\n  vec2 v2=smoothstep(0.0,1.0,fract(v));\n  float n00=Simple360HDR_hash12(v1);\n  float n01=Simple360HDR_hash12(v1+vec2(0,1));\n  float n10=Simple360HDR_hash12(v1+vec2(1,0));\n  float n11=Simple360HDR_hash12(v1+vec2(1,1));\n  return mix(mix(n00,n01,v2.y),mix(n10,n11,v2.y),v2.x);\n}\n\nfloat Simple360HDR_noiseOct(vec2 p){\n  return\n    Simple360HDR_noise(p)*0.5+\n    Simple360HDR_noise(p*2.0+13.0)*0.25+\n    Simple360HDR_noise(p*4.0+23.0)*0.15+\n    Simple360HDR_noise(p*8.0+33.0)*0.10+\n    Simple360HDR_noise(p*16.0+43.0)*0.05;\n}\n\nvec3 Simple360HDR_skyColor(vec3 p){\n\tvec3 s1=vec3(0.2,0.5,1.0);\n\tvec3 s2=vec3(0.1,0.2,0.4)*1.5;\n    vec3 v=(Simple360HDR_noiseOct(p.xz*0.1)-0.5)*vec3(1.0);\n\tfloat d=length(p);\n    return mix(s2+v,s1+v*(12.0/max(d,20.0)),clamp(d*0.1,0.0,1.0));\n}\n\nvec3 Simple360HDR_floorColor(vec3 p){\n    vec3 v=(Simple360HDR_noiseOct(p.xz*0.1)*0.5+0.25)*vec3(0.7,0.5,0.4);\n    return v;\n}\n\nvec3 Simple360HDR_renderHDR360(vec3 rd, vec3 sun){\n    vec3 col;\n\tvec3 p;\n\tvec3 c;\n\tif (rd.y>0.0) {\n        p=rd*(5.0/rd.y);\n        c=Simple360HDR_skyColor(p);\n    } else {\n        p=rd*(-10.0/rd.y);\n        c=Simple360HDR_floorColor(p);\n\t\tc=mix(c,vec3(0.5,0.7,1.0),clamp(1.0-sqrt(-rd.y)*3.0,0.0,1.0));\n\t}\n\tvec3 skycolor=vec3(0.1,0.45,0.68);\n\tfloat d=length(p);\n\t\n\tfloat ds=clamp(dot(sun,rd),0.0,1.0);\n\tvec3 sunc=(ds>0.9997?vec3(2.0):vec3(0.0))+pow(ds,512.0)*4.0+pow(ds,128.0)*vec3(0.5)+pow(ds,4.0)*vec3(0.5);\n    if (rd.y>0.0){\n\t\tc+=vec3(0.3)*pow(1.0-abs(rd.y),3.0)*0.7;\n\t} \n    return c+sunc;\n}\n\nvec3 Simple360HDR_make360hdri(vec2 p, vec3 sun){\n    float xPI=3.14159265359;\n    vec2 thetaphi = ((p * 2.0) - vec2(1.0)) * vec2(xPI,xPI/2.0); \n    vec3 rayDirection = vec3(cos(thetaphi.y) * cos(thetaphi.x), sin(thetaphi.y), cos(thetaphi.y) * sin(thetaphi.x));\n    return Simple360HDR_renderHDR360(rayDirection,sun);\n}\n//Simple HDRI END\n\n","inputs":[{"default":"length($uv)-0.4","function":true,"label":"SDF3D A","name":"sdf_a","shortdesc":"SDF3D A","type":"sdf3d"},{"default":"vec3(1.0,0.1,0.1)","function":true,"label":"TEX3D A","name":"tex3d_a","shortdesc":"TEX3D A","type":"tex3d"},{"default":"max($uv.y+1.0,length(vec3($uv.x,$uv.y+1.0,$uv.z))-10.0)","function":true,"label":"SDF3D B","name":"sdf_b","shortdesc":"SDF3D B","type":"sdf3d"},{"default":"vec3(mod(floor($uv.x*2.0)+floor($uv.z*2.0),2.0))*0.9+0.1","function":true,"label":"TEX3D B","name":"tex3d_b","shortdesc":"TEX3D B","type":"tex3d"},{"default":"Simple360HDR_make360hdri(vec2($uv.x,-$uv.y+1.0),normalize(vec3(-$SunX,$SunY,-$SunZ)))","function":true,"label":"360 HDRI Image","longdesc":"By default uses a very simple procedural hdri 360 image\nUse other procedural HDRI images from /PauloFalcao/Image/Generator\nOr download real ones from https://hdrihaven.com/","name":"hdri","shortdesc":"Image 360 HDRI","type":"rgb"}],"instance":"vec2 input_$name(vec3 p) {\n    float sdfa=$sdf_a(p);\n\tfloat sdfb=$sdf_b(p);\n\tif (sdfa<sdfb) {\n\t  return vec2(sdfa,0.0);\n\t} else {\n\t  return vec2(sdfb,1.0);\n\t}\n}\n\n//tetrahedron normal by PauloFalcao\n//https://www.shadertoy.com/view/XstGDS\nvec3 normal_$name(vec3 p){  \n  const vec3 e=vec3(0.001,-0.001,0.0);\n  float v1=input_$name(p+e.xyy).x;\n  float v2=input_$name(p+e.yyx).x;\n  float v3=input_$name(p+e.yxy).x;\n  float v4=input_$name(p+e.xxx).x;\n  return normalize(vec3(v4+v1-v3-v2,v3+v4-v1-v2,v2+v4-v3-v1));\n}\n\nvoid march_$name(inout float d,inout vec3 p,inout vec2 dS, vec3 ro, vec3 rd){\n    for (int i=0; i < 500; i++) {\n    \tp = ro + rd*d;\n        dS = input_$name(p);\n        d += dS.x;\n        if (d > 50.0 || abs(dS.x) < 0.0001) break;\n    }\n}\n\n//from https://www.shadertoy.com/view/lsKcDD\nfloat calcAO_$name( in vec3 pos, in vec3 nor ){\n\tfloat occ = 0.0;\n    float sca = 1.0;\n    for( int i=0; i<5; i++ ){\n        float h = 0.001 + 0.25*float(i)/4.0;\n        float d = input_$name( pos + h*nor ).x;\n        occ += (h-d)*sca;\n        sca *= 0.98;\n    }\n    return clamp( 1.0 - 1.6*occ, 0.0, 1.0 );    \n}\n\n//from https://www.shadertoy.com/view/lsKcDD\nfloat calcSoftshadow_$name( in vec3 ro, in vec3 rd, in float mint, in float tmax){\n\tfloat res = 1.0;\n    float t = mint;\n    float ph = 1e10; // big, such that y = 0 on the first iteration\n    for( int i=0; i<32; i++ ){\n\t\tfloat h = input_$name( ro + rd*t ).x;\n        res = min( res, 10.0*h/t );\n        t += h;\n        if( res<0.0001 || t>tmax ) break;  \n    }\n    return clamp( res, 0.0, 1.0 );\n}\n\nvec3 raymarch_$name(vec2 uv) {\n    uv-=0.5;\n\tvec3 cam=vec3($CamX,$CamY,$CamZ)*$CamZoom;\n\tvec3 lookat=vec3($LookAtX,$LookAtY,$LookAtZ);\n\tvec3 ray=normalize(lookat-cam);\n\tvec3 cX=normalize(cross(vec3(0.0,1.0,0.0),ray));\n\tvec3 cY=normalize(cross(cX,ray));\n\tvec3 rd = normalize(ray*$CamD+cX*uv.x+cY*uv.y);\n\tvec3 ro = cam;\n\t\n\tfloat d=0.;\n\tvec3 p=vec3(0);\n\tvec2 dS=vec2(0);\n\tmarch_$name(d,p,dS,ro,rd);\n\t\n    vec3 color=vec3(0.0);\n\tvec3 objColor=(dS.y<0.5)?$tex3d_a(vec4(p,1.0)):$tex3d_b(vec4(p,1.0));\n\tvec3 light=normalize(vec3($SunX,$SunY,$SunZ));\n\tif (d<50.0) {\n\t    vec3 n=normal_$name(p);\n\t\tfloat l=clamp(dot(-light,-n),0.0,1.0);\n\t\tvec3 ref=normalize(reflect(rd,-n));\n\t\tfloat r=clamp(dot(ref,light),0.0,1.0);\n\t\tfloat cAO=mix(1.0,calcAO_$name(p,n),$AmbOcclusion);\n\t\tfloat shadow=mix(1.0,calcSoftshadow_$name(p,light,0.05,5.0),$Shadow);\n\t\tcolor=min(vec3(max(shadow,$AmbLight)),max(l,$AmbLight))*max(cAO,$AmbLight)*objColor+pow(r,$Pow)*$Specular;\n\t\t//reflection\n\t\td=0.01;\n\t\tmarch_$name(d,p,dS,p,ref);\n\t\tvec3 objColorRef=vec3(0);\n\t\tif (d<50.0) {\n\t\t\tobjColorRef=(dS.y<0.5)?$tex3d_a(vec4(p,1.0)):$tex3d_b(vec4(p,1.0));\n\t\t\tn=normal_$name(p);\n\t\t\tl=clamp(dot(-light,-n),0.0,1.0);\n\t\t\tobjColorRef=max(l,$AmbLight)*objColorRef;\n\t\t} else {\n\t\t\tobjColorRef=$hdri(equirectangularMap(ref.xzy)).xyz;\n\t\t}\n\t\tcolor=mix(color,objColorRef,$Reflection);\n\t} else {\n\t\tcolor=$hdri(equirectangularMap(rd.xzy)).xyz;\n\t}\n\treturn color;\n}","longdesc":"Type - SDF3D Render\nCode - PauloFalcao, IQ\n\nRay marching node for 2 objects using a environment 360 HDRI image\nBy default uses a very simple procedural hdri 360 image\nUse other procedural HDRI images from /PauloFalcao/Image/Generator\nOr download real ones from https://hdrihaven.com/\n\n","name":"Ray Marching 360 HDRI Image","outputs":[{"rgb":"raymarch_$name($uv)","shortdesc":"Image output","type":"rgb"}],"parameters":[{"control":"None","default":0,"label":"CamX","longdesc":"Camera position X","max":5,"min":-5,"name":"CamX","step":0.001,"type":"float"},{"control":"None","default":1,"label":"CamY","longdesc":"Camera position Y","max":5,"min":-5,"name":"CamY","step":0.001,"type":"float"},{"control":"None","default":2,"label":"CamZ","longdesc":"Camera position Z","max":5,"min":-5,"name":"CamZ","step":0.001,"type":"float"},{"control":"None","default":0,"label":"LookAtX","longdesc":"Look at position with coordinate X","max":5,"min":-5,"name":"LookAtX","step":0.001,"type":"float"},{"control":"None","default":0,"label":"LookAtY","longdesc":"Look at position with coordinate Y","max":5,"min":-5,"name":"LookAtY","step":0.001,"type":"float"},{"control":"None","default":0,"label":"LookAtZ","longdesc":"Look at position with coordinate Z","max":5,"min":-5,"name":"LookAtZ","step":0.001,"type":"float"},{"control":"None","default":5,"label":"CamDistance","longdesc":"Camera distance to the view plane, used to define the Field Of View","max":5,"min":0,"name":"CamD","step":0.001,"type":"float"},{"control":"None","default":1,"label":"CamZoom","longdesc":"Camera zoom","max":5,"min":0,"name":"CamZoom","step":0.001,"type":"float"},{"control":"None","default":0,"label":"Reflection","longdesc":"Reflection strength, reflects other objects or the environment HDRI 360 image ","max":1,"min":0,"name":"Reflection","step":0.001,"type":"float"},{"control":"None","default":0.4,"label":"Specular","longdesc":"Objects shading specular component strength, it's the strength  of the highlight.","max":1,"min":0,"name":"Specular","step":0.001,"type":"float"},{"control":"None","default":32,"label":"Pow","longdesc":"Shininess of the specular component, it's the size of the specular component, it tries to simulate more shininess surfaces or more rough surfaces.","max":1024,"min":0,"name":"Pow","step":0.001,"type":"float"},{"control":"None","default":1,"label":"SunX","longdesc":"Sun position coordinate X","max":10,"min":-10,"name":"SunX","step":0.001,"type":"float"},{"control":"None","default":1,"label":"SunY","longdesc":"Sun position coordinate Y","max":10,"min":-10,"name":"SunY","step":0.001,"type":"float"},{"control":"None","default":1,"label":"SunZ","longdesc":"Sun position coordinate Z","max":10,"min":-10,"name":"SunZ","step":0.001,"type":"float"},{"control":"None","default":0.2,"label":"AmbLight","longdesc":"Strength of ambient light","max":1,"min":0,"name":"AmbLight","step":0.001,"type":"float"},{"control":"None","default":1,"label":"AmbOcclusion","longdesc":"Strength of ambient occlusion","max":1,"min":0,"name":"AmbOcclusion","step":0.001,"type":"float"},{"control":"None","default":1,"label":"Shadow","longdesc":"Shadow strength","max":1,"min":0,"name":"Shadow","step":0.001,"type":"float"}]},"type":"shader"}]}