#!/usr/bin/env ruby
# frozen_string_literal: true

###############################################
# Optimize PNG images: resize (+ optional compress)
#
# 1. Resizes images to TARGET_SIZE (default 400x400)
# 2. Optionally compresses with pngquant (--compress)
#
# Usage:
#   ./optimize-png.rb <directory>           # Process all PNGs in directory
#   ./optimize-png.rb <file1> <file2> ...   # Process specific files
#   ./optimize-png.rb --dry-run <path>
#   ./optimize-png.rb --compress <path>
#   ./optimize-png.rb --verbose <path>
#   ./optimize-png.rb --warnings <path>
#   ./optimize-png.rb --force <path>
#
# Images with non-square aspect ratios are skipped by default.
###############################################

require "optparse"
require "fileutils"

# Configuration
TARGET_SIZE = 400
ASPECT_RATIO_TOLERANCE = 0.05 # 5% tolerance (e.g., 401x400 is OK)
QUALITY = "85-100"

# Parse command line options
options = {
  dry_run: false,
  verbose: false,
  warnings: false,
  force: false,
  compress: false,
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

  opts.on("-c", "--compress", "Also compress with pngquant after resize") do
    options[:compress] = true
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
unless system("which sips > /dev/null 2>&1")
  puts "Error: sips not found (should be built into macOS)"
  exit 1
end

if options[:compress] && !system("which pngquant > /dev/null 2>&1")
  puts "Error: pngquant not found. Install with: brew install pngquant"
  exit 1
end

# Determine if input is a directory or file list
input_paths = ARGV
is_directory_mode = ARGV.length == 1 && Dir.exist?(ARGV[0])

# Helper methods
def get_dimensions(path)
  output = `sips -g pixelWidth -g pixelHeight "#{path}" 2>/dev/null`
  width = output[/pixelWidth:\s*(\d+)/, 1]&.to_i
  height = output[/pixelHeight:\s*(\d+)/, 1]&.to_i
  [width, height]
end

def file_size_kb(path)
  (File.size(path) / 1024.0).round
end

def resize_image(path, size)
  system("sips --resampleHeightWidth #{size} #{size} \"#{path}\" > /dev/null 2>&1")
end

def compress_image(path, quality)
  system("pngquant --quality=#{quality} --speed 1 --ext .png --force \"#{path}\" 2>/dev/null")
end

def is_nearly_square?(width, height, tolerance)
  ratio = [width, height].max.to_f / [width, height].min
  (ratio - 1).abs <= tolerance
end

# Print header
puts "🚀 PNG Optimization Script"
puts "   Target size: #{TARGET_SIZE}x#{TARGET_SIZE}"
puts "   Aspect ratio tolerance: #{ASPECT_RATIO_TOLERANCE} (#{(ASPECT_RATIO_TOLERANCE * 100).round}%)" if options[:verbose]
puts "   Mode: DRY RUN (no files will be modified)" if options[:dry_run]
puts options[:compress] ? "   Compression: pngquant (quality #{QUALITY})" : "   Compression: OFF (use --compress to enable)"
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

  # Check if already correct size
  if width == TARGET_SIZE && height == TARGET_SIZE
    puts "✓  Already #{TARGET_SIZE}x#{TARGET_SIZE}: #{filename}" if options[:verbose]
    stats[:already_correct] += 1

    # Compress if enabled
    if options[:compress] && !options[:dry_run]
      compress_image(path, QUALITY)
    end

    stats[:total_final_kb] += file_size_kb(path)
    next
  end

  # Check if smaller than target (don't upscale)
  if width < TARGET_SIZE && height < TARGET_SIZE
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

  # Resize the image
  puts "🔧 Resizing: #{filename}"
  puts "   Original: #{width}x#{height} (#{original_kb} KB)"

  if options[:dry_run]
    puts "   → Would resize to #{TARGET_SIZE}x#{TARGET_SIZE}"
    stats[:total_final_kb] += original_kb
  else
    if resize_image(path, TARGET_SIZE)
      after_resize_kb = file_size_kb(path)

      # Compress with pngquant if enabled
      compress_image(path, QUALITY) if options[:compress]

      final_kb = file_size_kb(path)
      stats[:total_final_kb] += final_kb
      saved = original_kb - final_kb

      puts "   → Resized to #{TARGET_SIZE}x#{TARGET_SIZE}"
      if options[:compress]
        puts "   → After resize: #{after_resize_kb} KB, after compress: #{final_kb} KB (saved #{saved} KB)"
      else
        puts "   → Final: #{final_kb} KB (saved #{saved} KB)"
      end
      stats[:resized] += 1
    else
      puts "   → ❌ Failed to resize"
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
puts "   Already #{TARGET_SIZE}x#{TARGET_SIZE}: #{stats[:already_correct]}" if options[:verbose] || stats[:already_correct] > 0
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
