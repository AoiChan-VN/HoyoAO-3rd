#!/usr/bin/env python3

import os
import sys

from SCons.Script import Environment, Glob, Variables, ARGUMENTS, SConscript, Default

libname = "aoi_native"
projectdir = "project"

local_env = Environment(tools=["default"], PLATFORM="")
customs = [os.path.abspath("custom.py")]

opts = Variables(customs, ARGUMENTS)
opts.Update(local_env)

env = SConscript(
    "godot-cpp/SConstruct",
    {"env": local_env, "customs": customs},
)

env.Append(CPPPATH=["src/"])
sources = Glob("src/*.cpp")

suffix = env["suffix"].replace(".dev", "").replace(".universal", "")
lib_filename = "{}{}{}{}".format(
    env.subst("$SHLIBPREFIX"),
    libname,
    suffix,
    env.subst("$SHLIBSUFFIX"),
)

library = env.SharedLibrary(
    "bin/{}/{}".format(env["platform"], lib_filename),
    source=sources,
)

copy = env.Install(
    "{}/bin/{}/".format(projectdir, env["platform"]),
    library,
)

Default(library, copy)
