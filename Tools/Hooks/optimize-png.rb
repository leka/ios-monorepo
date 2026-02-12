#!/usr/bin/env ruby
# frozen_string_literal: true

###############################################
# Optimize PNG images: resize + lossless optimize
#
# 1. Resizes images: <800px → 400x400, >=800px → 800x800 (*.icon.png always → 400x400)
# 2. Lossless optimization with oxipng (strip metadata)
# 3. Optionally lossy compression with pngquant (--lossy)
#
# Usage:
#   ./optimize-png.rb <directory>           # Process all PNGs in directory
#   ./optimize-png.rb <file1> <file2> ...   # Process specific files
#   ./optimize-png.rb --dry-run <path>
#   ./optimize-png.rb --lossy <path>
#   ./optimize-png.rb --verbose <path>
#   ./optimize-png.rb --warnings <path>
#   ./optimize-png.rb --force <path>
#   ./optimize-png.rb --list-non-square <path>
#
# Images with non-square aspect ratios are skipped by default.
###############################################

require "optparse"
require "fileutils"

# Configuration
TARGET_SIZE_SMALL = 400
TARGET_SIZE_LARGE = 800
TARGET_SIZE_THRESHOLD = 800 # dimensions >= threshold → resize to LARGE, otherwise SMALL
CROP_TOLERANCE = 10 # if within this many pixels of target, crop instead of resize
ASPECT_RATIO_TOLERANCE = 0.05 # 5% tolerance (e.g., 401x400 is OK)
OXIPNG_LEVEL = 2 # optimization level (0-6, default 2)
PNGQUANT_QUALITY = "85-100"

# Parse command line options
options = {
  dry_run: false,
  verbose: false,
  warnings: false,
  force: false,
  lossy: false,
}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [options] <directory|files...>"

  opts.on("--dry-run", "Preview without modifying files") do
    options[:dry_run] = true
  end

  opts.on("-v", "--verbose", "Show all files (including skipped)") do
    options[:verbose] = true
    options[:warnings] = true
  end

  opts.on("-w", "--warnings", "Show non-square aspect ratio warnings") do
    options[:warnings] = true
  end

  opts.on("-f", "--force", "Force resize non-square images") do
    options[:force] = true
    options[:warnings] = true
  end

  opts.on("-l", "--lossy", "Also apply lossy compression with pngquant") do
    options[:lossy] = true
  end

  opts.on("--list-non-square", "List images that are not 1:1 (or close) and exit") do
    options[:list_non_square] = true
  end

  opts.on("-h", "--help", "Show this help") do
    puts opts
    exit
  end
end

parser.parse!

if ARGV.empty?
  puts parser.banner
  exit 1
end

# Check dependencies
unless system("which magick > /dev/null 2>&1")
  puts "Error: magick not found. Install with: brew install imagemagick"
  exit 1
end

unless options[:list_non_square]
  unless system("which oxipng > /dev/null 2>&1")
    puts "Error: oxipng not found. Install with: brew install oxipng"
    exit 1
  end

  if options[:lossy] && !system("which pngquant > /dev/null 2>&1")
    puts "Error: pngquant not found. Install with: brew install pngquant"
    exit 1
  end
end

# Determine if input is a directory or file list
input_paths = ARGV
is_directory_mode = ARGV.length == 1 && Dir.exist?(ARGV[0])

# Helper methods
def get_dimensions(path)
  output = `magick identify -format "%w %h" "#{path}" 2>/dev/null`
  parts = output.strip.split
  return [nil, nil] if parts.length < 2

  [parts[0].to_i, parts[1].to_i]
end

def file_size_kb(path)
  (File.size(path) / 1024.0).round
end

def resize_image(path, size)
  system("magick \"#{path}\" -resize #{size}x#{size} \"#{path}\"")
end

def crop_image(path, size)
  system("magick \"#{path}\" -gravity center -crop #{size}x#{size}+0+0 +repage \"#{path}\"")
end

def should_crop?(width, height, target)
  (width - target).abs <= CROP_TOLERANCE && (height - target).abs <= CROP_TOLERANCE
end

def optimize_image(path, level)
  system("oxipng -o #{level} --strip safe -q \"#{path}\"")
end

def lossy_compress_image(path, quality)
  system("pngquant --quality=#{quality} --speed 1 --ext .png --force \"#{path}\" 2>/dev/null")
end

def is_nearly_square?(width, height, tolerance)
  ratio = [width, height].max.to_f / [width, height].min
  (ratio - 1).abs <= tolerance
end

def icon_file?(path)
  File.basename(path).end_with?(".icon.png")
end

def target_size_for(width, height, path = nil)
  return TARGET_SIZE_SMALL if path && icon_file?(path)

  max_dim = [width, height].max
  max_dim >= TARGET_SIZE_THRESHOLD ? TARGET_SIZE_LARGE : TARGET_SIZE_SMALL
end

# Print header
puts "🚀 PNG Optimization Script"
puts "   Target sizes: #{TARGET_SIZE_SMALL}x#{TARGET_SIZE_SMALL} (<#{TARGET_SIZE_THRESHOLD}px) / #{TARGET_SIZE_LARGE}x#{TARGET_SIZE_LARGE} (>=#{TARGET_SIZE_THRESHOLD}px) / *.icon.png always #{TARGET_SIZE_SMALL}x#{TARGET_SIZE_SMALL}"
puts "   Aspect ratio tolerance: #{ASPECT_RATIO_TOLERANCE} (#{(ASPECT_RATIO_TOLERANCE * 100).round}%)" if options[:verbose]
puts "   Mode: DRY RUN (no files will be modified)" if options[:dry_run]
puts "   Optimization: oxipng (lossless, level #{OXIPNG_LEVEL}, strip metadata)"
puts "   Lossy compression: pngquant (quality #{PNGQUANT_QUALITY})" if options[:lossy]
puts "   Force non-square: YES" if options[:force]
puts

# Find PNG files
if is_directory_mode
  search_dir = ARGV[0]
  puts "🔍 Searching in: #{search_dir}"
  puts
  files = Dir.glob(File.join(search_dir, "**", "*.png")).sort
else
  puts "🔍 Processing #{input_paths.length} file(s)"
  puts
  files = input_paths.select { |f| f.end_with?(".png") && File.exist?(f) }
end

if files.empty?
  puts "No PNG files found"
  exit 0
end

puts "📦 Found #{files.length} PNG files"
puts

# --list-non-square mode: report and exit
if options[:list_non_square]
  non_square = []

  files.each do |path|
    width, height = get_dimensions(path)
    next if width.nil? || height.nil?
    next if is_nearly_square?(width, height, ASPECT_RATIO_TOLERANCE)

    ratio = [width, height].max.to_f / [width, height].min
    non_square << { path: path, width: width, height: height, ratio: ratio }
  end

  if non_square.empty?
    puts "✅ All #{files.length} images have a 1:1 (or close) aspect ratio"
  else
    puts "⚠️  Found #{non_square.length} non-square image(s) (tolerance: #{(ASPECT_RATIO_TOLERANCE * 100).round}%):"
    puts
    non_square.each do |img|
      puts "   #{img[:width]}x#{img[:height]} (ratio=#{img[:ratio].round(2)}) #{img[:path]}"
    end
  end

  exit non_square.empty? ? 0 : 1
end

# Counters
stats = {
  already_correct: 0,
  resized: 0,
  skipped_non_square: 0,
  skipped_smaller: 0,
  forced_non_square: 0,
  failed: 0,
  total_original_kb: 0,
  total_final_kb: 0,
}

# Process each file
files.each do |path|
  filename = File.basename(path)
  width, height = get_dimensions(path)

  if width.nil? || height.nil?
    puts "⚠️  Could not read dimensions: #{filename}"
    stats[:failed] += 1
    next
  end

  original_kb = file_size_kb(path)
  stats[:total_original_kb] += original_kb

  target = target_size_for(width, height, path)

  # Check if already correct size
  if width == target && height == target
    puts "✓  Already #{target}x#{target}: #{filename}" if options[:verbose]
    stats[:already_correct] += 1

    # Optimize even if already correct size
    unless options[:dry_run]
      optimize_image(path, OXIPNG_LEVEL)
      lossy_compress_image(path, PNGQUANT_QUALITY) if options[:lossy]
    end

    stats[:total_final_kb] += file_size_kb(path)
    next
  end

  # Check if smaller than target (don't upscale)
  if width < target && height < target
    puts "⏭️  Smaller than target (#{width}x#{height}): #{filename}" if options[:verbose]
    stats[:skipped_smaller] += 1
    stats[:total_final_kb] += original_kb
    next
  end

  # Check aspect ratio
  unless is_nearly_square?(width, height, ASPECT_RATIO_TOLERANCE)
    ratio = [width, height].max.to_f / [width, height].min

    if options[:force]
      if options[:warnings]
        puts "⚠️  Non-square aspect ratio (#{width}x#{height}, ratio=#{ratio.round(2)}): #{filename}"
        puts "   → Forcing resize due to --force flag"
      end
      stats[:forced_non_square] += 1
      # Continue to resize below
    else
      puts "⚠️  Non-square aspect ratio (#{width}x#{height}, ratio=#{ratio.round(2)}): #{filename}" if options[:warnings]
      stats[:skipped_non_square] += 1
      stats[:total_final_kb] += original_kb
      next
    end
  end

  # Determine if we should crop or resize
  use_crop = should_crop?(width, height, target)
  action = use_crop ? "Cropping" : "Resizing"

  puts "🔧 #{action}: #{filename}"
  puts "   Original: #{width}x#{height} (#{original_kb} KB)"

  if options[:dry_run]
    puts "   → Would #{use_crop ? "crop" : "resize"} to #{target}x#{target}"
    stats[:total_final_kb] += original_kb
  else
    success = use_crop ? crop_image(path, target) : resize_image(path, target)

    if success
      after_resize_kb = file_size_kb(path)

      # Lossless optimization
      optimize_image(path, OXIPNG_LEVEL)
      after_optimize_kb = file_size_kb(path)

      # Lossy compression if enabled
      if options[:lossy]
        lossy_compress_image(path, PNGQUANT_QUALITY)
      end

      final_kb = file_size_kb(path)
      stats[:total_final_kb] += final_kb
      saved = original_kb - final_kb

      puts "   → #{use_crop ? "Cropped" : "Resized"} to #{target}x#{target}"
      if options[:lossy]
        puts "   → #{action}: #{after_resize_kb} KB → optimize: #{after_optimize_kb} KB → lossy: #{final_kb} KB (saved #{saved} KB)"
      else
        puts "   → #{action}: #{after_resize_kb} KB → optimize: #{final_kb} KB (saved #{saved} KB)"
      end
      stats[:resized] += 1
    else
      puts "   → ❌ Failed to #{use_crop ? "crop" : "resize"}"
      stats[:failed] += 1
      stats[:total_final_kb] += original_kb
    end
  end
  puts
end

# Summary
puts
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "📊 Summary:"
puts "   Resized:              #{stats[:resized]}"
puts "   Forced (non-square):  #{stats[:forced_non_square]}" if stats[:forced_non_square] > 0
puts "   Already correct size: #{stats[:already_correct]}" if options[:verbose] || stats[:already_correct] > 0
puts "   Skipped (non-square): #{stats[:skipped_non_square]}" if options[:verbose] || stats[:skipped_non_square] > 0
puts "   Skipped (too small):  #{stats[:skipped_smaller]}" if options[:verbose] || stats[:skipped_smaller] > 0
puts "   Failed:               #{stats[:failed]}" if stats[:failed] > 0
puts
puts "   Original total: #{stats[:total_original_kb]} KB (#{stats[:total_original_kb] / 1024} MB)"
puts "   Final total:    #{stats[:total_final_kb]} KB (#{stats[:total_final_kb] / 1024} MB)"
if stats[:total_original_kb] > 0
  total_saved = stats[:total_original_kb] - stats[:total_final_kb]
  percent_saved = (total_saved * 100.0 / stats[:total_original_kb]).round
  puts "   Space saved:    #{total_saved} KB (#{total_saved / 1024} MB / #{percent_saved}%)"
end
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts
puts "✅ Done!"
