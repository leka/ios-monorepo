# ContentKit Content System

This document describes the educational content system used by the Leka app. All content lives in `Modules/ContentKit/Resources/Content/` and is defined in YAML files.

**Important:** Only the v2 activity format (`.new_activity.yml`, `version: 2.0.0`) is current. The old v1 format (`.activity.yml`, `version: 1.0.0`) is deprecated and will be removed.

## Directory Structure

```
Content/
├── definitions/            # Global taxonomies (skills, tags, authors, etc.)
│   ├── skills.yml          # Hierarchical skill definitions
│   ├── tags.yml            # Flat topic tags
│   ├── authors.yml         # Content author profiles
│   ├── activity_types.yml  # one_on_one, group
│   ├── hmi.yml             # Interaction mediums
│   ├── robot_assets.yml    # Magic card / robot screen asset hex IDs
│   ├── cardAssets/         # Card PNG images per locale (en/, fr/)
│   └── icons/              # Skill icon PNGs
│
├── interaction/            # Icon PNGs for interaction classification
│   ├── attention/          # listen, look, mixed
│   ├── input/              # drag_and_drop, magic_card, touch_to_select, mixed
│   └── medium/             # robot, tablet, tablet_robot
│
├── curations/              # UI layout/navigation files (.curation.yml)
│   ├── home-*.curation.yml
│   ├── explore-*.curation.yml
│   ├── curriculums-*.curation.yml
│   ├── educational_games-*.curation.yml
│   ├── stories-*.curation.yml
│   ├── gamepads-*.curation.yml
│   ├── sandbox-*.curation.yml
│   ├── learning_objectives-*.curation.yml
│   └── subcurations/      # ~30 themed subcurations (animals, emotions, colors, etc.)
│
├── newActivities/          # Standalone/template v2 activities
│   ├── new_standalones/    # Standalone activities (dance_freeze, melody, etc.)
│   ├── new_templates/      # Template activities for reference
│   └── new_gamepads/       # Gamepad controller activities
│
├── curriculums/            # ~70 curriculum directories
│   └── curriculum_<name>-<UUID>/
│       ├── <name>-<UUID>.curriculum.yml
│       ├── new_activities/     # v2 activities belonging to this curriculum
│       │   ├── icons/          # Activity icon PNGs
│       │   └── assets/         # Activity asset PNGs
│       └── activities/         # DEPRECATED v1 activities (ignore)
│
└── stories/                # Interactive story files (.story.yml)
```

## ID and Reference System

Every content item has an ID in the format: `<human_readable_name>-<32_CHAR_HEX_UUID>`

Examples:
- `curriculum_recognition_body_parts-80761A1D62BF4C6980BF20E7D9BE52B8`
- `recognition_body_parts_1-756B84801C32483FABEA6E5BC5DF7081`
- `dance_freeze-6E2F7D56726C419EA534C614F777D934`

The UUID is a 32-character uppercase hex string (no hyphens). File names follow the same pattern: `<name>-<UUID>.<type>.yml`.

### Reference Chain

```
Curation --[items.value]--> Curriculum | Activity | Curation (subcuration)
Curriculum --[activities]--> Activity (by name-UUID)
Story --[pages.items.action]--> Activity (inline) | Robot actions
Activity --[authors]--> authors.yml IDs
Activity --[skills]--> skills.yml IDs (slash-path like "sensory_integration/vision")
Activity --[tags]--> tags.yml IDs
Activity --[types]--> activity_types.yml IDs
Activity --[interaction.medium]--> hmi.yml IDs
```

## Localization (l10n)

All content supports two locales: `fr_FR` and `en_US`. Localized data appears in `l10n` arrays:

```yaml
l10n:
  - locale: fr_FR
    details:
      title: Les parties du corps
      subtitle: 1 image
      ...
  - locale: en_US
    details:
      title: Body Parts
      subtitle: 1 image
      ...
```

## YAML File Header

All YAML files must start with:

```yaml
# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0
```

---

## Activity Schema (v2 - `.new_activity.yml`)

```yaml
version: 2.0.0

uuid: <32_CHAR_HEX_UUID>
name: <snake_case_name>

created_at: "<ISO8601_timestamp>"
last_edited_at: "<ISO8601_timestamp>"
status: published              # published | draft | template

authors:
  - leka                       # References authors.yml

skills:                        # References skills.yml (slash-path for subskills)
  - recognition
  - sensory_integration/vision

tags:                          # References tags.yml
  - body_parts

interaction:
  medium: tablet               # tablet | robot | tablet_robot
  input: touch_to_select       # touch_to_select | drag_and_drop | magic_card | mixed
  attention: listen             # listen | look | mixed (optional)

types:
  - one_on_one                 # one_on_one | group

locales:
  - en_US
  - fr_FR

l10n:
  - locale: fr_FR
    details:
      icon: <icon_image_name>  # PNG filename (no extension) in icons/
      title: <string>
      subtitle: <string>
      short_description: |
        <string>
      description: |
        <string>
      instructions: |
        <string>
  - locale: en_US
    details: ...

payload:
  options:
    shuffle_exercises: true    # Shuffle order of exercises
    shuffle_groups: false      # Shuffle order of exercise groups

  exercise_groups:
    - group:
        - <exercise>           # See Exercise Schema below
        - <exercise>
    - group:
        - <exercise>
```

### Exercise Schema

Each exercise within a group has this structure:

```yaml
instructions:                  # Optional, per-locale instructions for this exercise
  - locale: fr_FR
    value: <instruction text>
  - locale: en_US
    value: <instruction text>

interface: <interface_name>    # See Interface Types below
gameplay: <gameplay_name>      # See Gameplay Types below

action:                        # Optional, triggered action
  type: ipad | robot
  value:
    type: speech | color | motion | random | activity
    value: <action_value>      # Speech: l10n utterances, Color: color name, etc.

options:                       # Optional
  shuffle_choices: true

payload:
  choices:                     # For general interfaces
    - value: <string>          # Image name, emoji, SF Symbol, or color name
      type: image | emoji | sfsymbol | color
      is_right_answer: true    # Optional, marks correct answer
      is_dropzone: true        # Optional, for drag-and-drop zones
      category: catA           # Optional, for association/memory (catA, catB, catC...)
      dropZone: zoneA          # Optional, target zone for drag-and-drop
  songs:                       # For danceFreeze interface
    - audio: <filename>
      labels:
        - locale: fr_FR
          value:
            name: <display name>
            icon: <icon name>
```

### Interface Types

**General (tablet-based):**
- `touchToSelect` - Tap the correct choice from options
- `dragAndDropIntoZones` - Drag items into labeled drop zones
- `dragAndDropGrid` - Drag items into a grid layout
- `dragAndDropOneToOne` - Drag items to order them sequentially
- `dragAndDropGridWithZones` - Grid-based drag with category zones
- `memory` - Flip cards to find matching pairs
- `magicCards` - Use physical NFC magic cards scanned by robot

**Specialized (robot-integrated):**
- `danceFreeze` - Robot dances to music, freezes randomly
- `superSimon` - Simon Says color memory game with robot LEDs
- `hideAndSeek` - Robot plays hide and seek with sound/light
- `melody` - Music creation/playback
- `musicalInstruments` - Xylophone (pentatonic/heptatonic)
- `colorMusicPad` - Color-sound association pad
- `colorMediator` - Robot lights up colors for group games
- `gamepadArrowPad` - Directional control of robot movement
- `gamepadColorPad` - Color-button control of robot
- `gamepadJoyStickColorPad` - Joystick + color control
- `gamepadArrowPadColorPad` - Arrow + color pad combined
- `pairing` - Pairing interaction
- `discoverLeka` - Introduction to the robot

### Gameplay Types

- `findTheRightAnswers` - Select correct answers from choices
- `findTheRightOrder` - Arrange items in correct sequence
- `associateCategories` - Match items by category (used with memory, drag-and-drop zones)
- `openPlay` - Free play without scoring

### Choice Types

- `image` - PNG asset reference (filename without extension, located in curriculum's assets/)
- `emoji` - Unicode emoji character (e.g., `🍌`)
- `sfsymbol` - SF Symbols name (e.g., `circle`, `square`)
- `color` - Color name (e.g., `red`, `yellow`, `blue`, `green`, `pink`)

### Action Types

**iPad actions:**
```yaml
action:
  type: ipad
  value:
    type: speech
    value:
      - locale: fr_FR
        utterance: "le bras"
      - locale: en_US
        utterance: "the arm"
```

**Robot actions:**
```yaml
action:
  type: robot
  value:
    type: color        # color | motion | random
    value: blue        # color name, motion name, or "color"
```

---

## Curriculum Schema (`.curriculum.yml`)

```yaml
uuid: <32_CHAR_HEX_UUID>
name: curriculum_<topic>
status: published              # published | draft | template

created_at: "<ISO8601_timestamp>"
last_edited_at: "<ISO8601_timestamp>"

authors:
  - leka

skills:
  - recognition

tags:
  - body_parts

locales:
  - en_US
  - fr_FR

l10n:
  - locale: fr_FR
    details:
      icon: <icon_name>
      title: <string>
      subtitle: <string>
      abstract: |
        <string>
      description: |
        <string>
  - locale: en_US
    details: ...

activities:                    # Ordered list of activity name-UUID references
  - <activity_name>-<UUID>
  - <activity_name>-<UUID>
```

Curriculums live in `curriculums/curriculum_<name>-<UUID>/` directories. Their activities live in the `new_activities/` subdirectory within.

---

## Story Schema (`.story.yml`)

```yaml
version: 1.0.0

uuid: <32_CHAR_HEX_UUID>
name: <story_name>

created_at: "<ISO8601_timestamp>"
last_edited_at: "<ISO8601_timestamp>"
status: published

authors:
  - hanna_and_nagib
  - leka

skills:
  - familiarization_with_leka

interaction:
  medium: tablet_robot
  input: touch_to_select

types:
  - one_on_one

tags:
  - hanna
  - story

locales:
  - en_US
  - fr_FR

l10n:
  - locale: fr_FR
    details:
      icon: <icon_name>
      title: <string>
      subtitle: <string>
      short_description: |
        <string>
      description: |
        <string>
      instructions: |
        <string>
  - locale: en_US
    details: ...

pages:
  - background: <background_image_name>
    l10n:
      - locale: fr_FR
        items:
          - type: text               # text | image | button_image
            payload:
              text: "Some text"
          - type: button_image
            payload:
              idle: <image_name>     # Image when not pressed
              pressed: <image_name>  # Image when pressed
              text: <label>
              action:                # Optional robot/iPad action on press
                type: robot
                value:
                  type: motion
                  value: spin
          - type: image
            payload:
              image: <image_name>
              size: 700
              text: <alt text>
```

---

## Curation Schema (`.curation.yml`)

Curations define the UI layout and content organization for app navigation.

```yaml
uuid: <32_CHAR_HEX_UUID>
icon: <sf_symbol_name>         # SF Symbol for the tab/section
color: 0xFFEEFF               # Hex color

l10n:
  - locale: fr_FR
    details:
      title: <string>
      subtitle: <string>
      description: <string>
  - locale: en_US
    details: ...

content:
  - component: <component_type>
    l10n:
      - locale: fr_FR
        details:
          title: <section title>
          subtitle:
          description: <section description>
    items:
      - value: <name>-<UUID>   # References a curriculum, activity, or curation
        type: curriculum | activity | curation
```

### Component Types (layout widgets)

- `carousel` - Featured content carousel
- `horizontal_curriculum_grid` - Horizontal scrolling grid of curriculums
- `horizontal_activity_grid` - Horizontal scrolling grid of activities
- `horizontal_curriculum_list` - Horizontal scrolling list of curriculums
- `horizontal_activity_list` - Horizontal scrolling list of activities
- `horizontal_curation_list` - Horizontal scrolling list of subcurations
- `vertical_curriculum_grid` - Vertical grid of curriculums
- `vertical_activity_grid` - Vertical grid of activities
- `vertical_curation_grid` - Vertical grid of subcurations

### Curation Hierarchy

- **Top-level tabs:** home, explore, curriculums, educational_games, stories, gamepads, sandbox, learning_objectives
- **Explore** references subcurations (animals, emotions, colors, etc.)
- **Subcurations** group related curriculums and activities by theme
- Content can appear in multiple curations

---

## Global Definitions

### Skills (`definitions/skills.yml`)

Hierarchical taxonomy. Top-level skills include: association, attention, communication, counting, discrimination, emotion_recognition, empathy, familiarization_with_leka, fine_motor_skills, generalization, gross_motor_skills, inhibition, memory, recognition, relationship_tablet_robot, self_awareness, self_regulation, sensory_integration (hearing/touch/vision), social_interactions, spatial_understanding, time_and_temporality_understanding, turn_taking.

Subskills use slash-path notation: `association/matching`, `sensory_integration/vision`.

### Tags (`definitions/tags.yml`)

Flat topic tags: animals, colors, emotions, food, body_parts, music, alphabet_letters, shapes, weather, professions, sports, etc.

### Authors (`definitions/authors.yml`)

Content author profiles with name, website, email, professions, and l10n descriptions.

### Activity Types (`definitions/activity_types.yml`)

Two types: `one_on_one` and `group`.

### HMI (`definitions/hmi.yml`)

Four interaction mediums: `robot`, `magic_cards`, `tablet_robot`, `tablet`.

### Robot Assets (`definitions/robot_assets.yml`)

Hex-ID-to-name mapping for physical robot screen assets (magic cards). IDs range from `0x0001` to `0x00DB`.

---

## Swift Data Models

The Swift models that decode this content live in `Modules/ContentKit/Sources/Content/_NewSystem/`. Key files:

- `Activity/Activity.swift` - Main activity model
- `Curriculum/Curriculum.swift` - Curriculum model
- `Story/Story.swift` - Story model
- `Exercise/Exercise.swift` - Exercise model
- `Exercise/Exercise+Interface.swift` - Interface enum (GeneralInterface / SpecializedInterface)
- `Exercise/Exercise+Gameplay.swift` - Gameplay enum
- `Models/Interaction.swift` - Interaction struct (medium, input, attention)
- `Models/Skills.swift`, `Models/Tags.swift`, `Models/Authors.swift` - Definition models
- `Categories/Category+Curation.swift` - Curation model

Content is loaded at startup via `ContentKit.swift` by scanning `Bundle.module` for YAML files by extension, decoded with `YAMLDecoder` (Yams library), and stored in static dictionaries keyed by UUID.
