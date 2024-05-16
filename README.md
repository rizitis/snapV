# snapV

The snap command for Slackware64 and other Linux systems:
> Read [docs](https://github.com/rizitis/snapV/tree/main/snapv/doc) about LICENSE and Terms of Service snap-store

## MAIN IDEA
Main idea is Linux system stay untouch no sudo or su -c but snap command to works similirar with original [snap command](https://snapcraft.io/docs/quickstart-tour)


## HOWTO

Examples:

* `snap install <package>`  -  Install  snap package from snap-store.
* `snap list`  -  List all installed Snap packages
-  `snap remove <package>` - Remove snap package from system.
-  `snap refresh <package>` -  Check for new package version in snap-store.
-  `snap find <query>` - List all avaliables packages related to query.
+ `snap start <package>` -  Load service or app. 
+ `snap disable <package>` -  Disable package
+ `snap enable <package>` - Enable package
+ `snap info <package>` - Display info about a Snap package
+ `snap my <package> `  - Print package desc description if package installed
* `snap help`  - Display info for all snap commands

![snap help]([https://raw.githubusercontent.com/rizitis/snapV/main/snap_help.png?token=GHSAT0AAAAAACPLSMKACRF2JUPH7MWNIBS6ZSGLBPQ](https://github.com/rizitis/snapV/blob/main/snap_help.png)

*Althought snapV is written from sratch if you explore via browser in snap store and you want to install a snap you can follow ubuntu commands.*
*It work in the same therory :* `$ snap install package_name`

**NOTE :**

You should never run snap command via sudo or any root access. snapV is disined for regullar user mode.   

This way as user you can install or unistall it self, also  install, remove  snaps and ALL other snap commands that provided. 



### Uninstall 

`snap uninstall` - This command uninstall snapV and all snaps you had installed.


### INSTALL 

Slackware64 user just run the sysV.SlackBuild as **regular user** and follow the `tar -xf` command which will be printed in terminal'\s output. 

For other Linux systems just install the snapv/ folder in `~/.local/bin/` and the snap script also.  
Your path should be like this: `~/.local/bin/{snap,snapv}`

In any case a modification in ~/.bashrc needed to export path.
So Add in your ~/.bashrc if not exist...

`export PATH="/home/$USER/.local/bin:$PATH"`


#### TODO
* Check sums for dowloaded snaps
* Make a deal with .desktop entries
* sound and fix bugs


#### CANT DO
- I cant fix (alone) a special problem: Some snaps had different snap_name than executable_name.  
Example skype. To install it you must command `snap install skype` BUT for run it `snap start skypeforlinux` . Well I cant be a prophet and I m not so good programmer to fix this. In case you found more snaps with the exaclty problem (which means they installed ok but not run...) You must fix it locally. 

Navigate to `~/.local/bin/snapv/snaps/$package_name` found the folder which contains the executable (skypeforlinux) and rename it as snap_name during installation (skype)
Sorry so far I cant find a more robust fix... 

### Inspiration

- Slackware Linux (https://www.slackware.com/) 
- Linux Questions [https://www.linuxquestions.org](https://www.linuxquestions.org/questions/slackware-14/skype-fo-linux-in-slackware-no-more-4175737011/)
- Snapcraft Documentation (https://snapcraft.io/docs) 
- Our folks from AUR (https://aur.archlinux.org)

Thank you all!

