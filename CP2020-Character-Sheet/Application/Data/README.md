# Skills JSON structure
`Skills.json` contains an array of skills representing the skills included in the Cyberpunk 2020 v2 (3002) Rulebook. Each item in the array is a JSON that conforms to the Swift `Codable` complient class `Skill`. This is a read-only class. Each `Skill` represents only the model of the skill, and not the skill's relationship to the character.

The structure of a `Skill` object in JSON format is as follows:

```
{
    "name": "Combat Sense",
    "name_extension": null,
    "linked_stat": null,
    "modifies_skill": "Awareness\/Notice",
    "ip_multiplier": 1,
    "description": "This ability is based on the Solo's constant training and professionalism. Combat Sense allows the Solo to perceive danger, notice traps, and have an almost unearthly ability to avoid harm. Your Combat Sense gives you a bonus on both your Awareness skill and your Initiative equal to your level in the Combat Sense skill.",
    "special_ability": true
}
```

Here's a guide to each field. Even though Swift `Codable` will still successfully decode a JSON objects that omit fields that can be `null`, please include `null` values for optional fields. Do not omit fields that are optional:

### "name": String
This is the name of the skill. Self-explanatory. Examples of this would be "Combat Sense", "Awareness/Notice", or "Expert"

### "name_extension": String?
This is appended to the skill name in the case where a skill has a specific sub-category or descriptor. This is appended to the `name` after a colon and a space. An example of this would be the "Russian" in "Language: Russian", or "Quantum Physics" in "Expert: Quantum Physics".

This may be `null`.

### "linked_stat": String?
The stat which is linked to the skill. The points in the character's stat is added to the skill roll. In the book, skills are divided into categories by stat (i.e. "Intelligence Skills" on pg. 48)

Examples of this string would be "Reflex", which is linked to skills such as "Handgun". This string is expected to be one of the following strings from this list:

```
Intelligence
Tech
Cool
Reflex
Attractiveness
Body
Empathy
```

This value may also be `null`, as some Special Abilities do not have a supplemental stat added to the skill roll.

### "modifies_skill": String?
This is a case-sensitive string, representing a top-down relationship to another skill that is modified by this skill. The only example of this in the standard Cyberpunk 2020 skills is "Combat Sense", which modifies "Awareness/Notice" by adding the "Combat Sense" value to "Awareness/Notice".

Even though there's only one case for this, I'm leaving this field available for future support of custom skills.

This field may be `null`, and likely will be `null`.

### "ip_multiplier": Int
The multiplier factored into the calculation that determines how many Improvement Points are necessary to level up the skill. Most skills have a value of `1`. Some skills, like `Stealth`, have a value `>1`. Examples of skills that have >1 multipliers are `Stealth (2)`, `Martial Arts: Akido (3)`, and `Cyberdeck Design (2)`.

### "description": String
The description of the skill. The descriptions are available in the rulebook, and usually explain how the skill is used.

### "special_ability": Bool
Whether or not the skill is a special ability.
