# **Chat Module**

## ***Developer Functions***
---
## Player:PrettyChatPrint()

### Description

Player meta function that adds a chat message meta to a given users chat box with a given title and message body. Essentially just a nicer version of ChatPrint. This function is only available on the server realm.

### Arguments

| Data Type 	| Argument Name 	| Description                                                           	|
|-----------	|---------------	|-----------------------------------------------------------------------	|
| String    	| title         	| The title to appear for the message. This will be in square brackets. 	|
| String    	| message       	| The message body                                                      	|

### Examples

```lua
Player:PrettyChatPrint("GAMEMODE", "This is a message from the gamemode.")
```