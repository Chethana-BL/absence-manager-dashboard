# 🌿 Branching Strategy

This project follows a clear and consistent branch naming convention to keep collaboration structured and traceable.

| Prefix      | Purpose                                        | Example                          |
|-------------|------------------------------------------------|----------------------------------|
| `feature/`  | New user-facing features or major enhancements | `feature/filter-pagination`      |
| `fix/`      | Bug fixes or UI/UX corrections                 | `fix/disable-filter-on-loading`  |
| `chore/`    | Maintenance tasks (config, setup, dependencies)| `chore/makefile-check-task`      |
| `docs/`     | Documentation updates only                     | `docs/architecture-overview`     |
| `refactor/` | Code cleanup without changing behavior         | `refactor/extract-filter-widget` |
| `test/`     | Adding or improving tests                      | `test/absence-bloc-tests`        |

## 🔖 Guidelines

- Use **lowercase** branch names.
- Use **hyphens** to separate words.
- Be **descriptive** but concise.
- Prefix the branch with the appropriate type (`feature/`, `fix/`, etc.).

> ✅ Example: `feature/export-ical-support` or `test/filter-chip-widget-tests`
