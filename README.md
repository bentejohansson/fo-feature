# fo-feature

fo-feature is a feature toggle repository. It supplies information about what
features should be visible and enabled in frontend applications.

## Configuration

Modify the files in the [environments](environments/) directory to change
values for a specific environment. The files should have the name `<ENV>.json`,
where `ENV` is one of `p`, `t0`, `q0`, `t1`, `q1`, and so forth.

Commit and push to see your changes deployed.

## Usage

Build and deploy the Docker container. The API is available on port 80 inside
the container, and is available at the URI `/fo-feature`.

The environment is configured automatically by NAIS, using the environment
variable `FO_FEATURE_ENVIRONMENT`.
