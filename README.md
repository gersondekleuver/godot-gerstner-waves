# Godot Ocean Shaders

This repository is a collection of ocean shaders for the [godot 4.3 game engine](https://godotengine.org/).

Currently the repository includes the following shaders.

[Stylized waves - Gerstner waves](https://github.com/gersondekleuver/godot_ocean_shaders/tree/main/godot-ocean-shader-collection-4.3/stylized_wave)

## Shaders

### Stylized waves - Gerstner waves

<img src="https://github.com/user-attachments/assets/049ffac4-ce0c-4cbe-a574-7823a6304130" width="400" height="300" /> <img src="https://github.com/user-attachments/assets/c911e934-b794-4a87-8296-1935723527c8" width="400" height="300" />


* A very stylized ocean shader, unoptimized, directly implimented in a gdvisual shader file.
* Allows for stacking a few waves which allow for height calculation in real-time (computationally ineffective).
* Uses 3 noise textures to generate 2 water textures and 1 height texture which can be turned off to get smooth stylized waves.
* Parameters allow for alternation in wave smoothness, speed, height, and other aspects.
* This shader is a simple godot implimentation of the Gerstner waves from the great [catlikecoding](https://catlikecoding.com/unity/tutorials/flow/waves/).

#### TODO
* Precalculate the gerstner waves to significantly increase performance and store the output in a texture to go from real-time calculations to one-time (plus update calculation).
* Add readback for buoyancy.

### WIP Realistic waves - JONSWAP

* A realistic wave model based on the infamous works of Tessendorf and the observed JONSWAP spectrum data.
* Highly customizable, retained the original parameters of the JONSWAP spectrum to give enhanced customizability compared to other implimentations.
* Easy to personalize with modular components.
* This shader is a complex godot implimnetation partly inspired on the code works of [Jump trajectory](https://github.com/gasgiant/FFT-Ocean) ([video](https://www.youtube.com/watch?v=kGEqaX4Y4bQ))

### WIP Realistic waves - fluid dynamics
