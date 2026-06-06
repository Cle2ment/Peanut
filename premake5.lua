-- premake5.lua
workspace "PeanutApp"
   architecture "x64"
   configurations { "Debug", "Release", "Dist" }
   startproject "PeanutApp"

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

include "PeanutExternal.lua"
include "PeanutApp"