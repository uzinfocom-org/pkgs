# This one brings our custom packages from the 'pkgs' directory
{...}: final: _prev:
import ../packages {pkgs = final;}
