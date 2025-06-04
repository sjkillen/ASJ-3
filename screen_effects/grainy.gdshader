shader_type canvas_item;

uniform float seed = 81.0;
uniform float power : hint_range( 0.0, 1.0 ) = 0.00002;
uniform float speed = 0.1;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

vec2 random( vec2 pos )
{ 
	return fract(
		sin(
			vec2(
				dot(pos, vec2(12.9898,78.233))
			,	dot(pos, vec2(-148.998,-65.233))
			)
		) * 43758.5453
	);
}

uniform float amount = 0.010;


void fragment( )
{
	vec2 uv = SCREEN_UV + ( random( UV + vec2( seed - TIME * speed, TIME * speed ) ) - vec2( 0.5, 0.5 ) ) * power;
	COLOR = textureLod( SCREEN_TEXTURE, uv, 0.0 );
	
	vec2 buv = UV;
	//buv.r = buv.r % 25.0
	float factor = 100.0;
	buv.r = round(buv.r * factor) / factor;
	buv.g = round(buv.g * factor) / factor;
	
	float a = fract(sin(dot(buv, vec2(12.9898, 78.233) * TIME)) * 438.5453) * 1.9;
	a = a * amount;
	COLOR.r -= a;
	COLOR.g -= a;
	COLOR.b -= a;
}