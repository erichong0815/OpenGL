// Student: Ka Hou Hong (22085304)
vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 pos;
varying vec3 N;


uniform float LightBrightness, LightBrightness2;
uniform vec4 LightPosition, LightPosition2;
uniform vec3 LightColor, LightColor2;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform float Shininess;



uniform sampler2D texture;

void main()
{
    

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 E = normalize( -pos );   // Direction to the eye/camera

    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;
    vec3 Lvec2 = LightPosition2.xyz;

    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 L2 = normalize( Lvec2 );   // Direction to the light source
    vec3 H = normalize( L + E );  // Halfway vector
    vec3 H2 = normalize( L2 + E );  // Halfway vector

    //QuestionG: PERFORM THE LIGHTING CALCULATIONS IN THE FRAGMENT SHADER
    // AND QuestionI: ADD A SECOND LIGHT 
    // Compute terms in the illumination equation
    vec3 ambient = (LightColor * LightBrightness)  * AmbientProduct;
    vec3 ambient2 = (LightColor2 * LightBrightness2)  * AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    float Kd2 = max( dot(L2, N), 0.0 );

    vec3 diffuse = Kd * (LightColor * LightBrightness) * DiffuseProduct;
    vec3 diffuse2 = Kd2 * (LightColor2 * LightBrightness2) * DiffuseProduct;


    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );

    vec3 specular = Ks * LightBrightness * SpecularProduct;
    vec3 specular2 = Ks2 * LightBrightness2 * SpecularProduct;

    if (dot(L, N) < 0.0 ) {
    specular = vec3(0.0, 0.0, 0.0);
    } 

    if (dot(L2, N) < 0.0 ) {
    specular2 = vec3(0.0, 0.0, 0.0);
    } 
    
    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    
    //QuestionF: THE LIGHT REDUCES WITH DISTANCE
    float dist = 0.01 + length(Lvec);
    color = vec4(globalAmbient + ((ambient + diffuse) / dist) + (ambient2 + diffuse2), 1.0);
    color.a = 1.0;
    gl_FragColor = (color * texture2D(texture, texCoord * 2.0)) + vec4((specular / dist) + specular2 , 1.0);
}




