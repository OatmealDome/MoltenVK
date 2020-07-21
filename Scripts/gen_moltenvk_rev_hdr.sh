#!/bin/bash

# Record the MoltenVK GIT revision as a derived header file suitable for including in a build
MVK_GIT_REV=$(git rev-parse HEAD)
MVK_HDR_FILE="${BUILT_PRODUCTS_DIR}/mvkGitRevDerived.h"
echo "// Auto-generated by MoltenVK" > "${MVK_HDR_FILE}"
echo "static const char* mvkRevString = \"${MVK_GIT_REV}\";" >> "${MVK_HDR_FILE}"

