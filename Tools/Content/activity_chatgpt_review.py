#!/usr/bin/python3

"""
This script is used to review modified activityor curriculum
YAML filesin a Git repository using OpenAI's GPT-4 model.
"""

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import io
import os
import sys
import subprocess
import argparse
import logging
import ruamel.yaml
from ruamel.yaml.error import YAMLError
from openai import OpenAI

# Define global variables
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
GITHUB_ENV_FILE = os.getenv("GITHUB_ENV")

# Configure YAML parser globally if the configuration doesn't need to be dynamic per file
yaml = ruamel.yaml.YAML(typ="rt")
yaml.indent(mapping=2, sequence=4, offset=2)
yaml.preserve_quotes = True
yaml.representer.add_representer(
    type(None),
    lambda dumper, data: dumper.represent_scalar("tag:yaml.org,2002:null", "null"),
)

# Setup basic logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def get_modified_files(content_type):
    """
    Get a list of modified files filtered by content type ('activity' or 'curriculum').

    Parameters:
    - content_type: The type of content to filter by ('activity' or 'curriculum').
    """
    # Define the file extension based on content_type
    file_extension = f".{content_type}.yml"

    try:
        # Run git diff command to get list of modified files
        result = subprocess.run(
            [
                "git",
                "diff",
                "--name-only",
                "-r",
                "HEAD^1",
                "HEAD",
                "--diff-filter=AMCR",
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=True,
        )

        # Filter the output by newlines and file extension to get a list of relevant files
        modified_files = [
            file
            for file in result.stdout.strip().split("\n")
            if file.endswith(file_extension)
        ]

        return modified_files
    except subprocess.CalledProcessError as e:
        print(f"Error running git diff: {e.stderr}")
        return []


def read_file_content(file_path):
    """
    Read and return the content of a file.
    """
    try:
        with open(file_path, "r") as file:
            return file.read()
    except Exception as e:
        logging.error(f"Error reading file {file_path}: {e}")
        return None


def read_yaml_data(file_path):
    """
    Reads and returns the 'l10n' section from a YAML file.

    :param file_path: Path to the YAML file to be read.
    :return: YAML string of the 'l10n' section if present, None otherwise.
    """
    try:
        with open(file_path, "r", encoding="utf8") as file:
            content = file.read()
    except IOError as e:
        logging.error(f"Error opening/reading file {file_path}: {e}")
        return None

    try:
        data = yaml.load(content)
    except YAMLError as e:
        logging.error(f"Error parsing YAML content from {file_path}: {e}")
        return None

    l10n_data = data.get("l10n")
    if l10n_data:
        stream = io.StringIO("")
        yaml.dump(l10n_data, stream)
        return stream.getvalue()

    return None


def review_files_with_gpt(prompt_template, files):
    """
    Review files using GPT based on the given prompt template.
    """
    client = OpenAI(api_key=OPENAI_API_KEY)
    responses = []
    for index, file_path in enumerate(files):
        file_content = read_yaml_data(file_path)
        if file_content:
            try:
                logging.info(f"Reviewing file {os.path.basename(file_path)}")
                response = client.chat.completions.create(
                    model="gpt-4-turbo-preview",
                    messages=[
                        {"role": "system", "content": prompt_template},
                        {"role": "user", "content": file_content},
                    ],
                    max_tokens=1024,
                    temperature=0.1,
                    top_p=1.0,
                    frequency_penalty=0.0,
                    presence_penalty=0.0,
                )
                response_text = response.choices[0].message.content.strip()
                responses.append(
                    (
                        f"## Activity Review {index + 1}\n\n"
                        "```\n"
                        f"{os.path.basename(file_path)}\n"
                        "```\n\n"
                        f"{response_text}"
                    )
                )
                logging.info(f"Reviewed file {os.path.basename(file_path)}")
            except Exception as e:
                logging.error(f"Error reviewing file {file_path} with GPT: {e}")

    formatted_files = "\n".join(f"- {os.path.basename(file)}" for file in files)
    review_text = (
        "## Files reviewed\n\n"
        "```\n"
        f"{formatted_files}\n"
        "```\n\n"
        f"{"\n\n".join(responses)}"
    )
    return review_text


def main():
    """Main function"""
    if not OPENAI_API_KEY or not GITHUB_ENV_FILE:
        logging.error(
            "Missing required environment variables: OPENAI_API_KEY and/or GITHUB_ENV"
        )
        return

    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description="Review modified YAML files in a Git repo using GPT."
    )
    parser.add_argument(
        "--content_type",
        choices=["activity", "curriculum"],
        required=True,
        help="Type of content to review ('activity' or 'curriculum')",
    )
    args = parser.parse_args()

    modified_files = get_modified_files(args.content_type)
    logging.info(f"Files to review: {modified_files}")

    # Read prompt template
    prompt_template_path = (
        f"Tools/Content/{args.content_type}_chatgpt_review_prompt.txt"
    )
    prompt_template = read_file_content(prompt_template_path)
    if prompt_template is None:
        logging.error(
            f"Missing or unable to read prompt template at {prompt_template_path}"
        )
        return

    combined_responses = review_files_with_gpt(prompt_template, modified_files)

    # Append responses to the GITHUB_ENV file
    try:
        with open(GITHUB_ENV_FILE, "a", encoding="utf8") as env:
            env.write(
                (
                    "CHATGPT_RESPONSES<<EOF_CHATGPT_RESPONSES\n"
                    f"{combined_responses}\n"
                    "EOF_CHATGPT_RESPONSES\n\n"
                )
            )
    except FileExistsError as e:
        logging.error(
            f"Error writing to GitHub environment file {GITHUB_ENV_FILE}: {e}"
        )


if __name__ == "__main__":
    sys.exit(main())
