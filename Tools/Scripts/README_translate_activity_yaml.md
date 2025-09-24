# Activity YAML Translation Tool

This tool translates old activity YAML files (version 1.0.0) to the new activity YAML architecture (version 2.0.0).

## Usage

### Single File Translation

```bash
python3 Tools/Scripts/translate_activity_yaml.py path/to/activity.activity.yml
```

This will create `activity.new_activity.yml` in the same directory.

### Custom Output Path

```bash
python3 Tools/Scripts/translate_activity_yaml.py input.activity.yml -o output.new_activity.yml
```

### Batch Processing

Process all `.activity.yml` files in a directory recursively:

```bash
python3 Tools/Scripts/translate_activity_yaml.py path/to/directory --batch
```

### Batch Processing with Custom Output Directory

```bash
python3 Tools/Scripts/translate_activity_yaml.py input_dir --batch -o output_dir
```

### Options

- `--batch`: Process all `.activity.yml` files recursively
- `--skip-existing`: Skip files that already have a corresponding `.new_activity.yml` file  
- `--dry-run`: Show what would be processed without actually translating files
- `-o, --output`: Specify output file or directory

## Key Transformations

### Interface Mapping
- `touchToSelect`, `robotThenTouchToSelect`, `listenThenTouchToSelect`, `observeThenTouchToSelect` → `touchToSelect`
- `dragAndDropIntoZones`, `robotThenDragAndDropIntoZones`, `listenThenDragAndDropIntoZones`, `observeThenDragAndDropIntoZones` → `dragAndDropGridWithZones`  
- `dragAndDropToAssociate`, `robotThenDragAndDropToAssociate`, `listenThenDragAndDropToAssociate`, `observeThenDragAndDropToAssociate` → `dragAndDropGrid`
- `dragAndDropInOrder` → `dragAndDropOneToOne`

### Special Cases
- Former `dragAndDropIntoZones` interfaces with `findTheRightAnswers` gameplay → `associateCategories` gameplay
- `dragAndDropOneToOne` interface automatically gets `shuffle_choices: true` in options
- `shuffle_choices` moves from payload to options section

### Choice Models
The tool automatically converts choice models based on the interface+gameplay combination:

- **findTheRightAnswers**: `value`, `type`, `is_right_answer` (optional)
- **associateCategories**: `value`, `type`, `is_dropzone` (optional), `category` (optional)  
- **findTheRightOrder**: `value`, `type`, `state` (optional)
- **openPlay**: `value`, `type`, `is_dropzone` (optional)

### Version & Metadata Changes
- Version: `1.0.0` → `2.0.0`
- UUID: New UUID generated for each translation
- Key rename: `exercises_payload` → `payload`

## Examples

### Before (dragAndDropIntoZones + findTheRightAnswers)
```yaml
interface: observeThenDragAndDropIntoZones
gameplay: findTheRightAnswers
payload:
  dropZoneA:
    value: dropzone_kitchen
    type: image
  dropZoneB: 
    value: dropzone_bedroom
    type: image
  choices:
    - value: pictograms-foods-fruits-banana_yellow-00FB
      type: image
      dropZone: zoneB
```

### After
```yaml
interface: dragAndDropGridWithZones
gameplay: associateCategories
payload:
  choices:
    - value: dropzone_kitchen
      type: image
      category: catA
      is_dropzone: true
    - value: dropzone_bedroom
      type: image
      category: catB
      is_dropzone: true
    - value: pictograms-foods-fruits-banana_yellow-00FB
      type: image
      category: catB
```

## Error Handling

The tool includes validation to:
- Ensure input files are version 1.0.0
- Check that input files use the old `exercises_payload` structure
- Prevent accidental processing of already-translated files