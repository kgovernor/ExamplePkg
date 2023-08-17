using DocumenterTools, ExamplePkg

# Initialize Documentation
pwd()
DocumenterTools.generate() # Generates documentation folder in pwd()
DocumenterTools.genkeys() # Generates keys needed to host documentation on github pages

#=

1. Add Documenter.yml to .github/workflows

2. Use the first key generated above and add the GITHUB TOKEN to the github repository>settings>Deploy Keys, 
   name the new key "Documenter" (the same as the Documenter.yml file) and allow write access.

3. Use the second key generated above, the DOCUMENTER KEY, as a new repository secret on github repository>settings>secrets>Action>new repository secret,
   name the new secret "DOCUMENTER_KEY".
   
4. Update the make.jl file in docs and run it.

=#