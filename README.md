# Godot Ocean Shaders

This repository is a collection of ocean shaders for godot 4.3.

Currently the repository includes the following shaders.

[Stylized waves - Gerstner waves](https://github.com/gersondekleuver/godot_ocean_shaders/tree/main/godot-ocean-shader-collection-4.3/stylized_wave)

## Shaders

### Stylized waves - Gerstner waves

<img src="https://github.com/user-attachments/assets/049ffac4-ce0c-4cbe-a574-7823a6304130" width="400" height="300" /> <img src="https://github.com/user-attachments/assets/d091bd8a-e8db-4e47-9bce-35ad31dd36cb" width="400" height="300" />

* A very stylized ocean shader, unoptimized, directly implimented in a gdvisual shader file.
* Allows for stacking a few waves which allow for height calculation in real-time (computationally ineffective).
* Parameters allow for alternation in wave smoothness, speed, height, and other aspects.
* This shader is a simple godot implimentation of the Gerstner waves from the great [catlikecoding](https://catlikecoding.com/unity/tutorials/flow/waves/).

#### TODO
Precalculate the gerstner waves to significantly increase performance.

### WIP Realistic waves - JONSWAP

### WIP Realistic waves - fluid dynamics
