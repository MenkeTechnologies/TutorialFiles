#echo .profile

export UMASK=000

# Setting PATH for Python 3.5
# The orginal version is saved in .profile.pysave
export PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:/Users/jacobmenke/Documents/shellScripts:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Library/Developer/CommandLineTools/usr/bin"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home"

source ~/.bashrc
cd /Users/jacobmenke/Desktop; clear; ls -FlhA

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.cargo/bin:$PATH"
