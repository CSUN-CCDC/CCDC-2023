import sys
import site

# Print the paths where Python looks for modules and packages
print("Sys Path:")
for path in sys.path:
    print(path)

# Print the site-packages directory
print("\nSite Packages:")
print(site.getsitepackages())