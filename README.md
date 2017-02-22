IPCheck

Gets the IP addresses for a list of URLs and then replaces the domain with the IP and compares the two to see if the result is a compromised server. Put the domains/URIs in the input.txt, and
run ipcheck.rb, then receive output in output.txt. It will strip out the domains from URIs,
so it is not necessary to put only domains. It will also ignore blank lines and extra text AFTER the url.

Requires at least Ruby 2.x

Need Ruby? Linux - it's probably available as a package in your package manager. Windows - use this https://rubyinstaller.org/.
Mac - I recommend RVM https://rvm.io/rvm/install
