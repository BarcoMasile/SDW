# SDW

Simple tool to create a session in tmux with as many screens as url to download from.

You just pipe url string from stdin. In case of magnet urls, aria2c will be used.
Otherwise the choice falls on youtube-dl


### Requirements
- aria2c
- youtube-dl
- ruby
- 'colorize' gem for ruby
- bash
