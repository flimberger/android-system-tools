/*
 * Copyright (c) 2019 Florian Limberger <flo@snakeoilproductions.net>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

'use strict';

import * as vscode from 'vscode';
import * as childproc from 'child_process';
import * as path from 'path';

export class Formatter implements vscode.DocumentFormattingEditProvider {

    public provideDocumentFormattingEdits(document: vscode.TextDocument, options: vscode.FormattingOptions, token: vscode.CancellationToken): vscode.ProviderResult<vscode.TextEdit[]> {
        return this.run(document).then(edits => edits, err => {
            if (err) {
                console.log(err);
                return Promise.reject('Failed to run bpfmt, check the console for errors');
            }
        });
    }

    private run(document: vscode.TextDocument): Thenable<vscode.TextEdit[]> {
        return new Promise<vscode.TextEdit[]>((resolve, reject) => {
            const cfg = vscode.workspace.getConfiguration('android_systools', vscode.window.activeTextEditor ? vscode.window.activeTextEditor.document.uri : null)['bpfmt'];
            let bpfmt: string = cfg['executable'];
            if (!bpfmt) {
                bpfmt = 'bpfmt';
            }
            let flags: string[] = cfg['flags'];
            if (flags) {
                // Remove the -w flag, as directly updating the file on disk would break undo.
                const widx = flags.indexOf('-w');
                if (widx > -1) {
                    flags.splice(widx, 1);
                }
            } else {
                flags = [];
            }

            let outbuf = '';
            let errbuf = '';

            const cwd = path.dirname(document.fileName);
            const p = childproc.spawn(bpfmt, flags, {cwd});
            p.stdout.setEncoding('utf8');
            p.stdout.on('data', data => outbuf += data);
            p.stderr.on('data', data => errbuf += data);
            p.on('error', err => {
                if (err && (<any>err).code == 'ENOENT') {
                    const err = `${bpfmt} not found`;
                    console.log(err);
                    return reject(err);
                }
            });
            p.on('close', code => {
                if (code !== 0) {
                    return reject(errbuf);
                }

                const start = new vscode.Position(0, 0);
                const end = document.lineAt(document.lineCount - 1).range.end;
                const edits = [new vscode.TextEdit(new vscode.Range(start, end), outbuf)];

                return resolve(edits);
            });
            if (p.pid) {
                p.stdin.end(document.getText());
            }
        });
    }
}
