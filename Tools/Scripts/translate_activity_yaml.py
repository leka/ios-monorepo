#!/usr/bin/env python3
"""Activity YAML translation tool.

This script translates old activity YAML files (version 1.0.0) to new activity YAML files (version 2.0.0).
"""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import argparse
import sys
import uuid
from pathlib import Path
from typing import Dict, Any, List, Optional
import ruamel.yaml


def create_yaml_object():
    """Create a YAML object with proper formatting."""
    yaml = ruamel.yaml.YAML(typ="rt")
    yaml.indent(mapping=2, sequence=4, offset=2)
    yaml.width = 1024
    yaml.preserve_quotes = True
    yaml.representer.add_representer(
        type(None),
        lambda dumper, data: dumper.represent_scalar("tag:yaml.org,2002:null", "null"),
    )
    return yaml


def load_yaml(filename: Path) -> Dict[str, Any]:
    """Load a YAML file."""
    yaml = create_yaml_object()
    with open(filename, "r", encoding="utf8") as file:
        return yaml.load(file)


def dump_yaml(filename: Path, data: Dict[str, Any]) -> None:
    """Dump a YAML file with proper header."""
    yaml = create_yaml_object()
    
    # Write the header manually
    with open(filename, "w", encoding="utf8") as file:
        file.write("# Leka - iOS Monorepo\n")
        file.write("# Copyright APF France handicap\n") 
        file.write("# SPDX-License-Identifier: Apache-2.0\n")
        file.write("\n")
        yaml.dump(data, file)


# Interface mapping from old to new
INTERFACE_MAPPING = {
    'touchToSelect': 'touchToSelect',
    'robotThenTouchToSelect': 'touchToSelect',
    'listenThenTouchToSelect': 'touchToSelect',
    'observeThenTouchToSelect': 'touchToSelect',
    'dragAndDropIntoZones': 'dragAndDropGridWithZones',
    'robotThenDragAndDropIntoZones': 'dragAndDropGridWithZones',
    'listenThenDragAndDropIntoZones': 'dragAndDropGridWithZones',
    'observeThenDragAndDropIntoZones': 'dragAndDropGridWithZones',
    'dragAndDropToAssociate': 'dragAndDropGrid',
    'robotThenDragAndDropToAssociate': 'dragAndDropGrid',
    'listenThenDragAndDropToAssociate': 'dragAndDropGrid',
    'observeThenDragAndDropToAssociate': 'dragAndDropGrid',
    'dragAndDropInOrder': 'dragAndDropOneToOne',
}

# Gameplay mapping - special case for former drag and drop into zones
FORMER_DRAG_DROP_ZONES_INTERFACES = {
    'dragAndDropIntoZones',
    'robotThenDragAndDropIntoZones',
    'listenThenDragAndDropIntoZones',
    'observeThenDragAndDropIntoZones'
}


def translate_interface(old_interface: str) -> str:
    """Translate old interface to new interface."""
    return INTERFACE_MAPPING.get(old_interface, old_interface)


def translate_gameplay(old_interface: str, old_gameplay: str) -> str:
    """Translate gameplay based on interface and gameplay combination."""
    if old_interface in FORMER_DRAG_DROP_ZONES_INTERFACES and old_gameplay == 'findTheRightAnswers':
        return 'associateCategories'
    return old_gameplay


def translate_choices_for_find_right_answers(choices: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """Translate choices for findTheRightAnswers gameplay."""
    new_choices = []
    for choice in choices:
        new_choice = {
            'value': choice['value'],
            'type': choice['type']
        }
        if choice.get('is_right_answer'):
            new_choice['is_right_answer'] = choice['is_right_answer']
        new_choices.append(new_choice)
    return new_choices


def translate_choices_for_associate_categories(choices: List[Dict[str, Any]], drop_zones: Dict[str, Dict[str, str]]) -> List[Dict[str, Any]]:
    """Translate choices for associateCategories gameplay (former dragAndDropIntoZones)."""
    new_choices = []
    
    # Add dropzones first
    zone_to_category = {}
    category_index = 0
    categories = ['catA', 'catB', 'catC', 'catD']
    
    for zone_key, zone_data in drop_zones.items():
        if category_index < len(categories):
            category = categories[category_index]
            zone_to_category[zone_key.replace('dropZone', 'zone')] = category
            
            new_choice = {
                'value': zone_data['value'],
                'type': zone_data['type'],
                'category': category,
                'is_dropzone': True
            }
            new_choices.append(new_choice)
            category_index += 1
    
    # Add choices with appropriate categories
    for choice in choices:
        new_choice = {
            'value': choice['value'],
            'type': choice['type']
        }
        
        if 'dropZone' in choice:
            drop_zone = choice['dropZone']
            if drop_zone in zone_to_category:
                new_choice['category'] = zone_to_category[drop_zone]
        
        new_choices.append(new_choice)
    
    return new_choices


def translate_choices_for_find_right_order(choices: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """Translate choices for findTheRightOrder gameplay."""
    new_choices = []
    for choice in choices:
        new_choice = {
            'value': choice['value'],
            'type': choice['type']
        }
        # State is optional, defaults to unanswered if missing
        if 'state' in choice:
            new_choice['state'] = choice['state']
        new_choices.append(new_choice)
    return new_choices


def translate_choices_for_open_play(choices: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """Translate choices for openPlay gameplay."""
    new_choices = []
    for choice in choices:
        new_choice = {
            'value': choice['value'],
            'type': choice['type']
        }
        if choice.get('is_dropzone'):
            new_choice['is_dropzone'] = choice['is_dropzone']
        new_choices.append(new_choice)
    return new_choices


def translate_exercise(exercise: Dict[str, Any]) -> Dict[str, Any]:
    """Translate a single exercise from old to new format."""
    new_exercise = {}
    
    # Copy instructions as-is
    if 'instructions' in exercise:
        new_exercise['instructions'] = exercise['instructions']
    
    # Translate interface
    old_interface = exercise.get('interface', '')
    new_interface = translate_interface(old_interface)
    new_exercise['interface'] = new_interface
    
    # Translate gameplay
    old_gameplay = exercise.get('gameplay', '')
    new_gameplay = translate_gameplay(old_interface, old_gameplay)
    new_exercise['gameplay'] = new_gameplay
    
    # Handle action
    if 'action' in exercise:
        new_exercise['action'] = exercise['action']
    
    # Handle options (move shuffle_choices from payload to options)
    options = {}
    
    # Handle special case for dragAndDropOneToOne - always add shuffle_choices: true
    if new_interface == 'dragAndDropOneToOne':
        options['shuffle_choices'] = True
    
    # Handle payload
    if 'payload' in exercise:
        payload = exercise['payload']
        new_payload = {}
        
        # Move shuffle_choices to options if present
        if 'shuffle_choices' in payload:
            options['shuffle_choices'] = payload['shuffle_choices']
        
        # Handle choices based on gameplay
        if 'choices' in payload:
            choices = payload['choices']
            
            if new_gameplay == 'findTheRightAnswers':
                new_payload['choices'] = translate_choices_for_find_right_answers(choices)
                
            elif new_gameplay == 'associateCategories':
                # Handle former dragAndDropIntoZones case
                drop_zones = {}
                for key, value in payload.items():
                    if key.startswith('dropZone'):
                        drop_zones[key] = value
                
                new_payload['choices'] = translate_choices_for_associate_categories(choices, drop_zones)
                
            elif new_gameplay == 'findTheRightOrder':
                new_payload['choices'] = translate_choices_for_find_right_order(choices)
                
            elif new_gameplay == 'openPlay':
                new_payload['choices'] = translate_choices_for_open_play(choices)
                
            else:
                # Default case - copy as-is
                new_payload['choices'] = choices
        
        new_exercise['payload'] = new_payload
    
    # Add options if any were set
    if options:
        new_exercise['options'] = options
    
    return new_exercise


def translate_activity_yaml(input_file: Path, output_file: Path) -> None:
    """Translate an old activity YAML file to new format."""
    print(f"Translating {input_file} -> {output_file}")
    
    # Load old activity
    old_activity = load_yaml(input_file)
    
    # Create new activity structure
    new_activity = {}
    
    # Generate new UUID
    new_uuid = str(uuid.uuid4()).replace('-', '').upper()
    new_activity['uuid'] = new_uuid
    
    # Copy basic fields that remain the same
    for field in ['name', 'created_at', 'last_edited_at', 'status', 'authors', 'skills', 'tags', 'hmi', 'types', 'locales', 'l10n']:
        if field in old_activity:
            new_activity[field] = old_activity[field]
    
    # Update version
    new_activity['version'] = '2.0.0'
    
    # Translate payload
    if 'exercises_payload' in old_activity:
        old_payload = old_activity['exercises_payload']
        new_payload = {}
        
        # Copy options if present
        if 'options' in old_payload:
            new_payload['options'] = old_payload['options']
        
        # Translate exercise groups
        if 'exercise_groups' in old_payload:
            new_exercise_groups = []
            for group in old_payload['exercise_groups']:
                if 'group' in group:
                    new_group = {'group': []}
                    for exercise in group['group']:
                        translated_exercise = translate_exercise(exercise)
                        new_group['group'].append(translated_exercise)
                    new_exercise_groups.append(new_group)
            new_payload['exercise_groups'] = new_exercise_groups
        
        new_activity['payload'] = new_payload
    
    # Save new activity
    dump_yaml(output_file, new_activity)
    print(f"✅ Successfully translated to {output_file}")
    print(f"🆔 New UUID: {new_uuid}")


def main():
    """Main function."""
    parser = argparse.ArgumentParser(
        description='Translate old activity YAML files to new architecture format'
    )
    parser.add_argument(
        'input',
        type=Path,
        help='Input activity YAML file (.activity.yml)'
    )
    parser.add_argument(
        '-o', '--output',
        type=Path,
        help='Output file path (defaults to input_name.new_activity.yml)'
    )
    
    args = parser.parse_args()
    
    if not args.input.exists():
        print(f"❌ Error: Input file {args.input} does not exist")
        sys.exit(1)
    
    if not args.input.name.endswith('.activity.yml'):
        print(f"❌ Error: Input file must end with .activity.yml")
        sys.exit(1)
    
    # Determine output file
    if args.output:
        output_file = args.output
    else:
        # Replace .activity.yml with .new_activity.yml
        output_name = args.input.name.replace('.activity.yml', '.new_activity.yml')
        output_file = args.input.parent / output_name
    
    try:
        translate_activity_yaml(args.input, output_file)
    except Exception as e:
        print(f"❌ Error during translation: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()