# **Chat Module**

**NOTE:** As a developer if you want to add chat commands to the gamemode itself, you need to do so in the sh_chat.lua file. Do not override the PlayerSay hook in another file, as this will cause errors.

The chat module, as the name would suggest, handles the chat system in the game.

Chat commands can be added to the sh_chat.lua file and use the `createChatCommand` function.

## ***Developer Functions***
---
## Player:PrettyChatPrint()

### Description

Player meta function that adds a chat message meta to a given users chat box with a given message body. Essentially just a nicer version of ChatPrint. This function is only available on the server realm.

### Arguments

| Data Type 	| Argument Name 	| Description                                                           	|
|-----------	|---------------	|-----------------------------------------------------------------------	|
| Table     	| message       	| The message body                                                      	|

### Examples

```lua
local message = { color_white, "This is a message" }

Player:PrettyChatPrint( message )
```
