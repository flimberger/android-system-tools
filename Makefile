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

SRCS=	src/extension.ts \
	src/formatter.ts

TARGET=	${NAME}-${VERSION}.vsix
OUTDIR=	out

NPM?=	npm
VSCODE?=	code
VSCE?=	vsce

all: ${TARGET}

compile: node_modules
	${NPM} run compile

node_modules: package.json
	${NPM} install .

${TARGET}: node_modules ${SRCS} package.json language-configuration.json syntaxes/blueprint.tmLanguage.json
	${VSCE} package

install: ${TARGET}
	${VSCODE} --install-extension ${TARGET}

publish:
	${VSCE} publish

unpublish:
	${VSCE} unpublish ${PUBLISHER}.${NAME}

clean:
	rm -f ${TARGET}
	rm -rf ${OUTDIR}

nuke: clean
	rm -rf node_modules

.PHONY: all compile install publish unpublish clean nuke
