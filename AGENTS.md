# AGENTS.md

Project: OFDM Rayleigh Channel Simulator
Agent workflow level: 1
Workflow type: lightweight subagent-ready workflow
Repository type: MATLAB simulation / wireless communications study code

## Research Scope

Small OFDM Rayleigh channel simulation study with transmitter, receiver, and BER calculation scripts.

## Operating Model

This repository is maintained with a coordinator/subagent workflow.

Roles:
- Coordinator: decomposes tasks, assigns focused agents, tracks state, and verifies completion.
- Implementer: makes small, focused code or documentation changes.
- Spec Reviewer: checks whether changes match the requested task and project scope.
- Quality Reviewer: checks style, safety, maintainability, and reproducibility.
- Verification Agent: checks MATLAB script consistency, smoke tests, and simulation outputs when applicable.
- Documentation Agent: updates `TODO.md`, `LOG.md`, `PROJECT_PATHS.md`, README notes, and plans/reviews.

## Repository Rules

- Specification first, implementation second, verification third.
- Do not delete or overwrite files unless explicitly approved.
- Create suffixed copies on conflicts.
- Do not commit, push, install packages, modify system configuration, or run long simulations without explicit approval.
- Keep raw data, large outputs, generated figures, and heavy simulation results out of git.
- Use Dropbox or project-data folders for large data and generated outputs.
- Record meaningful project-state changes in `LOG.md`.
- Keep `TODO.md` current when tasks are added, completed, blocked, or superseded.
- Keep `PROJECT_PATHS.md` current when important paths, commands, or data locations change.

## MATLAB Rules

- MATLAB code should be fully runnable.
- Use English comments, plot labels, legends, and output messages.
- Avoid MATLAB line continuation using `...` unless unavoidable.
- Preserve existing variable names unless a change is explicitly requested.
- Check output folders before writing files.
- Make `parfor` variables explicit when parallel code is used.
- Report elapsed time and completion status for simulations.
- Do not invent simulation results; report only measured or explicitly provided values.

## Verification Guidance

Prefer this order:

1. Static inspection of changed files.
2. Lightweight smoke test or syntax check.
3. Small-parameter simulation.
4. Full simulation only after explicit approval.

If no automated test exists, document the manual verification performed and the limitations.
