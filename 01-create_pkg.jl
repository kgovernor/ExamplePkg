### Create package ###
using PkgTemplates

# Let's start with choosing a folder to create the package in.

pwd() # shows you which directory you are currently in.

# Change directory. The 'raw' command before the string is necessary.
use_dir = raw"C:\Users\kgovernor\Dropbox (BFI)\Apps\Overleaf\KG Orientation Latex and Julia\Julia\JuliaFiles"
cd(use_dir) 
pwd()

# Create template for package
t = Template(; 
    user="kgovernor",
    dir=use_dir,
    authors="Kyel Governor",
)

t("ExamplePkg")