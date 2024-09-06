# Godot Ocean Shaders

This repository is a collection of ocean shaders for godot 4.3.

Currently the repository includes the following shaders.

## Shaders

### Simple Gerstner waves 
* A very stylized ocean shader for places with little water, unoptimized.
* This shader is a simple godot implimentation of the Gerstner waves from the great [catlikecoding](https://catlikecoding.com/unity/tutorials/flow/waves/).
* It is implimented in the gerstner_wave.gdshader visual shader file. It is unoptimized and not scalable, scalability can be achieved by storing the waves in a texture instead of calculating wave height and displacement in real time. 

![gerstner_visual_shader](https://github.com/user-attachments/assets/049ffac4-ce0c-4cbe-a574-7823a6304130)
f)
