#version 300 es
//checkerboard
precision mediump float;
uniform vec4 u_color;
out vec4 fragColor;
vec2 screensize = vec2(900., 900.);

void main() {
    vec3 color = vec3(0.0, 0.0, 0.0);
    vec3 color1 = vec3(0.0, 0.0, 0.0);
    vec3 color2 = vec3(0.59f, 0.18f, 1.f);
    float lightness =1.;
    float zoom=1.;
    float ogx= gl_FragCoord.x;
    float ogy= gl_FragCoord.y;
    vec2 pos = vec2(ogx/screensize.x,ogy/screensize.y);
    float x = zoom * ogx+sin(ogy*0.05)*4.;// make the grid wavey gravey falvoured
    float y = zoom * ogy+cos/*why not*/(ogx*0.05)*4.;
   // float y = zoom * ogy;
    if (ogx<0. || ogy<0. || ogx>screensize.x || ogy>screensize.y) {
        // if we are outside the screen
        color = vec3(0.,0.,0.);
        // draw only black
    } else{
        // if we are inside the screen
        //draw the grid pattern
        if (mod(x, 100.0) < 50.0) {
            if (mod(y, 100.0) < 50.0) {
                color = color1;
            }else{
                color = color2;
            }
        
        } else {
            if (mod(y, 100.0) > 50.0) {
                color = color1;
            }else{
                color = color2;
            }
        }
        //make colors fancy because why not
        color.r=pos.x;	
        color.g=pos.y;

        vec3 lightpos=vec3(0.4,0.6,1.);
        float lightdistance=100.;
        float d = distance(vec2(ogx,ogy),vec2(screensize.x*lightpos.x,screensize.y*lightpos.y)); //distance from the light
        if(distance(vec2(ogx,ogy),vec2(screensize.x/2.,screensize.y/2.))<100./zoom){
            // if the pixel is in the ball
            color = vec3(pos.y,pos.x,pos.y);
            color += vec3(0.5,0.1,0.1);
            lightness=lightdistance/d;
        }else{
            //if the pixel is in the background
            vec2 offset=vec2(0.5-lightpos.x,0.5-lightpos.y); //where the shadow is
            offset*=200.;   //how far the shadow is from the ball
            if (distance(vec2(ogx-offset.x,ogy-offset.y),vec2(screensize.x/2.,screensize.y/2.))<100./zoom)
            {
                //if we are in the shadow
                lightness=min(0.15,lightdistance/d); //make the region darker
            }else{
                //if we are in the light
                lightness=min(lightdistance/d,1.); //calculate the brighness based on distance
            }
        }
        }
        //output the color
        fragColor = vec4(color*lightness,1.);   
        return;
}