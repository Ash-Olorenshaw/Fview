## Qualities project

### Building

Currently only on Linux (and potentially MacOS).

Ensure you have GFortran installed.

```nu-script
# Fedora
sudo dnf install gcc-gfortran

# Homebrew
brew install gfortran
```

Clone the repo (and submodules)

```nu-script
git clone --recurse-submodules -j8 https://github.com/Ash-Olorenshaw/Fview.git
```

Run the `Makefile`

```nu-script
# install submodule dependencies
make prepare

# OPTIONAL: download FPM dependencies and build project
make build

# runs 'make build' and runs the project
make run
```
