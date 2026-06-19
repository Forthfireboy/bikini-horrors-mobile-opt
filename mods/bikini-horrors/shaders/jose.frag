//por jorge2017a1 -- https://www.shadertoy.com/view/wtjfR3

#define MAX_STEPS 100
#define MAX_DIST 100.
#define MIN_DIST 0.001

vec3 light_pos1   ;
vec3 light_color1 ;
vec3 light_pos2   ;
vec3 light_color2 ;
    
    

float sdSphere( vec3 p, float s )
{
  return length(p)-s;
}

float sdRoundBox( vec3 p, vec3 b, float r )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0) - r;
}



float sdCylinderXZ( vec3 p, vec2 h )
{
    vec2 d = abs(vec2(length(p.xz),p.y)) - h;
    return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}




///----------Operacion de Distancia--------
float intersectSDF(float distA, float distB)
{
    return max(distA, distB);
}

float unionSDF(float distA, float distB) 
{
    return min(distA, distB);
}

float differenceSDF(float distA, float distB) 
{
    return max(distA, -distB);
}
//-------------------------------------------


vec3 opU3(vec3 d1, vec3 d2 )
{
  vec3 resp;
    if (d1.x < d2.x){ 
        resp = d1;
    }
    else
    {
        resp = d2;
    }
     
   return resp; 
}

///------------------------------------

// object transformation
vec3 rotate_x(vec3 p, float phi) 
{
	float c = cos(phi);
	float s = sin(phi);
	return vec3(p.x, c*p.y - s*p.z, s*p.y + c*p.z);
}

vec3 rotate_y(vec3 p, float phi) 
{
	float c = cos(phi);
	float s = sin(phi);
	return vec3(c*p.x + s*p.z, p.y, c*p.z - s*p.x);
}

vec3 rotate_z(vec3 p, float phi)
{
	float c = cos(phi);
	float s = sin(phi);
	return vec3(c*p.x - s*p.y, s*p.x + c*p.y, p.z);
}


vec3 CasaDoble(vec3 p)
{    
    vec3 res;
    res = vec3(9999.0, -1.0,-1.0);
    
    float cs1ParedFrente= sdRoundBox( p- vec3(-20.0,17.0,0.0), vec3(5.0,25.0,15.0), 1.0 );
    float cs1Marquesina= sdRoundBox( p- vec3(-20.0,17.5,0.0), vec3(10.0,0.4,15.0), 1.0 );
    
    float cs1Linea1= sdRoundBox( p- vec3(-20.5,4.5,-12.0), vec3(7.0,0.5,4.5), 1.0 );
    float cs1Linea2= sdRoundBox( p- vec3(-20.5,4.5, 12.0), vec3(7.0,0.5,4.5), 1.0 );
    
    float cs1Puerta= sdRoundBox( p- vec3(-13.0,2.0,0.0), vec3(8.5,10.0,4.0), 1.0 );
    float cs1PuertaInt= sdRoundBox( p- vec3(-16.0,2.0,0.0), vec3(0.5,9.5,3.5), 1.0 );
    
    float cs1VentanaSup1= sdRoundBox( p- vec3(-13.0,25.0,-4.0),vec3(3.5,4.0,2.0), 1.0 );
    float cs1VentanaSup2= sdRoundBox( p- vec3(-13.0,25.0,4.0), vec3(3.5,4.0,2.0), 1.0 );
    float cs1VentanaSup1int= sdRoundBox( p- vec3(-16.0,25.0,-4.0),vec3(0.4,3.5,2.0), 1.0 );
    float cs1VentanaSup2int= sdRoundBox( p- vec3(-16.0,25.0,4.0), vec3(0.4,3.5,2.0), 1.0 );
    
    
    res =opU3(res, vec3(cs1Linea1,12.0,MATERIAL_NO)); 
    res =opU3(res, vec3(cs1Linea2,11.0,MATERIAL_NO)); 
    
    //restar puerta con pared    
     float dif= differenceSDF(cs1ParedFrente, cs1Puerta); 
     dif= differenceSDF(dif, cs1VentanaSup1); 
     dif= differenceSDF(dif, cs1VentanaSup2); 
    
    
    //ventanas negras
    res =opU3(res, vec3(cs1VentanaSup1int,0.0,MATERIAL_NO)); 
    res =opU3(res, vec3(cs1VentanaSup2int,0.0,MATERIAL_NO)); 
    res =opU3(res, vec3(cs1PuertaInt,0.0,MATERIAL_NO)); 
    
    
    float cs1Banqueta= sdRoundBox( p- vec3(-10.0,-6.0,0.0), vec3(8.0,0.5,18.0), 1.0 );
    float cs1Banqueta2= sdRoundBox( p- vec3(5.0,-8.0,0.0), vec3(20.0,0.5,20.0), 1.0 );
    res =opU3(res, vec3(cs1Banqueta,13.0,MATERIAL_NO)); 
    res =opU3(res, vec3(cs1Banqueta2,1.0,MATERIAL_NO)); 
    
    
    res =opU3(res, vec3(cs1Marquesina,2.0,MATERIAL_NO)); 
    res =opU3(res, vec3(dif,30.0,MATERIAL_NO)); 
    
    
    //postes
    float sdcy= sdCylinderXZ(p-vec3(-2.0,0.0,0.0), vec2(0.5,25.0));
    float sdsp1= sdSphere(p-vec3(-2.0,25.0,0.0), 1.5 );
    res =opU3(res, vec3(sdcy,14.0,MATERIAL_NO)); 
    res =opU3(res,vec3(sdsp1,18.0,MATERIAL_NO)); 
    
    
    //bote basura
    float sdc2= sdCylinderXZ( p- vec3(-1.5,0.0,-8.0), vec2(1.5,3.0) );
    res =opU3(res,vec3(sdc2,32.0,MATERIAL_NO)); 
    
    
    return res;
}

///------------------------------------
vec3 GetDist(vec3 p  ) 
{	

    float d, dif1, dif2;
    vec3 res;
    vec3 pp,p1, p2,p3; 
    res = vec3(9999.0, -1.0,-1.0);

    float planeDist1 = p.y+5.0;  //piso inf
    float planeDist2 = 50.0-p.y;  //piso sup
       
    res =opU3(res, vec3(planeDist1,100.0,MATERIAL_NO)); //inf
    res =opU3(res, vec3(planeDist2,100.0,MATERIAL_NO)); 
    
    p.y=p.y-5.0;
  
    
	vec3 q=p;
    float cz=45.00;
    q.z = mod(q.z+0.5*cz,cz)-0.5*cz;

    p=q;
	
    vec3 cs1= CasaDoble( p);
    vec3 pr= rotate_y( p-vec3(52.0,0.0,0.0), radians(180.0));
        
    vec3 cs2= CasaDoble( pr);
    res =opU3(res, cs1); 
    res =opU3(res, cs2); 
    
    
    //return (dist, id_color, id_material)
    return vec3(res.x, res.y, res.z);
}



///-----------------------------------------
vec3 LightShading(vec3 Normal,vec3 toLight,vec3 toEye,vec3 color)
{
    vec3 toReflectedLight=reflect(-toLight, Normal);
    vec3 diffuse = max(0.,dot(Normal,-toLight))*color;
    //vec3 specular = pow(max(0.,dot(Normal,normalize(-toLight-V))),100.)*vec3(1.,1.,1.); 
    float specularf=max(dot(toReflectedLight, toEye),0.0);
    specularf=pow(specularf, 100.0);
    vec3 specular =specularf*vec3(1.0);
    
    return diffuse + specular;
}
//------------------------------------------------



vec3 GetNormal(vec3 p) 
{
	float d = GetDist(p).x;
    //Texture of white and black in image
    vec2 e = vec2(.001, 0);
    
    vec3 n = d - vec3(
        GetDist(p-e.xyy).x,
        GetDist(p-e.yxy).x,
        GetDist(p-e.yyx).x);
    
    return normalize(n);
}


//---------actualizacion por Shane---28-may-2020    ...gracias
float RayMarch(vec3 ro, vec3 rd) 
{
	
    // The extra distance might force a near-plane hit, so
    // it's set back to zero.
    float dO = 0.; 
    vec3 dS=vec3(9999.0,-1.0,-1.0);
    float marchCount = 0.0;
    vec3 p;
    
    //Determines size of shadow
    for(int i=0; i<MAX_STEPS; i++) 
    {
    	p = ro + rd*dO;
        dS = GetDist(p);
        
        if(dO>MAX_DIST || abs(dS.x)<MIN_DIST) break;
        dO += dS.x;
        //marchCount+= 1./dS.x*.75;
        marchCount++;
    }
    
    mObj.dist = dO;
    mObj.id_color = dS.y;
    mObj.marchCount=marchCount;
    mObj.id_material=dS.z;
    mObj.normal=GetNormal(p);
    return dO;
}

//---------------------------------------------------



float GetShadow(vec3 p, vec3 plig) 
{
    vec3 lightPos = plig;
    //Determine movement of light ex. shadow and light direction and diffusion
   
    vec3 l = normalize(lightPos-p);
    vec3 n = GetNormal(p);
    
    float dif = clamp(dot(n, l), 0., 1.);
    float d = RayMarch(p+n*MIN_DIST*2., l );
    if(d<length(lightPos-p)) dif *= .1;
    
    return dif;
}

//----------------------------------------------------

//Creado por dr2 en 2020-07-28
//https://www.shadertoy.com/view/3lfBz8
mat3 StdVuMat (float el, float az)
{
  vec2 ori, ca, sa;
  ori = vec2 (el, az);
  ca = cos (ori);
  sa = sin (ori);
  return mat3 (ca.y, 0., - sa.y, 0., 1., 0., sa.y, 0., ca.y) *
         mat3 (1., 0., 0., 0., ca.x, - sa.x, 0., sa.x, ca.x);
}


//Creado por dr2 en 2020-07-28
//https://www.shadertoy.com/view/3lfBz8
vec3 getMouse(vec3 ro)
{    
     vec4 mPtr = iMouse;
  mPtr.xy = mPtr.xy / iResolution.xy - 0.5;
  float tCur = iTime;
    
  float az = 0.;
  float el = -0.15 * PI;

    az += 2. * PI * mPtr.x;
    el += PI * mPtr.y;
 
    
    
  mat3 vuMat = StdVuMat (el, az);
	return ro*vuMat;
}

//-------------------------------------------

//-------------------------------
vec3 getColorTextura( vec3 p, vec3 nor,  int i)
{
    
	if (i==100 ) { return tex3D(iChannel0, p/32., nor); }
	if (i==101 ) { return tex3D(iChannel1, p/32., nor); }
	if (i==102 ) { return tex3D(iChannel2, p/32., nor); }
	if (i==103 ) { return tex3D(iChannel3, p/32., nor); }
   
    
}
//-------------------------------
vec3 Getluz(vec3 p, vec3 ro, vec3 rd, vec3 nor , vec3 colobj ,vec3 plight_pos)
{   
     
    vec3 lightPos = plight_pos;
    float intensity=1.0;
	const float shininess = 100.0;
	vec3 l = normalize( p-lightPos);
    vec3 v = normalize( p-ro);
    vec3 h = normalize(v + l);
    float diff = dot(nor, l);
    float spec = max(0.0, pow(dot(nor, h), shininess)) * float(diff > 0.0);
	vec3 result = LightShading(nor,l,v, colobj)*intensity;
    
    if (mObj.blnShadow==true)
    {       
    	float fhadow=GetShadow(p,plight_pos);
    	return result*fhadow;
        
        //vec3 psh= p_shadingv3(p,  nor,  ro,  rd,  plight_pos,   colobj );
    	//return result* psh;
     }
    else
    {
    	return result;
    }
   	
}
///-------------------------------------
//-------------------------------------------------

vec3 GetColorYMaterial(vec3 p,  vec3 n, vec3 ro,  vec3 rd, int id_color, float id_material)
{
   	vec3 colobj;
    
    
    
    
    if (id_color<100)
		{ colobj=getColor(int( id_color)); }
    
    
    
    if ( float( id_color)>=100.0  && float( id_color)<=199.0 ) 
 	{  vec3 coltex=getColorTextura(p, n, int( id_color));
        colobj=coltex;
	}

    
    
    
    return colobj;
}


///---------------------------------------------
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
   mObj.uv=uv;
    
    float t;
    t=mod(iTime*12.0,360.0);
    itime=t;
	mObj.blnShadow=false;
        
 
 	light_pos1   = vec3(10.0, 6.0, 30.0 ); 
 	light_color1 = vec3( 1.0 );

 	light_pos2   = vec3( -5.0, 6.0, -30.0 );
 	light_color2 = vec3( 1.0, 1.0, 1.0 );
 
    
 	vec3 ro=vec3(25.0,10.0,-25.0+t);
    //ro= getMouse(ro);       
    vec3 rd=normalize(vec3(uv,1.0));
    
    
    light_pos1+=ro;
    light_pos2+=ro;
    
    
    vec3 col = vec3(0);
    
    TObj Obj;
    
    
    mObj.rd=rd;
    mObj.ro=ro;

	 
    
    float d = RayMarch(ro, rd);
    Obj=mObj;
    
  
    vec3 p = (ro + rd * d ); 
    
    mObj.p=p;
    mObj.dist =d;
    vec3 nor=mObj.normal;

    vec3 colobj;
    colobj=GetColorYMaterial( p, nor, ro, rd,  int( Obj.id_color), Obj.id_material);
    

  	float dif1=1.0;
   	vec3 col2,col3;
    
    vec3 result;
    result=  Getluz( p,ro,rd, nor, colobj ,light_pos1);
    result+= Getluz( p,ro,rd, nor, colobj ,light_pos2);
    result/=1.25;
    col3=result;
    col= col3*dif1;
    
  	
    //sugerencia por dean_the_coder,
    col *= 1.0 - pow(d / 100.0, 4.5);
    //col *= 1.0 - pow(d /(100.0) , 3.5);    
    col = pow(col, vec3(1.0/2.2));  
    
    fragColor = vec4(col,1.0);

}