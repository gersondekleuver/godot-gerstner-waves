# Godot Ocean Shaders

This repository is a collection of ocean shaders for the [godot 4.3 game engine](https://godotengine.org/).

Currently the repository includes the following shaders.

[Stylized waves - Gerstner waves](https://github.com/gersondekleuver/godot_ocean_shaders/tree/main/godot-ocean-shader-collection-4.3/stylized_wave)

## Shaders

### Stylized waves - Gerstner waves

<img src="https://github.com/user-attachments/assets/049ffac4-ce0c-4cbe-a574-7823a6304130" width="400" height="300" /> <img src="https://github.com/user-attachments/assets/c911e934-b794-4a87-8296-1935723527c8" width="400" height="300" />

This shader is a simple godot implimentation of the Gerstner waves from the great [catlikecoding](https://catlikecoding.com/unity/tutorials/flow/waves/).
It uses Gerstner waves in combination with noise textures to create a wave-like effect. 

* A very stylized ocean shader, directly implimented in a gdvisual shader file.
* Simplistic code easy to understand.
* Limited customizability.
* Visible tiling (#TODO 1)
* Normals not accurate.

---------- 

### WIP Realistic waves - JONSWAP

* A realistic wave model based on the infamous works of Tessendorf and the observed JONSWAP spectrum data.
* Highly customizable, retained the original parameters of the JONSWAP spectrum to give enhanced customizability compared to other implimentations.
* Easy to personalize with modular components.
* This shader is a complex godot implimnetation partly inspired on the code works of [Jump trajectory](https://github.com/gasgiant/FFT-Ocean) ([video](https://www.youtube.com/watch?v=kGEqaX4Y4bQ))

### WIP Realistic waves - fluid dynamics
