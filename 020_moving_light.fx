
/*
    Description:
    ReShadeFX version of "shader tutorial series - episode 020 - moving light"

    Link:
    https://youtu.be/1EmrgnpXj7A

    BSD 3-Clause License

    Copyright (c) 2022, brimson
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

uniform float u_time < source = "timer"; >;

// Vertex shaders

void MainVS(in uint ID : SV_VertexID, out float4 Position : SV_Position, out float2 TexCoord : TEXCOORD0)
{
    TexCoord.x = (ID == 2) ? 2.0 : 0.0;
    TexCoord.y = (ID == 1) ? 2.0 : 0.0;
    Position = float4(TexCoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}

// Pixel shaders

void MainPS(in float4 Position : SV_Position, in float2 TexCoord : TEXCOORD0, out float4 FragColor : SV_Target0)
{
    float2 u_resolution = float2(BUFFER_WIDTH, BUFFER_HEIGHT);
    float min_resolution = min(BUFFER_WIDTH, BUFFER_HEIGHT);

    float u_time_ps = u_time / min_resolution;
    float2 FragCoord = TexCoord.xy * u_resolution;

    float2 coord = (FragCoord.xy * 2.0 - u_resolution) / min_resolution;
    coord.x += sin(u_time_ps) + cos(u_time_ps * 2.1);
    coord.y += cos(u_time_ps) + sin(u_time_ps * 1.6);
    float3 color = 0.0;

    color += 0.1 * (abs(sin(u_time_ps)) + 0.1) / length(coord);

    FragColor = float4(color, 1.0);
}

technique _020_moving_light
{
    pass
    {
        VertexShader = MainVS;
        PixelShader = MainPS;
        #if BUFFER_COLOR_BIT_DEPTH == 8
            SRGBWriteEnable = TRUE;
        #endif
    }
}
