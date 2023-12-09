# Leka - iOS Monorepo
# Copyright 2023 APF France handicap
# SPDX-License-Identifier: Apache-2.0

git_hooks:
	@echo "Installing pre-commit hooks..."
	@brew install pre-commit
	@pre-commit install
	@echo "Installing pre-commit hooks...✅"
