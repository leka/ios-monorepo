#!/usr/bin/python3

# Leka - iOS Monorepo
# Copyright APF France handicap
# SPDX-License-Identifier: Apache-2.0

import os
import sys
import subprocess
import argparse
import logging
from openai import OpenAI


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
            ["git", "diff", "--name-only", "-r", "HEAD^1", "HEAD"],
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


def review_files_with_gpt(prompt_template, files):
    """
    Review files using GPT based on the given prompt template.
    """
    client = OpenAI(api_key=OPENAI_API_KEY)
    responses = []
    for file_path in files:
        file_content = read_file_content(file_path)
        if file_content:
            try:
                logging.info(f"Reviewing file {file_path}")
                response = client.chat.completions.create(
                    model="gpt-4-turbo-preview",
                    messages=[
                        {"role": "system", "content": prompt_template},
                        {"role": "user", "content": file_content},
                    ],
                    max_tokens=2048,
                    temperature=0.1,
                    top_p=1.0,
                    frequency_penalty=0.0,
                    presence_penalty=0.0,
                )
                response_text = response.choices[0].message.content.strip()
                responses.append(f"## Review for `{file_path}`:\n\n{response_text}")
                logging.info(f"Reviewed file {file_path}")
            except Exception as e:
                logging.error(f"Error reviewing file {file_path} with GPT: {e}")
    return "\n\n".join(responses)


def main():
    # Ensure necessary environment variables are set
    global OPENAI_API_KEY
    global GITHUB_ENV_FILE

    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
    GITHUB_ENV_FILE = os.getenv("GITHUB_ENV")
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
        with open(GITHUB_ENV_FILE, "a") as env:
            env.write(
                f"CHATGPT_RESPONSES<<EOF_CHATGPT_RESPONSES\n{combined_responses}\nEOF_CHATGPT_RESPONSES\n\n"
            )
    except Exception as e:
        logging.error(
            f"Error writing to GitHub environment file {GITHUB_ENV_FILE}: {e}"
        )


if __name__ == "__main__":
    sys.exit(main())
