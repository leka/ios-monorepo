#!/usr/bin/python3
"""Get clean git log to be used for TestFlight notes and Slack"""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import argparse
import re
import subprocess
import sys


def parse_arguments():
    """Parse command line arguments for release note generation."""
    parser = argparse.ArgumentParser(
        prog="Git log to release notes",
        description="Get clean git log to be used for TestFlight notes and Slack",
    )

    parser.add_argument(
        "-r",
        "--remove-emojis",
        action="store_true",
        default=False,
        help="Remove emojis from the git log",
    )

    parser.add_argument(
        "-f", "--first-commit", help="First commit of the release", required=True
    )

    parser.add_argument(
        "-l", "--last-commit", help="Last commit of the release", required=True
    )

    return parser.parse_args()


def remove_emojis(text):
    """Remove emojis and other non-ASCII characters from text."""
    emoji_pattern = re.compile(
        "["
        "\U0001F600-\U0001F64F"  # emoticons
        "\U0001F300-\U0001F5FF"  # symbols & pictographs
        "\U0001F680-\U0001F6FF"  # transport & map symbols
        "\U0001F700-\U0001F77F"  # alchemical symbols
        "\U0001F780-\U0001F7FF"  # Geometric Shapes Extended
        "\U0001F800-\U0001F8FF"  # Supplemental Arrows-C
        "\U0001F900-\U0001F9FF"  # Supplemental Symbols and Pictographs
        "\U0001FA00-\U0001FA6F"  # Chess Symbols
        "\U0001FA70-\U0001FAFF"  # Symbols and Pictographs Extended-A
        "\U00002702-\U000027B0"  # Dingbats
        "\U000024C2-\U0001F251"
        "]+",
        flags=re.UNICODE,
    )
    return re.sub(emoji_pattern, "", text)


def git_log(first_commit, last_commit, remove_emojis_flag):
    """Get the git log between two commits, excluding merge commits, and remove emojis."""
    cmd = [
        "git",
        "log",
        "--reverse",
        "--oneline",
        "--no-merges",
        "--format= -%s" if remove_emojis_flag else "--format= - %s",
        f"{first_commit}..{last_commit}",
    ]

    try:
        result = subprocess.run(cmd, capture_output=True, check=True, text=True)
        output = remove_emojis(result.stdout) if remove_emojis_flag else result.stdout
        return True, output
    except subprocess.CalledProcessError as e:
        error_message = (
            f"Could not get the git log between {first_commit} and {last_commit}:\n"
            f"{e.stderr}"
        )
        return False, error_message


def main():
    """Main function to parse arguments and generate git log"""
    args = parse_arguments()

    success, message = git_log(args.first_commit, args.last_commit, args.remove_emojis)

    if not success:
        print(message, file=sys.stderr)
        return 1

    print(message)
    return 0


if __name__ == "__main__":
    sys.exit(main())
