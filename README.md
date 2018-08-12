REPOSITORY DESCRIPTION
----------------------
This repository contains scripts which simplify the edition of changelogs for package maintainers.
After running these scripts, only minimal edition is required.

REPOSITORY INDEX
----------------
`rpm2deb-changelog` is a Perl script which transforms an RPM *.changes file
into a Debian changelog. Minor editing may be required to have a consistent
Debian changelog (versions, urgencies, ...). The aim of this script is
to simplify the life of a maintainer, who packages for both RPM-based distros
and Debian-based distros.

`rpm2deb-change` is a Bash script which transforms the last RPM change
in an RPM *.changes file into a Debian change in a Debian changelog. The aim of
this script is to simplify the life of a maintainer, who packages for both
RPM-based distros and Debian-based distros.

The `vc-debian` tool adds a new changes entry to a SUSE *.changes file.
The *-m* option can be used to directly specify the entry, if it is
not given an editor is started to interactively enter the new changes
entry. If a *commentfile* is given, its content is used as template
for the new entry instead of an empty entry, whereas the *-e* option
suppresses the creation of an empty entry.
This version is modified so that the debian changelog is also modified
when osc vc is used in a package with a *debian.changelog* file.

AUTHOR
------
The scripts and the man pages were written by **Pascal COMBES** <pascom@orange.fr>

LICENSE
-------
These programs are free software: you can redistribute them and/or modify
them under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

These programs are distributed in the hope that they will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
