#!/bin/bash

is_fail=false

# Check for an Anaconda installation. This will help to isolate
# Python environments specifically for our application, as well as
# to ensure that we have the correct version of CMake and Python.
if ! conda list
then
    msg="Anaconda could not be found. Please install Anaconda and try again."
    echo $msg
    is_fail=true
fi

# Get the approprioate version of Python, CMake, and other dependencies
if ! $is_fail
then
    conda create --n pulse -f environment.yml
    conda activate pulse
fi

# Check for a Java installation, which Pulse requires for testing.
# To do so, we can check if the JAVA_HOME environment variable is set.
if (! $is_fail) && [ -z "$JAVA_HOME" ]
then
    msg="Java and/or the 'JAVA_HOME' environment variable could not be found. \
        Please install Java and try again. If you do not have a Java runtime installed, \
        Kitware recommends the free Corretto JDK 8 by Amazon."
    echo $msg
    is_fail=true
fi

# Generate build files specific to the user's operating system using CMake.
# This will also create a build directory in the appropriate location.
path_to_build=$"./build/build_"$OSTYPE
if ! $is_fail
then
    if ! [ -d $path_to_build ]
    then
        mkdir $path_to_build
    fi
    cd $path_to_build
    cmake -DCMAKE_BUILD_TYPE:STRING=Release ../../engine
    echo "Installation complete! Build files for your system are ready to compile in $path_to_build."
else
    echo "Installation failed."
fi