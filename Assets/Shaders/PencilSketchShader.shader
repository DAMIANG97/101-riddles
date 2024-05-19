Shader "Custom/PencilEffectSpriteShapeShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FillTexture ("Fill Texture", 2D) = "white" {} 
        _FillColor ("Fill Color", Color) = (1, 1, 1, 1) 
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _FillTexture; 
            fixed4 _FillColor; 

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mainCol = tex2D(_MainTex, i.texcoord);
                fixed4 fillCol = tex2D(_FillTexture, i.texcoord) * _FillColor;

                // Sprawdź, czy piksel z tekstury głównej jest biały
                if (mainCol.r == 1 && mainCol.g == 1 && mainCol.b == 1 && mainCol.a > 0) {
                    return fillCol;
                } else {
                    return mainCol;
                }
            }
            ENDCG
        }
    }
    FallBack "Sprites/Default"
}
