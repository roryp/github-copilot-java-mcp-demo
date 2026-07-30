# Repository instructions

## Files and where copy lives

- `scripts/script.md` is the **published walkthrough**. It ships on `main` to both the fork and the microsoft repo, so it is viewer-facing: columns are `#`, `Where`, `Do`, `Paste`, with no narration, no intro or outro copy, and no recorder-facing notes.
- `scripts/script-narration.md` is the **presenter narration** and the golden source for spoken copy. Columns are `#`, `Say`, `Paste`. It is gitignored and exists only on the fork's `narration` branch.
- `scripts/elgato-prompter-intros-outros.txt` holds the intro and outro copy verbatim. It is gitignored and also lives only on the `narration` branch.
- Every rule below about `Say` cells, spoken voice, intros, and outros applies to `scripts/script-narration.md` and the prompter file. Rules about `Where`, `Do`, and `Paste` cells apply to `scripts/script.md`.
- Keep the published `scripts/script.md` stable and concise. Once an episode's video is out, prefer changes on the `narration` branch and only touch the published walkthrough when it is actually wrong.
- `Do` cells in the published walkthrough address a reader, not a camera operator. Use `find`, `read`, `check`, `watch`, or state the result as an observation. Never use `show`, `point to`, `point out`, or `highlight` except as part of a literal UI label such as **Show All Endpoints**.

## Branches and remotes

- `origin` is the fork (`roryp`). `upstream` and `microsoft` are two remote names for the same public repo, `microsoft/github-copilot-java-mcp-demo`.
- `main` carries `scripts/script.md` only, and must be identical on `origin/main`, `upstream/main`, and `microsoft/main`.
- `narration` is fork-only. It carries the published `scripts/script.md` plus the two presenter files, which are force-added with `git add -f` because `.gitignore` excludes them. Never push `narration` to `upstream` or `microsoft`.
- To publish a `scripts/script.md` change: commit on `main`, `git push origin main`, `git push upstream main`, then `git switch narration; git merge main; git push origin narration`.
- Before pushing to `upstream`, confirm the push is a fast-forward with `git merge-base --is-ancestor upstream/main origin/main`, and confirm `git diff --name-only upstream/main origin/main` lists no presenter file.
- Switching from `narration` to `main` deletes both presenter files from the working tree, because they are tracked only on `narration`. Restore them with `git restore --source=narration --worktree scripts/script-narration.md scripts/elgato-prompter-intros-outros.txt`, which does not stage them on `main`. Do not use `git checkout narration -- <path>`, which does.
- A gitignored file that is tracked on the current branch makes `git check-ignore -q` return non-zero. Use `git check-ignore --no-index -v` to confirm the ignore rule still exists.
- When something looks reverted on GitHub, check all four refs before concluding anything: `origin/main`, `origin/narration`, `upstream/main`, `microsoft/main`. Read the file itself with `git show <ref>:scripts/script.md` rather than trusting branch names.

## Writing rules

- Treat `scripts/script-narration.md` as the golden source for all spoken copy, and `scripts/script.md` as the golden source for the published steps.
- The `Say` column is the presenter's own voice, and the producer records it verbatim. `Where`, `Do`, and `Paste` are the published steps a reader follows.
- When a `Do` cell and its `Say` cell disagree, the `Say` cell has priority, so change the `Do` by default. The recorder can adapt what they point at, while the voice cannot move.
- That priority is not a licence to preserve a broken take. If a `Say` cell is factually wrong, names a control or result that does not exist, or describes something the demo will not actually produce on screen, fix the `Say` and call out what changed and why. Never leave narration in place that is guaranteed to fail on camera.
- A wrong or unofficial UI label is normally a `Do` problem. Put the exact product label in the `Do` cell and leave the plain-English description in the `Say` cell alone, unless that description names a control the viewer will not be able to find.
- A `Say` cell does not need to locate a surface that its own `Do` cell already locates.
- After any editing session on `scripts/script-narration.md`, confirm that no `Say` cell or `Paste` cell changed unless the user asked for that change, and do the same for the intro and outro paragraphs in `scripts/elgato-prompter-intros-outros.txt`. When comparing against a committed version in PowerShell, set both `[Console]::OutputEncoding` and `$OutputEncoding` to UTF-8 first, or every em dash and arrow will be reported as a false difference.
- Do not update intro or outro copy unless the user explicitly asks for that copy to change.
- When intro or outro copy changes, update `scripts/elgato-prompter-intros-outros.txt` in the same change and keep it verbatim.
- Make every video self-contained. Establish the app and relevant context within that video, never assume the viewer watched another episode, and do not add transitions between episodes unless the user explicitly requests them.
- Open the first demo row of every episode with the verbatim phrase `We'll start with the sample provided in the description,`.
- Follow that phrase with a `To follow along, ...` sentence naming what the viewer needs for that episode. That invitation is what licenses the shared `we'll` for the rest of the video, so include it once per episode and do not repeat it later.
- Explain every product, dependency, and view the first time each episode uses it, even when an earlier episode already explained it. Locate a surface on first use, for example the Spring Boot Dashboard as the Activity Bar view the Spring Boot Extension Pack adds.
- Use a short name such as `the Dashboard` or `in Chat` only after the full name has been spoken in that same episode. Check first use per episode, not per document.
- In demo tables, write the `Say` column as one continuous spoken narrative within that video. Each row should build on the result of the preceding action and naturally motivate the next action instead of reading like an isolated caption or a reset.
- Write every piece of spoken copy, including intros and outros, in a neutral training voice with no first-person singular. Never use `I`, `I'll`, `let me`, `my`, or `mine`.
- Use `we` and `let's` for the shared journey, `you` for viewer outcomes and advice, third person for product and concept explanations, and the imperative in `Do` cells.
- Never pair `we` or `let's` with a presenter-only verb such as `show`, `point out`, `highlight`, or `demonstrate`. A `we'll` action must be something the viewer can perform too, so prefer `find` or `look at`, or restate it in third person. `Do` cells keep the imperative form of those verbs.
- Keep recorder-facing vocabulary such as `prepared`, `the take`, or `earlier takes` out of `Say` cells, and out of the published walkthrough entirely.
- Never state the presenter's own environment as fact. Describe what is visible on screen instead, for example `it already shows as Installed here` rather than `mine says Installed`.
- If a step requires an arbitrary or account-specific value such as a subscription, tenant, or local path, frame it as a scenario before naming it so the viewer knows the value is illustrative.
- Spell product names in full in spoken copy, because the audience is beginners. Always say `Visual Studio Code`, never `VS Code`. The shorter form is acceptable only in recorder-facing text such as `Where` and `Do` cells and setup notes.
- Number every demo table row in a leading `#` column using `episode.step` (for example `2.5` is Episode 2, step 5).
- Give the published walkthrough's demo tables the columns `#`, `Where`, `Do`, `Paste`, in that order, and give the narration tables the columns `#`, `Say`, `Paste`. `Paste` is the far-right column in both.
- Put the exact copy-ready text for a step in its `Paste` cell. Use a single backticked value when there is one item, a `<br>`-separated bulleted list with short labels when there are several, and an em dash when the step needs no typed input.
- Keep `Paste` text verbatim with the wording used in the matching `Do` and `Say` cells, and never invent paste text for a step that does not type anything. The two documents share step numbers, so a `Paste` cell must be identical in both.
- `scripts/script.md` and `scripts/script-narration.md` are the only demo documents. Do not create or maintain a separate recording-steps file.
- Keep narration aligned with the real code path and recording order. Each line must be technically accurate and make sense when spoken with its corresponding `Do` action.
- Keep spoken sentences under about 40 words, and avoid two consecutive sentences that open with `We'll`. Announce a wait by naming it, for example `Startup takes a few seconds`.
- Do not read dotted configuration keys or fully qualified names aloud. Describe what the setting does in the `Say` cell and keep the exact string in the `Do` and `Paste` cells.
- Do not repeat the same four-word phrase in adjacent rows unless it is a UI location or a literal value the viewer types.
- After changing the opening clause of a cell, check that the next pronoun, relative pronoun, or definite article still points at the intended noun rather than at the last noun of the new clause.
- Verify a UI label before changing or flagging it. View ids, view order, titles, and `when` clauses come from the extension's `package.json`; VS Code's own labels live in both `out/vs/workbench/workbench.desktop.main.js` and `out/nls.messages.js`, so check both before concluding a label is wrong.
- Checking a `Do` cell against its `Say` cell cannot find an error the two columns share, so verify every UI label, view name, and step order against the product itself rather than against the other column.
- The Spring Boot Dashboard only reports the app as running, and only shows its **Properties** and **Memory** sections, when VS Code launched the process. Never check those against an app started from a terminal.
- Always shut the application down with the Dashboard's **Stop** action. Ending only the debug session leaves the Java process holding port 8080, so confirm the port is free afterwards.
- The Maven build and application startup both print expected warnings. Treat **`BUILD SUCCESS`** and the started message as the only success signals, and keep the walkthrough's **Expected warnings** note saying they are normal.
- Spring Boot Tools renders its inline URL hints against `127.0.0.1`, so never state the host in spoken copy; refer to `the root hint` instead.
- Captions must describe what a clean take actually produces. If an embedded screenshot came from an earlier run with extra data, say so in the caption rather than presenting the image as the expected result.
- When running the demo to verify something, free port 8080 first, stop everything you start, and leave the port free.
- Prefer VS Code features and UI workflows over terminal commands throughout this project. Use the terminal only when VS Code has no practical equivalent for the task.
- Keep video-facing MCP and browser verification focused on VS Code. Prefer Copilot Chat with configured MCP tools, and do not add raw protocol smoke-test scripts or advanced shell commands unless the user explicitly requests them.