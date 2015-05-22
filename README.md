# [Get Wrecked](http://getwrecked.info) 
## [Vehicle Combat Sandbox] for Arma 3 ##

Get Wrecked challenges players to create, customize, drive, survive and of course, destroy. Construct wheeled, armoured behemoths using a variety of building parts, then fight to the death in a race zone of choice. It's a creative vehicle combat sandbox for Arma 3. It's currently designed for small games of up to 12 players and is in an alpha release state.

## Quick start

Get Wrecked is not a mod, just a mission file, so you don't need to start the Arma 3 client with any funky parameters - just ensure you have disabled all other mods as they can cause conflicts in rare cases. If you're just looking to play - you don't need to do anything but join a server running the Get Wrecked mission file. There is a [server list available on the website](http://getwrecked.info#play), or filter 'Get Wrecked' if you are already in-game.

If you're looking to host yourself, it is strongly recommended to use a dedicated server to run Get Wrecked. Simply  [download the mission.pbo](http://getwrecked.info#download) and add it to your Arma3/MpMissions folder on your server. You'll need to add a class to the server.cfg to load the mission as a default:

class Missions
{
	class GetWrecked // Name for the mission, can be anything
	{
		template = "Get Wrecked v0_8_1 [Alpha].Altis";	// This file name must match the mission file name EXACTLY (without the .pbo extension)
		difficulty = "regular";	  // It's recommended to keep this as regular and to ensure third person is enabled
	};
};	

## Customization

Several aspects of the game mode can be customized. These include starting money, kill rewards, armor system and respawn timers.

If you are running a one-off session, you can access them as an admin via the parameters tab in the lobby. 

If you are running a dedicated server and you want these values to persist, you need to edit the "default = #;" entries in params.hpp, which will require decompiling and then recompiling the .pbo. Seek help if you are not sure what you are doing as editing these values incorrectly may cause the mission to stop working.

## Links

For the latest updates please follow [@GetWreckedA3 on Twitter](https://twitter.com/getwreckeda3). The [website](http://getwrecked.info) contains a starter guide and server list, along with additional information about the mod.

## Credits

**Steve IV**, **Lee**, **GoVeg**, **Grimple Poopenstein**, **Reazack**

The infamous alpha test crew - forever breaking my shit 

**Orangesherbet, Tigah & co**

For their continuing help promoting and supporting the mod via Twitch, Youtube, Twitter and also lending their feedback!

## License

**Created, coded and designed by Sli**

This mod and its content (excluding those already attributed therein) are under a CC-BY-NC-ND 4.0 License
Attribution-NonCommercial-NoDerivatives 4.0 International
Permission must be sought from the Author for its commercial use, any modification or use of a non-public release obtained via the mission cache

**Additional scripts:**

Nuclear Explosion by [Moerderhoschi](http://www.armaholic.com/page.php?id=23963)

Chat command interceptor by [Conroy](http://www.armaholic.com/page.php?id=26377)
