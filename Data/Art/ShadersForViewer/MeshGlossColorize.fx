///////////////////////////////////////////////////////////////////////////////////////////////////
// Petroglyph Confidential Source Code -- Do Not Distribute
///////////////////////////////////////////////////////////////////////////////////////////////////
//
//          $File: //depot/Projects/StarWars_Expansion/Art/Shaders/MeshGlossColorize.fx $
//          $Author: Andre_Arsenault $
//          $DateTime: 2006/02/15 15:33:33 $
//          $Revision: #1 $
//
///////////////////////////////////////////////////////////////////////////////////////////////////
/*
	
	2x Diffuse+Spec lighting, colorization.
	Spec is modulated by alpha channel of the texture (gloss)
	Colorization mask is in the rgb channel (assumed greyscale) of the colorize texture.
	
*/

string _ALAMO_RENDER_PHASE = "Opaque";
string _ALAMO_VERTEX_PROC = "Mesh";
string _ALAMO_VERTEX_TYPE = "alD3dVertNU2";
bool _ALAMO_TANGENT_SPACE = false;
bool _ALAMO_SHADOW_VOLUME = false;
	

#include "GlossColorize.fxh"


///////////////////////////////////////////////////////
//
// Vertex Shader
//
///////////////////////////////////////////////////////

struct VS_INPUT
{
    float4 Pos  : POSITION;
    float3 Norm : NORMAL;
    float2 Tex  : TEXCOORD0;
};

VS_OUTPUT sph_vs_main(VS_INPUT In)
{
    VS_OUTPUT Out = (VS_OUTPUT)0;

	Out.Pos = mul(In.Pos,m_worldViewProj);
    Out.Tex0 = In.Tex;
	Out.Tex1 = In.Tex;	

    // Lighting in view space:
    float3 world_pos = mul(In.Pos, m_world);
    float3 world_normal = normalize(mul(In.Norm, (float3x3)m_world));
    float3 diff_light = Sph_Compute_Diffuse_Light_All(world_normal);
    float3 spec_light = Compute_Specular_Light(world_pos,world_normal);

    // Output final vertex lighting colors:
    Out.Diff = float4(Diffuse.rgb * diff_light * m_lightScale.rgb + Emissive, m_lightScale.a);
    Out.Spec = float4(Specular * spec_light, 1);

	// Output fog
	Out.Fog = Compute_Fog(Out.Pos.xyz);

    return Out;
}

vertexshader sph_vs_main_bin = compile vs_1_1 sph_vs_main();
pixelshader gloss_colorize_ps_main_bin = compile ps_1_1 gloss_colorize_ps_main();


//////////////////////////////////////
// Techniques follow
//////////////////////////////////////
technique max_viewport
{
    pass max_viewport_p0
    {
        SB_START

    		// blend mode
    		ZWriteEnable = TRUE;
    		ZFunc = LESSEQUAL;
    		DestBlend = INVSRCALPHA;
    		SrcBlend = SRCALPHA;
    
        SB_END        

        // shader programs
        VertexShader = (sph_vs_main_bin);
        PixelShader = (gloss_colorize_ps_main_bin);

   		AlphaBlendEnable = (m_lightScale.w < 1.0f); 
    }
}

technique sph_t0
<
	string LOD="DX8";
>
{
    pass sph_t0_p0
    {
        SB_START

    		// blend mode
    		ZWriteEnable = TRUE;
    		ZFunc = LESSEQUAL;
    		DestBlend = INVSRCALPHA;
    		SrcBlend = SRCALPHA;
    
        SB_END        

        // shader programs
        VertexShader = (sph_vs_main_bin);
        PixelShader = (gloss_colorize_ps_main_bin);

   		AlphaBlendEnable = (m_lightScale.w < 1.0f); 

    }
}

technique sph_t1
<
	string LOD="FIXEDFUNCTION";
>
{
    pass sph_t1_p0
    {
        SB_START

    		// blend mode
    		ZWriteEnable = TRUE;
    		ZFunc = LESSEQUAL;
    		DestBlend = INVSRCALPHA;
    		SrcBlend = SRCALPHA;
    
            // fixed function pixel pipeline
    		Lighting=true;
    		
    		MinFilter[0]=LINEAR;
    		MagFilter[0]=LINEAR;
    		MipFilter[0]=LINEAR;
    		AddressU[0]=wrap;
    		AddressV[0]=wrap;
    		TexCoordIndex[0]=0;
    
    		ColorOp[0]=BLENDTEXTUREALPHA;
    		ColorArg1[0]=TFACTOR;
    		ColorArg2[0]=TEXTURE;
    		AlphaOp[0]=SELECTARG1;
    		AlphaArg1[0]=TEXTURE;
    
    		ColorOp[1]=MODULATE2X;
    		ColorArg1[1]=DIFFUSE;
    		ColorArg2[1]=CURRENT;
    		AlphaOp[1]=SELECTARG1;
    		AlphaArg1[1]=DIFFUSE;
    		
    		ColorOp[2] = DISABLE;
    		AlphaOp[2] = DISABLE;

        SB_END        

        // shader programs
        VertexShader = NULL;
        PixelShader = NULL;
        
   		AlphaBlendEnable = (m_lightScale.w < 1.0f); 

		Texture[0]=(BaseTexture);
		TextureFactor=(Colorization);
		MaterialAmbient = (Diffuse);
	    MaterialDiffuse = (float4(Diffuse.rgb*m_lightScale.rgb,m_lightScale.a));
    	MaterialSpecular = (Specular);
		MaterialEmissive = (Emissive);
		MaterialPower = 32.0f;
    }

}

