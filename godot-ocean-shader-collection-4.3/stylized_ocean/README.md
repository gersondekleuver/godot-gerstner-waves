### Stylized ocean - Gerstner waves

<img src="https://github.com/user-attachments/assets/049ffac4-ce0c-4cbe-a574-7823a6304130" width="400" height="300" /> <img src="https://github.com/user-attachments/assets/c9ca243a-460e-46c0-8e02-7773abad8f21" width="400" height="300" />

This shader is a simple godot implimentation of the Gerstner waves from the great [catlikecoding](https://catlikecoding.com/unity/tutorials/flow/waves/).
It uses Gerstner waves in combination with noise textures to create a wave-like effect. 

* A very stylized ocean shader, directly implimented in a gdvisual shader file.
* Uses 5 gerstner waves and a height noise texture to simulate a stylized ocean.
* Simplistic code easy to understand yet unoptimized.
* Real-time calculations are inefficient, thus this shader is not scalable.
* Limited customizability.
* Uses central difference to calculate normals combined with gernster normals.

### WIP
* Terrain intersection.
* Foam - Foam textures.

This directory includes the following files:

* Project scene, for examplary reasons.
* Visual shaders folder, which includes a basic sky shader and the actual gersnter_shader.
