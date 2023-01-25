#version 300 es
//checkerboard
precision mediump float;
uniform vec4 u_color;
out vec4 fragColor;
vec2 screensize = vec2(900., 900.);

/*
=================================
[The configuration of the shader]
=================================
*/

vec3 lightPos = vec3(1.0, 1.0, 1.0); //light position
vec3 lightColor = vec3(1.0, 1.0, 1.0); //light color
vec3 spherePosition= vec3(0.0, 0.0, 0.0); //sphere position
vec3 sphereColor = vec3(1.0, 1.0, 1.0); //sphere color
vec3 ambientColor = vec3(0.37f, 0.24f, 0.24f); //ambient color
float sphereRadius = 0.3; //sphere radius
vec3 cameraPosition = vec3(-40.,-50.0, 90.0); //camera position
float cameraFov = 90.; //camera fov

void main() {
    float ogx= gl_FragCoord.x;
    float ogy= gl_FragCoord.y;
    vec3 color= vec3(0.0,0.0,0.0);
    float lightness=1.0;
    //if we are on the screen
    if (ogx < screensize.x && ogy < screensize.y) {
        //todo
        color=vec3(1.0,1.0,1.0);
        vec2 uv = gl_FragCoord.xy / screensize.xy;
        //we gotta trace them rays
        vec3 rayDir = normalize(vec3(uv, -1.0) - cameraPosition);
        //apply fov
        //rayDir.z *= cameraFov / 90.0;
        //rayDir.x *= cameraFov / 90.0;
        //rayDir.y *= cameraFov / 90.0;
        //rayDir = normalize(rayDir);
        vec3 rayOrigin = cameraPosition;
        //we gotta check if the ray hits the sphere
        vec3 L = spherePosition - rayOrigin;
        float tca = dot(L, rayDir);
        float d2 = dot(L, L) - tca * tca;
        float r2 = sphereRadius * sphereRadius;
        if (d2 > r2) {
            //no hit
            color=vec3(0.0,0.0,0.0);
            //maybe we hit the floor
            if (rayOrigin.y < 0.0 || rayDir.y > 0.0) {
                //we hit the floor
                color=vec3(0.41f, 0.35f, 0.35f);
                //get the floor position
                float t = -rayOrigin.y / rayDir.y;
                vec3 hitPoint = rayOrigin + rayDir * t;
                //set lightness
                lightness = distance(hitPoint, lightPos);
            } else {
                //no hit
                color=vec3(0.0,0.0,0.0);
            }
        } else {
            //hit
            float thc = sqrt(r2 - d2);
            float t0 = tca - thc;
            float t1 = tca + thc;
            float t = t0;
            if (t0 < 0.) t = t1;
            if (t < 0.) {
                //no hit
                color=vec3(0.0,0.0,0.0);
            } else {
                //hit
                vec3 hitPoint = rayOrigin + rayDir * t;
                vec3 N = normalize(hitPoint - spherePosition);
                vec3 L = normalize(lightPos - hitPoint);
                float lambert = max(dot(N, L), 0.0);
                lightness = max(lambert,0.1);
                
                color = sphereColor * lightColor * lambert + ambientColor;
            }
        }

    fragColor = vec4(color*lightness,1.);   
    return;
}
}