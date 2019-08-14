# Copyright (c) 2019 Florian Limberger

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

NAME=	android-system-tools
VERSION=	0.0.2
PUBLISHER=	flimberger

TARGET=	${NAME}-${VERSION}.vsix

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
