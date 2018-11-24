# Cyberpunk 2020 Character Sheet for iOS
A WIP character sheet app for the Cyberpunk 2020 tabletop RPG. The goal of this project is to recreate the functionality of the CP2020 character sheet from pages 27 - 28 in the Cyberpunk 2020 2nd Edition Rulebook.

The character sheet app is planned out for the following phases:

### Phase 1:
#### UI:
- [ ] Character name and Handle
- [ ] Class description
- [ ] Stats
- [x] Damage track
- [ ] Skill list
#### Data layer:
- [ ] Persistence
- [ ] Editable values for each section

### Phase 2:
#### UI:
- [ ] Incoming damage calculator
  - [ ] Standard bullets
  - [ ] AP bullets
  - [ ] Bladed weapons
  - [ ] Monobladed weapons
- [ ] Weapons list
- [ ] Armor list
- [ ] Cyberware list
- [ ] Searchable lists for skills
#### Data layer:
- [ ] Interaction between relevant equipment/stats to calculate damage
- [ ] Skill tooltips to provide dice roll equations

### Phase 3:
#### UI:
- [ ] Lifepath list
- [ ] Custom skill support
#### Data layer:
- [ ] Custom skill importing and exporting via JSON
  - [ ] Importing from web address or Apple Files/iCloud
  - [ ] Exporting to Apple Files/iCloud

## I am not affiliated with R. Talsorian Games or any official Cyberpunk 2020 copyright holders
This is just a fun side project for me to sharpen my iOS dev skills while making a useful utility for my tabletop gaming group. I do not hold any copyright to the Cyberpunk franchise and this is not intended for anything beyond personal use.

## Submitting changes
Currently I'm not accepting any PRs, as this project is intended mostly for practice for myself. This may change in the future, depending on whether this becomes bigger than a little side project.

## Building
Provided you have Xcode 10+, check out the repo and compile via Xcode. This project does not yet have code signing for devices.

## WIP Latest screenshot:
![Latest screenshot as of 11/24](https://raw.githubusercontent.com/krze/CP2020-Character-Sheet/master/Images/latest.png)
