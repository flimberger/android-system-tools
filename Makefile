NAME=android-system-tools
VERSION=0.0.1
PUBLISHER=flimberger

TARGET=${NAME}-${VERSION}.vsix

VSCODE?=	code
VSCE?=	vsce

all: ${TARGET}

${TARGET}: syntaxes/blueprint.tmLanguage.json package.json
# This is a bit strange: using `vsce package` without the `--yarn`
# option wants to include the files from
# `node_modules/yo/generator-code` instead of my extension.
	${VSCE} package --yarn

install: ${TARGET}
	${VSCODE} --install-extension ${TARGET}

publish:
	${VSCE} publish --yarn

unpublish:
	${VSCE} unpublish ${PUBLISHER}.${NAME}

clean:
	rm -f ${TARGET}

.PHONY: all install publish unpublish clean
