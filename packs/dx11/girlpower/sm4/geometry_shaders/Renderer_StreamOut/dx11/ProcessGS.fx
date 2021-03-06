//@author: vux
//@help: template for geometry fx
//@tags: geometry
//@credits:

float4x4 tW : WORLD;
float4x4 tWIT : WORLDINVERSETRANSPOSE;

struct vs2gs
{
	float3 PosO: POSITION;
	float3 Normal: NORMAL;
	float2 UV: TEXCOORD0;
};

vs2gs VS(
	float3 PosO: POSITION,
	float3 Normal: NORMAL,
	float2 UV: TEXCOORD0,
	uint InstanceID: SV_VertexID)
{
	vs2gs Out;
	
	Out.PosO = mul(float4(PosO, 1.0f), tW).xyz;
	Out.Normal = mul(float4(Normal, 0.0f), tWIT).xyz;
	Out.UV = UV;
	
    return Out;
}


GeometryShader StreamOutGS = ConstructGSWithSO( CompileShader( vs_4_0, VS() ), "POSITION.xyz;NORMAL.xyz;TEXCOORD.xy", NULL,NULL,NULL,-1 );
//if the above does not work, try this line instead
//GeometryShader StreamOutGS = ConstructGSWithSO( CompileShader( vs_4_0, VS() ), "POSITION.xyz;NORMAL.xyz;TEXCOORD.xy" );

technique10 PassMesh
{
    pass PP2
    {
        SetVertexShader( CompileShader( vs_4_0, VS() ) );
        SetGeometryShader( StreamOutGS );
    }  
}