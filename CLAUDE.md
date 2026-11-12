# FSL Agentic DevOps Challenge — working rules

## Context
- Repo root contains the challenge harness; the app lives in `codebase/rdicidr-0.1.0/`
  (React CRA app, Dockerfile, nginx.conf, `.github/workflows/ci.yaml`, `terraform/`).
- The codebase has **seeded defects** in the CI pipeline and the Terraform config.
  The goal is to **find, explain and fix them** — not to redesign anything.
- Remote: `myrepo` (GitHub). Long-lived branches: `devel`, `stage`.

## How to work
- **Diagnose before editing.** For each defect state: what you observed (file:line or
  log output), the root cause, and the minimal fix. Then apply it.
- **Minimal, targeted changes.** Do not rewrite files, split Terraform into new files,
  add new features (OIDC, HTTPS, autoscaling, etc.) or upgrade toolchains unless a
  defect requires it. Keep diffs small so each fix is reviewable.
- **Prefer real CI feedback over local yak-shaving.** Push early, read the GitHub
  Actions logs (`gh run view --log-failed`), fix one failure per iteration.
- Keep a running list of defects found and fixed (in the PR description).

## Toolchain constraints
- The app requires **Node 15 / npm 7** (`engines` + `engine-strict=true` in `.npmrc`).
  Do not run npm on the host (Node 24). Run it in Docker:
  `docker run --rm -v "$PWD/codebase/rdicidr-0.1.0":/app -w /app node:15 <cmd>`
- `react-scripts@4` pins ESLint 7: any ESLint plugin must support ESLint 7.

## Git / branching rules
- All work on `feature/*` or `bugfix/*` branches created from `devel`.
- Merge into `devel` only via PR; only `devel` may be merged into `stage` (via PR).
- Never push directly to `devel` or `stage`. Never force-push shared branches.
- Small commits with descriptive messages (one defect per commit where practical).

## Part 1 — CI
Pipeline must run on PRs and execute in order, each job gated on the previous one:
install (`npm install`) → lint (`npm run lint`) → test (`CI=true npm run test`) →
build (`npm run build`). Needed evidence: one PR with a failed run, one with a passing run.

## Part 2 — Terraform / AWS
- Provision at least the `devel` environment (ECS Fargate + ALB + ECR) with isolated
  state per environment (`devel`, `stage`).
- Validate with `terraform fmt -check`, `terraform validate`, `terraform plan` before apply.
- Done means: ALB DNS URL serves the app publicly, ALB targets are healthy consistently,
  ECS service is stable (no task restarts).
- Never print or commit AWS credentials or secrets.

## Submission
- AI interaction logs go in `.chat-history/` at the repo root.
- Build the zip with `./generateZip.sh` (it verifies required contents).
